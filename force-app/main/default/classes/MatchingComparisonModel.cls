/**
 * マッチング画面のモデルクラス
 */
public class MatchingComparisonModel {

    /**
     * カスタムメタデータ：マッチング比較対象 取得
     * @return  `List<MatchingComparisonTarget__mdt>`
     */
    public static List<MatchingComparisonTarget__mdt> getMatchingComparisonTargetMdt() {
        return [
            SELECT
                FieldsName__c,
                ReferenceName__c,
                RowNum__c,
                IsImportantExplanation__c,
                IsContract__c,
                IsBill__c,
                IsDrawing__c
            FROM MatchingComparisonTarget__mdt
            ORDER BY RowNum__c
        ];
    }

    /**
     * 新規レコード取得（複数）
     * @param newMatterIds 
     * @return  `List<NewMatter__c>`
     */
    public static List<NewMatter__c> getNewMatters(Set<Id> newMatterIds) {
        return [
            SELECT
                Id,
                Application__r.RecordType.Name
            FROM NewMatter__c
            WHERE Id IN :newMatterIds
        ];
    }

    /**
     * マッチング取得（新規ID指定）
     * @param newMatterIds 
     * @param fieldNames 
     * @return  `List<Matching__c>`
     */
    public static List<Matching__c> getMatchingsByNewMatterIds(Set<Id> newMatterIds, List<String> fieldNames) {
        List<String> cloneFieldNames = fieldNames.clone();
        cloneFieldNames.add(0, 'PaperType__c');
        cloneFieldNames.add(0, 'NewMatter__c');
        cloneFieldNames.add(0, 'Id');
        List<String> querys = new List<String>{
            'SELECT',
            String.join(cloneFieldNames, ', '),
            'FROM Matching__c',
            'WHERE NewMatter__c IN :newMatterIds'
        };
        return Database.query(String.join(querys, ' '));
    }

    /**
     * マッチング取得（新規ID一件指定）
     * @param newMatterIds 
     * @param fieldNames 
     * @return  `List<Matching__c>`
     */
    public static List<Matching__c> getMatchingsByNewMatterId(  
        String newMatterId) {

        return 
            [SELECT 
                Id
                , Name
                , NewMatter__c
                , PaperType__c
            FROM Matching__c
            WHERE NewMatter__c = :newMatterId
            ];
    }

    /**
     * マッチング比較結果取得（新規ID指定）
     * @param newMatterIds 
     * @param fieldNames 
     * @return  `List<MatchingComparisonResult__c>`
     */
    public static List<MatchingComparisonResult__c> getMatchingComparisonResultsByNewMatterIds(Set<Id> newMatterIds, List<String> fieldNames) {
        List<String> cloneFieldNames = fieldNames.clone();
        cloneFieldNames.add(0, 'IsExceptDrawing__c');
        cloneFieldNames.add(0, 'IsExceptBill__c');
        cloneFieldNames.add(0, 'IsExceptContract__c');
        cloneFieldNames.add(0, 'IsExceptImportantExplanation__c');
        cloneFieldNames.add(0, 'NewMatter__c');
        cloneFieldNames.add(0, 'Id');
        List<String> querys = new List<String>{
            'SELECT',
            String.join(cloneFieldNames, ', '),
            'FROM MatchingComparisonResult__c',
            'WHERE NewMatter__c IN :newMatterIds'
        };
        return Database.query(String.join(querys, ' '));
    }

    /**
     * マッチング比較結果取得（新規ID一件指定）
     * @param newMatterId 
     * @return  `List<MatchingComparisonResult__c>`
     */
    public static List<MatchingComparisonResult__c> getMatchingComparisonResultsByNewMatterId(
        String newMatterId) {

        return 
            [SELECT 
                Id,
                IsExceptImportantExplanation__c,
                IsExceptContract__c,
                IsExceptBill__c,
                IsExceptDrawing__c
            FROM MatchingComparisonResult__c
            WHERE NewMatter__c = :newMatterId
        ];
    }


