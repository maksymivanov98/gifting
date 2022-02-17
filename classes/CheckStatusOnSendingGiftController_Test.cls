@IsTest
private class CheckStatusOnSendingGiftController_Test {
    
    private static testmethod void test1(){
        contact con =new contact();
        con.Lastname = 'gupta';
        con.Gift_Id__c ='12345';
        con.Email ='abhihsek@hicglobalsolutions.com';
        insert con;               
        System.assert(con.id!=null);
        
        Corporate_gift__GiftingSetup__c  giftmarchant = new Corporate_gift__GiftingSetup__c ();
    	giftmarchant.Corporate_gift__Merchant_Id__c ='00124';
    	giftmarchant.Corporate_gift__Security_Header__c ='test321';
    	giftmarchant.Corporate_gift__Status_Merchant_Id__c ='00321548';
        insert giftmarchant;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
        CheckStatusOnSendingGiftController.CheckStatusOnSendingGiftController(con.id);
        Test.stopTest();
    }
}