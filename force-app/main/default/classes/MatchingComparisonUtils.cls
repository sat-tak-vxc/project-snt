/**
 * マッチング共通処理のユーティリティクラス
 */
public class MatchingComparisonUtils {
    /**
     * マッチング比較処理
     * 
     * @param newMatter 
     * @param matchingTargetData 
     * @param matchingComparisonResult 
     * @param fifthSetConfirm 
     * @param matchingTargets 
     * @param isExceptImportantExplanation 
     * @param isExceptContract 
     * @param isExceptBill 
     * @param isExceptDrawing 
     */
    public static MatchingResultData executeMatchingComparison(
        NewMatter__c newMatter,
        MatchingTargetData matchingTargetData,
        MatchingComparisonResult__c matchingComparisonResult,
        FifthSetConfirm__c fifthSetConfirm,
        List<MatchingComparisonTarget__mdt> matchingTargets,
        Boolean isExceptImportantExplanation,
        Boolean isExceptContract,
        Boolean isExceptBill,
        Boolean isExceptDrawing
    ){
        // カスタム設定
        MatchingSetting__c matchingSetting = MatchingSetting__c.getOrgDefaults();

        // 返却用マッチング比較結果
        MatchingComparisonResult__c upsertMatchingComparisonResult;
        if (matchingComparisonResult == null) {
            upsertMatchingComparisonResult = new MatchingComparisonResult__c();
            upsertMatchingComparisonResult.NewMatter__c = newMatter.Id;
        } else {
            upsertMatchingComparisonResult = matchingComparisonResult;
        }
        // 5点確定
        FifthSetConfirm__c upsertFifthSetConfirm;
        if (fifthSetConfirm == null) {
            upsertFifthSetConfirm = new FifthSetConfirm__c();
            upsertFifthSetConfirm.NewMatter__c = newMatter.Id;
        } else {
            upsertFifthSetConfirm = fifthSetConfirm;
        }

        for (MatchingComparisonTarget__mdt matchingTarget : matchingTargets) {

            // 項目API名（マッチング、5点確定）
            String fieldName = concat(matchingTarget.ReferenceName__c, matchingSetting.FieldSuffix__c);

            // 比較対象の書類件数を算出
            Integer matchingTargetCnt = 0;
            if (matchingTarget.IsImportantExplanation__c) {
                matchingTargetCnt++;
            }
            if (matchingTarget.IsContract__c) {
                matchingTargetCnt++;
            }
            if (matchingTarget.IsBill__c) {
                matchingTargetCnt++;
            }
            if (matchingTarget.IsDrawing__c) {
                matchingTargetCnt++;
            }
            upsertFifthSetConfirm.put(fieldName, null);
            if (matchingTargetCnt > 1) {
                upsertMatchingComparisonResult.put(concat(matchingTarget.ReferenceName__c, matchingSetting.TypeFieldSuffix__c), null);
                upsertMatchingComparisonResult.put(concat(matchingTarget.ReferenceName__c, matchingSetting.ResultFieldSuffix__c), false);
            }

            // 比較対象項目値格納用セット
            Set<Object> matchingValues = new Set<Object>();

            // 重説
            if (!isExceptImportantExplanation && matchingTarget.IsImportantExplanation__c && matchingTargetData.importantExplanation != null) {
                Object fieldValue = matchingTargetData.importantExplanation.get(fieldName);
                if (fieldValue != null) {
                    matchingValues.add(fieldValue);
                }
            }

            // 契約書
            if (!isExceptContract && matchingTarget.IsContract__c && matchingTargetData.contract != null) {
                Object fieldValue = matchingTargetData.contract.get(fieldName);
                if (fieldValue != null) {
                    matchingValues.add(fieldValue);
                }
            }

            // 請求書
            if (!isExceptBill && matchingTarget.IsBill__c && matchingTargetData.bill != null) {
                Object fieldValue = matchingTargetData.bill.get(fieldName);
                if (fieldValue != null) {
                    matchingValues.add(fieldValue);
                }
            }

            // 図面
            if (!isExceptDrawing && matchingTarget.IsDrawing__c && matchingTargetData.drawing != null) {
                Object fieldValue = matchingTargetData.drawing.get(fieldName);
                if (fieldValue != null) {
                    matchingValues.add(fieldValue);
                }
            }

            // 比較対象項目値が同一値の場合、5点確定の該当項目に値を設定する
            if (matchingValues.size() == 1) {
                upsertFifthSetConfirm.put(fieldName, new List<Object>(matchingValues).get(0));
                // 比較結果をOK、比較区分を「自動」とする
                if (matchingTargetCnt > 1) {
                    upsertMatchingComparisonResult.put(concat(matchingTarget.ReferenceName__c, matchingSetting.TypeFieldSuffix__c), '自動');
                    upsertMatchingComparisonResult.put(concat(matchingTarget.ReferenceName__c, matchingSetting.ResultFieldSuffix__c), true);
                }
            }
            // 比較対象項目値が複数値の場合、比較結果をNGとする
            else if (matchingValues.size() > 1) {
                if (matchingTargetCnt > 1) {
                    upsertMatchingComparisonResult.put(concat(matchingTarget.ReferenceName__c, matchingSetting.TypeFieldSuffix__c), null);
                    upsertMatchingComparisonResult.put(concat(matchingTarget.ReferenceName__c, matchingSetting.ResultFieldSuffix__c), false);
                }
            }
        }

        MatchingResultData matchingResultData = new MatchingResultData();
        matchingResultData.matchingComparisonResult = upsertMatchingComparisonResult;
        matchingResultData.fifthSetConfirm = upsertFifthSetConfirm;
        return matchingResultData;
    }

    /**
     * 
     * @param str 
     * @param addStr 
     * @return  `String`
     */
    public static String concat(String str, String addStr) {
        List<String> strs = new List<String>{str, addStr};
        return String.join(strs, '');
    }
}