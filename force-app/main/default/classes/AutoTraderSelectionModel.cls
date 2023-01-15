public class AutoTraderSelectionModel {
    /**
     * @description 申請レコードのIDから申請を取得
     * @param applicationIds // 申請IDリスト
     * @return `Map<Id, Application__c>`
     */
    public static Application__c getApplicationWhereId(Id applicationId) {

        // 申請を取得
        // 条件；新規．申請
        List<Application__c> results = [
            SELECT 
                Id
                , ApplicantCode__c // 申請者社員コード（参照：取引先担当者）
                , Account__c // 取引先（参照：取引先）
                , MediationRequest__c // 斡旋依頼（True: 自動斡旋依頼、False:手動斡旋依頼）
                , RealEstate1__c //対象物件1
                , RealEstate2__c //対象物件2
                , RealEstate3__c //対象物件3
                , DesiredAgency__c // 希望不動産会社
                , DesiredAreaState__c // 希望エリア_都道府県
                , DesiredAreaCity__c // 希望エリア_市町村
                , ToSNTComment__c // SNT連絡事項
                , ErrorMessage__c //エラーメッセージ
                , AlertMessage__c //アラートメッセージ
            FROM Application__c
           WHERE Id = :String.valueOf(applicationId) 
           LIMIT 1
        ];

        System.debug([
            SELECT Id
            FROM Contact
        ]);
        System.debug('results:'+results);
        return results[0];
    }

    /**
     * @description 不動産キャパを取得
     * @param accountIds // 取引先IDリスト
     * @return `List<AgencyCapacity__c>`
     */
    public static List<AgencyCapacity__c> getAgencyCapacityDesc(
        Set<Id> accountIds) {

        List<AgencyCapacity__c> result = new List<AgencyCapacity__c>();
        result = [
            SELECT 
                Id
                , Account__c // 取引先
                , ReserveNum__c
            FROM AgencyCapacity__c 
            WHERE Account__c IN :accountIds
            ORDER BY ReserveNum__c DESC
        ];
        return result;
    }

    /**
     * @description 希望条件を取得
     * @param newMatterId // 新規Id
     * @return DesiredCondition__c
     */
    //TODO自動
    public static DesiredCondition__c getDesiredConditionWhereApplicationId(
        Id applicationId) {

        DesiredCondition__c results = [
            SELECT 
                Id ,
                Application__c
            FROM DesiredCondition__c
            WHERE Application__c = :String.valueOf(applicationId)
            LIMIT 1
        ];

        return results;
    }

    

     /**
     * @description 取引先担当者を取得
     * @param applicantCodes // 申請者社員コード
     * @return `Map<Id, Contact>`
     */
    //TODO自動
    public static Contact getContact(
        Id applicantCode) {

        
        Contact result = ( [            
            SELECT 
                Id
                , CorporateHousingRegulation__c // 社宅規定ID
                , CorporateHousingRegulation__r.SelectionCount__c // 選定数
            FROM Contact
            WHERE Id = :String.valueOf(applicantCode)
        ]);
        return result ;
    }

    public static Set<SpecifyAgency__c> getspecifyAgencys(
        Id corporateHousingRegulationId
    ){

        Set<SpecifyAgency__c> result = new Set<SpecifyAgency__c>(
            [
            SELECT 
                Id
                , RealEstateAgency__c // 不動産仲介会社（参照：取引先）
            FROM SpecifyAgency__c
            WHERE IsMediation__c = false 
                AND CorporateHousingRegulation__c = :corporateHousingRegulationId
            ]
        );
        return result;
    }

    public static Map<Id, MediationPossibleArea__c> getMediationPossibleAreas(
        String state,
        String city
        ) {
        Map<Id, MediationPossibleArea__c> result = new Map<Id, MediationPossibleArea__c>();

        //希望エリアがNullの場合処理を終了
        if(String.isBlank(state) && String.isBlank(city)){
            return result;
        }

        Boolean addWhere = false;
        String query = 'SELECT Id, Account__c , District__c , State__c , City__c , IsAllCity__c FROM MediationPossibleArea__c WHERE';

        //希望エリア_都道府県に値がある場合、条件に追記
        if(!String.isBlank(state)){
            query += ' ';
            query += 'District__r.State__c IN :states';
        }
        //希望エリア_市町村に値がある場合、条件に追記
        if(!String.isBlank(city)){
            if(addWhere == false){
                query += ' ';
            query += '&';
            }
            query += ' ';
            query += 'District__r.State__c IN :states';
        }

        for (MediationPossibleArea__c mediationPossibleArea : Database.query(query)){
            if(String.isNotBlank(mediationPossibleArea.Account__c)){
                result.put(
                    mediationPossibleArea.Account__c,
                    mediationPossibleArea);
            }
        }

        return result;
    }

    /**
     * @description 斡旋依頼を登録
     * @param mediationRequests // 斡旋依頼リスト
     * @return `void`
     */
    //TODO自動
    public static void insertMediationRequest(
        List<MediationRequest__c> mediationRequests) {

        try {

            if (!mediationRequests.isEmpty()) {
                insert mediationRequests;
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
     * @description TODOを登録
     * @param sendTasks // ToDoリスト
     * @return `void`
     */
    //自動
    public static void insertTask(
        List<Task> sendTasks) {

        try {

            if (!sendTasks.isEmpty()) {
                insert sendTasks;
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