/**
 * @description ユーザセルフ登録モデルクラス
 * 
 * @author hi-takada
 * @date 2022/03/20
 */
public class CommunitiesSelfRegModel {

	/**
	 * @description 取引先IDから取引先を取得
	 * @param accountId 
	 * @return  `Account`
	 */
	public static List<Account> getAccount(String accountId) {
		return [
			SELECT
			    Id,
				RecordTypeId
			FROM Account
			WHERE AccountId__c = :accountId
		];
	}


    /**
	 * @description IDからユーザを取得
	 * @param userId 
	 * @return  `User`
	 */
	public static User getUser(String userId) {
		return [
			SELECT
			    Id,
				ContactId,
				Username,
				CommunityUsername__c,
				Email,
				LastName,
				FirstName,
				CommunityNickname,
				Phone,
				ProfileId
			FROM User
			WHERE Id = :userId
		];
	}


	/**
	 * @description 取引先担当者（レコードタイプ：社宅担当者）を取得
	 * @param accountId 
	 * @param recordTypeId 
	 * @return  `List<String>`
	 */
	public static List<String> getContactSendEmail(
        String accountId, String recordTypeId) {
		
		List<String> contactIds = new List<String>();

		for (Contact contact : [
            SELECT
		        Id, Name
			FROM Contact
			WHERE AccountId = :accountId
            AND RecordTypeId = :recordTypeId
		]) {
			contactIds.add((String)contact.get('Id'));
		}

		return contactIds;

	}


	/**
	 * @description 取引先担当者更新
	 * @param contact 
	 */
	public static void updateContact(Contact contact) {

		// 更新対象がnullの場合は何もしない
		if (contact == null) {
			return;
		}
		try {
			update contact;
		} catch(DmlException e) {
			System.debug('--- DmlException ---');
			System.debug('--- e.getNumDml() ---> ' + e.getNumDml());
			for (Integer index = 0; index < e.getNumDml(); index++) {
				System.debug('--- index ---> ' + index);
				System.debug('--- e.getDmlId(index) ---> ' + e.getDmlId(index));
				System.debug('--- e.getDmlIndex(index) ---> ' + e.getDmlIndex(index));
				System.debug('--- e.getDmlFieldNames(index) ---> ' + e.getDmlFieldNames(index));
				System.debug('--- e.getDmlMessage(index) ---> ' + e.getDmlMessage(index));
				System.debug('--- e.getDmlType(index).name() ---> ' + e.getDmlType(index).name());
			}
			throw e;
		} catch(Exception e) {
			System.debug('--- Exception ---');
			System.debug('--- e.getTypeName() ---> ' + e.getTypeName());
			System.debug('--- e.getCause() ---> ' + e.getCause());
			System.debug('--- e.getLineNumber() ---> ' + e.getLineNumber());
			System.debug('--- e.getMessage() ---> ' + e.getMessage());

			throw e;
		}
	}

	
	/**
	 * @description レコードタイプ（取引先）情報取得
	 * @param urSettingInfo カスタム設定
	 * @return  `Map<String, RecordType>`
	 */
	public static Map<String, RecordType> getRecordTypeAccounts(
		UserRegistration__c urSettingInfo) {

		// オブジェクトタイプ_取引先のレコードタイプ取得
		Map<String, RecordType> recordTypes = 
			new Map<String, RecordType>();

		for (RecordType recordType : [
			SELECT Id, Name, DeveloperName, SobjectType, IsActive
			FROM RecordType
			WHERE SobjectType = :urSettingInfo.SobjectTypeAccount__c
				AND IsActive = true
		]) {

			if(String.isNotBlank(String.valueOf(recordType.get('Name')))){
				recordTypes.put(
					(String)recordType.get('Name') , recordType);
			}
		}

		return recordTypes;
	}


	/**
	 * @description レコードタイプ（取引先担当者）情報取得
	 * @param urSettingInfo カスタム設定
	 * @return  `Map<String, RecordType>`
	 */
	public static Map<String, RecordType> getRecordTypeContacts(
		UserRegistration__c urSettingInfo) {

		// オブジェクトタイプ_取引先担当者のレコードタイプ取得
		Map<String, RecordType> recordTypes = 
			new Map<String, RecordType>();

		for (RecordType recordType : [
			SELECT Id, Name, DeveloperName, SobjectType, IsActive
			FROM RecordType
			WHERE SobjectType = :urSettingInfo.SobjectTypeContact__c
				AND IsActive = true
		]) {

			if(String.isNotBlank(String.valueOf(recordType.get('Name')))){
				recordTypes.put(
					(String)recordType.get('Name') , recordType);
			}
		}

		return recordTypes;
	}


	/**
	 * @description プロファイル情報取得
	 * @return  `Map<String, Profile>`
	 */
	public static Map<String, Profile> getProfiles() {

		Map<String, Profile> profiles = 
			new Map<String, Profile>();

		for (Profile profile : [
			SELECT Id, Name
			FROM Profile
		]) {

			if(String.isNotBlank(String.valueOf(profile.get('Name')))){
				profiles.put(
					(String)profile.get('Name') , profile);
			}
		}

		return profiles;
	}


	/**
	 * @description メールテンプレート情報取得
	 * @param emailTemplateName
	 * @return `EmailTemplate`
	 */
	public static EmailTemplate getEmailTemplate(String emailTemplateName) {

		return [
			SELECT 
				Id, 
				Subject,
				HtmlValue 
			FROM EmailTemplate 
			WHERE Name = :emailTemplateName
		];
	}


	/**
	 * @description 組織のメールアドレスを取得
	 * @param displayName 
	 * @return  `OrgWideEmailAddress`
	 */
	public static OrgWideEmailAddress getOrgWideEmailAddress(
		String displayName) {

		return [
			SELECT
			    Id
			FROM OrgWideEmailAddress
			WHERE DisplayName = :displayName
		];
	}

}