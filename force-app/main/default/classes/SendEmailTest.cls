@isTest
private class SendEmailTest{

    @isTest
    static void createSendEmailObject(){
        //メールテンプレートの作成
        EmailTemplate emailTemplate =  createEmailTemplate(true);

        SendEmail sendEmail = new SendEmail();
        //sendEmail.sendEmailObject.emailTemplateId = emailTemplate.id;
        //sendEmail.sendEmailObject.whatId = null;
        sendEmail.sendEmailObject.toAddress = 'sample@address.com';
        sendEmail.sendEmailObject.Body = emailTemplate.Body;
        sendEmail.sendEmailObject.subject = emailTemplate.Subject;

        sendEmail.addObject();

        Test.startTest();

        sendEmail.send();

        Test.stopTest();

    }

    public static EmailTemplate createEmailTemplate(Boolean insFlg) {
        EmailTemplate result = new EmailTemplate();
        result.isActive = true;
        result.Name = 'name';
        result.DeveloperName = 'unique_name_addSomethingSpecialHere';
        result.TemplateType = 'text';
        result.FolderId = UserInfo.getUserId();
        result.Subject = 'Your Subject Here';
        result.Body = 'Sample Body';
        if(insFlg) {
            insert result;
        }
        return result;
    }

}