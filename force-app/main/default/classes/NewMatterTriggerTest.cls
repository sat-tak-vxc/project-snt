/**
 * @Description: Testing for class NewMatterTrigger.
 * 
 * @author hi-takada
 * @date 
 */
@isTest
private class NewMatterTriggerTest {

    /**
     * @Description テストレコード作成
     */
    @testSetup
    static void setup() {
    }

    /**
     * @Description 新規トリガ：登録処理（単一）
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
        Test.startTest();
        // 新規データ作成（単一）
        // NewMatter__c newMatter =
        //     TraderSelectionTestDataFactory.createNewMatter_one_TraderSelection(
        //         applicationList.get(0)
        //     );
        Test.stopTest();

        // 新規
        List<NewMatter__c> newMatterCreateData =
            [SELECT Id, Name FROM NewMatter__c];
        for (NewMatter__c nMCD : newMatterCreateData) {
            System.debug(nMCD);
        }
        System.assertEquals(3, newMatterCreateData.size());

        // 斡旋依頼
        List<MediationRequest__c> mediationRequestCreateDatas =
            [SELECT Id, Name, ContractCategory__c, RequestTraderId__c FROM MediationRequest__c];
        for (MediationRequest__c mRCD : mediationRequestCreateDatas) {
            System.debug(mRCD);
        }
        System.assertEquals(16, mediationRequestCreateDatas.size());

        // Task
        List<Task> taskCreateDatas = [SELECT Id, Subject FROM Task];
        for (Task tCD : taskCreateDatas) {
            System.debug(tCD);
        }
        // System.assert(mediationRequestCreateDatas.size() <=
        //      taskCreateDatas.size());
    }
*/

    /**
     * @Description 新規トリガ：登録処理（複数）
     */
    /*
    @isTest
    static void onInsertAfterTest_002() {

        // カスタム設定を作成
        TraderSelectionTestDataFactory.createTraderSelectionSetting();
        TraderSelectionTestDataFactory.createSyatakusanSetting();
        // 取引先（不動産会社）データ生成
        List<Account> aMCList =
            TraderSelectionTestDataFactory.createAccount_MC_TraderSelection();
        // 申請データ生成
        List<Application__c> applicationList =
            TraderSelectionTestDataFactory.createApplication_TraderSelection();
        
        Test.startTest();
        // 新規データ作成（複数）
        // List<NewMatter__c> newMatter =
        //     TraderSelectionTestDataFactory.createNewMatter_TraderSelection(
        //         applicationList
        //     );
        Test.stopTest();

        // 新規
        List<NewMatter__c> newMatterCreateDatas =
            [SELECT Id, Name FROM NewMatter__c];
        for (NewMatter__c nMCD : newMatterCreateDatas) {
            System.debug(nMCD);
        }
        System.assertEquals(3, newMatterCreateDatas.size());

        // 斡旋依頼
        List<MediationRequest__c> mediationRequestCreateDatas =
            [SELECT Id, Name, ContractCategory__c, RequestTraderId__c 
            FROM MediationRequest__c];
        for (MediationRequest__c mRCD : mediationRequestCreateDatas) {
            System.debug(mRCD);
        }
        System.assertEquals(16, mediationRequestCreateDatas.size());

    }
*/

    /**
     * @Description 新規トリガ：登録処理（大量データ）
     */
    /*
    @isTest
    
    static void onInsertAfterTest_003() {        

        // カスタム設定を作成
        TraderSelectionTestDataFactory.createTraderSelectionSetting();
        TraderSelectionTestDataFactory.createSyatakusanSetting();
        // 取引先（不動産会社）データ生成
        Application__c application =
            TraderSelectionTestDataFactory.createAccount_Mass_TraderSelection(
                5, 'メール');
        Test.startTest();
        // 新規データ作成（単一）
        // NewMatter__c newMatter =
        //     TraderSelectionTestDataFactory.createNewMatter_one_TraderSelection(
        //         application
        //     );
        Test.stopTest();

        // 斡旋依頼
        List<MediationRequest__c> mediationRequestCreateDatas =
            [SELECT Id, Name, ContractCategory__c, RequestTraderId__c 
            FROM MediationRequest__c];

        System.assertEquals(5, mediationRequestCreateDatas.size());

    }
*/
    /**
     * @Description 新規トリガ：登録処理（大量データ）
     */
    /*
    @isTest
    static void onInsertAfterTest_004() {  

        // カスタム設定を作成
        TraderSelectionTestDataFactory.createTraderSelectionSetting();
        TraderSelectionTestDataFactory.createSyatakusanSetting();
        // 取引先（不動産会社）データ生成
        Application__c application =
            TraderSelectionTestDataFactory.createAccount_Mass_TraderSelection(
                190, 'Chatter');
        Test.startTest();

        // ※テスト内でチャターにアクセスするConnectApiを使用するとエラーが発生する

        // 新規データ作成（単一）
        // NewMatter__c newMatter =
        //     TraderSelectionTestDataFactory.createNewMatter_one_TraderSelection(
        //         application
        //     );
        Test.stopTest();

        // 斡旋依頼
        List<MediationRequest__c> mediationRequestCreateDatas =
            [SELECT Id, Name, ContractCategory__c, RequestTraderId__c 
            FROM MediationRequest__c];

        System.assertEquals(190, mediationRequestCreateDatas.size());

    }
    */
    /**
     * @Description 新規トリガ：異常
     */
    /*
    @isTest
    static void onInsertAfterTest_005_E() {        

        // カスタム設定を作成
        TraderSelectionSetting__c traderSelectionSetting = 
            TraderSelectionTestDataFactory.createTraderSelectionSetting();
        TraderSelectionTestDataFactory.createSyatakusanSetting();
        // エラー発生のため修正
        traderSelectionSetting.TaskSubtype__c = 'XXXXXXXXXXXXXXXXXXXX';
        traderSelectionSetting.TaskStatus__c = 'XXXXXXXXXXXXXXXXXXXX';
        traderSelectionSetting.TaskPriority__c = 'XXXXXXXXXXXXXXXXXXXX';
        update traderSelectionSetting;

        // 取引先（不動産会社）データ生成
        List<Account> aMCList =
        TraderSelectionTestDataFactory.createAccount_MC_TraderSelection();
        Test.startTest();
        try {
        // 申請データ生成
        List<Application__c> applicationList =
            TraderSelectionTestDataFactory.createApplication_TraderSelection();

        // Test.startTest();
        // try {

            // 新規データ作成（単一）
            // NewMatter__c newMatter =
            //     TraderSelectionTestDataFactory.createNewMatter_one_TraderSelection(
            //     applicationList.get(0)
            // );

        } catch (Exception e) {
            System.assert(false);
            return;
        }
        System.assert(true);
        Test.stopTest();
    }

*/
}