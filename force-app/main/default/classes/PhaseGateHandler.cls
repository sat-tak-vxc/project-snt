/**
 * @description 
 * @param accountId 取引先ID
 * @return `List<SObject>`
 */
public class PhaseGateHandler{
    
    public static boolean firstRun = true;//二重起動防止フラグ

    public static void triggerHandler(List<SObject> triggerRecord){
        PhaseGate phaseGate = new PhaseGate();
        PhaseGateModel model = new PhaseGateModel();

        phaseGate.setRecord(triggerRecord[0]);
        //オブジェクト名の取得
        String objectName = triggerRecord.getSObjectType().getDescribe().getName();
        model.setObjectName(objectName);

        //フェーズ項目名の設定
        String stageFieldName = '';
        switch on objectName {
            when  
            'NewMatter__c',
            'Cancel__c',
            'CancelCalculate__c',
            'Change__c',
            'Renewal__c',
            'ConditionChange__c'{
                stageFieldName = 'Stage__c';
            }
            when 'Case'{
                stageFieldName = 'Status';
            }
            when else {
                
            }
        }

        //レコード情報の取得
        String accountId = PhaseGate.getFieldValue('Account__c');//取引先ID
        String stage =  PhaseGate.getFieldValue(stageFieldName);//フェーズ
        model.setAccountId(accountId);

        //レコードのステップ数の取得
        integer stepNum = model.getStepNum(stage);
        System.debug(stepNum);
        if(stepNum != null){
            model.setStepNum(stepNum);

            //必須項目の取得
            boolean isNoneMediationRequest = false;
            if(phaseGate.isNewMatter(objectName))isNoneMediationRequest = true;

            Map<String,List<PhaseGate__c>> phaseGateMap = model.getPhaseGate(isNoneMediationRequest , stepNum);
            
            List<PhaseGate__c> phaseGateList = phaseGateMap.get('phaseGate');
            List<PhaseGate__c> aftterPhaseGateList = phaseGateMap.get('aftterPhaseGate');
            System.debug('phaseGateList:' + phaseGateList);
            System.debug('aftterPhaseGateList:' + aftterPhaseGateList);

            //レコードの必須項目が変更されていないか確認(変更されていたらエラーメッセージリストに追加)
            phaseGate.checkRequiredFields(triggerRecord[0] , phaseGateList);

            //後フェーズでの必須項目が入力されていないか確認
            phaseGate.checkAftterPhaseRequiredFields(triggerRecord[0] , aftterPhaseGateList);
        }

    }

}