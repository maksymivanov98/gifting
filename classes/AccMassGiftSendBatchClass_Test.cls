@Istest
private class AccMassGiftSendBatchClass_Test {
    
    private static testmethod void test1(){
        Set<String> accSet = new Set<String>();
        Account ac = new Account();
        ac.Name ='Abhishek';
        ac.Phone ='123456789';
        ac.Message__c ='test message';
        ac.Gift_Id__c ='2464';
        ac.Gift_Name__c ='test gift';
        insert ac;
        accSet.add(ac.Id);
        
        System.assert(ac.id!=null);

        
        Corporate_gift__GiftingSetup__c giftmarchant = new Corporate_gift__GiftingSetup__c();
        giftmarchant.Corporate_gift__Merchant_Id__c ='00124';
        giftmarchant.Corporate_gift__Security_Header__c ='test321';
        
        insert giftmarchant;
                
        System.assert(giftmarchant.id!=null);

        
        products__c gift = new products__c();
        gift.Name ='test gift';
        gift.id__c ='9876';
        insert gift;
        

         System.assert(gift.id!=null);

        
         Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
        
        AccMassGiftSendBatchClass massacc = new AccMassGiftSendBatchClass(accSet);
        AccMassGiftSendBatchClass massacc1 = new AccMassGiftSendBatchClass
            (accSet,gift.id__c ,ac.Message__c,'test greeting1' ,'test recipientName1' ,gift.Name ,'test giftType1' ,gift.Id);
    
        Database.executeBatch(massacc1);
        massacc1.createRecordsAfterCallout(ac.Gift_Id__c, ac.Id);
    }
    
    
}