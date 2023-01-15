@isTest
public with sharing class ManualTraderSelectionHandlerTest {
    public static Id newMatterId{get; set;}
    @isTest
    public static void createDate(){
        //テストデータ作成
        //カスタム設定
        TraderSelectionTestDataFactory.createSyatakusanSetting();
        TraderSelectionTestDataFactory.createTraderSelectionSetting();

        //取引先(不動産会社)作成
        TraderSelectionTestDataFactory.createAccount_MC_TraderSelection();

        //申請レコード作成
        List<Application__c> applications = TraderSelectionTestDataFactory.createApplication_TraderSelection();
        
        //新規レコード
        List<NewMatter__c> newMatters = TraderSelectionTestDataFactory.createNewMatter_one_TraderSelection(applications);

        NewMatter__c newMatter = newMatters[0];
        System.debug(newMatter);
        newMatterId = newMatter.Id;
        

    }
    @isTest(SeeAllData=true)
    public static void ManualTraderSelectionHandlerTest() {
        system.debug('ManualTraderSelectionHandlerTest BeforeQuerisLimits :'+limits.getQueries());
        //テストデータ作成
        //カスタム設定
        
        //TraderSelectionTestDataFactory.createSyatakusanSetting();
        //TraderSelectionTestDataFactory.createTraderSelectionSetting();
        //取引先(不動産会社)作成
        List<Account> accounts = TraderSelectionTestDataFactory.createAccount_MC_TraderSelection();

        //申請レコード作成
        List<Application__c> applications = TraderSelectionTestDataFactory.createApplication_TraderSelection();
        
        //新規レコード
        List<NewMatter__c> newMatters = TraderSelectionTestDataFactory.createNewMatter_one_TraderSelection(applications);

        NewMatter__c newMatter = newMatters[0];
        System.debug(newMatter);
        newMatterId = newMatter.Id;
        MediationRequest__c mediationRequest = new MediationRequest__c(
            NewMatterId__c = newMatterId , 
            RequestTraderId__c = accounts[0].Id
        ); 
        insert mediationRequest;
        
        List<String> accountIds = new List<String>();
        accountIds.add(String.valueOf(accounts[0].Id));

        Test.startTest();
        ManualTraderSelection.getMediationRequestProcess(newMatterId);

        ManualTraderSelection.searchProcess('' ,'','神奈川県','');

        ManualTraderSelection.upsertMediationRequestProcess(newMatterId,accountIds);

        ManualTraderSelection.updateMediationStatusProcess(newMatterId,accountIds,accountIds[0],'依頼中');
        //ManualTraderSelection.updateMediationStatusProcess(newMatterId,accountIds,accountIds[0],'成約');

        ManualTraderSelection.deleteMediationRequestProcess(newMatterId,accounts[0].Id);

        Test.stopTest();
    }
}