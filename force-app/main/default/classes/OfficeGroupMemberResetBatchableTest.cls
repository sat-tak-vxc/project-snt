/**
 * @Description: Testing for class OfficeGroupMemberResetBatchable.
 * 
 * @author hi-takada
 * @date 2022/03/01
 */
@isTest
private class OfficeGroupMemberResetBatchableTest {

    /**
     * @Description テストレコード作成
     */
    @testSetup
    static void setup() {
        // カスタム設定を作成
        RemoteAccessAuthorityTestDataFactory.createRemoteAccessSetting();
        RemoteAccessAuthorityTestDataFactory.createSections();
    }

    @isTest 
    static void executeBatchTest_001() {

        // カスタム設定
        RemoteAccessSetting__c remoteAccessSetting = 
            RemoteAccessSetting__c.getOrgDefaults();
        Test.startTest();
        OfficeGroupMemberResetBatchable batchable = new OfficeGroupMemberResetBatchable();
        Id batchId = Database.executeBatch(batchable);
        Test.stopTest();

    }

    @isTest 
    static void sendErrorEmailTest_001() {

        // カスタム設定
        RemoteAccessSetting__c remoteAccessSetting = 
            RemoteAccessSetting__c.getOrgDefaults();
        Test.startTest();
        RemoteAccessAuthorityControlUtils.sendErrorEmail(
            remoteAccessSetting);
        Test.stopTest();
    }
}