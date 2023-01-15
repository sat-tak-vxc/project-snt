/**
 * @description 新規トリガ
 * 
 * @author hi-takada
 * @date 2022/01/27
 */
trigger NewMatterTrigger on NewMatter__c (before insert , after insert , before update) {

    
   AutoTraderSelectionHandler autoTraderSelectionHandler = new AutoTraderSelectionHandler();

    //before insert & before update
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore){
        //二重起動防止
        if(PhaseGateHandler.firstRun==true){
            PhaseGateHandler.triggerHandler(Trigger.new);
            PhaseGateHandler.firstRun = false;
        }
    }
    


    /**
     * 登録後トリガ
     */
    if(Trigger.isInsert && Trigger.isAfter){
        System.debug('test');
       autoTraderSelectionHandler.autoTraderSelection(Trigger.new);   
     }

   
}