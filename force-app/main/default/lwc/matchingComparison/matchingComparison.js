// 基底
import { api, LightningElement, track } from 'lwc';

// Event
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// LMS
// wire

// テンプレート
import defaultTemplate from './matchingComparison.html';

// Apex
/** 画面初期表示内容取得 */
import GET_MATCHING from '@salesforce/apex/MatchingComparison.getMatching';
/** 一覧編集内容を登録／更新する */
import UPDATE_MATCHING from '@salesforce/apex/MatchingComparison.updateMatching';
/** 手動マッチング実行 */
//import DO_MANUAL_MATCHING from '@salesforce/apex/MatchingComparison.doManualMatching';

const actions = [
    { label: '－', name: 'blank' },
    { label: '重説', name: 'important' },
    { label: '契約書', name: 'contract' },
    { label: '請求書', name: 'bill' },
    { label: '図面', name: 'drawing' },
    { label: 'その他', name: 'others' },
];

const matchingColumns = [    
    { label: '項目名', fieldName: 'FieldsName', type: 'text', 
        hideDefaultActions: false, editable: false, wrapText: true,},
    { label: '重説', fieldName: 'ImportantExplanationText', type: 'text', initialWidth: 90, 
        hideDefaultActions: false, editable: {fieldName: 'IsImportantExplanationEdit'}, },
    { label: '契約書', fieldName: 'ContractText', type: 'text', initialWidth: 90, 
        hideDefaultActions: false, editable: {fieldName: 'IsContractEdit'}, },
    { label: '請求書', fieldName: 'BillText', type: 'text', initialWidth: 90, 
        hideDefaultActions: false, editable: {fieldName: 'IsBillEdit'}, },
    { label: '図面', fieldName: 'DrawingText', type: 'text', initialWidth: 90,
        hideDefaultActions: false, editable: {fieldName: 'IsDrawingEdit'},  },

    { label: '結果', fieldName: 'ResultText', type: 'text', initialWidth: 50,
        hideDefaultActions: true, editable: false, },

    { type: 'action', typeAttributes: { rowActions: {fieldName: 'actionContents'},  },},

    { label: '結果区分', fieldName: 'ResultTypeText', type: 'text', initialWidth: 70,
        hideDefaultActions: true, editable: false, },
    { label: '結果値', fieldName: 'ResultValueText', type: 'text',
    hideDefaultActions: false, editable: {fieldName: 'IsResultValueEdit'}, wrapText: true,},

    { label: '', fieldName: 'blankText', type: 'text', initialWidth: 50,
    hideDefaultActions: true, editable: false, },
];


export default class MatchingComparison extends LightningElement {
    /***********************
     *    各種プロパティ    *
     ***********************/

    // 画面ID
    @api recordId;
    checkboxValue = [];

    get checkboxOptions() {
        return [
            { label: '重説不要', value: 'important' },
            { label: '契約書不要', value: 'contract' },
            { label: '請求書不要', value: 'bill' },
            { label: '図面不要', value: 'drawing' },
        ];
    }

    @track matchingData = [];
    @track matchingColumns = matchingColumns;
    draftValues = [];

    /** 画面ローディング表示 */
    @track isLoading = false;

    /** 書類入力可 */
    isPaperInput = false;

    isExceptImportantExplanation = false;
    isExceptContract = false;
    isExceptBill = false;
    isExceptDrawing = false;

    // 登録モード
    @track isRegisterMode = false;
    @track isPaperInputDisplay = false;
    
    /** モード 0: 非表示1: 表示 */
    @track mode = 0;
    /** ダイアログ表示モードかどうかを返す */
    get isEditDialog() {
        return (this.mode === 1);
    }
    // ダイアログメッセージ表示
    @track dialogMessage = '';
    dialogType;

