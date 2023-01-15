/**
 * 斡旋依頼通知クラス
 */
public class MediationRequestSend{
    /**
     * @description 不動産会社へ通知
     * 
     * @param mediationRequests 斡旋依頼リスト
     * @return `void`
     */
    @Future
    public static void accountSendNotificationFuture(
        Id newMatterId
        ) {
        // カスタム設定
        TraderSelectionSetting__c tsSetting = TraderSelectionSetting__c.getOrgDefaults();
        ReportNameSetting__c reportNameSetting = ReportNameSetting__c.getOrgDefaults();
        
        //新規IDから斡旋依頼レコードを取得
        List<MediationRequest__c> mediationRequests = getNewMatterIdMediationRequest(newMatterId);

        //送信可能時間判定
        System.debug('送信可能時間：'+SendPossibleTimeJude());
        if(!SendPossibleTimeJude()){
            //送信可能時間外の処理
            System.debug('送信可能時間外');
            return;
        }
        //以降：送信可能時間内の処理

        //斡旋依頼を送信する取引先(不動産)を格納
        Set<Id> accountIds = new Set<Id>();
        for (MediationRequest__c mediationRequest : mediationRequests) {
            if(mediationRequest.ContractCategory__c != '依頼前'){
                continue;
            }

            //斡旋依頼をする取引先(不動産会社)のIdを格納
            accountIds.add(mediationRequest.RequestTraderId__c);
        }
        //依頼業者が空の場合処理終了
        if (accountIds.isEmpty()) {
            System.debug('AccountIds Is Empty');
            return;
        }

        // 取引先（不動産会社）:依頼業者　取得
        Map<Id, Account> requestTraders = getAccounts(accountIds, tsSetting);

        //取引先(本店)を取得
        Map<String,Account> sendTraders = TraderSelectionModel.getAccountSendMediationRequest(requestTraders,tsSetting);
        Set<Id> sendTraderIds = new Set<Id>();

        //requestTradersの値をSendTradersの値で上書き
        for(Id id : requestTraders.keySet()){
            Account account = requestTraders.get(id);
            String groupId = account.Name;//グループID
            Account putAccount = sendTraders.get(groupId);
            if(putAccount == null){
                putAccount = account;
            }
            requestTraders.put(id,putAccount);
            sendTraderIds.add(id);
        }

        //送信用配列
        List<MediationRequest__c> emailMediationRequests = new List<MediationRequest__c>();
        List<MediationRequest__c> chatterMediationRequests = new List<MediationRequest__c>();
        List<MediationRequest__c> faxMediationRequests = new List<MediationRequest__c>();
        List<MediationRequest__c> emailFaxMediationRequests = new List<MediationRequest__c>();
        List<MediationRequest__c> taskMediationRequests = new List<MediationRequest__c>();

        //ToDo作成用リスト
        List<Task> createTodos = new List<Task>();

        //通知方法毎に取引先を格納
        System.debug('--SendMediationRequest--');
        for (MediationRequest__c mediationRequest: mediationRequests) {
            //取引先
            Account requestTrader = requestTraders.get(mediationRequest.RequestTraderId__c);
            System.debug('---Account:'+requestTrader);
            //優先斡旋依頼書連絡方法を取得
            String priorityMediationContactMethod = requestTrader.PriorityMediationContactMethod__c;
            
            //Chatter
            if(priorityMediationContactMethod=='Chatter'){
                chatterMediationRequests.add(mediationRequest);
            }
            //メール
            else if(priorityMediationContactMethod=='メール'){
                emailMediationRequests.add(mediationRequest);
            }
            //FAX
            else if(priorityMediationContactMethod=='FAX'){
                faxMediationRequests.add(mediationRequest);
            }
            //どの送信方法にも当てはまらない場合ToDo発行
            else{
                taskMediationRequests.add(mediationRequest);
            }
        }
        System.debug('--SendEmail MediationRequests:'+emailMediationRequests);
        System.debug('--SendChatter MediationRequests:'+chatterMediationRequests);
        System.debug('--SendFax MediationRequests:'+faxMediationRequests);
        System.debug('--SendEmailFax MediationRequests:'+emailFaxMediationRequests);
        System.debug('--CreateTask MediationRequests:'+taskMediationRequests);

        //通知テンプレートを取得
        Map<Id,NotificationTemplate__c> notificationTemplates= TraderSelectionModel.getNotificationTemplates(sendTraderIds);
            
        //斡旋依頼送信が成功した斡旋依頼レコードを格納するList
        List<MediationRequest__c> updateMediationRequests = new List<MediationRequest__c>();

        // Chatter通知の実行
        System.debug('-SendChatter:'+chatterMediationRequests);
        updateMediationRequests.addAll(MediationRequestSendChatter.sendChatter(
            chatterMediationRequests,
            requestTraders));
        // メール通知の実行
        System.debug('---SendEmail---');
        updateMediationRequests.addAll(MediationRequestSendEmail.sendMediationRequestEmail(
            emailMediationRequests,
            requestTraders,
            notificationTemplates));
        //sendMediationRequestEmail(emailObjects,sendEmailMediationRequests);
        //FAX送信機能
        System.debug('---SendFax---');
        updateMediationRequests.addAll(MediationRequestSendFax.sendFax(
            faxMediationRequests,
            requestTraders));

        //斡旋依頼送信が成功した斡旋依頼レコードの更新
        Datetime now = Datetime.now().addHours(9);
        List<MediationRequest__c> updateMediationDays = new List<MediationRequest__c>();
        for(MediationRequest__c mediationRequest : updateMediationRequests){
            mediationRequest.MediationRequestSendDateTime__c = now;//斡旋依頼日
            mediationRequest.ContractCategory__c ='依頼中'; //成約区分
            updateMediationDays.add(mediationRequest);
        }

        //ToDo作成
        for (MediationRequest__c mediationRequest : mediationRequests) {
            Task todo = new Task();
            
            //所有者割り当て
            todo.OwnerId = mediationRequest.RequestTraderId__r.NewMatterTeam__r.OwnerId;//所有者←新規/斡旋チーム キューグループ
            //件名割り当て
            todo.Subject = tsSetting.TaskMediationRequestNotNoticenotSubject__c;//件名←カスタム設定.TODO斡旋依頼通知未設定_件名
            //コメント
            todo.Description = tsSetting.TaskMediationRequestNotNoticenotText__c;//コメント←カスタム設定.TODO斡旋依頼通知未設定_本文
            //関連先
            todo.WhatId = mediationRequest.Id;//関連先←斡旋依頼レコード

            //ToDo作成用リストに格納
            createTodos.add(todo);
        }

        try {

            
            
        update updateMediationDays;
   
        } catch(DmlException e) {
            System.debug('--- DmlException ---');
            System.debug('--- e.getNumDml() ---> ' + e.getNumDml());
            for (Integer index = 0; index < e.getNumDml(); index++) {
                System.debug('--- index ---> ' + index);
                System.debug('--- e.getDmlId(index) ---> ' + e.getDmlId(index));
                System.debug('--- e.getDmlIndex(index) ---> ' + e.getDmlIndex(index));
                System.debug('--- e.getDmlFieldNames(index) ---> ' + e.getDmlFieldNames(index));
                System.debug('--- e.getDmlMessage(index) ---> ' + e.getDmlMessage(index));
                System.debug('--- e.getDmlType(index).name() ---> ' + e.getDmlType(index).name());
            }
            throw e;
        } catch(Exception e) {
            System.debug('--- Exception ---');
            System.debug('--- e.getTypeName() ---> ' + e.getTypeName());
            System.debug('--- e.getCause() ---> ' + e.getCause());
            System.debug('--- e.getLineNumber() ---> ' + e.getLineNumber());
            System.debug('--- e.getMessage() ---> ' + e.getMessage());

            // エラーをメール通知
            //TraderSendEmail.sendErrorEmail(tsSetting.NotificationErrorEmailTemplate__c);
        }

        

    }
   
    

