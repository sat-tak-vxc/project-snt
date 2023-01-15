/**
 * @File Name          : ApexBatchUtils.cls
 * @Description        : APEXバッチ処理のユーティリティークラス
**/
public  class ApexBatchUtils {
    /**
     * デフォルトバッチサイズ取得
     */
    public static Integer getDefaultBatchSize() {
        // カスタムメタデータ型「Apexバッチ情報.[パラメータ]Apexバッチクラス名」取得
        SystemControl_ApexBatch__mdt defaultBatchSize = [SELECT BatchSize__c FROM SystemControl_ApexBatch__mdt WHERE DeveloperName='Default' LIMIT 1];
        return defaultBatchSize.BatchSize__c.intValue();
    }

    /**
     * バッチクラス指定バッチサイズ取得
     */
    public static Integer getBatchSize(String apexBatchClassName) {
        // カスタムメタデータ型「Apexバッチ情報.[パラメータ]Apexバッチクラス名」取得
        SystemControl_ApexBatch__mdt[] apexBatchSize = [SELECT BatchSize__c FROM SystemControl_ApexBatch__mdt WHERE DeveloperName=:apexBatchClassName LIMIT 1];
        if (apexBatchSize.isEmpty()) {
            return getDefaultBatchSize();
        }
        return apexBatchSize[0].BatchSize__c.intValue();
    }
}