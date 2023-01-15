public class PhaseGateCreateNewMatterTestData{
    public static List<NewMatter__c> createData(){
         //セクションを作成
        Section__c section = new Section__c(
            Name = '新規チーム', //セクション名
            SectionId__c = '12' //セクションID
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
            AccountId__c = '111222333', //取引先ID
            Name = 'フェーズゲートテスト取引先1',//取引先名
            NewMatterTeam__c = section.id //斡旋/新規チーム
        );
        accountList.add(account1);

        Account account2 = new Account(
            RecordTypeId = recordTypeCompany.id,//レコードタイプ
            AccountId__c = '222333444', //取引先ID
            Name = 'フェーズゲートテスト取引先2',//取引先名
            NewMatterTeam__c = section.id //斡旋/新規チーム
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
            Operation__c = 'NewMatter__c',
            Stage__c = '申請',
            Step__c = 1,
            Type__c = '必須項目',
            Field__c = 'ProjectImportantMatter__c',
            MandatoryFieldsErrorMessage__c = '必須項目です。入力してください。',
            AfterStageMandatoryFieldsErrorMessage__c =  '後フェーズでの必須項目です。入力しないでください。'
        );
        phaseGateList.add(phaseGate1);

        PhaseGate__c phaseGate2 = new PhaseGate__c(
            Operation__c = 'NewMatter__c',
            Stage__c = '申請確認中',
            Step__c = 2,
            Type__c = '必須項目',
            Field__c = 'ConfirmContent__c',
            MandatoryFieldsErrorMessage__c = '必須項目です。入力してください。',
            AfterStageMandatoryFieldsErrorMessage__c =  '後フェーズでの必須項目です。入力しないでください。'
        );
        phaseGateList.add(phaseGate2);

        insert phaseGateList;

        //新規レコードを作成
        List<NewMatter__c> newMatterList = new List<NewMatter__c>();
        NewMatter__c newMatter1 = new NewMatter__c(
            Stage__c = '申請',
            Application__c = application1.id,//申請
            Account__c = account1.id//取引先
           
        );
        newMatterList.add(newMatter1);

        NewMatter__c newMatter2 = new NewMatter__c(
            Stage__c = '申請',
            Application__c = application2.id,//申請
            Account__c = account2.id ,//取引先
            ProjectImportantMatter__c = 'a'
        );
        newMatterList.add(newMatter2);

        NewMatter__c newMatter3 = new NewMatter__c(
            Stage__c = '申請',
            Application__c = application2.id,//申請
            Account__c = account2.id ,//取引先
            ConfirmContent__c = 'a'
        );
        newMatterList.add(newMatter3);

        insert newMatterList;
        return newMatterList;
    }

     /**
     * @Description カスタム設定を作成
     */
    private static SyatakusanSetting__c createCustomSetting(){
        SyatakusanSetting__c customSetting = new SyatakusanSetting__c();
        customSetting.SystemUserId__c = '005O0000007fyxo';

        insert customSetting;
        return customSetting;
    }
}