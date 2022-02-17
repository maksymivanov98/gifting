@Istest
private class MassGiftSendController_Test {
    
    private static testmethod void test2(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        insert con11;
        conList.add(con11);
        
        
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
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        MassGiftSendController masssend = new MassGiftSendController(setcontroller);
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.giftSelected = gift.id__c;
        
        
        
        masssend.sendGift();
        
        Test.stopTest();
        
        
    }
    
    private static testmethod void test3(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        insert con11;
        conList.add(con11);
        
        
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
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        MassGiftSendController masssend = new MassGiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.giftSelected = gift.id__c;
        
        
        
        
        masssend.customSendGift();
        
        
        Test.stopTest();
        
        
    }
    
    private static testmethod void test4(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        insert con11;
        conList.add(con11);
        
        
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
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        MassGiftSendController masssend = new MassGiftSendController(setcontroller);
        masssend.giftSelected = gift.id__c;
        
        
        
        E_GiftSendController emassgift = new E_GiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        emassgift.giftSelected = 'test';
        
        emassgift.E_GiftName  ='';
        emassgift.recipientSelected = 'Include Both First and Last Name (Recommended)';
        emassgift.greetSelected = 'Other';
        emassgift.otherSalution = 'Other';
        
        emassgift.sendGift();
        Test.stopTest();
        
        
    }
    
    private static testmethod void test5(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-25;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        insert con11;
        conList.add(con11);
        
        
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
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        MassGiftSendController masssend = new MassGiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.giftSelected = gift.id__c;
        masssend.contactVsValidAddress.put(con11,'Valid Address');
        masssend.customSendGift();
        
        
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        
        
        Test.stopTest();
        
        
    }
    
    
    private static testmethod void test5March(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-25;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        insert con11;
        conList.add(con11);
        
        
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
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        
        
        
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        E_GiftSendController emassgift = new E_GiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        emassgift.contactVsValidAddress.put(con11,'Valid Address');
        emassgift.recipientSelected = 'Include Just Recipient First Name';
        emassgift.customSendGift();
        
        Test.stopTest();
        
        
    }
    
    private static testmethod void test6(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.email = 'test@test.com';
        insert con11;
        conList.add(con11);
        
        
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
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        MassGiftSendController masssend = new MassGiftSendController(setcontroller);
        masssend.giftSelected = gift.id__c;
        
        
        
        E_GiftSendController emassgift = new E_GiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        emassgift.invalidContactWrapper.add(new E_GiftSendController.wrapperClass(true,con11));
        emassgift.recipientSelected = 'Include Just Recipient Last Name';
        emassgift.customSendGift();
        emassgift.idVal = con11.id;
        emassgift.setWrapperVal();
        emassgift.proceed();
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        GiftSendFromContactPage giftContactPage = new GiftSendFromContactPage();
        Test.stopTest();
    }
    
    
    private static testmethod void test22(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.email = 'abc@test.com';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        insert con11;
        conList.add(con11);
        
        
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
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        MassGiftSendController masssend = new MassGiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.giftSelected = gift.id__c;
        
        masssend.invalidContactWrapper.add(new MassGiftSendController.wrapperClass(true,con11));
        masssend.customSendGift();
        masssend.idVal = con11.id;
        masssend.setWrapperVal();
        masssend.proceed();
        
        masssend.sendGift();
        
        Test.stopTest();
        
        
    }
    
    private static testmethod void test23(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.MailingStreet = 'test';
        con11.MailingCity = 'test';
        con11.MailingPostalCode = '123456';
        con11.MailingState = 'test';
        con11.MailingCountry = 'test';
        insert con11;
        conList.add(con11);
        
        set<String> contactId = new set<String>();
        contactId.add(con11.id);
        
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
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        MassGiftSendController masssend = new MassGiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.giftSelected = gift.id__c;
        
        masssend.invalidContactWrapper.add(new MassGiftSendController.wrapperClass(true,con11));
        masssend.contactVsValidAddress.put(con11,'Valid Address');
        // masssend.customSendGift();
        masssend.idVal = con11.id;
        masssend.setWrapperVal();
        masssend.proceed();
        
        // masssend.sendMassEGiftCallout(contactId, 'test','test','test','test','Include Just Recipient First Name','test','test','test',false);
        // masssend.createRecordsAfterEGiftCallout('test','test','test','test',contactId);
        masssend.sendGift();
        
        Test.stopTest();
        
        
    }
    
