@isTest
/**
 * @Description: Testing for class TraderSelection.
 * 
 * @author t-sato
 * @date 2022/09/09
 */
private class SendChatterTest{
   
    @isTest(SeeAllData=true) 
    static void createSendChatterObject(){
        SendChatter sendChatter = new SendChatter();

        //User
        User u = createUser();
        
        //SendChatterオブジェクト
        sendChatter.SendChatterObject.mentionId = u.id;
        sendChatter.SendChatterObject.text = 'test';
        sendChatter.SendChatterObject.feedItemInput = u.Id;

        sendChatter.addObject();

        Test.startTest();

        sendChatter.send();
        
        Test.stopTest();
    }
    static User createUser(){
        
        Profile p = [Select Id from Profile Where Name = 'オペレーター'];
        
        User u = new User(
            LastName = 'testuser',
            Alias = 'newUser',
            Email = 'test@xx.xxx.com',
            UserName = 'test@xx.xxx.com',
            ProfileId = p.Id,
            EmailEncodingKey = 'ISO-2022-JP',
            LanguageLocaleKey = 'ja',
            LocaleSidKey = 'ja_JP',
            TimeZoneSidKey = 'Asia/Tokyo'
        );
        return u;
    }
}