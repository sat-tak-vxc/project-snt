public class PhaseGate{
    List<String> dhisplayPhaseGateErrorMassage = new List<String>();//表示エラーメッセージ
    List<String> dhisplayAftterPhaseGateErrorMassage = new List<String>();//表示エラーメッセージ
    SObject record = null;

    /**
     * @description 必須項目が入力されているかをチェックする。
     * @param List<PhaseGate__c> 必須項目のリスト
     * @return `void`
     */
    public void checkRequiredFields(SObject record , List<PhaseGate__c> phaseGateList){
        
        for(PhaseGate__c phaseGate :phaseGateList){
            String requiredFieldName = phaseGate.Field__c;
            String fieldValue = getFieldValue(requiredFieldName);
            //System.debug(requiredFieldName+':' + fieldValue);
            if(String.isBlank(fieldValue)){
                //必須項目が入力されていないときの処理
                System.debug('必須項目が入力されていない:' + phaseGate.Field__c);
                //dhisplayErrorMassage(phaseGate.Field__c, phaseGate.MandatoryFieldsErrorMessage__c);
                record.addError(phaseGate.Field__c,phaseGate.MandatoryFieldsErrorMessage__c);
            }
        }
    }

    /**
     * @description 後フェーズでの必須項目が入力されているかをチェックする。
     * @param SObject 業務レコード
     * @param List<PhaseGate__c> 後フェーズでの必須項目のリスト
     * @return `void`
     */
    public void checkAftterPhaseRequiredFields(SObject record , List<PhaseGate__c> phaseGateList){
        
        for(PhaseGate__c phaseGate : phaseGateList){
            String requiredFieldName = phaseGate.Field__c;
            String fieldValue = getFieldValue(requiredFieldName);
            //System.debug(requiredFieldName + ':' + fieldValue);
            if(fieldValue != null){
                //後フェーズでの必須項目が入力されている
                System.debug('後フェーズでの必須項目が入力されている:' + phaseGate.Field__c);
                //dhisplayErrorMassage(phaseGate.Field__c, phaseGate.AfterStageMandatoryFieldsErrorMessage__c);
                record.addError(phaseGate.Field__c,phaseGate.AfterStageMandatoryFieldsErrorMessage__c);
            }

        }
    }

    /**
     * @description 項目名から項目の値を取得する。
     * @param String 項目名
     * @return String　取得した項目
     */
    public String getFieldValue(String fieldName){
        String result = '';
        System.debug('fieldName:'+fieldName);
        try{
            result = String.valueOf(this.record.get(fieldName));
        }catch(SObjectException e){
            System.debug(e.getMessage());
            System.debug('フェーズゲートレコードに格納されている項目名が誤っています。');
        }
        return result;
    }
    /**
     * @description エラーを表示する。
     * @param String 項目名
     * @return 'void'
     
    public void dhisplayErrorMassage(String fieldName, String massageText){
        //this.record.addError(fieldName, massageText);

        this.record.addError('ApplicationFormReceiptDate__c',massageText);
        
    }
    */

    /**
     * @description 斡旋不要かをチェックする。
     * @param SObject 
     * @return 'void'
     */
    public boolean isNewMatter(String objectName){
        boolean result = false;
        System.debug('objectName:'+objectName);
        
        if(objectName == 'NewMatter__c'){
            System.debug('MediationRequest__c:'+getFieldValue('Application__r.MediationRequest__c'));
            Id applicationId = getFieldValue('Application__c');
            Application__c application = [SELECT MediationRequest__c FROM Application__c WHERE Id = :applicationId];
            if(application.MediationRequest__c == false){
                result = true;
            }
        }
        return result;
    }


     /**
     * @description SObjectを設定する。
     * @param SObject 
     * @return 'void'
     */
    public void setRecord(SObject objectRecod){
        this.record = objectRecod;
    }

}