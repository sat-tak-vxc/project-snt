trigger CancelCalculateTrigger on CancelCalculate__c(before insert  , before update) {

    //before insert & before update
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore){
        //二重起動防止
        if(PhaseGateHandler.firstRun==true){
            PhaseGateHandler.triggerHandler(Trigger.new);
            PhaseGateHandler.firstRun = false;
        }
    }

}