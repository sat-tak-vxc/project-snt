public class TraderSelectionSendNoticesFlow {
    public class MediationRequestInfo {
        @InvocableVariable(required=true)
        public Id mediationRequestId;
    }
    
    @InvocableMethod(label='Send mediationRequest')
    public static void frowAccountSendNotificationFuture(MediationRequestInfo[] infos){
        Id recordId = infos[0].mediationRequestId;
        Set<Id> Ids= new Set<Id>();
        Ids.add(recordId );
        //TraderSelectionSendNotices.accountSendNotificationFuture(Ids);
    
    }
        


}