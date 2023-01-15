public class PhaseGateCreateConditionChangeTestData{
    public static List<ConditionChange__c> createData(){
        //セクションを作成
        Section__c section = new Section__c(
            Name = '条件変更チーム', //セクション名
            SectionId__c = '14' //セクションID
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
            AccountId__c = '556677', //取引先ID
            Name = 'フェーズゲートテスト取引先5',//取引先名
            ConditionChangeTeam__c = section.id //条件変更チーム
        );
        accountList.add(account1);

        Account account2 = new Account(
            RecordTypeId = recordTypeCompany.id,//レコードタイプ
            AccountId__c = '667788', //取引先ID
            Name = 'フェーズゲートテスト取引先6',//取引先名
            ConditionChangeTeam__c = section.id //条件変更チーム
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

        //申請レコードを作成
        List<Application__c> applicationList = new List<Application__c>();
        Application__c application1 = new Application__c(
            Account__c = account1.id,//申請
            ApplicantCode__c = contact1.id
        );
        applicationList.add(application1);

        Application__c application2 = new Application__c(
            Account__c = account2.id,//申請
            ApplicantCode__c = contact2.id
        );
        applicationList.add(application2);

        insert applicationList;

        //フェーズゲートレコードを作成
        List<PhaseGate__c> phaseGateList = new List<PhaseGate__c>();
        PhaseGate__c phaseGate1 = new PhaseGate__c(
            Operation__c = 'ConditionChange__c',
            Stage__c = '条件確認/調整',
            Step__c = 2,
            Type__c = '必須項目',
            Field__c = 'RequestDate__c	',
            MandatoryFieldsErrorMessage__c = '必須項目です。入力してください。',
            AfterStageMandatoryFieldsErrorMessage__c =  '後フェーズでの必須項目です。入力しないでください。'
        );
        phaseGateList.add(phaseGate1);

        PhaseGate__c phaseGate2 = new PhaseGate__c(
            Operation__c = 'ConditionChange__c',
            Stage__c = '再査中',
            Step__c = 3,
            Type__c = '必須項目',
            Field__c = 'ReconfirmDate__c',
            MandatoryFieldsErrorMessage__c = '必須項目です。入力してください。',
            AfterStageMandatoryFieldsErrorMessage__c =  '後フェーズでの必須項目です。入力しないでください。'
        );
        phaseGateList.add(phaseGate2);

        insert phaseGateList;

        //条件変更レコードを作成
        List<ConditionChange__c> conditionChangeList = new List<ConditionChange__c>();
        ConditionChange__c conditionChange1 = new ConditionChange__c(
            Stage__c = '条件確認/調整',
            Account__c = account1.id//取引先
           
        );
        conditionChangeList.add(conditionChange1);

        ConditionChange__c conditionChange2 = new ConditionChange__c(
            Stage__c = '条件確認/調整',
            Account__c = account2.id ,//取引先
            RequestDate__c = Date.valueOf('2022-08-17')
        );
        conditionChangeList.add(conditionChange2);

        ConditionChange__c conditionChange3 = new ConditionChange__c(
            Stage__c = '条件確認/調整',
            Account__c = account2.id ,//取引先
            ReconfirmDate__c = Date.valueOf('2022-08-17')
        );
        conditionChangeList.add(conditionChange3);

        insert conditionChangeList;
        return conditionChangeList;
        
    }
}