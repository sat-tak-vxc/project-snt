/**
 * @description        : 毎月支払用FBデータ作成呼び出しバッチスケジュール登録用クラス
 * @author             : h-nakata
**/
global class CallCreateMonthlyFbDataSchedulable implements Schedulable {
    /**
    * @description 実行処理
    * @author h-nakata
    * @param SchedulableContext ctx
    * @return void 
    **/
    global void execute(SchedulableContext ctx) {
        //毎月支払用FBデータ作成呼び出しバッチ
        String batchName = 'CallCreateMonthlyFbData';
        CallCreateMonthlyFbData batch =
            (CallCreateMonthlyFbData)Type.forName(batchName).newInstance();
        //バッチサイズを取得
        Integer batchSize = ApexBatchUtils.getBatchSize(batchName);
        //毎月支払用FBデータ作成呼び出しバッチを実行
        ID processId = Database.executeBatch(batch, batchSize);
    }
}