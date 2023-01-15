/**
 * @Description: Testing for class MatchingTrigger.
 * 
 * @author t-ooshiro-bp
 * @date 2022/02/16
 */
@isTest
private class MatchingTriggerTest {

    /**
     * @Description 共通テストレコード作成
     */
    /*
    @testSetup
    static void setup() {
        // カスタム設定を作成
        MatchingComparisonTestDataFactory.createTraderSelectionSetting();
        MatchingComparisonTestDataFactory.createMatchingSetting();
        MatchingComparisonTestDataFactory.createSyatakusanSetting();
        // 取引先（不動産会社）データ生成
        Application__c application = MatchingComparisonTestDataFactory.createAccount_Mass_TraderSelection(1, 'メール');
        // 新規データ作成（単一）
        // NewMatter__c newMatter = MatchingComparisonTestDataFactory.createNewMatter_one_TraderSelection(application);
    }
    */
    /**
     * @Description 
     */
    /*
    @isTest
    static void matchingComparisonTest_001() {
        List<NewMatter__c> newMatters = [SELECT Id, Application__c FROM NewMatter__c];
        NewMatter__c newMatter = newMatters.get(0);
        // レコードタイプ（引越申請）取得
        List<RecordType> recordTypes = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Application__c' 
              AND Name = '引越申請' AND IsActive = true
        ];
        List<Application__c> applications = [SELECT Id, RecordTypeId FROM Application__c WHERE Id = :newMatter.Application__c];
        Application__c application = applications.get(0);
        // 申請にレコードタイプ：引越申請を設定
        application.RecordTypeId = recordTypes.get(0).Id;
        update application;

        MatchingComparisonResult__c matchingComparisonResult = new MatchingComparisonResult__c();
        matchingComparisonResult.NewMatter__c = newMatter.Id;
        matchingComparisonResult.IsExceptImportantExplanation__c = false;
        matchingComparisonResult.IsExceptContract__c = false;
        matchingComparisonResult.IsExceptBill__c = false;
        matchingComparisonResult.IsExceptDrawing__c = false;
        insert matchingComparisonResult;

        // マッチング
        List<Matching__c>  matchings = new List<Matching__c>();

        Matching__c matching_1 = new Matching__c(
            Name = 'マッチング比較用_重説',
            NewMatter__c = newMatter.Id,
            PaperType__c = '重説',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_1);

        Test.startTest();
        insert matchings;
        Test.stopTest();

        List<MatchingComparisonResult__c> matchingComparisonResults = [SELECT Id FROM MatchingComparisonResult__c WHERE NewMatter__c = :newMatter.Id];
        System.assert(!matchingComparisonResults.isEmpty());
        List<FifthSetConfirm__c> fifthSetConfirms = [SELECT Id FROM FifthSetConfirm__c WHERE NewMatter__c = :newMatter.Id];
        System.assert(fifthSetConfirms.isEmpty());
    }
    */
    /**
     * @Description 
     */
    /*
    @isTest
    static void matchingComparisonTest_002() {
        List<NewMatter__c> newMatters = [SELECT Id, Application__c FROM NewMatter__c];
        NewMatter__c newMatter = newMatters.get(0);
        // レコードタイプ（引越申請）取得
        List<RecordType> recordTypes = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Application__c' 
              AND Name = '引越申請' AND IsActive = true
        ];
        List<Application__c> applications = [SELECT Id, RecordTypeId FROM Application__c WHERE Id = :newMatter.Application__c];
        Application__c application = applications.get(0);
        // 申請にレコードタイプ：引越申請を設定
        application.RecordTypeId = recordTypes.get(0).Id;
        update application;

        MatchingComparisonResult__c matchingComparisonResult = new MatchingComparisonResult__c();
        matchingComparisonResult.NewMatter__c = newMatter.Id;
        matchingComparisonResult.IsExceptImportantExplanation__c = false;
        matchingComparisonResult.IsExceptContract__c = false;
        matchingComparisonResult.IsExceptBill__c = false;
        matchingComparisonResult.IsExceptDrawing__c = false;
        insert matchingComparisonResult;

        // マッチング
        List<Matching__c>  matchings = new List<Matching__c>();

        Matching__c matching_1 = new Matching__c(
            Name = 'マッチング比較用_重説',
            NewMatter__c = newMatter.Id,
            PaperType__c = '重説',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_1);

        Matching__c matching_2 = new Matching__c(
            Name = 'マッチング比較用_契約書',
            NewMatter__c = newMatter.Id,
            PaperType__c = '契約書',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_2);

        Test.startTest();
        insert matchings;
        Test.stopTest();

        List<MatchingComparisonResult__c> matchingComparisonResults = [SELECT Id FROM MatchingComparisonResult__c WHERE NewMatter__c = :newMatter.Id];
        System.assert(!matchingComparisonResults.isEmpty());
        List<FifthSetConfirm__c> fifthSetConfirms = [SELECT Id FROM FifthSetConfirm__c WHERE NewMatter__c = :newMatter.Id];
        System.assert(fifthSetConfirms.isEmpty());
    }
    */

