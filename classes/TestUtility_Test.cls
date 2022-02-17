@IsTest
private class TestUtility_Test {

    private static testmethod void test1(){
         List<Account> accList = new List<Account>();
        Account ac = new Account();
         ac.Name ='Abhishek';
        ac.Phone ='123456789';
        ac.Message__c ='test message';
        ac.Gift_Id__c ='2464';
        ac.Gift_Name__c ='test gift';
        insert ac;
        accList.add(ac);
       
        System.assert(ac.id!=null);

        
        products__c gift = new products__c();
        gift.Name ='test gift';
        gift.id__c ='9876';
        insert gift;
        

        System.assert(gift.id!=null);
        

        
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        GiftSendController accgift  = new GiftSendController();
        accgift.sendGiftMethod();
       // GiftSendFromContactController aaccgiftc = new GiftSendFromContactController();
     //   aaccgiftc.sendGift();
    
    }
}