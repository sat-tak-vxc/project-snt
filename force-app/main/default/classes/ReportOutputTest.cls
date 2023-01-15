/**
 * @Description: Testing for class ReportOutPut TestClass.
 * 
 * @author tak-sato
 * @date 2022/08/16
 */
@isTest
private class ReportOutputTest{
    @isTest static void testGetCallout(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

        Test.setMock(HttpCalloutMock.class, mock);
        List<Map<String,Integer>> resultList = new List<Map<String,Integer>>{};
        //テストデータ
        //取引先を作成
        Account account = new Account(
            AccountId__c = '111111111',
            Name = '帳票テスト1'
        );

        //テストパラメータ
        //正常値
        mock.setStaticResource('GetReportOutputSucces');
        Integer varNo_1 = 10001;
        String varKey01_1 = account.id;
        String varKey02_1 = account.id;
        String varType_1 = '1';
        Map<String,Integer> result1 = ReportOutput.StartUpReportOutPut(varNo_1 , varKey01_1 , varKey02_1, varType_1);
        resultList.add(result1);

        //異常値
        mock.setStaticResource('GetReportOutputError');
        Integer varNo_2 = 99999;
        String varKey01_2 = account.id;
        String varKey02_2 = account.id;
        String varType_2 = '1';
        Map<String,Integer> result2 = ReportOutput.StartUpReportOutPut(varNo_2 , varKey01_2 , varKey02_2, varType_2);
        resultList.add(result2);
        
        Test.startTest();
        for(Map<String,Integer> result : resultList){
            Integer resultCode = result.get(ReportOutput.RESULT_CODE);
            switch on resultCode {
                when 0 {
                    System.debug('Succes');
                }
                when 1{
                    System.debug('Request Error');
                }
                when else {
                    System.debug('Error Code:' + result);
                }
            }
        }
        Test.stopTest();

    }
}