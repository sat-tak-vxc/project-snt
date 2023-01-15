/**
 * @Description: TestDataactory.
 * 
 * @author hi-takada
 * @date 2022/02/15
 */
@isTest
public class MatchingComparisonTestDataFactory {

    /**
     * @Description カスタム設定を作成
     * @return `SyatakusanSetting__c`
     */
    public static SyatakusanSetting__c createSyatakusanSetting(){

        SyatakusanSetting__c syatakusanSetting = new SyatakusanSetting__c();
        syatakusanSetting.SystemUserId__c = '005O0000007fyxo';
        insert syatakusanSetting;

        return syatakusanSetting;
    }

    /**
     * @Description カスタム設定を作成
     * @return `MatchingSetting__c`
     */
    public static MatchingSetting__c createMatchingSetting(){

        MatchingSetting__c matchingSetting = new MatchingSetting__c();
        matchingSetting.FieldSuffix__c = '__c';
        matchingSetting.TypeFieldSuffix__c = 'Type__c';
        matchingSetting.ResultFieldSuffix__c = 'Result__c';
        matchingSetting.RecordTypeNameParkingApplication__c = '駐車場申請';
        matchingSetting.PaperTypeImportantExplanation__c = '重説';
        matchingSetting.PaperTypeContract__c = '契約書';
        matchingSetting.PaperTypeBill__c = '請求書';
        matchingSetting.PaperTypeDrawing__c = '図面';
        matchingSetting.TaskSubtype__c = 'Task';
        matchingSetting.TaskStatus__c = '進行中';
        matchingSetting.TaskPriority__c = '標準';
        matchingSetting.SendTaskAutoProcessCompleteSubject__c = '自動マッチング処理完了';
        matchingSetting.SendTaskAutoProcessCompleteMessage__c = '自動マッピング処理が完了しました。';
        matchingSetting.TaskErrorSubtype__c = 'Task';
        matchingSetting.TaskErrorStatus__c = '進行中';
        matchingSetting.TaskErrorPriority__c = '標準';
        matchingSetting.SendTaskAutoProcessErrorSubject__c = '自動マッチング処理失敗';
        matchingSetting.SendTaskAutoProcessErrorMessage__c = '自動マッチング処理に失敗しました。システム管理者へご連絡ください。';
        matchingSetting.MatchingComparisonResultOk__c = 'OK';
        matchingSetting.MatchingComparisonResultNg__c = 'NG';
        matchingSetting.GetMatchingEventErrorMessage__c = '画面初期表示処理に失敗しました。システム管理者へご連絡ください。';
        matchingSetting.UpdateMatchingEventErrorMessage__c = '登録処理に失敗しました。システム管理者へご連絡ください。';
        matchingSetting.DoManualMatchingEventErrorMessage__c = '手動マッチング実行処理に失敗しました。システム管理者へご連絡ください。';

        insert matchingSetting;

        return matchingSetting;
    }