    /**
     * @Description 
     */
    /*
    @isTest
    static void matchingComparisonTest_003() {
        List<NewMatter__c> newMatters = [SELECT Id, Application__c FROM NewMatter__c];
        NewMatter__c newMatter = newMatters.get(0);
        // レコードタイプ（引越申請）取得
        List<RecordType> recordTypes = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Application__c' 
              AND Name = '引越申請' AND IsActive = true
        ];
        List<Application__c> applications = [SELECT Id, RecordTypeId FROM Application__c WHERE Id = :newMatter.Application__c];
        Application__c application = applications.get(0);
        // 申請にレコードタイプ：引越申請を設定
        application.RecordTypeId = recordTypes.get(0).Id;
        update application;

        MatchingComparisonResult__c matchingComparisonResult = new MatchingComparisonResult__c();
        matchingComparisonResult.NewMatter__c = newMatter.Id;
        matchingComparisonResult.IsExceptImportantExplanation__c = false;
        matchingComparisonResult.IsExceptContract__c = false;
        matchingComparisonResult.IsExceptBill__c = false;
        matchingComparisonResult.IsExceptDrawing__c = false;
        insert matchingComparisonResult;

        // マッチング
        List<Matching__c>  matchings = new List<Matching__c>();

        Matching__c matching_1 = new Matching__c(
            Name = 'マッチング比較用_重説',
            NewMatter__c = newMatter.Id,
            PaperType__c = '重説',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_1);

        Matching__c matching_2 = new Matching__c(
            Name = 'マッチング比較用_契約書',
            NewMatter__c = newMatter.Id,
            PaperType__c = '契約書',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_2);

        Matching__c matching_3 = new Matching__c(
            Name = 'マッチング比較用_請求書',
            NewMatter__c = newMatter.Id,
            PaperType__c = '請求書',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_3);

        Test.startTest();
        insert matchings;
        Test.stopTest();

        List<MatchingComparisonResult__c> matchingComparisonResults = [SELECT Id FROM MatchingComparisonResult__c WHERE NewMatter__c = :newMatter.Id];
        System.assert(!matchingComparisonResults.isEmpty());
        List<FifthSetConfirm__c> fifthSetConfirms = [SELECT Id FROM FifthSetConfirm__c WHERE NewMatter__c = :newMatter.Id];
        System.assert(fifthSetConfirms.isEmpty());
    }
    */

    /**
     * @Description 
     */
    /*

    /*
    @isTest
    static void matchingComparisonTest_004() {
        List<NewMatter__c> newMatters = [SELECT Id, Application__c FROM NewMatter__c];
        NewMatter__c newMatter = newMatters.get(0);
        // レコードタイプ（引越申請）取得
        List<RecordType> recordTypes = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Application__c' 
              AND Name = '引越申請' AND IsActive = true
        ];
        List<Application__c> applications = [SELECT Id, RecordTypeId FROM Application__c WHERE Id = :newMatter.Application__c];
        Application__c application = applications.get(0);
        // 申請にレコードタイプ：引越申請を設定
        application.RecordTypeId = recordTypes.get(0).Id;
        update application;

        MatchingComparisonResult__c matchingComparisonResult = new MatchingComparisonResult__c();
        matchingComparisonResult.NewMatter__c = newMatter.Id;
        matchingComparisonResult.IsExceptImportantExplanation__c = false;
        matchingComparisonResult.IsExceptContract__c = false;
        matchingComparisonResult.IsExceptBill__c = false;
        matchingComparisonResult.IsExceptDrawing__c = false;
        insert matchingComparisonResult;

        // マッチング
        List<Matching__c>  matchings = new List<Matching__c>();

        Matching__c matching_1 = new Matching__c(
            Name = 'マッチング比較用_重説',
            NewMatter__c = newMatter.Id,
            PaperType__c = '重説',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_1);

        Matching__c matching_2 = new Matching__c(
            Name = 'マッチング比較用_契約書',
            NewMatter__c = newMatter.Id,
            PaperType__c = '契約書',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_2);

        Matching__c matching_3 = new Matching__c(
            Name = 'マッチング比較用_請求書',
            NewMatter__c = newMatter.Id,
            PaperType__c = '請求書',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_3);

        Matching__c matching_4 = new Matching__c(
            Name = 'マッチング比較用_図面',
            NewMatter__c = newMatter.Id,
            PaperType__c = '図面',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_4);

        Test.startTest();
        insert matchings;
        Test.stopTest();

        List<MatchingComparisonResult__c> matchingComparisonResults = [SELECT Id FROM MatchingComparisonResult__c WHERE NewMatter__c = :newMatter.Id];
        System.assert(!matchingComparisonResults.isEmpty());
        List<FifthSetConfirm__c> fifthSetConfirms = [SELECT Id FROM FifthSetConfirm__c WHERE NewMatter__c = :newMatter.Id];
        System.assert(!fifthSetConfirms.isEmpty());
    }
    */

