/**
 * ポータルサイト：ログイン
 * @author t-ooshiro-bp
 * @since 2022/03/30
 */
 public class CommunitiesLoginController {

    /**
     * カスタム設定
     */
    public CommunitiesLogin__c setting {get; set;}
    /**
     * リクエストパラメータ：取引先ID
     */
    public String accountId {get; set;}
    /**
     * 画面項目：ユーザ名
     */
    public String communityUsername {get; set;}
    /**
     * 画面項目：パスワード
     */
    public String password {get; set;}

    /**
     * ユーザセルフ登録のリンクを出すか。
     */
    public Boolean isRegistrationEnabled {get; set;}

    /**
     * コンストラクタ
     */
    public CommunitiesLoginController () {
        String expid = ApexPages.currentPage().getParameters().get('expid');
        accountId = ApexPages.currentPage().getParameters().get('id');
        setting = CommunitiesLogin__c.getOrgDefaults();
        isRegistrationEnabled = false;
        if (expId != null) {
            Site.setExperienceId(expId);
        }
    }

    /**
     * @description 必須入力チェック
     */
    public void isRequiredInput() {
        // ユーザ名
        if (String.isBlank(communityUsername)) {
            ApexPages.addMessage(createError(setting.CommunityUsernameLabel__c + setting.RequiredErrorMessage__c));
        }
        // パスワード
        if (String.isBlank(password)) {
            ApexPages.addMessage(createError(setting.PasswordLabel__c + setting.RequiredErrorMessage__c));
        }
    }

    private ApexPages.Message createError(String message) {
        return new ApexPages.Message(ApexPages.Severity.ERROR, message);
    }

    /**
     * @description 初期化
     * 
     * @return `PageReference`
     */
    public PageReference init() {
     
        try {
            List<Account> accounts = CommunitiesLoginModel.getAccount(accountId);
            if(accounts.size() <= 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'IDが誤っています'));
            }

        }catch (Exception e) {

            Apexpages.addMessages(e);
            //ApexPages.addMessage(new ApexPages.Message(e.getMessage()));

        }
        //RecordType recordType = CommunitiesLoginModel.getRecordType(setting.RecordTypeAccountAccount__c, account.RecordTypeId);
        return null;
    }

    /**
     * @description ログイン
     * 
     * @return `PageReference`
     */
    public PageReference login() {

        isRequiredInput();

        User user = CommunitiesLoginModel.getUser(accountId, communityUsername);

        return Site.login(
            user.id, 
            password, 
            ApexPages.currentPage().getParameters().get('startURL'));
    }

}