/**
 * @description        : 個人情報削除バッチ
 * @author             : h-nakata
**/
public class DeletePersonalInfoBatch implements Database.Batchable<sObject>, Database.Stateful {
    //取引先ID
    public String accountId {get; set;}
    //削除対象オブジェクト
    public List<String> deleteTargetObjects {get; set;}
    //カウント
    public Integer count {get; set;}
    //終了フラグ
    public Boolean isEnd {get; set;}

    /**
    * @description 開始処理 対象データ抽出　
    * @author h-nakata
    * @param Database.BatchableContext BC 
    * @return Iterable 
    **/
    public Iterable<SObject> start(Database.BatchableContext BC) {
        this.isEnd = TRUE;
        Integer listCount = this.count;
        String accountId = this.accountId;
        String sObjectApiName = this.deleteTargetObjects.get(listCount);
        //削除対象オブジェクトのレコード取得(50000件)
        String query = 'SELECT Id ';
        query += 'FROM ';
        query += sObjectApiName;
        query += ' WHERE AccountId__c = \'';
        query += accountId;
        query += '\' LIMIT 50000';
        //クエリロケーターを利用し、最大5000万件までレコード参照可能とする
        System.debug('---DeletePersonalInfoBatch---');
        System.debug('start query: ' + query);
        return Database.getQueryLocator(query);
    }
    /**
    * @description 実行処理
    * @author h-nakata
    * @param Database.BatchableContext BC 
    * @param List<SObject> records 
    * @return void 
    **/
    public void execute(Database.BatchableContext BC, List<SObject> records) {
        this.isEnd = FALSE;
        List<Id> recordIds = new List<Id>();
        for(SObject record : records){
            recordIds.add(record.Id);
        }
        //ファイル取得
        List<ContentDocumentLink> deleteDocumentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN :recordIds LIMIT 2000];
        //ToDo取得
        List<Task> deleteTasks = [SELECT Id FROM Task WHERE WhatId IN :recordIds LIMIT 2000];
        //Chatterコメント取得
        List<FeedComment> deleteFeedComments = [SELECT Id FROM FeedComment WHERE ParentId IN :recordIds LIMIT 2000];
        //Chatter投稿取得
        List<FeedItem> deleteFeedItems = [SELECT Id FROM FeedItem WHERE ParentId IN :recordIds LIMIT 2000];
        If(!deleteDocumentLinks.isEmpty()){
            List<Id> contentDocumentIds = new List<Id>();
            for(ContentDocumentLink documentLink : deleteDocumentLinks){
                contentDocumentIds.add(documentLink.ContentDocumentId);
            }
            List<ContentDocument> deleteContentDocuments = [SELECT Id FROM ContentDocument WHERE Id IN :contentDocumentIds];
            //ファイル削除
            Delete deleteContentDocuments;
            Database.emptyRecycleBin(deleteContentDocuments);
        } else if (!deleteTasks.isEmpty()){
            //ToDo削除
            Delete deleteTasks;
            Database.emptyRecycleBin(deleteTasks);
        } else if (!deleteFeedComments.isEmpty()){
            //Chatterコメント削除
            Delete deleteFeedComments;
            Database.emptyRecycleBin(deleteFeedComments);
        } else if (!deleteFeedItems.isEmpty()){
            //Chatter投稿削除
            Delete deleteFeedItems;
            Database.emptyRecycleBin(deleteFeedItems);
        }else {
            //レコード削除
            Delete records;
            Database.emptyRecycleBin(records);
        }
    }
    /**
    * @description 終了処理 同バッチを再実行する
    * @author h-nakata
    * @param Database.BatchableContext BC 
    * @return void 
    **/
    public void finish(Database.BatchableContext BC) {
        if(!this.isEnd){
            //個人情報削除バッチを再実行(削除対象：同オブジェクト)
            String batchName = 'DeletePersonalInfoBatch';
            DeletePersonalInfoBatch batch = new DeletePersonalInfoBatch();
            batch.accountId = this.accountId;
            batch.deleteTargetObjects = this.deleteTargetObjects;
            batch.count = this.count;
            //バッチサイズを取得
            Integer batchSize = ApexBatchUtils.getBatchSize(batchName);
            Database.executeBatch(batch, batchSize);
        } else if(this.deleteTargetObjects.size() != this.count + 1){
            //個人情報削除バッチを再実行(削除対象：次のオブジェクト)
            String batchName = 'DeletePersonalInfoBatch';
            DeletePersonalInfoBatch batch = new DeletePersonalInfoBatch();
            batch.accountId = this.accountId;
            batch.deleteTargetObjects = this.deleteTargetObjects;
            batch.count = this.count + 1;
            //バッチサイズを取得
            Integer batchSize = ApexBatchUtils.getBatchSize(batchName);
            Database.executeBatch(batch, batchSize);
        } else {
            //取引先削除
            String deleteAccountId = this.accountId;
            List<Account> deleteAccounts = [SELECT Id FROM Account WHERE AccountId__c = :deleteAccountId];
            Delete deleteAccounts;
            // カスタム設定
            Masking__c masking = Masking__c.getOrgDefaults();
            // ユーザに処理完了通知
            this.postFeed(masking.BatchCompletedMessage__c);
        }
    }
    /**
     * Chatter投稿
     * @param messages 
     */
    private void postFeed(String message) {
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        //メンション先
        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        mentionSegmentInput.id = UserInfo.getUserId();
        messageBodyInput.messageSegments.add(mentionSegmentInput);

        //本文
        ConnectApi.TextSegmentInput newlineSegmentInput = new ConnectApi.TextSegmentInput();
        newlineSegmentInput.text = '\n';
        messageBodyInput.messageSegments.add(newlineSegmentInput);
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = message;
        messageBodyInput.messageSegments.add(textSegmentInput);

        feedItemInput.body = messageBodyInput;

        // //投稿先
        // feedItemInput.subjectId = this.accountId;
        // ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
    }
}