    /**
     * @Description 
     */
    /*
    @isTest
    static void matchingComparisonTest_101() {
        List<NewMatter__c> newMatters = [SELECT Id, Application__c FROM NewMatter__c];
        NewMatter__c newMatter = newMatters.get(0);
        // レコードタイプ（駐車場申請）取得
        List<RecordType> recordTypes = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Application__c' 
              AND Name = '駐車場申請' AND IsActive = true
        ];
        List<Application__c> applications = [SELECT Id, RecordTypeId FROM Application__c WHERE Id = :newMatter.Application__c];
        Application__c application = applications.get(0);
        // 申請にレコードタイプ：駐車場申請を設定
        application.RecordTypeId = recordTypes.get(0).Id;
        update application;

        MatchingComparisonResult__c matchingComparisonResult = new MatchingComparisonResult__c();
        matchingComparisonResult.NewMatter__c = newMatter.Id;
        matchingComparisonResult.IsExceptImportantExplanation__c = true;
        matchingComparisonResult.IsExceptContract__c = false;
        matchingComparisonResult.IsExceptBill__c = false;
        matchingComparisonResult.IsExceptDrawing__c = true;
        insert matchingComparisonResult;

        // マッチング
        List<Matching__c>  matchings = new List<Matching__c>();

        Matching__c matching_1 = new Matching__c(
            Name = 'マッチング比較用_重説',
            NewMatter__c = newMatter.Id,
            PaperType__c = '重説',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_1);

        Test.startTest();
        insert matchings;
        Test.stopTest();

        List<MatchingComparisonResult__c> matchingComparisonResults = [SELECT Id FROM MatchingComparisonResult__c WHERE NewMatter__c = :newMatter.Id];
        System.assert(!matchingComparisonResults.isEmpty());
        List<FifthSetConfirm__c> fifthSetConfirms = [SELECT Id FROM FifthSetConfirm__c WHERE NewMatter__c = :newMatter.Id];
        System.assert(fifthSetConfirms.isEmpty());
    }
    */

    /**
     * @Description 
     */
    /*
    @isTest
    static void matchingComparisonTest_102() {
        List<NewMatter__c> newMatters = [SELECT Id, Application__c FROM NewMatter__c];
        NewMatter__c newMatter = newMatters.get(0);
        // レコードタイプ（駐車場申請）取得
        List<RecordType> recordTypes = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Application__c' 
              AND Name = '駐車場申請' AND IsActive = true
        ];
        List<Application__c> applications = [SELECT Id, RecordTypeId FROM Application__c WHERE Id = :newMatter.Application__c];
        Application__c application = applications.get(0);
        // 申請にレコードタイプ：駐車場申請を設定
        application.RecordTypeId = recordTypes.get(0).Id;
        update application;

        MatchingComparisonResult__c matchingComparisonResult = new MatchingComparisonResult__c();
        matchingComparisonResult.NewMatter__c = newMatter.Id;
        matchingComparisonResult.IsExceptImportantExplanation__c = true;
        matchingComparisonResult.IsExceptContract__c = false;
        matchingComparisonResult.IsExceptBill__c = false;
        matchingComparisonResult.IsExceptDrawing__c = true;
        insert matchingComparisonResult;

        // マッチング
        List<Matching__c>  matchings = new List<Matching__c>();

        Matching__c matching_1 = new Matching__c(
            Name = 'マッチング比較用_重説',
            NewMatter__c = newMatter.Id,
            PaperType__c = '重説',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_1);

        Matching__c matching_2 = new Matching__c(
            Name = 'マッチング比較用_契約書',
            NewMatter__c = newMatter.Id,
            PaperType__c = '契約書',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_2);

        Test.startTest();
        insert matchings;
        Test.stopTest();

        List<MatchingComparisonResult__c> matchingComparisonResults = [SELECT Id FROM MatchingComparisonResult__c WHERE NewMatter__c = :newMatter.Id];
        System.assert(!matchingComparisonResults.isEmpty());
        List<FifthSetConfirm__c> fifthSetConfirms = [SELECT Id FROM FifthSetConfirm__c WHERE NewMatter__c = :newMatter.Id];
        System.assert(fifthSetConfirms.isEmpty());
    }
    */

