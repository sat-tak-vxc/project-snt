/**
 * @Description: Testing for class MatchingComparison.
 * 
 * @author hi-takada
 * @date 2022/02/15
 */
@isTest
private class MatchingComparisonTest {
    

    /**
     * @Description テストレコード作成
     */
    /*
    @testSetup
    static void setup() {
        // カスタム設定を作成
        TraderSelectionTestDataFactory.createTraderSelectionSetting();
        MatchingComparisonTestDataFactory.createMatchingSetting();
        MatchingComparisonTestDataFactory.createSyatakusanSetting();

        // 取引先（不動産会社）データ生成
        Application__c application =
            TraderSelectionTestDataFactory.createAccount_Mass_TraderSelection(
                1, 'メール');
        // 新規データ作成（単一）
        // NewMatter__c newMatter =
        //     TraderSelectionTestDataFactory.createNewMatter_one_TraderSelection(
        //         application
        //     );

        List<BankAccount__c>  bankAccounts = new List<BankAccount__c>();
        BankAccount__c bankAccount_1 = new BankAccount__c(
            BankAccountId__c = '1',
            BankCode__c = '1111',
            BranchOfficeCode__c = '111',
            DepositType__c = '普通預金',
            // DepositName__c = '普通預金'
            Name = '10001'
        );
        bankAccounts.add(bankAccount_1);
        BankAccount__c bankAccount_4 = new BankAccount__c(
            BankAccountId__c = '9',
            BankCode__c = '9999',
            BranchOfficeCode__c = '999',
            DepositType__c = '普通預金',
            // DepositName__c = '普通預金'
            Name = '90001'
        );
        bankAccounts.add(bankAccount_4);
        insert bankAccounts;
    }
    */
    /**
     * @Description 
     */
    /*
    @isTest
    static void getMatchingTest_001() {

        NewMatter__c newMatter = [SELECT Id FROM NewMatter__c LIMIT 1];

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
            RealEstateName__c = 'テスト物件名2',
            RealEstateNameKana__c = 'テストブッケンメイ2',
            ZipCode__c = '105-0012',
            Room__c = '102',
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
            RealEstateName__c = 'テスト物件名2',
            RealEstateNameKana__c = 'テストブッケンメイ2',
            ZipCode__c = '105-0012',
            Room__c = '102',
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
            RealEstateName__c = 'テスト物件名2',
            RealEstateNameKana__c = 'テストブッケンメイ2',
            ZipCode__c = '105-0012',
            Room__c = '102',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_4);

        insert matchings;

        // // 5点確定
        // List<FifthSetConfirm__c>  fifthSetConfirms = new List<FifthSetConfirm__c>();

        // FifthSetConfirm__c fifthSetConfirm_1 = new FifthSetConfirm__c(
        //     NewMatter__c = newMatter.Id,
        //     RealEstateName__c = 'テスト物件名1',
        //     RealEstateNameKana__c = 'テストブッケンメイ1',
        //     ZipCode__c = '105-0011',
        //     Room__c = '101',
        //     State__c = '東京都',
        //     City__c = '港区',
        //     FloorPlanNum__c = 100,
        //     SecurityDeposit__c = 200,
        //     PenaltyTermStart1__c = Date.parse('2022/02/01')
        // );
        // fifthSetConfirms.add(fifthSetConfirm_1);

        // insert fifthSetConfirms;


        // // マッチング比較結果
        // List<MatchingComparisonResult__c>  matchingComparisonResults = new List<MatchingComparisonResult__c>();

        // MatchingComparisonResult__c matchingComparisonResult_1 = new MatchingComparisonResult__c(
        //     NewMatter__c = newMatter.Id,
        //     RealEstateNameResult__c = true,
        //     RealEstateNameType__c = '自動',
        //     RoomResult__c = true,
        //     RoomType__c = '自動',
        //     StateResult__c = true,
        //     StateType__c = '自動',
        //     CityResult__c = false,
        //     CityType__c = null,
        //     FloorPlanNumResult__c = false,
        //     FloorPlanNumType__c = null,
        //     SecurityDepositResult__c = false,
        //     SecurityDepositType__c = null,
        //     PenaltyTermStart1Result__c = false,
        //     PenaltyTermStart1Type__c = null
        // );
        // matchingComparisonResults.add(matchingComparisonResult_1);

        // insert matchingComparisonResults;


        Test.startTest();
        
        MatchingComparison.DataRelatedObject result =
            MatchingComparison.getMatching(newMatter.Id);


        // // String aa = '[{"actionContents":[],"ContractText":"テスト物件名2","FieldsName":"物件名/駐車場名","id":"RealEstateName","ImportantExplanationText":"テスト物件名1","IsActionContentActive":false,"IsBillEdit":false,"IsContractEdit":false,"IsDrawingEdit":false,"IsImportantExplanationEdit":false,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"自動","ResultValueText":"テスト物件名1"},{"actionContents":[],"ContractText":"102","FieldsName":"号室/区画","id":"Room","ImportantExplanationText":"101","IsActionContentActive":false,"IsBillEdit":false,"IsContractEdit":false,"IsDrawingEdit":false,"IsImportantExplanationEdit":false,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"自動","ResultValueText":"101"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"FieldsName":"都道府県","id":"State","IsActionContentActive":true,"IsBillEdit":false,"IsContractEdit":false,"IsDrawingEdit":false,"IsImportantExplanationEdit":false,"IsResultValueEdit":true,"ResultText":"NG","ResultTypeText":"その他","ResultValueText":"神奈川県"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"埼玉県","FieldsName":"市区","id":"City","ImportantExplanationText":"東京都","IsActionContentActive":true,"IsBillEdit":false,"IsContractEdit":false,"IsDrawingEdit":false,"IsImportantExplanationEdit":false,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"川崎市"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"FieldsName":"間取_数","id":"FloorPlanNum","IsActionContentActive":true,"IsBillEdit":false,"IsContractEdit":false,"IsDrawingEdit":false,"IsImportantExplanationEdit":false,"IsResultValueEdit":true,"ResultText":"NG","ResultTypeText":"その他","ResultValueText":"1"},{"actionContents":[],"ContractText":"1000","FieldsName":"敷金","id":"SecurityDeposit","ImportantExplanationText":"1000","IsActionContentActive":false,"IsBillEdit":false,"IsContractEdit":false,"IsDrawingEdit":false,"IsImportantExplanationEdit":false,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"自動","ResultValueText":"100000"},{"actionContents":[],"ContractText":"2022-01-01","FieldsName":"違約金1_期間始まり","id":"PenaltyTermStart1","ImportantExplanationText":"2022-01-01","IsActionContentActive":false,"IsBillEdit":false,"IsContractEdit":false,"IsDrawingEdit":false,"IsImportantExplanationEdit":false,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"自動","ResultValueText":"2022-01-01"},{"actionContents":[],"FieldsName":"物件名/駐車場名フリガナ","id":"RealEstateNameKana","IsActionContentActive":false,"IsBillEdit":false,"IsContractEdit":false,"IsDrawingEdit":false,"IsImportantExplanationEdit":false,"IsResultValueEdit":false}]';
        // String testJson = '[{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"1","DrawingText":"3","FieldsName":"間取_数","id":"FloorPlanNum","ImportantExplanationText":"2","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"契約書","ResultValueText":"1"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"1","ContractText":"1","FieldsName":"号室/区画","id":"Room","ImportantExplanationText":"111","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"111"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"2345","DrawingText":"2345","FieldsName":"敷金","id":"SecurityDeposit","ImportantExplanationText":"1234","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"2022-02-18","FieldsName":"違約金1_期間始まり","id":"PenaltyTermStart1","ImportantExplanationText":"2022-02-17","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"2022-02-17"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"ああああ","ContractText":"ああああ","DrawingText":"ああああ","FieldsName":"物件名/駐車場名","id":"RealEstateName","ImportantExplanationText":"ああああ","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"ああああ"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"品川区","ContractText":"品川区","FieldsName":"市区","id":"City","ImportantExplanationText":"札幌市","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"その他","ResultValueText":"テスト"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"テストブッケン2","FieldsName":"物件名/駐車場名フリガナ","id":"RealEstateNameKana","ImportantExplanationText":"テストブッケン1","IsBillEdit":false,"IsBillTarget":false,"IsComparison":false,"IsContractEdit":false,"IsContractTarget":false,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":true,"ResultText":"OK","ResultValueText":"","ResultTypeText":"その他"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"東京都","ContractText":"東京都","FieldsName":"都道府県","id":"State","ImportantExplanationText":"北海道","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"北海道"}]';
        
        // MatchingComparison.updateMatching(newMatter.Id, false, testJson);
        // Test.stopTest();

        List<FifthSetConfirm__c> getFifthSetConfirms = 
            [SELECT 
                Id
                , Name
                , NewMatter__c
                , RealEstateName__c
                , RealEstateNameKana__c
                , ZipCode__c
                , Room__c
                , State__c
                , City__c
                , FloorPlanNum__c
                , SecurityDeposit__c
                , PenaltyTermStart1__c
            FROM FifthSetConfirm__c
            WHERE NewMatter__c = :newMatter.Id
            ];

        for (FifthSetConfirm__c fifthSetConfirm : getFifthSetConfirms) {
            System.debug(fifthSetConfirm);
        }


        // マッチング比較結果取得
        List<MatchingComparisonResult__c> getMatchingComparisonResults = 
            [SELECT 
                Id
                , Name
                , NewMatter__c
                , RealEstateNameResult__c
                , RealEstateNameType__c
                , RoomResult__c
                , RoomType__c
                , StateResult__c
                , StateType__c
                , CityResult__c
                , CityType__c
                , FloorPlanNumResult__c
                , FloorPlanNumType__c
                , SecurityDepositResult__c
                , SecurityDepositType__c
                , PenaltyTermStart1Result__c
                , PenaltyTermStart1Type__c
            FROM MatchingComparisonResult__c
            WHERE NewMatter__c = :newMatter.Id
            ];

        for (MatchingComparisonResult__c matchingComparisonResult : getMatchingComparisonResults) {
            System.debug(matchingComparisonResult);
        }

    }
    */
    /**
     * @Description 
     */
    /*
    @isTest
    static void getMatchingTest_002() {

        NewMatter__c newMatter = [SELECT Id FROM NewMatter__c LIMIT 1];

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
            RealEstateName__c = 'テスト物件名2',
            RealEstateNameKana__c = 'テストブッケンメイ2',
            ZipCode__c = '105-0012',
            Room__c = '102',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_2);

        insert matchings;

        // 5点確定
        List<FifthSetConfirm__c>  fifthSetConfirms = new List<FifthSetConfirm__c>();

        FifthSetConfirm__c fifthSetConfirm_1 = new FifthSetConfirm__c(
            NewMatter__c = newMatter.Id,
            RealEstateName__c = 'テスト物件名1',
            RealEstateNameKana__c = 'テストブッケンメイ1',
            ZipCode__c = '105-0011',
            Room__c = '101',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01'),
            ContractMoneyBankAccountBankNum1__c = '1111',
            ContractMoneyBankAccountBranchOfficeNum1__c = '111',
            ContractMoneyBankAccountNum1__c = '10001',
            ContractMoneyBankAccountType1__c = '普通預金',
            ContractMoneyBankAccountBankNum2__c = '2222',
            ContractMoneyBankAccountBranchOfficeNum2__c = '222',
            ContractMoneyBankAccountNum2__c = '20001',
            ContractMoneyBankAccountType2__c = '普通預金',
            // ContractMoneyBankAccountBankNum3__c = '3333',
            // ContractMoneyBankAccountBranchOfficeNum3__c = '333',
            // ContractMoneyBankAccountNum3__c = '30001',
            // ContractMoneyBankAccountType3__c = '普通預金',
            RentBankAccountBankNum__c = '9999',
            RentBankAccountBranchOfficeNum__c = '999',
            RentBankAccountNum__c = '90001',
            RentBankAccountType__c = '普通預金'
        );
        fifthSetConfirms.add(fifthSetConfirm_1);

        insert fifthSetConfirms;

        // マッチング比較結果
        List<MatchingComparisonResult__c>  matchingComparisonResults = new List<MatchingComparisonResult__c>();

        MatchingComparisonResult__c matchingComparisonResult_1 = new MatchingComparisonResult__c(
            NewMatter__c = newMatter.Id,
            RealEstateNameResult__c = true,
            RealEstateNameType__c = '自動',
            RoomResult__c = true,
            RoomType__c = '自動',
            StateResult__c = true,
            StateType__c = '自動',
            CityResult__c = false,
            CityType__c = null,
            FloorPlanNumResult__c = false,
            FloorPlanNumType__c = null,
            SecurityDepositResult__c = false,
            SecurityDepositType__c = null,
            PenaltyTermStart1Result__c = false,
            PenaltyTermStart1Type__c = null
        );
        matchingComparisonResults.add(matchingComparisonResult_1);

        insert matchingComparisonResults;

        Test.startTest();
        
        MatchingComparison.DataRelatedObject result =
            MatchingComparison.getMatching(newMatter.Id);
        Test.stopTest();
    }
    */

