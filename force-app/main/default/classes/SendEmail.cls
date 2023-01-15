/**
 * @description メールを一括送信するクラス
 * @author t-sato
 * @since 1.0
 */
public class SendEmail{
    /**
     * @description メール送信オブジェクト
     */
    public class SendEmailObject{   
        public String subject { get; set; }  // 件名
        public String Body {get; set;} //本文
        //public Id whatId { get; set; } // 埋め込み変換用ID
        public String toAddress { get; set; } // 宛先メールアドレス
        public MediationRequest__c mediationRequest{get; set;}
        public EmailTemplate emailTemplate{get; set; }
        
        public sendEmailObject() {
        }
    }
    //メール送信用クラス
    public SendEmailObject sendEmailObject = new SendEmailObject();
    //メール送信用クラスリスト
    public List<SendEmailObject> sendEmailObjects = new List<SendEmailObject>();
    public void addObject(){
        System.debug('sendEmailObject:'+sendEmailObject);
        sendEmailObjects.add(sendEmailObject);
    }
    //フローインタビュークラス
    public Flow.Interview.MediationRequestSend mediationRequestSend{get; set;}

    /**
     * @description メールの一括送信を実行する。
     * @return  `List<Messaging.SendEmailResult>`
     */
    public List<Map<String,String>> send(){
        System.debug('---send---');
        System.debug(sendEmailObjects);
        //返却値の初期化
        List<Map<String,String>> result= new List<Map<String,String>>();
        // 送信対象メールリスト
        List<Messaging.SingleEmailMessage> emails = 
        new List<Messaging.SingleEmailMessage>();

        for(SendEmailObject sendEmailObject: this.sendEmailObjects){
        
            //フロー入力値
            //Map<String,Object> inputValues = new Map<String,Object>();
            //inputValues.put('var_InputSubject',sendEmailObject.subject);
            //inputValues.put('var_InputBody',sendEmailObject.Body);
            //inputValues.put('var_InputMediationRequest',sendEmailObject.mediationRequest);
            //inputValues.put('var_InputEmailAddress',String.valueOf(sendEmailObject.toAddress));
            List<String> toAddressList = new List<String>();
            toAddressList.add(sendEmailObject.toAddress);
    
            Messaging.SingleEmailMessage  email = new Messaging.SingleEmailMessage();

            email.setTemplateId(sendEmailObject.emailTemplate.Id);
            email.setToAddresses(toAddressList);
            emails.add(email);
            System.debug('email:'+email);
            //System.debug('inputValues:'+inputValues);
            //Flow.Interview mediationRequestSendFrow = Flow.Interview.createInterview('MediationRequestSend', inputValues);
            //System.debug('var_OutputResultType:'+mediationRequestSendFrow.getVariableValue('var_OutputResultType'));

        }
        // エラーが発生した際に全メール中断するか否か
        Boolean allOrNothing = false;
        
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(emails, allOrNothing);

        //エラー処理
        /** 
        System.debug('--- Messaging.SendEmailResult ---');
        for (Integer i = 0; i < results.size(); i++) {
            System.debug('--- i ---> ' + i);
            Messaging.SendEmailResult result = results.get(i);
            System.debug('--- result.isSuccess() ---> ' + result.isSuccess());

            if (!result.isSuccess()) {
                System.debug('--- result.getErrors().size() ---> ' + result.getErrors().size());
                List<Messaging.SendEmailError> errors = result.getErrors();
                for (Messaging.SendEmailError error : errors) {
                    System.debug('--- error.getTargetObjectId() ---> ' + error.getTargetObjectId());
                    System.debug('--- error.getStatusCode() ---> ' + error.getStatusCode());
                    System.debug('--- error.getFields() ---> ' + error.getFields());
                    System.debug('--- error.getMessage() ---> ' + error.getMessage());
                } 
            }
        }
        */

        return result;
    }

    
}