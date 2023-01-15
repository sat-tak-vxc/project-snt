/**
 * @description        : スポットFBデータ作成バッチ呼び出し
 * @author             : h-nakata
**/
public class CallCreateSpotFbData {
    /**
    * @description スポットFBデータ作成バッチ実行
    * @author h-nakata
    * @param List<InputInfo> inputInfo
    * @return void
    **/
    @InvocableMethod
    public static void CallCreateSpotFbData(List<InputInfo> inputInfo) {
        //送金日取得
        Date remittanceDate = inputInfo[0].inputDate;
        //フロー実行ユーザID取得
        String executionUserId = inputInfo[0].executionUser;
        //スポットFBデータ作成バッチ
        String batchName = 'CreateSpotFbData';
        CreateSpotFbData batch = new CreateSpotFbData();
        batch.remittanceDate = remittanceDate;
        batch.executionUser = executionUserId;
        //バッチサイズを取得
        Integer batchSize = ApexBatchUtils.getBatchSize(batchName);
        Database.executeBatch(batch, batchSize);
    }
    public class InputInfo {
        //送金日
        @InvocableVariable
        public Date inputDate;
        //フロー実行ユーザ
        @InvocableVariable
        public String executionUser;
    }
}