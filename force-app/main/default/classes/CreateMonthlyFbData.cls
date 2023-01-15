/**
 * @description        : 毎月支払用FBデータ作成バッチ
 * @author             : h-nakata
**/
public class CreateMonthlyFbData implements Database.Batchable<sObject>, Database.Stateful {
    //取引先ID
    public String accountId {get; set;}
    //FBデータIDリスト
    public List<String> fbDataIds {get; set;}
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
        //しゃたくさん設定取得
        SyatakusanSetting__c syatakusanSetting = SyatakusanSetting__c.getOrgDefaults();
        //毎月支払用FBデータ作成対象の支払区分を取得
        String paymentCategoryCreateMonthlyPaymentFbData = syatakusanSetting.PaymentCategoryNotCreateSpotFbData__c;
        //処理対象の支払レコード取得(2000件)
        String query = 'SELECT BankAccount__c, AccountingTicketType__r.PaymentCategory__c, ';
        query += 'TransfererAccountContractor__c, ';
        query += 'RemittanceDate__c, ';
        query += 'RentId__r.RealEstateName__r.Account__r.TransfererAccount__r.BankCode__c, ';
        query += 'RentId__r.RealEstateName__r.Account__r.TransfererAccount__r.BankKana__c, ';
        query += 'RentId__r.RealEstateName__r.Account__r.TransfererAccount__r.BranchOfficeCode__c, ';
        query += 'RentId__r.RealEstateName__r.Account__r.TransfererAccount__r.BranchOfficeKana__c, ';
        query += 'RentId__r.RealEstateName__r.Account__r.TransfererAccount__r.DepositTypeForFbData__c, ';
        query += 'RentId__r.RealEstateName__r.Account__r.TransfererAccount__r.Name, ';
        query += 'RentId__r.RealEstateName__r.Account__r.TransfererAccount__r.ContractorKana__c, ';
        query += 'BankAccount__r.BankCode__c, ';
        query += 'BankAccount__r.BankKana__c, ';
        query += 'BankAccount__r.BranchOfficeCode__c, ';
        query += 'BankAccount__r.BranchOfficeKana__c, ';
        query += 'BankAccount__r.DepositTypeForFbData__c, ';
        query += 'BankAccount__r.Name, ';
        query += 'BankAccount__r.ContractorKana__c, ';
        query += 'BankAccount__r.CustomerCode1__c, ';
        query += 'BankAccount__r.CustomerCode2__c, ';
        query += 'TotalAmount_PaymentTarget__c, ';
        query += 'FBDataName__c ';
        query += 'FROM Payment__c ';
        query += 'WHERE RentId__r.RealEstateName__r.Account__c = \'';
        query += this.accountId;
        query += '\' AND FBDataName__c = NULL ';
        query += ' AND AccountingTicketType__r.PaymentCategory__c = \'';
        query += paymentCategoryCreateMonthlyPaymentFbData;
        query += '\' ORDER BY RemittanceDate__c,BankAccount__c';
        query += ' LIMIT 2000';
        //クエリロケーターを利用し、最大5000万件までレコード参照可能とする
        System.debug('---CreateMonthlyFbData---');
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
        Boolean isSpotFb = FALSE;
        Date remittanceDate;
        if(this.fbDataIds == NULL){
            this.fbDataIds = new List<String>();
        }
        //FBデータを作成し、作成したFBデータのIDをリストに追加
        this.fbDataIds.addAll(CreateFbData.CreateFbData(records, remittanceDate, this.fbDataIds, isSpotFb));
    }
    /**
    * @description 終了処理 同バッチを再実行する
    * @author h-nakata
    * @param Database.BatchableContext BC 
    * @return void 
    **/
    public void finish(Database.BatchableContext BC) {
        if(!this.isEnd){
            //毎月支払用FBデータ作成バッチを再実行
            String batchName = 'CreateMonthlyFbData';
            CreateMonthlyFbData batch = new CreateMonthlyFbData();
            batch.accountId = this.accountId;
            batch.fbDataIds = this.fbDataIds;
            //バッチサイズを取得
            Integer batchSize = ApexBatchUtils.getBatchSize(batchName);
            Database.executeBatch(batch, batchSize);
        }
    }
}