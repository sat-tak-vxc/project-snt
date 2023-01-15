/**
 * 在宅アクセス権限制御画面APEX処理
 * 
 * @author hi-takada
 * @since 2022/03/01
 */
public with sharing class RemoteAccessAuthorityControl {

    /**
     * @description セクション情報取得
     * @return `List<Section__c>`
     */
    @AuraEnabled(Cacheable=true)
    public static List<Section__c> getSections(){
        // カスタム設定
        RemoteAccessSetting__c remoteAccessSetting = 
            RemoteAccessSetting__c.getOrgDefaults();
        return RemoteAccessAuthorityControlModel.getSections(
            remoteAccessSetting);
    }


    /**
     * @description 検索ボタン押下処理
     * @param employeeNumber 
     * @param userName 
     * @param sectionQueueName 
     * @param workStyle 
     * @return `DataRelatedObject`
     */
    @AuraEnabled
    public static DataRelatedObject search(
        String employeeNumber,
        String userName,
        String sectionQueueName,
        String workStyle
    ){
        // 実行処理
        return searchProcess(employeeNumber, userName,
            sectionQueueName, workStyle);
    }

   
    /**
     * @description 出社在宅切り替えボタン押下処理
     * @param selectedRecordJson ユーザ一覧チェック情報
     * @param employeeNumber 
     * @param userName 
     * @param sectionQueueName 
     * @param workStyle 
     * @return `DataRelatedObject`
     */
    @AuraEnabled
    public static DataRelatedObject switchingOfficeRemote(
        String selectedRecordJson,
        String employeeNumber,
        String userName,
        String sectionQueueName,
        String workStyle
    ){
        // 実行処理
        switchingOfficeRemoteProcess(selectedRecordJson);
        return searchProcess(employeeNumber, userName,
            sectionQueueName, workStyle);
    }


    /**
     * @description 検索処理
     * @param employeeNumber 
     * @param userName 
     * @param sectionQueueName 
     * @param workStyle 
     * @return `DataRelatedObject`
     */
    public static DataRelatedObject searchProcess(
        String employeeNumber, String userName, 
        String sectionQueueName, String workStyle
    ){
        // カスタム設定
        RemoteAccessSetting__c remoteAccessSetting = 
            RemoteAccessSetting__c.getOrgDefaults();

        // 返却リストマップ
        DataRelatedObject dataRelated = new DataRelatedObject();

        try {
            
            // 出社グループメンバー取得
            Map<Id, GroupMember> groupMembers = 
                RemoteAccessAuthorityControlModel.getGroupMemberOffice(
                    remoteAccessSetting);

            if(String.isNotBlank(workStyle)){
                // 画面入力が'出社'の場合かつ、出社グループメンバーが存在しない場合、
                // 空を返却
                if(workStyle == remoteAccessSetting.WorkStyleTypeOffice__c && 
                    groupMembers.isEmpty()){
                    return dataRelated;
                }
            }

            Set<Id> sectionUserOrGroupIds = new Set<Id>();

            // セクションが画面選択されている場合、
            // セクションに紐づくグループメンバーからユーザIdを取得する
            if(String.isNotBlank(sectionQueueName)){
                // セクション取得
                Section__c sectionInfo = 
                    RemoteAccessAuthorityControlModel.getSectionQueueName(
                        sectionQueueName);
                // グループ取得
                Group sectionGroup = 
                    RemoteAccessAuthorityControlModel.getGroupQueue(
                        remoteAccessSetting, sectionInfo.Name);
                // グループメンバー取得
                List<GroupMember> sectionGroupMembers = 
                    RemoteAccessAuthorityControlModel.getGroupsMembers(
                        sectionGroup.Id);
            
                for (GroupMember sectionGroupMember : sectionGroupMembers) {
                    sectionUserOrGroupIds.add(sectionGroupMember.UserOrGroupId);
                }

                // セクション入力ありかつグループメンバーに紐づくユーザが存在しない場合、
                // 空を返却
                if(sectionUserOrGroupIds.isEmpty()){
                    return dataRelated;
                }

            }

            // ユーザ取得
            List<User> users  = 
                RemoteAccessAuthorityControlModel.getUsersToSearchConditions(
                    remoteAccessSetting, // カスタム設定
                    employeeNumber, // 従業員番号
                    userName, // 氏名
                    sectionQueueName, // セクションキュー名
                    sectionUserOrGroupIds, // セクションキュー名
                    workStyle, // 勤務形態
                    groupMembers.keySet() // 出社ユーザID
                    );

            if(users.isEmpty()){
                return dataRelated;
            }

            List<RemoteAccessAuthorityControlModel.DatatableInfo> datatableInfos = 
                RemoteAccessAuthorityControlModel.getSectionNamesToUserId(
                    remoteAccessSetting, users);

            // 一覧表示情報
            List<DataRelateDatatable> dataRelateDatatables = 
                new List<DataRelateDatatable>();
            User user;
            Section__c section;

            for (RemoteAccessAuthorityControlModel.DatatableInfo datatableInfo : datatableInfos) {
                user = datatableInfo.userInfo;
                section = datatableInfo.sectionInfo;

                // 一覧設定値
                DataRelateDatatable dataRelatedDatatable = new DataRelateDatatable();
                dataRelatedDatatable.id = user.Id;
                dataRelatedDatatable.UserNameText = user.Name;
                dataRelatedDatatable.EmployeeNumberText = user.EmployeeNumber;
                dataRelatedDatatable.SectionNameText = section.Name;

                if(groupMembers.containsKey(user.Id)){
                    dataRelatedDatatable.IsOfficeAccess = true;
                    dataRelatedDatatable.WorkStyleType = 
                        remoteAccessSetting.WorkStyleTypeOffice__c;
                } else {
                    dataRelatedDatatable.IsOfficeAccess = false;
                    dataRelatedDatatable.WorkStyleType = 
                        remoteAccessSetting.WorkStyleTypeRemote__c;
                }
                dataRelateDatatables.add(dataRelatedDatatable);
            }

            dataRelated.dataRelateDatatable = dataRelateDatatables;

            // 結果を返却
            return dataRelated;

        } catch (Exception e) {
            // 初期表示値取得失敗を表示
            throw new AuraHandledException(
                remoteAccessSetting.SearchEventErrorMessage__c);
        }
    }


    /**
     * @description 出社在宅切り替え処理
     * @param selectedRecordJson ユーザ一覧チェック情報
     * @return `void`
     */
    public static void switchingOfficeRemoteProcess(
        String selectedRecordJson
    ){

        // カスタム設定
        RemoteAccessSetting__c remoteAccessSetting = 
            RemoteAccessSetting__c.getOrgDefaults();

        try {

            if (String.isBlank(selectedRecordJson)) {
                return;
            }

            // 画面検索部入力値
            List<Object> selectedRecordDatas = 
                (List<Object>)JSON.deserializeUntyped(selectedRecordJson);

            List<GroupMember> upsertGroupMembers = new List<GroupMember>();
            Set<Id> deleteUserIds = new Set<Id>();

            Map<String, Object> tmpData = new Map<String, Object>();

            GroupMember tempGroupMember = new GroupMember();
            for(Object selectedRecordData: selectedRecordDatas){
                tmpData = (Map<String, Object>)selectedRecordData;
                // 一覧チェックユーザId
                String userId = (String)tmpData.get('id');
                String workStyleType = (String)tmpData.get('WorkStyleType');

                // 出社 → 在宅 切り替え（delete GroupMember）
                if(workStyleType == remoteAccessSetting.WorkStyleTypeOffice__c){
                    deleteUserIds.add(userId);
                } 
                // 在宅 → 出社 切り替え（upsert GroupMember）
                else if(workStyleType == remoteAccessSetting.WorkStyleTypeRemote__c) {
                    tempGroupMember = new GroupMember();
                    tempGroupMember.GroupId = remoteAccessSetting.OfficeGroupId__c;
                    tempGroupMember.UserOrGroupId = userId;
                    upsertGroupMembers.add(tempGroupMember);
                }
            }

            if (!deleteUserIds.isEmpty()) {

                // 削除グループメンバーId取得
                List<GroupMember> deleteGroupMembers = 
                    RemoteAccessAuthorityControlModel.getGroupMembersUserIds(deleteUserIds);

                // グループメンバー削除処理実行
                RemoteAccessAuthorityControlModel.deleteGroupMember(deleteGroupMembers);

            }

            // グループメンバー登録更新処理実行
            RemoteAccessAuthorityControlModel.upsertGroupMember(upsertGroupMembers);

        } catch (Exception e) {
            // 初期表示値取得失敗を表示
            throw new AuraHandledException(
                remoteAccessSetting.SwitchingOfficeRemoteEventErrorMessage__c);
        }
    }


    /**
     * @description 画面初期表示情報返却オブジェクト
     */
    public class DataRelatedObject{	
        @AuraEnabled
		public List<DataRelateDatatable> dataRelateDatatable { get; set; } // データテーブル情報
        
		public DataRelatedObject() {
            this.dataRelateDatatable = new List<DataRelateDatatable>();
		}
    }


    /**
     * @description 画面データテーブル表示用オブジェクト
     */
    public class DataRelateDatatable{
        @AuraEnabled
        public String id  { get; set; } // 行id
        @AuraEnabled
        public String linkName  { get; set; } // 氏名リンク
        @AuraEnabled
		public String EmployeeNumberText  { get; set; } // 従業員番号
        @AuraEnabled
		public String UserNameText { get; set; } // 氏名
        @AuraEnabled
		public String SectionNameText { get; set; } // セクション
        @AuraEnabled
		public String WorkStyleText { get; set; } // 勤務形態
        @AuraEnabled
		public String WorkStyleType { get; set; } // 勤務形態タイプ
        @AuraEnabled
		public Boolean IsOfficeAccess { get; set; } // 出社フラグ

		public DataRelateDatatable() {
            this.IsOfficeAccess = false;
		}
    }    
}