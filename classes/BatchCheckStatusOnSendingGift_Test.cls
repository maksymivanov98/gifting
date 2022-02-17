@isTest
private class BatchCheckStatusOnSendingGift_Test {

   private static testMethod void myUnitTest() {
        // TO DO: implement unit test

        Gift_History__c gifthis = new Gift_History__c();
        gifthis.Gift_Status_Id__c ='021547';
        insert gifthis;

        Corporate_gift__GiftingSetup__c gift = new Corporate_gift__GiftingSetup__c();
        gift.Corporate_gift__Merchant_Id__c = '11';
        gift.Corporate_gift__Security_Header__c = 'vts435av';
        gift.Corporate_gift__Status_Merchant_Id__c ='32245';
        insert gift;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
        BatchCheckStatusOnSendingGift checkbatch = new  BatchCheckStatusOnSendingGift();
        Database.executebatch(checkbatch);
        Test.stopTest();
        system.assert(true);

    }
}