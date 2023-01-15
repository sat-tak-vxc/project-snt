/**
 * @Description: TestDataactory.
 * 
 * @author hi-takada
 * @date 2022/03/20
 */
@isTest
public class CommunitiesSelfRegTestDataFactory {

    /**
     * @Description カスタム設定を作成
     * @return `SyatakusanSetting__c`
     */
    public static SyatakusanSetting__c createSyatakusanSetting(){

        SyatakusanSetting__c syatakusanSetting = new SyatakusanSetting__c();
        syatakusanSetting.SystemUserId__c = '005O0000007fyxo';
        insert syatakusanSetting;

        return syatakusanSetting;
    }

    /**
     * @Description カスタム設定を作成
     * @return `UserRegistration__c`
     */
    public static UserRegistration__c createUserRegistration(){

        UserRegistration__c userRegistration = new UserRegistration__c();
        userRegistration.AccountIdLabel__c = '取引先ID(企業ID)';
        userRegistration.CommunityUsernameLabel__c = 'ユーザ名';
        userRegistration.LastnameLabel__c = '姓';
        userRegistration.FirstnameLabel__c = '名';
        userRegistration.CommunityNicknameLabel__c = 'ニックネーム';
        userRegistration.EmailLabel__c = 'メールアドレス';
        userRegistration.PhoneLabel__c = '携帯電話';
        userRegistration.PasswordLabel__c = 'パスワード';
        userRegistration.ConfirmPasswordLabel__c = 'パスワード（確認）';
        userRegistration.RequiredErrorMessageAccountId__c = '取引先ID(企業ID)は必須です。';
        userRegistration.RequiredErrorMessageCommunityUsername__c = 'ユーザ名は必須です。';
        userRegistration.RequiredErrorMessageLastname__c = '姓は必須です。';
        userRegistration.RequiredErrorMessageFirstname__c = '名は必須です。';
        userRegistration.RequiredErrorMessageCommunityNickname__c = 'ニックネームは必須です。';
        userRegistration.RequiredErrorMessagePassword__c = 'パスワードは必須です。';
        userRegistration.InputErrorMessageAccountId__c = '取引先ID(企業ID)の入力値が不正です。';
        userRegistration.SobjectTypeAccount__c = 'Account';
        userRegistration.SobjectTypeContact__c = 'Contact';
        userRegistration.RecordTypeAccountAccount__c = '委託企業';
        userRegistration.RecordTypeAccountRealEstateAgency__c = '不動産会社/家主';
        userRegistration.RecordTypeContactAccount__c = '企業社員';
        userRegistration.RecordTypeContactRealEstateAgency__c = '不動産管理会社';
        userRegistration.RecordTypeContactCompanyStaff__c = '社宅担当者';
        userRegistration.ProfileAccount__c = '企業コミュニティユーザ(社員)';
        userRegistration.ProfileRealEstateAgency__c = '不動産コミュニティユーザ';
        userRegistration.DomainAccount__c = '@invalid_01.co.jp';
        userRegistration.DomainRealEstateAgency__c = '@invalid_02.co.jp';
        userRegistration.DummyEmailDomainAccount__c = '@virtualex.co.jp';
        userRegistration.DummyEmailDomainRealEstateAgency__c = '@virtualex.co.jp';
        userRegistration.EmailTemplateUserRegistration__c = 'ポータルユーザ登録テンプレート';
        userRegistration.OrgWideEmailAddressName__c = '日本社宅サービス';
        userRegistration.EmailTemplateReplaceAccountId__c = '#AccountId#';
        userRegistration.EmailTemplateReplaceUsername__c = '#Username#';
        userRegistration.EmailTemplateReplaceCommunityUsername__c = '#CommunityUsername__c#';
        userRegistration.EmailTemplateReplaceLastName__c = '#LastName#';
        userRegistration.EmailTemplateReplaceFirstName__c = '#FirstName#';
        userRegistration.EmailTemplateReplaceCommunityNickname__c = '#CommunityNickname#';
        userRegistration.EmailTemplateReplaceEmail__c = '#Email#';
        userRegistration.EmailTemplateReplacePhone__c = '#Phone#';
        userRegistration.EmailTemplateReplacePassword__c = '#Password#';
        userRegistration.EmailTemplateReplaceProfileId__c = '#ProfileId#';
        userRegistration.EmailTemplateReplaceUserPage__c = '#UserPage#';
        
        insert userRegistration;

        return userRegistration;
    }


}