/**
 * @Description: Testing for class RemoteAccessAuthorityControl.
 * 
 * @author hi-takada
 * @date 2022/03/01
 */
@isTest
private class RemoteAccessAuthorityControlTest {

    /**
     * @Description テストレコード作成
     */
    @testSetup
    static void setup() {
        // カスタム設定を作成
        RemoteAccessAuthorityTestDataFactory.createRemoteAccessSetting();
        RemoteAccessAuthorityTestDataFactory.createSections();
    }
    

    /**
     * @Description 
     */
    @isTest
    static void getSectionsTest_001() {
        Test.startTest();
        RemoteAccessAuthorityControl.getSections();
        Test.stopTest();
    }

    /**
     * @Description 
     */
    @isTest
    static void searchTest_001() {
        List<User> userInfo = 
            [SELECT 
                Id
            FROM User
            ];

        for (User user : userInfo) {
            System.debug(user);
        }

        Group groupInfo = 
            [SELECT 
                Id
            FROM Group
            WHERE Id = '00GO000000PNWEvMAP'
            ];

        List<GroupMember> groupMemberInfos = 
            [SELECT 
                Id,
                GroupId
            FROM GroupMember
            WHERE GroupId = :groupInfo.Id
            ];

        for (GroupMember groupMemberInfo : groupMemberInfos) {
            System.debug(groupMemberInfo);
        }

        List<Section__c> sections = 
            [SELECT 
                Id
            FROM Section__c
            ];

        for (Section__c section : sections) {
            System.debug(section);
        }

        Test.startTest();
        RemoteAccessAuthorityControl.search(
            null, // 従業員番号
            null, // 氏名
            null, // セクション
            null  // 勤務形態
        );
        Test.stopTest();


    


    }

    /**
     * @Description 
     */
    @isTest
    static void searchTest_002() {
        Test.startTest();
        RemoteAccessAuthorityControl.search(null, '', null, 'remote');
        Test.stopTest();

        Group groupInfo = 
            [SELECT 
                Id
            FROM Group
            WHERE Id = '00GO000000PNWEvMAP'
            ];
    
        List<GroupMember> groupMemberInfos = 
            [SELECT 
                Id,
                GroupId
            FROM GroupMember
            WHERE GroupId = :groupInfo.Id
            ];

        for (GroupMember groupMemberInfo : groupMemberInfos) {
            System.debug(groupMemberInfo);
        }

    }

    /**
     * @Description 
     */
    @isTest
    static void searchTest_003() {
        Test.startTest();
        RemoteAccessAuthorityControl.search(null, null, '解約申入チーム', null);
        Test.stopTest();

        Group groupInfo = 
            [SELECT 
                Id
            FROM Group
            WHERE Id = '00GO000000PNWEvMAP'
            ];
    
        List<GroupMember> groupMemberInfos = 
            [SELECT 
                Id,
                GroupId
            FROM GroupMember
            WHERE GroupId = :groupInfo.Id
            ];

        for (GroupMember groupMemberInfo : groupMemberInfos) {
            System.debug(groupMemberInfo);
        }

    }

    /**
     * @Description 
     */
    @isTest
    static void switchingOfficeRemoteTest_001() {

        String testJson = '[';
        testJson += '{"id": "005O0000007VGlCIAW","WorkStyleType": "office"}';
        testJson += ', {"id": "0055h000003EsmxAAC","WorkStyleType": "remote"}';
        testJson += ']';

        Test.startTest();
        RemoteAccessAuthorityControl.switchingOfficeRemote(testJson, null, '', null, 'office');
        Test.stopTest();

    }

}