/**
 * @description ユーザセルフ登録
 *  An apex page controller that supports self registration of users
 *  in communities that allow self registration
 * 
 * @author hi-takada
 * @date 2022/03/20
 */
public class CommunitiesSelfRegController {

    /**
     * 画面項目：取引先ID(企業ID)
     */
    public String accountId {get; set;}
    /**
     * 画面項目：ユーザ名
     */
    public String communityUsername {get; set;}
    /**
     * 画面項目：姓
     */
    public String lastname {get; set;}
    /**
     * 画面項目：名
     */
    public String firstname {get; set;}
    /**
     * 画面項目：ニックネーム
     */
    public String communityNickname {get; set;}
    /**
     * 画面項目：メールアドレス
     */
    public String email {get; set;}
    /**
     * 画面項目：携帯電話
     */
    public String phone {get; set;}
    /**
     * 画面項目：パスワード
     */
    public String password {get; set;}
    /**
     * 画面項目：パスワード（確認）
     */
    public String confirmPassword {get; set;}
    
    public CommunitiesSelfRegController() {
        String expid = ApexPages.currentPage().getParameters().get('expid');
        if (expId != null) {
            Site.setExperienceId(expId);
        }    
    }


    /**
     * @description 必須入力チェック
     * 
     * @param urSettingInfo カスタム設定
     * @return `Boolean`
     */
    private Boolean isRequiredInput(UserRegistration__c urSettingInfo) {
        Boolean isRequiredInput = true;

        if (String.isBlank(accountId)) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    urSettingInfo.RequiredErrorMessageAccountId__c));
            isRequiredInput = false;
        }
        if (String.isBlank(communityUsername)) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    urSettingInfo.RequiredErrorMessageCommunityUsername__c));
            isRequiredInput = false;
        }
        if (String.isBlank(lastname)) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    urSettingInfo.RequiredErrorMessageLastname__c));
            isRequiredInput = false;
        }
        if (String.isBlank(firstname)) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    urSettingInfo.RequiredErrorMessageFirstname__c));
            isRequiredInput = false;
        }
        if (String.isBlank(communityNickname)) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    urSettingInfo.RequiredErrorMessageCommunityNickname__c));
            isRequiredInput = false;
        }
        if (String.isBlank(password)) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    urSettingInfo.RequiredErrorMessagePassword__c));
            isRequiredInput = false;
        }
        return isRequiredInput;
    }


    /**
     * @description パスワード確認
     * 
     * @return `Boolean`
     */
    private Boolean isValidPassword() {
        return password == confirmPassword;
    }


    /**
     * @description セルフ登録実行
     * 
     * @return `PageReference`
     */
    public PageReference registerUser() {

        // カスタム設定
        UserRegistration__c urSettingInfo = 
            UserRegistration__c.getOrgDefaults();

        // 必須チェック
        if (!isRequiredInput(urSettingInfo)) {
            return null;
        }

        // パスワード、確認パスワード一致チェック
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(
                ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }

        // 入力取引先ID(企業ID)から取引先を検索
        List<Account> account = CommunitiesSelfRegModel.getAccount(accountId);
        if(account.isEmpty()){
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    urSettingInfo.InputErrorMessageAccountId__c));
            return null;
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
        if(account.get(0).RecordTypeId == 
            recordTypeAccounts.get(urSettingInfo.RecordTypeAccountAccount__c).Id){

            // 企業コミュニティユーザ(社員)
            profileId = profiles.get(urSettingInfo.ProfileAccount__c).Id;
            // 企業社員
            contractRecordType = 
                recordTypeContacts.get(urSettingInfo.RecordTypeContactAccount__c).Id;

            userDomain = urSettingInfo.DomainAccount__c;
            dummyEmailDomain = urSettingInfo.DummyEmailDomainAccount__c;
        } 
        // 不動産会社/家主の場合
        else if(account.get(0).RecordTypeId == 
            recordTypeAccounts.get(urSettingInfo.RecordTypeAccountRealEstateAgency__c).Id) {

            // 不動産コミュニティユーザ
            profileId = profiles.get(urSettingInfo.ProfileRealEstateAgency__c).Id;
            // 不動産管理会社
            contractRecordType = 
                recordTypeContacts.get(urSettingInfo.RecordTypeContactRealEstateAgency__c).Id;

            userDomain = urSettingInfo.DomainRealEstateAgency__c;
            dummyEmailDomain = urSettingInfo.DummyEmailDomainRealEstateAgency__c;
        } else {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    urSettingInfo.InputErrorMessageAccountId__c));
            return null;
        }

        // String roleEnum = null; // To be filled in by customer.

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
		
        String userId;
        PageReference page;

        try {
            // ユーザ作成
            userId = Site.createExternalUser(u, account.get(0).Id, password);
            // ログイン
            page = Site.login(
                u.Username, password,
                ApexPages.currentPage().getParameters().get('startURL'));

        } catch(Site.ExternalUserCreateException ex) {
            List<String> errors = ex.getDisplayMessages();
            for (String error : errors)  {
                ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }
            System.debug(ex.getMessage());
            return null;
        }

        // ※テストではSite.createExternalUser()の結果は空で設定される
        if (userId != null) { 
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

            return page;
            
        }

        return null;
    }


}