    /**
     * @Description 
     */
    /*
    @isTest
    static void getMatchingTest_003() {

        NewMatter__c newMatter = [SELECT Id FROM NewMatter__c LIMIT 1];

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
            RealEstateName__c = 'テスト物件名2',
            RealEstateNameKana__c = 'テストブッケンメイ2',
            ZipCode__c = '105-0012',
            Room__c = '102',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_2);

        insert matchings;

        Test.startTest();
        
        MatchingComparison.DataRelatedObject result =
            MatchingComparison.getMatching(newMatter.Id);
        Test.stopTest();
    }
    */

    /**
     * @Description マッチング元データあり
     */
    /*
    @isTest
    static void updateMatchingTest_001() {

        NewMatter__c newMatter = [SELECT Id FROM NewMatter__c LIMIT 1];

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
            RealEstateName__c = 'テスト物件名2',
            RealEstateNameKana__c = 'テストブッケンメイ2',
            ZipCode__c = '105-0012',
            Room__c = '102',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 100,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_2);

        insert matchings;

        Test.startTest();

        // String testJson = '[{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"1","DrawingText":"3","FieldsName":"間取_数","id":"FloorPlanNum","ImportantExplanationText":"2","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"契約書","ResultValueText":"1"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"1","ContractText":"1","FieldsName":"号室/区画","id":"Room","ImportantExplanationText":"111","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"111"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"2345","DrawingText":"2345","FieldsName":"敷金","id":"SecurityDeposit","ImportantExplanationText":"1234","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"2022-02-18","FieldsName":"違約金1_期間始まり","id":"PenaltyTermStart1","ImportantExplanationText":"2022-02-17","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"2022-02-17"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"ああああ","ContractText":"ああああ","DrawingText":"ああああ","FieldsName":"物件名/駐車場名","id":"RealEstateName","ImportantExplanationText":"ああああ","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"ああああ"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"品川区","ContractText":"品川区","FieldsName":"市区","id":"City","ImportantExplanationText":"札幌市","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"その他","ResultValueText":"テスト"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"テストブッケン2","FieldsName":"物件名/駐車場名フリガナ","id":"RealEstateNameKana","ImportantExplanationText":"テストブッケン1","IsBillEdit":false,"IsBillTarget":false,"IsComparison":false,"IsContractEdit":false,"IsContractTarget":false,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":true,"ResultText":"OK","ResultValueText":"","ResultTypeText":"その他"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"東京都","ContractText":"東京都","FieldsName":"都道府県","id":"State","ImportantExplanationText":"北海道","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"北海道"}]';
        String testJson = '[';
        testJson += '{"ContractText":"1","DrawingText":"3","FieldsName":"間取_数","id":"FloorPlanNum","ImportantExplanationText":"2","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"契約書","ResultValueText":"1"},{"BillText":"1","ContractText":"1","FieldsName":"号室/区画","id":"Room","ImportantExplanationText":"111","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"111"},{"ContractText":"2345","DrawingText":"2345","FieldsName":"敷金","id":"SecurityDeposit","ImportantExplanationText":"1234","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG"},{"ContractText":"2022-02-18","FieldsName":"違約金1_期間始まり","id":"PenaltyTermStart1","ImportantExplanationText":"2022-02-17","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"2022-02-17"},{"BillText":"ああああ","ContractText":"ああああ","DrawingText":"ああああ","FieldsName":"物件名/駐車場名","id":"RealEstateName","ImportantExplanationText":"ああああ","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"ああああ"},{"BillText":"品川区","ContractText":"品川区","FieldsName":"市区","id":"City","ImportantExplanationText":"札幌市","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"その他","ResultValueText":"テスト"},{"ContractText":"テストブッケン2","FieldsName":"物件名/駐車場名フリガナ","id":"RealEstateNameKana","ImportantExplanationText":"テストブッケン1","IsBillEdit":false,"IsBillTarget":false,"IsComparison":false,"IsContractEdit":false,"IsContractTarget":false,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":true,"ResultText":"OK","ResultValueText":"","ResultTypeText":"その他"},{"BillText":"東京都","ContractText":"東京都","FieldsName":"都道府県","id":"State","ImportantExplanationText":"北海道","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"北海道"}';
        testJson += ',{"id":"ContractMoneyBankAccountId1","FieldsName":"契約金送金口座1_ID","ResultValueText":"11111","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBank1","FieldsName":"契約金送金口座1_銀行","ResultValueText":"テスト銀行1","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBankNum1","FieldsName":"契約金送金口座1_銀行番号","ResultValueText":"1111","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBranchOffice1","FieldsName":"契約金送金口座1_支店","ResultValueText":"テスト支店1","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBranchOfficeNum1","FieldsName":"契約金送金口座1_支店番号","ResultValueText":"111","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountType1","FieldsName":"契約金送金口座1_種別","ResultValueText":"普通預金","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountNum1","FieldsName":"契約金送金口座1_番号","ResultValueText":"10001","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountContractor1","FieldsName":"契約金送金口座1_名義","ResultValueText":"テスト名義1","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountContractorKana1","FieldsName":"契約金送金口座1_名義カナ","ResultValueText":"テストメイギ1","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false}';
        testJson += ',{"id":"SecurityDeposit","FieldsName":"敷金","ResultValueText":"1011","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false}';
        testJson += ']';

        MatchingComparison.updateMatching(newMatter.Id, true, false, false, true, true, testJson);
        Test.stopTest();

        List<Matching__c> getMatchings = 
            [SELECT 
                Id
                , Name
                , PaperType__c
                , NewMatter__c
                , RealEstateName__c
                , RealEstateNameKana__c
                , ZipCode__c
                , Room__c
                , State__c
                , City__c
                , FloorPlanNum__c
                , SecurityDeposit__c
                , PenaltyTermStart1__c
            FROM Matching__c
            WHERE NewMatter__c = :newMatter.Id
            ];

        for (Matching__c getMatching : getMatchings) {
            System.debug(getMatching);
        }

    }
    */

