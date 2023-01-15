/**
 * 斡旋業者選定画面APEX処理
 * 
 * @author hi-takada
 * @since 2022/01/17
 */
public class ManualTraderSelection {

    public TraderSelectionController.DataRelateDatatable dataRelateDatatable =
        new TraderSelectionController.DataRelateDatatable();

    public TraderSelectionController.DataRelatedObject dataRelatedObject = 
        new TraderSelectionController.DataRelatedObject();
    

    /**
     * @description 引数の新規IDから斡旋依頼に紐づく不動産会社を取得する
     * @param newMatterId 新規ID
     * @return `List<SObject>`
     */
    public static TraderSelectionController.DataRelatedObject getMediationRequestProcess(
        Id newMatterId
    ){

        // カスタム設定
        TraderSelectionSetting__c tsSetting = TraderSelectionSetting__c.getOrgDefaults();

        try {

            // 返却リストマップ
            TraderSelectionController.DataRelatedObject dataRelated = 
                new TraderSelectionController.DataRelatedObject();

            // 新規取得
            NewMatter__c newMatter = 
                ManualTraderSelectionModel.getNewMatter(newMatterId);

            // 希望不動産会社
            dataRelated.desiredAgencyValue = newMatter.Application__r.DesiredAgency__c;
            
            // 斡旋依頼
            dataRelated.isMediationRequest = newMatter.Application__r.MediationRequest__c;
    
            // 取引先（企業）を取得
            // 条件：申請．取引先ID
            Account account = 
                TraderSelectionModel.getAccount(newMatter.Application__r.Account__c);
            
            //サービス新規.斡旋自動対応不可フラグ
            Boolean isAutoMediationRequest = account.ServiceContractNewMatter__r.IsAutoMediationRequest__c;

            //社宅規定の取得
            CorporateHousingRegulation__c corporateHousingRegulation = TraderSelectionModel.getCorporateHousingRegulation(account.id);
          
            // 申請．希望不動産会社が未設定 かつ
            // 申請．斡旋依頼がtrue かつ
            // 申請．社員コメントが未設定 かつ 
            // 申請．ＳＮＴ宛コメントが未設定 かつ
            // 申請. エラーメッセージが未設定
            // 取引先．サービス_新規．斡旋自動対応不可フラグがfalse
            // の場合、'自動'と表示する
            if(String.isBlank(newMatter.Application__r.DesiredAgency__c)&&
                newMatter.Application__r.MediationRequest__c &&   
                String.isBlank(newMatter.application__r.EmployeeComment__c) &&
                String.isBlank(newMatter.application__r.ErrorMessage__c) &&
                String.isBlank(newMatter.application__r.ToSNTComment__c) &&
                !isAutoMediationRequest ){
                    
                // 斡旋の自動、手動を判定
                dataRelated.isSelectionRule = true;
            }

            if(String.isNotBlank(newMatter.Application__r.ApplicantCode__c)){
                // 取引先担当者取得
                System.debug(newMatter.Application__r.ApplicantCode__c);
                Contact contact = TraderSelectionModel.getContact(newMatter.Application__r.ApplicantCode__c);

                // 指定業者選定ルール
                dataRelated.bodyPreview = 
                    contact.CorporateHousingRegulation__r.SelectionRule__c;
                // 選定数
                dataRelated.mediationRequestTotalCount = 
                    Integer.valueOf(corporateHousingRegulation.SelectionCount__c);
            } 

            // 都道府県情報取得
            List<District__c> districts = 
                ManualTraderSelectionModel.getDistrictStates();

            // 都道府県リスト
            dataRelated.districts = districts;

            // 斡旋依頼取得
            List<MediationRequest__c> mediationRequests = 
                ManualTraderSelectionModel.getMediationRequestRegistereds(newMatterId);

            Set<Id> accountIds = new Set<Id>();
            Map<Id, MediationRequest__c> mediationRequestToAccountId = 
                new Map<Id, MediationRequest__c>();

            for (MediationRequest__c mediationRequest : mediationRequests) {

                // 取引先IDをKeyにマップに格納
                mediationRequestToAccountId.put(
                    mediationRequest.RequestTraderId__c, mediationRequest);

                // 検索条件用IDリストに格納
                accountIds.add(mediationRequest.RequestTraderId__c);
            }
            
            // 取引先（不動産会社）取得
            Map<Id, Account> accountsToId = ManualTraderSelectionModel.getAccounts(accountIds, tsSetting);
            

            // 不動産会社キャパ取得
            Map<Id, AgencyCapacity__c> agencyCapacityToAccountId = 
                TraderSelectionModel.getAgencyCapacityToAccountId(accountIds);

            // 一覧表示情報初期化
            List<TraderSelectionController.DataRelateDatatable> dataRelateDatatables = 
                new List<TraderSelectionController.DataRelateDatatable>();

            Boolean isContractFinish = false;
            Boolean isRequesting = false;

            // ループ処理用一時オブジェクト
            Account tempAccount = new Account();
            AgencyCapacity__c tempAgencyCapacity = new AgencyCapacity__c();
            MediationRequest__c tempMediationRequest = new MediationRequest__c();

            for (Id accountId : accountIds) {

                // 一覧設定値
                TraderSelectionController.DataRelateDatatable dataRelatedDatatable = 
                    new TraderSelectionController.DataRelateDatatable();

                // 斡旋依頼
                tempMediationRequest = mediationRequestToAccountId.get(accountId);

                // データテーブルID
                dataRelatedDatatable.id = tempMediationRequest.RequestTraderId__c;

                // 成約区分
                dataRelatedDatatable.ContractCategoryText = tempMediationRequest.ContractCategory__c;
                // 斡旋入力日
                dataRelatedDatatable.MediationInputDateText = 
                    String.valueOf(tempMediationRequest.MediationInputDate__c);

                if(String.isNotBlank(tempMediationRequest.ContractCategory__c)){

                    // 選定区分に値がある場合、解除ボタンは非活性とする
                    dataRelatedDatatable.actionDisabled = true;

                    if(tempMediationRequest.ContractCategory__c == 
                        tsSetting.SelectionResultContract__c){

                        // 成約区分が'成約'の場合、画面を選定済みの表示にする
                        isContractFinish = true;

                    }else {

                        // 成約区分が'成約'以外の場合、画面を選定済みの表示にする
                        dataRelatedDatatable.isActionContentActive = true;
                    }
                    if(tempMediationRequest.ContractCategory__c == 
                        tsSetting.SelectionResultRequesting__c){

                        // 成約区分が'依頼中'の場合、画面を依頼中の表示にする
                        isRequesting = true;
                    }
                }

                // 取引先
                System.debug('accountId:'+accountId);
                tempAccount = accountsToId.get(accountId);
                dataRelatedDatatable.name = tempAccount.Name;
                dataRelatedDatatable.IsTokutokuService = tempAccount.IsTokutokuService__c;
                dataRelatedDatatable.BasicRankText = tempAccount.BasicRank__c;
                // 取引先（不動産会社）ID
                dataRelatedDatatable.IdText = accountId;
                dataRelatedDatatable.ParticipatingStoreText = tempAccount.ParticipatingStore__r.Name;

                // 不動産キャパ
                if(agencyCapacityToAccountId.containsKey(accountId)){
                    tempAgencyCapacity = agencyCapacityToAccountId.get(accountId);

                    // 各キャパ件数
                    dataRelatedDatatable.CapacityNumInt = 
                        Integer.valueOf(tempAgencyCapacity.CapacityNum__c);
                    dataRelatedDatatable.ReserveNumInt = 
                        Integer.valueOf(tempAgencyCapacity.ReserveNum__c);
                    dataRelatedDatatable.RequestingFmNumInt = 
                        Integer.valueOf(tempAgencyCapacity.RequestingFmNum__c);
                    dataRelatedDatatable.RequestingNumInt = 
                        Integer.valueOf(tempAgencyCapacity.RequestingNum__c);
                    dataRelatedDatatable.RequestingNewCommodityInt = 
                        Integer.valueOf(tempAgencyCapacity.RequestingNewCommodity__c);
                }

                dataRelateDatatables.add(dataRelatedDatatable);
            }

            //選定業者数と規定の選定業者数を比較
           // if(dataRelatedDatatable >= dataRelateDatatables.size()){}

            dataRelated.isContractFinish = isContractFinish;
            dataRelated.isRequesting = isRequesting;

            dataRelated.dataRelateDatatable = dataRelateDatatables;

            // 結果を返却
            return dataRelated;

        } catch (Exception e) {
            // 初期表示値取得失敗を表示
            throw new AuraHandledException(
                tsSetting.GetMediationRequestEventErrorMessage__c);
        }
    }


