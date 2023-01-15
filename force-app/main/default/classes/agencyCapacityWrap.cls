public with sharing class agencyCapacityWrap {
   // 不動産キャパ
   public AgencyCapacity__c agencyCapacity { get; set; } 
   // 紹介可能エリア
   public MediationPossibleArea__c mediationPossibleArea { get; set; }
   public Integer reserveNum { get; set; } // 残余力
   public Boolean isReserveFinish { get; set; } // 余力なし

   public agencyCapacityWrap(){
       this.agencyCapacity = new AgencyCapacity__c();
       this.mediationPossibleArea = new MediationPossibleArea__c();
       this.reserveNum = 0;
       this.isReserveFinish = false;
   }

   /**
    * @description 選定された場合余力をデクリメントする
    */
   public Boolean isReserveFinishCheck(){
       this.reserveNum --;

       if(this.reserveNum <= 0){
           return true;
       }
       return false;
   }
}