    /**
     * @Description マッチング元データなし
     */
    /*
    @isTest
    static void updateMatchingTest_002() {

        NewMatter__c newMatter = [SELECT Id FROM NewMatter__c LIMIT 1];

        Test.startTest();
        // String testJson = '[{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"1","DrawingText":"3","FieldsName":"間取_数","id":"FloorPlanNum","ImportantExplanationText":"2","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"契約書","ResultValueText":"1"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"1","ContractText":"1","FieldsName":"号室/区画","id":"Room","ImportantExplanationText":"111","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"111"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"2345","DrawingText":"2345","FieldsName":"敷金","id":"SecurityDeposit","ImportantExplanationText":"1234","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"2022-02-18","FieldsName":"違約金1_期間始まり","id":"PenaltyTermStart1","ImportantExplanationText":"2022-02-17","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"2022-02-17"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"ああああ","ContractText":"ああああ","DrawingText":"ああああ","FieldsName":"物件名/駐車場名","id":"RealEstateName","ImportantExplanationText":"ああああ","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"ああああ"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"品川区","ContractText":"品川区","FieldsName":"市区","id":"City","ImportantExplanationText":"札幌市","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"その他","ResultValueText":"テスト"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"テストブッケン2","FieldsName":"物件名/駐車場名フリガナ","id":"RealEstateNameKana","ImportantExplanationText":"テストブッケン1","IsBillEdit":false,"IsBillTarget":false,"IsComparison":false,"IsContractEdit":false,"IsContractTarget":false,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":true,"ResultText":"OK","ResultValueText":"","ResultTypeText":"その他"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"東京都","ContractText":"東京都","FieldsName":"都道府県","id":"State","ImportantExplanationText":"北海道","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"北海道"}]';
        String testJson = '[';
        testJson += '{"ContractText":"1","DrawingText":"3","FieldsName":"間取_数","id":"FloorPlanNum","ImportantExplanationText":"2","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"契約書","ResultValueText":"1"},{"BillText":"1","ContractText":"1","FieldsName":"号室/区画","id":"Room","ImportantExplanationText":"111","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"111"},{"ContractText":"2345","DrawingText":"2345","FieldsName":"敷金","id":"SecurityDeposit","ImportantExplanationText":"1234","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG"},{"ContractText":"2022-02-18","FieldsName":"違約金1_期間始まり","id":"PenaltyTermStart1","ImportantExplanationText":"2022-02-17","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"2022-02-17"},{"BillText":"ああああ","ContractText":"ああああ","DrawingText":"ああああ","FieldsName":"物件名/駐車場名","id":"RealEstateName","ImportantExplanationText":"ああああ","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"ああああ"},{"BillText":"品川区","ContractText":"品川区","FieldsName":"市区","id":"City","ImportantExplanationText":"札幌市","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"その他","ResultValueText":"テスト"},{"ContractText":"テストブッケン2","FieldsName":"物件名/駐車場名フリガナ","id":"RealEstateNameKana","ImportantExplanationText":"テストブッケン1","IsBillEdit":false,"IsBillTarget":false,"IsComparison":false,"IsContractEdit":false,"IsContractTarget":false,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":true,"ResultText":"OK","ResultValueText":"","ResultTypeText":"その他"},{"BillText":"東京都","ContractText":"東京都","FieldsName":"都道府県","id":"State","ImportantExplanationText":"北海道","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"北海道"}';
        testJson += ',{"id":"ContractMoneyBankAccountId1","FieldsName":"契約金送金口座1_ID","ResultValueText":"11111","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBank1","FieldsName":"契約金送金口座1_銀行","ResultValueText":"テスト銀行1","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBankNum1","FieldsName":"契約金送金口座1_銀行番号","ResultValueText":"1111","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBranchOffice1","FieldsName":"契約金送金口座1_支店","ResultValueText":"テスト支店1","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBranchOfficeNum1","FieldsName":"契約金送金口座1_支店番号","ResultValueText":"111","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountType1","FieldsName":"契約金送金口座1_種別","ResultValueText":"普通預金","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountNum1","FieldsName":"契約金送金口座1_番号","ResultValueText":"10001","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountContractor1","FieldsName":"契約金送金口座1_名義","ResultValueText":"テスト名義1","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountContractorKana1","FieldsName":"契約金送金口座1_名義カナ","ResultValueText":"テストメイギ1","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false}';
        testJson += ',{"id":"ContractMoneyBankAccountId2","FieldsName":"契約金送金口座2_ID","ResultValueText":"22222","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBank2","FieldsName":"契約金送金口座2_銀行","ResultValueText":"テスト銀行2","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBankNum2","FieldsName":"契約金送金口座2_銀行番号","ResultValueText":"2222","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBranchOffice2","FieldsName":"契約金送金口座2_支店","ResultValueText":"テスト支店2","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBranchOfficeNum2","FieldsName":"契約金送金口座2_支店番号","ResultValueText":"222","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountType2","FieldsName":"契約金送金口座2_種別","ResultValueText":"普通預金","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountNum2","FieldsName":"契約金送金口座2_番号","ResultValueText":"20002","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountContractor2","FieldsName":"契約金送金口座2_名義","ResultValueText":"テスト名義2","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountContractorKana2","FieldsName":"契約金送金口座2_名義カナ","ResultValueText":"テストメイギ2","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false}';
        testJson += ',{"id":"ContractMoneyBankAccountId3","FieldsName":"契約金送金口座3_ID","ResultValueText":"33333","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBank3","FieldsName":"契約金送金口座3_銀行","ResultValueText":"テスト銀行3","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBankNum3","FieldsName":"契約金送金口座3_銀行番号","ResultValueText":"3333","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBranchOffice3","FieldsName":"契約金送金口座3_支店","ResultValueText":"テスト支店3","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBranchOfficeNum3","FieldsName":"契約金送金口座3_支店番号","ResultValueText":"333","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountType3","FieldsName":"契約金送金口座3_種別","ResultValueText":"普通預金","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountNum3","FieldsName":"契約金送金口座3_番号","ResultValueText":"30003","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountContractor3","FieldsName":"契約金送金口座3_名義","ResultValueText":"テスト名義3","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountContractorKana3","FieldsName":"契約金送金口座3_名義カナ","ResultValueText":"テストメイギ3","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false}';
        testJson += ',{"id":"RentBankAccountId","FieldsName":"家賃送金口座_ID","ResultValueText":"99999","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"RentBankAccountBank","FieldsName":"家賃送金口座_銀行","ResultValueText":"テスト銀行9","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"RentBankAccountBankNum","FieldsName":"家賃送金口座_銀行番号","ResultValueText":"9999","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"RentBankAccountBranchOffice","FieldsName":"家賃送金口座_支店","ResultValueText":"テスト支店9","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"RentBankAccountBranchOfficeNum","FieldsName":"家賃送金口座_支店番号","ResultValueText":"999","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"RentBankAccountType","FieldsName":"家賃送金口座_種別","ResultValueText":"普通預金","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"RentBankAccountNum","FieldsName":"家賃送金口座_番号","ResultValueText":"90009","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"RentBankAccountContractor","FieldsName":"家賃送金口座_名義","ResultValueText":"テスト名義9","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"RentBankAccountContractorKana","FieldsName":"家賃送金口座_名義カナ","ResultValueText":"テストメイギ9","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false}';
        testJson += ']';
        
        
        MatchingComparison.updateMatching(newMatter.Id, false, false, false, false, true, testJson);
        Test.stopTest();

        List<Matching__c> getMatchings = 
            [SELECT 
                Id
                , Name
                , PaperType__c
                , NewMatter__c
                , RealEstateName__c
                , RealEstateNameKana__c
                , ZipCode__c
                , Room__c
                , State__c
                , City__c
                , FloorPlanNum__c
                , SecurityDeposit__c
                , PenaltyTermStart1__c
            FROM Matching__c
            WHERE NewMatter__c = :newMatter.Id
            ];

        for (Matching__c getMatching : getMatchings) {
            System.debug(getMatching);
        }

    }
    */

