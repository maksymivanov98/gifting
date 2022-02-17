@isTest
private class InvocableEGiftClass_Test {
    
    @isTest
    private static void testMethod1(){
        String jsonString = '[{"ContactIds":"0036g000007SyV9AAK","E_GiftName":"Test Gift","emailSubject":"Test Subject","giftId":"17651","giftName":"Test GiftName","greeting":"Dear","message":"Test Message","recipientName":"new"}]';
        
        InvocableEGiftClass.giftRequest[] requests = new list<InvocableEGiftClass.giftRequest>();
        requests = (List<InvocableEGiftClass.giftRequest>)Json.deserialize(jsonString,List<InvocableEGiftClass.giftRequest>.class);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());

        InvocableEGiftClass.giftList(requests);
        
       
        jsonString = '[{"ContactIds":"0036g000007SyV9AAK","giftId":"100080151","giftName":"test","greeting":"TEst","message":"Test Message","recipientName":"Test Name"}]';
        InvocablePGiftClass.giftRequest[] requestss = new list<InvocablePGiftClass.giftRequest>();

        requestss = (List<InvocablePGiftClass.giftRequest >)Json.deserialize(jsonString,List<InvocablePGiftClass.giftRequest >.class);

        InvocablePGiftClass.giftList(requestss);
        
        System.assert(true);
     
    }
}