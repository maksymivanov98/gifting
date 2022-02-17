@Istest
private class MassGiftSendBatchClassLead_Test {
    
    private static testmethod void test(){
        
        Set<String> leadSet = new Set<String>();
        Lead ld = new Lead();
        ld.LastName ='gupta';
        ld.Last_Gift_send__c =Date.today()-10;
        ld.Email ='abhishek@hicglobalsolutions.com';
        ld.Company ='HIC Global Solutions';
        ld.Gift_Id__c ='1234';
        insert ld;
        leadSet.add(ld.Id);
        System.assert(ld.id!=null);  
        
        Corporate_gift__GiftingSetup__c  giftmarchant = new Corporate_gift__GiftingSetup__c ();
        giftmarchant.Corporate_gift__Merchant_Id__c ='00124';
        giftmarchant.Corporate_gift__Security_Header__c ='test321';
        
        insert giftmarchant;
        
        products__c gift = new products__c();
        gift.Name ='test gift';
        gift.id__c ='9876';
        insert gift;
        
        System.assert(gift.id!=null);  
        try{
            Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
            
            MassGiftSendBatchClassLead Massgift = new MassGiftSendBatchClassLead(leadSet);
            MassGiftSendBatchClassLead Massgift1 = new MassGiftSendBatchClassLead
                (leadSet , ld.Gift_Id__c,'test message1' ,'test greeting1' ,'test recipientName1' ,gift.Name ,'test giftType1' ,gift.id);
            
            Database.executeBatch(Massgift1);
            //  Massgift1.createRecordsAfterCallout(ld.Gift_Id__c, ld.Id);
        }catch(Exception e){
        }
    }
}