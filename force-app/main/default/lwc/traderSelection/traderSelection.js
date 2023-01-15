// 基底
import { api, LightningElement, track } from 'lwc';

// Event
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// LMS
// wire

// テンプレート
import defaultTemplate from './traderSelection.html';

// Apex
/** 検索ボタン押下処理 */
import SEARCH_METHOD from '@salesforce/apex/TraderSelectionController.search';
/** 画面初期表示内容取得 */
import GET_MEDIATION_REQUEST from '@salesforce/apex/TraderSelectionController.getMediationRequest';
/** 画面初期表示内容取得 */
import GET_CITY from '@salesforce/apex/TraderSelectionController.getCity';

import UPSERT_MEDIATION_REQUEST from '@salesforce/apex/TraderSelectionController.upsertMediationRequest';
import UPDATE_MEDIATION_STATUS from '@salesforce/apex/TraderSelectionController.updateMediationStatus';
import DELETE_MEDIATION_REQUEST from '@salesforce/apex/TraderSelectionController.deleteMediationRequest';


// 業者選択一覧列情報
const selectEstateAgencyColumns = [
    { label: '', fieldName: 'registerButton', type: 'button', initialWidth: 85,
        hideLabel: true, hideDefaultActions: true, 
        typeAttributes: {
            label: { fieldName: 'actionLabel' }, 
            name: 'register_status' , disabled: {fieldName: 'actionDisabled'} 
        }, 
    },
    { label: '得々サービス有無', fieldName: 'IsTokutokuServiceText', type: 'text', initialWidth: 120,
        hideDefaultActions: true, 
    },
    { label: '優先度', fieldName: 'BasicRankText', type: 'text', initialWidth: 70,
        hideDefaultActions: true
    },
    { label: 'ID', fieldName: 'IdText', type: 'text', initialWidth: 70,
        hideDefaultActions: true
    },
    { label: '取引先名', fieldName: 'linkName', type: 'url',
        typeAttributes: { label: { fieldName: 'name' }, target: '_blank'}, 
        initialWidth: 200
    },
    { label: '加盟店区分', fieldName: 'ParticipatingStoreText', type: 'text', initialWidth: 140,
        hideDefaultActions: true
    },
    { label: 'キャパ', fieldName: 'CapacityNumInt', type: 'number', initialWidth: 70,
        cellAttributes: { alignment: 'left' },
        sortable: true, hideDefaultActions: true, 
    },
    { label: '余力', fieldName: 'ReserveNumInt', type: 'number', initialWidth: 70,
        cellAttributes: { alignment: 'left' },
        sortable: true, hideDefaultActions: true, },
    { label: '依頼中', fieldName: 'RequestingNumInt', type: 'number', initialWidth: 70,
        cellAttributes: { alignment: 'left' }, hideDefaultActions: true, 
    },
    { label: '依頼中(基幹)', fieldName: 'RequestingFmNumInt', type: 'number',
        initialWidth: 100, cellAttributes: { alignment: 'left' },
        hideDefaultActions: true, 
    },
    { label: '新商材', fieldName: 'RequestingNewCommodityInt', type: 'number', initialWidth: 70, cellAttributes: { alignment: 'left' }, hideDefaultActions: true, },
];

