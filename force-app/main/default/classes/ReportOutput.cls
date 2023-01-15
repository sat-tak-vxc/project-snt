/**
 * @Description: 帳票出力トリガーへのアクセス
 * @author tak-sato
 * @date 2022/08/17
 */

public class ReportOutput{
    public  static String RESULT_CODE = 'resultCode';
    public static String ERROR_CODE = 'errorCode';

    //フローからの引数クラス
    public class Info{
        @InvocableVariable(required=true label='帳票No')
        public Integer inputVarNo;
        @InvocableVariable(required=true label='取引先')
        public String inputVarKey1;
        @InvocableVariable(required=true label='レコードID')
        public String inputVarKey2;
        @InvocableVariable(required=true label='自動：0 手動：1')
        public String inputVarType;
    }
    public class Result {
        @InvocableVariable
        public Integer resultCode;
        @InvocableVariable
        public Integer errorCode;

    }

    
    
    
    //帳票単一送信(フロー)
    @InvocableMethod(label='ReportOutput' description='帳票トリガーを起動する')
    public static List<Result> StartUpReportOutPutFlow(List<Info> infos){
         Result result = new Result();
         List<Result> resultList = new List<Result>();
         for(Info info : infos){
             Map<String,Integer> resultMap = StartUpReportOutPut(
                info.inputVarNo,
                info.inputVarKey1,
                info.inputVarKey2,
                info.inputVarType
            );
            result.resultCode = resultMap.get(RESULT_CODE);
            result.errorCode = resultMap.get(ERROR_CODE);
            resultList.add(result);
           }
        
        return resultList;
    }

    

    /**
    * @Description:帳票出力トリガーへのアクセス
    * @author tak-sato
    * @date 2022/08/17
    * @param varNo 帳票の種類を識別する整数
    * @param varKey01 取引先ID
    * @param varKey02 各レコードID
    * @param varType 帳票をFaxで自動送信する:0 送信しない:1
    */
    public static Map<String,Integer> StartUpReportOutPut(
        Integer varNo,//var_no 整数型　帳票の種類
        String varKey01 , //文字列型　取引先ID
        String varKey02, //文字列型　帳票データを特定するためのキー
        String varType //帳票データを印刷するかどうか 0:自動 1:手動
    ){
        //カスタム設定の取得
        ReportOutput__c reportOutput = ReportOutput__c.getOrgDefaults();

        //返り値の設定
        Integer resultCode = 0;
        Integer errorCode = null;
        Map<String,Integer> result = new Map<String,Integer>();

        //エンドポイントの設定
        String cid = reportOutput.cid__c;
        String sid = reportOutput.sid__c;

        String endPoint = 'https://ss.dataspidercloud.com/ws/trigger/'+reportOutput.ExecutionPath__c;

        endPoint += '';
        endPoint += '?cid=' + cid;
        endPoint += '&sid=' + sid;

        //パラメータの設定
        endPoint += '&var_no=' + varNo; //var_noの追加
        endPoint += '&var_type=' + varType; //var_typeの追加
        if(varKey01 != '')endPoint += '&var_key1=' + varKey01;
        if(varKey02 != '')endPoint += '&var_key2=' + varKey02; 
        
        System.debug('endPoint:' + endPoint);

        //認証情報
        String username = reportOutput.certificationId__c;
        String password = reportOutput.certificationPass__c;
        System.debug('certificationId__c:' + username);
        System.debug('certificationPass__c:' + password);
        

        //Responseの取得
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);

        HttpResponse response = http.send(request);

        Integer statusCode = response.getStatusCode();
        System.debug('Response:' +response);
        System.debug('ResponseStatuCode:' + response.getStatusCode());

       

        if(statusCode != 200){
            //接続失敗処理
            System.debug('Error : ' + statusCode + ' => ' + response.getBody());
            resultCode = 1;
            errorCode = statusCode;
            
        }else{
            Integer requestCode = Integer.valueOf(response.getBody());
            System.debug('requestBody:' + requestCode);
            //接続成功処理
            if(requestCode == 0){
                //処理成功処理
                resultCode = 0;
                errorCode = null;
            }else{
                //処理失敗
                resultCode = 9;
                errorCode = requestCode;
            }
        }
        result.put(RESULT_CODE,resultCode);
        result.put(ERROR_CODE,errorCode);

        return result;
        

    }
}