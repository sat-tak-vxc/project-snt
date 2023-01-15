@isTest
/**
 * @Description: Testing for class TraderSelectionModel.
 * 
 * @author hi-takada
 * @date 2022/01/27
 */

private class TraderSelectionModelTest {
    /**
     * @Description テストレコード作成
     */
    /*
    @testSetup
    static void setup() {
        // カスタム設定を作成
        TraderSelectionTestDataFactory.createTraderSelectionSetting();
        TraderSelectionTestDataFactory.createSyatakusanSetting();
        // 取引先（不動産会社）データ生成
        List<Account> aMCList =
        TraderSelectionTestDataFactory.createAccount_MC_TraderSelection();
        // 申請データ生成
        List<Application__c> applicationList =
            TraderSelectionTestDataFactory.createApplication_TraderSelection();
         //新規データ作成（単一）
        NewMatter__c newMatter =
        TraderSelectionTestDataFactory.createNewMatter_one_TraderSelection(
        ApplicationList.get(0)
        );
    }
*/
    /**
     * @Description 各検索処理
     */
    /*
    @isTest static void eachSearchProcessTest_001() {

        // カスタム設定
        TraderSelectionSetting__c tsSetting = 
            TraderSelectionSetting__c.getOrgDefaults();

        // 新規
        NewMatter__c newMatterData =
            [SELECT Id, Application__r.ApplicantCode__c FROM NewMatter__c LIMIT 1];

        Id contactId = newMatterData.Application__r.ApplicantCode__c;
        Set<Id> contactIds = new Set<Id>();
        contactIds.add(contactId);

        Set<Id> accountIds = new Set<Id>();
        Set<Id> mediationRequestIds = new Set<Id>();
        Set<Id> emptySet = new Set<Id>();
        List<String> accountIdList = new List<String>();
        
        Set<Id> applicationIds = new Set<Id>();
        applicationIds.add(newMatterData.Application__c);
        
        Set<String> states = new Set<String>();
        states.add('神奈川県');

        // 斡旋依頼
        List<MediationRequest__c> mediationRequestDatas = 
            [ SELECT Id, ContractCategory__c, RequestTraderId__c
              FROM MediationRequest__c 
             WHERE NewMatterId__c = :newMatterData.Id];
        for(MediationRequest__c mediationRequestData : mediationRequestDatas){

            accountIds.add(mediationRequestData.RequestTraderId__c);
            mediationRequestIds.add(mediationRequestData.Id);
            accountIdList.add(mediationRequestData.RequestTraderId__c);
        }

        // 新規情報取得（単数） 
        NewMatter__c newMatterOne = 
            TraderSelectionModel.getNewMatter(newMatterData.Id);
        System.assert(String.isNotBlank(newMatterOne.Name));  

        // 取引先担当者取得（単数）
        Contact contactOne = 
            TraderSelectionModel.getContact(contactId);
        System.assert(String.isNotBlank(
            contactOne.CorporateHousingRegulation__c));

        // 都道府県情報取得
        List<District__c> districts = 
            TraderSelectionModel.getDistrictStates();
        System.assert(String.isNotBlank(districts.get(0).State__c));  

        // 斡旋依頼取得（新規ID検索）
        List<MediationRequest__c> mediationRequests = 
            TraderSelectionModel.getMediationRequests(newMatterData.Id);
        System.assert(String.isNotBlank(
            mediationRequests.get(0).RequestTraderId__c));  

        // 斡旋依頼取得（新規ID、取引先（不動産会社）ID検索）
        List<MediationRequest__c> mediationRequestRegistereds = 
            TraderSelectionModel.getMediationRequestRegistereds(
                newMatterData.Id, accountIdList);
        System.assert(String.isNotBlank(
                mediationRequestRegistereds.get(0).ContractCategory__c));

        // 斡旋依頼取得（新規ID、取引先（不動産会社）ID検索）
        List<MediationRequest__c> mediationRequestDeleteOne = 
            TraderSelectionModel.getMediationRequestDelete(
                newMatterData.Id, accountIdList.get(0));
        System.assert(!mediationRequestDeleteOne.isEmpty());

        // 斡旋依頼取得（斡旋依頼ID検索）
        List<MediationRequest__c> mediationRequestRequestIds = 
            TraderSelectionModel.getMediationRequestRequestId(
                mediationRequestIds);
        System.assert(!mediationRequestRequestIds.isEmpty());

        // 斡旋依頼取得（'依頼中'の不動産会社数）
        Map<Id, AggregateResult> mediationRequestAccountCount = 
            TraderSelectionModel.getMediationRequestAccountCount(
                accountIds, tsSetting);
        System.assert(!mediationRequestAccountCount.isEmpty());

        // 斡旋依頼取得（'依頼中'の不動産会社数）
        Map<Id, Account> accountsToAccountId = 
            TraderSelectionModel.getAccounts(
                accountIds, tsSetting);
        System.assert(!accountsToAccountId.isEmpty());
        // （引数空）
        accountsToAccountId = 
        TraderSelectionModel.getAccounts(
            emptySet, tsSetting);
        System.assert(accountsToAccountId.isEmpty());

        // 不動産キャパ取得
        Map<Id, AgencyCapacity__c> agencyCapacitysToAccountId = 
            TraderSelectionModel.getAgencyCapacityToAccountId(accountIds);
        System.assert(!agencyCapacitysToAccountId.isEmpty());
        // （引数空）
        Map<Id, AgencyCapacity__c>  agencyCapacitysToAccountIdEmpty = 
            TraderSelectionModel.getAgencyCapacityToAccountId(emptySet);
        System.assert(agencyCapacitysToAccountIdEmpty.isEmpty());   
        
        // 都道府県、市区郡から紹介可能エリアを取得
        Set<Id> accountIdStateMediationPossibleArea = 
            TraderSelectionModel.getAccountIdStateMediationPossibleArea(
            '神奈川県', '横浜市');
        System.assert(!accountIdStateMediationPossibleArea.isEmpty());
        // （引数空）
        Set<Id> accountIdStateMediationPossibleAreaEmpty = 
            TraderSelectionModel.getAccountIdStateMediationPossibleArea(
                null, null);  
        System.assert(accountIdStateMediationPossibleAreaEmpty.isEmpty());

        // 都道府県、市区郡から紹介可能エリアを取得
        Map<Id, Account> accountInput = 
            TraderSelectionModel.getAccountInput(
            accountIdList.get(0), 'テスト',
            '神奈川県', '横浜市', 
            accountIdStateMediationPossibleArea, tsSetting); 
        System.assert(!accountInput.isEmpty());

        // 市区郡取得
        List<District__c> districtCitys = 
            TraderSelectionModel.getDistrictCitys('神奈川県');
        System.assert(!districtCitys.isEmpty());

        // 希望条件を取得
        DesiredCondition__c desiredCondition = 
            TraderSelectionModel.getDesiredCondition(
                newMatterData.Application__c);

        // 申請情報取得
        Map<Id, Application__c> applications = 
            TraderSelectionModel.getApplications(applicationIds);
        System.assert(!applications.isEmpty());

        // 希望条件を取得
        Map<Id, DesiredCondition__c> desiredConditions = 
            TraderSelectionModel.getDesiredConditions(applicationIds);

        // 取引先担当者を取得
        Map<Id, Contact> contacts = 
            TraderSelectionModel.getContacts(contactIds);

        // 指定不動産会社を取得（都道府県情報）
        List<SpecifyAgency__c> specifyAgencys = 
            TraderSelectionModel.getSpecifyAgencys(states);
        System.assert(!specifyAgencys.isEmpty());

        // 紹介可能エリアを取得（都道府県条件）
        Map<Id, MediationPossibleArea__c> mediationPossibleArea = 
            TraderSelectionModel.getMediationPossibleAreas(states);
        System.assert(!mediationPossibleArea.isEmpty());

        // 取引先を取得（降順）
        List<AgencyCapacity__c> agencyCapacityDesc = 
            TraderSelectionModel.getAgencyCapacityDesc(accountIds);

        System.assert(!agencyCapacityDesc.isEmpty());

    }
*/
    /**
     * @Description 斡旋依頼を登録
     */
    /*
    @isTest
    static void insertMediationRequestTest_001() {

        // 新規
        NewMatter__c newMatterData =
            [SELECT Id, Name FROM NewMatter__c LIMIT 1];
        // 取引先
        Account accountData =
            [SELECT Id, Name FROM Account LIMIT 1];

        // 斡旋依頼
        List<MediationRequest__c>  mediationRequests = new List<MediationRequest__c>();
        MediationRequest__c mediationRequest = new MediationRequest__c(
            Name = 'Test',
            RequestTraderId__c = accountData.Id,
            ContractCategory__c = ''
        );
        mediationRequests.add(mediationRequest);

        TraderSelectionModel.insertMediationRequest(
            mediationRequests);

        System.assert(String.isNotBlank(mediationRequest.Id));  
    }
    */