    private static testmethod void test23New(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.MailingStreet = 'test';
        con11.MailingCity = 'test';
        con11.MailingPostalCode = '123456';
        con11.MailingState = 'test';
        con11.MailingCountry = 'test';
        insert con11;
        conList.add(con11);
        
        set<String> contactId = new set<String>();
        contactId.add(con11.id);
        
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
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        MassGiftSendController masssend = new MassGiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.giftSelected = gift.id__c;
        
        masssend.invalidContactWrapper.add(new MassGiftSendController.wrapperClass(true,con11));
        masssend.contactVsValidAddress.put(con11,'Valid Address');
        masssend.customSendGift();
        masssend.idVal = con11.id;
        masssend.setWrapperVal();
        masssend.proceed();
        
        // masssend.sendMassEGiftCallout(contactId, 'test','test','test','test','Include Just Recipient First Name','test','test','test',false);
        // masssend.createRecordsAfterEGiftCallout('test','test','test','test',contactId);
        // masssend.sendGift();
        
        Test.stopTest();
        
        
    }
    
    private static testmethod void test23New1(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.MailingStreet = 'test';
        con11.MailingCity = 'test';
        con11.MailingPostalCode = '123456';
        con11.MailingState = 'test';
        con11.MailingCountry = 'test';
        insert con11;
        conList.add(con11);
        
        set<String> contactId = new set<String>();
        contactId.add(con11.id);
        
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
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        MassGiftSendController masssend = new MassGiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.giftSelected = gift.id__c;
        
        masssend.invalidContactWrapper.add(new MassGiftSendController.wrapperClass(true,con11));
        masssend.contactVsValidAddress.put(con11,'Valid Address');
        masssend.customSendGift();
        masssend.idVal = con11.id;
        masssend.setWrapperVal();
        masssend.proceed();
        
        // masssend.sendMassEGiftCallout(contactId, 'test','test','test','test','Include Just Recipient First Name','test','test','test',false);
        //  masssend.createRecordsAfterEGiftCallout('test','test','test','test',contactId);
        // masssend.sendGift();
        
        Test.stopTest();
        
        
    }
    
    private static testmethod void test23New2(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.MailingStreet = 'test';
        con11.MailingCity = 'test';
        con11.MailingPostalCode = '123456';
        con11.MailingState = 'test';
        con11.MailingCountry = 'test';
        insert con11;
        conList.add(con11);
        
        set<String> contactId = new set<String>();
        contactId.add(con11.id);
        
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
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        MassGiftSendController masssend = new MassGiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.giftSelected = gift.id__c;
        
        masssend.invalidContactWrapper.add(new MassGiftSendController.wrapperClass(true,con11));
        masssend.contactVsValidAddress.put(con11,'Valid Address');
        // masssend.customSendGift();
        masssend.idVal = con11.id;
        masssend.setWrapperVal();
        masssend.proceed();
        
        // masssend.sendMassEGiftCallout(contactId, 'test','test','test','test','Include Just Recipient First Name','test','test','test',false);
        masssend.createRecordsAfterEGiftCallout('test','test','test','test',contactId,1);
        // masssend.sendGift();
        
        Test.stopTest();
        
        
    }
    
    
    private static testmethod void test24(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.email = 'test@test.com';
        insert con11;
        conList.add(con11);
        
        set<String> contactId = new set<String>();
        contactId.add(con11.id);
        
        Profile prof = [select id from profile where Name='System Administrator' limit 1];
        User user = new User();
        user.firstName = 'test1';
        user.lastName = 'test2';
        user.profileId = prof.id;
        user.username = 'testfinal@test.com';
        user.email = 'test@test.com';
        user.Gift__c = 'testgift';
        user.Recipient_Name__c = 'TestUser';
        user.Salutation__c = 'Dear';        
        user.EmailEncodingKey = 'ISO-8859-1';
        user.Alias = 'testtest';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.LanguageLocaleKey = 'en_US'; 
        insert user;
        
        products__c gift = new products__c();
        gift.Name ='testgift';
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
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        MassGiftSendController masssend = new MassGiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.E_GiftName = 'test';
        masssend.giftSelected = gift.id__c;
        
        masssend.invalidContactWrapper.add(new MassGiftSendController.wrapperClass(true,con11));
        masssend.giftVsIdMap.put(gift.id__c,gift.id);
        masssend.giftIdVsNameMap.put(gift.id__c,gift.name);
        
        masssend.Daysflag = true;
        masssend.contactVsValidAddress.put(con11,'Valid Address');
        masssend.customSendGift();
        masssend.idVal = con11.id;
        masssend.setWrapperVal();
        masssend.proceed();
        
        
        
        //masssend.createRecordsAfterEGiftCallout('test','test','test','test',contactId);
        masssend.E_GiftName  ='';
        masssend.greetSelected = 'Other';
        masssend.otherSalution = 'Other';
        masssend.sendGift();
        masssend.sendMassEGiftCallout(contactId, 'test','test','test','test','test','test','test','test',false,'test',1);
        Test.stopTest();
        
        
        
    }
    
