/**
 * @description        : スポットFBデータ作成バッチ
 * @author             : h-nakata
**/
public class CreateSpotFbData implements Database.Batchable<sObject>, Database.Stateful {
    //送金日
    public Date remittanceDate {get; set;}
    //FBデータレコードIDリスト
    public List<String> fbDataIds {get; set;}
    //フロー実行ユーザ
    public String executionUser {get; set;}
    //終了フラグ
    public Boolean isEnd {get; set;}

    /**
    * @description 初期処理 対象データ抽出　
    * @author h-nakata
    * @param Database.BatchableContext BC 
    * @return Iterable 
    **/
    public Iterable<SObject> start(Database.BatchableContext BC) {
        this.isEnd = TRUE;
        //しゃたくさん設定取得
        SyatakusanSetting__c syatakusanSetting = SyatakusanSetting__c.getOrgDefaults();
        //スポットFBデータ作成対象外の支払区分を取得
        String paymentCategoryNotCreateSpotFbData = syatakusanSetting.PaymentCategoryNotCreateSpotFbData__c;
        //処理対象の支払レコード取得(2000件)
        String query = 'SELECT BankAccount__c, AccountingTicketType__r.PaymentCategory__c, ';
        query += 'TransfererAccountContractor__c, ';
        query += 'RemittanceDate__c, ';
        query += 'BankAccount__r.BankCode__c, ';
        query += 'BankAccount__r.BankKana__c, ';
        query += 'BankAccount__r.BranchOfficeCode__c, ';
        query += 'BankAccount__r.BranchOfficeKana__c, ';
        query += 'BankAccount__r.DepositTypeForFbData__c, ';
        query += 'BankAccount__r.Name, ';
        query += 'BankAccount__r.ContractorKana__c, ';
        query += 'BankAccount__r.CustomerCode1__c, ';
        query += 'BankAccount__r.CustomerCode2__c, ';
        query += 'IsTransferFeeSubtract__c, ';
        query += 'TotalAmount_PaymentTarget__c, ';
        query += 'FBDataName__c ';
        query += 'FROM Payment__c ';
        query += 'WHERE RemittanceDate__c = ';
        query += String.valueOf(this.remittanceDate);
        query += ' AND FBDataName__c = NULL ';
        query += ' AND AccountingTicketType__r.PaymentCategory__c != \'';
        query += paymentCategoryNotCreateSpotFbData;
        query += '\' ORDER BY RemittanceDate__c,BankAccount__c';
        query += ' LIMIT 2000';
        //クエリロケーターを利用し、最大5000万件までレコード参照可能とする
        System.debug('---CreateSpotFbData---');
        System.debug('start query: ' + query);
        return Database.getQueryLocator(query);
    }
    /**
    * @description 処理実行
    * @author h-nakata
    * @param Database.BatchableContext BC 
    * @param List<SObject> records 
    * @return void 
    **/
    public void execute(Database.BatchableContext BC, List<SObject> records) {
        this.isEnd = FALSE;
        Boolean isSpotFb = TRUE;
        if(this.fbDataIds == NULL){
            this.fbDataIds = new List<String>();
        }
        //FBデータを作成し、作成したFBデータのIDをリストに追加
        this.fbDataIds.addAll(CreateFbData.CreateFbData(records, this.remittanceDate, this.fbDataIds, isSpotFb));
    }
    /**
    * @description 終了処理 同バッチを再実行する/カスタム通知送信
    * @author h-nakata
    * @param Database.BatchableContext BC 
    * @return void 
    **/
    public void finish(Database.BatchableContext BC) {
        if(!this.isEnd){
            //スポットFBデータ作成バッチを再実行
            String batchName = 'CreateSpotFbData';
            CreateSpotFbData batch = new CreateSpotFbData();
            batch.remittanceDate = this.remittanceDate;
            batch.executionUser = this.executionUser;
            batch.fbDataIds = this.fbDataIds;
            //バッチサイズを取得
            Integer batchSize = ApexBatchUtils.getBatchSize(batchName);
            Database.executeBatch(batch, batchSize);
        } else {
            //カスタム通知送信
            Set<String> executionUserIds = new Set<String>();
            executionUserIds.add(this.executionUser);
            CreateFbDataCustomNotification.notifyUsers(executionUserIds);
        }
    }
}