    /**
     * @Description 斡旋依頼を登録（重複エラー）
     */
    /*
    @isTest
    static void insertMediationRequestTest_002_Error() {

        // 斡旋依頼
        List<MediationRequest__c> mediationRequestCreateDatas =
            [SELECT Id, Name, ContractCategory__c, RequestTraderId__c FROM MediationRequest__c];

        try {
            TraderSelectionModel.insertMediationRequest(
                mediationRequestCreateDatas);
        } catch (Exception e) {
            System.assert(true);
            return;
        }
        System.assert(false); 
    }

*/
    /**
     * @Description TODOを登録
     */
    /*
    @isTest
    static void insertTaskTest_001() {

        // カスタム設定
        TraderSelectionSetting__c tsSetting = 
            TraderSelectionSetting__c.getOrgDefaults();

        // 新規
        NewMatter__c newMatterData =
            [SELECT Id, Name FROM NewMatter__c LIMIT 1];

        List<Task> sendTasks = new List<Task>();

        // 通知情報
        Task sendTask = new Task(
            WhatId = newMatterData.Id, // 関連先
            // WhoId = '', // 名前
            TaskSubtype = tsSetting.TaskSubtype__c , // ToDo のサブ種別
            Status = tsSetting.TaskStatus__c, // 状況
            Priority = tsSetting.TaskPriority__c // 優先度
        );
        sendTasks.add(sendTask);

        TraderSelectionModel.insertTask(
            sendTasks);

        System.assert(String.isNotBlank(sendTask.Id));  
    }
    */

