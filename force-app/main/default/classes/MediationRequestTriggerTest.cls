/**
 * @Description: Testing for class MediationRequestTrigger.
 * 
 * @author hi-takada
 * @date 2022/01/27
 */
@isTest
private class MediationRequestTriggerTest {


    /**
     * @Description 斡旋依頼トリガ：斡旋依頼登録処理
     */
    /*
    @isTest
    static void onInsertAfterTest_001() {

        // カスタム設定を作成
        TraderSelectionTestDataFactory.createTraderSelectionSetting();
        TraderSelectionTestDataFactory.createSyatakusanSetting();
        // 取引先（不動産会社）データ生成
        List<Account> aMCList =
        TraderSelectionTestDataFactory.createAccount_MC_TraderSelection();
        // 申請データ生成
        List<Application__c> applicationList =
            TraderSelectionTestDataFactory.createApplication_TraderSelection();
        // 新規データ作成（単一）
        // NewMatter__c newMatter =
        // TraderSelectionTestDataFactory.createNewMatter_one_TraderSelection(
        //     applicationList.get(0)
        // );

        Test.startTest();
        // 斡旋依頼
        MediationRequest__c mediationRequest =
            [SELECT Id,NewMatterId__c,RequestTraderId__c, ContractCategory__c 
                FROM MediationRequest__c LIMIT 1];
        // 取引先IDを斡旋依頼から取得
        Id accountId = mediationRequest.RequestTraderId__c;

        // 不動産キャパ
        AgencyCapacity__c agencyCapacity =
            [SELECT Id, RequestingNum__c 
            FROM AgencyCapacity__c WHERE Account__c = :accountId];

        // 登録前斡旋依頼数
        Integer requestingNum = 
            Integer.valueOf(agencyCapacity.RequestingNum__c);


        // 登録斡旋依頼
        List<MediationRequest__c>  insertMediationRequests = new List<MediationRequest__c>();

        MediationRequest__c insertmediationRequest_1 = new MediationRequest__c(
            Name = 'Test_1',
            NewMatterId__c = mediationRequest.NewMatterId__c,
            RequestTraderId__c = accountId,
            ContractCategory__c = '依頼中'
        );
        insertMediationRequests.add(insertmediationRequest_1);
        MediationRequest__c insertmediationRequest_2 = new MediationRequest__c(
            Name = 'Test_2',
            NewMatterId__c = mediationRequest.NewMatterId__c,
            RequestTraderId__c = accountId,
            ContractCategory__c = '依頼中'
        );
        insertMediationRequests.add(insertmediationRequest_2);
        MediationRequest__c insertmediationRequest_3 = new MediationRequest__c(
            Name = 'Test_3',
            NewMatterId__c = mediationRequest.NewMatterId__c,
            RequestTraderId__c = accountId,
            ContractCategory__c = 'キャンセル'
        );
        insertMediationRequests.add(insertmediationRequest_3);
        MediationRequest__c insertmediationRequest_4 = new MediationRequest__c(
            Name = 'Test_4',
            NewMatterId__c = mediationRequest.NewMatterId__c,
            RequestTraderId__c = accountId,
            ContractCategory__c = null
        );
        insertMediationRequests.add(insertmediationRequest_4);

        // 斡旋依頼を削除
        insert insertMediationRequests;

        // 不動産キャパ再取得
        agencyCapacity =
            [SELECT Id, RequestingNum__c 
            FROM AgencyCapacity__c WHERE Account__c = :accountId];

        // 斡旋依頼数が異なることを確認
        System.assertNotEquals(requestingNum, 
            Integer.valueOf(agencyCapacity.RequestingNum__c));
        Test.stopTest();
    }
*/