    /**
     * 5点確定取得（新規ID指定）
     * @param newMatterIds 
     * @param fieldNames 
     * @return  `List<FifthSetConfirm__c>`
     */
    public static List<FifthSetConfirm__c> getFifthSetConfirmsByNewMatterIds(Set<Id> newMatterIds, List<String> fieldNames) {
        List<String> cloneFieldNames = fieldNames.clone();
        cloneFieldNames.add(0, 'NewMatter__c');
        cloneFieldNames.add(0, 'Id');
        for(String str : fieldNames){
            System.debug(str);
        }
        List<String> querys = new List<String>{
            'SELECT',
            String.join(fieldNames, ', '),
            'FROM FifthSetConfirm__c',
            'WHERE NewMatter__c IN :newMatterIds'
        };
        return Database.query(String.join(querys, ' '));
    }


    /**
     * 口座取得（銀行番号、支店番号、口座番号、種別指定）
     * @param bankAccountBankNum 
     * @param bankAccountBranchOfficeNum 
     * @param bankAccountNum 
     * @param bankAccountType 
     * @return  `List<BankAccount__c>`
     */
    public static List<BankAccount__c> getBankAccounts(
        String bankAccountBankNum, String bankAccountBranchOfficeNum,
        String bankAccountNum, String bankAccountType) {

        return  
            [SELECT 
                Id
            FROM BankAccount__c
            WHERE BankCode__c = :BankAccountBankNum
                AND BranchOfficeCode__c = :BankAccountBranchOfficeNum
                AND Name= :BankAccountNum
                AND DepositType__c = :BankAccountType
            ];
    }


    /**
     * 
     * @param matchingComparisonResults 
     */
    public static void upsertMatchingComparisonResult(List<MatchingComparisonResult__c> matchingComparisonResults) {
        // 登録／更新対象がnullまたは空の場合は何もしない
        if (matchingComparisonResults == null || matchingComparisonResults.isEmpty()) {
            return;
        }
        try {
            upsert matchingComparisonResults;
        } catch(DmlException e) {
            System.debug('--- DmlException ---');
            System.debug('--- e.getNumDml() ---> ' + e.getNumDml());
            for (Integer index = 0; index < e.getNumDml(); index++) {
                System.debug('--- index ---> ' + index);
                System.debug('--- e.getDmlId(index) ---> ' + e.getDmlId(index));
                System.debug('--- e.getDmlIndex(index) ---> ' + e.getDmlIndex(index));
                System.debug('--- e.getDmlFieldNames(index) ---> ' + e.getDmlFieldNames(index));
                System.debug('--- e.getDmlMessage(index) ---> ' + e.getDmlMessage(index));
                System.debug('--- e.getDmlType(index).name() ---> ' + e.getDmlType(index).name());
            }
            throw e;
        } catch(Exception e) {
            System.debug('--- Exception ---');
            System.debug('--- e.getTypeName() ---> ' + e.getTypeName());
            System.debug('--- e.getCause() ---> ' + e.getCause());
            System.debug('--- e.getLineNumber() ---> ' + e.getLineNumber());
            System.debug('--- e.getMessage() ---> ' + e.getMessage());

            throw e;
        }
    }

    /**
     * 
     * @param matchingComparisonResults 
     */
    public static void updateMatchingComparisonResult(List<MatchingComparisonResult__c> matchingComparisonResults) {
        // 更新対象がnullまたは空の場合は何もしない
        if (matchingComparisonResults == null || matchingComparisonResults.isEmpty()) {
            return;
        }
        try {
            update matchingComparisonResults;
        } catch(DmlException e) {
            System.debug('--- DmlException ---');
            System.debug('--- e.getNumDml() ---> ' + e.getNumDml());
            for (Integer index = 0; index < e.getNumDml(); index++) {
                System.debug('--- index ---> ' + index);
                System.debug('--- e.getDmlId(index) ---> ' + e.getDmlId(index));
                System.debug('--- e.getDmlIndex(index) ---> ' + e.getDmlIndex(index));
                System.debug('--- e.getDmlFieldNames(index) ---> ' + e.getDmlFieldNames(index));
                System.debug('--- e.getDmlMessage(index) ---> ' + e.getDmlMessage(index));
                System.debug('--- e.getDmlType(index).name() ---> ' + e.getDmlType(index).name());
            }
            throw e;
        } catch(Exception e) {
            System.debug('--- Exception ---');
            System.debug('--- e.getTypeName() ---> ' + e.getTypeName());
            System.debug('--- e.getCause() ---> ' + e.getCause());
            System.debug('--- e.getLineNumber() ---> ' + e.getLineNumber());
            System.debug('--- e.getMessage() ---> ' + e.getMessage());

            throw e;
        }
    }