    /**
     * @Description TODOを登録（重複エラー）
     */
    /*
    @isTest
    static void insertTaskTest_002_Error() {

        // カスタム設定
        TraderSelectionSetting__c tsSetting = 
            TraderSelectionSetting__c.getOrgDefaults();

        // 新規
        NewMatter__c newMatterData =
            [SELECT Id, Name FROM NewMatter__c LIMIT 1];

        List<Task> sendTasks = new List<Task>();
            // 新規
        Task taskData =
            [SELECT Id FROM Task LIMIT 1];
        sendTasks.add(taskData);

        try {
            TraderSelectionModel.insertTask(
                sendTasks);
        } catch (Exception e) {
            System.assert(true);
            return;
        }
        System.assert(false); 
    }
*/

    /**
     * @Description 斡旋依頼を登録／更新
     */
    /*
    @isTest
    static void upsertMediationRequestTest_001() {

        // 新規
        NewMatter__c newMatterData =
            [SELECT Id, Name FROM NewMatter__c LIMIT 1];
        // 取引先
        Account accountData =
            [SELECT Id, Name FROM Account LIMIT 1];

        // 斡旋依頼
        List<MediationRequest__c>  mediationRequests = new List<MediationRequest__c>();
        MediationRequest__c mediationRequest = new MediationRequest__c(
            Name = 'Test',
            RequestTraderId__c = accountData.Id,
            ContractCategory__c = ''
        );
        mediationRequests.add(mediationRequest);

        TraderSelectionModel.upsertMediationRequest(
            mediationRequests);

        System.assert(String.isNotBlank(mediationRequest.Id));  
    }*/


    /**
     * @Description 斡旋依頼を更新
     */
    /*
    @isTest
    static void updateMediationRequestTest_001() {

        // 新規
        NewMatter__c newMatterData =
            [SELECT Id, Name FROM NewMatter__c LIMIT 1];
        // 取引先
        Account accountData =
            [SELECT Id, Name FROM Account LIMIT 1];

        // 斡旋依頼
        List<MediationRequest__c>  mediationRequests = new List<MediationRequest__c>();
        MediationRequest__c mediationRequestData = 
            [ SELECT Id, ContractCategory__c, RequestTraderId__c
              FROM MediationRequest__c LIMIT 1];

        mediationRequestData.ContractCategory__c = 'キャンセル';

        mediationRequests.add(mediationRequestData);

        TraderSelectionModel.upsertMediationRequest(
            mediationRequests);

        System.assert(String.isNotBlank(mediationRequestData.Id));  
    }
*/

    /**
     * @Description 斡旋依頼を更新（IDなし更新）
     */
    /*
    @isTest
    static void updateMediationRequestTest_002_Error() {

        // 新規
        NewMatter__c newMatterData =
            [SELECT Id, Name FROM NewMatter__c LIMIT 1];
        // 取引先
        Account accountData =
            [SELECT Id, Name FROM Account LIMIT 1];

        // 斡旋依頼
        List<MediationRequest__c>  mediationRequests = new List<MediationRequest__c>();
        MediationRequest__c mediationRequest = new MediationRequest__c(
            Name = 'Test',
            RequestTraderId__c = accountData.Id,
            ContractCategory__c = ''
        );
        mediationRequests.add(mediationRequest);

        try {
            TraderSelectionModel.updateMediationRequest(
                mediationRequests);
        } catch (Exception e) {
            System.assert(true);
            return;
        }
        System.assert(false); 
    }
*/