    /**
     * @description 引数を検索条件に取引先（不動産会社）を取得する
     * @param accountId 取引先ID
     * @param accountName 取引先名
     * @param state 都道府県
     * @param city 市区町村
     * @return `List<DataRelateDatatable>`
     * @exception 
     */
    public static List<TraderSelectionController.DataRelateDatatable> searchProcess(
        String accountId,
        String accountName,
        String state,
        String city
    ){
        // カスタム設定
        TraderSelectionSetting__c tsSetting = 
            TraderSelectionSetting__c.getOrgDefaults();

        try {
            // 返却リストマップ
            List<TraderSelectionController.DataRelateDatatable> dataRelateDatatables = 
                new List<TraderSelectionController.DataRelateDatatable>();

            // 都道府県に入力がある場合、取引先IDセットを紹介可能エリアから検索
            Set<Id> mpAreaAccountId = 
                ManualTraderSelectionModel.getAccountIdStateMediationPossibleArea(
                    state, city);
            
            if(String.isNotBlank(state) && mpAreaAccountId.isEmpty()){
                // 都道府県に入力がある場合で、取得結果が存在しない場合処理を終了する
                return dataRelateDatatables;
            }

            // 取引先（不動産会社）から検索
            Map<Id, Account> accountsToId = ManualTraderSelectionModel.getAccountInput(
                accountId, accountName, state, city,
                mpAreaAccountId, tsSetting);

            Set<Id> accountIds = accountsToId.keySet();
            // 不動産会社キャパ取得
            Map<Id, AgencyCapacity__c> agencyCapacityToAccountId = 
                TraderSelectionModel.getAgencyCapacityToAccountId(accountIds);

            Account tempAccount = new Account();
            AgencyCapacity__c tempAgencyCapacity = new AgencyCapacity__c();
            
            for (Id id : accountIds) {

                TraderSelectionController.DataRelateDatatable dataRelatedDatatable = 
                    new TraderSelectionController.DataRelateDatatable();

                // 取引先
                tempAccount = accountsToId.get(id);
                dataRelatedDatatable.id = id;
                dataRelatedDatatable.name = tempAccount.Name;
                dataRelatedDatatable.IsTokutokuService = tempAccount.IsTokutokuService__c;
                dataRelatedDatatable.BasicRankText = tempAccount.BasicRank__c;
                dataRelatedDatatable.IdText = id;
                dataRelatedDatatable.ParticipatingStoreText = tempAccount.ParticipatingStore__r.Name;

                // 不動産キャパ
                if(agencyCapacityToAccountId.containsKey(id)){
                    tempAgencyCapacity = agencyCapacityToAccountId.get(id);

                    // 各キャパ件数
                    dataRelatedDatatable.CapacityNumInt = 
                        Integer.valueOf(tempAgencyCapacity.CapacityNum__c);
                    dataRelatedDatatable.ReserveNumInt = 
                        Integer.valueOf(tempAgencyCapacity.ReserveNum__c);
                    dataRelatedDatatable.RequestingFmNumInt = 
                        Integer.valueOf(tempAgencyCapacity.RequestingFmNum__c);
                    dataRelatedDatatable.RequestingNumInt = 
                        Integer.valueOf(tempAgencyCapacity.RequestingNum__c);
                    dataRelatedDatatable.RequestingNewCommodityInt = 
                        Integer.valueOf(tempAgencyCapacity.RequestingNewCommodity__c);
                }

                dataRelateDatatables.add(dataRelatedDatatable);

            }

            // 結果を返却
            return dataRelateDatatables;

        } catch (Exception e) {
            // 検索処理失敗を表示
            throw new AuraHandledException(
                tsSetting.SearchEventErrorMessage__c);
        }
    }


