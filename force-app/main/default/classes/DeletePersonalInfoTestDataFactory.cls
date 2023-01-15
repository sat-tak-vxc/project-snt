/**
 * 
 * @author 
 * @since 
 */
@isTest
public class DeletePersonalInfoTestDataFactory {

    /**
     * @Description テストレコード作成
     * @return `List<Account>`
     */
    public static void createAccount_Mass_TraderSelection(
        Integer processNum,
        String notificationMethod
    ) {
        UserRole userRole_1 = [
            SELECT Id
            FROM UserRole
            WHERE PortalType = 'None'
            LIMIT 1
        ];
        Profile profile_1 = [
            SELECT Id
            FROM Profile
            WHERE Name = 'システム管理者'
        ];
        User user_1 = new User(
            Email = 'deletePersonalInfo_001@test.com',
            UserRoleId = userRole_1.Id,
            ProfileId = profile_1.Id,
            Username = 'deletePersonalInfo_001@test.com',
            Alias = 'テスト０１',
            TimeZoneSidKey='Asia/Tokyo',
            EmailEncodingKey='UTF-8',
            LocaleSidKey='ja_JP',
            LanguageLocaleKey='ja',
            LastName = 'テスト０１'
        );
        System.runAs(user_1) {
        // ↓↓↓ ここから

        // 地区
        List<District__c>  districtList = new List<District__c>();

        District__c district_1 = new District__c(
            State__c = '神奈川県',
            City__c = '',
            IsAllCity__c = true
        );
        districtList.add(district_1);

        insert districtList;

        // レコードタイプ（引越業者）取得
        RecordType recordTypeMoving = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Account' 
                AND Name = '引越業者' AND IsActive = true
            LIMIT 1
        ];                

        // 取引先（引越業者）作成
        Account account_M_1 = new Account(
            Name = 'テスト（引越業者）_001',
            AccountId__c = '90000001c',
            RecordTypeId = recordTypeMoving.Id,
            NotificationMethod__c = 'Chatter',
            IsContractPossible__c = '有り',
            ContractCategory__c = '5',
            AccountAbbreviation__c = 'テスト０３',
            Representative__c = 'テスト０３',
            ContractMoneyDeadline__c = Date.today().day(),
            ContractMoneyBillingDate__c = Date.today().day(),
            ContractTermStartDate__c = Date.today(),
            ContractTermEndDate__c = Date.today(),
            ContractorCopied__c = true,
            ConsignmentCollectionNew__c = true,
            ConsignmentCollectionCancel__c = true,
            ContractSignatureRepresentative__c = 'テスト０３',
            ContractMailOperatingCostsNote__c = 'テスト０３',
            PracticeChargeEmail1__c = '03@xx.xx',
            PracticeChargeEmail2__c = '03@xx.xx',
            WorkPlacePhone__c = '0303030303',
            AcceptForContactRealEstatePhone__c = '0303030303'
        );
        insert account_M_1;

        // レコードタイプ（不動産会社/家主）取得
        RecordType recordTypeMediationCompany = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Account' 
                AND Name = '不動産会社/家主' AND IsActive = true
            LIMIT 1
        ];

        // 取引先（不動産会社）
        List<Account>  accountList_MC = new List<Account>();

        for(Integer i = 0; i < processNum; i ++){ 
            String count = String.valueOf(i + 1);
            String nameCount = count.leftPad(7, '0');

            Account account_MC_1 = new Account(
                Name = 'テスト（不動産会社）_' + nameCount,
                AccountId__c = '9'  + nameCount + 'b',
                RecordTypeId = recordTypeMediationCompany.Id,
                ParticipatingStore__c = account_M_1.Id,
                IsTokutokuService__c = false,
                BasicRank__c = 'A',
                NotificationMethod__c = notificationMethod,
                NotificationTemplate__c = 'a0oO000000C4EqKIAV',
                MainEmail__c = 'ml-snt-sfdc@virtualex.co.jp',
                IsContractPossible__c = '有り',
                ContractCategory__c = '5',
                AccountAbbreviation__c = 'テスト０２',
                Representative__c = 'テスト０２',
                ContractMoneyDeadline__c = Date.today().day(),
                ContractMoneyBillingDate__c = Date.today().day(),
                ContractTermStartDate__c = Date.today(),
                ContractTermEndDate__c = Date.today(),
                ContractorCopied__c = true,
                ConsignmentCollectionNew__c = true,
                ConsignmentCollectionCancel__c = true,
                ContractSignatureRepresentative__c = 'テスト０２',
                ContractMailOperatingCostsNote__c = 'テスト０２',
                PracticeChargeEmail1__c = '02@xx.xx',
                PracticeChargeEmail2__c = '02@xx.xx',
                WorkPlacePhone__c = '0202020202',
                AcceptForContactRealEstatePhone__c = '0202020202'
            );
            accountList_MC.add(account_MC_1);
        }

        insert accountList_MC;

        Integer accountList_MC_count = accountList_MC.size();

        // 通知テンプレート
        List<NotificationTemplate__c>  notificationTemplateList = new List<NotificationTemplate__c>();
        NotificationTemplate__c tempNotificationTemplate = new NotificationTemplate__c();
        // 不動産キャパ
        List<AgencyCapacity__c>  agencyCapacityList = new List<AgencyCapacity__c>();
        AgencyCapacity__c tempAgencyCapacity = new AgencyCapacity__c();

        // 紹介可能エリア
        List<MediationPossibleArea__c>  mdiationPossibleAreaList =
            new List<MediationPossibleArea__c>();
        MediationPossibleArea__c tempMdiationPossibleArea = new MediationPossibleArea__c();