    /**
     * @Description マッチング元データあり + なし
     */
    /*
    @isTest
    static void updateMatchingTest_003() {

        NewMatter__c newMatter = [SELECT Id FROM NewMatter__c LIMIT 1];

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

        insert matchings;


        Test.startTest();
        // String testJson = '[{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"1","DrawingText":"3","FieldsName":"間取_数","id":"FloorPlanNum","ImportantExplanationText":"2","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"契約書","ResultValueText":"1"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"1","ContractText":"1","FieldsName":"号室/区画","id":"Room","ImportantExplanationText":"111","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"111"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"2345","DrawingText":"2345","FieldsName":"敷金","id":"SecurityDeposit","ImportantExplanationText":"1234","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"2022-02-18","FieldsName":"違約金1_期間始まり","id":"PenaltyTermStart1","ImportantExplanationText":"2022-02-17","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"2022-02-17"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"ああああ","ContractText":"ああああ","DrawingText":"ああああ","FieldsName":"物件名/駐車場名","id":"RealEstateName","ImportantExplanationText":"ああああ","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"ああああ"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"品川区","ContractText":"品川区","FieldsName":"市区","id":"City","ImportantExplanationText":"札幌市","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"その他","ResultValueText":"テスト"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"テストブッケン2","FieldsName":"物件名/駐車場名フリガナ","id":"RealEstateNameKana","ImportantExplanationText":"テストブッケン1","IsBillEdit":false,"IsBillTarget":false,"IsComparison":false,"IsContractEdit":false,"IsContractTarget":false,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":true,"ResultText":"OK","ResultValueText":"","ResultTypeText":"その他"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"東京都","ContractText":"東京都","FieldsName":"都道府県","id":"State","ImportantExplanationText":"北海道","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"北海道"}]';
        String testJson = '[';
        testJson += '{"ContractText":"1","DrawingText":"3","FieldsName":"間取_数","id":"FloorPlanNum","ImportantExplanationText":"2","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"契約書","ResultValueText":"1"},{"BillText":"1","ContractText":"1","FieldsName":"号室/区画","id":"Room","ImportantExplanationText":"111","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"111"},{"ContractText":"2345","DrawingText":"2345","FieldsName":"敷金","id":"SecurityDeposit","ImportantExplanationText":"1234","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG"},{"ContractText":"2022-02-18","FieldsName":"違約金1_期間始まり","id":"PenaltyTermStart1","ImportantExplanationText":"2022-02-17","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"2022-02-17"},{"BillText":"ああああ","ContractText":"ああああ","DrawingText":"ああああ","FieldsName":"物件名/駐車場名","id":"RealEstateName","ImportantExplanationText":"ああああ","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"ああああ"},{"BillText":"品川区","ContractText":"品川区","FieldsName":"市区","id":"City","ImportantExplanationText":"札幌市","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"その他","ResultValueText":"テスト"},{"ContractText":"テストブッケン2","FieldsName":"物件名/駐車場名フリガナ","id":"RealEstateNameKana","ImportantExplanationText":"テストブッケン1","IsBillEdit":false,"IsBillTarget":false,"IsComparison":false,"IsContractEdit":false,"IsContractTarget":false,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":true,"ResultText":"OK","ResultValueText":"","ResultTypeText":"その他"},{"BillText":"東京都","ContractText":"東京都","FieldsName":"都道府県","id":"State","ImportantExplanationText":"北海道","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"北海道"}';
        testJson += ',{"id":"ContractMoneyBankAccountId2","FieldsName":"契約金送金口座2_ID","ResultValueText":"22222","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBank2","FieldsName":"契約金送金口座2_銀行","ResultValueText":"テスト銀行2","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBankNum2","FieldsName":"契約金送金口座2_銀行番号","ResultValueText":"2222","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBranchOffice2","FieldsName":"契約金送金口座2_支店","ResultValueText":"テスト支店2","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBranchOfficeNum2","FieldsName":"契約金送金口座2_支店番号","ResultValueText":"222","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountType2","FieldsName":"契約金送金口座2_種別","ResultValueText":"普通預金","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountNum2","FieldsName":"契約金送金口座2_番号","ResultValueText":"20002","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountContractor2","FieldsName":"契約金送金口座2_名義","ResultValueText":"テスト名義2","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountContractorKana2","FieldsName":"契約金送金口座2_名義カナ","ResultValueText":"テストメイギ2","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false}';
        testJson += ']';
        
        MatchingComparison.updateMatching(newMatter.Id, false, false, false, false, true, testJson);
        Test.stopTest();

        List<Matching__c> getMatchings = 
            [SELECT 
                Id
                , Name
                , PaperType__c
                , NewMatter__c
                , RealEstateName__c
                , RealEstateNameKana__c
                , ZipCode__c
                , Room__c
                , State__c
                , City__c
                , FloorPlanNum__c
                , SecurityDeposit__c
                , PenaltyTermStart1__c
            FROM Matching__c
            WHERE NewMatter__c = :newMatter.Id
            ];

        for (Matching__c getMatching : getMatchings) {
            System.debug(getMatching);
        }

    }
    */

