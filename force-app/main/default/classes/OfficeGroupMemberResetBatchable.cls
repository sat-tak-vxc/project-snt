/**
 * @description 出社グループメンバーリセットバッチ処理
 * 
 * @author hi-takada
 * @date 2022/03/01
 */
public with sharing class OfficeGroupMemberResetBatchable 
	implements Database.Batchable<GroupMember> , Database.Stateful{

	public Iterable<GroupMember> start(Database.BatchableContext jobId) {
		// カスタム設定
        RemoteAccessSetting__c remoteAccessSetting = 
            RemoteAccessSetting__c.getOrgDefaults();

		// 出社グループメンバーを実行処理に渡す
		return [
			SELECT 
				Id 
			FROM GroupMember 
			WHERE GroupId = :remoteAccessSetting.OfficeGroupId__c
			];

	}

	public void execute(Database.BatchableContext jobId, List<GroupMember> paramList) {

		// グループメンバー削除実行
		RemoteAccessAuthorityControlModel.deleteGroupMember(paramList);
	}


	public void finish(Database.BatchableContext jobId) {

		// カスタム設定
        RemoteAccessSetting__c remoteAccessSetting = 
            RemoteAccessSetting__c.getOrgDefaults();

		AsyncApexJob JobResult = [
			SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
				TotalJobItems, CreatedBy.Email
			FROM AsyncApexJob 
			WHERE Id = :jobId.getJobId()];

		if(0 < JobResult.NumberOfErrors){
			// 削除処理に失敗している場合、システム管理者へ通知を行う
			RemoteAccessAuthorityControlUtils.sendErrorEmail(remoteAccessSetting);
		}

	}

}