/**
 * @description        : 支払再作成
 * @author             : h-nakata
**/
public class RecreatePayment {
    /**
    * @description 支払再作成
    * @author h-nakata
    * @param String realEstateId 物件ID
    * @param String executionUserId フロー実行ユーザID
    * @return void
    **/
    @future
    public static void RecreatePayment(String realEstateId, String executionUserId) {
        Integer thisYear = Date.today().year();
        Integer thisMonth = Date.today().month();
        //削除対象の支払取得
        List<Payment__c> deletePayments = 
            [SELECT Id
            FROM Payment__c 
            WHERE RealEstate__c = :realEstateId
            AND CALENDAR_YEAR(RemittanceDate__c) = :thisYear
            AND CALENDAR_MONTH(RemittanceDate__c) = :thisMonth];
        List<String> paymentIds = new List<String>();
        for(Payment__c payment : deletePayments){
            paymentIds.add(payment.Id);
        }
        //削除対象で費用分類が月次変動費の支払明細取得
        List<PaymentDetail__c> deletePaymentDetails = 
            [SELECT ExpenseItem__c, Amount__c
            FROM PaymentDetail__c 
            WHERE Payment__c IN :paymentIds
            AND CostCategory__c = '月次変動費'];
        //費目Idをkeyとし、支払明細の金額をvalueとするマップを作成
        Map<Id, Decimal> expenseItemIds = new Map<Id, Decimal>();
        //削除対象で費用分類が月次変動費の支払明細の金額をマップに保存
        for(PaymentDetail__c paymentDetail : deletePaymentDetails){
            expenseItemIds.put(paymentDetail.ExpenseItem__c, paymentDetail.Amount__c);
        }
        //支払&支払明細削除
        Delete deletePayments;

        //物件に紐づく支払開始年月≦今日≦支払終了年月の家賃取得
        Date today = Date.today();
        String thisMonthText = String.valueOf(thisMonth);
        List<Rent__c> rents = 
            [SELECT Id, RealEstateName__r.Account__c
            FROM Rent__c
            WHERE RealEstateName__c = :realEstateId
            AND PaymentStartDate__c <= :today
            AND PaymentEndDate__c >= :today];
        String rentId = rents[0].Id;
        //家賃明細取得(季節変動費は今月が発生月の場合のみ取得)
        List<RentDetail__c> rentDetails = 
            [SELECT BankAccount__c,
            ExpenseItem__c,
            ExpenseItem__r.Name,
            ExpenseItem__r.IsPaymentTarget__c,
            HandlingType__c,
            Amount__c,
            Rent__c,
            CostCategory__c,
            SeasonVariableCostOccurrenceMonth__c
            FROM RentDetail__c 
            WHERE Rent__c = :rentId
            AND (CostCategory__c != '季節変動費' OR (CostCategory__c = '季節変動費' AND SeasonVariableCostOccurrenceMonth__c INCLUDES (:thisMonthText)))];
            String accountId = rents[0].RealEstateName__r.Account__c;
        //工程管理から今月の家賃送金日取得
        List<ProcessControl__c> processControls = 
            [SELECT RentRemittanceDate__c
            FROM ProcessControl__c
            WHERE Account__c = :accountId
            AND CALENDAR_YEAR(RentRemittanceDate__c) = :thisYear
            AND CALENDAR_MONTH(RentRemittanceDate__c) = :thisMonth];
        Date rentRemittanceDate;
        If(!processControls.isEmpty()){
            rentRemittanceDate = processControls[0].RentRemittanceDate__c;
        }
        //しゃたくさん設定取得
        SyatakusanSetting__c syatakusanSetting = SyatakusanSetting__c.getOrgDefaults();
        //毎月支払用FBデータ作成対象の支払区分を取得
        String paymentCategoryCreateMonthlyPaymentFbData = syatakusanSetting.PaymentCategoryNotCreateSpotFbData__c;
        //伝票種別取得
        List<SlipType__c> slipTypes = 
            [SELECT Id, Name
            FROM SlipType__c
            WHERE PaymentCategory__c = :paymentCategoryCreateMonthlyPaymentFbData];

        //送金先口座Idをkeyとし、家賃明細をvalueとするマップを作成
        Map<String, RentDetail__c> bankAccountIds = new Map<String, RentDetail__c>();
        List<Payment__c> payments = new List<Payment__c>();
        for(RentDetail__c rentDetail : rentDetails){
            String bankAccountId = rentDetail.BankAccount__c;
            if(!bankAccountIds.containsKey(bankAccountId)){
                //支払編集
                Payment__c payment = new Payment__c(
                    //取引先
                    Account__c = rents[0].RealEstateName__r.Account__c,
                    //物件
                    RealEstate__c = realEstateId,
                    //家賃
                    RentId__c = rentId,
                    //口座
                    BankAccount__c = bankAccountId,
                    //送金日
                    RemittanceDate__c = rentRemittanceDate,
                    //経理伝票種別
                    AccountingTicketType__c = slipTypes[0].Id
                );
                payments.add(payment);
                bankAccountIds.put(bankAccountId, rentDetail);
            }
        }
        //支払Insert
        Insert payments;

        //送金先口座IDをkeyとし、支払Idをvalueとするマップを作成
        Map<String, String> bankAccounts = new Map<String, String>();
        for(Payment__c payment : payments){
            bankAccounts.put(payment.BankAccount__c, payment.Id);
        }
        List<PaymentDetail__c> paymentDetails = new List<PaymentDetail__c>();
        for(RentDetail__c rentDetail : rentDetails){
            //金額編集(月次変動費の場合マップに保存した金額をセット)
            Decimal amount;
            if(expenseItemIds.containsKey(rentDetail.ExpenseItem__c)){
                amount = expenseItemIds.get(rentDetail.ExpenseItem__c);
            } else {
                amount = rentDetail.Amount__c;
            }
            //支払対象の取扱種別を取得
            String paymentTargetHandlingType = syatakusanSetting.PaymentTargetHandlingType__c;
            //支払対象編集(費目.支払対象がTRUEかつ取扱種別が振込の場合のみTRUEをセット)
            Boolean isPaymentTarget = FALSE;
            if(rentDetail.ExpenseItem__r.IsPaymentTarget__c && rentDetail.HandlingType__c == paymentTargetHandlingType){
                isPaymentTarget = TRUE;
            }
            //支払明細編集
            PaymentDetail__c paymentDetail = new PaymentDetail__c(
                //支払
                Payment__c = bankAccounts.get(rentDetail.BankAccount__c),
                //金額
                Amount__c = amount,
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

        //カスタム通知送信
        Set<String> executionUserIds = new Set<String>();
        executionUserIds.add(executionUserId);
        RecreatePaymentCustomNotification.notifyUsers(executionUserIds);
    }
}