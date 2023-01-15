/**
 * 
 * @author t-ooshiro-bp
 * @since 2022/03/01
 */
public class OldDeletePersonalInfoFlowAction {
    /**
     * 
     * @param requests 
     */
    @InvocableMethod
    public static void deletePersonalInfo(List<Request> requests) {
        // カスタムメタデータ型：マスキング対象取得
        List<MaskedTarget__mdt> maskedTargets = [
            SELECT AccountRecordType__c, SObjectApiName__c, KeyItemApiName__c
            FROM MaskedTarget__mdt
            WHERE IsActive__c = TRUE
        ];

        // 有効なマスキング対象がない場合は終了
        if (maskedTargets.isEmpty()) {
            return;
        }

        // カスタムメタデータ型：マスキング項目取得
        List<MaskedItem__mdt> maskedItems = [
            SELECT AccountRecordType__c, SObjectApiName__c, ItemApiName__c, MaskedValue__c
            FROM MaskedItem__mdt
            WHERE IsActive__c = TRUE
        ];

        // 取引先レコードタイプ取得
        Map<Id, String> recordTypeMap = new Map<Id, String>();
        for (RecordType rType : [SELECT Id, Name FROM RecordType WHERE IsActive = TRUE AND SobjectType = 'Account']) {
            recordTypeMap.put(rType.Id, rType.Name);
        }

        // 個人情報削除バッチ起動
        for (Request req : requests) {
            executeBatch(req, maskedTargets, maskedItems, recordTypeMap);
        }
    }

    /**
     * 
     * @param req 
     * @param maskedTargets 
     * @param maskedItemMap 
     */
    private static void executeBatch(Request req, List<MaskedTarget__mdt> maskedTargets, List<MaskedItem__mdt> maskedItems, Map<Id, String> recordTypeMap) {
        List<MaskedTarget__mdt> tmpMaskedTargets = new List<MaskedTarget__mdt>();
        for (MaskedTarget__mdt target : maskedTargets) {
            if (target.AccountRecordType__c == null
                    || target.AccountRecordType__c.equals(recordTypeMap.get(req.recordTypeId))) {
                tmpMaskedTargets.add(target);
            }
        }
        List<MaskedItem__mdt> tmpMaskedItems = new List<MaskedItem__mdt>();
        for (MaskedItem__mdt item : maskedItems) {
            if (item.AccountRecordType__c == null
                    || item.AccountRecordType__c.equals(recordTypeMap.get(req.recordTypeId))) {
                tmpMaskedItems.add(item);
            }
        }
        Map<String, Map<String, String>> maskedItemMap = new Map<String, Map<String, String>>();
        for (MaskedItem__mdt maskedItem : tmpMaskedItems) {
            if (!maskedItemMap.containsKey(maskedItem.SObjectApiName__c)) {
                maskedItemMap.put(maskedItem.SObjectApiName__c, new Map<String, String>());
            }
            maskedItemMap.get(maskedItem.SObjectApiName__c).put(maskedItem.ItemApiName__c, maskedItem.MaskedValue__c);
        }

        List<OldDeletePersonalInfoBatch> batchs = new List<OldDeletePersonalInfoBatch>();
        for (MaskedTarget__mdt target : tmpMaskedTargets) {
            // マスキング項目が定義されていないオブジェクトは除外
            if (!maskedItemMap.containsKey(target.SObjectApiName__c)) {
                continue;
            }
            // 起動対象バッチに追加
            batchs.add(
                new OldDeletePersonalInfoBatch(
                    target.SObjectApiName__c,
                    target.KeyItemApiName__c,
                    req.accountId,
                    maskedItemMap.get(target.SObjectApiName__c)
                )
            );
        }
        // 起動対象バッチがない場合は終了
        if (batchs.isEmpty()) {
            return;
        }

        // 個人情報削除バッチのチェーンを生成
        for (Integer i = batchs.size() - 1; i > 0; i--) {
            batchs.get(i - 1).nextBatch = batchs.get(i);
        }

        // 個人情報削除バッチ起動
        Database.executeBatch(batchs.get(0));
    }

    /**
     * 入力値定義
     */
    public class Request {
        /* 取引先.ID */
        @InvocableVariable(required=true label='取引先.ID')
        public Id accountId;
        /* 取引先.レコードタイプID */
        @InvocableVariable(required=true label='取引先.レコードタイプID')
        public Id recordTypeId;
    }
}