// 斡旋確認一覧列情報
const mediationAccountColumns = [
    { label: '', fieldName: 'releaseButton', type: 'button', initialWidth: 85,
        hideLabel: true, hideDefaultActions: true,
        typeAttributes: { 
            label: { fieldName: 'actionLabel' },name: 'release_status' ,
            disabled: {fieldName: 'actionDisabled'} 
        }, 
    },
    { label: '得々サービス有無', fieldName: 'IsTokutokuServiceText', type: 'text',
        initialWidth: 120, hideDefaultActions: true, 
    },
    { label: '優先度', fieldName: 'BasicRankText', type: 'text', 
        initialWidth: 70, hideDefaultActions: true
    },
    { label: 'ID', fieldName: 'IdText', type: 'text', 
        initialWidth: 70, hideDefaultActions: true
    },
    { label: '取引先名', fieldName: 'linkName', type: 'url',
        typeAttributes: { 
            label: { fieldName: 'name' }, target: '_blank'
        }, initialWidth: 200
    },
    { label: '加盟店区分', fieldName: 'ParticipatingStoreText', type: 'text', 
        initialWidth: 140, hideDefaultActions: true
    },
    { type: 'action', 
        typeAttributes: {
            rowActions: {fieldName: 'actionContents'},  
        },
    },
    { label: 'ステータス', fieldName: 'ContractCategoryText', type: 'text',
        initialWidth: 85, hideDefaultActions: true, editable: false, 
    },
    { label: '依頼日', fieldName: 'MediationInputDateText', type: 'text', 
        initialWidth: 120, hideDefaultActions: true, 
    },
];

// 斡旋確認一覧ステータス列アクション
const actions = [
    { label: '－', name: 'blank' },
    { label: '依頼中', name: 'request' },
    { label: '成約', name: 'contract' },
    { label: '失注', name: 'lost' },
    { label: 'キャンセル', name: 'cancel' },
];

export default class TraderSelection extends LightningElement {
    /***********************
     *    各種プロパティ    *
     ***********************/

    // 画面ID
    @api recordId;
    
    // 業者選択部表示
    @track isToggleOpen = true;
    @track toggleIconName = 'utility:chevrondown';
    @track toggleButtonLabel = '業者選択部非表示';

    // 選択後業者選択部表示
    @track isSelectEstateAgencyOpen = false;

    // 斡旋依頼数表示
    @track mediationRequestCount = 0;
    @track mediationRequestTotalCount = 3;

    // 指定業者選定ルール本文
    @track bodyPreview;

    // 希望不動産会社
    @track desiredAgencyValue = null;

    // 市区町村活性／非活性
    @track isDisabledSearchCity = true;

    // 指定業者選定ルールタイトル表示
    @track selectionRuleTitle = '指定業者選定ルール：手動';

    // ダイアログメッセージ表示
    @track dialogMessage = '';
    dialogType;

    // 登録モード
    @track isRegisterMode = true;

    // 検索取引先ID
    @track searchAccountIdValue;
    // 検索取引先名
    @track searchAccountNameValue;
    // 検索都道府県
    @track searchStateValue = '';
    @track searchStateOptions = [];
    // 検索市区町村
    @track searchCityValue = '';
    @track searchCityOptions = [];
    // 業者選択一覧表示値
    @track selectEstateAgencyData = [];
    @track selectEstateAgencyColumns = selectEstateAgencyColumns;
    // 斡旋確認一覧表示値
    @track mediationAccountData = [];
    @track mediationAccountColumns = mediationAccountColumns;
    mediationAccountActionRowId;
    mediationAccountActionStr;

    /** モード 0: 非表示1: 表示 */
    @track mode = 0;
    /** ダイアログ表示モードかどうかを返す */
    get isEditDialog() {
        return (this.mode === 1);
    }

    /** 斡旋依頼ボタン活性／非活性／ */
    get isMediationRequestCountCheck() {
        return (this.mediationRequestCount < this.mediationRequestTotalCount);
    }

    /** 画面ローディング表示 */
    @track isLoading = false;

    /***********************
     *    ライフサイクル    *
     ***********************/
    /**
     * コンポーネント作成時のコードの実行
     */
     constructor() {
        super();
    }