    private static testmethod void test232(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.MailingStreet = 'test';
        con11.MailingCity = 'test';
        con11.MailingPostalCode = '123456';
        con11.MailingState = 'test';
        con11.MailingCountry = 'test';
        insert con11;
        conList.add(con11);
        
        set<String> contactId = new set<String>();
        contactId.add(con11.id);
        
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
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        MassGiftSendController masssend = new MassGiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.giftSelected = gift.id__c;
        
        masssend.invalidContactWrapper.add(new MassGiftSendController.wrapperClass(true,con11));
        masssend.contactVsValidAddress.put(con11,'Valid Address');
        // masssend.customSendGift();
        masssend.idVal = con11.id;
        masssend.setWrapperVal();
        masssend.proceed();
        
        masssend.sendMassEGiftCallout(contactId, 'test','test','test','test','test','test','test','test',false,'test',1);
        masssend.createRecordsAfterEGiftCallout('test','test','test','test',contactId,1);
        masssend.sendGift();
        
        Test.stopTest();
        
        
    }
    
    private static testmethod void test242(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.email = 'test@test.com';
        insert con11;
        conList.add(con11);
        
        set<String> contactId = new set<String>();
        contactId.add(con11.id);
        
        Profile prof = [select id from profile where Name='System Administrator' limit 1];
        User user = new User();
        user.firstName = 'test1';
        user.lastName = 'test2';
        user.profileId = prof.id;
        user.username = 'testfinal@test.com';
        user.email = 'test@test.com';
        user.Gift__c = 'testgift';
        user.Recipient_Name__c = 'TestUser';
        user.Salutation__c = 'Dear';        
        user.EmailEncodingKey = 'ISO-8859-1';
        user.Alias = 'testtest';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.LanguageLocaleKey = 'en_US'; 
        insert user;
        
        products__c gift = new products__c();
        gift.Name ='testgift';
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
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        MassGiftSendController masssend = new MassGiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.E_GiftName = 'test';
        masssend.giftSelected = gift.id__c;
        
        masssend.invalidContactWrapper.add(new MassGiftSendController.wrapperClass(true,con11));
        masssend.giftVsIdMap.put(gift.id__c,gift.id);
        masssend.giftIdVsNameMap.put(gift.id__c,gift.name);
        
        masssend.Daysflag = true;
        masssend.contactVsValidAddress.put(con11,'Valid Address');
        //masssend.customSendGift();
        masssend.idVal = con11.id;
        masssend.setWrapperVal();
        masssend.proceed();
        
        
        
        masssend.createRecordsAfterEGiftCallout('test','test','test','test',contactId,1);
        masssend.E_GiftName  ='';
        masssend.greetSelected = 'Other';
        masssend.otherSalution = 'Other';
        masssend.sendGift();
        masssend.sendMassEGiftCallout(contactId, 'test','test','test','test','test','test','test','test',false,'test',1);
        Test.stopTest();
        
        
        
    }
    
    private static testmethod void test233(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.MailingStreet = 'test';
        con11.MailingCity = 'test';
        con11.MailingPostalCode = '123456';
        con11.MailingState = 'test';
        con11.MailingCountry = 'test';
        insert con11;
        conList.add(con11);
        
        set<String> contactId = new set<String>();
        contactId.add(con11.id);
        
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
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        MassGiftSendController masssend = new MassGiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.giftSelected = gift.id__c;
        
        masssend.invalidContactWrapper.add(new MassGiftSendController.wrapperClass(true,con11));
        masssend.contactVsValidAddress.put(con11,'Valid Address');
        masssend.customSendGift();
        masssend.idVal = con11.id;
        masssend.setWrapperVal();
        masssend.proceed();
        
        masssend.sendMassEGiftCallout(contactId, 'test','test','test','test','Include Just Recipient First Name','test','test','test',false,'test',1);
        // masssend.createRecordsAfterEGiftCallout('test','test','test','test',contactId);
        masssend.sendGift();
        
        Test.stopTest();
        
        
    }
    