    /**
     * @description 斡旋依頼実行処理
     * @param newMatterId // 新規ID
     * @param accountIds // 取引先IDリスト
     * @return `void`
     * @exception DmlException // レコード登録／更新エラー
     * @exception AuraHandledException // 引数不正
     */
    public static void upsertMediationRequestProcess(
        String newMatterId,
        List<String> accountIds
    ){

        // カスタム設定
        TraderSelectionSetting__c tsSetting = 
            TraderSelectionSetting__c.getOrgDefaults();

        // 登録／更新斡旋依頼情報格納
        List<MediationRequest__c> upsertMediationRequests = 
            new List<MediationRequest__c>();

        if(String.isBlank(newMatterId) || accountIds.isEmpty()){
            // 引数不正メッセージを表示
            throw new AuraHandledException(tsSetting.DisplayInputEventErrorMessage__c); 
        }

        try {

            // 新規取得
            NewMatter__c newMatter = 
                ManualTraderSelectionModel.getNewMatter(newMatterId);

            if(String.isNotBlank(newMatter.Application__r.ErrorMessage__c)){
                throw new AuraHandledException(
                tsSetting.ApplicationWhenCheckErrorMessage__c);
            }
            // 希望条件を取得
            // 条件；申請ID
            System.debug('getDesiredCondition:'+newMatter.Application__c);
            DesiredCondition__c desiredCondition = 
                TraderSelectionModel.getDesiredCondition(
                    newMatter.Application__c);
            // 登録済みの斡旋依頼を取得
            List<MediationRequest__c> mediationRequests = 
            ManualTraderSelectionModel.getMediationRequestRegistereds(
                    newMatterId);

            Date today = Date.today();

            for (Integer i = 0; i < accountIds.size(); i++) {
                // 既に登録されている場合かつ選定結果が未設定の場合、更新を行う
                for (MediationRequest__c mediationRequest : mediationRequests){
                    // 既登録チェック
                    if(mediationRequest.RequestTraderId__c == accountIds.get(i)) {
                        break; 
                    }
                        
                }
            
                // 登録値設定
                System.debug('debug'+accountIds[i]);
                MediationRequest__c newMediationRequest = new MediationRequest__c(
                    RequestTraderId__c = accountIds[i], // 依頼業者名
                    NewMatterId__c = newMatterId, // 新規ＩＤ
                    ContractCategory__c = tsSetting.SelectionResultRequesting__c, // 選定結果
                    MediationInputDate__c = today, // 斡旋入力日
                    DesiredCondition__c = desiredCondition.Id //希望条件
                );

                upsertMediationRequests.add(newMediationRequest);
                
            }

            // 斡旋依頼を登録／更新する
            upsert upsertMediationRequests;

            // 斡旋依頼結果をメールまたはChatterにて通知する
            System.debug('TraderSelectionModel.getHolidayToday():'+TraderSelectionModel.getHolidayToday());
            System.debug('TraderSelectionUtils.SendPossibleTimeJude(tsSetting):'+
                MediationRequestSend.SendPossibleTimeJude());

           

            System.debug('upsertMediationRequests:'+upsertMediationRequests);
            MediationRequestSend.accountSendNotificationFuture(newMatterId); 
            
            //初回の斡旋依頼かどうかを判定
            if(newMatter.MediationRequestDate__c == null){
                //初回の処理
                //斡旋依頼日に当日の値を格納しレコードを更新
                newMatter.MediationRequestDate__c = today;

                //斡旋依頼をしている業者の名前の一覧を項目に挿入
                List<MediationRequest__c> nameListMediationRequests = ManualTraderSelectionModel.getMediationRequestRegistereds(newMatterId);
                String nameList = '';
                for(MediationRequest__c mediationRequest : nameListMediationRequests){
                    nameList += mediationRequest.RequestTraderId__r.Name+'\n';
                }
                newMatter.MediationRequestRequestTraderList__c = nameList;

                update newMatter;
            }
            //TODO 活動を作成
            Task task = new Task(
                WhatId = newMatterId
                ,ActivityDate = today
                ,Subject = '斡旋依頼完了'
            );
            insert task;
            

        } catch (Exception e) {
            // 斡旋依頼エラーを表示
            throw new AuraHandledException(
                tsSetting.MediationRequestEventErrorMessage__c);
        }
    }


