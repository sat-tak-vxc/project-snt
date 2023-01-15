/**
 * @description 出社グループメンバーリセットスケジュール
 * 
 * @author hi-takada
 * @date 2022/03/01
 */
global class OfficeGroupMemberResetSchedulable implements Schedulable {
	
	global void execute(SchedulableContext ctx) {
        // カスタム設定
        RemoteAccessSetting__c remoteAccessSetting = 
            RemoteAccessSetting__c.getOrgDefaults();

		// バッチサイズ
		Integer	batchSize = 
			Integer.valueOf(
				remoteAccessSetting.OfficeGroupMemberResetBatchSize__c);
		OfficeGroupMemberResetBatchable batchable = 
			new OfficeGroupMemberResetBatchable();
        Database.executeBatch(batchable, batchSize);
	}
  }