/**
 * フェーズゲートのモデルクラス
 */

public class PhaseGateModel{
     
     public String objectName = null;//オブジェクト名
     public Id accountId = null;//取引先ID
     public integer stepNum = null;//ステップ数

     /**
      * @description 必須項目レコードを取得
      * @param null
      * @return 'List<PhaseGate__c>'
      */
     public Map<String,List<PhaseGate__c>> getPhaseGate(boolean isNoneMediationRequest , integer stepNum){
          Map<String,List<PhaseGate__c>> result = new Map<String,List<PhaseGate__c>>();
          List<PhaseGate__c> phaseGateList = new List<PhaseGate__c>();
          List<PhaseGate__c> aftterPhaseGateList = new List<PhaseGate__c>();
          stepNum += 1;
          String addText = '';
          if(isNoneMediationRequest)addText = ' AND Stage__c != \'斡旋中\'';
           
          String soqlTextSelect = 'SELECT Field__c,Step__c,MandatoryFieldsErrorMessage__c,AfterStageMandatoryFieldsErrorMessage__c';
          String soqlTextFrom = 'FROM PhaseGate__c';
          String soqlTextWhere = 'WHERE (Account__c=\''+ this.accountId +'\'OR Account__c=\'\') AND Operation__c =\''+this.objectName+'\' AND Type__c = \'必須項目\' AND Step__c != '+stepNum+addText;

          String soqlText = createSoqlText(soqlTextSelect, soqlTextFrom, soqlTextWhere);
          System.debug('SOQLテキスト：'+soqlText);

          for(PhaseGate__c phaseGate : Database.query(soqlText)){
               if(phaseGate.Step__c <= this.stepNum){
                    //必須項目の追加
                    phaseGateList.add(phaseGate);
               }else{
                    //後フェーズ必須項目の追加
                    aftterPhaseGateList.add(phaseGate);
               }
          }
          //返却値の格納
          result.put('phaseGate', phaseGateList);
          result.put('aftterPhaseGate', aftterPhaseGateList);

          return result;
     }

     /**
      * @description ステップ数を取得
      * @param str オブジェクト名
      * @return 'void'
      */
     public integer getStepNum(String stage){
          integer result = null;
          String soqlTextSelect = 'SELECT Step__c';
          String soqlTextFrom = 'FROM PhaseGate__c';
          String soqlTextWhere = 'WHERE Operation__c =\'' + this.objectName + '\' AND Stage__c = \'' + stage + '\' AND Type__c = \'必須項目\' LIMIT 1';
          System.debug('objectName:'+this.objectName);
          System.debug('stage:'+stage);
          String soqlText = createSoqlText(soqlTextSelect, soqlTextFrom, soqlTextWhere);
          System.debug('SOQL_TEXT:'+soqlText);
          try{
               PhaseGate__c phaseGateSubSObject =  Database.query(soqlText);
               result = integer.valueOf(phaseGateSubSObject.Step__c);
          }catch(QueryException e){
               System.debug('取得できるフェーズゲートレコードはありませんでした。');
          }
         
          return result;
     }

     public String createSoqlText(String soqlTextSelect, String soqlTextFrom, String soqlTextWhere){
          String result = soqlTextSelect + ' ' + soqlTextFrom + ' ' + soqlTextWhere;
          return result;
     }
     
     /**
      * @description objectNameのsetter
      * @param str オブジェクト名
      * @return 'void'
      */
     public void setObjectName(String str){
          this.objectName = str;
     }

     /**
      * @description accountIdのsetter
      * @param id 取引先ID
      * @return 'void'
      */
     public void setAccountId(Id id){
          this.accountId = id;
     }

     /**
      * @description stepNumのsetter
      * @param num ステップ数
      * @return 'void'
      */
     public void setStepNum(integer num){
          this.stepNum = num;
     }


}