global class PortalSelfRegisterController {

    public PortalSelfRegisterController() {
    }


	/**
	 * パスワード入力チェック
	 * @param password 
	 * @param confirmPassword
	 */
    @TestVisible 
    private static boolean isValidPassword(String password, String confirmPassword) {
        return password == confirmPassword;
    }


	/**
	 * Site.comページを使用チェック
	 * @param communityUrl 
	 */
    @TestVisible 
    private static boolean siteAsContainerEnabled(String communityUrl) {
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(communityUrl,'');
        return authConfig.isCommunityUsingSiteAsContainer();
    }
    

	/**
	 * パスワードポリシー要件チェック
	 * @param communityUrl 
	 */
    @TestVisible 
    private static void validatePassword(User u, String password, String confirmPassword) {
        if(!Test.isRunningTest()) {
            Site.validatePassword(u, password, confirmPassword);
        }
        return;
    }
    

    /**
	 * セルフ登録処理
	 * @param accountId
     * @param username
	 * @param firstname 
	 * @param lastname
	 * @param communityNickname
	 * @param email
	 * @param phone
	 * @param password
	 * @param confirmPassword
	 * @param startUrl
	 */
    @AuraEnabled
    public static String selfRegister(
        String accountId,
        String communityUsername,
        String firstname,
        String lastname,
        String communityNickname,
        String email,
        String phone,
        String password, 
        String confirmPassword,
        String startUrl
    ) {
        // カスタム設定
        UserRegistration__c urSettingInfo =  UserRegistration__c.getOrgDefaults();

        // セーブポイント
        Savepoint sp = null;
        try {
            sp = Database.setSavepoint();

            // パスワード、確認パスワード一致チェック
            if (!isValidPassword(password, confirmPassword)) {
                return Label.site.passwords_dont_match;
            }


            // 入力取引先ID(企業ID)から取引先を検索
            List<Account> account = CommunitiesSelfRegModel.getAccount(accountId);
            if(account.isEmpty()){
                return urSettingInfo.InputErrorMessageAccountId__c;
            }

            // レコードタイプ、プロファイル情報取得
            Map<String, RecordType> recordTypeAccounts =
                CommunitiesSelfRegModel.getRecordTypeAccounts(urSettingInfo);
            Map<String, RecordType> recordTypeContacts =
                CommunitiesSelfRegModel.getRecordTypeContacts(urSettingInfo);
            Map<String, Profile> profiles =
                CommunitiesSelfRegModel.getProfiles();

            // ユーザ：プロファイル
            String profileId;
            // 取引先担当者：レコードタイプ
            String contractRecordType;
            // ユーザドメイン
            String userDomain;
            // メールアドレス未入力用ダミーメールドメイン
            String dummyEmailDomain;

            // 委託企業の場合
            if(account.get(0).RecordTypeId == recordTypeAccounts.get(urSettingInfo.RecordTypeAccountAccount__c).Id){
                // 企業コミュニティユーザ(社員)
                profileId = profiles.get(urSettingInfo.ProfileAccount__c).Id;
                // 企業社員
                contractRecordType = recordTypeContacts.get(urSettingInfo.RecordTypeContactAccount__c).Id;
                userDomain = urSettingInfo.DomainAccount__c;
                dummyEmailDomain = urSettingInfo.DummyEmailDomainAccount__c;
            }
            // 不動産会社/家主の場合
            else if(account.get(0).RecordTypeId == recordTypeAccounts.get(urSettingInfo.RecordTypeAccountRealEstateAgency__c).Id) {
                // 不動産コミュニティユーザ
                profileId = profiles.get(urSettingInfo.ProfileRealEstateAgency__c).Id;
                // 不動産管理会社
                contractRecordType = recordTypeContacts.get(urSettingInfo.RecordTypeContactRealEstateAgency__c).Id;
                userDomain = urSettingInfo.DomainRealEstateAgency__c;
                dummyEmailDomain = urSettingInfo.DummyEmailDomainRealEstateAgency__c;
            } else {
                return urSettingInfo.InputErrorMessageAccountId__c;
            }

            User u = new User();
            // ユーザ名
            u.Username = communityUsername + userDomain;
            // コミュニティユーザ名
            u.CommunityUsername__c = communityUsername;
            // メールアドレス
            if (String.isNotBlank(email)) {
                u.Email = email;
            } else {
                // メールアドレス入力が空の場合、ダミーの値を設定
                // 取引先ID + ユーザ名
                u.Email = accountId + communityUsername + dummyEmailDomain;
            }
            // 姓
            u.LastName = lastname;
            // 名
            u.FirstName = firstname;
            // ニックネーム
            u.CommunityNickname = communityNickname;
            // 携帯電話
            if (String.isNotBlank(phone)) {
                u.Phone = phone;
            }
            // プロファイル
            u.ProfileId = profileId;
            // モバイルログイン
            String networkId = Network.getNetworkId();
            if(networkId != null && siteAsContainerEnabled(Network.getLoginUrl(networkId))) {
                // サポートされるモバイルブラウザから 
                // Salesforceにログインするときにユーザに表示されるインターフェースを制御 → 有効化
                u.put('UserPreferencesHideS1BrowserUI', true);
            }

            // ユーザ作成
            String userId = Site.createExternalUser(u, account.get(0).Id, password);
            // ログイン
            ApexPages.PageReference page = Site.login(u.Username, password, startUrl);

            // 登録ユーザ情報取得
            User userReg = CommunitiesSelfRegModel.getUser(userId);

            // 更新する取引先担当者を設定
            Contact contacInfo = new Contact();
            contacInfo.Id = userReg.ContactId;
            contacInfo.RecordTypeId = contractRecordType;    
            // 取引先担当者更新
            CommunitiesSelfRegModel.updateContact(contacInfo);

            // メール送信取引先担当者（レコードタイプ：社宅担当者）のID取得
            List<String> contactSendEmails = CommunitiesSelfRegModel.getContactSendEmail(
                account.get(0).Id, 
                recordTypeContacts.get(
                    urSettingInfo.RecordTypeContactCompanyStaff__c).Id);

            // 取引先担当者（レコードタイプ：社宅担当者）へメール送信
            CommunitiesSelfRegUtils.sendEmailContactCompanyStaff(
                urSettingInfo, userReg, password, accountId, contactSendEmails);

            if(!Test.isRunningTest()) {
                aura.redirect(page);
            }
            return null;
        } catch(Site.ExternalUserCreateException ex) {
            Database.rollback(sp);
            return String.join(ex.getDisplayMessages(), '\r');
        } catch (Exception ex) {
            Database.rollback(sp);
            return ex.getMessage();            
        }
    }
    
    @AuraEnabled
    global static String setExperienceId(String expId) {
        // エラーがない場合はnullを返し、そうでない場合はエラーメッセージを返します
        try {
            if (expId != null) {
                Site.setExperienceId(expId);   
            }
            return null; 
        } catch (Exception ex) {
            return ex.getMessage();            
        }        
    }  
}