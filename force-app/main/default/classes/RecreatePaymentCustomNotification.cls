/**
 * @description        : 支払再作成カスタム通知
 * @author             : h-nakata
**/
public class RecreatePaymentCustomNotification {
    /**
    * @description カスタム通知送信
    * @author h-nakata
    * @param Set<String> recipientsIds 通知受信ユーザID
    * @return void
    **/
    public static void notifyUsers(Set<String> recipientsIds) {
        //カスタム通知種別取得
        CustomNotificationType notificationType = 
            [SELECT Id
             FROM CustomNotificationType 
             WHERE DeveloperName = 'RecreatePaymentCompleted'];
        
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        //しゃたくさん設定取得
        SyatakusanSetting__c syatakusanSetting = SyatakusanSetting__c.getOrgDefaults();
        //通知タイトル
        notification.setTitle(syatakusanSetting.RecreatePaymentNotificationTitle__c);
        //通知本文
        notification.setBody(syatakusanSetting.RecreatePaymentNotificationBody__c);
        //カスタム通知種別
        notification.setNotificationTypeId(notificationType.Id);
        //遷移先を物件リストビューに設定
        String pageRef = '{"type":"standard__objectPage", "attributes":{"objectApiName":"RealEstate__c", "actionName":"list"}, "state":{"filterName":"Recent"}}';
        notification.setTargetPageRef(pageRef);
        
        //カスタム通知送信
        try {
            notification.send(recipientsIds);
        } catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }
}