    private static testmethod void test243(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.email = 'test@test.com';
        insert con11;
        conList.add(con11);
        
        
        
        Profile prof = [select id from profile where Name='System Administrator' limit 1];
        User user = new User();
        user.firstName = 'test1';
        user.lastName = 'test2';
        user.email = 'test@test.com';
        user.Gift__c = 'testgift';
        user.Recipient_Name__c = 'TestUser';
        user.Salutation__c = 'Dear';        
        user.EmailEncodingKey = 'ISO-8859-1';
        user.Alias = 'testtest';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.LanguageLocaleKey = 'en_US';
        user.profileId = prof.id;
        user.Username = 'testfinal@test.com';
        
        insert user;
        
        set<String> contactId = new set<String>();
        contactId.add(con11.id);
        
        products__c gift = new products__c();
        gift.Name ='testgift';
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
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        MassGiftSendController masssend = new MassGiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.E_GiftName = 'test';
        masssend.giftSelected = gift.id__c;
        
        masssend.invalidContactWrapper.add(new MassGiftSendController.wrapperClass(true,con11));
        masssend.giftVsIdMap.put(gift.id__c,gift.id);
        masssend.giftIdVsNameMap.put(gift.id__c,gift.name);
        
        masssend.Daysflag = true;
        masssend.contactVsValidAddress.put(con11,'Valid Address');
        masssend.customSendGift();
        masssend.idVal = con11.id;
        masssend.setWrapperVal();
        masssend.proceed();
        
        
        
        // masssend.createRecordsAfterEGiftCallout('test','test','test','test',contactId);
        masssend.E_GiftName  ='';
        masssend.greetSelected = 'Other';
        masssend.otherSalution = 'Other';
        // masssend.sendGift();
        // masssend.sendMassEGiftCallout(contactId, 'test','test',con11.id,'test','test','test','test','test',false);
        Test.stopTest();
        
        
        
    }
    
    private static testmethod void test243New(){
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Contact con11 = new Contact();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.Message__c ='test 1message';
        con11.phone ='9871234560';
        con11.AccountId = ac.Id;
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.email = 'test@test.com';
        insert con11;
        conList.add(con11);
        
        set<String> contactId = new set<String>();
        contactId.add(con11.id);
        
        Profile prof = [select id from profile where Name='System Administrator' limit 1];
        User user = new User();
        user.firstName = 'test1';
        user.lastName = 'test2';
        user.profileId = prof.id;
        user.username = 'testfinal@test.com';
        user.email = 'test@test.com';
        user.Gift__c = 'testgift';
        user.Recipient_Name__c = 'TestUser';
        user.Salutation__c = 'Dear';        
        user.EmailEncodingKey = 'ISO-8859-1';
        user.Alias = 'testtest';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.LanguageLocaleKey = 'en_US'; 
        insert user;
        
        products__c gift = new products__c();
        gift.Name ='testgift';
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
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        MassGiftSendController masssend = new MassGiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.E_GiftName = 'test';
        masssend.giftSelected = gift.id__c;
        
        masssend.invalidContactWrapper.add(new MassGiftSendController.wrapperClass(true,con11));
        masssend.giftVsIdMap.put(gift.id__c,gift.id);
        masssend.giftIdVsNameMap.put(gift.id__c,gift.name);
        
        masssend.Daysflag = true;
        masssend.contactVsValidAddress.put(con11,'Valid Address');
        // masssend.customSendGift();
        masssend.idVal = con11.id;
        masssend.setWrapperVal();
        masssend.proceed();
        
        
        
        masssend.createRecordsAfterEGiftCallout('test','test','test','test',contactId,1);
        masssend.E_GiftName  ='';
        masssend.greetSelected = 'Other';
        masssend.otherSalution = 'Other';
        //  masssend.sendGift();
        // masssend.sendMassEGiftCallout(contactId, 'test','test',con11.id,'test','test','test','test','test',false);
        Test.stopTest();
        
        
        
    }
    
    
    
    /*private static testmethod void test7(){
Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());

List<Contact> conList = new List<Contact>();
Account ac = new Account();
ac.name = 'Abhi';
insert ac;
System.assert(ac.id!=null); 



Contact con11 = new Contact();
con11.FirstName ='testcon';
con11.LastName = 'NewTest';
con11.Message__c ='test 1message';
con11.phone ='9871234560';
con11.AccountId = ac.Id;
con11.Last_Gift_Send__c =Date.today()-35;
con11.Gift_Name__c ='test gift';
con11.Gift_Id__c ='00213';
insert con11;
conList.add(con11);


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

GiftMerchant__c giftMerchantObj = new GiftMerchant__c();
giftMerchantObj.MerchantId__c = '11';
giftMerchantObj.Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
insert giftMerchantObj;

String testLbl = Label.GreetingLabel;
String testLbl1 = Label.Recipient_Name;

PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here


Test.startTest();

GiftSendFromContactController.wrapContact wrap = new GiftSendFromContactController.wrapContact();
GiftSendFromContactController giftSendConCont = new GiftSendFromContactController();
giftSendConCont.errorClose();
giftSendConCont.showMag();
Test.stopTest();
}*/
    
    
}