/**
 * @description 斡旋依頼トリガ
 * 
 * @author hi-takada
 * @date 2022/01/17
 */
trigger MediationRequestTrigger on MediationRequest__c (after insert, after update, after delete) {
    
    MediationRequestTriggerHandler handler = new MediationRequestTriggerHandler();

    if (Trigger.isDelete && Trigger.isAfter) {
        /**
         * 削除後トリガ
         */

        handler.capacityNumUpdate(Trigger.old);

    } else {
        /**
         * 登録後トリガ、更新後トリガ
         */

        handler.capacityNumUpdate(Trigger.new);
    }
}