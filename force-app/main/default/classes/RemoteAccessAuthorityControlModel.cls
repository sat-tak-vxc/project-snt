/**
 * 在宅アクセス権限制御画面のモデルクラス
 */
public class RemoteAccessAuthorityControlModel {


	/**
     * セクション情報 取得
	 * @return  `List<Section__c>`
	 */
    public static List<Section__c> getSections(
		RemoteAccessSetting__c remoteAccessSetting) {
		Map<String, Group> groups = 
			getGroupsToName(remoteAccessSetting);

		Set<String> groupNames = groups.keySet();

		return [
			SELECT
				Id,
				QueueName__c,
				Name
			FROM Section__c
			WHERE QueueName__c IN:groupNames
			ORDER BY Name
		];
	}


	/**
     * セクション情報 取得（単数）
	 * @return  `Section__c`
	 */
    public static Section__c getSectionQueueName(String queueName) {
		return [
			SELECT 
				Id, Name
			FROM Section__c
			WHERE QueueName__c = :queueName
			];      
	}


	/**
     * セクション情報 取得
	 * @return  `Map<String, Section__c>`
	 */
    public static Map<String, Section__c> getSectionsToQueueName(
		Set<String> queueNames) {
		
		Map<String, Section__c> sections = new Map<String, Section__c>();
		for (Section__c section : 
			[SELECT
				Id,
				QueueName__c,
				Name
			FROM Section__c
			WHERE QueueName__c IN :queueNames
			]) 
		{
			if(String.isNotBlank(section.QueueName__c)){
				sections.put(section.QueueName__c, section);
			}
		}

		return sections;
	}

	/**
     * グループ情報 取得
	 * @return  `Group`
	 */
    public static Group getGroupQueue(
		RemoteAccessSetting__c remoteAccessSetting,
		String queueName) {
		
		return [
			SELECT 
				Id
			FROM Group
			WHERE Name = :queueName
			AND Type = :remoteAccessSetting.GroupTypeQueue__c
			];                  
	}


	/**
     * グループ情報 取得
	 * @return  `Map<Id, Group>`
	 */
    public static Map<Id, Group> getGroupsToId(
		RemoteAccessSetting__c remoteAccessSetting) {
		
		Map<Id, Group> groups = new Map<Id, Group>();
		for (Group getGroup : 
			[SELECT 
				Id, Name
			FROM Group
			WHERE Type = :remoteAccessSetting.GroupTypeQueue__c
			]) 
		{
			if(String.isNotBlank(getGroup.Id)){
				groups.put(getGroup.Id, getGroup);
			}
		}

		return groups;
	}

	/**
     * グループ情報 取得
	 * @return  `Map<String, Group>`
	 */
    public static Map<String, Group> getGroupsToName(
		RemoteAccessSetting__c remoteAccessSetting) {
		
		Map<String, Group> groups = new Map<String, Group>();
		for (Group getGroup : 
			[SELECT 
				Id, Name
			FROM Group
			WHERE Type = :remoteAccessSetting.GroupTypeQueue__c
			]) 
		{
			if(String.isNotBlank(getGroup.Id)){
				groups.put(getGroup.Name, getGroup);
			}
		}

		return groups;
	}


	/**
     * グループメンバー（出社グループ）情報 取得
	 * @return  `Map<Id, GroupMember>`
	 */
    public static Map<Id, GroupMember> getGroupMemberOffice(
		RemoteAccessSetting__c remoteAccessSetting) {

		Map<Id, GroupMember> groupMembers = new Map<Id, GroupMember>();
		for (GroupMember groupMember : 
			[SELECT 
				Id,
				GroupId,
				UserOrGroupId
			FROM GroupMember
			WHERE GroupId = :remoteAccessSetting.OfficeGroupId__c
			]) 
		{
			if(String.isNotBlank(groupMember.UserOrGroupId)){
				groupMembers.put(groupMember.UserOrGroupId, groupMember);
			}
		}

		return groupMembers;
	}


	/**
     * グループメンバー情報 取得
	 * @return  `List<GroupMember>`
	 */
    public static List<GroupMember> getGroupsMembers(String groupId) {
		
		return [
			SELECT 
				Id,
				UserOrGroupId
			FROM GroupMember
			WHERE GroupId = :groupId
			];               
	}


	/**
     * グループメンバー情報 取得
	 * @return  `GroupMember`
	 */
    public static List<GroupMember> getGroupMembersUserIds(Set<Id> userIds) {
		
		return [
			SELECT
				Id, GroupId, UserOrGroupId
			FROM GroupMember
			WHERE UserOrGroupId IN :userIds
			];              
	}