    /**
     * @Description 
     */
    /*
    @isTest
    static void matchingComparisonTest_103() {
        List<NewMatter__c> newMatters = [SELECT Id, Application__c FROM NewMatter__c];
        NewMatter__c newMatter = newMatters.get(0);
        // レコードタイプ（駐車場申請）取得
        List<RecordType> recordTypes = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Application__c' 
              AND Name = '駐車場申請' AND IsActive = true
        ];
        List<Application__c> applications = [SELECT Id, RecordTypeId FROM Application__c WHERE Id = :newMatter.Application__c];
        Application__c application = applications.get(0);
        // 申請にレコードタイプ：駐車場申請を設定
        application.RecordTypeId = recordTypes.get(0).Id;
        update application;

        MatchingComparisonResult__c matchingComparisonResult = new MatchingComparisonResult__c();
        matchingComparisonResult.NewMatter__c = newMatter.Id;
        matchingComparisonResult.IsExceptImportantExplanation__c = true;
        matchingComparisonResult.IsExceptContract__c = false;
        matchingComparisonResult.IsExceptBill__c = false;
        matchingComparisonResult.IsExceptDrawing__c = true;
        insert matchingComparisonResult;

        // マッチング
        List<Matching__c>  matchings = new List<Matching__c>();

        Matching__c matching_1 = new Matching__c(
            Name = 'マッチング比較用_重説',
            NewMatter__c = newMatter.Id,
            PaperType__c = '重説',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_1);

        Matching__c matching_2 = new Matching__c(
            Name = 'マッチング比較用_契約書',
            NewMatter__c = newMatter.Id,
            PaperType__c = '契約書',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_2);

        Matching__c matching_3 = new Matching__c(
            Name = 'マッチング比較用_請求書',
            NewMatter__c = newMatter.Id,
            PaperType__c = '請求書',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_3);

        Test.startTest();
        insert matchings;
        Test.stopTest();

        List<MatchingComparisonResult__c> matchingComparisonResults = [SELECT Id FROM MatchingComparisonResult__c WHERE NewMatter__c = :newMatter.Id];
        System.assert(!matchingComparisonResults.isEmpty());
        List<FifthSetConfirm__c> fifthSetConfirms = [SELECT Id FROM FifthSetConfirm__c WHERE NewMatter__c = :newMatter.Id];
        System.assert(!fifthSetConfirms.isEmpty());
    }
    */

    /**
     * @Description 
     */
    /*
    @isTest
    static void matchingComparisonTest_104() {
        List<NewMatter__c> newMatters = [SELECT Id, Application__c FROM NewMatter__c];
        NewMatter__c newMatter = newMatters.get(0);
        // レコードタイプ（駐車場申請）取得
        List<RecordType> recordTypes = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Application__c' 
              AND Name = '駐車場申請' AND IsActive = true
        ];
        List<Application__c> applications = [SELECT Id, RecordTypeId FROM Application__c WHERE Id = :newMatter.Application__c];
        Application__c application = applications.get(0);
        // 申請にレコードタイプ：駐車場申請を設定
        application.RecordTypeId = recordTypes.get(0).Id;
        update application;

        MatchingComparisonResult__c matchingComparisonResult = new MatchingComparisonResult__c();
        matchingComparisonResult.NewMatter__c = newMatter.Id;
        matchingComparisonResult.IsExceptImportantExplanation__c = true;
        matchingComparisonResult.IsExceptContract__c = false;
        matchingComparisonResult.IsExceptBill__c = false;
        matchingComparisonResult.IsExceptDrawing__c = true;
        insert matchingComparisonResult;

        // マッチング
        List<Matching__c>  matchings = new List<Matching__c>();

        Matching__c matching_1 = new Matching__c(
            Name = 'マッチング比較用_重説',
            NewMatter__c = newMatter.Id,
            PaperType__c = '重説',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_1);

        Matching__c matching_2 = new Matching__c(
            Name = 'マッチング比較用_契約書',
            NewMatter__c = newMatter.Id,
            PaperType__c = '契約書',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_2);

        Matching__c matching_3 = new Matching__c(
            Name = 'マッチング比較用_請求書',
            NewMatter__c = newMatter.Id,
            PaperType__c = '請求書',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_3);

        Matching__c matching_4 = new Matching__c(
            Name = 'マッチング比較用_図面',
            NewMatter__c = newMatter.Id,
            PaperType__c = '図面',
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_4);

        Test.startTest();
        insert matchings;
        Test.stopTest();

        List<MatchingComparisonResult__c> matchingComparisonResults = [SELECT Id FROM MatchingComparisonResult__c WHERE NewMatter__c = :newMatter.Id];
        System.assert(!matchingComparisonResults.isEmpty());
        List<FifthSetConfirm__c> fifthSetConfirms = [SELECT Id FROM FifthSetConfirm__c WHERE NewMatter__c = :newMatter.Id];
        System.assert(!fifthSetConfirms.isEmpty());
    }
    */
}