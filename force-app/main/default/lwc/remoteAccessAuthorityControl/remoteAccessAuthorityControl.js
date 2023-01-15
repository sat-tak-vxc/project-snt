// 基底
import { api, LightningElement, track, wire } from 'lwc';

// Event
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Event
// LMS
// wire

// テンプレート
import defaultTemplate from './remoteAccessAuthorityControl.html';

// Apex
/** 画面初期表示内容取得 */
import SEARCH_METHOD from '@salesforce/apex/RemoteAccessAuthorityControl.search';
import GET_SECTIONS from '@salesforce/apex/RemoteAccessAuthorityControl.getSections';
import SWITCHING_OFFICE_REMOTE from '@salesforce/apex/RemoteAccessAuthorityControl.switchingOfficeRemote';

const userColumns = [
    
    { label: '従業員番号', fieldName: 'EmployeeNumberText', type: 'text', 
        hideDefaultActions: false, editable: false, initialWidth: 200 
        ,sortable: true},
    { label: '氏名', fieldName: 'linkName', type: 'url', 
        typeAttributes: { label: { fieldName: 'UserNameText' }, target: '_blank'}
        ,sortable: true},
    { label: 'セクション', fieldName: 'SectionNameText', type: 'text', 
        hideDefaultActions: false, editable: false
        ,sortable: true},
    { label: '勤務形態', fieldName: 'WorkStyleText', type: 'text', 
        hideDefaultActions: false, editable: false, initialWidth: 200 
        ,sortable: true},
];


export default class RemoteAccessAuthorityControl extends LightningElement {
    /***********************
     *    各種プロパティ    *
     ***********************/

    /**
        * モード
        * 0: 表示
        * 1: 編集
        */
    @track mode = 0;

    /**
     * 編集モードかどうかを返す
     */
    get isEdit() {
        return (this.mode === 1);
    }

    // 勤務形態
    @track workStyleComboboxValue = '';
    get workStyleComboboxOptions() {
        return [
            { label: '', value: 'blank' },
            { label: '出社', value: 'office' },
            { label: '在宅', value: 'remote' },
        ];
    }

    /** 画面ローディング表示 */
    @track isLoading = false;
    /** 出社／在宅切り替えボタン活性非活性 */
    @track isDisabledButton = true;

    /**
     * セクションコンボボックス値取得
     */
     @wire(GET_SECTIONS)
     wiredRecord({error, data}) {
         if (data) {
            const tempSectionComboboxOptions = [];
            tempSectionComboboxOptions.push({label:'', value:null});
            [...data].map((value, index, array) => {
                tempSectionComboboxOptions.push( {
                    label: value.Name,
                    value: value.QueueName__c
                });
            });
            this.sectionComboboxOptions = tempSectionComboboxOptions;

         } else if (error) {
            console.log('GET_SECTIONS error');
            this.dispatchEvent(
                new ShowToastEvent({
                    title: '処理失敗。',
                    message: '選択ボックスの値取得に失敗しました。システム管理者へご連絡ください。',
                    variant: 'error'
                })
            );
         }
     }

    // 従業員番号
    @track searchEmployeeNumberValue;
    // 氏名
    @track searchUserNameValue;
    // ユーザ検索結果数
    @track searchResultCount = 'ユーザ検索結果';
    // セクション
    @track sectionComboboxValue = '';
    @track sectionComboboxOptions = [];

    @track userData = [];
    @track userColumns = userColumns;

    @track selectedRowInfos = [];

    @track isSearchResultDisp = false;

    // 検索時情報保持
    tempSearchEmployeeNumberValue;
    tempSearchUserNameValue;
    tempSectionComboboxValue;
    tempWorkStyleComboboxValue;

    // ソート
    @track defaultSortDirection = 'asc';
    @track sortDirection = 'asc';
    @track sortedBy;

    /***********************
     *    ライフサイクル    *
     ***********************/
    /**
     * コンポーネント作成時のコードの実行
     */
    constructor() {
        super();
        console.log('RemoteAccessAuthorityControl constructor');
    }
    /**
     * DOM のコンポーネントの挿入時のコードの実行
     */
    connectedCallback() {
        console.log('RemoteAccessAuthorityControl connectedCallback');
    }
    /**
     * コンポーネント表示開始時のコードの実行
     * @returns 
     */
    render() {
        console.log('RemoteAccessAuthorityControl render');
        return defaultTemplate;
    }
    /**
     * コンポーネント表示時のコードの実行
     */
    renderedCallback() {
        console.log('RemoteAccessAuthorityControl renderedCallback');
    }
    /**
     * DOM のコンポーネントの削除時のコードの実行
     */
    disconnectedCallback() {
        console.log('RemoteAccessAuthorityControl disconnectedCallback');
    }
    /**
     * コンポーネントエラーの処理
     * @param {*} error 
     * @param {*} stack 
     */
    errorCallback(error, stack) {
        console.log('RemoteAccessAuthorityControl errorCallback');
        console.log(error);
        console.log(stack);
    }


