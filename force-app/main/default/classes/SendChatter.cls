public class SendChatter{
    public class SendChatterObject{
        public Id mentionId { get; set; }
        public String text { get; set; }
        public Id feedItemInput { get; set; }
    }
    public SendChatterObject sendChatterObject = new SendChatterObject();
    public List<SendChatterObject> sendChatterObjects = new List<SendChatterObject>();

    public List<ConnectApi.BatchResult> send(){
    
        List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();

        for(SendChatterObject chatterObject: this.sendChatterObjects){
            //値の初期化
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

            //メンション先
            if(chatterObject.mentionId != null){
                mentionSegmentInput.id = chatterObject.mentionId;
                messageBodyInput.messageSegments.add(mentionSegmentInput);
            }

            //本文
            textSegmentInput.text = chatterObject.text;
            messageBodyInput.messageSegments.add(textSegmentInput);
            feedItemInput.body = messageBodyInput;

            //投稿先
            feedItemInput.subjectId = chatterObject.feedItemInput;

            ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
            batchInputs.add(batchInput);

        }

        // Chatter送信実行
        List<ConnectApi.BatchResult> batchResults = 
        ConnectApi.ChatterFeeds.postFeedElementBatch(
            Network.getNetworkId(), batchInputs);

        // 送信結果確認
        for(Integer n=0; n < batchResults.size(); n++){
            ConnectApi.BatchResult batchResult = batchResults[n];
            if (batchResult.isSuccess()) {
                System.debug('sendChatter Success!!');
                
            } else {
                System.debug('sendChatter Error');
                System.debug(batchResult.getErrorMessage());
            }
        }
        return batchResults;
    }
    public void addObject(){
        this.sendChatterObjects.add(this.sendChatterObject);
    }
}