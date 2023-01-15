public class PhaseGateCreateRenewalTestData{
    public static List<Renewal__c> createData(){
        //セクションを作成
        Section__c section = new Section__c(
            Name = '更新チーム', //セクション名
            SectionId__c = '13' //セクションID
        );
        insert section;

        //取引先を作成
        List<Account> accountList= new List<Account>();
        // レコードタイプ（委託企業）取得
        RecordType recordTypeCompany = [
            SELECT Id
            FROM RecordType
            WHERE 
                SobjectType = 'Account' 
                AND Name = '委託企業' 
                AND IsActive = true
            LIMIT 1
        ];
        Account account1 = new Account(
            RecordTypeId = recordTypeCompany.id,//レコードタイプ
            AccountId__c = '334455', //取引先ID
            Name = 'フェーズゲートテスト取引先3',//取引先名
            RenewalTeam__c = section.id
        );
        accountList.add(account1);

        Account account2 = new Account(
            RecordTypeId = recordTypeCompany.id,//レコードタイプ
            AccountId__c = '445566', //取引先ID
            Name = 'フェーズゲートテスト取引先4',//取引先名
            RenewalTeam__c = section.id
        );
        accountList.add(account2);

        insert accountList;

        //取引先担当者を作成
        List<Contact> contactList = new List<Contact>();

        Contact contact1 = new Contact(
            LastName = 'フェーゲート取引先担当者1',//名前
            AccountId = account1.id //取引先ID
        );
        contactList.add(contact1);

        Contact contact2 = new Contact(
            LastName = 'フェーゲート取引先担当者2',//名前
            AccountId = account2.id //取引先ID
        );
        contactList.add(contact2);

        insert contactList;

        //フェーズゲートレコードを作成
        List<PhaseGate__c> phaseGateList = new List<PhaseGate__c>();
        PhaseGate__c phaseGate1 = new PhaseGate__c(
            Operation__c = 'Renewal__c',
            Stage__c = '条件確認中',
            Step__c = 2,
            Type__c = '必須項目',
            Field__c = 'NewContractTermEndDate__c',
            MandatoryFieldsErrorMessage__c = '必須項目です。入力してください。',
            AfterStageMandatoryFieldsErrorMessage__c =  '後フェーズでの必須項目です。入力しないでください。'
        );
        phaseGateList.add(phaseGate1);

        PhaseGate__c phaseGate2 = new PhaseGate__c(
            Operation__c = 'Renewal__c',
            Stage__c = '再査中',
            Step__c = 4,
            Type__c = '必須項目',
            Field__c = 'ReconfirmDate__c',
            MandatoryFieldsErrorMessage__c = '必須項目です。入力してください。',
            AfterStageMandatoryFieldsErrorMessage__c =  '後フェーズでの必須項目です。入力しないでください。'
        );
        phaseGateList.add(phaseGate2);

        insert phaseGateList;

        //更新レコードを作成
        List<Renewal__c> renewalList = new List<Renewal__c>();
        Renewal__c renewal1 = new Renewal__c(
            Stage__c = '条件確認中',
            Account__c = account1.id,//取引先
            ChargeTeam__c = section.id
           
        );
        renewalList.add(renewal1);

        Renewal__c renewal2 = new Renewal__c(
            Stage__c = '条件確認中',
            Account__c = account2.id ,//取引先
            ChargeTeam__c = section.id,
            NewContractTermEndDate__c = Date.valueOf('2022-08-17')
        );
        renewalList.add(renewal2);

        Renewal__c renewal3 = new Renewal__c(
            Stage__c = '条件確認中',
            Account__c = account2.id ,//取引先
            ChargeTeam__c = section.id,
            ReconfirmDate__c = Date.valueOf('2022-08-17')
        );
        renewalList.add(renewal3);

        insert renewalList;
        return renewalList;
    }
}