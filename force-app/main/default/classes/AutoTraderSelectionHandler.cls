/**
 * @description トリガ：新規
 * 
 * @author hi-takada
 * @date 2022/01/17
 */
public with sharing class AutoTraderSelectionHandler{

    
    /**
     * @description 新規登録後処理、自動斡旋依頼選定
     * 
     * @param news 登録後の新規のリスト
     * @return void
     */
    public void autoTraderSelection(List<NewMatter__c> news) {
        //新規レコード
        NewMatter__c newMatter = news[0];

        //斡旋依頼送信クラス
        RequestTraderAutoTraderSelection rtats = new RequestTraderAutoTraderSelection();
        rtats.newMatter = newMatter;//新規

        
        //NewMatter__cレコード情報からレコード情報を取得
        System.debug('---Start process to get the data ---');
        Application__c application = new Application__c();
        DesiredCondition__c desiredCondition = new DesiredCondition__c();
        Account account = new Account();
        CorporateHousingRegulation__c corporateHousingRegulation = new CorporateHousingRegulation__c();
        Contact contact = new Contact();
        Set<SpecifyAgency__c> specifyAgencys = new Set<SpecifyAgency__c>();
        Map<Id,MediationPossibleArea__c> mediationPossibleAreas = new Map<Id,MediationPossibleArea__c>();
        List<AgencyCapacity__c> agencyCapacitys = new List<AgencyCapacity__c>();

        try {
            
            // 新規から申請Idを取得
            Id applicationId = newMatter.Application__c;

            // 申請を取得
            // 条件：新規．申請
            application = AutoTraderSelectionModel.getApplicationWhereId(applicationId);
            System.debug('get Application__c');
            System.debug('applicationId:'+application.Id);
            System.debug('application:'+application);

            // 希望条件を取得 条件：新規ID
            desiredCondition = 
                AutoTraderSelectionModel.getDesiredConditionWhereApplicationId(applicationId);
            System.debug('get DesiredCondition__c');
            System.debug('desiredCondition.Id:'+desiredCondition.Id);
            System.debug('desiredCondition:'+desiredCondition);
           
            // 取引先IDから取引先（企業）を取得
            account = TraderSelectionModel.getAccount(application.Account__c);
            System.debug('get Account');
            System.debug('account.Id:'+account.Id);
            System.debug('account:'+account);

            //社宅規定を取得
            corporateHousingRegulation = 
                TraderSelectionModel.getCorporateHousingRegulation(application.Account__c);
            System.debug('get CorporateHousingRegulation__c');
            System.debug('corporateHousingRegulation.Id:'+corporateHousingRegulation.Id);
            System.debug('corporateHousingRegulation:'+corporateHousingRegulation);

            //申請社員(取引先担当者) を取得
            contact = AutoTraderSelectionModel.getContact(application.ApplicantCode__c);
            System.debug('get Contact');
            System.debug('contact.Id:'+contact.Id);
            System.debug('contact:'+contact);

            //指定不動産会社を取得
            specifyAgencys = AutoTraderSelectionModel.getspecifyAgencys(corporateHousingRegulation.Id);
            System.debug('get SpecifyAgency__c');
            Integer logCount = 1;
            for(SpecifyAgency__c specifyAgency:specifyAgencys){
                System.debug('logCount:'+logCount);
                logCount++;
                System.debug('specifyAgency.Id:'+specifyAgency.Id);
                System.debug('specifyAgency:'+specifyAgency);
            }

            //紹介可能エリアを取得
            mediationPossibleAreas = AutoTraderSelectionModel.getMediationPossibleAreas(application.DesiredAreaState__c , application.MovingAreaCity__c);
            logCount = 1;
            for(Id id:mediationPossibleAreas.keyset()){
                System.debug('logCount:'+logCount);
                logCount++;
                System.debug('specifyAgency.Id:'+id);
                System.debug('specifyAgency:'+mediationPossibleAreas.get(id));
            }

            //不動産キャパを取得
            agencyCapacitys = AutoTraderSelectionModel.getAgencyCapacityDesc(mediationPossibleAreas.keyset());
            logCount = 1;
            for(AgencyCapacity__c agencyCapacity:agencyCapacitys){
                System.debug('logCount:'+logCount);
                logCount++;
                System.debug('agencyCapacity.Id:'+agencyCapacity.Id);
                System.debug('agencyCapacity:'+agencyCapacity);
            }


        } catch (Exception e) {
            // 例外が発生した場合、新規ユーザへTODOを通知
            createErrorMessageTaskItem(rtats);
            // エラー通知内容を通知する
            System.debug(e);
        }
        System.debug('---End process to get the data ---');

        //アラートメッセージチェック
        TraderSelectionSetting__c tsSetting = 
            TraderSelectionSetting__c.getOrgDefaults();  // カスタム設定
        if(!(String.isBlank(application.AlertMessage__c))){
            CreateTask createTask = new CreateTask();
            createTask.OwnerId = newMatter.Staff__c;
            createTask.addLnDescription(tsSetting.AlertMessageToDoText__c);
            createTask.createTask();
        }

        //新規レコード登録後以下の条件で自動選定を行わない。
        //・物件の斡旋を希望していない
        //・物件が既に決まっている。
        if(application.MediationRequest__c == False ||
            application.RealEstate1__c != null ||
            application.RealEstate2__c != null ||
            application.RealEstate3__c != null){
            return;
        }
        //以降：自動選定を実施する場合の処理

        //斡旋依頼クラスに取得したレコード情報を格納
        rtats.application = application;//申請
        rtats.desiredCondition = desiredCondition;//希望条件
        rtats.account = account; //取引先
        rtats.corporateHousingRegulation = corporateHousingRegulation;//社宅規定
        rtats.contact = contact;//取引先担当者
        rtats.specifyAgencys = specifyAgencys;//指定不動産会社
        rtats.mediationPossibleAreas = mediationPossibleAreas;//紹介可能エリア
        rtats.agencyCapacitys = agencyCapacitys; //不動産キャパ


        // 申請レコードから希望エリア_都道府県を格納
        Set<String> states = new Set<String>(); // 都道府県リスト
        if (String.isNotBlank(application.DesiredAreaState__c)){ //申請レコードに希望エリア_都道府県があれば都道府県リストに追加する。
            states.add(application.DesiredAreaState__c);
        }


        // 斡旋依頼登録情報に指定不動産会社から不動産会社を選定し格納
        rtats.setSelectionSpecifyAgencyAccount();
        System.debug('setSelectionSpecifyAgencyAccount');
        
        // 斡旋依頼登録情報に紹介可能エリアと不動産キャパから不動産会社を選定し格納
        rtats.setSelectionMediationPossibleAreaAccount();
        System.debug('doTraderSelectionInsert');

        //選定業者から斡旋依頼レコードのSObjectを作成する。
        Set<MediationRequest__c> mediationRequests = createMediationRequests(
            rtats.mediationCompanyIds,
            newMatter.Id,
            desiredCondition.Id
            );
        
        //斡旋依頼送信を行うかの判定
        Boolean checkSendIsRequestResult = checkSendIsRequestTraderAutoTraderSelection(rtats);
        if(checkSendIsRequestResult){
            //斡旋依頼の送信

        }
        //斡旋依頼レコードの作成
        AutoTraderSelectionModel.insertMediationRequest(new List<MediationRequest__c>(mediationRequests));
        System.debug('CreatemediationCompanyIds');
        //新規レコードの更新
        //ToDoの作成

        //

        //斡旋依頼レコード作成処理
        try{
            // 登録内容作成
            List<MediationRequest__c> mediationRequestsq = doTraderSelectionInsert(rtats);
            
            // 登録内容を通知
            //MediationRequestSend.accountSendNotification(mediationRequests);
   
        } catch (Exception e) {
            // 例外が発生した場合、新規ユーザへTODOを通知

            // エラー通知内容を通知する
            createErrorMessageTaskItem(rtats);
        }
    }
    /**
     * @description 斡旋依頼を自動送信するかどうかをBoolenで返す。送信しない場合は、理由を完了済みToDoで作成する。
     * @param rtats 
     * @return  `Boolean`
     */
    private Boolean checkSendIsRequestTraderAutoTraderSelection(
        RequestTraderAutoTraderSelection rtats
    ){
        Boolean result = true;

         // カスタム設定
         TraderSelectionSetting__c tsSetting = 
         TraderSelectionSetting__c.getOrgDefaults();

        CreateTask createTask = new CreateTask();

        createTask.OwnerId = rtats.newMatter.Staff__c;

        createTask.addLnDescription(tsSetting.MediationRequestsStopCause__c);

        //斡旋自動対応不可フラグ
        System.debug('rtats.account.ServiceContractNewMatter__r.IsAutoMediationRequest__c:'+rtats.account.ServiceContractNewMatter__r.IsAutoMediationRequest__c);
        if((rtats.account.ServiceContractNewMatter__r.IsAutoMediationRequest__c)){
            result = false;
            createTask.addLnDescription(tsSetting.StopCauseIsAutoMediationRequest__c);
        }
        //SNT連絡事項チェック
        if(!(String.isBlank(rtats.application.ToSNTComment__c))){
            result = false;
            createTask.addLnDescription(tsSetting.StopCauseToSNTComment__c);
        }
         //希望不動産会社チェック
         if(!(String.isBlank(rtats.application.DesiredAgency__c))){
            result = false;
            createTask.addLnDescription(tsSetting.StopCauseDesiredAgency__c);
        }
         //エラーメッセージチェック
         if(!(String.isBlank(rtats.application.ErrorMessage__c))){
            result = false;
            createTask.addLnDescription(tsSetting.StopCauseErrorMessage__c);
        }
        
        if(!result){
            createTask.OwnerId = rtats.newMatter.Staff__c;
            createTask.createTask();
        }
        return result;
    }
    
    /**
     * @description 選定業者から斡旋依頼レコードのSobjectを作成する。
     * 
     * @param accountIds 
     * @param newMatterId 
     * @param desiredConditionId 
     * @return  `Set<MediationRequest__c>`
     */
    private Set<MediationRequest__c> createMediationRequests(
        Set<Id> accountIds,
        Id newMatterId,
        Id desiredConditionId
    ){
        Set<MediationRequest__c> result = new Set<MediationRequest__c>();
        // 取得した取引先（不動産会社）から斡旋依頼を生成
        for (Id companyId : accountIds){
            MediationRequest__c newMediationRequest = new MediationRequest__c(
                //Name = rtats.newMatter.Name,
                RequestTraderId__c = companyId, // 依頼業者名
                NewMatterId__c = newMatterId, // 新規ＩＤ
                ContractCategory__c = '依頼前', // 成約区分
                DesiredCondition__c = desiredConditionId // 希望条件
            );
            result.add(newMediationRequest);
        }
        return result;
    }

    /**
     * @description 斡旋依頼登録情報から、斡旋依頼、TODOを登録する
     * 
     * @param rtatss 斡旋依頼登録情報
     * @return `List<MediationRequest__c>`
     */
    private List<MediationRequest__c>  doTraderSelectionInsert(
        RequestTraderAutoTraderSelection rtats) {
    
        // カスタム設定　OK
        TraderSelectionSetting__c tsSetting = 
            TraderSelectionSetting__c.getOrgDefaults();  

        List<MediationRequest__c> mediationRequests = new List<MediationRequest__c>();
        List<Task> sendTasks = new List<Task>();

        //新規レコードIDを取得 OK
        Id newMatterId = rtats.newMatter.Staff__c;

        //アラートメッセージチェック　OK
        if(!(String.isBlank(rtats.application.AlertMessage__c))){
            CreateTask createTask = new CreateTask();
            createTask.OwnerId = rtats.newMatter.Staff__c;
            createTask.addLnDescription(tsSetting.AlertMessageToDoText__c);
            createTask.createTask();
        }

        Date today = Date.today();  //OK
             
        // 取得した取引先（不動産会社）から斡旋依頼を生成 OK
        for (Id companyId : rtats.mediationCompanyIds){
            MediationRequest__c newMediationRequest = new MediationRequest__c(
                //Name = rtats.newMatter.Name,
                RequestTraderId__c = companyId, // 依頼業者名
                NewMatterId__c = rtats.newMatter.Id, // 新規ＩＤ
                ContractCategory__c = '依頼前', // 成約区分
                DesiredCondition__c = rtats.desiredCondition.Id // 希望条件
            );
            if(
                MediationRequestSend.SendPossibleTimeJude()
                ){
                    //TODO　斡旋依頼送信クラスに内包させたい
                    newMediationRequest.MediationRequestDate__c = today; //斡旋依頼日
                    newMediationRequest.ContractCategory__c = '依頼中';
                }
            mediationRequests.add(newMediationRequest);
        }

        // 斡旋依頼を登録
        AutoTraderSelectionModel.insertMediationRequest(mediationRequests);
        System.debug('CreatemediationCompanyIds');

        // TODOを登録
        AutoTraderSelectionModel.insertTask(sendTasks);

        //斡旋依頼を送信
        MediationRequestSend.accountSendNotificationFuture(newMatterId);
        System.debug('accountSendNotificationFuture');


        return mediationRequests;
    }


    /**
     * @description エラーメッセージTask情報を生成する
     * 
     * @param rtatss 斡旋依頼登録情報
     * @return `List<RequestTraderAutoTraderSelection>`
     */
    private void createErrorMessageTaskItem(
        RequestTraderAutoTraderSelection rtats) {
            
        // カスタム設定
        TraderSelectionSetting__c tsSetting = TraderSelectionSetting__c.getOrgDefaults();    

        List<Task> sendTasks = new List<Task>();

        // 斡旋依頼登録情報から斡旋依頼リストとTODO通知を生成する

        // 通知情報
        System.debug(rtats);
        Task sendTask = new Task(
            WhatId = rtats.newMatter.Id, // 関連先
            // WhoId = '', // 名前
            TaskSubtype = tsSetting.TaskErrorSubtype__c , // ToDo のサブ種別
            Status = tsSetting.TaskErrorStatus__c, // 状況
            Priority = tsSetting.TaskErrorPriority__c, // 優先度
            Subject = tsSetting.SendTaskAutoProcessErrorSubject__c, // 件名
            Description = tsSetting.SendTaskAutoProcessErrorMessage__c // コメント
        );

        sendTasks.add(sendTask);
    

        // TODOを登録
        AutoTraderSelectionModel.insertTask(sendTasks);
    }

    /**
     * @description 紹介可能エリアと不動産キャパを紐づけ格納
     */
    public class agencyCapacityWrap{
        
    }


}