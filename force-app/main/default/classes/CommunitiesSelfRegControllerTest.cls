/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
@IsTest 
public with sharing class CommunitiesSelfRegControllerTest {
    


    /**
     * @Description テストレコード作成
     */
    /*
    @testSetup
    static void setup() {
        CommunitiesSelfRegTestDataFactory.createUserRegistration();
        CommunitiesSelfRegTestDataFactory.createSyatakusanSetting();

        // 取引先
        List<Account>  accounts = new List<Account>();
        Account account_1 = new Account(
            AccountId__c = 'test_self_reg_a_01',
            Name = 'test（委託企業）_001',
            RecordTypeId = '012O0000000YiuJIAS'
        );
        accounts.add(account_1);
        Account account_2 = new Account(
            AccountId__c = 'test_self_reg_r_01',
            Name = 'test（不動産）_001',
            RecordTypeId = '012O0000000YiuTIAS'
        );
        accounts.add(account_2);
        Account account_3 = new Account(
            AccountId__c = 'test_self_reg_m_01',
            Name = 'test（引越）_001',
            RecordTypeId = '012O0000000YiuOIAS'
        );
        accounts.add(account_3);
        insert accounts;

        
        // 取引先担当者
        List<Contact>  contacts = new List<Contact>();
        Contact contact_1 = new Contact(
            LastName = 'test（委託企業）_001_社宅担当者_01',
            AccountId = account_1.Id,
            RecordTypeId = '012O0000000Yvv5IAC',
            Email = 'xxxxxxxx@invalid.com'
        );
        Contact contact_2 = new Contact(
            LastName = 'test_self_reg_a_01_ln',
            FirstName = 'fn',
            AccountId = account_1.Id,
            RecordTypeId = '012O0000000Yvv0IAC',
            Email = 'xxxxxxxx@invalid.com'
        );
        contacts.add(contact_1);
        insert contacts;


    }
    */

    /**
     * @Description ユーザ登録（委託企業）
     */
    /*
    @isTest
    static void testCommunitiesSelfReg_001() {
        
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.accountId = 'test_self_reg_a_01';
        controller.communityUsername = 'testPortal';
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        controller.phone = '09001010101';
        controller.password = 'Password0099';
        controller.confirmPassword = 'Password0099';

        System.assert(controller.registerUser() == null);
    }

    */
    /**
     * @Description ユーザ登録（不動産）
     */
    /*
    @isTest
    static void testCommunitiesSelfReg_002() {
        
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.accountId = 'test_self_reg_r_01';
        controller.communityUsername = 'testPortal';
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        controller.phone = '09001010101';
        controller.password = 'Password0099';
        controller.confirmPassword = 'Password0099';

        System.assert(controller.registerUser() == null);
    }
    */

    /**
     * @Description ユーザ登録（引越レコードタイプ取引先登録エラー）
     */
    /*
    @isTest
    static void testCommunitiesSelfReg_003_E() {
        
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.accountId = 'test_self_reg_m_01';
        controller.communityUsername = 'testPortal';
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        controller.phone = '09001010101';
        controller.password = 'Password0099';
        controller.confirmPassword = 'Password0099';

        System.assert(controller.registerUser() == null);
    }
    */

    /**
     * @Description ユーザ登録（必須チェックエラー）
     */
    /*
    @isTest
    static void testCommunitiesSelfRegRequired_E() {
        
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        System.assert(controller.registerUser() == null);
    }

    */
    /**
     * @Description ユーザ登録（パスワード不一致エラー）
     */
    /*
    @isTest
    static void testCommunitiesSelfRegValidPassword_E() {
        
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.accountId = 'test_self_reg_a_01';
        controller.communityUsername = 'testPortal';
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        controller.phone = '09001010101';
        controller.password = 'Password0099';
        controller.confirmPassword = 'xxx';

        System.assert(controller.registerUser() == null);
    }
    */
    /**
     * @Description ユーザ登録（関連取引先情報なし）
     */
    /*
    @isTest
    static void testCommunitiesSelfRegAccountIsEmpty() {
        
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.accountId = 'xxxxxx000000000000';
        controller.communityUsername = 'testPortal';
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        controller.phone = '09001010101';
        controller.password = 'Password0099';
        controller.confirmPassword = 'Password0099';

        System.assert(controller.registerUser() == null);
    }
    */
    /**
     * @Description ユーザ登録後処理確認
     */
    /*
    @IsTest
    public static void testCreateUserAfterProcess() {
        // カスタム設定
        UserRegistration__c urSettingInfo = 
            UserRegistration__c.getOrgDefaults();

        String accountId = 'test_self_reg_a_01';
        String userId = '005O0000007iadvIAA';
        String password = 'Password0099';

        Map<String, RecordType> recordTypeContacts = 
            CommunitiesSelfRegModel.getRecordTypeContacts(urSettingInfo);
        String contractRecordType = 
            recordTypeContacts.get(urSettingInfo.RecordTypeContactAccount__c).Id;

        List<Account> account = CommunitiesSelfRegModel.getAccount(accountId);

        try {
            User userReg = CommunitiesSelfRegModel.getUser(userId);

            Contact contacInfo = new Contact();
            contacInfo.Id = userReg.ContactId;
            contacInfo.RecordTypeId = contractRecordType;

            CommunitiesSelfRegModel.updateContact(contacInfo);

            List<String> contactSendEmails = CommunitiesSelfRegModel.getContactSendEmail(
                account.get(0).Id, 
                recordTypeContacts.get(
                    urSettingInfo.RecordTypeContactCompanyStaff__c).Id);

            CommunitiesSelfRegUtils.sendEmailContactCompanyStaff(
                urSettingInfo, userReg, password, accountId, contactSendEmails);

        } catch (Exception e) {
            System.assert(false);
            return;
        }
        System.assert(true);
    }    
    */

    
}