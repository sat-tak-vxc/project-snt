public class PhaseGateCreateCaseTestData{
    public static List<Case> createData(){
        
        //取引先を作成
        List<Account> accountList= new List<Account>();
        // レコードタイプ（委託企業）取得
        RecordType recordTypeCompany = [
            SELECT Id
            FROM RecordType
            WHERE 
                SobjectType = 'Account' 
                AND Name = '委託企業' 
                AND IsActive = true
            LIMIT 1
        ];
        Account account1 = new Account(
            RecordTypeId = recordTypeCompany.id,//レコードタイプ
            AccountId__c = '312312312', //取引先ID
            Name = 'フェーズゲートテスト取引先132'//取引先名
        );
        accountList.add(account1);

        Account account2 = new Account(
            RecordTypeId = recordTypeCompany.id,//レコードタイプ
            AccountId__c = '423423423', //取引先ID
            Name = 'フェーズゲートテスト取引先133'//取引先名
        );
        accountList.add(account2);

        insert accountList;

        //フェーズゲートレコードを作成
        List<PhaseGate__c> phaseGateList = new List<PhaseGate__c>();
        PhaseGate__c phaseGate1 = new PhaseGate__c(
            Operation__c = 'Case',
            Stage__c = '対応中',
            Step__c = 2,
            Type__c = '必須項目',
            Field__c = 'AcceptDate__c',
            MandatoryFieldsErrorMessage__c = '必須項目です。入力してください。',
            AfterStageMandatoryFieldsErrorMessage__c =  '後フェーズでの必須項目です。入力しないでください。'
        );
        phaseGateList.add(phaseGate1);

        PhaseGate__c phaseGate2 = new PhaseGate__c(
            Operation__c = 'Case',
            Stage__c = '完了報告',
            Step__c = 3,
            Type__c = '必須項目',
            Field__c = 'CompletedReportDate__c',
            MandatoryFieldsErrorMessage__c = '必須項目です。入力してください。',
            AfterStageMandatoryFieldsErrorMessage__c =  '後フェーズでの必須項目です。入力しないでください。'
        );
        phaseGateList.add(phaseGate2);

        insert phaseGateList;

        //ケースレコードを作成
        List<Case> caseList = new List<Case>();
        Case case1 = new Case(
            Status = '対応中',
            Account__c = account1.id,
            Origin = '電話'//受付方法
        );
        caseList.add(case1);

        Case case2 = new Case(
            Status = '対応中',
            Account__c = account2.id,
            Origin = '電話' ,//受付方法
            AcceptDate__c = Date.valueOf('2022-08-17')
        );
        caseList.add(case2);

        Case case3 = new Case(
            Status = '対応中',
            Account__c = account2.id,
            Origin = '電話',//受付方法
            CompletedReportDate__c = Date.valueOf('2022-08-17')
        );
        caseList.add(case3);
        insert caseList;
        return caseList;

    }
}