    /**
     * 
     * @param fifthSetConfirms 
     */
    public static void upsertFifthSetConfirm(List<FifthSetConfirm__c> fifthSetConfirms) {
        // 登録／更新対象がnullまたは空の場合は何もしない
        if (fifthSetConfirms == null || fifthSetConfirms.isEmpty()) {
            return;
        }
        try {
            upsert fifthSetConfirms;
        } catch(DmlException e) {
            System.debug('--- DmlException ---');
            System.debug('--- e.getNumDml() ---> ' + e.getNumDml());
            for (Integer index = 0; index < e.getNumDml(); index++) {
                System.debug('--- index ---> ' + index);
                System.debug('--- e.getDmlId(index) ---> ' + e.getDmlId(index));
                System.debug('--- e.getDmlIndex(index) ---> ' + e.getDmlIndex(index));
                System.debug('--- e.getDmlFieldNames(index) ---> ' + e.getDmlFieldNames(index));
                System.debug('--- e.getDmlMessage(index) ---> ' + e.getDmlMessage(index));
                System.debug('--- e.getDmlType(index).name() ---> ' + e.getDmlType(index).name());
            }
            throw e;
        } catch(Exception e) {
            System.debug('--- Exception ---');
            System.debug('--- e.getTypeName() ---> ' + e.getTypeName());
            System.debug('--- e.getCause() ---> ' + e.getCause());
            System.debug('--- e.getLineNumber() ---> ' + e.getLineNumber());
            System.debug('--- e.getMessage() ---> ' + e.getMessage());

            throw e;
        }
    }

    /**
     * 
     * @param fifthSetConfirms 
     */
    public static void updateFifthSetConfirm(List<FifthSetConfirm__c> fifthSetConfirms) {
        // 更新対象がnullまたは空の場合は何もしない
        if (fifthSetConfirms == null || fifthSetConfirms.isEmpty()) {
            return;
        }
        try {
            update fifthSetConfirms;
        } catch(DmlException e) {
            System.debug('--- DmlException ---');
            System.debug('--- e.getNumDml() ---> ' + e.getNumDml());
            for (Integer index = 0; index < e.getNumDml(); index++) {
                System.debug('--- index ---> ' + index);
                System.debug('--- e.getDmlId(index) ---> ' + e.getDmlId(index));
                System.debug('--- e.getDmlIndex(index) ---> ' + e.getDmlIndex(index));
                System.debug('--- e.getDmlFieldNames(index) ---> ' + e.getDmlFieldNames(index));
                System.debug('--- e.getDmlMessage(index) ---> ' + e.getDmlMessage(index));
                System.debug('--- e.getDmlType(index).name() ---> ' + e.getDmlType(index).name());
            }
            throw e;
        } catch(Exception e) {
            System.debug('--- Exception ---');
            System.debug('--- e.getTypeName() ---> ' + e.getTypeName());
            System.debug('--- e.getCause() ---> ' + e.getCause());
            System.debug('--- e.getLineNumber() ---> ' + e.getLineNumber());
            System.debug('--- e.getMessage() ---> ' + e.getMessage());

            throw e;
        }
    }