        for(Account account_MC : accountList_MC){ 

            tempNotificationTemplate = new NotificationTemplate__c(
                Account__c = account_MC.Id,
                MediationRequestMail__c = '00XO0000000l8zCMAQ'
            );
            notificationTemplateList.add(tempNotificationTemplate);

            tempAgencyCapacity = new AgencyCapacity__c(
                Account__c = account_MC.Id,
                CapacityNum__c = 100,
                RequestingNum__c = 10,
                RequestingFmNum__c = 10,
                RequestingNewCommodity__c = 10,
                AgencyCapacityId__c = account_MC.AccountId__c.replace('b', 'd')
            );
            agencyCapacityList.add(tempAgencyCapacity);

            tempMdiationPossibleArea = new MediationPossibleArea__c(
                Name = 'テスト（紹介可能エリア）_' + account_MC.AccountId__c.replace('b', 'd'),
                Account__c = account_MC.Id,
                District__c = district_1.Id
            );
            mdiationPossibleAreaList.add(tempMdiationPossibleArea);

        }

        insert notificationTemplateList;
        insert agencyCapacityList;
        insert mdiationPossibleAreaList;

        Integer notificationTemplateList_count = notificationTemplateList.size();
        Integer agencyCapacityList_count = agencyCapacityList.size();
        Integer mdiationPossibleAreaList_count = mdiationPossibleAreaList.size();


        // レコードタイプ（委託企業）取得
        RecordType recordTypeCompany = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Account' 
                AND Name = '委託企業' AND IsActive = true
            LIMIT 1
        ];

        // 取引先（企業）
        Account account_C_1 = new Account(
            Name = 'テスト（企業）_001',
            AccountId__c = '90000001a',
            RecordTypeId = recordTypeCompany.Id,
            NotificationMethod__c = 'メール',
            NotificationTemplate__c = 'a0oO000000C4EqKIAV',
            IsContractPossible__c = '有り',
            ContractCategory__c = '5',
            AccountAbbreviation__c = 'テスト０１',
            Representative__c = 'テスト０１',
            ContractMoneyDeadline__c = Date.today().day(),
            ContractMoneyBillingDate__c = Date.today().day(),
            ContractTermStartDate__c = Date.today(),
            ContractTermEndDate__c = Date.today(),
            ContractorCopied__c = true,
            ConsignmentCollectionNew__c = true,
            ConsignmentCollectionCancel__c = true,
            ContractSignatureRepresentative__c = 'テスト０１',
            ContractMailOperatingCostsNote__c = 'テスト０１',
            PracticeChargeEmail1__c = '01@xx.xx',
            PracticeChargeEmail2__c = '01@xx.xx',
            WorkPlacePhone__c = '0101010101',
            AcceptForContactRealEstatePhone__c = '0101010101'
        );

        insert account_C_1;

        // 通知テンプレート
        NotificationTemplate__c notificationTemplate_1 = 
            new NotificationTemplate__c(
            Account__c = account_C_1.Id,
            GreetingMail__c = 'APEXテンプレート',
            GreetingChatter__c = 'この度は新規ご契約ありがとうございます。'
        );
        insert notificationTemplate_1;

        // 社宅規定
        CorporateHousingRegulation__c cR_1 = 
            new CorporateHousingRegulation__c(
                Name = 'テスト（社宅規定）_001',
                Account__c = account_C_1.Id,
                SelectionRule__c = '<p><span>XXXXXXXXXXXX</span></p>',
                SelectionCount__c = processNum
            );
        insert cR_1;

        // 取引先担当者
        Contact contact_1 = new Contact(
            LastName = 'テスト（取引先担当者）_001',
            AccountId = account_C_1.Id,
            CorporateHousingRegulation__c = cR_1.Id,
            OtherDestinationCategory__c = '5',
            CompanyStaffCharacteristic__c = '5',
            Character__c = 'テスト０１',
            Department = 'テスト０１',
            OtherPriorityRanking__c = Date.today().day(),
            EmailContactRanking__c = Date.today().day(),
            InaugurationDate__c = Date.today(),
            RetireDate__c = Date.today(),
            HasOptedOutOfFax = true,
            HasOptedOutOfEmail = true,
            IsNoResident__c = true,
            TransferMemo__c = 'テスト０１',
            Description = 'テスト０１',
            Email = '01@xx.xx',
            Email2__c = '01@xx.xx',
            MobilePhone = '0101010101',
            Mobile2__c = '0101010101'
        );
        insert contact_1;

        // コミュニティユーザ
        Profile profile_2 = [
            SELECT Id
            FROM Profile
            WHERE Name = '（テスト用）Customer Community Login User'
            LIMIT 1
        ];
        User user_2 = new User(
            Email = contact_1.Email,
            ProfileId = profile_2.Id,
            Username = contact_1.Email,
            Alias = 'テスト０２',
            TimeZoneSidKey='Asia/Tokyo',
            EmailEncodingKey='UTF-8',
            LocaleSidKey='ja_JP',
            LanguageLocaleKey='ja',
            ContactId = contact_1.Id,
            // PortalRole = null,
            LastName = contact_1.LastName,
            CommunityNickname = 'テスト０２'
        );
        insert user_2;

        // 申請
        Application__c application_1 = new Application__c(
            Account__c = account_C_1.Id,
            ApplicantCode__c = contact_1.Id,
            MediationRequest__c = true,
            DesiredAreaState__c = '神奈川県',
            DesiredAreaCity__c = null
        );
        insert application_1;

        // 希望条件
        DesiredCondition__c desiredCondition_1 = new DesiredCondition__c(
            Application__c = application_1.Id
        );
        insert desiredCondition_1;

        // ↑↑↑ ここまで
        }
    }
}