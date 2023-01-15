/**
 * マッチング情報
 * @author t-oshiro-bp
 * @since 2022/02/17
 */
public class MatchingTargetData {
    /* 重説マッチングレコード */
    public Matching__c importantExplanation {get;set;}
    /* 契約書マッチングレコード */
    public Matching__c contract {get;set;}
    /* 請求書マッチングレコード */
    public Matching__c bill {get;set;}
    /* 図面マッチングレコード */
    public Matching__c drawing {get;set;}
}