    /**
     * 
     * @param tasks 
     */
    public static void insertTask(List<Task> tasks) {
        // 登録対象がnullまたは空の場合は何もしない
        if (tasks == null || tasks.isEmpty()) {
            return;
        }
        try {
            insert tasks;
        } catch(DmlException e) {
            System.debug('--- DmlException ---');
            System.debug('--- e.getNumDml() ---> ' + e.getNumDml());
            for (Integer index = 0; index < e.getNumDml(); index++) {
                System.debug('--- index ---> ' + index);
                System.debug('--- e.getDmlId(index) ---> ' + e.getDmlId(index));
                System.debug('--- e.getDmlIndex(index) ---> ' + e.getDmlIndex(index));
                System.debug('--- e.getDmlFieldNames(index) ---> ' + e.getDmlFieldNames(index));
                System.debug('--- e.getDmlMessage(index) ---> ' + e.getDmlMessage(index));
                System.debug('--- e.getDmlType(index).name() ---> ' + e.getDmlType(index).name());
            }
            throw e;
        } catch(Exception e) {
            System.debug('--- Exception ---');
            System.debug('--- e.getTypeName() ---> ' + e.getTypeName());
            System.debug('--- e.getCause() ---> ' + e.getCause());
            System.debug('--- e.getLineNumber() ---> ' + e.getLineNumber());
            System.debug('--- e.getMessage() ---> ' + e.getMessage());

            throw e;
        }
    }

    /**
     * 
     * @param matchings 
     */
    public static void upsertMatching(List<Matching__c> matchings) {
        // 登録／更新対象がnullまたは空の場合は何もしない
        if (matchings == null || matchings.isEmpty()) {
            return;
        }
        try {
            upsert matchings;
        } catch(DmlException e) {
            System.debug('--- DmlException ---');
            System.debug('--- e.getNumDml() ---> ' + e.getNumDml());
            for (Integer index = 0; index < e.getNumDml(); index++) {
                System.debug('--- index ---> ' + index);
                System.debug('--- e.getDmlId(index) ---> ' + e.getDmlId(index));
                System.debug('--- e.getDmlIndex(index) ---> ' + e.getDmlIndex(index));
                System.debug('--- e.getDmlFieldNames(index) ---> ' + e.getDmlFieldNames(index));
                System.debug('--- e.getDmlMessage(index) ---> ' + e.getDmlMessage(index));
                System.debug('--- e.getDmlType(index).name() ---> ' + e.getDmlType(index).name());
            }
            throw e;
        } catch(Exception e) {
            System.debug('--- Exception ---');
            System.debug('--- e.getTypeName() ---> ' + e.getTypeName());
            System.debug('--- e.getCause() ---> ' + e.getCause());
            System.debug('--- e.getLineNumber() ---> ' + e.getLineNumber());
            System.debug('--- e.getMessage() ---> ' + e.getMessage());

            throw e;
        }
    }

    /**
     * 
     * @param bankAccounts 
     */
    public static void insertBankAccount(List<BankAccount__c> bankAccounts) {
        // 登録／更新対象がnullまたは空の場合は何もしない
        if (bankAccounts == null || bankAccounts.isEmpty()) {
            return;
        }
        try {
            insert bankAccounts;
        } catch(DmlException e) {
            System.debug('--- DmlException ---');
            System.debug('--- e.getNumDml() ---> ' + e.getNumDml());
            for (Integer index = 0; index < e.getNumDml(); index++) {
                System.debug('--- index ---> ' + index);
                System.debug('--- e.getDmlId(index) ---> ' + e.getDmlId(index));
                System.debug('--- e.getDmlIndex(index) ---> ' + e.getDmlIndex(index));
                System.debug('--- e.getDmlFieldNames(index) ---> ' + e.getDmlFieldNames(index));
                System.debug('--- e.getDmlMessage(index) ---> ' + e.getDmlMessage(index));
                System.debug('--- e.getDmlType(index).name() ---> ' + e.getDmlType(index).name());
            }
            throw e;
        } catch(Exception e) {
            System.debug('--- Exception ---');
            System.debug('--- e.getTypeName() ---> ' + e.getTypeName());
            System.debug('--- e.getCause() ---> ' + e.getCause());
            System.debug('--- e.getLineNumber() ---> ' + e.getLineNumber());
            System.debug('--- e.getMessage() ---> ' + e.getMessage());

            throw e;
        }
    }

}