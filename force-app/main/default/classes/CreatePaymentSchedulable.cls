/**
 * @description        : 支払作成バッチスケジュール登録用クラス
 * @author             : h-nakata
**/
global class CreatePaymentSchedulable implements Schedulable {
    /**
    * @description 実行処理
    * @author h-nakata
    * @param SchedulableContext ctx
    * @return void 
    **/
    global void execute(SchedulableContext ctx) {
        //支払作成バッチ
        String batchName = 'CreatePayment';
        CreatePayment batch =
            (CreatePayment)Type.forName(batchName).newInstance();
        //バッチサイズを取得
        Integer batchSize = ApexBatchUtils.getBatchSize(batchName);
        //支払作成バッチを実行
        ID processId = Database.executeBatch(batch, batchSize);
    }
}