    /**
     * DOM のコンポーネントの挿入時のコードの実行
     */
    connectedCallback() {

        this.isLoading = true;

        // 斡旋確認一覧の表示項目を取得する
        GET_MEDIATION_REQUEST({
            // 新規ID
            newMatterId: this.recordId,
        })
        .then(result => {
            // 成功メッセージ

            // データテーブル設定
            [...result['dataRelateDatatable']].map((value, index, array) => {
                
                // アクション
                if(!result['isContractFinish'] && value.isActionContentActive){
                    value.actionContents = actions;
                }
                // ボタンラベル
                value.actionLabel = '解除';
                // リンク
                value.linkName = '/lightning/r/Account/' + value.id + '/view';
                // 得々サービス有無
                if(value.isTokutokuService){
                    value.IsTokutokuServiceText =  '有';
                } else {
                    value.IsTokutokuServiceText =  '無';
                }
            });
            this.mediationAccountData = result['dataRelateDatatable'];

            // 希望不動産会社表示
            this.desiredAgencyValue = result['desiredAgencyValue'];
            // 指定業者選定ルール表示
            this.bodyPreview = result['bodyPreview'];
            // 想定選定数表示
            this.mediationRequestTotalCount = result['mediationRequestTotalCount'];
            // 斡旋確認一覧数表示
            this.mediationRequestCount = this.mediationAccountData.length;

            // 斡旋の自動、手動を表示
            if(result['isSelectionRule']){
                this.selectionRuleTitle = '指定業者選定ルール：自動'
            }

            // 都道府県表示
            const tmpSearchStateOptions = [{label: '', value: ''}];
			[...result['districts']].map((value, index, array) => {
                tmpSearchStateOptions.push({
                    label: value.State__c,
                    value: value.State__c
                })
            });
            this.searchStateOptions = tmpSearchStateOptions;


            // 斡旋依頼の内容により画面表示を変更
            if(result['isContractFinish']){
                this.isToggleOpen = false;
                this.isRegisterMode = false;

            } else if(result['isRequesting']) {
                this.isToggleOpen = false;
                this.toggleIconName = 'utility:chevrondown';
                this.toggleButtonLabel = '業者選択部非表示';
            }

            this.isLoading = false;

        })
        .catch(error => {
            console.log('GET_MEDIATION_REQUEST error');
            console.log(error);
            this.isLoading = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: '処理失敗。',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });

    }

    
    /**
     * コンポーネント表示開始時のコードの実行
     * @returns 
     */
    render() {
        return defaultTemplate;
    }
    /**
     * コンポーネント表示時のコードの実行
     */
    renderedCallback() {
        return;
    }
    /**
     * DOM のコンポーネントの削除時のコードの実行
     */
    disconnectedCallback() {
        return;
    }
    /**
     * コンポーネントエラーの処理
     * @param {*} error 
     * @param {*} stack 
     */
    errorCallback(error, stack) {
        console.log('TraderSelection errorCallback');
        console.log(error);
        console.log(stack);
    }

    @track defaultSortDirection = 'asc';
    @track sortDirection = 'asc';
    @track sortedBy;

