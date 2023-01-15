/**
 * @description        : ユーザマスキング
 * @author             : h-nakata
**/
public class DeletePersonalInfoUserMasking implements Database.Batchable<sObject> {
    //取引先ID
    public String accountId {get; set;}

    /**
    * @description 開始処理 対象データ抽出　
    * @author h-nakata
    * @param Database.BatchableContext BC 
    * @return Iterable 
    **/
    public Iterable<SObject> start(Database.BatchableContext BC) {
        String accountId = this.accountId;
        //マスキング対象のユーザレコード取得
        String query = 'SELECT Id, ';
        query += 'LastName, ';
        query += 'FirstName, ';
        query += 'Alias, ';
        query += 'Email, ';
        query += 'Username, ';
        query += 'CommunityNickname, ';
        query += 'IsActive, ';
        query += 'ContactId ';
        query += 'FROM User ';
        query += 'WHERE Contact.AccountId__c = \'';
        query += accountId;
        query += '\'';
        //クエリロケーターを利用し、最大5000万件までレコード参照可能とする
        System.debug('---DeletePersonalInfoUserMasking---');
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
        //カスタム設定
        Masking__c masking = Masking__c.getOrgDefaults();
        for (SObject record : records) {
            User user = (User)record;
            //姓
            user.LastName = masking.LastName__c;
            //名
            user.FirstName = masking.FirstName__c;
            //別名
            user.Alias = masking.Alias__c;
            //メール
            user.Email = masking.Email__c;
            //ユーザ名
            user.Username = masking.Username__c;
            //ニックネーム
            user.CommunityNickname = masking.CommunityNickname__c;
            // //有効
            // user.IsActive = FALSE;
            // //取引先責任者
            // user.ContactId = NULL;
        }
        //ユーザUpdate
        Update records;

    }
    /**
    * @description 終了処理
    * @author h-nakata
    * @param Database.BatchableContext BC 
    * @return void 
    **/
    public void finish(Database.BatchableContext BC) {
        //カスタマーポータル取引先無効化
        String updateAccountId = this.accountId;
        List<Account> updateAccounts = [SELECT Id, IsCustomerPortal FROM Account WHERE AccountId__c = :updateAccountId AND IsCustomerPortal = TRUE];
        If(!updateAccounts.isEmpty()){
            for(Account updateAccount : updateAccounts){
                updateAccount.IsCustomerPortal = FALSE;
            }
            Update updateAccounts;
        }
        // カスタムメタデータ型：削除対象オブジェクト取得
        List<PersonalInfoDeleteTarget__mdt> deleteTargets = [
            SELECT SObjectApiName__c
            FROM PersonalInfoDeleteTarget__mdt
            WHERE IsActive__c = TRUE
        ];
        List<String> deleteTargetObjects = new List<String>();
        for(PersonalInfoDeleteTarget__mdt deleteTarget : deleteTargets){
            deleteTargetObjects.add(deleteTarget.SObjectApiName__c);
        }
        //個人情報削除バッチ
        String batchName = 'DeletePersonalInfoBatch';
        DeletePersonalInfoBatch batch = new DeletePersonalInfoBatch();
        batch.accountId = accountId;
        batch.deleteTargetObjects = deleteTargetObjects;
        batch.count = 0;
        //バッチサイズを取得
        Integer batchSize = ApexBatchUtils.getBatchSize(batchName);
        Database.executeBatch(batch, batchSize);
    }
}