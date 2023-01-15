/**
 * @description 自動で斡旋依頼業者を選定するクラス
 * @author tak-sato
 * @since 2022-11-02
 */
public with sharing class RequestTraderAutoTraderSelection{
    public NewMatter__c newMatter { get; set; }  // 新規
    public Application__c application { get; set; } // 申請
    public DesiredCondition__c desiredCondition { get; set; } //希望条件
    public Account account { get; set; } // 取引先
    public CorporateHousingRegulation__c corporateHousingRegulation { get; set; }//社宅規定
    public Contact contact { get; set; } // 取引先担当者

    public Set<SpecifyAgency__c> specifyAgencys { get; set; } //指定不動産会社

    public Map<Id,MediationPossibleArea__c> mediationPossibleAreas { get; set; } //紹介可能エリア

    public List<AgencyCapacity__c> agencyCapacitys { get; set; } //不動産キャパ    
    
    public Set<Id> mediationCompanyIds { get; } //斡旋依頼業者ID

    public Boolean isSelectionFinish(){ // 選定済みフラグ
        if(mediationCompanyIds.size() >= corporateHousingRegulation.SelectionCount__c){
            return true ;
        }else{
            return false ;
        }
    } 

    /**
     * @description 取引先（不動産会社）のIDを格納する
     */
    public void addAccountIdList(Id accountId){
        this.mediationCompanyIds.add(accountId);
    }

    /**
     * @description 指定不動産会社を選定業者に追加
     * 
     * @param tsmrs 斡旋依頼登録情報
     * @param states 都道府県リスト
     * @return `void`
     */
    public void setSelectionSpecifyAgencyAccount() {
        
        // 指定不動産会社の取引先（不動産会社）IDを斡旋依頼登録情報に格納
        // (地区情報が等しい値の場合処理)
        for (SpecifyAgency__c specifyAgency : this.specifyAgencys) {
            Id accountId = specifyAgency.RealEstateAgency__c;
            
            addAccountIdList(accountId);
        }
    }

    /**
     * @description 希望エリアに紐づく不動産キャパの取引先（不動産会社）情報を取得し
     *  tsmrs（斡旋依頼登録情報）へ格納する
     * 
     * @param tsmrs 斡旋依頼登録情報
     * @return `List<TraderSelectionMediationRequest>`
     */
    public void setSelectionMediationPossibleAreaAccount() {

        //選定が終了していた場合、処理を実行しない
        if(isSelectionFinish()){
            return;    
        }
        
        // 不動産キャパ情報クラスのリストを定義
        List<agencyCapacityWrap> agencyCapacityWrapList = new List<agencyCapacityWrap>();

        // 紹介可能エリアと不動産キャパの取引先IDで一致するデータをまとめる
        for (AgencyCapacity__c agencyCapacity : this.agencyCapacitys){

            // 取引先IDが同じ紹介可能エリアを取得
            agencyCapacityWrap agencyCapacityWrap = new agencyCapacityWrap();
            agencyCapacityWrap.agencyCapacity = agencyCapacity;
            agencyCapacityWrap.reserveNum = Integer.valueOf(agencyCapacity.ReserveNum__c);
            agencyCapacityWrap.mediationPossibleArea = this.mediationPossibleAreas.get(agencyCapacity.Account__c);
            agencyCapacityWrapList.add(agencyCapacityWrap);
        }
            

        for (agencyCapacityWrap agencyCapacityWrap : agencyCapacityWrapList){
            // 余力0件の場合、処理なし
            if(agencyCapacityWrap.isReserveFinish){
                continue;
            }

            Id accountId = agencyCapacityWrap.agencyCapacity.Account__c;
            // 希望エリア
            String desiredState = this.application.DesiredAreaState__c;
            String desiredCity = this.application.DesiredAreaCity__c;

            // 対象エリア
            String targetState = agencyCapacityWrap.mediationPossibleArea.State__c ;
            String targetCity = agencyCapacityWrap.mediationPossibleArea.City__c ;
            Boolean isAllCity = 
                agencyCapacityWrap.mediationPossibleArea.IsAllCity__c;

            if(String.isBlank(desiredCity)){
                if(desiredState == targetState){
                    /** 希望エリア_市町村が存在しない場合、
                     *  都道府県のみで比較
                     */
                    if(agencyCapacityWrap.isReserveFinishCheck()){
                        break;
                    }

                    if(isSelectionFinish()){
                        addAccountIdList(accountId);
                    }
                    
                }

            } else {
                if((isAllCity && (desiredState == targetState)) ||
                    (desiredState == targetState) && (desiredCity == targetCity)){
                    /** 希望エリア_市町村が存在する場合、
                     *  都道府県と市町村で比較
                     *  （都道府県全域についても選定に含む）
                     */
                    addAccountIdList(accountId);
                    agencyCapacityWrap.isReserveFinishCheck();
                    if(isSelectionFinish()){
                        break;
                    }
                }
            }        

        }  
    }
    


}