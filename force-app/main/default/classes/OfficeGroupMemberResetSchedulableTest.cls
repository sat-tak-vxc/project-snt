/**
 * @Description: Testing for class OfficeGroupMemberResetSchedulable.
 * 
 * @author hi-takada
 * @date 2022/03/01
 */
@isTest
private class OfficeGroupMemberResetSchedulableTest {

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
    static void schedulableTest() {

        // ※指定するクーロン式は、ダミー値
        // Test.stopTest();の後にすぐにスケジュールが実行される
        // String CRON_EXP = '0 0 * * * ?';
      
        Test.startTest();
        String jobId = System.schedule('test', '0 0 * * * ?', new OfficeGroupMemberResetSchedulable());
        Test.stopTest();
    }

}