@isTest
public with sharing class RequestTraderDataFactory {
    public static Application__c application = new Application__c(); 
    public static NewMatter__c  newMatter = new NewMatter__c();
    public static List<Account> rquestTraders = new List<Account>();
    public static Account account = new Account();
    public static Contact resident = new Contact();


    public static void createRequestTraders(Id NewMatterId) {
        delete [SELECT ID FROM MediationRequest__c];
        Account account1 = new Account(
            Name = 'テスト（不動産会社）_101',
            AccountId__c = '92200001b',
            PriorityMediationContactMethod__c = 'メール'
        );
        Account account2 = new Account(
            Name = 'テスト（不動産会社）_102',
            AccountId__c = '92200002b',
            PriorityMediationContactMethod__c = 'Chatter'
        );
        Account account3 = new Account(
            Name = 'テスト（不動産会社）_103',
            AccountId__c = '92200003b',
            PriorityMediationContactMethod__c = 'FAX'
        );

        List<Account> createAccounts = new List<Account>();
        createAccounts.add(account1);
        createAccounts.add(account2);
        createAccounts.add(account3);
        insert createAccounts;

        List<MediationRequest__c> mediationRequests = new List<MediationRequest__c>();
        MediationRequest__c mediationRequest1 = new MediationRequest__c(
            RequestTraderId__c = account1.Id, // 依頼業者名
            NewMatterId__c = NewMatterId, // 新規ＩＤ
            ContractCategory__c = '依頼前' // 成約区分
        );
        MediationRequest__c mediationRequest2 = new MediationRequest__c(
            RequestTraderId__c = account2.Id, // 依頼業者名
            NewMatterId__c = NewMatterId, // 新規ＩＤ
            ContractCategory__c = '依頼前' // 成約区分
        );
        MediationRequest__c mediationRequest3 = new MediationRequest__c(
            RequestTraderId__c = account3.Id, // 依頼業者名
            NewMatterId__c = NewMatterId, // 新規ＩＤ
            ContractCategory__c = '依頼前' // 成約区分
        );
        mediationRequests.add(mediationRequest1);
        mediationRequests.add(mediationRequest2);
        mediationRequests.add(mediationRequest3);
        insert mediationRequests;
        rquestTraders = createAccounts;
    }

    public static void createAccountData(){
        // レコードタイプ（委託企業）取得
        RecordType recordTypeCompany = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Account' 
                AND Name = '委託企業' AND IsActive = true
            LIMIT 1
        ];

        //サービス新規
        ServiceContractNewMatter__c serviceContractNewMatter = new ServiceContractNewMatter__c(
            IsAutoCreateRecord__c = false,
            IsAutoMediationRequest__c = false
        );
        insert serviceContractNewMatter;


        Account createAccount = new Account(
            Name = 'テスト（企業）_001',
            AccountId__c = '91000001c',
            RecordTypeId = recordTypeCompany.Id,
            NotificationMethod__c = 'メール',
            ServiceContractNewMatter__c = serviceContractNewMatter.Id
        );
        insert createAccount;
        account = createAccount;

        CorporateHousingRegulation__c cR_1 = new CorporateHousingRegulation__c(
                Name = 'テスト（社宅規定）_001',
                Account__c = createAccount.Id,
                SelectionRule__c = '<p><span>XXXXXXXXXXXX</span></p>',
                SelectionCount__c = 4
            );

        Contact contact = new Contact(
            EmployeeNum__c = '400011',
            LastName = 'TESTCLASS（取引先担当者）_1001',
            AccountId = createAccount.Id,
            CorporateHousingRegulation__c = cR_1.Id,
            Email = 'ml-snt-sfdc@virtualex.co.jp'
        );
        resident = contact;
        
    }

    public static void createApplicationData(){
        Application__c createApplication = new Application__c(
            CompanyIdText__c = account.AccountId__c,
            ApplicantCodeText__c = resident.EmployeeNum__c,
            Account__c = account.Id,
            ApplicantCode__c = resident.Id,
            MediationRequest__c = false,
            DesiredAreaState__c = '神奈川県',
            DesiredAreaCity__c = null
        );
        insert createApplication;
        application = createApplication;
    }
}