    /***********************
     *    ライフサイクル    *
     ***********************/
    /**
     * コンポーネント作成時のコードの実行
     */
     constructor() {
        super();
        console.log('MatchingComparison constructor');
    }
    /**
     * DOM のコンポーネントの挿入時のコードの実行
     */
    connectedCallback() {
        console.log('MatchingComparison connectedCallback');

        this.isLoading = true;

        // 一覧の表示項目を取得する
        GET_MATCHING({
            // 新規ID
            newMatterId: this.recordId,
        })
        .then(result => {
            // 成功メッセージ

            this.displayProcess(result);
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
        console.log('MatchingComparison render');
        return defaultTemplate;
    }
    /**
     * コンポーネント表示時のコードの実行
     */
    renderedCallback() {
        console.log('MatchingComparison renderedCallback');
    }
    /**
     * DOM のコンポーネントの削除時のコードの実行
     */
    disconnectedCallback() {
        console.log('MatchingComparison disconnectedCallback');
    }
    /**
     * コンポーネントエラーの処理
     * @param {*} error 
     * @param {*} stack 
     */
    errorCallback(error, stack) {
        console.log('MatchingComparison errorCallback');
        console.log(error);
        console.log(stack);
    }


    /**
     * 書類入力ボタン押下
     * @param {*} event 
     */
    hundleOnclickPaperInputButton = (event) => {
        this.isLoading = true;
        this.isPaperInput = true;

        // 重説、契約書、請求書、図説列を入力可能に変更
        const tempMatchingData = [...this.matchingData];
        [...tempMatchingData].map((value, index, array) => {

            if(value.IsImportantExplanationTarget){
                value.IsImportantExplanationEdit = true;
            } 
            if(value.IsContractTarget){
                value.IsContractEdit = true;
            }
            if(value.IsBillTarget){
                value.IsBillEdit = true;
            }
            if(value.IsDrawingTarget){
                value.IsDrawingEdit = true;
            }
        });

        this.matchingData = tempMatchingData;
        this.isLoading = false;
    }


    /**
     * 手動マッチング実行時不要項目選択チェックボックス選択イベント
     * @param {*} event 
     */
    handleChangeCheckbox = (event) => {
        this.checkboxValue = event.detail.value;
    }


    /**
     * 手動マッチング実行ボタン押下
     * @param {*} event 
     */
    /*
    hundleOnclickManualMatchingButton = (event) => {
        this.dialogType = 'ManualMatching';
        this.dialogMessage = 
            '手動マッチング実行処理を行います。';
        this.mode = (this.mode === 0) ? 1 : 0;
    }
    */


    /**
     * 登録ボタン押下
     * @param {*} event 
     */
    hundleOnclickRegisterButton = (event) => {
        this.dialogType = 'Register';
        this.dialogMessage = 
            '登録処理を行います。';
        this.mode = (this.mode === 0) ? 1 : 0;
    }


    /**
     * 一覧アクション選択イベント 
     * @param {*} event 
     */
    handleRowAction = (event) => {

        const actionName = event.detail.action.name;
        const actionLabel = event.detail.action.label;
        const row = event.detail.row;

        switch (actionName) {
            case 'blank':
                break;
            case 'important':
                this.rowActionStatusProcess(row, actionLabel, row.ImportantExplanationText);
                break;
            case 'contract':
                this.rowActionStatusProcess(row, actionLabel, row.ContractText);
                break;
            case 'bill':
                this.rowActionStatusProcess(row, actionLabel, row.BillText);
                break;
            case 'drawing':
                this.rowActionStatusProcess(row, actionLabel, row.DrawingText);
                break;
            case 'others':
                this.rowActionInputProcess(row, actionLabel);
                break;

            default:
        }

    }


    /**
     * 一覧行変更イベント
     * @param {*} event 
     */
    handleEditCellChange = (event) => {

        const tmpMatchingData = [...this.matchingData];
        const tmpDraftValues = event.detail.draftValues[0];

        for (const tmpMatching of tmpMatchingData) {
            if(tmpDraftValues.id == tmpMatching.id){

                // 重説列修正の場合
                if ('ImportantExplanationText' in tmpDraftValues) {
                    tmpMatching.ImportantExplanationText = 
                        tmpDraftValues.ImportantExplanationText;
                } 
                // 契約書列修正の場合
                else if('ContractText' in tmpDraftValues) {
                    tmpMatching.ContractText = tmpDraftValues.ContractText;
                } 
                // 請求書列修正の場合
                else if('BillText' in tmpDraftValues) {
                    tmpMatching.BillText = tmpDraftValues.BillText;
                } 
                // 図面列修正の場合
                else if('DrawingText' in tmpDraftValues) {
                    tmpMatching.DrawingText = tmpDraftValues.DrawingText;
                } 
                // 結果値列修正の場合
                else if('ResultValueText' in tmpDraftValues) {
                    tmpMatching.ResultValueText = tmpDraftValues.ResultValueText;
                }
            }
        }

        this.draftValues = [];
        this.matchingData = tmpMatchingData;        
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

        switch (this.dialogType) {
            case 'ManualMatching':
                //this.hundleOnclickManualMatchingProcess();
                break;
            case 'Register':
                this.hundleOnclickRegisterProcess();
                break;
            default:
        }
    }


    /**
     * 一覧アクション選択処理 選択書類の値を結果値へ設定
     * @param row イベント行情報
     * @param label イベントアクションラベル
     * @param text イベントアクションテキスト
     */
    rowActionStatusProcess = (row, label, text) => {

        if (text != null) {
            const tmpMatchingData = [...this.matchingData];
            for (const tmpMatching of tmpMatchingData) {
                // 選択書類の値を結果値へ設定
                if(row.id == tmpMatching.id){
                    // tmpMatching.ResultText = 'OK';
                    // tmpMatching.IsResultValueEdit = false;
                    tmpMatching.ResultTypeText = label;
                    tmpMatching.ResultValueText = text;
                }
            }

            this.matchingData = tmpMatchingData;

        } else {
            // アクションで選択した書類の表示値が空の場合警告を表示

            this.dispatchEvent(
                new ShowToastEvent({
                    title: '警告',
                    message: '空の値が選択されています。選択値をご確認ください',
                    messageData: [],
                    variant: 'warning',
                    mode: 'dismissable'
                })
            );
        }
    }


    /**
     * 一覧アクション選択処理 結果値を編集可能へ切り替える
     * @param row イベント行情報
     * @param label イベントアクションラベル
     */
     rowActionInputProcess = (row, label) => {

        const tmpMatchingData = [...this.matchingData];
        for (const tmpMatching of tmpMatchingData) {
            // 結果値を編集可能へ設定
            if(row.id == tmpMatching.id){
                tmpMatching.IsResultValueEdit = true;
                tmpMatching.ResultTypeText = label;
            }
        }

        this.matchingData = tmpMatchingData;
    }

    
    /**
     * APEXからの取得値を画面に表示する
     * @param result APEX返却値
     */
    displayProcess = (result) => {

        // マッチング一覧表示
        [...result['dataRelateDatatable']].map((value, index, array) => {
            if(result['isFifthSetConfirmExists']){
                value.actionContents = actions;
            }
        });
        this.matchingData = result['dataRelateDatatable'];

        // チェックボックス設定
        let tempCheckboxValue = [];
        if(result['isExceptImportantExplanation']){
            tempCheckboxValue.push('important');
        }
        if(result['isExceptContract']){
            tempCheckboxValue.push('contract');
        }
        if(result['isExceptBill']){
            tempCheckboxValue.push('bill');
        }
        if(result['isExceptDrawing']){
            tempCheckboxValue.push('drawing');
        }
        this.checkboxValue = tempCheckboxValue;

        this.isRegisterMode = true;
    }


    /**
     * 手動マッチング実行ボタン押下
     */
    /*
    hundleOnclickManualMatchingProcess = () => {

        this.setCheckboxValueInfo();
        
        this.isLoading = true;
        this.mode = (this.mode === 1) ? 0 : 1;

        DO_MANUAL_MATCHING({
            // 新規ID
            newMatterId: this.recordId,
            isExceptImportantExplanation: this.isExceptImportantExplanation,
            isExceptContract: this.isExceptContract,
            isExceptBill: this.isExceptBill,
            isExceptDrawing: this.isExceptDrawing,
            isPaperInput: this.isPaperInput,
            matchingDataJson: JSON.stringify(this.matchingData)
        })
        .then(result => {
            // 成功メッセージ

            this.displayProcess(result);
            this.draftValues = [];
            this.isLoading = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: '処理成功',
                    message: '手動マッチング処理を実行しました。',
                    variant: 'success',
                    mode: 'dismissable'
                })
            );

        })
        .catch(error => {
            console.log('DO_MANUAL_MATCHING error');
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
    */
    /**
     * 登録ボタン押下
     */
    hundleOnclickRegisterProcess = () => {      

        this.setCheckboxValueInfo();

        this.isLoading = true;
        this.mode = (this.mode === 1) ? 0 : 1;

        // 一覧の表示項目を更新する
        UPDATE_MATCHING({
            // 新規ID
            newMatterId: this.recordId,
            isExceptImportantExplanation: this.isExceptImportantExplanation,
            isExceptContract: this.isExceptContract,
            isExceptBill: this.isExceptBill,
            isExceptDrawing: this.isExceptDrawing,
            isPaperInput: this.isPaperInput,
            matchingDataJson: JSON.stringify(this.matchingData)
        })
        .then(result => {
            // 成功メッセージ

            this.displayProcess(result);
            this.draftValues = [];
            this.isLoading = false;

            this.dispatchEvent(
                new ShowToastEvent({
                    title: '処理成功',
                    message: '登録処理を実行しました。',
                    variant: 'success',
                    mode: 'dismissable'
                })
            );
        })
        .catch(error => {
            console.log('UPDATE_MATCHING error');
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
     * チェックボックス内容
     */
    setCheckboxValueInfo = () => {      
        for (const value of this.checkboxValue) {
            switch (value) {
                case 'important':
                    this.isExceptImportantExplanation = true; 
                    break;
                case 'contract':
                    this.isExceptContract = true; 
                    break;
                case 'bill':
                    this.isExceptBill = true; 
                    break;
                case 'drawing':
                    this.isExceptDrawing = true; 
                    break;
                default:
            }
        }
    }

}