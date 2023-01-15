public class MediationRequestSendEmail{

     /**
     * @description 斡旋依頼メール通知を行う
     * @author t-sato
     * @param sendEmailObjects メール送信情報オブジェクト
     * @param mediationRequests 斡旋依頼オブジェクト
     * @return `List<MediationRequest__c> `
     */
    public static List<MediationRequest__c> sendMediationRequestEmail(
        List<MediationRequest__c> mediationRequests,
        Map<Id, Account> requestTraders,
        Map<Id,NotificationTemplate__c> notificationTemplates
        ) {
        //返却値
        List<MediationRequest__c> sendSuccesMediationRequests = new List<MediationRequest__c>();

        System.debug('mediationRequests:'+mediationRequests);
        System.debug('requestTraders:'+requestTraders);
        System.debug('notificationTemplates:'+notificationTemplates);

        //カスタム設定
        DefaultMailTemplate__c defaultMailTemplate = DefaultMailTemplate__c.getOrgDefaults();
        //メール送信クラス初期化
        SendEmail sendEmail = new SendEmail();

        //メール送信のために変数の初期化
        Account tempAccount = new Account();
        
        List<MediationRequest__c> sendEmailMediationRequests = new List<MediationRequest__c>();

        //メールテンプレート名格納用
        Set<String> emailTemplateNames =new Set<String>();
        for(Id id : notificationTemplates.keySet()){
            NotificationTemplate__c notificationTemplate = notificationTemplates.get(id);
            System.debug('notificationTemplate:'+notificationTemplate);
            emailTemplateNames.add(notificationTemplate.MediationRequestMail__c);
        }
        
        
        //メールテンプレートID取得 Map(メールテンプレート名,メールテンプレートID)
        Map<String,EmailTemplate> emailTemplates = getEmailTemplates(emailTemplateNames,defaultMailTemplate.MediationRequestSend__c);

        //メール送信情報を格納
        for (MediationRequest__c mediationRequest : mediationRequests) {
            
            // 取引先（不動産）情報
            tempAccount = requestTraders.get(mediationRequest.RequestTraderId__c);
            System.debug('tempAccount:'+tempAccount);
            // テンプレートIDに取引先（不動産）の斡旋依頼メールテンプレートを設定
            NotificationTemplate__c notificationTemplate = notificationTemplates.get(tempAccount.Id);
            System.debug('notificationTemplate:'+notificationTemplate);
            EmailTemplate emailTemplate = null;
            if(notificationTemplate == null){
                System.debug('notificationTemplateIsNull');
                emailTemplate = emailTemplates.get('DEFAULT');
            }else{
                emailTemplate = emailTemplates.get(notificationTemplate.MediationRequestMail__c) ;
            }
            System.debug('emailTemplate:'+emailTemplate);
            //sendEmail.sendEmailObject.subject = emailTemplate.Subject;
            //sendEmail.sendEmailObject.Body = emailTemplate.Body;
            // 差し込みIDに斡旋依頼IDを設定
            //sendEmail.sendEmailObject.whatId = mediationRequest.Id;
            sendEmail.SendEmailObject.emailTemplate = emailTemplate;
            // 宛先に連絡先メールを設定
            sendEmail.sendEmailObject.toAddress = tempAccount.MainEmail__c;
            //斡旋依頼を設定
            sendEmail.sendEmailObject.mediationRequest = mediationRequest;
            System.debug('sendEmail.sendEmailObject:'+sendEmail.sendEmailObject);
            sendEmail.addObject();
        }

        //斡旋依頼送信日を更新するレコードを保存する変数
        List<MediationRequest__c> successSendEmailMediationRequests = new List<MediationRequest__c>();

        List<Map<String,String>> results = SendEmail.send();
        
        return sendSuccesMediationRequests;
    }

     /**
     * @description エラーメールを送信する
     * @return `void`
     */
    public static void sendErrorEmail(EmailTemplate errorEmailTemplate) {
        SendEmail sendEmail = new SendEmail();
        // カスタム設定
        TraderSelectionSetting__c tsSettingInfo = 
            TraderSelectionSetting__c.getOrgDefaults();

        //sendEmail.sendEmailObject.emailTemplate = errorEmailTemplate;
        //sendEmail.sendEmailObject.whatId = null;
        sendEmail.sendEmailObject.toAddress = tsSettingInfo.ApexErrorEmailtoAddress__c;
        sendEmail.addObject();

        // メール通知の実行
        sendEmail.send();
    }

    /**
     * @description メールテンプレートID取得
     * @author sato-takumi
     * @param  emailTemplateNames //メールテンプレート名
     * @return Map<String,Id> 
     */
    //手動Email
    public static Map<String,EmailTemplate> getEmailTemplates(
        Set<String> emailTemplateNames, //<メールテンプレート名
        Id defaultId
    ) {
        System.debug('defaultId:'+defaultId);
        //返却マップ
        Map<String,EmailTemplate> result = new Map<String,EmailTemplate>();
        // 引数が空の場合は処理終了

        //取得結果を返却マップに格納
        for(EmailTemplate emailTemplate: [
            SELECT 
                Id,
                Name,
                Subject,
                Body
            FROM EmailTemplate
            WHERE
                Name IN :emailTemplateNames 
                OR Id = :defaultId
            ])if(emailTemplate.Id == defaultId){
                result.put('DEFAULT',emailTemplate);
            }else{
                result.put(emailTemplate.Name,emailTemplate);
            }
            System.debug('EmailTemplates:'+result);
        return result;
    }
}