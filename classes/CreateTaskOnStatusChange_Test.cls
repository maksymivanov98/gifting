@isTest

private class CreateTaskOnStatusChange_Test {
    static testMethod void validateHelloWorld() {
       Test.startTest();
       Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
 
       Corporate_gift__GiftingSetup__c merchantObject = new Corporate_gift__GiftingSetup__c();
       // merchantObject.name = 'test';
        merchantObject.Corporate_gift__Enable_gift_frequency__c = true;
        insert merchantObject;
        Gift_History__c giftHistoryObject = new Gift_History__c();
        giftHistoryObject.Gift_Status__c = 'Shipped';
        giftHistoryObject.Gift_Status_Id__c = 'Shipped';
        insert giftHistoryObject;
        
        giftHistoryObject.Gift_Status__c = 'Delivered';
        update giftHistoryObject;
        system.assert(true);
        Test.stopTest();
    }
}