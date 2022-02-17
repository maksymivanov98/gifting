@IsTest
private class MassGiftSendBatchClass_Test {
    
    Private Static testmethod void test1(){
        Set<string> conSet = new Set <string>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null);
        
        Contact con = new Contact();
        con.Email ='abhishek@hicglobalsolutions.com';
        con.FirstName ='Abhi';
        con.LastName = 'Gupta';
        con.Message__c ='test message';
        con.phone ='123456789';
        con.AccountId = ac.Id;
        con.Last_Gift_Send__c =Date.today()-15;
        con.Gift_Name__c ='test gift';
        con.MailingCity ='Noida';
        con.MailingCountry ='India';
        con.MailingStreet ='Sector 2';
        con.MailingPostalCode ='201301';
        con.Gift_Id__c ='00213';
        insert con;

         System.assert(con.id!=null);    
        
        conSet.add(con.Id);
        Corporate_gift__GiftingSetup__c giftmarchant = new Corporate_gift__GiftingSetup__c ();
        giftmarchant.Corporate_gift__Merchant_Id__c  ='00124';
        giftmarchant.Corporate_gift__Security_Header__c ='test321';
        insert giftmarchant;
        
         System.assert(giftmarchant.id!=null);
         
        products__c gift = new products__c();
        gift.Name ='test gift';
        gift.id__c ='9876';
        insert gift;
        System.assert(gift.id!=null);
        
        try{
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
            Test.startTest();
            MassGiftSendBatchClass massgift = new MassGiftSendBatchClass(conSet);
            MassGiftSendBatchClass massgift1 = new MassGiftSendBatchClass
                (conSet ,'00213', con.Message__c ,'test greeting' ,'test recipientName1 ',gift.Name,'test giftType1 ',gift.Id); 
            DataBase.executeBatch(massgift1);
            Test.stopTest();

       // massgift1.createRecordsAfterCallout(con.Gift_Id__c, con.Id);
        }catch(Exception e){
            
        }
        
    }
    
    Private Static testmethod void test2(){
        Set<string> conSet = new Set <string>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null);
        
        Contact con = new Contact();
        con.Email ='abhishek@hicglobalsolutions.com';
        //con.FirstName ='Abhi';
        con.LastName = 'Gupta';
        con.Message__c ='test message';
        con.phone ='123456789';
        con.AccountId = ac.Id;
        con.Last_Gift_Send__c =Date.today()-15;
        con.Gift_Name__c ='test gift';
        con.MailingCity ='Noida';
        con.MailingCountry ='India';
        con.MailingStreet ='Sector 2';
        con.MailingPostalCode ='201301';
        con.Gift_Id__c ='00213';
        insert con;

         System.assert(con.id!=null);    
        
        conSet.add(con.Id);
        Corporate_gift__GiftingSetup__c giftmarchant = new Corporate_gift__GiftingSetup__c ();
        giftmarchant.Corporate_gift__Merchant_Id__c  ='00124';
        giftmarchant.Corporate_gift__Security_Header__c ='test321';
        insert giftmarchant;
        
         System.assert(giftmarchant.id!=null);
         
        products__c gift = new products__c();
        gift.Name ='test gift';
        gift.id__c ='9876';
        insert gift;
        System.assert(gift.id!=null);
        
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
        MassGiftSendBatchClass massgift = new MassGiftSendBatchClass(conSet);
        MassGiftSendBatchClass massgift1 = new MassGiftSendBatchClass
            (conSet ,'00213', con.Message__c ,'test greeting' ,'Include Just Recipient First Name',gift.Name,'E_gift',gift.Id, 'testName'); 
        DataBase.executeBatch(massgift1);
     //   massgift1.createRecordsAfterCallout(con.Gift_Id__c, con.Id);
        
    }
    
    Private Static testmethod void test3(){
        Set<string> conSet = new Set <string>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null);
        
        Contact con = new Contact();
        con.Email ='abhishek@hicglobalsolutions.com';
        //con.FirstName ='Abhi';
        con.LastName = 'Gupta';
        con.Message__c ='test message';
        con.phone ='123456789';
        con.AccountId = ac.Id;
        con.Last_Gift_Send__c =Date.today()-15;
        con.Gift_Name__c ='test gift';
        con.MailingCity ='Noida';
        con.MailingState ='UP';
        con.MailingCountry ='India';
        con.MailingStreet ='Sector 2';
        con.MailingPostalCode ='201301';
        con.Gift_Id__c ='00213';
        insert con;

         System.assert(con.id!=null);    
        
        conSet.add(con.Id);
        Corporate_gift__GiftingSetup__c giftmarchant = new Corporate_gift__GiftingSetup__c ();
        giftmarchant.Corporate_gift__Merchant_Id__c  ='00124';
        giftmarchant.Corporate_gift__Security_Header__c ='test321';
        insert giftmarchant;
        
         System.assert(giftmarchant.id!=null);
         
        products__c gift = new products__c();
        gift.Name ='test gift';
        gift.id__c ='9876';
        insert gift;
        System.assert(gift.id!=null);
        
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
        MassGiftSendBatchClass massgift = new MassGiftSendBatchClass(conSet);
        MassGiftSendBatchClass massgift1 = new MassGiftSendBatchClass
            (conSet ,'00213', con.Message__c ,'test greeting' ,'Include Just Recipient First Name',gift.Name,'P_gift',gift.Id); 
        DataBase.executeBatch(massgift1);
     //   massgift1.createRecordsAfterCallout(con.Gift_Id__c, con.Id);
        
    }
}