    /**
     * @description 送信可能時間内判定
     * 
     * @param tsSetting　カスタム設定
     * @return boolean TURE:送信可能時間内　FALSE：送信可能時間外
     */
    public static Boolean SendPossibleTimeJude(){
        // カスタム設定
        TraderSelectionSetting__c tsSetting = TraderSelectionSetting__c.getOrgDefaults();

        //返り値のデフォルトを登録
        Boolean result = True;
        if(!(TraderSelectionModel.getHolidayToday())){
            System.debug('--SendPossibleTimeJude SendPossibleDate--');
            return False;
        }
        //現在時刻の取得
        Datetime todayDt = Datetime.now();
        Integer todayYear = todayDt.year();
        Integer todayMonth = todayDt.month();
        Integer todayDay = todayDt.day();
        //カスタム設定から送信可能時間を取得
        Integer startHour = Integer.valueOf(tsSetting.SendPossibleStartTimeHour__c);
        Integer startMonth = Integer.valueOf(tsSetting.SendPossibleStartTimeMinutes__c);
        Integer endHour = Integer.valueOf(tsSetting.SendPossibleEndTimeHour__c);
        Integer endMonth = Integer.valueOf(tsSetting.SendPossibleEndTimeMinutes__c);

        //本日の日付取得
        String todayText = String.valueOf(Date.Today());
        
        //送信可能時間の取得
        String sendPossibleStartTime = Integer.valueOf(tsSetting.SendPossibleStartTimeHour__c)+':'+Integer.valueOf(tsSetting.SendPossibleStartTimeMinutes__c);//送信可能開始時間(HH:MM)
        String sendPossibleEndTime = Integer.valueOf(tsSetting.SendPossibleEndTimeHour__c)+':'+Integer.valueOf(tsSetting.SendPossibleEndTimeMinutes__c);//送信可能終了時間(HH:MM)
         
        //当日の送信可能開始時間
        Datetime sendPossibleStartDt = Datetime.newInstanceGmt(todayYear,todayMonth,todayDay,startHour,startMonth,0);

        //当日の送信可能終了時間
        Datetime sendPossibleEndDt = Datetime.newInstanceGmt(todayYear,todayMonth,todayDay,endHour,endMonth,0);

        /*現在時刻が送信可能時間かどうかを判定
         送信可能時間外：result←False
        */
        todayDt = todayDt.addHours(9);

        if(
            todayDt < sendPossibleStartDt ||
            todayDt > sendPossibleEndDt
        ){
            System.debug('--SendPossibleTimeJude SendPossibleDateTime--');
            result = False;
        }


        return result;
    }

