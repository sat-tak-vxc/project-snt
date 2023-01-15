/**
 * @description        : FBデータ作成カスタム通知
 * @author             : h-nakata
**/
public class CreateFbDataCustomNotification {
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
             WHERE DeveloperName = 'CreateFbDataCompleted'];
        
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        //しゃたくさん設定取得
        SyatakusanSetting__c syatakusanSetting = SyatakusanSetting__c.getOrgDefaults();
        //通知タイトル
        notification.setTitle(syatakusanSetting.CreateFbDataNotificationTitle__c);
        //通知本文
        notification.setBody(syatakusanSetting.CreateFbDataNotificationBody__c);
        //カスタム通知種別
        notification.setNotificationTypeId(notificationType.Id);
        //遷移先をFBデータリストビューに設定
        String pageRef = '{"type":"standard__objectPage", "attributes":{"objectApiName":"FbData__c", "actionName":"list"}, "state":{"filterName":"Recent"}}';
        notification.setTargetPageRef(pageRef);
        
        //カスタム通知送信
        try {
            notification.send(recipientsIds);
        } catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }
}