    /**
     * @Description カスタム設定を作成
     * @return `void`
     */
    public static TraderSelectionSetting__c createTraderSelectionSetting(){

        TraderSelectionSetting__c traderSelectionSetting = new TraderSelectionSetting__c();
        traderSelectionSetting.ApexErrorEmailTemplate__c = '00XO0000000l99dMAA';
        traderSelectionSetting.ApexErrorEmailtoAddress__c = 'ml-snt-sfdc@virtualex.co.jp';
        traderSelectionSetting.SendTaskAutoProcessCompleteMessage__c = '<p>斡旋依頼が完了しました。</p>';
        traderSelectionSetting.SendTaskAutoProcessCompleteSubject__c = '斡旋依頼完了';
        traderSelectionSetting.SendTaskManualWorkRequestMessage__c = '<p>斡旋依頼が未完了です。</p><p>手動での斡旋依頼を行ってください。</p>';
        traderSelectionSetting.SendTaskManualWorkRequestSubject__c = '手動選定依頼通知';
        traderSelectionSetting.TaskSubtype__c = 'Task';
        traderSelectionSetting.TaskStatus__c = '進行中';
        traderSelectionSetting.TaskPriority__c = '標準';
        traderSelectionSetting.MediationRequestAutoProcessName__c = 'テスト';
        traderSelectionSetting.MediationRequestManualWorkName__c = 'テスト';
        traderSelectionSetting.SelectionResultRequesting__c = '依頼中';
        traderSelectionSetting.SelectionResultContract__c = '成約';
        traderSelectionSetting.SelectionResultLostOrder__c = '失注';
        traderSelectionSetting.GetMediationRequestEventErrorMessage__c = 'テスト';
        traderSelectionSetting.DisplayInputEventErrorMessage__c = 'テスト';
        traderSelectionSetting.SearchEventErrorMessage__c = 'テスト';
        traderSelectionSetting.MediationRequestEventErrorMessage__c = 'テスト';
        traderSelectionSetting.MediationRequestUpdateEventErrorMessage__c = 'テスト';
        traderSelectionSetting.MediationRequestDeleteEventErrorMessage__c = 'テスト';
        traderSelectionSetting.ChatterTextBody__c = 'Chatterテキスト_斡旋依頼の通知';
        traderSelectionSetting.ChatterTargetUserId__c = '0F9O0000000AFRBKA4';
        traderSelectionSetting.NotificationMethodEmail__c = 'メール';
        traderSelectionSetting.NotificationMethodChatter__c = 'Chatter';
        traderSelectionSetting.SendTaskAutoProcessErrorSubject__c = '自動斡旋依頼処理失敗';
        traderSelectionSetting.SendTaskAutoProcessErrorMessage__c = '自動斡旋依頼処理に失敗しました。システム管理者へご連絡ください。';
        traderSelectionSetting.TaskErrorSubtype__c = 'Task';
        traderSelectionSetting.TaskErrorStatus__c = '進行中';
        traderSelectionSetting.TaskErrorPriority__c = '標準';
        traderSelectionSetting.AccountSendNotificationBatchableCount__c = 180;
        traderSelectionSetting.SobjectTypeAccount__c = 'Account';
        traderSelectionSetting.RecordTypeNameTrader__c = '不動産会社/家主';
        traderSelectionSetting.NotificationErrorEmailTemplate__c = '00XO0000000l99dMAA';

        insert traderSelectionSetting;

        return traderSelectionSetting;
    }

