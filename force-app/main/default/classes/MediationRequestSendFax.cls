public with sharing class MediationRequestSendFax {
    public static List<MediationRequest__c> SendFax(
        List<MediationRequest__c> mediationRequests,
        Map<Id, Account> requestTraders
    ){
        System.debug('--SendFax--');
        //カスタム設定
        DefaultReportNum__c tsSetting = DefaultReportNum__c.getOrgDefaults();

        //固定値：出力種別
        String VAR_TYPE = '0'; 

        List<MediationRequest__c> resultList = new List<MediationRequest__c>();
        for(MediationRequest__c mediationRequest:mediationRequests){
            //通知テンプレートの斡旋依頼帳票番号を取得
            Integer mediationRequestReportNum = Integer.valueOf(mediationRequest.RequestTraderId__r.NotificationTemplate__r.MediationRequestReportNum__c);
            //カスタム値なない場合デフォルト値を使用
            if(mediationRequestReportNum == null){
                mediationRequestReportNum = Integer.valueOf(tsSetting.MediationRequest__c);
            }

            //パラメータを設定
            Id mediationRequestId = mediationRequest.Id; //斡旋依頼レコードID
            String destination = String.valueOf(
                requestTraders.get(mediationRequest.RequestTraderId__c)); //本店の取引先を取得

            Map<String,Integer> result = ReportOutput.StartUpReportOutPut(
                mediationRequestReportNum,
                mediationRequestId,
                destination,
                VAR_TYPE
            );
            Integer resultCode = result.get('resultCode');
            Integer resultErrorCode = result.get('resultErrorCode');

            
            if(resultCode == 0){
                //送信成功処理
                System.debug('-SendFaxSucces');
                resultList.add(mediationRequest);
                }
            else if(resultCode == 1){
                //接続失敗処理
                System.debug('AccesError:'+resultErrorCode);
            }else if(resultCode == 9){
                //処理失敗処理
                System.debug('SystemError:'+resultErrorCode);
            }else {
                    
            }
        }
        return resultList;

    }
}