/**
 * 
 * @author t-ooshiro-bp
 * @since 2022/03/30
 */
public class CommunitiesLoginModel {

    /**
     * 取引先の取得
     * @param id Salesforce Id
     * @return  List<Account>
     */
    public static List<Account> getAccount(Id accountId) {        
        return [
                SELECT Id, Name, RecordTypeId 
                FROM Account
                WHERE id = :accountId
                LIMIT 1
        ];
    }

    /**
     * レコードタイプ情報取得
     * @param id Salesforce Id
     * @return  RecordType
     */
    public static RecordType getRecordType(String recordTypeNmae, Id recordTypeId) {        
        return  [
                SELECT Id, Name, DeveloperName, SobjectType, IsActive 
                FROM RecordType
                WHERE id = :recordTypeId
                  AND Name = :recordTypeNmae
                  AND IsActive = true
                LIMIT 1
        ];
    }

    /**
     * ContactIdとユーザ名（ニックネーム）からユーザIDを取得
     * @param accountId 取引先のSalesforce Id
     * @param username ユーザ名（ニックネーム）
     * @return  `User`
     */
    public static User getUser(Id accountId, String username) {
        return [
                SELECT Id, Name 
                FROM User
                WHERE 
                    Id = :accountId
                    AND CommunityNickname = :username
                    AND IsActive = true
                Limit 1
        ];
    }
}