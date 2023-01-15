/**
 * 個人情報削除バッチ
 * @author t-ooshiro-bp
 * @since 2022/03/01
 */
public class OldDeletePersonalInfoBatch implements Database.Batchable<sObject> {
    /* オブジェクトAPI名 */
    private final String sObjectApiName;
    /* キー項目API名 */
    private final String keyItemApiName;
    /* 取引先ID */
    private final String accountId;
    /* マスキング項目マップ（項目API名：マスキング値） */
    private final Map<String, String> maskedItemMap;
    /* オブジェクト項目マップ */
    private final Map<String, Schema.SObjectField> fieldMap;
    /* 後続バッチ */
    public Database.Batchable<sObject> nextBatch;

    /**
     * コンストラクタ
     * @param sObjectApiName 
     * @param keyItemApiName 
     * @param accountId 
     * @param maskedItemMap 
     */
    public OldDeletePersonalInfoBatch(
        String sObjectApiName,
        String keyItemApiName,
        String accountId,
        Map<String, String> maskedItemMap
    ) {
        this.sObjectApiName = sObjectApiName;
        this.keyItemApiName = keyItemApiName;
        this.accountId = accountId;
        this.maskedItemMap = maskedItemMap;
        this.fieldMap =
            Schema.getGlobalDescribe().get(this.sObjectApiName).getDescribe().fields.getMap();
    }
    /**
     * 開始処理
     * @param context 
     * @return  `Database.QueryLocator`
     */
    public Database.QueryLocator start(Database.BatchableContext context){
        // SOQL文生成
        List<String> queries = new List<String>();
        queries.add('SELECT');
        queries.add('Id,' + String.join(new List<String>(this.maskedItemMap.keySet()), ','));
        queries.add('FROM');
        queries.add(String.escapeSingleQuotes(this.sObjectApiName));
        queries.add('WHERE');
        queries.add(String.escapeSingleQuotes(this.keyItemApiName));
        queries.add('=');
        queries.add('\'' + String.escapeSingleQuotes(this.accountId) + '\'');
        return Database.getQueryLocator(String.join(queries, ' '));
    }

    /**
     * バッチ処理
     * @param context 
     * @param scope 
     */
    public void execute(Database.BatchableContext context, List<SObject> records){
        List<SObject> updateTargets = new List<SObject>();
        // レコードマスキング処理
        for (SObject record : records) {
            updateTargets.add(this.maskedRecord(record));
        }
        // 更新
        update updateTargets;
    }

    /**
     * レコードマスキング処理
     * @param record 
     * @return  `SObject`
     */
    private SObject maskedRecord(SObject record) {
        for (String fieldName : this.maskedItemMap.keySet()) {
            String maskedValue = (String)this.maskedItemMap.get(fieldName);
            Schema.DisplayType dataType = this.fieldMap.get(fieldName).getDescribe().getType();
            if (String.isBlank(maskedValue)) {
                switch on dataType {
                    when BOOLEAN {
                        record.put(fieldName, false);
                    }
                    when else {
                        record.put(fieldName, null);
                    }
                }
            } else {
                switch on dataType {
                    when BOOLEAN {
                        record.put(fieldName, this.maskedBooleanValue(maskedValue));
                    }
                    when Date, DATETIME {
                        record.put(fieldName, this.maskedDateValue(maskedValue));
                    }
                    when CURRENCY, INTEGER, LONG, DOUBLE {
                        record.put(fieldName, this.maskedDecimalValue(maskedValue));
                    }
                    when else {
                        record.put(fieldName, maskedValue);
                    }
                }
            }
        }
        return record;
    }

    /**
     * 真偽型項目の型変換
     * @param maskedValue 
     * @return  `Boolean`
     */
    private Boolean maskedBooleanValue(String maskedValue) {
        return Boolean.valueOf(maskedValue);
    }

    /**
     * 日付型項目の型変換
     * @param maskedValue 
     * @return  `Date`
     */
    private Date maskedDateValue(String maskedValue) {
        try {
            return Date.valueOf(maskedValue);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 数値型項目の型変換
     * @param maskedValue 
     * @return  `Decimal`
     */
    private Decimal maskedDecimalValue(String maskedValue) {
        try {
            return Decimal.valueOf(maskedValue);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 終了処理
     * @param context 
     */
    public void finish(Database.BatchableContext context){
        // カスタム設定
        Masking__c masking = Masking__c.getOrgDefaults();
        // JOBのステータスを取得
        AsyncApexJob apexJob = [SELECT Status FROM AsyncApexJob WHERE Id = :context.getJobId()];

        // JOBが正常終了した場合
        if ('Completed'.equals(apexJob.Status)) {
            // 後続のバッチ起動がある場合
            if (this.nextBatch != null) {
                // 後続のバッチ起動
                Database.executeBatch(this.nextBatch);
            }
            // 後続のバッチ起動がない場合
            else {
                // ユーザに処理完了通知
                this.postFeed(masking.BatchCompletedMessage__c);
            }
        }
        // JOBが異常終了した場合
        else if ('Failed'.equals(apexJob.Status)) {
            // ユーザに異常終了通知
            this.postFeed(masking.BatchFailedMessage__c);
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

        //投稿先
        feedItemInput.subjectId = this.accountId;
        ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
    }
}