    private static List<MediationRequest__c> getNewMatterIdMediationRequest(Id newMatterId){
        List<MediationRequest__c> result = new List<MediationRequest__c>();

        for(MediationRequest__c mediationRequest : [
            SELECT
            Id
            , Name
            , RequestTraderId__c // 依頼業者名
            , RequestTraderId__r.Name
            , ContractCategory__c // 成約区分
            , MediationInputDate__c // 斡旋入力日
            , MediationRequestSendDateTime__c //斡旋依頼送信日時	
            , RequestTraderId__r.NewMatterTeam__r.OwnerId
            FROM MediationRequest__c
            WHERE NewMatterId__c = :newMatterId
        ])result.add(mediationRequest);

        return result;
    }

    /**
     * @description 取引先（不動産会社）取得
     * @param accountIds // 取引先ID
     * @param tsSetting // カスタム設定
     * @return `Map<Id, Account>`
     */
    //両方
    public static Map<Id, Account> getAccounts(
        Set<Id> accountIds, TraderSelectionSetting__c tsSetting) {

        Map<Id, Account> accounts = new Map<Id, Account>();

        if(accountIds.isEmpty()){
            return accounts;
        }

        // レコードタイプ（不動産会社/家主）取得
        RecordType recordType = [
            SELECT Id, Name, DeveloperName, SobjectType, IsActive
            FROM RecordType
            WHERE SobjectType = :tsSetting.SobjectTypeAccount__c
                AND Name = :tsSetting.RecordTypeNameTrader__c 
                AND IsActive = true
            LIMIT 1
        ];

        // 取引先（不動産会社）取得
        accounts = new Map<Id, Account>([
            SELECT 
                Id
                , Name
                , ChatterGroupName__c //Chatterグループ名
                , NotificationTemplate__r.MediationRequestMail__c // メールテンプレート
                , NewMatterTeam__r.OwnerId//新規/斡旋チーム キューグループ
                , PriorityMediationContactMethod__c//優先斡旋依頼書連絡方法
            FROM Account
            WHERE Id IN :accountIds 
            AND RecordTypeId = :recordType.Id
        ]);
      
        return accounts;
    }

}