    /**
     * @Description マッチング元データあり + なし
     */
    /*
    @isTest
    static void updateMatchingTest_004() {

        NewMatter__c newMatter = [SELECT Id FROM NewMatter__c LIMIT 1];

        // マッチング比較結果
        List<MatchingComparisonResult__c>  matchingComparisonResults = new List<MatchingComparisonResult__c>();
        MatchingComparisonResult__c matchingComparisonResult_1 = new MatchingComparisonResult__c(
            NewMatter__c = newMatter.Id,
            IsExceptImportantExplanation__c = false,
            IsExceptContract__c = false,
            IsExceptBill__c = false,
            IsExceptDrawing__c = false
        );
        matchingComparisonResults.add(matchingComparisonResult_1);

        insert matchingComparisonResults;

        Test.startTest();
        // String testJson = '[{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"1","DrawingText":"3","FieldsName":"間取_数","id":"FloorPlanNum","ImportantExplanationText":"2","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"契約書","ResultValueText":"1"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"1","ContractText":"1","FieldsName":"号室/区画","id":"Room","ImportantExplanationText":"111","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"111"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"2345","DrawingText":"2345","FieldsName":"敷金","id":"SecurityDeposit","ImportantExplanationText":"1234","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"2022-02-18","FieldsName":"違約金1_期間始まり","id":"PenaltyTermStart1","ImportantExplanationText":"2022-02-17","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"2022-02-17"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"ああああ","ContractText":"ああああ","DrawingText":"ああああ","FieldsName":"物件名/駐車場名","id":"RealEstateName","ImportantExplanationText":"ああああ","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"ああああ"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"品川区","ContractText":"品川区","FieldsName":"市区","id":"City","ImportantExplanationText":"札幌市","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"その他","ResultValueText":"テスト"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"テストブッケン2","FieldsName":"物件名/駐車場名フリガナ","id":"RealEstateNameKana","ImportantExplanationText":"テストブッケン1","IsBillEdit":false,"IsBillTarget":false,"IsComparison":false,"IsContractEdit":false,"IsContractTarget":false,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":true,"ResultText":"OK","ResultValueText":"","ResultTypeText":"その他"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"東京都","ContractText":"東京都","FieldsName":"都道府県","id":"State","ImportantExplanationText":"北海道","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"北海道"}]';
        String testJson = '[';
        testJson += '{"ContractText":"1","DrawingText":"3","FieldsName":"間取_数","id":"FloorPlanNum","ImportantExplanationText":"2","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"契約書","ResultValueText":"1"},{"BillText":"1","ContractText":"1","FieldsName":"号室/区画","id":"Room","ImportantExplanationText":"111","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"111"},{"ContractText":"2345","DrawingText":"2345","FieldsName":"敷金","id":"SecurityDeposit","ImportantExplanationText":"1234","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG"},{"ContractText":"2022-02-18","FieldsName":"違約金1_期間始まり","id":"PenaltyTermStart1","ImportantExplanationText":"2022-02-17","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"2022-02-17"},{"BillText":"ああああ","ContractText":"ああああ","DrawingText":"ああああ","FieldsName":"物件名/駐車場名","id":"RealEstateName","ImportantExplanationText":"ああああ","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"ああああ"},{"BillText":"品川区","ContractText":"品川区","FieldsName":"市区","id":"City","ImportantExplanationText":"札幌市","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"その他","ResultValueText":"テスト"},{"ContractText":"テストブッケン2","FieldsName":"物件名/駐車場名フリガナ","id":"RealEstateNameKana","ImportantExplanationText":"テストブッケン1","IsBillEdit":false,"IsBillTarget":false,"IsComparison":false,"IsContractEdit":false,"IsContractTarget":false,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":true,"ResultText":"OK","ResultValueText":"","ResultTypeText":"その他"},{"BillText":"東京都","ContractText":"東京都","FieldsName":"都道府県","id":"State","ImportantExplanationText":"北海道","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"北海道"}';
        testJson += ',{"id":"ContractMoneyBankAccountId2","FieldsName":"契約金送金口座2_ID","ResultValueText":"22222","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBank2","FieldsName":"契約金送金口座2_銀行","ResultValueText":"テスト銀行2","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBankNum2","FieldsName":"契約金送金口座2_銀行番号","ResultValueText":"2222","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBranchOffice2","FieldsName":"契約金送金口座2_支店","ResultValueText":"テスト支店2","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountBranchOfficeNum2","FieldsName":"契約金送金口座2_支店番号","ResultValueText":"222","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountType2","FieldsName":"契約金送金口座2_種別","ResultValueText":"普通預金","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountNum2","FieldsName":"契約金送金口座2_番号","ResultValueText":"20002","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountContractor2","FieldsName":"契約金送金口座2_名義","ResultValueText":"テスト名義2","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false},{"id":"ContractMoneyBankAccountContractorKana2","FieldsName":"契約金送金口座2_名義カナ","ResultValueText":"テストメイギ2","ResultText":"NG","ResultTypeText":"その他","IsBillTarget":false,"IsComparison":false,"IsContractTarget":false,"IsDrawingTarget":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":false}';
        testJson += ']';
        
        MatchingComparison.updateMatching(newMatter.Id, true, false, false, true, false, testJson);
        Test.stopTest();

        List<Matching__c> getMatchings = 
            [SELECT 
                Id
                , Name
                , PaperType__c
                , NewMatter__c
                , RealEstateName__c
                , RealEstateNameKana__c
                , ZipCode__c
                , Room__c
                , State__c
                , City__c
                , FloorPlanNum__c
                , SecurityDeposit__c
                , PenaltyTermStart1__c
            FROM Matching__c
            WHERE NewMatter__c = :newMatter.Id
            ];

        for (Matching__c getMatching : getMatchings) {
            System.debug(getMatching);
        }

    }
    */


