/**
 * @description        : 個人情報削除フローアクション
 * @author             : h-nakata
**/
public class DeletePersonalInfoFlowAction {
    /**
    * @description 個人情報削除バッチ実行
    * @author h-nakata
    * @param List<InputInfo> inputInfo
    * @return void
    **/
    @InvocableMethod
    public static void DeletePersonalInfoFlowAction(List<InputInfo> inputInfo) {
        //取引先ID取得
        String accountId = inputInfo[0].accountId;
        //ユーザマスキング
        String batchName = 'DeletePersonalInfoUserMasking';
        DeletePersonalInfoUserMasking batch = new DeletePersonalInfoUserMasking();
        batch.accountId = accountId;
        //バッチサイズを取得
        Integer batchSize = ApexBatchUtils.getBatchSize(batchName);
        Database.executeBatch(batch, batchSize);
    }
    public class InputInfo {
        //取引先ID
        @InvocableVariable
        public String accountId;
    }
}