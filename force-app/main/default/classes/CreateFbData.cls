/**
 * @description        : FBデータ作成
 * @author             : h-nakata
**/
public class CreateFbData {
    /**
    * @description FBデータ作成
    * @author h-nakata
    * @param List<SObject> records 支払レコードリスト
    * @param Date remittanceDate 送金日
    * @param List<String> upsertedFbDataIds 同バッチ内でupsert済みのFBデータのレコードIDリスト
    * @param Boolean isSpotFb スポットFBフラグ
    * @return List<String> upsertしたFBデータのレコードIDリスト
    **/
    public static List<String> CreateFbData(List<SObject> records, Date remittanceDate, List<String> upsertedFbDataIds, Boolean isSpotFb) {
        //同バッチ内でupsert済みのFBデータ取得
        List<FbData__c> upsertedFbDatas= 
            [SELECT TransferAmount__c,
            FbDataForeignKey__c
            FROM FbData__c 
            WHERE Id in :upsertedFbDataIds];
        //しゃたくさん設定取得
        SyatakusanSetting__c syatakusanSetting = SyatakusanSetting__c.getOrgDefaults();
        //スポットFBデータ作成対象外の支払区分を取得
        String paymentCategoryNotCreateSpotFbData = syatakusanSetting.PaymentCategoryNotCreateSpotFbData__c;
        //銀行コード取得
        String bankCodeMizuho = syatakusanSetting.BankCodeMizuho__c;
        String bankCodeMitsuisumitomo = syatakusanSetting.BankCodeMitsuisumitomo__c;
        //FBデータ作成対象で送金先みずほの支払件数取得
        Integer paymentCountMizuho = 
            [SELECT COUNT() 
            FROM Payment__c 
            WHERE RemittanceDate__c = :remittanceDate AND FBDataName__c = NULL AND AccountingTicketType__r.PaymentCategory__c != :paymentCategoryNotCreateSpotFbData
            AND BankAccount__r.BankCode__c = :bankCodeMizuho];
        //FBデータ作成対象で送金先三井住友の支払件数取得
        Integer paymentCountMitsuisumitomo = 
            [SELECT COUNT() 
            FROM Payment__c 
            WHERE RemittanceDate__c = :remittanceDate AND FBDataName__c = NULL AND AccountingTicketType__r.PaymentCategory__c != :paymentCategoryNotCreateSpotFbData 
            AND BankAccount__r.BankCode__c = :bankCodeMitsuisumitomo];
        //SNT口座取得(key:口座ID value:口座obj)
        Map<Id, BankAccount__c> sntBankAccouts = new Map<Id, BankAccount__c>([SELECT Id, ContractorKana__c, BankCode__c, BankKana__c, BranchOfficeCode__c, BranchOfficeKana__c, DepositTypeForFbData__c, Name FROM BankAccount__c WHERE IsOwnedBankAccount__c = True]);
        //送金元口座取得
        TransfererBankAccount__mdt[] transfererBankAccounts = [SELECT BankAccountId__c, PaymentCategory__c, BankCode__c FROM TransfererBankAccount__mdt];
        //マップに格納(key:支払区分+銀行コード value:口座ID)
        Map<String, String> bankAccountPatterns = new Map<String, String>();
        for(TransfererBankAccount__mdt transfererBankAccount : transfererBankAccounts){
            bankAccountPatterns.put(transfererBankAccount.PaymentCategory__c + transfererBankAccount.BankCode__c, transfererBankAccount.BankAccountId__c);
        }
        //振込手数料取得
        Integer transferFee = Integer.valueOf(syatakusanSetting.TransferFee__c);
        //FBデータ作成パターン毎の支払区分+銀行コード
        String paymentCategoryBankCodeDepositSettlement = syatakusanSetting.PaymentCategoryDepositSettlement__c + syatakusanSetting.BankCodeMitsubishiUFJ__c;
        String paymentCategoryBankCodeLeaveSettlement = syatakusanSetting.PaymentCategoryLeaveSettlement__c + syatakusanSetting.BankCodeMitsubishiUFJ__c;
        String paymentCategoryBankCodeMizuho = syatakusanSetting.PaymentCategoryOther__c + bankCodeMizuho;
        String paymentCategoryBankCodeMitsuisumitomo = syatakusanSetting.PaymentCategoryOther__c + bankCodeMitsuisumitomo;
        String paymentCategoryBankCodeOther = syatakusanSetting.PaymentCategoryOther__c + syatakusanSetting.BankCodeMitsubishiUFJ__c;

        //送金日・口座ID・支払区分・送金元口座名義を結合した一意のIdをKeyとし、"FBデータがKeyで支払がValueとなるマップ"をValueとするマップを作成
        Map<String, Map<FbData__c, List<Payment__c>>> uniqueIds = new Map<String, Map<FbData__c, List<Payment__c>>>();
        //取得したFBデータをマップに格納
        for(FbData__c fbData : upsertedFbDatas){
            List<Payment__c> payments = new List<Payment__c>();
            Map<FbData__c, List<Payment__c>> fbDatas = new Map<FbData__c, List<Payment__c>>();
            fbDatas.put(fbData, payments);
            uniqueIds.put(fbData.FbDataForeignKey__c, fbDatas);
        }
        for (SObject record : records) {
            Payment__c payment = (Payment__c)record;
            String uniqueId = String.valueOf(payment.RemittanceDate__c) + payment.BankAccount__c + payment.AccountingTicketType__r.PaymentCategory__c + payment.TransfererAccountContractor__c;
            if(!uniqueIds.containsKey(uniqueId)){
                //委託者名,仕向金融機関番号,仕向金融機関名,仕向支店番号,仕向支店名,預金種目（依頼人）,口座番号（依頼人）編集
                String consignorName;
                String remittingBankCode;
                String remittingBankName;
                String remittingBranchOfficeCode;
                String remittingBranchOfficeName;
                String remitterDepositType;
                String remitterBankAccountNum;
                If(isSpotFb){
                    //スポットFBデータの場合
                    If(payment.AccountingTicketType__r.PaymentCategory__c == syatakusanSetting.PaymentCategoryDepositSettlement__c){
                        //伝票種別.支払区分=敷金精算の場合、敷金精算用の送金元口座情報をセット
                        consignorName = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeDepositSettlement)).ContractorKana__c;
                        remittingBankCode = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeDepositSettlement)).BankCode__c;
                        remittingBankName = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeDepositSettlement)).BankKana__c;
                        remittingBranchOfficeCode = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeDepositSettlement)).BranchOfficeCode__c;
                        remittingBranchOfficeName = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeDepositSettlement)).BranchOfficeKana__c;
                        remitterDepositType = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeDepositSettlement)).DepositTypeForFbData__c;
                        remitterBankAccountNum = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeDepositSettlement)).Name;
                    } else if (payment.AccountingTicketType__r.PaymentCategory__c == syatakusanSetting.PaymentCategoryLeaveSettlement__c){
                        //伝票種別.支払区分=退去精算の場合、退去精算用の送金元口座情報をセット
                        consignorName = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeLeaveSettlement)).ContractorKana__c;
                        remittingBankCode = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeLeaveSettlement)).BankCode__c;
                        remittingBankName = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeLeaveSettlement)).BankKana__c;
                        remittingBranchOfficeCode = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeLeaveSettlement)).BranchOfficeCode__c;
                        remittingBranchOfficeName = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeLeaveSettlement)).BranchOfficeKana__c;
                        remitterDepositType = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeLeaveSettlement)).DepositTypeForFbData__c;
                        remitterBankAccountNum = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeLeaveSettlement)).Name;
                    } else if (payment.BankAccount__r.BankCode__c == bankCodeMizuho && paymentCountMizuho >= 10){
                        //送金先みずほ、かつ送金先みずほの支払件数が10件以上の場合、みずほの送金元口座情報をセット
                        consignorName = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeMizuho)).ContractorKana__c;
                        remittingBankCode = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeMizuho)).BankCode__c;
                        remittingBankName = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeMizuho)).BankKana__c;
                        remittingBranchOfficeCode = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeMizuho)).BranchOfficeCode__c;
                        remittingBranchOfficeName = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeMizuho)).BranchOfficeKana__c;
                        remitterDepositType = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeMizuho)).DepositTypeForFbData__c;
                        remitterBankAccountNum = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeMizuho)).Name;
                    } else if (payment.BankAccount__r.BankCode__c == bankCodeMitsuisumitomo && paymentCountMitsuisumitomo >= 10){
                        //送金先三井住友、かつ送金先三井住友の支払件数が10件以上、三井住友の送金元口座情報をセット
                        consignorName = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeMitsuisumitomo)).ContractorKana__c;
                        remittingBankCode = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeMitsuisumitomo)).BankCode__c;
                        remittingBankName = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeMitsuisumitomo)).BankKana__c;
                        remittingBranchOfficeCode = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeMitsuisumitomo)).BranchOfficeCode__c;
                        remittingBranchOfficeName = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeMitsuisumitomo)).BranchOfficeKana__c;
                        remitterDepositType = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeMitsuisumitomo)).DepositTypeForFbData__c;
                        remitterBankAccountNum = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeMitsuisumitomo)).Name;
                    } else {
                        //三菱UFJの送金元口座情報をセット
                        consignorName = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeOther)).ContractorKana__c;
                        remittingBankCode = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeOther)).BankCode__c;
                        remittingBankName = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeOther)).BankKana__c;
                        remittingBranchOfficeCode = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeOther)).BranchOfficeCode__c;
                        remittingBranchOfficeName = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeOther)).BranchOfficeKana__c;
                        remitterDepositType = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeOther)).DepositTypeForFbData__c;
                        remitterBankAccountNum = sntBankAccouts.get(bankAccountPatterns.get(paymentCategoryBankCodeOther)).Name;
                    }
                } else {
                    //毎月支払用FBデータの場合
                    consignorName = payment.RentId__r.RealEstateName__r.Account__r.TransfererAccount__r.ContractorKana__c;
                    remittingBankCode = payment.RentId__r.RealEstateName__r.Account__r.TransfererAccount__r.BankCode__c;
                    remittingBankName = payment.RentId__r.RealEstateName__r.Account__r.TransfererAccount__r.BankKana__c;
                    remittingBranchOfficeCode = payment.RentId__r.RealEstateName__r.Account__r.TransfererAccount__r.BranchOfficeCode__c;
                    remittingBranchOfficeName = payment.RentId__r.RealEstateName__r.Account__r.TransfererAccount__r.BranchOfficeKana__c;
                    remitterDepositType = payment.RentId__r.RealEstateName__r.Account__r.TransfererAccount__r.DepositTypeForFbData__c;
                    remitterBankAccountNum = payment.RentId__r.RealEstateName__r.Account__r.TransfererAccount__r.Name;
                }
                //送金元口座名義を委託者名にセット
                If(payment.TransfererAccountContractor__c != NULL){
                    consignorName = payment.TransfererAccountContractor__c;
                }
                //振込手数料差し引き
                Integer transferAmount;
                Boolean isTransferFeeSubtracted = FALSE; 
                If(isSpotFb && payment.IsTransferFeeSubtract__c){
                    transferAmount = Integer.valueOf(payment.TotalAmount_PaymentTarget__c) - transferFee;
                    isTransferFeeSubtracted = TRUE;
                } else {
                    transferAmount = Integer.valueOf(payment.TotalAmount_PaymentTarget__c);
                }
                //FBデータ編集
                FbData__c fbData = new FbData__c(
                    //種別コード
                    TypeCode__c = '21',
                    //コード区分
                    CodeCategory__c = '0',
                    //委託者名
                    ConsignorName__c = consignorName,
                    //取組日
                    RemittanceDate__c = String.valueOf(payment.RemittanceDate__c).substring(5,7) + String.valueOf(payment.RemittanceDate__c).substring(8,10),
                    //仕向金融機関番号
                    RemittingBankCode__c = remittingBankCode,
                    //仕向金融機関名
                    RemittingBankName__c = remittingBankName,
                    //仕向支店番号
                    RemittingBranchOfficeCode__c = remittingBranchOfficeCode,
                    //仕向支店名
                    RemittingBranchOfficeName__c = remittingBranchOfficeName,
                    //預金種目（依頼人）
                    RemitterDepositType__c = remitterDepositType,
                    //口座番号（依頼人）
                    RemitterBankAccountNum__c = remitterBankAccountNum,
                    //被仕向金融機関番号
                    BankCode__c = payment.BankAccount__r.BankCode__c,
                    //被仕向金融機関名
                    BankName__c = payment.BankAccount__r.BankKana__c,
                    //被仕向支店番号
                    BranchOfficeCode__c = payment.BankAccount__r.BranchOfficeCode__c,
                    //被仕向支店名
                    BranchOfficeName__c = payment.BankAccount__r.BranchOfficeKana__c,
                    //預金種目
                    DepositType__c = payment.BankAccount__r.DepositTypeForFbData__c,
                    //口座番号
                    BankAccountNum__c = payment.BankAccount__r.Name,
                    //受取人名
                    RecipientName__c = payment.BankAccount__r.ContractorKana__c,
                    //振込金額
                    TransferAmount__c = String.valueOf(transferAmount),
                    //新規コード
                    NewCode__c = '0',
                    //顧客コード1
                    CustomerCode1__c = payment.BankAccount__r.CustomerCode1__c,
                    //顧客コード2
                    CustomerCode2__c = payment.BankAccount__r.CustomerCode2__c,
                    //振込区分
                    TransferType__c = '7',
                    //振手差引済みフラグ
                    IsTransferFeeSubtracted__c = isTransferFeeSubtracted,
                    //支払区分
                    PaymentCategory__c = payment.AccountingTicketType__r.PaymentCategory__c,
                    //FBデータ外部キー
                    FbDataForeignKey__c = uniqueId
                );
                Map<FbData__c, List<Payment__c>> fbDatas = new Map<FbData__c, List<Payment__c>>();
                List<Payment__c> payments = new List<Payment__c>();
                payments.add(payment);
                fbDatas.put(fbData, payments);
                uniqueIds.put(uniqueId, fbDatas);
            } else {
                Map<FbData__c, List<Payment__c>> oldFbDatas = uniqueIds.get(uniqueId);
                FbData__c oldFbData;
                for (FbData__c fb : oldFbDatas.keySet()){
                    oldFbData = fb;
                }
                List<Payment__c> payments = AddPaymentToList(oldFbDatas, oldFbData, payment);
                //振込金額加算
                oldFbData.TransferAmount__c = String.valueOf(Integer.valueOf(oldFbData.TransferAmount__c) + Integer.valueOf(payment.TotalAmount_PaymentTarget__c));
                //振込手数料差し引き
                If(isSpotFb && !oldFbData.IsTransferFeeSubtracted__c && payment.IsTransferFeeSubtract__c){
                    oldFbData.TransferAmount__c = String.valueOf(Integer.valueOf(oldFbData.TransferAmount__c) - transferFee);
                    oldFbData.IsTransferFeeSubtracted__c = TRUE;
                }
                Map<FbData__c, List<Payment__c>> newFbDatas = new Map<FbData__c, List<Payment__c>>();
                newFbDatas.put(oldFbData, payments);
                uniqueIds.put(uniqueId, newFbDatas);
            }
        }
        //UpsertするFBデータのリスト作成
        List<FbData__c> upsertFbDatas = new List<FbData__c>();
        List<Map<FbData__c, List<Payment__c>>> fbDataMaps = uniqueIds.values();
        for(Map<FbData__c, List<Payment__c>> fbDataMap : fbDataMaps){
            for(FbData__c upsertFbdata : fbDataMap.keySet()){
                upsertFbDatas.add(upsertFbdata);
            }
        }
        //結合キーと支払リストのマップを保持(key:送金日+口座ID+支払区分+送金元口座名義 value:支払リスト)
        Map<String,List<Payment__c>> uniqueIdPayments = new Map<String,List<Payment__c>>();
        for(String uniqueId : uniqueIds.keySet()){
            for(List<Payment__c> payments : uniqueIds.get(uniqueId).values()){
                uniqueIdPayments.put(uniqueId, payments);
            }
        }
        //FBデータUpsert
        Upsert upsertFbDatas FbDataForeignKey__c;

        //UpsertしたFBデータのIDをリストに格納
        List<String> fbDataIds = new List<String>();
        for(FbData__c fbData : upsertFbDatas){
            fbDataIds.add(fbData.ID);
        }
        //結合キーとFBデータのマップを保持(key:送金日+口座ID+支払区分+送金元口座名義 value:FBデータ)
        Map<String,FbData__c> uniqueIdFbDatas = new Map<String,FbData__c>();
        for(String uniqueId : uniqueIds.keySet()){
            for(FbData__c fbData : uniqueIds.get(uniqueId).keySet()){
                uniqueIdFbDatas.put(uniqueId, fbData);
            }
        }
        //送金日・口座ID・支払区分・送金元口座名義を結合した一意のIdをKeyとし、"FBデータがKeyで支払がValueとなるマップ"をValueとするマップを再作成
        Map<String, Map<FbData__c, List<Payment__c>>> newUniqueIds = new Map<String, Map<FbData__c, List<Payment__c>>>();
        for(String uniqueId : uniqueIdFbDatas.keySet()){
            Map<FbData__c, List<Payment__c>> newFbDatas = new Map<FbData__c, List<Payment__c>>();
            newFbDatas.put(uniqueIdFbDatas.get(uniqueId), uniqueIdPayments.get(uniqueId));
            newUniqueIds.put(uniqueId, newFbDatas);
        }
        //更新する支払リスト作成
        List<Payment__c> updatePayments = new List<Payment__c>();
        for(String uniqueId : newUniqueIds.keySet()){
            for(FbData__c fb : newUniqueIds.get(uniqueId).keySet()){
                for(Payment__c updatePayment : newUniqueIds.get(uniqueId).get(fb)){
                    //FBデータ名
                    updatePayment.FBDataName__c = fb.Id;
                    //FBデータ作成日
                    updatePayment.FBDataCreatedDate__c = Date.today();
                    updatePayments.add(updatePayment);
                }
            }
        }
        //支払Update
        Update updatePayments;

        return fbDataIds;
    }
    /**
    * @description マップにてキーのFBデータに対応する支払リストに支払を追加し、支払リストを返却
    * @author h-nakata
    * @param Map<FbData__c, List<Payment__c>> FbDatas
    * @param FbData__c fbData
    * @param Payment__c payment
    * @return List<Payment__c>
    **/
    public static List<Payment__c> AddPaymentToList(Map<FbData__c, List<Payment__c>> FbDatas, FbData__c fbData, Payment__c payment) {
        List<Payment__c> payments = FbDatas.get(fbData);
        if (payments == NULL) {
            payments = new List<Payment__c>();
        }
        payments.add(payment);
        return payments;
    }
}