    /**
     * @Description 手動マッチング実行
     */
    /*
    @isTest
    static void doManualMatching_001() {
        
        NewMatter__c newMatter = [SELECT Id FROM NewMatter__c LIMIT 1];

        // マッチング
        List<Matching__c>  matchings = new List<Matching__c>();

        Matching__c matching_1 = new Matching__c(
            Name = 'マッチング比較用_重説',
            NewMatter__c = newMatter.Id,
            PaperType__c = '重説',
            RealEstateName__c = 'テスト物件名1', // 比較NG
            RealEstateNameKana__c = 'テストブッケンメイ', // 比較対象外
            ZipCode__c = '105-0011',
            Room__c = '101', // 比較NG
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 1, // 比較NG
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_1);

        Matching__c matching_2 = new Matching__c(
            Name = 'マッチング比較用_契約書',
            NewMatter__c = newMatter.Id,
            PaperType__c = '契約書',
            RealEstateName__c = 'テスト物件名2',
            RealEstateNameKana__c = 'テストブッケンメイ',
            ZipCode__c = '105-0011',
            Room__c = '102',
            State__c = '東京都',
            City__c = '港区',
            FloorPlanNum__c = 2,
            SecurityDeposit__c = 200,
            PenaltyTermStart1__c = Date.parse('2022/02/01')
        );
        matchings.add(matching_2);

        insert matchings;

        Test.startTest();
        String testJson = '[{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"1","DrawingText":"3","FieldsName":"間取_数","id":"FloorPlanNum","ImportantExplanationText":"2","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"契約書","ResultValueText":"1"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"1","ContractText":"1","FieldsName":"号室/区画","id":"Room","ImportantExplanationText":"111","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"111"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"2345","DrawingText":"2345","FieldsName":"敷金","id":"SecurityDeposit","ImportantExplanationText":"1234","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"2022-02-18","FieldsName":"違約金1_期間始まり","id":"PenaltyTermStart1","ImportantExplanationText":"2022-02-17","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"NG","ResultTypeText":"重説","ResultValueText":"2022-02-17"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"ああああ","ContractText":"ああああ","DrawingText":"ああああ","FieldsName":"物件名/駐車場名","id":"RealEstateName","ImportantExplanationText":"ああああ","IsBillEdit":false,"IsBillTarget":true,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"ああああ"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"品川区","ContractText":"品川区","FieldsName":"市区","id":"City","ImportantExplanationText":"札幌市","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"その他","ResultValueText":"テスト"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"ContractText":"テストブッケン2","FieldsName":"物件名/駐車場名フリガナ","id":"RealEstateNameKana","ImportantExplanationText":"テストブッケン1","IsBillEdit":false,"IsBillTarget":false,"IsComparison":false,"IsContractEdit":false,"IsContractTarget":false,"IsDrawingEdit":false,"IsDrawingTarget":false,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":false,"IsResultValueEdit":true,"ResultText":"OK","ResultValueText":"","ResultTypeText":"その他"},{"actionContents":[{"label":"－","name":"blank"},{"label":"重説","name":"important"},{"label":"契約書","name":"contract"},{"label":"請求書","name":"bill"},{"label":"図面","name":"drawing"},{"label":"その他","name":"others"}],"BillText":"東京都","ContractText":"東京都","FieldsName":"都道府県","id":"State","ImportantExplanationText":"北海道","IsBillEdit":false,"IsBillTarget":false,"IsComparison":true,"IsContractEdit":false,"IsContractTarget":true,"IsDrawingEdit":false,"IsDrawingTarget":true,"IsImportantExplanationEdit":false,"IsImportantExplanationTarget":true,"IsResultValueEdit":false,"ResultText":"OK","ResultTypeText":"重説","ResultValueText":"北海道"}]';
        MatchingComparison.doManualMatching(newMatter.Id, false, false, true, true, true, testJson);
        Test.stopTest();

        List<FifthSetConfirm__c> getFifthSetConfirms = 
            [SELECT 
                Id
                , Name
                , NewMatter__c
                , RealEstateName__c
                , RealEstateNameKana__c
                , ZipCode__c
                , Room__c
                , State__c
                , City__c
                , FloorPlanNum__c
                , SecurityDeposit__c
                , PenaltyTermStart1__c
            FROM FifthSetConfirm__c
            WHERE NewMatter__c = :newMatter.Id
            ];

        for (FifthSetConfirm__c fifthSetConfirm : getFifthSetConfirms) {
            System.debug(fifthSetConfirm);
        }


        // マッチング比較結果取得
        List<MatchingComparisonResult__c> getMatchingComparisonResults = 
            [SELECT 
                Id
                , Name
                , NewMatter__c
                , RealEstateNameResult__c
                , RealEstateNameType__c
                , RoomResult__c
                , RoomType__c
                , StateResult__c
                , StateType__c
                , CityResult__c
                , CityType__c
                , FloorPlanNumResult__c
                , FloorPlanNumType__c
                , SecurityDepositResult__c
                , SecurityDepositType__c
                , PenaltyTermStart1Result__c
                , PenaltyTermStart1Type__c
            FROM MatchingComparisonResult__c
            WHERE NewMatter__c = :newMatter.Id
            ];

        for (MatchingComparisonResult__c matchingComparisonResult : getMatchingComparisonResults) {
            System.debug(matchingComparisonResult);
        }


    }
*/
}