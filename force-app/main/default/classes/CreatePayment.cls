/**
 * @description        : 支払作成バッチ
 * @author             : h-nakata
**/
public class CreatePayment extends AbstractBaseBatch {
    /**
    * @description 初期処理 対象データ抽出　
    * @author h-nakata
    * @param Database.BatchableContext BC 
    * @return Iterable 
    **/
    public override Iterable<SObject> start(Database.BatchableContext BC) {
        String today = String.valueOf(Date.today());
        String thisMonthText = String.valueOf(Date.today().month());
        //処理対象の家賃明細レコード取得
        String query = 'SELECT Rent__c, ';
        query += 'Rent__r.RealEstateName__r.Account__c, ';
        query += 'Rent__r.RealEstateName__c, ';
        query += 'BankAccount__c, ';
        query += 'ExpenseItem__c, ';
        query += 'ExpenseItem__r.Name, ';
        query += 'ExpenseItem__r.IsPaymentTarget__c, ';
        query += 'HandlingType__c, ';
        query += 'Amount__c, ';
        query += 'CostCategory__c, ';
        query += 'SeasonVariableCostOccurrenceMonth__c ';
        query += 'FROM RentDetail__c ';
        query += 'WHERE Rent__r.PaymentStartDate__c <= ';
        query += today;
        query += ' AND Rent__r.PaymentEndDate__c >=';
        query += today;
        query += ' AND (CostCategory__c != \'季節変動費\' OR (CostCategory__c = \'季節変動費\' AND SeasonVariableCostOccurrenceMonth__c INCLUDES (\'';
        query += thisMonthText;
        query += '\')))';
        //クエリロケーターを利用し、最大5000万件までレコード参照可能とする
        System.debug('---CreatePayment---');
        System.debug('start query: ' + query);
        return Database.getQueryLocator(query);
    }
    /**
    * @description 処理実行
    * @author h-nakata
    * @param Database.BatchableContext BC 
    * @param List<SObject> records 
    * @return void 
    **/
    public override void execute(Database.BatchableContext BC, List<SObject> records) {        
        Integer thisYear = Date.today().year();
        Integer thisMonth = Date.today().month();
        //しゃたくさん設定取得
        SyatakusanSetting__c syatakusanSetting = SyatakusanSetting__c.getOrgDefaults();
        //毎月支払用FBデータ作成対象の支払区分を取得
        String paymentCategoryCreateMonthlyPaymentFbData = syatakusanSetting.PaymentCategoryNotCreateSpotFbData__c;
        //伝票種別取得
        List<SlipType__c> slipTypes = 
            [SELECT Id, Name
            FROM SlipType__c
            WHERE PaymentCategory__c = :paymentCategoryCreateMonthlyPaymentFbData];
        //工程管理から今月の家賃送金日を取得し取引先IDをキーとしたマップに格納
        List<ProcessControl__c> processControls = 
            [SELECT Account__c, RentRemittanceDate__c
            FROM ProcessControl__c
            WHERE CALENDAR_YEAR(RentRemittanceDate__c) = :thisYear
            AND CALENDAR_MONTH(RentRemittanceDate__c) = :thisMonth];
        Map<String, Date> accountIds = new Map<String, Date>();
        for(ProcessControl__c processControl : processControls){
            accountIds.put(processControl.Account__c, processControl.RentRemittanceDate__c);
        }

        //家賃ID+送金先口座Idをkeyとし、家賃明細をvalueとするマップを作成
        Map<String, RentDetail__c> uniqueIds = new Map<String, RentDetail__c>();
        List<Payment__c> payments = new List<Payment__c>();
        for (SObject record : records) {
            RentDetail__c rentDetail = (RentDetail__c)record;
            String accountId = rentDetail.Rent__r.RealEstateName__r.Account__c;
            Date rentRemittanceDate = accountIds.get(accountId);
            
            String uniqueId = String.valueOf(rentDetail.Rent__c) + String.valueOf(rentDetail.BankAccount__c);
            if(!uniqueIds.containsKey(uniqueId)){
                //支払編集
                Payment__c payment = new Payment__c(
                    //取引先
                    Account__c = rentDetail.Rent__r.RealEstateName__r.Account__c,
                    //物件
                    RealEstate__c = rentDetail.Rent__r.RealEstateName__c,
                    //家賃
                    RentId__c = rentDetail.Rent__c,
                    //口座
                    BankAccount__c = rentDetail.BankAccount__c,
                    //送金日
                    RemittanceDate__c = rentRemittanceDate,
                    //経理伝票種別
                    AccountingTicketType__c = slipTypes[0].Id
                );
                payments.add(payment);
                uniqueIds.put(uniqueId, rentDetail);
            }
        }
        //支払Insert
        Insert payments;

        //家賃ID+送金先口座Idをkeyとし、支払Idをvalueとするマップを作成
        Map<String, String> uniqueIdPayments = new Map<String, String>();
        for(Payment__c payment : payments){
            uniqueIdPayments.put(String.valueOf(payment.RentId__c) + String.valueOf(payment.BankAccount__c), payment.Id);
        }
        //支払対象の取扱種別を取得
        String paymentTargetHandlingType = syatakusanSetting.PaymentTargetHandlingType__c;
        List<PaymentDetail__c> paymentDetails = new List<PaymentDetail__c>();
        for (SObject record : records) {
            RentDetail__c rentDetail = (RentDetail__c)record;
            //支払対象編集(費目.支払対象がTRUEかつ取扱種別が振込の場合のみTRUEをセット)
            Boolean isPaymentTarget = FALSE;
            if(rentDetail.ExpenseItem__r.IsPaymentTarget__c && rentDetail.HandlingType__c == paymentTargetHandlingType){
                isPaymentTarget = TRUE;
            }
            //支払明細編集
            PaymentDetail__c paymentDetail = new PaymentDetail__c(
                //支払
                Payment__c = uniqueIdPayments.get(String.valueOf(rentDetail.Rent__c) + String.valueOf(rentDetail.BankAccount__c)),
                //金額
                Amount__c = rentDetail.Amount__c,
                //費目名
                ExpenseItem__c = rentDetail.ExpenseItem__c,
                //取扱種別
                HandlingType__c = rentDetail.HandlingType__c,
                //支払対象
                IsPaymentTarget__c = isPaymentTarget,
                //費用分類
                CostCategory__c = rentDetail.CostCategory__c,
                //明細名
                DetailName__c = rentDetail.ExpenseItem__r.Name
            );
            paymentDetails.add(paymentDetail);
        }
        //支払明細Insert
        Insert paymentDetails;
    }
    /**
    * @description 終了処理
    * @author h-nakata
    * @param Database.BatchableContext BC 
    * @return void 
    **/
    public override void finish(Database.BatchableContext BC) {}
}