    /**
     * @Description 斡旋依頼を削除
     */
    /*
    @isTest
    static void deleteMediationRequestTest_001() {
        

        // 新規
        NewMatter__c newMatterData =
            [SELECT Id, Name FROM NewMatter__c LIMIT 1];
        // 取引先
        Account accountData =
            [SELECT Id, Name FROM Account LIMIT 1];

        // 斡旋依頼
        List<MediationRequest__c>  mediationRequests = new List<MediationRequest__c>();
        MediationRequest__c mediationRequestData = 
            [ SELECT Id, ContractCategory__c, RequestTraderId__c
              FROM MediationRequest__c LIMIT 1];
        Id mediationRequestDataId = mediationRequestData.Id;

        mediationRequests.add(mediationRequestData);
 
        TraderSelectionModel.deleteMediationRequest(
            mediationRequests);
        try {
            // 削除されていること
            mediationRequestData = 
                [ SELECT Id, ContractCategory__c, RequestTraderId__c
                FROM MediationRequest__c WHERE Id = :mediationRequestDataId];
        } catch (Exception e) {
            System.assert(true);
            return;
        }
        System.assert(false); 

    }
*/

    /**
     * @Description 斡旋依頼を削除（IDなし更新）
     */
    /*
    @isTest
    static void deleteMediationRequestTest_002_Error() {

        // 新規
        NewMatter__c newMatterData =
            [SELECT Id, Name FROM NewMatter__c LIMIT 1];
        // 取引先
        Account accountData =
            [SELECT Id, Name FROM Account LIMIT 1];

        // 斡旋依頼
        List<MediationRequest__c>  mediationRequests = new List<MediationRequest__c>();
        MediationRequest__c mediationRequest = new MediationRequest__c(
            Name = 'Test',
            RequestTraderId__c = accountData.Id,
            ContractCategory__c = ''
        );
        mediationRequests.add(mediationRequest);

        try {
            TraderSelectionModel.updateMediationRequest(
                mediationRequests);
        } catch (Exception e) {
            System.assert(true);
            return;
        }
        System.assert(false); 
    }
    
*/
    /**
     * @Description 斡旋依頼を削除
     */
    /*
    @isTest
    static void updateAgencyCapacitysTest_001() {

        // 新規
        NewMatter__c newMatterData =
            [SELECT Id, Name FROM NewMatter__c LIMIT 1];
        // 取引先
        Account accountData =
            [SELECT Id, Name FROM Account LIMIT 1];

        // 斡旋依頼
        List<AgencyCapacity__c>  agencyCapacitys = new List<AgencyCapacity__c>();
        AgencyCapacity__c agencyCapacity = 
            [ SELECT Id, RequestingNum__c
              FROM AgencyCapacity__c LIMIT 1];
        Id agencyCapacityId = agencyCapacity.Id;

        agencyCapacity.RequestingNum__c = 90;
        
        agencyCapacitys.add(agencyCapacity);
 
        TraderSelectionModel.updateAgencyCapacitys(
            agencyCapacitys);

        // 削除されていること
        agencyCapacity = 
            [ SELECT Id, RequestingNum__c
            FROM AgencyCapacity__c WHERE Id = :agencyCapacityId];

        System.assertEquals(90 ,agencyCapacity.RequestingNum__c);
    }
*/

    /**
     * @Description 斡旋依頼を削除（IDなし更新）
     */
    /*
    @isTest
    static void updateAgencyCapacitysTest_002_Error() {

        // 新規
        NewMatter__c newMatterData =
            [SELECT Id, Name FROM NewMatter__c LIMIT 1];
        // 取引先
        Account accountData =
            [SELECT Id, Name FROM Account LIMIT 1];

        // 斡旋依頼
        MediationRequest__c mediationRequestData = 
            [ SELECT Id, ContractCategory__c, RequestTraderId__c
            FROM MediationRequest__c LIMIT 1];

        // 斡旋依頼
        List<AgencyCapacity__c>  agencyCapacitys = new List<AgencyCapacity__c>();
        AgencyCapacity__c agencyCapacity = new AgencyCapacity__c(
            AgencyCapacityId__c = '10000000a',
            Account__c = mediationRequestData.RequestTraderId__c
        );
        agencyCapacitys.add(agencyCapacity);

        try {
            TraderSelectionModel.updateAgencyCapacitys(
                agencyCapacitys);
        } catch (Exception e) {
            System.assert(true);
            return;
        }
        System.assert(false); 
    }
*/
}