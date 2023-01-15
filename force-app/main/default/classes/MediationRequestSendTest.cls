@isTest
public with sharing class MediationRequestSendTest {
    @isTest
    public static void DoTest() {
       //カスタム設定
       TraderSelectionTestDataFactory.createSyatakusanSetting();
       TraderSelectionTestDataFactory.createTraderSelectionSetting();

        //取引先(不動産会社)作成
        TraderSelectionTestDataFactory.createAccount_MC_TraderSelection();

        //申請レコード作成
        List<Application__c> applications = TraderSelectionTestDataFactory.createApplication_TraderSelection();

        //新規レコード
        test.startTest();
        List<NewMatter__c> newMatter = TraderSelectionTestDataFactory.createNewMatter_one_TraderSelection(applications);

        RequestTraderDataFactory.createRequestTraders(newMatter[0].Id);
        MediationRequestSend.accountSendNotificationFuture(newMatter[0].Id);
        test.stopTest();
    }
}