    /**
     * @Description 斡旋依頼トリガ：斡旋依頼変更処理
     */
    /*
    @isTest
    static void onUpdateAfterTest_001() {

        // カスタム設定を作成
        TraderSelectionTestDataFactory.createTraderSelectionSetting();
        TraderSelectionTestDataFactory.createSyatakusanSetting();
        // 取引先（不動産会社）データ生成
        List<Account> aMCList =
        TraderSelectionTestDataFactory.createAccount_MC_TraderSelection();
        // 申請データ生成
        List<Application__c> applicationList =
            TraderSelectionTestDataFactory.createApplication_TraderSelection();
        // 新規データ作成（単一）
        // NewMatter__c newMatter =
        // TraderSelectionTestDataFactory.createNewMatter_one_TraderSelection(
        //     applicationList.get(0)
        // );

        Test.startTest();
        // 斡旋依頼
        MediationRequest__c mediationRequest =
            [SELECT Id, RequestTraderId__c, ContractCategory__c 
                FROM MediationRequest__c LIMIT 1];
        // 取引先IDを斡旋依頼から取得
        Id accountId = mediationRequest.RequestTraderId__c;

        // 不動産キャパ
        AgencyCapacity__c agencyCapacity =
            [SELECT Id, RequestingNum__c 
            FROM AgencyCapacity__c WHERE Account__c = :accountId];

        // 削除前斡旋依頼数
        Integer requestingNum = 
            Integer.valueOf(agencyCapacity.RequestingNum__c);

        // 斡旋依頼を更新
        mediationRequest.ContractCategory__c = 'キャンセル';
        update mediationRequest;

        // 不動産キャパ再取得
        agencyCapacity =
            [SELECT Id, RequestingNum__c 
            FROM AgencyCapacity__c WHERE Account__c = :accountId];

        // 斡旋依頼数が異なることを確認
        System.assertNotEquals(requestingNum, 
            Integer.valueOf(agencyCapacity.RequestingNum__c));
        Test.stopTest();

    }
*/
    /**
     * @Description 斡旋依頼トリガ：斡旋依頼削除処理 
     */
    /*
    @isTest
    static void onDeleteAfterTest_001() {
        // カスタム設定を作成
        TraderSelectionTestDataFactory.createTraderSelectionSetting();
        TraderSelectionTestDataFactory.createSyatakusanSetting();
        // 取引先（不動産会社）データ生成
        List<Account> aMCList =
        TraderSelectionTestDataFactory.createAccount_MC_TraderSelection();
        // 申請データ生成
        List<Application__c> applicationList =
            TraderSelectionTestDataFactory.createApplication_TraderSelection();
        // 新規データ作成（単一）
        // NewMatter__c newMatter =
        //     TraderSelectionTestDataFactory.createNewMatter_one_TraderSelection(
        //         applicationList.get(0)
        //     );

        Test.startTest();

        // 斡旋依頼
        MediationRequest__c mediationRequest =
            [SELECT Id, RequestTraderId__c, ContractCategory__c 
                FROM MediationRequest__c LIMIT 1];
        // 取引先IDを斡旋依頼から取得
        Id accountId = mediationRequest.RequestTraderId__c;
        
        // 不動産キャパ
        AgencyCapacity__c agencyCapacity =
            [SELECT Id, RequestingNum__c 
            FROM AgencyCapacity__c WHERE Account__c = :accountId];

        // 削除前斡旋依頼数
        Integer requestingNum = 
            Integer.valueOf(agencyCapacity.RequestingNum__c);

        // 斡旋依頼を削除
        delete mediationRequest;

        // 不動産キャパ再取得
        agencyCapacity =
            [SELECT Id, RequestingNum__c 
            FROM AgencyCapacity__c WHERE Account__c = :accountId];

        // 斡旋依頼数が異なることを確認
        System.assertNotEquals(requestingNum, 
            Integer.valueOf(agencyCapacity.RequestingNum__c));
        Test.stopTest();
    }
*/

    /**
     * @Description 斡旋依頼トリガ：斡旋依頼削除処理 （複数）
     */
    /*
    @isTest
    static void onDeleteAfterTest_002() {

        // カスタム設定を作成
        TraderSelectionTestDataFactory.createTraderSelectionSetting();
        TraderSelectionTestDataFactory.createSyatakusanSetting();
        // 取引先（不動産会社）データ生成
        List<Account> aMCList =
        TraderSelectionTestDataFactory.createAccount_MC_TraderSelection();
        // 申請データ生成
        List<Application__c> applicationList =
            TraderSelectionTestDataFactory.createApplication_TraderSelection();
        // 新規データ作成（複数）
        // List<NewMatter__c> newMatter =
        // TraderSelectionTestDataFactory.createNewMatter_TraderSelection(
        //     applicationList
        // );

        Test.startTest();
        // 斡旋依頼
        list<MediationRequest__c> mediationRequests =
            [SELECT Id, RequestTraderId__c, ContractCategory__c 
                FROM MediationRequest__c ];
        // 取引先IDを斡旋依頼から取得
        Id accountId = mediationRequests.get(0).RequestTraderId__c;

        // 不動産キャパ
        AgencyCapacity__c agencyCapacity =
            [SELECT Id, RequestingNum__c 
            FROM AgencyCapacity__c WHERE Account__c = :accountId];

        // 削除前斡旋依頼数
        Integer requestingNum = 
            Integer.valueOf(agencyCapacity.RequestingNum__c);

        // 斡旋依頼を削除
        delete mediationRequests;

        // 不動産キャパ再取得
        agencyCapacity =
            [SELECT Id, RequestingNum__c 
            FROM AgencyCapacity__c WHERE Account__c = :accountId];

        // 斡旋依頼数が異なることを確認
        System.assertNotEquals(requestingNum, 
            Integer.valueOf(agencyCapacity.RequestingNum__c));
        Test.stopTest();

    }
*/
}