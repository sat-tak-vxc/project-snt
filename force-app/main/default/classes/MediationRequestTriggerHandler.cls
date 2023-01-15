/**
 * @description トリガ：斡旋依頼
 * 
 * @author hi-takada
 * @date 2022/01/17
 */
public with sharing class MediationRequestTriggerHandler {
    
    /**
     * @description 不動産キャパの件数を更新する
     * 
     * @param news 斡旋依頼のリスト
     * @return `void`
     */
    public void capacityNumUpdate(List<MediationRequest__c> mediationRequests) {

        // カスタム設定
        TraderSelectionSetting__c tsSetting = 
            TraderSelectionSetting__c.getOrgDefaults();

        try {

            Set<Id> accountIds = new Set<Id>();
            for (MediationRequest__c mediationRequest : mediationRequests) {
                // 斡旋依頼の取引先IDをリストに格納
                accountIds.add(mediationRequest.RequestTraderId__c);
            }

            // 斡旋依頼を検索
            // 条件：取引先（不動産会社）
            // 条件：成約区分 = '依頼中'
            Map<Id, AggregateResult> mediationRequestRequestingCounts =
                MediationRequestModel.getMediationRequestAccountCount(
                    accountIds, tsSetting);

            // 不動産キャパ取得
            Map<Id, AgencyCapacity__c> agencyCapacityToAccountId = 
                TraderSelectionModel.getAgencyCapacityToAccountId(
                    accountIds);

            // 更新不動産キャパリスト
            List<AgencyCapacity__c> updateAgencyCapacitys =
                new List<AgencyCapacity__c>();

            // ループ処理用オブジェクト
            AgencyCapacity__c tempAgencyCapacity = new AgencyCapacity__c();
            for (Id accountId : accountIds){

                // 不動産キャパが存在する場合オブジェクトに処理を行う
                if(agencyCapacityToAccountId.containsKey(accountId)){
                    tempAgencyCapacity = agencyCapacityToAccountId.get(accountId);
                } else {
                    continue;
                }

                // 取引先（不動産）IDに紐づく斡旋依頼が存在する場合、
                // 斡旋依頼の'依頼中'の数を斡旋依頼数に設定
                if(mediationRequestRequestingCounts.containsKey(accountId)){
                    Integer requestingNum = 
                        Integer.valueOf(
                            mediationRequestRequestingCounts.get(accountId).get('cnt'));
                    tempAgencyCapacity.RequestingNum__c = requestingNum;
                } else {
                    // 斡旋依頼が存在しない場合0を設定
                    tempAgencyCapacity.RequestingNum__c = 0;
                }

                updateAgencyCapacitys.add(tempAgencyCapacity);
            }


            // 不動産キャパを更新
            MediationRequestModel.updateAgencyCapacitys(updateAgencyCapacitys);
            

        } catch (Exception e) {
            // 例外が発生した場合、エラーメールを通知
            //TraderSendEmail.sendErrorEmail(tsSetting.ApexErrorEmailTemplate__c);
        }

    }

}