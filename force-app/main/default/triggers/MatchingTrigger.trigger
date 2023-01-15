trigger MatchingTrigger on Matching__c (after insert) {
    MatchingTriggerHandler handler = new MatchingTriggerHandler();
    handler.matchingComparison(Trigger.new);
}