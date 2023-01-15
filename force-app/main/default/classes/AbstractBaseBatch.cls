public abstract class AbstractBaseBatch implements Database.Batchable<SObject> {

    /**
     * 後続のApexバッチ
     */
    public Database.Batchable<SObject> nextBatch {private get; set;}

    /**
     * 後続のApexバッチ
     */
    public Integer nextBatchSize {private get; set;}

    /**
     * 初期処理
     */
    public abstract Iterable<SObject> start(Database.BatchableContext BC);

    /**
     * 実行処理
     */
    public abstract void execute(Database.BatchableContext BC, List<SObject> records);

    /**
     * 終了処理
     */
    public abstract void finish(Database.BatchableContext BC);
}