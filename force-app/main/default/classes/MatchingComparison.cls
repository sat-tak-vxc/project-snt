/**
 * マッチング画面APEX処理
 * 
 * @author hi-takada
 * @since 2022/02/15
 */
public with sharing class MatchingComparison {

    /**
     * @description 画面表示情報を取得する
     * @param newMatterId 新規ID
     * @return `DataRelatedObject`
     */
    @AuraEnabled
    public static DataRelatedObject getMatching(
        String newMatterId
    ){
        // 実行処理
        return getMatchingProcess(newMatterId);
    }


    /**
     * @description 一覧編集内容を登録／更新する
     * @param newMatterId 新規ID
     * @param isPaperInput 書類部修正判定
     * @param matchingDataJson 画面一覧情報
     * @return `DataRelatedObject`
     */
    @AuraEnabled
    public static DataRelatedObject updateMatching(
        String newMatterId,
        Boolean isExceptImportantExplanation,
        Boolean isExceptContract,
        Boolean isExceptBill,
        Boolean isExceptDrawing,
        Boolean isPaperInput,
        String matchingDataJson
    ){
        // 実行処理
        updateMatchingProcess(newMatterId, isPaperInput, matchingDataJson,
            isExceptImportantExplanation, isExceptContract, isExceptBill, isExceptDrawing
        );
        return getMatchingProcess(newMatterId);
    }

    
    /**
     * @description 手動マッチングを実行する
     * @param newMatterId 新規ID
     * @return `DataRelatedObject`
     */
    /*
    @AuraEnabled
    public static DataRelatedObject doManualMatching(
        String newMatterId,
        Boolean isExceptImportantExplanation,
        Boolean isExceptContract,
        Boolean isExceptBill,
        Boolean isExceptDrawing,
        Boolean isPaperInput,
        String matchingDataJson
    ){
        // 実行処理
        updateMatchingProcess(newMatterId, isPaperInput, matchingDataJson,
            isExceptImportantExplanation, isExceptContract, isExceptBill, isExceptDrawing
        );
        doManualMatchingProcess(newMatterId, 
            isExceptImportantExplanation, isExceptContract,
            isExceptBill,isExceptDrawing);
        return getMatchingProcess(newMatterId);
    }
    */

    /**
     * @description 引数の新規IDからマッチング情報を取得する
     * @param newMatterId 新規ID
     * @return `DataRelatedObject`
     */
    public static DataRelatedObject getMatchingProcess(
        String newMatterId
    ){

        // カスタム設定
        MatchingSetting__c matchingSetting = MatchingSetting__c.getOrgDefaults();

        // 返却リストマップ
        DataRelatedObject dataRelated = new DataRelatedObject();

        try {

            // 処理関連情報取得
            MatchingComparisonProcessData processData = 
                getMatchingComparisonProcessData(newMatterId, matchingSetting);

            if(processData.matchingComparisonResult != null){                    
                dataRelated.isExceptImportantExplanation = processData.matchingComparisonResult.IsExceptImportantExplanation__c;
                dataRelated.isExceptContract = processData.matchingComparisonResult.IsExceptContract__c;
                dataRelated.isExceptBill = processData.matchingComparisonResult.IsExceptBill__c;
                dataRelated.isExceptDrawing = processData.matchingComparisonResult.isExceptDrawing__c;
            }

            if(processData.fifthSetConfirm != null &&
                processData.matchingComparisonResult != null){

                // 5点確定、比較結果が存在する場合フラグをON
                dataRelated.isFifthSetConfirmExists = true;
            }

            // 一覧表示情報
            List<DataRelateDatatable> dataRelateDatatables = 
                new List<DataRelateDatatable>();

            // マッチングのオブジェクト情報
            Map<String, Schema.SObjectField> matchingfieldInfos = Schema.SObjectType.Matching__c.fields.getMap();
            // 5点確定のオブジェクト情報
            Map<String, Schema.SObjectField> fifthSetConfirmfieldInfos = Schema.SObjectType.FifthSetConfirm__c.fields.getMap();
            
            // カスタムメタデータ「マッチング比較対象」の数分ループ
            for (MatchingComparisonTarget__mdt mCT : processData.matchingComparisonTarget) {

                // 一覧設定値
                DataRelateDatatable datatable = new DataRelateDatatable();

                // データテーブルID
                datatable.id = mCT.ReferenceName__c;
                // 項目名
                datatable.FieldsName = mCT.FieldsName__c;

                String fieldType;

                // 比較対象の書類件数を算出、画面返却値へ比較対象を設定
                Integer matchingTargetCnt = 0;
                if (mCT.IsImportantExplanation__c) {
                    datatable.IsImportantExplanationTarget = true;
                    matchingTargetCnt++;
                }
                if (mCT.IsContract__c) {
                    datatable.IsContractTarget = true;
                    matchingTargetCnt++;
                }
                if (mCT.IsBill__c) {
                    datatable.IsBillTarget = true;
                    matchingTargetCnt++;
                }
                if (mCT.IsDrawing__c) {
                    datatable.IsDrawingTarget = true;
                    matchingTargetCnt++;
                }

                // マッチング比較対象に一つでもTrueが存在する場合
                if(0 < matchingTargetCnt){
                    Schema.SObjectField field = matchingfieldInfos.get(
                        mCT.ReferenceName__c + matchingSetting.FieldSuffix__c);
                    fieldType = field.getDescribe().getType().name();
                }

                // カスタムメタデータ（マッチング比較対象）の該当フラグがTRUEかつ
                // 各マッチングデータが存在する場合、画面表示値を設定
                if(mCT.IsImportantExplanation__c && processData.targetData.importantExplanation != null){
                    datatable.ImportantExplanationText = objectToString(
                        fieldType,
                        processData.targetData.importantExplanation.get(
                            mCT.ReferenceName__c + matchingSetting.FieldSuffix__c));
                }
                if(mCT.IsContract__c && processData.targetData.contract != null){
                    datatable.ContractText = objectToString(
                        fieldType,
                        processData.targetData.contract.get(
                            mCT.ReferenceName__c + matchingSetting.FieldSuffix__c));
                }
                if(mCT.IsBill__c && processData.targetData.bill != null){
                    datatable.BillText = objectToString(
                        fieldType,
                        processData.targetData.bill.get(
                            mCT.ReferenceName__c + matchingSetting.FieldSuffix__c));
                }
                if(mCT.IsDrawing__c && processData.targetData.drawing != null){
                    datatable.DrawingText = objectToString(
                        fieldType,
                        processData.targetData.drawing.get(
                            mCT.ReferenceName__c + matchingSetting.FieldSuffix__c));
                }

                // 5点確定レコードが存在する場合
                if(dataRelated.isFifthSetConfirmExists){
                    Schema.SObjectField field = fifthSetConfirmfieldInfos.get(
                        mCT.ReferenceName__c + matchingSetting.FieldSuffix__c);
                    fieldType = field.getDescribe().getType().name();

                    // 結果値
                    datatable.ResultValueText = objectToString(
                        fieldType, 
                        processData.fifthSetConfirm.get(
                            mCT.ReferenceName__c + matchingSetting.FieldSuffix__c));

                    // 比較項目の場合、結果情報を表示
                    if(1 < matchingTargetCnt){

                        // 比較項目 true
                        datatable.IsComparison = true;

                        // 比較結果値を確認
                        Boolean IsComparisonResult = 
                            Boolean.valueOf(
                                processData.matchingComparisonResult.get(
                                    mCT.ReferenceName__c + matchingSetting.ResultFieldSuffix__c));

                        // 比較結果OKの場合
                        if(IsComparisonResult){
                            datatable.ResultText = matchingSetting.MatchingComparisonResultOk__c;                                

                            datatable.ResultTypeText = String.valueOf(
                                processData.matchingComparisonResult.get(
                                    mCT.ReferenceName__c + matchingSetting.TypeFieldSuffix__c));

                        } 
                        // 比較結果NGの場合
                        else {
                            datatable.ResultText = matchingSetting.MatchingComparisonResultNg__c;
                        }
                    } else {

                        // 比較項目ではない場合、値が存在すればOK表示
                        if (String.isNotEmpty(
                            objectToString(
                                fieldType, 
                                processData.fifthSetConfirm.get(
                                    mCT.ReferenceName__c + matchingSetting.FieldSuffix__c)))) {

                            datatable.ResultText = matchingSetting.MatchingComparisonResultOk__c;     
                        } 
                    }
                }

                dataRelateDatatables.add(datatable);
            }


            dataRelated.dataRelateDatatable = dataRelateDatatables;
            // 結果を返却
            return dataRelated;

        } catch (Exception e) {
            // 初期表示値取得失敗を表示
            throw new AuraHandledException(
                matchingSetting.GetMatchingEventErrorMessage__c);
        }
    }


    /**
     * @description 引数の新規IDからマッチング情報を取得する
     * @param newMatterId 新規ID
     * @param isPaperInput 書類入力フラグ
     * @param matchingDataJson マッチング一覧情報
     * @return `void`
     */
    public static void updateMatchingProcess(
        String newMatterId,
        Boolean isPaperInput,
        String matchingDataJson,
        Boolean isExceptImportantExplanation,
        Boolean isExceptContract,
        Boolean isExceptBill,
        Boolean isExceptDrawing
    ){

        // カスタム設定
        MatchingSetting__c matchingSetting = MatchingSetting__c.getOrgDefaults();

        try {
            // 画面検索部入力値
            List<Object> matchingData = new List<Object>();
            if (String.isNotBlank(matchingDataJson)) {
                matchingData = (List<Object>)JSON.deserializeUntyped(matchingDataJson);
            }

            if(isPaperInput){
                // 書類入力登録 
                // マッチングレコード登録／更新
                upsertPaperInput(newMatterId, matchingData, matchingSetting);
            } 

            // 結果情報更新 
            // 5点確定レコード更新
            // マッチング比較結果レコード更新
            updateConfirmAndResult(
                newMatterId, matchingData, matchingSetting,
                isExceptImportantExplanation, isExceptContract,
                isExceptBill, isExceptDrawing
            );

        } catch (Exception e) {
            // 登録処理失敗を表示
            throw new AuraHandledException(matchingSetting.UpdateMatchingEventErrorMessage__c);
        }
    }


    /**
     * @description 5点確定とマッチング比較結果情報更新
     * 
     * @param newMatterId
     * @param matchingDatas
     * @param matchingSetting
     * @return `void`
     */
    private static void updateConfirmAndResult(
        String newMatterId, 
        List<Object> matchingDatas,
        MatchingSetting__c matchingSetting,
        Boolean isExceptImportantExplanation,
        Boolean isExceptContract,
        Boolean isExceptBill,
        Boolean isExceptDrawing
        ) {
        
        Set<Id> newMatterIds = new Set<Id>();
        newMatterIds.add(newMatterId);

        // カスタムメタデータ：マッチング比較対象 取得
        List<MatchingComparisonTarget__mdt> matchingTargets =
            MatchingComparisonModel.getMatchingComparisonTargetMdt();

        // マッチング、5点確定、マッチング比較結果の取得項目リストを生成
        List<String> matchingFieldNames = new List<String>();
        for (MatchingComparisonTarget__mdt matchingTarget : matchingTargets) {
            matchingFieldNames.add(
                MatchingComparisonUtils.concat(
                    matchingTarget.ReferenceName__c, matchingSetting.FieldSuffix__c));
        }

        // マッチング比較結果取得
        List<MatchingComparisonResult__c> matchingComparisonResult = 
            MatchingComparisonModel.getMatchingComparisonResultsByNewMatterId(
                newMatterId);

        MatchingComparisonResult__c updateMatchingComparisonResult;

        if(!matchingComparisonResult.isEmpty()){
            // 比較結果が存在する場合
            updateMatchingComparisonResult = matchingComparisonResult.get(0);
            updateMatchingComparisonResult.IsExceptImportantExplanation__c = isExceptImportantExplanation;
            updateMatchingComparisonResult.IsExceptContract__c = isExceptContract;
            updateMatchingComparisonResult.IsExceptBill__c = isExceptBill;
            updateMatchingComparisonResult.IsExceptDrawing__c = isExceptDrawing;

        } else {
            // 比較結果が存在しない場合処理なし
            return;
        }

        // 5点確定取得
        List<FifthSetConfirm__c> fifthSetConfirm = 
            MatchingComparisonModel.getFifthSetConfirmsByNewMatterIds(
                newMatterIds, matchingFieldNames);

        // 更新用マッチング比較結果リスト
        List<MatchingComparisonResult__c> updateMatchingComparisonResults = 
            new List<MatchingComparisonResult__c>();

        // 5点確定が存在しない場合、マッチング比較結果の不要チェックボックスのみ更新
        if(fifthSetConfirm.isEmpty()){

            updateMatchingComparisonResults.add(updateMatchingComparisonResult);
            // マッチング比較結果更新
            MatchingComparisonModel.updateMatchingComparisonResult(updateMatchingComparisonResults);
            return;
        }

        FifthSetConfirm__c updateFifthSetConfirm = 
            fifthSetConfirm.get(0);

        // 5点確定オブジェクト情報
        Map<String, Schema.SObjectField> fieldInfos =
            Schema.SObjectType.FifthSetConfirm__c.fields.getMap();

        Map<String, Object> tmpMatchingDatas = new Map<String, Object>();
        for(Object matchingData: matchingDatas){

            tmpMatchingDatas = (Map<String, Object>)matchingData;

            // 参照名
            String referenceNameStr = (String)tmpMatchingDatas.get('id');
            // 結果区分
            String resultTextStr = (String)tmpMatchingDatas.get('ResultText');

            Schema.SObjectField field = fieldInfos.get(referenceNameStr + matchingSetting.FieldSuffix__c);
            String fieldType = field.getDescribe().getType().name();
            
            // 結果値に値が存在する場合
            if (tmpMatchingDatas.containsKey('ResultValueText') && 
                String.isNotEmpty((String)tmpMatchingDatas.get('ResultValueText'))) {
                
                updateFifthSetConfirm.put(
                    referenceNameStr + matchingSetting.FieldSuffix__c,
                    stringToObject(fieldType, tmpMatchingDatas.get('ResultValueText')));
            } 
            // 結果値が空の場合
            else {

                updateFifthSetConfirm.put(referenceNameStr + matchingSetting.FieldSuffix__c, null);
                
                // 比較結果を初期化
                if(Boolean.valueOf(tmpMatchingDatas.get('IsComparison'))){
                    updateMatchingComparisonResult.put(
                        referenceNameStr + matchingSetting.ResultFieldSuffix__c, false);
                    updateMatchingComparisonResult.put(
                        referenceNameStr + matchingSetting.TypeFieldSuffix__c, null);
                }

                // 次の繰り返しへ
                continue;
            }

            // 比較結果を更新
            if(Boolean.valueOf(tmpMatchingDatas.get('IsComparison'))){
                
                updateMatchingComparisonResult.put(
                    referenceNameStr + matchingSetting.ResultFieldSuffix__c, true);
                updateMatchingComparisonResult.put(
                    referenceNameStr + matchingSetting.TypeFieldSuffix__c,
                    (String)tmpMatchingDatas.get('ResultTypeText'));
            }

        }

        // 口座情報を生成し、家賃送金口座のIDを取得する
        Id contractMoney1 = insertBankAccountData(updateFifthSetConfirm);

        if(contractMoney1 != null){
            // 家賃送金口座のIDが取得できた場合、各参照へ設定
            updateFifthSetConfirm.BillingSecurityDepositAccount__c = contractMoney1;
            updateFifthSetConfirm.BillingDepositAccount__c = contractMoney1;
            updateFifthSetConfirm.BillingRewardAccount__c = contractMoney1;
            updateFifthSetConfirm.BillingKeyMoneyAccount__c = contractMoney1;
            updateFifthSetConfirm.BillingThisMonthRentAccount__c = contractMoney1;
            updateFifthSetConfirm.BillingThisMonthManagementChargeAccount__c = contractMoney1;
            updateFifthSetConfirm.BillingThisMonthCommonChargeAccount__c = contractMoney1;
            updateFifthSetConfirm.BillingThisMonthParkingFeeAccount__c = contractMoney1;
            updateFifthSetConfirm.BillingNextMonthRentAccount__c = contractMoney1;
            updateFifthSetConfirm.BillingNextMonthManagementChargeAccount__c = contractMoney1;
            updateFifthSetConfirm.BillingNextMonthCommonChargeAccount__c = contractMoney1;
            updateFifthSetConfirm.BillingNextMonthParkingFeeAccount__c = contractMoney1;
            updateFifthSetConfirm.AgencyCommissionAccount__c = contractMoney1;
            updateFifthSetConfirm.OtherBillingAmount1Account__c = contractMoney1;
            updateFifthSetConfirm.OtherBillingAmount2Account__c = contractMoney1;
            updateFifthSetConfirm.OtherBillingAmount3Account__c = contractMoney1;
            updateFifthSetConfirm.OtherBillingAmount4Account__c = contractMoney1;
            updateFifthSetConfirm.OtherBillingAmount5Account__c = contractMoney1;
            updateFifthSetConfirm.OtherBillingAmount6Account__c = contractMoney1;
            updateFifthSetConfirm.DepositAmortisationAccount__c = contractMoney1;
        }


        // マッチング比較結果更新
        updateMatchingComparisonResults.add(updateMatchingComparisonResult);
        MatchingComparisonModel.updateMatchingComparisonResult(updateMatchingComparisonResults);

        // 更新用5点確定リスト
        List<FifthSetConfirm__c> updateFifthSetConfirms = new List<FifthSetConfirm__c>();
        updateFifthSetConfirms.add(updateFifthSetConfirm);

        // 5点確定更新
        MatchingComparisonModel.updateFifthSetConfirm(updateFifthSetConfirms);
    }


    /**
     * @description 書類情報登録／更新
     * 
     * @param  newMatterId
     * @param  matchingDatas
     * @param  matchingSetting
     * @return `void`
     */
    private static void upsertPaperInput(
        String newMatterId, List<Object> matchingDatas,
        MatchingSetting__c matchingSetting) {
        
        // マッチング取得
        List<Matching__c> matchings = 
            MatchingComparisonModel.getMatchingsByNewMatterId(newMatterId);

        MatchingTargetInfo targetData = new MatchingTargetInfo();
        // マッチングレコード情報格納
        targetData.setMatching(matchings, matchingSetting);
        // マッチングレコードが存在しない書類に初期値を設定
        targetData.setDefaultMatching(newMatterId, matchingSetting);

        // マッチングオブジェクト情報
        Map<String, Schema.SObjectField> fieldInfos = Schema.SObjectType.Matching__c.fields.getMap();

        Map<String, Object> tmpMatchingDatas = new Map<String, Object>();
        for(Object matchingData: matchingDatas){
            tmpMatchingDatas = (Map<String, Object>)matchingData;

            // 比較対象でない場合、次のループへ
            if(!(Boolean)tmpMatchingDatas.get('IsImportantExplanationTarget') &&
                !(Boolean)tmpMatchingDatas.get('IsContractTarget') &&
                !(Boolean)tmpMatchingDatas.get('IsBillTarget') &&
                !(Boolean)tmpMatchingDatas.get('IsDrawingTarget')  ){
                
                continue;
            }

            // 参照名
            String referenceNameStr = (String)tmpMatchingDatas.get('id');

            Schema.SObjectField field = fieldInfos.get(referenceNameStr + matchingSetting.FieldSuffix__c);
            String fieldType = field.getDescribe().getType().name();

            // 重説
            if (tmpMatchingDatas.containsKey('ImportantExplanationText') &&
                String.isNotEmpty((String)tmpMatchingDatas.get('ImportantExplanationText'))) {

                targetData.isUpsertImportantExplanation = true;
                targetData.importantExplanation.put(
                    referenceNameStr + matchingSetting.FieldSuffix__c,
                    stringToObject(fieldType, tmpMatchingDatas.get('ImportantExplanationText')));
            }
            // 契約書
            if (tmpMatchingDatas.containsKey('ContractText') &&
                String.isNotEmpty((String)tmpMatchingDatas.get('ContractText'))) {

                targetData.isUpsertContract = true;
                targetData.contract.put(
                    referenceNameStr + matchingSetting.FieldSuffix__c,
                    stringToObject(fieldType, tmpMatchingDatas.get('ContractText')));
            }
            // 請求書
            if (tmpMatchingDatas.containsKey('BillText') &&
                String.isNotEmpty((String)tmpMatchingDatas.get('BillText'))) {

                targetData.isUpsertBill = true;
                targetData.bill.put(
                    referenceNameStr + matchingSetting.FieldSuffix__c,
                    stringToObject(fieldType, tmpMatchingDatas.get('BillText')));
            }
            // 図面
            if (tmpMatchingDatas.containsKey('DrawingText') &&
                String.isNotEmpty((String)tmpMatchingDatas.get('DrawingText'))) {

                targetData.isUpsertDrawing = true;
                targetData.drawing.put(
                    referenceNameStr + matchingSetting.FieldSuffix__c,
                    stringToObject(fieldType, tmpMatchingDatas.get('DrawingText')));
            }
        }

        List<Matching__c> upsertMatchings  = new List<Matching__c>();
        if(targetData.isUpsertImportantExplanation){
            upsertMatchings.add(targetData.importantExplanation);
        }
        if(targetData.isUpsertContract){
            upsertMatchings.add(targetData.contract);
        }
        if(targetData.isUpsertBill){
            upsertMatchings.add(targetData.bill);
        }
        if(targetData.isUpsertDrawing){
            upsertMatchings.add(targetData.drawing);
        }

        // マッチング登録／更新
        MatchingComparisonModel.upsertMatching(upsertMatchings);
    }

    /**
     * @description 手動マッチング実行処理
     * 
     * @param newMatterId // 新規ID
     * @param isExceptImportantExplanation // 重説不要フラグ
     * @param isExceptContract // 契約書不要フラグ
     * @param isExceptBill // 請求書不要フラグ
     * @param isExceptDrawing // 図面不要フラグ
     * @return `void`
     */
    /*
    public static void doManualMatchingProcess(
        String newMatterId,
        Boolean isExceptImportantExplanation,
        Boolean isExceptContract,
        Boolean isExceptBill,
        Boolean isExceptDrawing
    ){
        
        // カスタム設定
        MatchingSetting__c matchingSetting = MatchingSetting__c.getOrgDefaults();

        // 登録／更新用マッチング比較結果リスト
        List<MatchingComparisonResult__c> upsertMatchingComparisonResults = new List<MatchingComparisonResult__c>();
        // 登録／更新用5点確定リスト
        List<FifthSetConfirm__c> upsertFifthSetConfirms = new List<FifthSetConfirm__c>();
        try {

            MatchingResultData matchingResultData =
                executeManualMatchingComparison(
                    newMatterId, isExceptImportantExplanation,
                    isExceptContract, isExceptBill, isExceptDrawing, matchingSetting);

            upsertMatchingComparisonResults.add(matchingResultData.matchingComparisonResult);
            upsertFifthSetConfirms.add(matchingResultData.fifthSetConfirm);

            // マッチング比較結果 登録／更新
            MatchingComparisonModel.upsertMatchingComparisonResult(upsertMatchingComparisonResults);
            // 5点確定 登録／更新
            MatchingComparisonModel.upsertFifthSetConfirm(upsertFifthSetConfirms);

        } catch (Exception e) {
            // 手動マッチング実行処理失敗を表示
            throw new AuraHandledException(matchingSetting.DoManualMatchingEventErrorMessage__c);
        }
    }
    */


    /**
     * @description マッチング処理呼び出し
     * 
     * @param newMatterId // 新規ID
     * @param isExceptImportantExplanation // 重説不要フラグ
     * @param isExceptContract // 契約書不要フラグ
     * @param isExceptBill // 請求書不要フラグ
     * @param isExceptDrawing // 図面不要フラグ
     * @param matchingSetting // カスタム設定
     * @return  `MatchingResultData`
     */
    public static MatchingResultData executeManualMatchingComparison(
        String newMatterId, 
        Boolean isExceptImportantExplanation, 
        Boolean isExceptContract, 
        Boolean isExceptBill,
        Boolean isExceptDrawing,
        MatchingSetting__c matchingSetting

    ){

        // 関連情報取得
        MatchingComparisonProcessData processData = 
            getMatchingComparisonProcessData(newMatterId, matchingSetting);

        // マッチング比較処理呼び出し
        return MatchingComparisonUtils.executeMatchingComparison(
                processData.newMatter, // 新規
                processData.targetData, // マッチング
                processData.matchingComparisonResult, // マッチング比較結果
                processData.fifthSetConfirm, // 5点確定
                processData.matchingComparisonTarget, // カスタムメタデータ
                isExceptImportantExplanation, // 重説不要フラグ
                isExceptContract, // 契約書不要フラグ
                isExceptBill, // 請求書不要フラグ
                isExceptDrawing); // 図面不要フラグ

    }


    /**
     * @description 関連情報取得
     * 
     * @param newMatterId // 新規ID
     * @param matchingSetting // カスタム設定
     * @return  `MatchingResultData`
     */
    public static MatchingComparisonProcessData getMatchingComparisonProcessData(
        String newMatterId, 
        MatchingSetting__c matchingSetting
    ){

        Set<Id> newMatterIds = new Set<Id>();
        newMatterIds.add(newMatterId);

        // 新規取得
        List<NewMatter__c> newMatters =
            MatchingComparisonModel.getNewMatters(newMatterIds);

        // カスタムメタデータ：マッチング比較対象 取得
        List<MatchingComparisonTarget__mdt> matchingTargets =
            MatchingComparisonModel.getMatchingComparisonTargetMdt();

        // マッチング、5点確定、マッチング比較結果の取得項目リストを生成
        List<String> matchingFieldNames = new List<String>();
        List<String> matchingResultFieldNames = new List<String>();
        List<String> fifthSetConfirmFieldNames = new List<String>();
        for (MatchingComparisonTarget__mdt matchingTarget : matchingTargets) {
            fifthSetConfirmFieldNames.add(MatchingComparisonUtils.concat(matchingTarget.ReferenceName__c, matchingSetting.FieldSuffix__c));

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

        // マッチング 取得
        List<Matching__c> matchings =
            MatchingComparisonModel.getMatchingsByNewMatterIds(newMatterIds, matchingFieldNames);
        MatchingTargetData targetData = new MatchingTargetData();

        for (Matching__c matching : matchings) {
            if (matchingSetting.PaperTypeImportantExplanation__c.equals(matching.PaperType__c)) {
                targetData.importantExplanation = matching;
            } else if (matchingSetting.PaperTypeContract__c.equals(matching.PaperType__c)) {
                targetData.contract = matching;
            } else if (matchingSetting.PaperTypeBill__c.equals(matching.PaperType__c)) {
                targetData.bill = matching;
            } else if (matchingSetting.PaperTypeDrawing__c.equals(matching.PaperType__c)) {
                targetData.drawing = matching;
            }
        }

        // マッチング比較結果 取得
        MatchingComparisonResult__c sendMatchingComparisonResults;
        List<MatchingComparisonResult__c> matchingComparisonResults =
            MatchingComparisonModel.getMatchingComparisonResultsByNewMatterIds(
                newMatterIds, matchingResultFieldNames);

        // 5点確定 取得
        FifthSetConfirm__c sendFifthSetConfirms;
        List<FifthSetConfirm__c> fifthSetConfirms =
            MatchingComparisonModel.getFifthSetConfirmsByNewMatterIds(newMatterIds, fifthSetConfirmFieldNames);

        MatchingComparisonProcessData processData = new MatchingComparisonProcessData();

        processData.newMatter = newMatters.get(0);
        processData.matchingComparisonTarget = matchingTargets;
        processData.targetData = targetData;
        if(!matchingComparisonResults.isEmpty()){
            processData.matchingComparisonResult = matchingComparisonResults.get(0);
        }
        if(!fifthSetConfirms.isEmpty()){
            processData.fifthSetConfirm = fifthSetConfirms.get(0);
        }

        return processData;
    }


     /**
     * @description 5点確定に設定される口座情報の内、未登録の口座を登録する
     * 
     * @param fSConf 
     * @return `String`
     */
    private static Id insertBankAccountData(
        FifthSetConfirm__c fSConf) {

        List<BankAccount__c> insertBankAccounts = new List<BankAccount__c>();
        BankAccount__c contractMoney1 = createBankAccountInfo(
            fSConf.ContractMoneyBankAccountBankNum1__c,
            fSConf.ContractMoneyBankAccountBranchOfficeNum1__c,
            fSConf.ContractMoneyBankAccountNum1__c,
            fSConf.ContractMoneyBankAccountType1__c);
        BankAccount__c contractMoney2 = createBankAccountInfo(
            fSConf.ContractMoneyBankAccountBankNum2__c,
            fSConf.ContractMoneyBankAccountBranchOfficeNum2__c,
            fSConf.ContractMoneyBankAccountNum2__c,
            fSConf.ContractMoneyBankAccountType2__c);
        BankAccount__c contractMoney3 = createBankAccountInfo(
            fSConf.ContractMoneyBankAccountBankNum3__c,
            fSConf.ContractMoneyBankAccountBranchOfficeNum3__c,
            fSConf.ContractMoneyBankAccountNum3__c,
            fSConf.ContractMoneyBankAccountType3__c);
        BankAccount__c rent = createBankAccountInfo(
            fSConf.RentBankAccountBankNum__c,
            fSConf.RentBankAccountBranchOfficeNum__c,
            fSConf.RentBankAccountNum__c,
            fSConf.RentBankAccountType__c);

        // 必須項目が全て存在し、かつ口座が存在しない場合登録の設定を行う
        if(contractMoney1 != null && String.isBlank(contractMoney1.id)){
            contractMoney1.BankName__c = fSConf.ContractMoneyBankAccountBank1__c;
            contractMoney1.BranchOfficeName__c = fSConf.ContractMoneyBankAccountBranchOffice1__c;
            contractMoney1.BankAccountName__c = fSConf.ContractMoneyBankAccountContractor1__c;
            contractMoney1.ContractorKana__c = fSConf.ContractMoneyBankAccountContractorKana1__c;
            contractMoney1.BankAccountId__c = fSConf.ContractMoneyBankAccountId1__c;
            insertBankAccounts.add(contractMoney1);
        }
        if(contractMoney2 != null && String.isBlank(contractMoney2.id)){
            if(checkDuplicateBankAccount(contractMoney2, insertBankAccounts)){
                contractMoney2.BankName__c = fSConf.ContractMoneyBankAccountBank2__c;
                contractMoney2.BranchOfficeName__c = fSConf.ContractMoneyBankAccountBranchOffice2__c;
                contractMoney2.BankAccountName__c = fSConf.ContractMoneyBankAccountContractor2__c;
                contractMoney2.ContractorKana__c = fSConf.ContractMoneyBankAccountContractorKana2__c;
                contractMoney2.BankAccountId__c = fSConf.ContractMoneyBankAccountId2__c;
                insertBankAccounts.add(contractMoney2);
            }
        }
        if(contractMoney3 != null && String.isBlank(contractMoney3.id)){
            if(checkDuplicateBankAccount(contractMoney3, insertBankAccounts)){
                contractMoney3.BankName__c = fSConf.ContractMoneyBankAccountBank3__c;
                contractMoney3.BranchOfficeName__c = fSConf.ContractMoneyBankAccountBranchOffice3__c;
                contractMoney3.BankAccountName__c = fSConf.ContractMoneyBankAccountContractor3__c;
                contractMoney3.ContractorKana__c = fSConf.ContractMoneyBankAccountContractorKana3__c;
                contractMoney3.BankAccountId__c = fSConf.ContractMoneyBankAccountId3__c;
                insertBankAccounts.add(contractMoney3);
            }
        }
        if(rent != null && String.isBlank(rent.id)){
            if(checkDuplicateBankAccount(rent, insertBankAccounts)){
                rent.BankName__c = fSConf.RentBankAccountBank__c;
                rent.BranchOfficeName__c = fSConf.RentBankAccountBranchOffice__c;
                rent.BankAccountName__c = fSConf.RentBankAccountContractor__c;
                rent.ContractorKana__c = fSConf.RentBankAccountContractorKana__c;
                rent.BankAccountId__c = fSConf.RentBankAccountId__c;
                insertBankAccounts.add(rent);
            }
        } 

        // 口座登録
        MatchingComparisonModel.insertBankAccount(insertBankAccounts);

        if(contractMoney1 != null){
            return contractMoney1.id;
        } 

        return null;
    }


    /**
     * @description 口座情報の存在を確認
     * 存在するしない場合、空を返却
     * 存在する場合、かつ該当口座が存在する場合口座IDを返却
     * 存在する場合、かつ該当口座が存在しない場合登録口座情報を返却
     * 
     * @param bankAccountBankNum // 銀行番号
     * @param bankAccountBranchOfficeNum // 支店番号
     * @param bankAccountNum // 口座番号
     * @param bankAccountType // 種別
     * @return `String`
     */
    private static BankAccount__c createBankAccountInfo(
        String bankAccountBankNum, String bankAccountBranchOfficeNum,
         String bankAccountNum, String bankAccountType) {
        
        BankAccount__c bankAccountData;
    
        if (String.isEmpty(bankAccountBankNum) ||
            String.isEmpty(bankAccountNum) ||
            String.isEmpty(bankAccountBranchOfficeNum) ||
            String.isEmpty(bankAccountType) 
        ) {
            // 空のオブジェクトを返却
            return bankAccountData;
        }

        // 口座取得 
        List<BankAccount__c> bankAccount = 
            MatchingComparisonModel.getBankAccounts(
                bankAccountBankNum, bankAccountBranchOfficeNum,
                bankAccountNum, bankAccountType);

        if(bankAccount.isEmpty()){
            bankAccountData = new BankAccount__c();

            // 既存の口座が存在しない場合、登録用の口座を返却する。
            bankAccountData.BankCode__c = bankAccountBankNum;
            bankAccountData.BranchOfficeCode__c = bankAccountBranchOfficeNum;
            bankAccountData.Name = bankAccountNum;
            bankAccountData.DepositType__c = bankAccountType;

            return bankAccountData;
        } else {
            return bankAccount.get(0);
        }
        
    }


    /**
     * @description 画面表示値へ変換する
     * 
     * @param fieldType 型情報
     * @param obj 変換元
     * @return `String`
     */
    private static String objectToString(
        String fieldType, Object obj) {
        
        if(obj == null){
            return null; 
        }

        if (fieldType == 'DATE') {
            Date d = Date.valueOf(obj);
            return String.valueOf(d);

        } 

        return String.valueOf(obj);
    }

    /**
     * @description 画面情報をオブジェクト登録用に型変換する
     * 
     * @param fieldType 型情報
     * @param obj 変換元
     * @return `Object`
     */
    private static Object stringToObject(
        String fieldType, Object obj) {
        
        if(obj == null){
            return null; 
        }

        if (fieldType=='CURRENCY' || fieldType=='DOUBLE' ||
            fieldType=='INTEGER' || fieldType=='PERCENT' ) {

            return Integer.valueOf(obj);
        }

        if (fieldType == 'DATE') {
            String str = String.valueOf(obj);
            return Date.valueOf(str);
        }         

        return String.valueOf(obj);
    }

    /**
     * @description 複数の同一口座を生成しないチェック
     * 
     * @param bankAccount 
     * @param insertBankAccounts 
     * @return `Boolean`
     */
    private static Boolean checkDuplicateBankAccount(
        BankAccount__c bankAccount, List<BankAccount__c> insertBankAccounts ) {
     
        if(insertBankAccounts.isEmpty()){
           return true; 
        }

        for(BankAccount__c insertBA :insertBankAccounts){
            if(insertBA.BankCode__c == bankAccount.BankCode__c && 
                insertBA.BranchOfficeCode__c == bankAccount.BranchOfficeCode__c &&
                insertBA.Name == bankAccount.Name && 
                insertBA.DepositType__c == bankAccount.DepositType__c ){
                
                return false;
            }
        }
        return true;
    }
    
    /**
     * 処理関連情報を格納
     */
    public class MatchingComparisonProcessData {
        /* 新規 */
        public NewMatter__c newMatter {get;set;}
        /* マッチング情報 */
        public MatchingTargetData targetData {get;set;}
        /* マッチング比較結果 */
        public MatchingComparisonResult__c matchingComparisonResult {get;set;}
        /* 5点確定 */
        public FifthSetConfirm__c fifthSetConfirm {get;set;}
        /* カスタムメタデータ */
        public List<MatchingComparisonTarget__mdt> matchingComparisonTarget {get;set;}

    }

    /**
     * 登録／更新するマッチング情報を格納
     */
    public class MatchingTargetInfo {
        public Boolean isUpsertImportantExplanation {get;set;}
        public Boolean isUpsertContract {get;set;}
        public Boolean isUpsertBill {get;set;}
        public Boolean isUpsertDrawing {get;set;}
        /* 重説 */
        public Matching__c importantExplanation {get;set;}
        /* 契約書 */
        public Matching__c contract {get;set;}
        /* 請求書 */
        public Matching__c bill {get;set;}
        /* 図説 */
        public Matching__c drawing {get;set;}

        public MatchingTargetInfo() {
            this.isUpsertImportantExplanation = false;
            this.isUpsertContract = false;
            this.isUpsertBill = false;
            this.isUpsertDrawing = false;
            this.importantExplanation = new Matching__c();
            this.contract = new Matching__c();
            this.bill = new Matching__c();
            this.drawing = new Matching__c();
        }

        /**
         * @description 該当書類が存在する場合格納
         */
        public void setMatching(List<Matching__c> matchings, MatchingSetting__c matchingSetting){

            for (Matching__c matching : matchings) {

                if (matchingSetting.PaperTypeImportantExplanation__c.equals(matching.PaperType__c)) {
                    this.importantExplanation = matching;
                } else if (matchingSetting.PaperTypeContract__c.equals(matching.PaperType__c)) {
                    this.contract = matching;
                } else if (matchingSetting.PaperTypeBill__c.equals(matching.PaperType__c)) {
                    this.bill = matching;
                } else if (matchingSetting.PaperTypeDrawing__c.equals(matching.PaperType__c)) {
                    this.drawing = matching;
                }

            }
        }


        /**
         * @description 該当の書類が存在しない場合初期設定する
         */
        public void setDefaultMatching(String newMatterId, MatchingSetting__c matchingSetting){
            // 重説
            if(String.isBlank(this.importantExplanation.Id)){
                this.importantExplanation = new Matching__c(
                    Name = newMatterId + matchingSetting.PaperTypeImportantExplanation__c,
                    NewMatter__c = newMatterId,
                    PaperType__c = matchingSetting.PaperTypeImportantExplanation__c
                );
            }
            // 契約書
            if(String.isBlank(this.contract.Id)){
                this.contract = new Matching__c(
                    Name = newMatterId + matchingSetting.PaperTypeContract__c,
                    NewMatter__c = newMatterId,
                    PaperType__c = matchingSetting.PaperTypeContract__c
                );
            }
            // 請求書
            if(String.isBlank(this.bill.Id)){
                this.bill = new Matching__c(
                    Name = newMatterId + matchingSetting.PaperTypeBill__c,
                    NewMatter__c = newMatterId,
                    PaperType__c = matchingSetting.PaperTypeBill__c
                );
            }
            // 図面
            if(String.isBlank(this.drawing.Id)){
                this.drawing = new Matching__c(
                    Name = newMatterId + matchingSetting.PaperTypeDrawing__c,
                    NewMatter__c = newMatterId,
                    PaperType__c = matchingSetting.PaperTypeDrawing__c
                );
            }
        }
    }


    /**
     * @description 画面初期表示情報返却オブジェクト
     */
    public class DataRelatedObject{ 
        @AuraEnabled
        public Boolean isMatchingExists { get; set; } // マッチング存在フラグ
        @AuraEnabled
        public Boolean isFifthSetConfirmExists { get; set; } // 5点確定存在フラグ
        @AuraEnabled
        public Boolean isExceptImportantExplanation { get; set; } // 重説フラグ
        @AuraEnabled
        public Boolean isExceptContract { get; set; } // 契約書フラグ
        @AuraEnabled
        public Boolean isExceptBill { get; set; } // 請求書フラグ
        @AuraEnabled
        public Boolean isExceptDrawing { get; set; } // 図面フラグ
        @AuraEnabled
        public List<DataRelateDatatable> dataRelateDatatable { get; set; } // データテーブル情報
        
        public DataRelatedObject() {
            this.dataRelateDatatable = new List<DataRelateDatatable>();
            this.isMatchingExists = false;
            this.isFifthSetConfirmExists = false;
            this.isExceptImportantExplanation = false;
            this.isExceptContract = false;
            this.isExceptBill = false;
            this.isExceptDrawing = false;
        }
    }

    /**
     * @description 画面データテーブル表示用オブジェクト
     */
    public class DataRelateDatatable{
        @AuraEnabled
        public String id  { get; set; } // 行id
        @AuraEnabled
        public String FieldsName { get; set; } // 項目名
        @AuraEnabled
        public String ImportantExplanationText { get; set; } // 重説
        @AuraEnabled
        public String ContractText { get; set; } // 契約書
        @AuraEnabled
        public String BillText { get; set; } // 請求書
        @AuraEnabled
        public String DrawingText { get; set; } // 図面
        @AuraEnabled
        public String ResultText { get; set; } // 結果
        @AuraEnabled
        public String ResultTypeText { get; set; } // 結果区分
        @AuraEnabled
        public String ResultValueText { get; set; } // 結果値
        @AuraEnabled
        public List<Map<String,String>> actionContents { get; set; } // アクション情報
        @AuraEnabled
        public Boolean IsComparison { get; set; } // 比較項目判定
        @AuraEnabled
        public Boolean IsResultValueEdit { get; set; } // 編集可能／不可能
        @AuraEnabled
        public Boolean IsImportantExplanationEdit { get; set; } // 重説入力可能／不可能
        @AuraEnabled
        public Boolean IsContractEdit { get; set; } // 契約書入力可能／不可能
        @AuraEnabled
        public Boolean IsBillEdit { get; set; } // 請求書入力可能／不可能
        @AuraEnabled
        public Boolean IsDrawingEdit { get; set; } // 図面入力可能／不可能
        @AuraEnabled
        public Boolean IsImportantExplanationTarget { get; set; } // 重説対象項目
        @AuraEnabled
        public Boolean IsContractTarget { get; set; } // 契約書対象項目
        @AuraEnabled
        public Boolean IsBillTarget { get; set; } // 請求書対象項目
        @AuraEnabled
        public Boolean IsDrawingTarget { get; set; } // 図面対象項目


        public DataRelateDatatable() {
            this.actionContents = new List<Map<String,String>>();
            this.IsComparison = false;
            this.IsResultValueEdit = false;
            this.IsImportantExplanationEdit = false;
            this.IsContractEdit = false;
            this.IsBillEdit = false;
            this.IsDrawingEdit = false;
            this.IsImportantExplanationTarget = false;
            this.IsContractTarget = false;
            this.IsBillTarget = false;
            this.IsDrawingTarget = false;
        }
    }    
}