    /**
     * ソート処理
     * @param {*} event 
     */
    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.userData];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.userData = cloneData;
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
     * 検索ボタン押下
     * @param {*} event 
     */
    hundleOnclickButtonSearch = (event) => {
        this.isLoading = true;

        // 一覧の表示項目を取得する
        SEARCH_METHOD({
            employeeNumber: this.searchEmployeeNumberValue, // 従業員番号
            userName: this.searchUserNameValue, // 氏名
            sectionQueueName: this.sectionComboboxValue, // セクション
            workStyle: this.workStyleComboboxValue, // 勤務形態
        })
        .then(result => {
            // 成功処理
            if(result['dataRelateDatatable'].length > 0){
                
                this.displayProcess(result);
                this.tempSearchEmployeeNumberValue = this.searchEmployeeNumberValue;
                this.tempSearchUserNameValue = this.searchUserNameValue;
                this.tempSectionComboboxValue = this.sectionComboboxValue;
                this.tempWorkStyleComboboxValue  =this.workStyleComboboxValue;

                this.isSearchResultDisp = true;

            } else {

                this.isSearchResultDisp = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: '警告',
                        message: '検索条件に該当するユーザが存在しません。検索条件を見直してください。',
                        messageData: [],
                        variant: 'warning',
                        mode: 'dismissable'
                    })
                );
                
            }

            this.isLoading = false;
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
     * 出社／在宅切り替えボタン押下
     * @param {*} event 
     */
    hundleOnclickButton = (event) => {
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
        this.mode = (this.mode === 1) ? 0 : 1;
        
        // 一覧の表示項目を取得する
        SWITCHING_OFFICE_REMOTE({
            selectedRecordJson: JSON.stringify(this.selectedRowInfos), // 一覧チェック情報
            employeeNumber: this.tempSearchEmployeeNumberValue, // 従業員番号
            userName: this.tempSearchUserNameValue, // 氏名
            sectionQueueName: this.tempSectionComboboxValue, // セクション
            workStyle: this.tempWorkStyleComboboxValue, // 勤務形態
        })
        .then(result => {
            // 成功メッセージ
            this.displayProcess(result);
            this.isLoading = false;

            this.dispatchEvent(
                new ShowToastEvent({
                    title: '処理成功',
                    message: '出社／在宅切り替えを実行しました。',
                    variant: 'success',
                    mode: 'dismissable'
                })
            );
        })
        .catch(error => {
            console.log('SWITCHING_OFFICE_REMOTE error');
            console.log(error);
            this.mode = (this.mode === 1) ? 0 : 1;
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
     * 従業員番号
     * @param {*} event 
     */
    handleOnblurSearchEmployeeNumber = (event) => {
        this.searchEmployeeNumberValue = event.target.value;
    }


    /**
     * 氏名
     * @param {*} event 
     */
    handleOnblurSearchUserName = (event) => {
        this.searchUserNameValue = event.target.value;
    }

    
    /**
     * セクションコンボボックス選択押下
     */
     handleOnchangeSearchConditionSectionCombobox = (event) => {
        this.sectionComboboxValue = event.detail.value;
    }

    /**
     * 勤務形態コンボボックス選択押下
     */
     handleOnchangeSearchConditionWorkStyleCombobox = (event) => {
        this.workStyleComboboxValue = event.detail.value;
    }


    /**
     * ユーザ一覧チェック処理
     * @param {*} event 
     */
     handleOnrowselection = (event) => {
        const selectedRows = event.detail.selectedRows;
        this.isDisabledButton = !(selectedRows.length > 0);

        let tempSelectedRow = [];
        // チェック内容格納
        for (let i = 0; i < selectedRows.length; i++){
            tempSelectedRow.push({
                'id':selectedRows[i].id, 
                'WorkStyleType':selectedRows[i].WorkStyleType
            })
        }

        this.selectedRowInfos = tempSelectedRow;
    }


    /**
     * APEXからの取得値を画面に表示する
     * @param result APEX返却値
     */
    displayProcess = (result) => {
        // データテーブル設定
        [...result['dataRelateDatatable']].map((value, index, array) => {
            // 勤務形態
            if(value.IsOfficeAccess){
                value.WorkStyleText = '出社';
            } else {
                value.WorkStyleText = '在宅';
            }
            // リンク
            value.linkName = '/lightning/r/User/' + value.id + '/view';
        });
        this.userData = result['dataRelateDatatable'];

        this.searchResultCount =  'ユーザ検索結果（' +  this.userData.length + '）';
    }

}