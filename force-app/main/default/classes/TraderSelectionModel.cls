/**
 * 斡旋業者選定画面のモデルクラス
 */
public class TraderSelectionModel {
    /**
     * @description 取引先担当者取得（単数）
     * @param contactId // 取引先担当者ID
     * @return `Contact`
     */
    public static Contact getContact(Id contactId) {
        system.debug(limits.getQueries());

        // 取引先担当者取得
        Contact result = ([
            SELECT 
                Id
                , CorporateHousingRegulation__c // 社宅規定
                , CorporateHousingRegulation__r.SelectionRule__c // 不動産選定ルール
                , CorporateHousingRegulation__r.SelectionCount__c // 選定数 
            FROM Contact
            WHERE Id = :contactId  
            LIMIT 1
        ]);
        return result;
    }
    
    
    
    /**
     * @description 本店を取得
     * @author t-sato
     * @param requestTraders 
     * @param tsSetting 
     * @return  `Map<String,Account>`
     */
    //通知
    public static Map<String,Account> getAccountSendMediationRequest(
        Map<Id,Account> requestTraders,
        TraderSelectionSetting__c tsSetting
    ){
        Map<String,Account> result =  new Map<String,Account>();

        //グループIDをリストで取得
        List<String> GroupIds = new List<String>();
        for(Id id : requestTraders.keySet()){
            GroupIds.add(requestTraders.get(id).AccountGroupId__c);//TODO 取引先グループIDを格納
        }

        // レコードタイプ（不動産会社/家主）取得
        RecordType recordType = [
            SELECT Id, Name, DeveloperName, SobjectType, IsActive
            FROM RecordType
            WHERE SobjectType = :tsSetting.SobjectTypeAccount__c
                AND Name = :tsSetting.RecordTypeNameTrader__c 
                AND IsActive = true
            LIMIT 1
        ];

        // 取引先（不動産会社）取得
        Map<Id, Account> accounts = new Map<Id, Account>([
            SELECT 
                Id
                , Name
                , BasicRank__c // 基本ランク
                , IsTokutokuService__c // 得々サービス有無
                , MainEmail__c // メール
                , NotificationMethod__c // 自動通知方法
                , ChatterGroupName__c //Chatterグループ名
                , NotificationTemplate__r.MediationRequestMail__c // メールテンプレート
                , NewMatterTeam__r.OwnerId//新規/斡旋チーム キューグループ
                , PriorityMediationContactMethod__c//優先斡旋依頼書連絡方法
            FROM Account
            WHERE 
                Id IN :GroupIds
                AND Name != null
                AND RecordTypeId = :recordType.Id
        ]);

        for(Id id : accounts.keySet()){
            Account account = accounts.get(id);
            String groupId = account.Name;
            result.put(groupId,account);
        }

        return result;
    }
    /**
     * @description 社宅規定を取得
     * @param newMatterId // 新規Id
     * @return DesiredCondition__c
     */
    public static CorporateHousingRegulation__c getCorporateHousingRegulation(
        Id accountId
    ){
        CorporateHousingRegulation__c result = [
            SELECT 
                Id, 
                SelectionCount__c //選定数
            FROM CorporateHousingRegulation__c
            WHERE
                Account__c = :accountId
            LIMIT 1
        ];
        return result;
    }

    /**
     * @description 不動産キャパ取得
     * @param accountIds // 取引先ID
     * @return `Map<Id, AgencyCapacity__c>`
     */
    //手動　斡旋
    public static Map<Id, AgencyCapacity__c> getAgencyCapacityToAccountId(
        Set<Id> accountIds) {

        // 返却マップ 
        Map<Id, AgencyCapacity__c> agencyCapacitys = 
            new Map<Id, AgencyCapacity__c>();

        // 引数が空の場合は処理終了
        if(accountIds.isEmpty()){
            return agencyCapacitys;
        }

        for (AgencyCapacity__c agencyCapacity : [
            SELECT 
                Id
                , Account__c // 取引先
                , CapacityNum__c // キャパ件数
                , ReserveNum__c // 依頼中件数
                , RequestingFmNum__c // 依頼中件数(基幹)
                , RequestingNum__c // 新商材
                , RequestingNewCommodity__c // 余力
            FROM AgencyCapacity__c
            WHERE Account__c IN :accountIds
        ]) {

            if(String.isNotBlank(agencyCapacity.Account__c)){
                agencyCapacitys.put(
                    agencyCapacity.Account__c, agencyCapacity);
            }
        }
      
        return agencyCapacitys;
    }

    /**
     * @description 希望条件を取得
     * @param newMatterId // 新規Id
     * @return `DesiredCondition__c`
     */
    //TODO両方
    public static DesiredCondition__c getDesiredCondition(Id applicationId) {
        System.debug('DesiredCondition__c:'+applicationId);

        // 希望条件を取得      
        DesiredCondition__c result = new DesiredCondition__c();
        result = [
            SELECT 
                Id ,Application__c
            FROM DesiredCondition__c
            WHERE Application__c = :applicationId
            LIMIT 1
        ];
        return result;
    }

    /**
     * @description 取引先の取得
     * @param accountIds // 取引先IDリスト
     * @return `Map<Id, Account>`
     */
    public static Account getAccount(
        Id accountId) {

        Account result = new Account();

        // 引数が空の場合は処理終了
        if(accountId == null){
            return result;
        }
        result = [
            SELECT 
                Id
                , ServiceContractNewMatter__c // サービス_新規
                , ServiceContractNewMatter__r.IsAutoMediationRequest__c // 斡旋自動対応不可フラグ
            FROM Account
            WHERE Id = :accountId
            ];
        return result;
    }

     /**
     * @description 取引先(不動産)の取得
     * @param accountIds // 取引先IDリスト
     * @return `Map<Id, Account>`
     */
    public static Account getTrader(
        Id accountId) {

        Account result = new Account();

        // 引数が空の場合は処理終了
        if(accountId == null){
            return result;
        }
        result = [
            SELECT 
                Id
                , Name
                , IsTokutokuService__c // 得々サービス
                , BasicRank__c //基本ランク
                , ParticipatingStore__r.Name //加盟店名
            FROM Account
            WHERE Id = :accountId
            ];
        return result;
    }

     

     /**
     * @description 休日有無取得
     * @author sato-takumi
     * @param  emailTemplateNames //メールテンプレート名
     * @return Boolean
     */
    //手動
    public static Boolean getHolidayToday() {
        //返却値
        Boolean result = True;

        //取得結果を返却マップに格納
        for(Holiday holiday: [
            SELECT ActivityDate
            FROM Holiday
            WHERE ActivityDate = :Date.today()
            ])result = False;
        
        return result;
    }

    public static Map<Id,NotificationTemplate__c> getNotificationTemplates(
        Set<Id> AccountIds
        ){
            Map<Id,NotificationTemplate__c> result = new Map<Id,NotificationTemplate__c>();
            //取得結果を返却マップに格納
            for(NotificationTemplate__c notificationTemplate: [
                SELECT 
                Id,
                MediationRequestMail__c
                FROM NotificationTemplate__c
                WHERE Account__c IN :AccountIds 
            ])result.put(notificationTemplate.Id,notificationTemplate);
            return result;

    }

    
}