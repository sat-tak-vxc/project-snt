public class MediationRequestModel {
    /**
     * @description 斡旋依頼取得（'依頼中'の不動産会社数）
     * @param accountIds // 取引先IDリスト
     * @return `List<AggregateResult>`
     */
    //斡旋
    public static Map<Id, AggregateResult> getMediationRequestAccountCount(
        Set<Id> accountIds, TraderSelectionSetting__c tsSetting) {

        // 斡旋依頼を検索
        // 条件：取引先（不動産会社）
        // 条件：成約区分 = '依頼中'  
        Map<Id, AggregateResult> aggregateResults = 
            new Map<Id, AggregateResult>();

        // 引数が空の場合は処理終了
        if(accountIds.isEmpty()){
            return aggregateResults;
        }

        for (AggregateResult aggregateResult : [
            SELECT 
                COUNT(Id) cnt
                , RequestTraderId__c
            FROM MediationRequest__c
                WHERE RequestTraderId__c IN :accountIds
                AND ContractCategory__c = :tsSetting.SelectionResultRequesting__c
            GROUP BY RequestTraderId__c
        ]) {

            if(String.isNotBlank(String.valueOf(aggregateResult.get('RequestTraderId__c')))){
                aggregateResults.put(
                    (Id)aggregateResult.get('RequestTraderId__c') , aggregateResult);
            }
        }
        return aggregateResults;
    }

    /**
     * @description 不動産キャパを更新
     * @param mediationRequests // 斡旋依頼リスト
     * @return `void`
     */
    //斡旋
    public static void updateAgencyCapacitys(
        List<AgencyCapacity__c> agencyCapacitys) {

        try {

            if (!agencyCapacitys.isEmpty()) {
                update agencyCapacitys;
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