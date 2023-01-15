/**
 * @Description: TestDataactory.
 * 
 * @author hi-takada
 * @date 2022/03/01
 */
@isTest
public class RemoteAccessAuthorityTestDataFactory {

    /**
     * @Description カスタム設定を作成
     * @return `void`
     */
    public static RemoteAccessSetting__c createRemoteAccessSetting(){

        RemoteAccessSetting__c remoteAccessSetting = new RemoteAccessSetting__c();
        remoteAccessSetting.ApexErrorEmailTemplate__c = '00XO0000000l99dMAA';
        remoteAccessSetting.ApexErrorEmailtoAddress__c = 'ml-snt-sfdc@virtualex.co.jp';
        remoteAccessSetting.GroupTypeQueue__c = 'Queue';
        remoteAccessSetting.WorkStyleTypeRemote__c = 'remote';
        remoteAccessSetting.WorkStyleTypeOffice__c = 'office';
        remoteAccessSetting.SearchEventErrorMessage__c = '検索処理に失敗しました。システム管理者へご連絡ください。';
        remoteAccessSetting.OfficeGroupId__c = '00GO000000PNWEvMAP';
        remoteAccessSetting.OfficeGroupMemberResetBatchSize__c = 200;
        remoteAccessSetting.SwitchingOfficeRemoteEventErrorMessage__c = '出社在宅切り替え処理に失敗しました。システム管理者へご連絡ください。';

        insert remoteAccessSetting;

        return remoteAccessSetting;
    }

    /**
     * @Description テストレコード作成
     * @return `List<Section__c>`
     */
    public static List<Section__c> createSections() {

        // セクション
        List<Section__c>  sectionList = new List<Section__c>();

        Section__c section_1 = new Section__c(
            SectionId__c = '00001',
            Name = '入替チーム',
            QueueName__c = '入替チーム'
        );
        sectionList.add(section_1);

        Section__c section_2 = new Section__c(
            SectionId__c = '00002',
            Name = '解約申入チーム',
            QueueName__c = '解約申入チーム'
        );
        sectionList.add(section_2);

        Section__c section_3 = new Section__c(
            SectionId__c = '00003',
            Name = '受付チーム',
            QueueName__c = '受付チーム'
        );
        sectionList.add(section_3);

        insert sectionList;

        return sectionList;

    }


}