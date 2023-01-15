/**
 * @description  帳票を一括送信するためのクラス
 * @author tak-sato
 * @since 
 */
public with sharing class ReportOutputBulk {
    
    /**
     * @description フローからの入力値＆出力値を定義するクラス
     */
    public class InputValue{
        @InvocableVariable(required=true label='帳票送信トークン')
        public List<ReportOutputToken__c> ReportOutputTokens = new List<ReportOutputToken__c>();
    }

    /**
     * 
     * @param inputValues 
     * @return  `List<InputValue>`
     */
    @InvocableMethod(label='ReportOutputBulk' description='帳票を一括で送信する')
    public static List<InputValue> StartUpBulkReportOutput(InputValue[] inputValues){
        //返却値の定義
        List<InputValue> result = new List<InputValue>();
        InputValue resultInputValue = new InputValue();

        //入力値
        InputValue inputValue = inputValues[0];

        //帳票出力トークン(コレクション変数を利用するための型)
        List<ReportOutputToken__c> reportOutputTokens = inputValue.ReportOutputTokens;

        //入力された帳票出力トークンを一つずつ送信し、帳票出力トークンに結果を格納する
        for(ReportOutputToken__c reportOutputToken : reportOutputTokens){
            //帳票を出力
            Map<String,Integer> reportOutputResult = ReportOutput.StartUpReportOutPut(
                Integer.valueOf(reportOutputToken.ReportNo__c),
                reportOutputToken.AccountId__c,
                reportOutputToken.RecordId__c,
                reportOutputToken.OutputType__c
            );
            //結果を格納
            Integer resultCode = reportOutputResult.get(ReportOutput.RESULT_CODE);
            Integer errorCode = reportOutputResult.get(ReportOutput.ERROR_CODE);
            reportOutputToken.ResultCode__c = resultCode;
            if(errorCode!=null) reportOutputToken.ErrorCode__c = errorCode;
            System.debug('reportOutputToken:'+reportOutputToken);
            resultInputValue.ReportOutputTokens.add(reportOutputToken);
            
        }
        
        result.add(resultInputValue);
        return result; 
    }
}