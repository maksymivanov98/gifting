@IsTest
private class AccE_GiftSendController_Test {
    
    private static testmethod void test1(){
        Corporate_gift__GiftingSetup__c giftMerchantObj = new Corporate_gift__GiftingSetup__c();
        giftMerchantObj.Corporate_gift__Merchant_Id__c = '11';
        giftMerchantObj.Corporate_gift__Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
        insert giftMerchantObj;
        
        List<Account> accList = new List<Account>();
        Account ac = new Account();
        ac.Name ='Abhishek';
        ac.Phone ='123456789';
        ac.Message__c ='test message';
        ac.Gift_Id__c ='2464';
        ac.Gift_Name__c ='test gift';
        ac.BillingCity = '';
        ac.BillingCountry = '';
        ac.BillingPostalCode = '';
        ac.BillingState = '';
        ac.BillingStreet = '';
        insert ac;
        accList.add(ac);
        
        System.assert(ac.id!=null);
        
        
        products__c gift = new products__c();
        gift.Name ='test gift';
        gift.id__c ='9876';
        gift.isActive__c = true;
        insert gift;
        
        
        System.assert(gift.id!=null);
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(accList);
        
        test.startTest();
        
        setcontroller.setSelected(accList);
        
        AccE_GiftSendController accgift =new AccE_GiftSendController(setcontroller);
        //accgift.sendGift();
        
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        AccMassGiftSendController accgift1 = new AccMassGiftSendController(setcontroller);
        //accgift1.sendGift();
        
        test.stopTest();
    }
    
    private static testmethod void test2(){
        
        
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
        
        List<Account> accList = new List<Account>();
        Account ac = new Account();
        ac.Name ='Abhishek';
        ac.Phone ='123456789';
        ac.Message__c ='test message';
        ac.Gift_Id__c ='2464';
        ac.Gift_Name__c ='test gift';
        ac.BillingCity = 'test city';
        ac.BillingState = 'test state';
        ac.BillingCountry = 'test country';
        ac.BillingStreet = 'test street';
        ac.BillingPostalCode = '123456';
        ac.Last_Gift_Send__c = Date.today()-15;
        insert ac;
        accList.add(ac);
        
        System.assert(ac.id!=null);
        
        
        products__c gift = new products__c();
        gift.Name ='test gift';
        gift.id__c ='9876';
        gift.isActive__c = true;
        insert gift;
        
        Corporate_gift__GiftingSetup__c giftMerchantObj = new Corporate_gift__GiftingSetup__c();
        giftMerchantObj.Corporate_gift__Merchant_Id__c = '11';
        giftMerchantObj.Corporate_gift__Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
        giftMerchantObj.Corporate_gift__Enable_gift_frequency__c = true;
        insert giftMerchantObj;
        
        
        System.assert(gift.id!=null);
        
        
        
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        test.startTest();
        
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(accList);
        
        setcontroller.setSelected(accList);
        
        AccE_GiftSendController accgift =new AccE_GiftSendController(setcontroller);
        //accgift.sendGift();
        
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        AccMassGiftSendController accgift1 = new AccMassGiftSendController(setcontroller);
        //accgift1.sendGift();
        
        test.stopTest();
    }
    
    private static testmethod void test3(){
        
        List<Contact> conList = new List<Contact>();
        List<account> acclist = new List<account>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        acclist.add(ac);
        
        set<String> contactId = new set<String>();
        contactId.add(ac.id);
        
        Profile prof = [select id from profile where Name='System Administrator' limit 1];
        User user = new User();
        user.firstName = 'test1';
        user.lastName = 'test2';
        user.profileId = prof.id;
        user.username = 'testfinal@test.com';
        user.email = 'test@test.com';
        user.Gift__c = 'test gift';
        user.Recipient_Name__c = 'TestUser';
        user.Salutation__c = 'Dear';        
        user.EmailEncodingKey = 'ISO-8859-1';
        user.Alias = 'testtest';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.LanguageLocaleKey = 'en_US'; 
        insert user;
        
        products__c gift = new products__c();
        gift.Name ='test gift';
        gift.id__c ='9876';
        gift.isActive__c = true;
        insert gift;
        
        System.assert(gift.id!=null);
        
        Corporate_gift__GiftingSetup__c giftMerchantObj = new Corporate_gift__GiftingSetup__c();
        giftMerchantObj.Corporate_gift__Merchant_Id__c = '11';
        giftMerchantObj.Corporate_gift__Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
        insert giftMerchantObj;
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        
        
        Test.startTest();
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(acclist);
        setcontroller.setSelected(acclist);
        AccMassGiftSendController masssend = new AccMassGiftSendController(setcontroller);
        
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        masssend.giftSelected = gift.id__c;
        
        masssend.sendGiftAccountCallout(ContactId ,'giftId' ,'message' ,'greeting' ,'recipientName' ,'giftName' ,'giftType' ,'recId','test',1);
        
        
        Test.stopTest();
        
    }
    
    private static testmethod void test4(){
        
        
        
        List<Contact> conList = new List<Contact>();
        List<account> acclist = new List<account>();
        Account ac = new Account();
        ac.name = 'Abhi';
        ac.BillingCity = null;
        ac.BillingCountry = null;
        ac.BillingPostalCode = null;
        ac.BillingState = null;
        ac.BillingStreet = null;
        insert ac;
        acclist.add(ac);
        
        set<String> contactId = new set<String>();
        contactId.add(ac.id);
        
        Profile prof = [select id from profile where Name='System Administrator' limit 1];
        User user = new User();
        user.firstName = 'test1';
        user.lastName = 'test2';
        user.profileId = prof.id;
        user.username = 'testfinal@test.com';
        user.email = 'test@test.com';
        user.Gift__c = 'test gift';
        user.Recipient_Name__c = 'TestUser';
        user.Salutation__c = 'Dear';        
        user.EmailEncodingKey = 'ISO-8859-1';
        user.Alias = 'testtest';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.LanguageLocaleKey = 'en_US'; 
        insert user;
        
        products__c gift = new products__c();
        gift.Name ='test gift';
        gift.id__c ='9876';
        gift.isActive__c = true;
        insert gift;
        
        System.assert(gift.id!=null);
        
        Corporate_gift__GiftingSetup__c giftMerchantObj = new Corporate_gift__GiftingSetup__c();
        giftMerchantObj.Corporate_gift__Merchant_Id__c = '11';
        giftMerchantObj.Corporate_gift__Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
        giftMerchantObj.Corporate_gift__Enable_gift_frequency__c = true;
        insert giftMerchantObj;
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        
        Test.startTest();
        
        PageReference pageRef = Page.AccMassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass2());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(acclist);
        setcontroller.setSelected(acclist);
        AccMassGiftSendController masssend = new AccMassGiftSendController(setcontroller);
        
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass2());
        
        masssend.giftSelected = gift.id__c;
        
        masssend.sendGiftAccountCallout(ContactId ,'giftId' ,'message' ,'greeting' ,'recipientName' ,'giftName' ,'giftType' ,'recId','test',1);
        try{
            masssend.showPopup();
        }catch(Exception e){
            
        }
        Test.stopTest();
        
    }
}