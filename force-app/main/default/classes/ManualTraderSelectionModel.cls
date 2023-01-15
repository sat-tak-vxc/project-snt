public class ManualTraderSelectionModel{

    /**
     * @description 新規情報取得（単数）
     * @param newMatterId // 新規ID
     * @return `NewMatter__c`
     */
    //TODO手動
    public static NewMatter__c getNewMatter(String newMatterId) {

        // 新規取得
        return [
            SELECT 
                Id
                , Name
                , Application__c // 申請
                , Application__r.ErrorMessage__c//エラーメッセージ	
                , Application__r.Account__c // 取引先
                , Application__r.MediationRequest__c // 斡旋依頼
                , Application__r.ApplicantCode__c // 申請者社員コード
                , Application__r.DesiredAgency__c // 希望不動産会社
                , Application__r.EmployeeComment__c // 社員コメント
                , Application__r.ToSNTComment__c // SNT宛コメント
                , MediationRequestDate__c //斡旋依頼日	
            FROM NewMatter__c
            WHERE Id = :newMatterId
            LIMIT 1
        ];
    }

     /**
     * @description 都道府県情報取得
     * @return `List<District__c>`
     */
    //TODO手動
    public static List<District__c> getDistrictStates() {

        // 都道府県情報取得（都道府県並び順で取得）
        return [
            SELECT Id, State__c
            FROM District__c
            WHERE IsAllCity__c = true
            ORDER BY StateSortOrder__c
        ];
    }


    public static Map<Id , Account> getAccounts(set<Id> newMatterIds,TraderSelectionSetting__c tsSetting){
        Map<Id , Account> result = new Map<Id , Account>();
        return result;
    }

    /**
     * @description 斡旋依頼取得（新規ID、取引先（不動産会社）ID検索）
     * @param newMatterId // 新規ID
     * @param accountIds // 取引先ID
     * @return `List<MediationRequest__c>`
     */
    //TODO手動
    public static List<MediationRequest__c> getMediationRequestRegistereds(
        Id newMatterId) {

        // 登録済みの斡旋依頼を取得
        try{
        List<MediationRequest__c> result = [
            SELECT 
                Id 
                , MediationInputDate__c
                , ContractCategory__c
                , RequestTraderId__c
                , RequestTraderId__r.Name
            FROM MediationRequest__c
            WHERE NewMatterId__c = :newMatterId 
                AND ContractCategory__c != '成約'
        ];
        return result;
        } catch (AuraHandledException e) {
            return null;
        }   
        
    }
    
    /**
     * @description 斡旋依頼取得（斡旋依頼ID検索）
     * @param mediationRequestIds // 斡旋依頼IDリスト
     * @return `List<MediationRequest__c>`
     */
    public static List<MediationRequest__c> getMediationRequestRequestId(
        Set<Id> mediationRequestIds) {

        // 斡旋依頼を取得    
        return [
            SELECT 
                Id,
                Name,
                ContractCategory__c, 
                RequestTraderId__c,//依頼業者
                RequestTraderId__r.ChatterGroupName__c,//依頼業者.Chatterグループ名
                RequestTraderId__r.NotificationTemplate__r.MediationRequestFeed__c,//依頼業者.通知テンプレート.斡旋依頼テンプレート名
                RequestTraderId__r.NotificationTemplate__r.MediationRequestReportNum__c,//斡旋依頼業者_帳票番号
                RequestTraderId__r.PriorityMediationContactMethod__c//依頼業者.優先斡旋依頼書連絡方法
            
            FROM MediationRequest__c
            WHERE Id IN :mediationRequestIds
        ];
    }
    
    

    /**
     * @description 都道府県、市区郡から紹介可能エリア
     * @param state // 取引先ID
     * @param city // 取引先ID
     * @return `Set<Id>`
     */
    //手動
    public static Set<Id> getAccountIdStateMediationPossibleArea(
        String state, String city) {

        Set<Id> mpAreaAccountId = new Set<Id>();

        if(String.isBlank(state)){
            return mpAreaAccountId;
        }

        // 対応可能エリア検索SQL文
        String selectQuery = '';
        selectQuery += 'SELECT ';
        selectQuery += 'Id, ';
        selectQuery += 'Name, ';
        selectQuery += 'Account__c ';
        selectQuery += 'FROM ';
        selectQuery += 'MediationPossibleArea__c ';

        // WHERE句
        List<String> wheres = new List<String>();

        if(String.isNotBlank(state)){
            wheres.add('State__c = :state');
        }
        if(String.isNotBlank(city)){
            wheres.add('City__c = :city');
        }
        if (!wheres.isEmpty()) {
            selectQuery += 'WHERE ';
            selectQuery += String.join(wheres, ' AND ');
        }

        // 検索SQL実行
        List<MediationPossibleArea__c> mpAreas = Database.query(selectQuery);

        if(!mpAreas.isEmpty()){
            for (MediationPossibleArea__c mpArea : mpAreas){
                mpAreaAccountId.add(mpArea.Account__c);
            }
        }
      
        return mpAreaAccountId;
    }


     /**
     * @description 斡旋依頼取得（登録済み）
     * @param newMatterId // 新規ID
     * @param accountId // 取引先ID
     * @return `List<MediationRequest__c>`
     */
    public static List<MediationRequest__c> getMediationRequestDelete(
        String newMatterId, String accountId) {

        // 登録済みの斡旋依頼を取得    
        return [
            SELECT 
                Id
            FROM MediationRequest__c
            WHERE NewMatterId__c = :newMatterId 
                AND RequestTraderId__c = :accountId
        ];
    }

     /**
     * @description 画面入力内容から取引先（不動産会社）検索
     * @param accountId // 取引先ID
     * @param accountName // 取引先名
     * @param state // 都道府県
     * @param city // 市区郡
     * @param mpAreaAccountId // 紹介可能エリアの取引先ID
     * @return `Map<Id, Account>`
     */
    //TODO手動
    public static Map<Id, Account> getAccountInput(
        String accountId, String accountName,
        String state, String city, Set<Id> mpAreaAccountId,
        TraderSelectionSetting__c tsSetting
        ) {

        // レコードタイプ（不動産会社/家主）取得
        RecordType recordType = [
            SELECT Id, Name, DeveloperName, SobjectType, IsActive
            FROM RecordType
            WHERE SobjectType = :tsSetting.SobjectTypeAccount__c 
                AND Name = :tsSetting.RecordTypeNameTrader__c 
                AND IsActive = true
            LIMIT 1
        ];
        String recordTypeId = recordType.Id;

        // 取引先（不動産会社）検索SQL文
        String selectQuery = '';
        selectQuery += 'SELECT ';
        selectQuery += 'Id, ';
        selectQuery += 'Name, ';
        selectQuery += 'BasicRank__c, ';
        selectQuery += 'ParticipatingStore__r.Name, ';
        selectQuery += 'IsTokutokuService__c ';
        selectQuery += 'FROM ';
        selectQuery += 'Account ';

        // WHERE句
        List<String> wheres = new List<String>();
        wheres.add('RecordTypeId = :recordTypeId');

        if(String.isNotBlank(accountId)){
            wheres.add('Id = :accountId');
        }
        if(String.isNotBlank(accountName)){
            wheres.add('Name LIKE ' + '\'%'+ accountName + '%\'');
        }
        if(String.isNotBlank(state) && !mpAreaAccountId.isEmpty()){
            wheres.add('Id IN :mpAreaAccountId');
        }
        if (!wheres.isEmpty()) {
            selectQuery += 'WHERE ';
            selectQuery += String.join(wheres, ' AND ');
        }

        // 検索SQL実行
        List<Account> accounts = Database.query(selectQuery);
        return new Map<Id, Account>(accounts);
    }

    /**
     * @description 市区郡取得
     * @param stateName // 都道府県ID
     * @return `List<District__c>`
     */
    //TODO手動(画面)
    public static List<District__c> getDistrictCitys(String stateName) {

        // 市区郡取得（市区群並び順で取得）
        return [
            SELECT Id, City__c
            FROM District__c
            WHERE State__c = :stateName AND IsAllCity__c = false 
            ORDER BY CitySortOrder__c
        ];
    }

    /**
     * @description 斡旋依頼を登録／更新
     * @param mediationRequests // 斡旋依頼リスト
     * @return `void`
     */
    //手動(画面でも使われている)
    public static void upsertMediationRequest(
        List<MediationRequest__c> mediationRequests) {

        try {

            if (!mediationRequests.isEmpty()) {
                upsert mediationRequests;
            }

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
     * @description 斡旋依頼を更新
     * @param mediationRequests // 斡旋依頼リスト
     * @return `void`
     */
    //手動
    public static void updateMediationRequest(
        List<MediationRequest__c> mediationRequests) {

        try {

            if (!mediationRequests.isEmpty()) {
                update mediationRequests;
            }

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
     * @description 斡旋依頼を削除
     * @param mediationRequests // 斡旋依頼リスト
     * @return `void`
     */
    //TODO手動(画面)
    public static void deleteMediationRequest(
        List<MediationRequest__c> mediationRequests) {

        try {

            if (!mediationRequests.isEmpty()) {
                delete mediationRequests;
            }

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

     

}