    /**
     * @description 斡旋依頼ステータス更新
     * @param newMatterId // 新規ID
     * @param accountIdList // 取引先IDリスト
     * @param accountId // 取引先ID
     * @param status // 選定結果
     * @return `void`
     * @exception 
     */
    public static void updateMediationStatusProcess(
        String newMatterId,
        List<String> accountIds,
        String accountId,
        String status
    ){

        // カスタム設定
        TraderSelectionSetting__c tsSetting = 
            TraderSelectionSetting__c.getOrgDefaults();

        if(String.isBlank(newMatterId) || accountIds.isEmpty() || 
            String.isBlank(accountId) || String.isBlank(status)){
            // 引数不正メッセージを表示
            throw new AuraHandledException(tsSetting.DisplayInputEventErrorMessage__c); 
        }

        try {

            // 登録済みの斡旋依頼を取得
            List<MediationRequest__c> mediationRequests = 
                ManualTraderSelectionModel.getMediationRequestRegistereds(
                    newMatterId);

            for(MediationRequest__c mediationRequest : mediationRequests){
                if(mediationRequest.RequestTraderId__c == accountId){

                    // 成約区分を入力内容に更新
                    mediationRequest.ContractCategory__c = status;  // 成約区分
                    continue;
                }else{
                    // '成約'選択の場合、他'依頼中'を'失注'に更新
                    if(status == tsSetting.SelectionResultContract__c && 
                        mediationRequest.ContractCategory__c == 
                            tsSetting.SelectionResultRequesting__c){

                        mediationRequest.ContractCategory__c = 
                            tsSetting.SelectionResultLostOrder__c;  // 成約区分
                    }
                }
            }

            // 斡旋依頼を更新
            ManualTraderSelectionModel.updateMediationRequest(mediationRequests);

        } catch (Exception e) {
            throw new AuraHandledException(
                tsSetting.MediationRequestUpdateEventErrorMessage__c);
        }

    }


    /**
     * @description 斡旋依頼解除ボタン押下処理
     * @param newMatterId // 新規ID
     * @param accountId // 取引先ID
     * @return `void`
     * @exception 
     */
    public static void deleteMediationRequestProcess(
        String newMatterId,
        String accountId
    ){

        // カスタム設定
        TraderSelectionSetting__c tsSetting = 
            TraderSelectionSetting__c.getOrgDefaults();

        if(String.isBlank(newMatterId) || String.isBlank(accountId)){
            // 引数不正メッセージを表示
            throw new AuraHandledException(tsSetting.DisplayInputEventErrorMessage__c); 
        }

        try {
            // 登録済みの斡旋依頼を取得
            List<MediationRequest__c> mediationRequests = 
                ManualTraderSelectionModel.getMediationRequestDelete(
                    newMatterId, accountId);
        
            // 斡旋依頼削除
            ManualTraderSelectionModel.deleteMediationRequest(mediationRequests);

        } catch (Exception e) {
            throw new AuraHandledException(
                tsSetting.MediationRequestDeleteEventErrorMessage__c);
        }

    }

    
}