	/**
     * 画面表示情報 取得
	 * @return  `List<DatatableInfo>`
	 */
    public static List<DatatableInfo> getSectionNamesToUserId(
		RemoteAccessSetting__c remoteAccessSetting, List<User> users) {

		Set<Id> userIds = new Set<Id>();

		List<DatatableInfo> datatableInfos = new List<DatatableInfo>();
		DatatableInfo tempDatatableInfo;

		for (User user : users) {
			userIds.add(user.Id);

			tempDatatableInfo = new DatatableInfo();
			// ユーザ情報格納
			tempDatatableInfo.userInfo = user;

			datatableInfos.add(tempDatatableInfo);
		}

		// キュー全体取得
		Map<Id, Group> groups = getGroupsToId(remoteAccessSetting);
		// グループメンバ―取得取得
		List<GroupMember> groupMembers = getGroupMembersUserIds(userIds);

		Map<Id, GroupMember> groupMembersToId  = new Map<Id, GroupMember>();
		Set<Id> groupIds = new Set<Id>();

		for (GroupMember groupMember : groupMembers) {
			groupMembersToId.put(groupMember.UserOrGroupId, groupMember);
			groupIds.add(groupMember.GroupId);
		}

		Set<String> groupNames = new Set<String>();
		for (DatatableInfo datatableInfo : datatableInfos) {

			// ユーザIDに紐づくグループメンバーが存在する場合
			if(groupMembersToId.containsKey(datatableInfo.userInfo.Id)){
				// グループメンバーのグループIDに紐づくキューが存在する場合
				if(groups.containsKey(groupMembersToId.get(datatableInfo.userInfo.Id).GroupId)){
					// グループメンバー情報格納
					datatableInfo.groupMemberInfo = 
						groupMembersToId.get(datatableInfo.userInfo.Id);
					// キュー情報格納
					datatableInfo.groupInfo = 
						groups.get(groupMembersToId.get(datatableInfo.userInfo.Id).GroupId);
					groupNames.add(datatableInfo.groupInfo.Name);
				}
			}
		}

		Map<String, Section__c> sections = getSectionsToQueueName(groupNames);
		for (DatatableInfo datatableInfo : datatableInfos) {
			if(sections.containsKey(datatableInfo.groupInfo.Name)){
				// セクション情報格納
				datatableInfo.sectionInfo = sections.get(datatableInfo.groupInfo.Name);
			}
		}

		return datatableInfos;            
	}


	
	/**
     * 検索条件からユーザ情報 取得
	 * @return  `List<User>`
	 */
    public static List<User> getUsersToSearchConditions(
		RemoteAccessSetting__c remoteAccessSetting,
		String employeeNumber,
		String userName,
		String sectionQueueName,
		Set<Id> sectionUserOrGroupIds,
		String workStyle,
		Set<Id> userOrGroupIds
		) {
		
		// 検索SQL文
		String selectQuery = '';
		selectQuery += 'SELECT ';
		selectQuery += 'Id, ';
		selectQuery += 'Name, ';
		selectQuery += 'EmployeeNumber ';
		selectQuery += 'FROM ';
		selectQuery += 'User ';

		// WHERE句
		List<String> wheres = new List<String>();

		// 有効ユーザ
		wheres.add('IsActive = true');
		// ユーザ種別
		String userType = remoteAccessSetting.SearchConditionUserType__c;
		wheres.add('UserType = :userType');

		if(String.isNotBlank(employeeNumber)){
			wheres.add('EmployeeNumber = :employeeNumber');
		}

		if(String.isNotBlank(userName)){
			wheres.add('Name LIKE ' + '\'%'+ userName + '%\'');
		}

		if(String.isNotBlank(sectionQueueName) && !sectionUserOrGroupIds.isEmpty()){
			wheres.add('Id IN :sectionUserOrGroupIds');
		}

		if(String.isNotBlank(workStyle) && !userOrGroupIds.isEmpty()){
			// 画面入力が'出社'の場合
			if(workStyle == remoteAccessSetting.WorkStyleTypeOffice__c){
				wheres.add('Id IN :userOrGroupIds');
			// 画面入力が'在宅'の場合
			} else if(workStyle == remoteAccessSetting.WorkStyleTypeRemote__c) {
				wheres.add('Id NOT IN :userOrGroupIds');
			}
		}

		if (!wheres.isEmpty()) {
			selectQuery += 'WHERE ';
			selectQuery += String.join(wheres, ' AND ');
		}

		selectQuery += ' ORDER BY Name';

		// 検索SQL実行
		return Database.query(selectQuery);
	}


	/**
	 * グループメンバー登録／更新
	 * @param groupMembers 
	 */
	public static void upsertGroupMember(
		List<GroupMember> groupMembers) {

		// 登録／更新対象がnullまたは空の場合は何もしない
		if (groupMembers == null || groupMembers.isEmpty()) {
			return;
		}
		try {
			upsert groupMembers;
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
	 * グループメンバー削除
	 * @param groupMembers 
	 */
	public static void deleteGroupMember(
		List<GroupMember> groupMembers) {

		// 削除対象がnullまたは空の場合は何もしない
		if (groupMembers == null || groupMembers.isEmpty()) {
			return;
		}
		try {
			delete groupMembers;
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
     * @description 
     */
    public class DatatableInfo{
        @AuraEnabled
        public User userInfo  { get; set; } // 行id
        @AuraEnabled
        public Group groupInfo  { get; set; } // 
        @AuraEnabled
		public GroupMember groupMemberInfo  { get; set; } // 
        @AuraEnabled
		public Section__c sectionInfo  { get; set; } // 
		
		public DatatableInfo() {
            this.userInfo = new User();
			this.groupInfo = new Group();
			this.groupMemberInfo = new GroupMember();
			this.sectionInfo = new Section__c();
		}
    }  
}