    /**
     * @Description 取引先（不動産会社）テストレコード作成
     * @return `List<Account>`
     */
    public static List<Account> createAccount_MC_TraderSelection() {

        // 地区
        List<District__c>  districtList = new List<District__c>();

        District__c district_1 = new District__c(
            State__c = '神奈川県',
            City__c = '',
            IsAllCity__c = true
        );
        districtList.add(district_1);

        District__c district_2 = new District__c(
            State__c = '神奈川県',
            City__c = '横浜市',
            IsAllCity__c = false
        );
        districtList.add(district_2);

        District__c district_3 = new District__c(
            State__c = '神奈川県',
            City__c = '川崎市',
            IsAllCity__c = false
        );
        districtList.add(district_3);

        District__c district_4 = new District__c(
            State__c = '東京都',
            City__c = '',
            IsAllCity__c = true
        );
        districtList.add(district_4);
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
            RecordTypeId = recordTypeMoving.Id
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

        Account account_MC_1 = new Account(
            Name = 'テスト（不動産会社）_001',
            AccountId__c = '90000001b',
            RecordTypeId = recordTypeMediationCompany.Id,
            ParticipatingStore__c = account_M_1.Id,
            IsTokutokuService__c = false,
            BasicRank__c = 'A',
            NotificationMethod__c = 'メール',
            NotificationTemplate__c = 'a0oO000000C4EqKIAV',
            MainEmail__c = 'ml-snt-sfdc@virtualex.co.jp'
        );
        accountList_MC.add(account_MC_1);

        Account account_MC_2 = new Account(
            Name = 'テスト（不動産会社）_002',
            AccountId__c = '90000002b',
            RecordTypeId = recordTypeMediationCompany.Id,
            ParticipatingStore__c = account_M_1.Id,
            IsTokutokuService__c = false,
            BasicRank__c = 'A',
            NotificationMethod__c = 'メール',
            NotificationTemplate__c = 'a0oO000000C4EqKIAV',
            MainEmail__c = 'ml-snt-sfdc@virtualex.co.jp'
        );
        accountList_MC.add(account_MC_2);

        Account account_MC_3 = new Account(
            Name = 'テスト（不動産会社）_003',
            AccountId__c = '90000003b',
            RecordTypeId = recordTypeMediationCompany.Id,
            ParticipatingStore__c = account_M_1.Id,
            IsTokutokuService__c = false,
            BasicRank__c = 'A',
            // NotificationMethod__c = 'Chatter',
            NotificationMethod__c = 'メール',
            NotificationTemplate__c = 'a0oO000000C4EqKIAV',
            MainEmail__c = 'ml-snt-sfdc@virtualex.co.jp'
        );
        accountList_MC.add(account_MC_3);

        Account account_MC_4 = new Account(
            Name = 'テスト（不動産会社）_004',
            AccountId__c = '90000004b',
            RecordTypeId = recordTypeMediationCompany.Id,
            ParticipatingStore__c = account_M_1.Id,
            IsTokutokuService__c = false,
            BasicRank__c = 'A',
            // NotificationMethod__c = 'Chatter',
            NotificationMethod__c = 'メール',
            NotificationTemplate__c = 'a0oO000000C4EqKIAV',
            MainEmail__c = 'ml-snt-sfdc@virtualex.co.jp'
        );
        accountList_MC.add(account_MC_4);

        // ↓ 地区から取得する用
        Account account_MC_5 = new Account(
            Name = 'テスト（不動産会社）_005',
            AccountId__c = '90000005b',
            RecordTypeId = recordTypeMediationCompany.Id,
            ParticipatingStore__c = account_M_1.Id,
            IsTokutokuService__c = false,
            BasicRank__c = 'A',
            // NotificationMethod__c = 'Chatter',
            NotificationMethod__c = 'メール',
            NotificationTemplate__c = 'a0oO000000C4EqKIAV',
            MainEmail__c = 'ml-snt-sfdc@virtualex.co.jp'
        );
        accountList_MC.add(account_MC_5);
        Account account_MC_6 = new Account(
            Name = 'テスト（不動産会社）_006',
            AccountId__c = '90000006b',
            RecordTypeId = recordTypeMediationCompany.Id,
            ParticipatingStore__c = account_M_1.Id,
            IsTokutokuService__c = false,
            BasicRank__c = 'A',
            // NotificationMethod__c = 'Chatter',
            NotificationMethod__c = 'メール',
            NotificationTemplate__c = 'a0oO000000C4EqKIAV',
            MainEmail__c = 'ml-snt-sfdc@virtualex.co.jp'
        );
        accountList_MC.add(account_MC_6);
        Account account_MC_7 = new Account(
            Name = 'テスト（不動産会社）_007',
            AccountId__c = '90000007b',
            RecordTypeId = recordTypeMediationCompany.Id,
            ParticipatingStore__c = account_M_1.Id,
            IsTokutokuService__c = false,
            BasicRank__c = 'A',
            // NotificationMethod__c = 'Chatter',
            NotificationMethod__c = 'メール',
            NotificationTemplate__c = 'a0oO000000C4EqKIAV',
            MainEmail__c = 'ml-snt-sfdc@virtualex.co.jp'
        );
        accountList_MC.add(account_MC_7);

        insert accountList_MC;


        // 通知テンプレート
        List<NotificationTemplate__c>  notificationTemplateList = new List<NotificationTemplate__c>();

        NotificationTemplate__c notificationTemplate_1 = new NotificationTemplate__c(
            Account__c = account_MC_1.Id,
            MediationRequestMail__c = '00XO0000000l8zCMAQ'
        );
        notificationTemplateList.add(notificationTemplate_1);

        NotificationTemplate__c notificationTemplate_2 = new NotificationTemplate__c(
            Account__c = account_MC_2.Id,
            MediationRequestMail__c = '00XO0000000l8zCMAQ'
        );
        notificationTemplateList.add(notificationTemplate_2);

        NotificationTemplate__c notificationTemplate_3 = new NotificationTemplate__c(
            Account__c = account_MC_3.Id,
            MediationRequestMail__c = '00XO0000000l8zCMAQ'
        );
        notificationTemplateList.add(notificationTemplate_3);

        NotificationTemplate__c notificationTemplate_4 = new NotificationTemplate__c(
            Account__c = account_MC_4.Id,
            MediationRequestMail__c = '00XO0000000l8zCMAQ'
        );
        notificationTemplateList.add(notificationTemplate_4);

        NotificationTemplate__c notificationTemplate_5 = new NotificationTemplate__c(
            Account__c = account_MC_5.Id,
            MediationRequestMail__c = '00XO0000000l8zCMAQ'
        );
        notificationTemplateList.add(notificationTemplate_5);

        NotificationTemplate__c notificationTemplate_6 = new NotificationTemplate__c(
            Account__c = account_MC_6.Id,
            MediationRequestMail__c = '00XO0000000l8zCMAQ'
        );
        notificationTemplateList.add(notificationTemplate_6);

        NotificationTemplate__c notificationTemplate_7 = new NotificationTemplate__c(
            Account__c = account_MC_7.Id,
            MediationRequestMail__c = '00XO0000000l8zCMAQ'
        );
        notificationTemplateList.add(notificationTemplate_7);

        insert notificationTemplateList;

        // 不動産キャパ
        List<AgencyCapacity__c>  agencyCapacityList = new List<AgencyCapacity__c>();
        AgencyCapacity__c agencyCapacity_1 = new AgencyCapacity__c(
            Account__c = account_MC_1.Id,
            CapacityNum__c = 100,
            RequestingNum__c = 0,
            RequestingFmNum__c = 10,
            RequestingNewCommodity__c = 10,
            AgencyCapacityId__c = '90000001d'
        );
        agencyCapacityList.add(agencyCapacity_1);

        AgencyCapacity__c agencyCapacity_2 = new AgencyCapacity__c(
            Account__c = account_MC_2.Id,
            CapacityNum__c = 110,
            RequestingNum__c = 0,
            RequestingFmNum__c = 10,
            RequestingNewCommodity__c = 10,
            AgencyCapacityId__c = '90000002d'
        );
        agencyCapacityList.add(agencyCapacity_2);

        AgencyCapacity__c agencyCapacity_3 = new AgencyCapacity__c(
            Account__c = account_MC_3.Id,
            CapacityNum__c = 120,
            RequestingNum__c = 0,
            RequestingFmNum__c = 10,
            RequestingNewCommodity__c = 10,
            AgencyCapacityId__c = '90000003d'
        );
        agencyCapacityList.add(agencyCapacity_3);

        AgencyCapacity__c agencyCapacity_4 = new AgencyCapacity__c(
            Account__c = account_MC_4.Id,
            CapacityNum__c = 130,
            RequestingNum__c = 0,
            RequestingFmNum__c = 10,
            RequestingNewCommodity__c = 10,
            AgencyCapacityId__c = '90000004d'
        );
        agencyCapacityList.add(agencyCapacity_4);

        AgencyCapacity__c agencyCapacity_5 = new AgencyCapacity__c(
            Account__c = account_MC_5.Id,
            CapacityNum__c = 140,
            RequestingNum__c = 0,
            RequestingFmNum__c = 10,
            RequestingNewCommodity__c = 10,
            AgencyCapacityId__c = '90000005d'
        );
        agencyCapacityList.add(agencyCapacity_5);

        AgencyCapacity__c agencyCapacity_6 = new AgencyCapacity__c(
            Account__c = account_MC_6.Id,
            CapacityNum__c = 150,
            RequestingNum__c = 0,
            RequestingFmNum__c = 10,
            RequestingNewCommodity__c = 10,
            AgencyCapacityId__c = '90000006d'
        );
        agencyCapacityList.add(agencyCapacity_6);

        AgencyCapacity__c agencyCapacity_7 = new AgencyCapacity__c(
            Account__c = account_MC_7.Id,
            CapacityNum__c = 160,
            RequestingNum__c = 0,
            RequestingFmNum__c = 10,
            RequestingNewCommodity__c = 10,
            AgencyCapacityId__c = '90000007d'
        );
        agencyCapacityList.add(agencyCapacity_7);

        insert agencyCapacityList;

        // 紹介可能エリア
        List<MediationPossibleArea__c>  mdiationPossibleAreaList =
            new List<MediationPossibleArea__c>();

        MediationPossibleArea__c mdiationPossibleArea_1 = new MediationPossibleArea__c(
            Name = 'テスト（紹介可能エリア）_001',
            Account__c = account_MC_1.Id,
            District__c = district_2.Id
        );
        mdiationPossibleAreaList.add(mdiationPossibleArea_1);

        MediationPossibleArea__c mdiationPossibleArea_2 = new MediationPossibleArea__c(
            Name = 'テスト（紹介可能エリア）_002',
            Account__c = account_MC_2.Id,
            District__c = district_2.Id
        );
        mdiationPossibleAreaList.add(mdiationPossibleArea_2);

        MediationPossibleArea__c mdiationPossibleArea_3 = new MediationPossibleArea__c(
            Name = 'テスト（紹介可能エリア）_003',
            Account__c = account_MC_3.Id,
            District__c = district_3.Id
        );
        mdiationPossibleAreaList.add(mdiationPossibleArea_3);

        MediationPossibleArea__c mdiationPossibleArea_4 = new MediationPossibleArea__c(
            Name = 'テスト（紹介可能エリア）_004',
            Account__c = account_MC_4.Id,
            District__c = district_2.Id
        );
        mdiationPossibleAreaList.add(mdiationPossibleArea_4);
        MediationPossibleArea__c mdiationPossibleArea_5 = new MediationPossibleArea__c(
            Name = 'テスト（紹介可能エリア）_005',
            Account__c = account_MC_5.Id,
            District__c = district_2.Id
        );
        mdiationPossibleAreaList.add(mdiationPossibleArea_5);
        MediationPossibleArea__c mdiationPossibleArea_6 = new MediationPossibleArea__c(
            Name = 'テスト（紹介可能エリア）_006',
            Account__c = account_MC_6.Id,
            District__c = district_2.Id
        );
        mdiationPossibleAreaList.add(mdiationPossibleArea_6);
        MediationPossibleArea__c mdiationPossibleArea_7 = new MediationPossibleArea__c(
            Name = 'テスト（紹介可能エリア）_007',
            Account__c = account_MC_7.Id,
            District__c = district_2.Id
        );
        mdiationPossibleAreaList.add(mdiationPossibleArea_7);

        insert mdiationPossibleAreaList;

        // 指定不動産会社
        List<SpecifyAgency__c>  specifyAgencyList = new List<SpecifyAgency__c>();

        SpecifyAgency__c specifyAgency_1 = new SpecifyAgency__c(
            Name = 'テスト（指定不動産会社）_001',
            IsMediation__c = false,
            RealEstateAgency__c = account_MC_1.Id,
            District__c = district_1.Id
        );
        specifyAgencyList.add(specifyAgency_1);

        SpecifyAgency__c specifyAgency_2 = new SpecifyAgency__c(
            Name = 'テスト（指定不動産会社）_002',
            IsMediation__c = false,
            RealEstateAgency__c = account_MC_2.Id,
            District__c = district_2.Id
        );
        specifyAgencyList.add(specifyAgency_2);

        SpecifyAgency__c specifyAgency_3 = new SpecifyAgency__c(
            Name = 'テスト（指定不動産会社）_003',
            IsMediation__c = true, // 検索時に取得されないようにする設定
            RealEstateAgency__c = account_MC_3.Id,
            District__c = district_2.Id
        );
        specifyAgencyList.add(specifyAgency_3);

        SpecifyAgency__c specifyAgency_4 = new SpecifyAgency__c(
            Name = 'テスト（指定不動産会社）_004',
            IsMediation__c = false, 
            RealEstateAgency__c = account_MC_4.Id,
            District__c = district_2.Id
        );
        specifyAgencyList.add(specifyAgency_4);

        insert specifyAgencyList;

        return accountList_MC;
    }


