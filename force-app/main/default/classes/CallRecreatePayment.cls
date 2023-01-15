/**
 * @description        : 支払再作成呼び出し
 * @author             : h-nakata
**/
public class CallRecreatePayment {
    /**
    * @description 支払再作成実行
    * @author h-nakata
    * @param List<InputInfo> inputInfo
    * @return void
    **/
    @InvocableMethod
    public static void CallRecreatePayment(List<InputInfo> inputInfo) {
        //物件ID取得
        String realEstateId = inputInfo[0].realEstateId;
        //フロー実行ユーザID取得
        String executionUserId = inputInfo[0].executionUser;
        //支払再作成実行
        RecreatePayment.RecreatePayment(realEstateId, executionUserId);
    }
    public class InputInfo {
        //物件ID
        @InvocableVariable
        public String realEstateId;
        //フロー実行ユーザ
        @InvocableVariable
        public String executionUser;
    }
}