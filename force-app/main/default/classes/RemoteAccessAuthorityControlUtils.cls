/**
 * 在宅アクセス権限制御共通処理のユーティリティクラス
 */
public class RemoteAccessAuthorityControlUtils {

    /**
     * @description エラーメールを送信する
     * @return `void`
     */
	public static void sendErrorEmail(
        RemoteAccessSetting__c remoteAccessSetting) {

		// 送信対象メールリスト
		List<Messaging.SingleEmailMessage> emails = 
			new List<Messaging.SingleEmailMessage>();

		List<String> toAddressList = new List<String>();
		toAddressList.add(remoteAccessSetting.ApexErrorEmailtoAddress__c);
	
		Messaging.SingleEmailMessage  email = 
			Messaging.renderStoredEmailTemplate(
				remoteAccessSetting.ApexErrorEmailTemplate__c, null, null);
	
		email.setToAddresses(toAddressList);
		emails.add(email);

		// エラーが発生した際に全メール中断するか否か
		Boolean allOrNothing = false;
		List<Messaging.SendEmailResult> results = 
            Messaging.sendEmail(emails, allOrNothing);

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
}