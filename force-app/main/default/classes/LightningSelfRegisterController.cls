global class LightningSelfRegisterController {

    public LightningSelfRegisterController() {

    }

    @TestVisible 
    private static boolean isValidPassword(String password, String confirmPassword) {
        return password == confirmPassword;
    }
    
    @TestVisible 
    private static boolean siteAsContainerEnabled(String communityUrl) {
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(communityUrl,'');
        return authConfig.isCommunityUsingSiteAsContainer();
    }
    
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
        String accountId, String username, String firstname, String lastname,
        String communityNickname, String email, String phone, String password, 
        String confirmPassword, String startUrl
    ) {
        System.debug('--- PortalSelfRegisterController selfRegister start ---');

        Savepoint sp = null;
        try {

            sp = Database.setSavepoint();

            String dummyEmail = 'testUser@salesforce.com';
            String userDomain = '@virtualex.co.jp';
            
            User u = new User();
            // ユーザ名
            u.Username = username + userDomain;
            // コミュニティユーザ名
            u.put('CommunityUsername__c', username);
            // 姓
            u.FirstName = firstname;
            // 名
            u.LastName = lastname;
            // ニックネーム
            u.put('CommunityNickname', communityNickname);
            // メールアドレス
            if (email == null || String.isEmpty(email)) {
                // メールアドレス入力が空の場合、ダミーの値を設定
                email = dummyEmail;
            }
            u.put('Email',email);
            // 携帯電話
            if (phone == null || String.isEmpty(phone)) {
                u.put('Phone', phone);
            }

            // モバイルログイン
            String networkId = Network.getNetworkId();
            if(networkId != null && siteAsContainerEnabled(Network.getLoginUrl(networkId))) {
                // サポートされるモバイルブラウザから 
                // Salesforceにログインするときにユーザに表示されるインターフェースを制御 → 有効化
                u.put('UserPreferencesHideS1BrowserUI',true);
            }
   
            // パスワードチェック
            if (!isValidPassword(password, confirmPassword)) {
                return Label.site.passwords_dont_match;
            }
            System.debug('--- validatePassword start ---');
            validatePassword(u, password, confirmPassword);

            System.debug('--- validatePassword end ---');
            String userId = null;

            // 
            // String userId = Site.createPortalUser(u, accountId, password);

            // create a fake userId for test.
            if (Test.isRunningTest()) {
                userId = 'fakeUserId';           
            }
            if (userId != null) { 
                if (password != null && password.length() > 1) {
                    ApexPages.PageReference lgn = Site.login(email, password, startUrl);
                    if(!Test.isRunningTest()) {
                        aura.redirect(lgn);
                    }
                }
            }
            System.debug('--- PortalSelfRegisterController selfRegister end ---');
            return null;
        }
        catch (Exception ex) {
            Database.rollback(sp);
            return ex.getMessage();            
        }
    }
    
    @AuraEnabled
    public static List<Map<String,Object>> getExtraFields(String extraFieldsFieldSet) { 
        List<Map<String,Object>> extraFields = new List<Map<String,Object>>();
        Schema.FieldSet fieldSet = Schema.SObjectType.User.fieldSets.getMap().get(extraFieldsFieldSet);
        if(!Test.isRunningTest()) {
        if (fieldSet != null) {
            for (Schema.FieldSetMember f : fieldSet.getFields()) {
                Map<String, Object> fieldDetail = new Map<String, Object>();
                fieldDetail.put('dbRequired', f.getDBRequired());
                fieldDetail.put('fieldPath', f.getFieldPath());
                fieldDetail.put('label', f.getLabel());
                fieldDetail.put('required', f.getRequired());
                fieldDetail.put('type', f.getType());
                fieldDetail.put('value', '');   // client will populate
                extraFields.add(fieldDetail);
            }}}
        return extraFields;
    }
    
    @AuraEnabled
    global static String setExperienceId(String expId) {
        // Return null if there is no error, else it will return the error message 
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