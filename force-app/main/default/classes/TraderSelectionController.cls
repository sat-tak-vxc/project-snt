public with sharing class TraderSelectionController {
    /**
     * @description 画面表示情報を取得する
     * @param accountId 取引先ID
     * @return `List<SObject>`
     */
    
    @AuraEnabled
    public static DataRelatedObject getMediationRequest(
        String newMatterId
    ){
        // 実行処理
        DataRelatedObject result = ManualTraderSelection.getMediationRequestProcess(newMatterId);
        return result;
    }

    /**
     * @description 引数を検索条件に市区郡を取得する
     * @param stateName 都道府県名
     * @return `List<SObject>`
     */
    @AuraEnabled
    public static List<SObject> getCity(
        String stateName
    ){
        
        // 市区郡を取得を実行
        return ManualTraderSelectionModel.getDistrictCitys(stateName);
    }

     /**
     * @description 検索ボタン押下処理
     * @param accountId 取引先ID
     * @param accountName 取引先名
     * @param state 都道府県
     * @param city 市区町村
     * @return `List<DataRelateDatatable>`
     * @exception 
     */
    @AuraEnabled
    public static List<DataRelateDatatable> search(
        String accountId,
        String accountName,
        String state,
        String city
    ){
        // 実行処理
        return ManualTraderSelection.searchProcess(accountId, accountName, state, city);
    }

    /**
     * @description 斡旋依頼ボタン押下処理
     * @param newMatterId // 新規ID
     * @param accountIds // 取引先IDリスト
     * @return `void`
     * @exception DmlException // レコード登録／更新エラー
     * @exception AuraHandledException // 引数不正
     */
    @AuraEnabled
    public static void upsertMediationRequest(
        String newMatterId,
        List<String> accountIds
    ){
        
        // 実行処理
        ManualTraderSelection.upsertMediationRequestProcess(newMatterId, accountIds);
    }

    /**
     * @description 斡旋依頼アクション実行処理
     * @param newMatterId // 新規ID
     * @param accountIds // 取引先IDリスト
     * @param accountId // 取引先ID
     * @param status // 選定結果
     * @return `void`
     * @exception 
     */
    @AuraEnabled
    public static void updateMediationStatus(
        String newMatterId,
        List<String> accountIds,
        String accountId,
        String status
    ){
        // 実行処理
        ManualTraderSelection.updateMediationStatusProcess(
            newMatterId, accountIds, accountId, status);
    }

    /**
     * @description 斡旋依頼削除処理
     * @param newMatterId // 新規ID
     * @param accountId // 取引先ID
     * @return `void`
     * @exception 
     */
    @AuraEnabled
    public static void deleteMediationRequest(
        String newMatterId,
        String accountId
    ){
        // 実行処理
        ManualTraderSelection.deleteMediationRequestProcess(newMatterId, accountId);
    }

     /**
     * @description 画面初期表示情報返却オブジェクト
     */
    public class DataRelatedObject{ 
        @AuraEnabled
        public Boolean isContractFinish { get; set; } // 斡旋完了判定
        @AuraEnabled
        public Boolean isRequesting { get; set; } // 依頼中判定
        @AuraEnabled
        public String selectionRuleTitle { get; set; } // 自動／手動
        @AuraEnabled
        public Integer mediationRequestTotalCount { get; set; } // 選定数
        @AuraEnabled
        public List<DataRelateDatatable> dataRelateDatatable { get; set; } // データテーブル情報
        @AuraEnabled
        public List<District__c> districts { get; set; } // 地区情報
        @AuraEnabled
        public String desiredAgencyValue { get; set; } // 希望不動産会社
        @AuraEnabled
        public String bodyPreview { get; set; } // 選定ルール
        @AuraEnabled
        public Boolean isSelectionRule { get; set; } // 指定業者選定ルール表示判定
        @AuraEnabled
        public Boolean isMediationRequest { get; set; }

        public Boolean mediationRequestDisabled(){//斡旋依頼ボタン活性/非活性 
            boolean result = this.mediationRequestTotalCount <= this.dataRelateDatatable.size();
            return result;
        }

        
        public DataRelatedObject() {
            this.dataRelateDatatable = new List<DataRelateDatatable>();
            this.districts = new List<District__c>();
            this.isContractFinish = false;
            this.isRequesting = false;
            this.isSelectionRule = false;
            this.isMediationRequest = false;
            this.mediationRequestTotalCount = 0;
        }
        public boolean isSelectionCount(Integer selectionCount){
            boolean result = 
                this.mediationRequestTotalCount <= selectionCount;
            return result;
        }
    }

    /**
     * @description 画面データテーブル表示用オブジェクト
     */
    public class DataRelateDatatable{
        @AuraEnabled
        public String id  { get; set; } // 行id
        @AuraEnabled
        public String IsTokutokuServiceText { get; set; } // 得々サービス有無
        @AuraEnabled
        public String BasicRankText { get; set; } // 優先度
        @AuraEnabled
        public String IdText { get; set; } // ID
        @AuraEnabled
        public String ParticipatingStoreText { get; set; } // 加盟店区分
        @AuraEnabled
        public String ContractCategoryText { get; set; } // ステータス
        @AuraEnabled
        public String MediationInputDateText { get; set; } // 依頼日
        @AuraEnabled
        public String actionLabel { get; set; } // ボタンラベル
        @AuraEnabled
        public Boolean actionDisabled { get; set; } // ボタン活性／非活性
        @AuraEnabled
        public Boolean isActionContentActive { get; set; } // アクション表示／非表示
        @AuraEnabled
        public List<Map<String,String>> actionContents { get; set; } // アクション情報
        @AuraEnabled
        public String name { get; set; } // 取引先名
        @AuraEnabled
        public String linkName { get; set; } // 取引先名リンク
        @AuraEnabled
        public Integer CapacityNumInt { get; set; } // キャパ件数
        @AuraEnabled
        public Integer ReserveNumInt { get; set; }  // 余力
        @AuraEnabled
        public Integer RequestingNumInt { get; set; }  // 依頼中件数
        @AuraEnabled
        public Integer RequestingFmNumInt { get; set; } // 依頼中(基幹)件数
        @AuraEnabled
        public Integer RequestingNewCommodityInt { get; set; } // 新商材件数
        @AuraEnabled
        public Boolean isTokutokuService { get; set; } // 得々サービス有無判定

        public DataRelateDatatable() {
            this.actionLabel = null;
            this.actionDisabled = false;
            this.actionContents = new List<Map<String,String>>();
            this.isActionContentActive = false;
            this.CapacityNumInt = 0;
            this.ReserveNumInt = 0;
            this.RequestingFmNumInt = 0;
            this.RequestingNumInt = 0;
            this.RequestingNewCommodityInt = 0;
            this.isTokutokuService = false;
        }
    }    

    
}