    /**
     * @Description 申請テストレコード作成
     * @return `List<Application__c>`
     */
    public static List<Application__c> createApplication_TraderSelection() {

        // レコードタイプ（委託企業）取得
        RecordType recordTypeCompany = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Account' 
                AND Name = '委託企業' AND IsActive = true
            LIMIT 1
        ];

        // 取引先（企業）
        List<Account>  accountList = new List<Account>();

        Account account_C_1 = new Account(
            Name = 'テスト（企業）_001',
            AccountId__c = '90000001a',
            RecordTypeId = recordTypeCompany.Id,
            NotificationMethod__c = 'メール',
            NotificationTemplate__c = 'a0oO000000C4EqKIAV'
        );
        accountList.add(account_C_1);

        Account account_C_2 = new Account(
            Name = 'テスト（企業）_002',
            AccountId__c = '90000002a',
            RecordTypeId = recordTypeCompany.Id,
            NotificationMethod__c = 'メール',
            NotificationTemplate__c = 'a0oO000000C4EqKIAV'
        );
        accountList.add(account_C_2);

        Account account_C_3 = new Account(
            Name = 'テスト（企業）_003',
            AccountId__c = '90000003a',
            RecordTypeId = recordTypeCompany.Id,
            NotificationMethod__c = 'メール',
            NotificationTemplate__c = 'a0oO000000C4EqKIAV'
        );
        accountList.add(account_C_3);

