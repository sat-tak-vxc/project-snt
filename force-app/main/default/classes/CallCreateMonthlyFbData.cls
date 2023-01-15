/**
 * @description        : 毎月支払用FBデータ作成呼び出しバッチ
 * @author             : h-nakata
**/
public class CallCreateMonthlyFbData implements Database.Batchable<sObject>, Database.Stateful {
    //取引先IDリスト
    public List<String> accountIds {get; set;}

    /**
    * @description 開始処理 対象データ抽出　
    * @author h-nakata
    * @param Database.BatchableContext BC 
    * @return Iterable 
    **/
    public Iterable<SObject> start(Database.BatchableContext BC) {
        this.accountIds = new List<String>();
        String fbDataCreateDate = String.valueOf(Date.today());
        //FBデータ作成日が今日日付の工程管理レコード取得
        String query = 'SELECT Account__c ';
        query += 'FROM ProcessControl__c ';
        query += 'WHERE FbDataCreateDate__c = ';
        query += fbDataCreateDate;
        //クエリロケーターを利用し、最大5000万件までレコード参照可能とする
        System.debug('---CallCreateMonthlyFbData---');
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
        for (SObject record : records) {
            ProcessControl__c processControl = (ProcessControl__c)record;
            //FBデータ作成実行対象の取引先IDをリストに追加
            this.accountIds.add(processControl.Account__c);
        }
    }
    /**
    * @description 終了処理 同バッチを再実行する
    * @author h-nakata
    * @param Database.BatchableContext BC 
    * @return void 
    **/
    public void finish(Database.BatchableContext BC) {
        if(!this.accountIds.isEmpty()){
            //取引先毎に毎月支払用FBデータ作成バッチを実行
            for(String account : this.accountIds){
                String batchName = 'CreateMonthlyFbData';
                CreateMonthlyFbData batch = new CreateMonthlyFbData();
                batch.accountId = account;
                //バッチサイズを取得
                Integer batchSize = ApexBatchUtils.getBatchSize(batchName);
                Database.executeBatch(batch, batchSize);
            }
        }
    }
}