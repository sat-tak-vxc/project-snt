/**
 * @description トリガ：マッチング
 * 
 * @author t-ooshiro-bp
 * @date 2022/02/15
 */
public with sharing class MatchingTriggerHandler {
    /**
     * 
     * @param news 
     */
    public void matchingComparison(List<Matching__c> news) {

        // カスタム設定
        MatchingSetting__c matchingSetting = MatchingSetting__c.getOrgDefaults();

        // 処理対象の新規IDを抽出
        Set<Id> newMatterIds = new Set<Id>();
        for (Matching__c matching : news) {
            newMatterIds.add(matching.NewMatter__c);
        }

        // カスタムメタデータ：マッチング比較対象 取得
        List<MatchingComparisonTarget__mdt> matchingTargets =
            MatchingComparisonModel.getMatchingComparisonTargetMdt();

        // マッチング、5点確定、マッチング比較結果の取得項目リストを生成
        List<String> matchingFieldNames = new List<String>();
        List<String> matchingResultFieldNames = new List<String>();
        for (MatchingComparisonTarget__mdt matchingTarget : matchingTargets) {
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

            if (matchingTargetCnt > 0) {
                matchingFieldNames.add(MatchingComparisonUtils.concat(matchingTarget.ReferenceName__c, matchingSetting.FieldSuffix__c));
                // 比較対象書類が2種類以上の場合、マッチング比較結果の取得フィールドに追加
                if (matchingTargetCnt > 1) {
                    matchingResultFieldNames.add(MatchingComparisonUtils.concat(matchingTarget.ReferenceName__c, matchingSetting.TypeFieldSuffix__c));
                    matchingResultFieldNames.add(MatchingComparisonUtils.concat(matchingTarget.ReferenceName__c, matchingSetting.ResultFieldSuffix__c));
                }
            }
        }

        // 新規 取得
        List<NewMatter__c> newMatters =
            MatchingComparisonModel.getNewMatters(newMatterIds);

        // マッチング 取得
        List<Matching__c> matchings =
            MatchingComparisonModel.getMatchingsByNewMatterIds(newMatterIds, matchingFieldNames);

        // 取得したマッチングを新規ID毎にMap化
        Map<Id, MatchingTargetData> matchingMap = new Map<Id, MatchingTargetData>();
        for (Matching__c matching : matchings) {
            MatchingTargetData targetData;
            if (matchingMap.containsKey(matching.NewMatter__c)) {
                targetData = (MatchingTargetData)matchingMap.get(matching.NewMatter__c);
            } else {
                targetData = new MatchingTargetData();
            }

            if (matchingSetting.PaperTypeImportantExplanation__c.equals(matching.PaperType__c)) {
                targetData.importantExplanation = matching;
            } else if (matchingSetting.PaperTypeContract__c.equals(matching.PaperType__c)) {
                targetData.contract = matching;
            } else if (matchingSetting.PaperTypeBill__c.equals(matching.PaperType__c)) {
                targetData.bill = matching;
            } else if (matchingSetting.PaperTypeDrawing__c.equals(matching.PaperType__c)) {
                targetData.drawing = matching;
            }
            matchingMap.put(matching.NewMatter__c, targetData);
        }

        // マッチング比較結果 取得
        List<MatchingComparisonResult__c> matchingComparisonResults =
            MatchingComparisonModel.getMatchingComparisonResultsByNewMatterIds(newMatterIds, matchingResultFieldNames);

        // 取得したマッチング比較結果を新規ID毎にMap化
        Map<Id, MatchingComparisonResult__c> matchingResultMap = new Map<Id, MatchingComparisonResult__c>();
        for (MatchingComparisonResult__c matchingComparisonResult : matchingComparisonResults) {
            matchingResultMap.put(matchingComparisonResult.NewMatter__c, matchingComparisonResult);
        }

        // 5点確定 取得
        List<FifthSetConfirm__c> fifthSetConfirms =
            MatchingComparisonModel.getFifthSetConfirmsByNewMatterIds(newMatterIds, matchingFieldNames);

        // 取得した5点確定を新規ID毎にMap化
        Map<Id, FifthSetConfirm__c> fifthSetMap = new Map<Id, FifthSetConfirm__c>();
        for (FifthSetConfirm__c fifthSetConfirm : fifthSetConfirms) {
            fifthSetMap.put(fifthSetConfirm.NewMatter__c, fifthSetConfirm);
        }

        // 登録／更新用マッチング比較結果リスト
        List<MatchingComparisonResult__c> upsertMatchingComparisonResults = new List<MatchingComparisonResult__c>();
        // 登録／更新用5点確定リスト
        List<FifthSetConfirm__c> upsertFifthSetConfirms = new List<FifthSetConfirm__c>();
        // 通知用Taskリスト
        List<Task> insertTasks = new List<Task>();

        for (NewMatter__c newMatter : newMatters) {
            // 自動マッチング実施可否判定
            if (this.isContinueMatchingComparison(matchingResultMap.get(newMatter.Id), (MatchingTargetData)matchingMap.get(newMatter.Id))) continue;

            MatchingResultData matchingResultData =
                this.executeAutoMatchingComparison(
                    newMatter,
                    matchingMap.get(newMatter.Id),
                    matchingResultMap.get(newMatter.Id),
                    fifthSetMap.get(newMatter.Id),
                    matchingTargets,
                    matchingSetting
                );

            // 登録／更新用マッチング比較結果リストに追加
            upsertMatchingComparisonResults.add(matchingResultData.matchingComparisonResult);
            // 登録／更新用5点確定リストに追加
            upsertFifthSetConfirms.add(matchingResultData.fifthSetConfirm);
            // 通知用Taskリストに追加
            insertTasks.add(
                new Task(
                    WhatId = newMatter.Id, // 関連先
                    TaskSubtype = matchingSetting.TaskSubtype__c , // ToDoのサブ種別
                    Status = matchingSetting.TaskStatus__c, // 状況
                    Priority = matchingSetting.TaskPriority__c, // 優先度
                    Subject = matchingSetting.SendTaskAutoProcessCompleteSubject__c, // 件名
                    Description = matchingSetting.SendTaskAutoProcessCompleteMessage__c // コメント
                )
            );
        }

        try {
            // マッチング比較結果 登録／更新
            MatchingComparisonModel.upsertMatchingComparisonResult(upsertMatchingComparisonResults);
            // 5点確定 登録／更新
            MatchingComparisonModel.upsertFifthSetConfirm(upsertFifthSetConfirms);
            // ToDo 登録
            MatchingComparisonModel.insertTask(insertTasks);
        } catch (Exception e) {
            // 例外が発生した場合、新規ユーザへTODOを通知

            // エラー通知用Taskリスト
            List<Task> insertErrorTasks = new List<Task>();
            for (Id newMatterId : newMatterIds) {
                insertErrorTasks.add(
                    new Task(
                        WhatId = newMatterId, // 関連先
                        TaskSubtype = matchingSetting.TaskErrorSubtype__c, // ToDoのサブ種別
                        Status = matchingSetting.TaskErrorStatus__c, // 状況
                        Priority = matchingSetting.TaskErrorPriority__c, // 優先度
                        Subject = matchingSetting.SendTaskAutoProcessErrorSubject__c, // 件名
                        Description = matchingSetting.SendTaskAutoProcessErrorMessage__c // コメント
                    )
                );
            }
            // ToDo 登録
            MatchingComparisonModel.insertTask(insertErrorTasks);
        }
    }

    /**
     * 
     * @param newMatter 
     * @param matchingTargetData 
     * @param matchingComparisonResult 
     * @param fifthSetConfirm 
     * @param matchingTargets 
     * @param matchingSetting 
     * @return  `MatchingResultData`
     */
    private MatchingResultData executeAutoMatchingComparison(
        NewMatter__c newMatter,
        MatchingTargetData matchingTargetData,
        MatchingComparisonResult__c matchingComparisonResult,
        FifthSetConfirm__c fifthSetConfirm,
        List<MatchingComparisonTarget__mdt> matchingTargets,
        MatchingSetting__c matchingSetting
    ){
        // 重説不要フラグ
        Boolean isExceptImportantExplanation = matchingComparisonResult == null ? false : matchingComparisonResult.IsExceptImportantExplanation__c;
        // 契約書不要フラグ
        Boolean isExceptContract = matchingComparisonResult == null ? false : matchingComparisonResult.IsExceptContract__c;
        // 請求書不要フラグ
        Boolean isExceptBill = matchingComparisonResult == null ? false : matchingComparisonResult.IsExceptBill__c;
        // 図面不要フラグ
        Boolean isExceptDrawing = matchingComparisonResult == null ? false : matchingComparisonResult.IsExceptDrawing__c;

        // マッチング比較処理呼び出し
        return MatchingComparisonUtils.executeMatchingComparison(
            newMatter, // 新規
            matchingTargetData, // マッチング
            matchingComparisonResult, // マッチング比較結果
            fifthSetConfirm, // 5点確定
            matchingTargets, // カスタムメタデータ
            isExceptImportantExplanation, // 重説不要フラグ
            isExceptContract, // 契約書不要フラグ
            isExceptBill, // 請求書不要フラグ
            isExceptDrawing // 図面不要フラグ
        );
    }

    /**
     * 
     * @param newMatter 
     * @param matchingTargetData 
     * @param matchingSetting 
     * @return  `Boolean`
     */
    private Boolean isContinueMatchingComparison(MatchingComparisonResult__c matchingComparisonResult, MatchingTargetData matchingTargetData) {
        // 重説不要フラグ
        Boolean isExceptImportantExplanation = matchingComparisonResult == null ? false : matchingComparisonResult.IsExceptImportantExplanation__c;
        if (!isExceptImportantExplanation && matchingTargetData.importantExplanation == null) {
            return true;
        }

        // 契約書不要フラグ
        Boolean isExceptContract = matchingComparisonResult == null ? false : matchingComparisonResult.IsExceptContract__c;
        if (!isExceptContract && matchingTargetData.contract == null) {
            return true;
        }

        // 請求書不要フラグ
        Boolean isExceptBill = matchingComparisonResult == null ? false : matchingComparisonResult.IsExceptBill__c;
        if (!isExceptBill && matchingTargetData.bill == null) {
            return true;
        }

        // 図面不要フラグ
        Boolean isExceptDrawing = matchingComparisonResult == null ? false : matchingComparisonResult.IsExceptDrawing__c;
        if (!isExceptDrawing && matchingTargetData.drawing == null) {
            return true;
        }
        return false;
    }
}