        insert accountList;


        // 通知テンプレート
        List<NotificationTemplate__c>  notificationTemplateList = 
            new List<NotificationTemplate__c>();

        NotificationTemplate__c notificationTemplate_1 = 
            new NotificationTemplate__c(
            Account__c = account_C_1.Id,
            GreetingMail__c = 'APEXテンプレート',
            GreetingChatter__c = 'この度は新規ご契約ありがとうございます。'
        );
        notificationTemplateList.add(notificationTemplate_1);

        NotificationTemplate__c notificationTemplate_2 = 
            new NotificationTemplate__c(
            Account__c = account_C_2.Id,
            GreetingMail__c = 'APEXテンプレート',
            GreetingChatter__c = 'この度は新規ご契約ありがとうございます。'
        );
        notificationTemplateList.add(notificationTemplate_2);

        NotificationTemplate__c notificationTemplate_3 = 
            new NotificationTemplate__c(
            Account__c = account_C_3.Id,
            GreetingMail__c = 'APEXテンプレート',
            GreetingChatter__c = 'この度は新規ご契約ありがとうございます。'
        );
        notificationTemplateList.add(notificationTemplate_3);

        insert notificationTemplateList;

        // 社宅規定
        List<CorporateHousingRegulation__c>  cRList = 
            new List<CorporateHousingRegulation__c>();

