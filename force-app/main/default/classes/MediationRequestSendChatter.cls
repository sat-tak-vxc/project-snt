public with sharing class MediationRequestSendChatter {
    public static List<MediationRequest__c> sendChatter(
        List<MediationRequest__c> mediationRequests,
        Map<Id, Account> requestTraders
        ) {
        
        System.debug('--sendChatter');

        SendChatter sendChatter = new SendChatter();

        //カスタム設定
        DefaultFeedTemplate__c defaultFeedTemplate = DefaultFeedTemplate__c.getOrgDefaults();

        //返却値の初期化
        List<MediationRequest__c> resultList = new List<MediationRequest__c>();

        //本店のグループ名を取得
        Set<String> groupNames = new Set<String>();
        Map<String,Id> requestTraderGroupNames = new Map<String,Id>();
        for(Id id: requestTraders.keySet()){
            String groupName = requestTraders.get(id).ChatterGroupName__c;
            groupNames.add(groupName);
            requestTraderGroupNames.put(groupName,id);
        }

        //本店のグループIDを取得
        Map<Id,CollaborationGroup> collaborationGroups = getCollaborationGroups(groupNames);
        
        //本店のグループIDを紐づけ
        Map<Id,Id> requestTraderCollaborationGroups = new Map<Id,Id>();
        for(Id id : collaborationGroups.keySet()){
            String collaborationGroupName = collaborationGroups.get(id).Name;
            Id requestTraderId = requestTraderGroupNames.get(collaborationGroupName);

            requestTraderCollaborationGroups.put(requestTraderId , id);
        }

        //本文テンプレートの取得
        Map<Id,String> chatterTemplate = getChatterTemlate(requestTraders.keySet());
        //デフォルトのテンプレート取得
        String DefaultChatterTemplate = defaultFeedTemplate.MediationRequestSend__c;

        // Chatterの通知
        List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
        List<MediationRequest__c> sendChatterMediationRequests = new List<MediationRequest__c>();
        for(MediationRequest__c mediationRequest: mediationRequests){
        
            Id requestTraderId = mediationRequest.RequestTraderId__c;
            sendChatter.SendChatterObject.mentionId = requestTraderCollaborationGroups.get(requestTraderId);
            if(String.isBlank(sendChatter.SendChatterObject.mentionId))sendChatter.SendChatterObject.mentionId = requestTraderId;
            // テキスト
            sendChatter.SendChatterObject.text = chatterTemplate.get(sendChatter.SendChatterObject.mentionId);
            if(String.isBlank(sendChatter.SendChatterObject.text))sendChatter.SendChatterObject.text = DefaultChatterTemplate;
        
            //投稿先
            sendChatter.SendChatterObject.feedItemInput = mediationRequest.Id;

            System.debug('-sendChatter:'+sendChatter);

            sendChatter.addObject();

        }
        
        //Chatter送信
        List<ConnectApi.BatchResult> batchResults = sendChatter.send();

        // 送信結果確認
        List<MediationRequest__c> updateMediationRequest = new List<MediationRequest__c>();
        for(Integer n=0; n < batchResults.size(); n++){
            ConnectApi.BatchResult batchResult = batchResults[n];
            MediationRequest__c mediationRequest = mediationRequests[n];
            if (batchResult.isSuccess()) {
                System.debug('sendChatter Success!!');
                System.debug('mediationRequest.Id:'+mediationRequest.Id);
                //斡旋依頼送信日時を更新するレコードを格納
                resultList.add(mediationRequest);
            } else {
                System.debug('sendChatter Error');
                System.debug('mediationRequest.Id:'+mediationRequest.Id);
                System.debug(batchResult.getErrorMessage());
            }
        }
        return resultList;
    }

     /**
     * @description グループ情報取得
     * @author sato-takumi
     * @param accountId // 取引先IDリスト
     * @return CollaborationGroup 
     */
    public static Map<Id,CollaborationGroup> getCollaborationGroups(
        Set<String> groupName 
    ) {
        Map<Id,CollaborationGroup> result = new Map<Id,CollaborationGroup>();
        for(CollaborationGroup collaborationGroup: [
            SELECT Id,Name
            FROM CollaborationGroup
            WHERE 
                Name IN : groupName
        ]){
            result.put(collaborationGroup.Id,collaborationGroup);
        }
        return result;
    }

    public static Map<Id,String> getChatterTemlate(Set<Id> AccountIds){
        Map<Id,String> result = new Map<Id,String>();
        for(NotificationTemplate__c notificationTemplate:[
            SELECT 
                Id,
                MediationRequestFeed__c
            FROM NotificationTemplate__c
            WHERE
                Account__c IN :AccountIds
        ])result.put(notificationTemplate.Id, notificationTemplate.MediationRequestFeed__c);
        return result;
    }
}