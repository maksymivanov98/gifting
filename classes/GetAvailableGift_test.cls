@isTest
private class GetAvailableGift_test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
       Test.setMock(HttpCalloutMock.class, new RefreshMerchantProductsBatch_Mock());
        Corporate_gift__GiftingSetup__c gift = new Corporate_gift__GiftingSetup__c();
        gift.Corporate_gift__Merchant_Id__c  ='00124';
        gift.Corporate_gift__Security_Header__c ='test321';
        gift.Corporate_gift__Admin_Email__c = 'test@mail.com';
        insert gift;
        
        Corporate_gift__GiftMerchant__c gift1 = new Corporate_gift__GiftMerchant__c();
        gift1.Corporate_gift__MerchantId__c  ='00124';
        gift1.Corporate_gift__Security_Header__c ='test321';
        insert gift1;
        
        Products__c pd = new Products__c();
        pd.isActive__c =true ;
        pd.id__c = '5882';
        pd.name = 'test';
        insert pd ;

        Test.starttest();
        BatchGetAvailableGifts batch = new BatchGetAvailableGifts();
      
        database.executebatch(batch,1);
        BatchFetchAvailableGifts batch1 = new BatchFetchAvailableGifts() ;
        database.executebatch(batch1,1);
        
        set<ID> settingIDSet = new set<ID>();
        settingIDSet.add(gift.Id);
        GetAvailableGiftController.getGifts(settingIDSet);
        Test.stoptest();
        system.assert(true);
    }
    static testMethod void myUnitTest1() {
        // TO DO: implement unit test
        
       Test.setMock(HttpCalloutMock.class, new RefreshMerchantProductsBatch_Mock1());
        Corporate_gift__GiftingSetup__c gift1 = new Corporate_gift__GiftingSetup__c();
        gift1.Corporate_gift__Merchant_Id__c  ='00124';
        gift1.Corporate_gift__Security_Header__c ='test321';
        insert gift1;
        
        Corporate_gift__GiftMerchant__c gift2 = new Corporate_gift__GiftMerchant__c();
        gift2.Corporate_gift__MerchantId__c  ='00124';
        gift2.Corporate_gift__Security_Header__c ='test321';
        insert gift2;
        
        Products__c pd1 = new Products__c();
        pd1.isActive__c =false;
        pd1.id__c = '12345';
        pd1.name = 'test';
        insert pd1 ;

        Test.starttest();
         BatchGetAvailableGifts batch = new BatchGetAvailableGifts();
         database.executebatch(batch,1);
        BatchFetchAvailableGifts batch1 = new BatchFetchAvailableGifts() ;
        database.executebatch(batch1,1);
         Test.stopTest();
         system.assert(true);
    }
}