        CorporateHousingRegulation__c cR_1 = 
            new CorporateHousingRegulation__c(
                Name = 'テスト（社宅規定）_001',
                Account__c = account_C_1.Id,
                SelectionRule__c = '<p><span>XXXXXXXXXXXX</span></p>',
                SelectionCount__c = 4
            );
        cRList.add(cR_1);

        CorporateHousingRegulation__c cR_2 = 
            new CorporateHousingRegulation__c(
                Name = 'テスト（社宅規定）_002',
                SelectionRule__c = '<p><span>XXXXXXXXXXXX</span></p>',
                Account__c = account_C_2.Id,
                SelectionCount__c = 20
            );
        cRList.add(cR_2);

        CorporateHousingRegulation__c cR_3 = 
            new CorporateHousingRegulation__c(
                Name = 'テスト（社宅規定）_003',
                SelectionRule__c = '<p><span>XXXXXXXXXXXX</span></p>',
                Account__c = account_C_3.Id
            );
        cRList.add(cR_3);

        insert cRList;


        // 取引先担当者
        List<Contact>  contactList = new List<Contact>();

        Contact contact_1 = new Contact(
            LastName = 'テスト（取引先担当者）_001',
            AccountId = account_C_1.Id,
            CorporateHousingRegulation__c = cR_1.Id,
            Email = 'ml-snt-sfdc@virtualex.co.jp'
        );
        contactList.add(contact_1);

        Contact contact_2 = new Contact(
            LastName = 'テスト（取引先担当者）_002',
            AccountId = account_C_2.Id,
            CorporateHousingRegulation__c = cR_2.Id,
            Email = 'ml-snt-sfdc@virtualex.co.jp'
        );
        contactList.add(contact_2);

        Contact contact_3 = new Contact(
            LastName = 'テスト（取引先担当者）_003',
            AccountId = account_C_3.Id,
            CorporateHousingRegulation__c = cR_3.Id,
            Email = 'ml-snt-sfdc@virtualex.co.jp'
        );
        contactList.add(contact_3);
        
        insert contactList;


        // 申請
        List<Application__c>  applicationList = new List<Application__c>();

        Application__c application_1 = new Application__c(
            Account__c = account_C_1.Id,
            ApplicantCode__c = contact_1.Id,
            MediationRequest__c = true,
            DesiredAreaState__c = '神奈川県',
            DesiredAreaCity__c = null
        );
        applicationList.add(application_1);

