public class CallCreateFbData {
    @InvocableMethod
    public static void CallCreateFbData(List<InputInfo> inputInfo) {
        //送金日取得
        Date remittanceDate = inputInfo[0].inputDate;
        //フロー実行ユーザID取得
        String executionUserId = inputInfo[0].executionUser;
        //FBデータ作成実行
        //CreateFbData.CreateFbData(remittanceDate, executionUserId);
    }
    public class InputInfo {
        @InvocableVariable
        public Date inputDate;
        @InvocableVariable
        public String executionUser;
    }
}