    /**
     * 業者選択一覧ソート処理
     * @param {*} event 
     */
    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.selectEstateAgencyData];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.selectEstateAgencyData = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }
    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                  return primer(x[field]);
              }
            : function (x) {
                  return x[field];
              };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }


    /**
     * 一覧ボタン、アクション処理
     * @param {*} event 
     */
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const actionLabel = event.detail.action.label;
        const row = event.detail.row;

        switch (actionName) {
            // 登録ボタン押下
            case 'register_status':
                this.rowActionRegisterProcess(row);
                break;
            // 解除ボタン押下
            case 'release_status':
                this.rowActionReleaseProcess(row);
                break;

            // ステータスアクション選択
            case 'blank':
                // 処理なし
                break;
            case 'request':
                this.rowActionStatusProcess(row, actionLabel);
                break;
            case 'contract':
                this.rowActionStatusProcess(row, actionLabel);
                break;
            case 'lost':
                this.rowActionStatusProcess(row, actionLabel);
                break;
            case 'cancel':
                this.rowActionStatusProcess(row, actionLabel);
                break;
            default:

        }
    }

    /**
     * 業者選択一覧登録ボタン処理
     * @param {*} row  業者選択一覧登録ボタン押下行
     */
    rowActionRegisterProcess = (row) => {

        /** 業者選択一覧生成 */

        const tmpSelectEstateAgencyData = 
        [...this.selectEstateAgencyData]
            .filter((value, index, array) => {
                // 業者選択一覧から登録ボタン押下行を削除
                return value.id !== row.id
            })
            .filter((value, index, array) => {
                // 空欄行削除
                return value.IdText != null
            });

        let new_selectEstateAgencyData = {
            id: row.id,
            actionLabel: '登録',
            actionDisabled: true,
        };

        tmpSelectEstateAgencyData.push(new_selectEstateAgencyData);

        this.selectEstateAgencyData = tmpSelectEstateAgencyData;

        /** 斡旋確認一覧生成 */

        let new_mediationAccountData = row;
        new_mediationAccountData.actionLabel = '解除';

        const tmpMediationAccountData = [...this.mediationAccountData];
        tmpMediationAccountData.push(new_mediationAccountData);

        this.mediationAccountData = tmpMediationAccountData;
        this.mediationRequestCount = this.mediationAccountData.length;
    }

    /**
     * 斡旋確認一覧解除ボタン処理
     * @param {*} row  斡旋確認一覧解除ボタン押下行
     */
     rowActionReleaseProcess = (row) => {

        this.isLoading = true;

        // 解除ボタン押下行の斡旋依頼が存在する場合削除する
        DELETE_MEDIATION_REQUEST({
            // 新規ID
            newMatterId: this.recordId,
            accountId: row.id,
        })
        .then(result => {
            // 成功メッセージ

            /** 業者選択一覧生成 */

            let new_selectEstateAgencyData = row;
            new_selectEstateAgencyData.actionLabel = '登録';

            const tmpSelectEstateAgencyData = 
                [...this.selectEstateAgencyData].filter((value, index, array) => {
                // 業者選択一覧から解除ボタン押下行を削除
                return value.IdText != null
            });

            tmpSelectEstateAgencyData.push(new_selectEstateAgencyData);
            this.selectEstateAgencyData = tmpSelectEstateAgencyData;

            /** 斡旋確認一覧生成 */

            const tmpMediationAccountData = 
            [...this.mediationAccountData].filter((value, index, array) => {
                // 斡旋確認一覧から解除ボタン押下行を削除
                return value.id !== row.id
            });

            this.mediationAccountData = tmpMediationAccountData;
            this.mediationRequestCount = this.mediationAccountData.length;

            this.isLoading = false;
        })
        .catch(error => {
            console.log('DELETE_MEDIATION_REQUEST error');
            console.log(error);
            this.isLoading = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: '処理失敗。',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
        
    }


    /**
     * 検索ボタン押下
     * @param {*} event 
     */
    hundleOnclickButtonSearch = (event) => {

        this.isLoading = true;

        // 検索
        SEARCH_METHOD({
            // 取引先ID
            accountId: this.searchAccountIdValue,
            // 取引先名
            accountName: this.searchAccountNameValue,
            // 都道府県
            state: this.searchStateValue,
            // 市区町村
            city: this.searchCityValue,
        })
        .then(result => {
            // 成功メッセージ

            const tmpSelectEstateAgencyData = [];

            // データテーブル設定
            [...result]
                .filter((value, index, array) => {
                    // 斡旋確認一覧と重複している場合処理スキップ
                    for(var i = 0; i < this.mediationAccountData.length; i++){
                        if(this.mediationAccountData[i].id === value.id){
                            return false;
                        }
                    }
                    return true;
                })          
                .map((value, index, array) => {

                    // ボタンラベル
                    value.actionLabel = '登録';
                    // リンク
                    value.linkName = '/lightning/r/Account/' + value.id + '/view';
                    // 得々サービス有無
                    if(value.isTokutokuService){
                        value.IsTokutokuServiceText =  '有';
                    } else {
                        value.IsTokutokuServiceText =  '無';
                    }
                    tmpSelectEstateAgencyData.push(value);
                });

            this.selectEstateAgencyData = tmpSelectEstateAgencyData;

            this.isLoading = false;

            if(this.selectEstateAgencyData.length > 0){
                this.isSelectEstateAgencyOpen = true;
            } else {
                this.isSelectEstateAgencyOpen = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: '警告',
                        message: '検索条件に該当する取引先が存在しません。\n検索条件を見直してください。',
                        messageData: [],
                        variant: 'warning',
                        mode: 'dismissable'
                    })
                );

            }
        })
        .catch(error => {
            console.log('SEARCH_METHOD error');
            console.log(error);
            this.isLoading = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: '処理失敗。',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }

    /**
     * 斡旋依頼ボタン押下
     * @param {*} event 
     */
     hundleOnclickButton = (event) => {
        this.dialogType = '1';
        this.dialogMessage = 
            '斡旋確認一覧に表示されている不動産会社を対象に斡旋依頼を実行します。';
        this.mode = (this.mode === 0) ? 1 : 0;
    }

    /**
     * 閉じるボタン押下
     * @param {*} event 
     */
    hundleOnclickCancel = (event) => {
        this.mode = (this.mode === 1) ? 0 : 1;
    }

    /**
     * 実行ボタン押下
     * @param {*} event 
     */
    hundleOnclickAction = (event) => {

        this.isLoading = true;

        const accountIds = [];
        [...this.mediationAccountData].map((value, index, array) => {
            accountIds.push(value.id)
        });

        switch (this.dialogType) {
            case '1':
        
                // 斡旋依頼登録／更新
                UPSERT_MEDIATION_REQUEST({
                    // 新規ID
                    newMatterId: this.recordId,
                    // 取引先IDリスト
                    accountIds: accountIds,
                })
                .then(result => {
                    // 成功メッセージ
                    console.log('UPSERT_MEDIATION_REQUEST success');

                    let today = this.getNowYMD();

                    const tmpMediationAccountData = [...this.mediationAccountData];
                    for (const tmpMediationAccount of tmpMediationAccountData) {
                        
                        if(tmpMediationAccount.ContractCategoryText == null 
                            || tmpMediationAccount.ContractCategoryText == ''){
                            tmpMediationAccount.actionDisabled = true;
                            tmpMediationAccount.ContractCategoryText = '依頼中';
                            tmpMediationAccount.MediationInputDateText = today;
                            tmpMediationAccount.actionContents = actions;
                        }
                    }
                    this.mediationAccountData = tmpMediationAccountData;
                    this.isLoading = false;
                    this.mode = (this.mode === 1) ? 0 : 1;
        
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: '処理成功',
                            message: '斡旋依頼を実行しました。',
                            variant: 'success',
                            mode: 'dismissable'
                        })
                    );
        
                })
                .catch(error => {
                    console.log('UPSERT_MEDIATION_REQUEST error');
                    console.log(error);
                    this.isLoading = false;
                    this.mode = (this.mode === 1) ? 0 : 1;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: '処理失敗。',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });

                break;
            case '2':
            
                // 斡旋依頼ステータス更新
                UPDATE_MEDIATION_STATUS({
                    // 新規ID
                    newMatterId: this.recordId,
                    // 取引先IDリスト
                    accountIds: accountIds,
                    // 取引先ID
                    accountId: this.mediationAccountActionRowId,
                    // ステータス
                    status: this.mediationAccountActionStr,
                })
                .then(result => {
                    const tmpMediationAccountData = [...this.mediationAccountData];
                    for (const tmpMediationAccount of tmpMediationAccountData) {
                        
                        if(this.mediationAccountActionRowId == tmpMediationAccount.id){
                            tmpMediationAccount.ContractCategoryText = this.mediationAccountActionStr;
                        }else {
                            if(this.mediationAccountActionStr == '成約'){
                                if(tmpMediationAccount.ContractCategoryText == '依頼中'){
                                    tmpMediationAccount.ContractCategoryText = '失注';
                                }
                            }
                        }

                        if(this.mediationAccountActionStr == '成約'){
                            tmpMediationAccount.actionContents = null;
                        }
                    }
                    if(this.mediationAccountActionStr == '成約'){
                        // 登録モードをOFF
                        this.isRegisterMode = false;
                        this.isToggleOpen = false;
                    }

                    this.mediationAccountData = tmpMediationAccountData;
                    this.isLoading = false;
                    this.mode = (this.mode === 1) ? 0 : 1;

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: '処理成功',
                            message: '斡旋依頼のステータス更新を実行しました。',
                            variant: 'success',
                            mode: 'dismissable'
                        })
                    );

                })
                .catch(error => {
                    console.log('UPDATE_MEDIATION_STATUS error');
                    console.log(error);
                    this.isLoading = false;
                    this.mode = (this.mode === 1) ? 0 : 1;

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: '処理失敗。',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });

                break;
            default:
        }
        
    }


    /**
     * 開閉ボタン押下
     * @param {*} event 
     */
     hundleOnclickButtonChevrondown = (event) => {
        if(this.isToggleOpen){
            this.isToggleOpen = false;
            this.toggleIconName = 'utility:chevronright';
            this.toggleButtonLabel = '業者選択部表示';
        } else {
            this.isToggleOpen = true;
            this.toggleIconName = 'utility:chevrondown';
            this.toggleButtonLabel = '業者選択部非表示';
        }
    }

    /**
     * 取引先ID入力イベント
     * @param {*} event 
     */
    handleOnblurSearchAccountId = (event) => {

        this.searchAccountIdValue = event.target.value;
    }

    /**
     * 取引先名入力イベント
     * @param {*} event 
     */
    handleOnblurSearchAccountName = (event) => {
        
        this.searchAccountNameValue = event.target.value;
    }


    /**
     * 都道府県選択イベント
     * @param {*} event 
     */
    handleOnchangeSearchState = (event) => {
        this.searchStateValue  = event.detail.value;
        this.searchCityValue = '';

        if(event.detail.value == ''){
            // ブランクが選択された場合、市区町村を非活性にする
            
            this.isDisabledSearchCity = true;
        } else {
            // ブランク以外が選択された場合、市区町村を活性にする

            // 地区から市区町村を所得
            GET_CITY({
                // 都道府県名
                stateName: event.detail.value,
            })
            .then(result => {
                this.isDisabledSearchCity = false;

                const tmp = [{label: '', value: ''}];
                [...result].map((value, index, array) => {
                    tmp.push({
                        label: value.City__c,
                        value: value.City__c
                    })
                });

                this.searchCityOptions = tmp;

            })
            .catch(error => {
                console.log('GET_MEDIATION_REQUEST error');
                console.log(error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: '処理失敗。',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
        }
    }


    /**
     * 市区町村選択イベント
     * @param {*} event 
     */
    handleOnchangeSearchCity = (event) => {
        this.searchCityValue = event.detail.value;
    }
    

    /**
     * 斡旋確認一覧ステータス選択処理
     */
     rowActionStatusProcess = (row, str) => {
        this.dialogType = '2';
        this.dialogMessage = '斡旋依頼ステータスを' + str + 'に更新します。';
        this.mediationAccountActionRowId = row.id;
        this.mediationAccountActionStr = str;
        this.mode = (this.mode === 0) ? 1 : 0;
    }

    /**
     * 現在日付取得
     */
    getNowYMD = () => {
        var date = new Date();
        var y = date.getFullYear();
        var m = ("00" + (date.getMonth()+1)).slice(-2);
        var d = ("00" + date.getDate()).slice(-2);
        var result = y + '-' + m + '-'+ d;
        return result;
    }


}