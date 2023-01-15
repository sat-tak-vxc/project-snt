/**
 * @description ユーザセルフ登録共通処理のユーティリティクラス
 * 
 * @author hi-takada
 * @date 2022/03/20
 */
public class CommunitiesSelfRegUtils {

    /**
     * @description 取引先担当者へメール送信
     * 
     * @param urSettingInfo 
     * @param u 
     * @param password 
     * @param accountId 
     * @param contactIds 
     * @return `void`
     */
    public static void sendEmailContactCompanyStaff(
        UserRegistration__c urSettingInfo,
        User u,
        String password,
        String accountId,
        List<String> contactIds) {

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        // メールテンプレート取得
        EmailTemplate et = 
            CommunitiesSelfRegModel.getEmailTemplate(
                urSettingInfo.EmailTemplateUserRegistration__c);

        // 組織のメールアドレス取得
        OrgWideEmailAddress owEmailAddress = 
            CommunitiesSelfRegModel.getOrgWideEmailAddress(
                urSettingInfo.OrgWideEmailAddressName__c);

        // ユーザ登録内容で本文に差し込み
        et.HtmlValue = replaceTemplateBody(urSettingInfo, et.HtmlValue, u, password, accountId);
        
        mail.setToAddresses(contactIds);
        mail.setSubject(et.Subject);
        mail.setHtmlBody(et.HtmlValue);
        mail.setOrgWideEmailAddressId(owEmailAddress.Id);

        Boolean allOrNothing = false;
        List<Messaging.SendEmailResult> results = 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }, allOrNothing);

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
    }

    /**
	 * @description ユーザ登録内容で本文に差し込み
	 * @param urSettingInfo 
	 * @param value 
	 * @param u 
	 * @param password 
	 * @param accountId 
	 * @return `String`
	 */
	public static String replaceTemplateBody(
        UserRegistration__c urSettingInfo,
        String value, User u, String password, String accountId) {

        // ユーザ必須項目
        // ユーザ名
        value = value.replace(
            urSettingInfo.EmailTemplateReplaceUsername__c, u.Username);
        // コミュニティユーザ名
        value = value.replace(
            urSettingInfo.EmailTemplateReplaceCommunityUsername__c, u.CommunityUsername__c);
        // メールアドレス
        value = value.replace(
            urSettingInfo.EmailTemplateReplaceEmail__c, u.Email);
        // 姓
        value = value.replace(
            urSettingInfo.EmailTemplateReplaceLastName__c, u.LastName);
        // 名
        value = value.replace(
            urSettingInfo.EmailTemplateReplaceFirstName__c, u.FirstName);
        // ニックネーム
        value = value.replace(
            urSettingInfo.EmailTemplateReplaceCommunityNickname__c, u.CommunityNickname);
        // プロファイル
        value = value.replace(
            urSettingInfo.EmailTemplateReplaceProfileId__c, u.ProfileId);
        
        // ユーザ任意項目
        // 携帯電話 
        if(String.isNotBlank(u.Phone)){
            value = value.replace(
                urSettingInfo.EmailTemplateReplacePhone__c, u.Phone);
        } else {
            value = value.replace(
                urSettingInfo.EmailTemplateReplacePhone__c, '');
        }

        // その他関連情報
        // パスワード
        value = value.replace(
            urSettingInfo.EmailTemplateReplacePassword__c, password);
        // 取引先ID(企業ID)
        value = value.replace(
            urSettingInfo.EmailTemplateReplaceAccountId__c, accountId);
        // ユーザページ
        value = value.replace(
            urSettingInfo.EmailTemplateReplaceUserPage__c, Site.getBaseUrl());

		return value;
	}
}