        Application__c application_2 = new Application__c(
            Account__c = account_C_2.Id,
            ApplicantCode__c = contact_2.Id,
            MediationRequest__c = true,
            DesiredAreaState__c = '神奈川県',
            DesiredAreaCity__c = '横浜市'
        );
        applicationList.add(application_2);

        Application__c application_3 = new Application__c(
            Account__c = account_C_3.Id,
            ApplicantCode__c = contact_3.Id,
            MediationRequest__c = false,
            DesiredAreaState__c = '神奈川県',
            DesiredAreaCity__c = '横浜市'
        );
        applicationList.add(application_3);

        insert applicationList;



        // 希望条件
        List<DesiredCondition__c>  desiredConditionList = new List<DesiredCondition__c>();

        DesiredCondition__c desiredCondition_1 = new DesiredCondition__c(
            Application__c = application_1.Id
        );
        desiredConditionList.add(desiredCondition_1);

        DesiredCondition__c desiredCondition_2 = new DesiredCondition__c(
            Application__c = application_2.Id
        );
        desiredConditionList.add(desiredCondition_2);

        DesiredCondition__c desiredCondition_3 = new DesiredCondition__c(
            Application__c = application_3.Id
        );
        desiredConditionList.add(desiredCondition_3);

        insert desiredConditionList;

        return applicationList;
    }

    /**
     * @Description 新規テストレコード作成（複数）
     * @return `List<NewMatter__c>`
     */
    public static List<NewMatter__c> createNewMatter_TraderSelection(
        List<Application__c> applicationList) {

        // レコードタイプ（新規）取得
        RecordType recordTypeNew = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'NewMatter__c' 
                AND Name = '新規' AND IsActive = true
            LIMIT 1
        ];

        // 新規
        List<NewMatter__c>  newMatterList = new List<NewMatter__c>();

        for (Application__c application : applicationList){
            NewMatter__c newMatter = new NewMatter__c(
                Application__c = application.Id,
                RecordTypeId = recordTypeNew.Id
            );
            newMatterList.add(newMatter);
        }

        insert newMatterList;

        return newMatterList;
    }

    /**
     * @Description 新規テストレコード作成（単一）
     * @return `NewMatter__c`
     */
    public static NewMatter__c createNewMatter_one_TraderSelection(
        Application__c application) {

        // レコードタイプ（新規）取得
        RecordType recordTypeNew = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'NewMatter__c' 
                AND Name = '新規' AND IsActive = true
            LIMIT 1
        ];

        // 新規
        NewMatter__c newMatter = new NewMatter__c(
            Application__c = application.Id,
            RecordTypeId = recordTypeNew.Id
        );        

        insert newMatter;

        return newMatter;
    }

    /**
     * @Description テストレコード作成
     * @return `List<Account>`
     */
    public static Application__c createAccount_Mass_TraderSelection(
        Integer processNum, String notificationMethod) {

        // Integer processNum = 80;
        // String notificationMethod = 'メール';

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
            NotificationMethod__c = 'Chatter'
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
            String count = i + 1 + 'b';
            String nameCount = count.leftPad(6, '0');

            Account account_MC_1 = new Account(
                Name = 'テスト（不動産会社）_' + nameCount,
                AccountId__c = '9'  + nameCount + 'b',
                RecordTypeId = recordTypeMediationCompany.Id,
                ParticipatingStore__c = account_M_1.Id,
                IsTokutokuService__c = false,
                BasicRank__c = 'A',
                NotificationMethod__c = notificationMethod,
                NotificationTemplate__c = 'a0oO000000C4EqKIAV',
                MainEmail__c = 'ml-snt-sfdc@virtualex.co.jp'
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
            NotificationTemplate__c = 'a0oO000000C4EqKIAV'
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
            Email = 'ml-snt-sfdc@virtualex.co.jp'
        );
        insert contact_1;


        // 申請
        Application__c application_1 = new Application__c(
            Account__c = account_C_1.Id,
            ApplicantCode__c = contact_1.Id,
            MediationRequest__c = true
            // DesiredAreaState__c = '神奈川県',
            // DesiredAreaCity__c = null
            //ApprovalStep__c = '承認済み'
        );
        insert application_1;

        // 希望条件
        // DesiredCondition__c desiredCondition_1 = new DesiredCondition__c(
        //     Application__c = application_1.Id
        // );
        // insert desiredCondition_1;

        return application_1;

    }


}