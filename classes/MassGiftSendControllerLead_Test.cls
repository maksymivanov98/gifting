@Istest
private class MassGiftSendControllerLead_Test {
    
    private Static testmethod void test1(){
        List<Lead> leadList = new List<Lead>();
        Lead ld = new Lead();
        ld.FirstName ='abhishek';
        ld.LastName ='gupta';
        ld.Last_Gift_send__c =Date.today()-10;
        ld.Email ='abhishek@hicglobalsolutions.com';
        ld.Company ='HIC Global Solutions';
        insert ld;
        leadList.add(ld);
        System.assert(ld.id!=null);
        products__c gift = new products__c();
        gift.Name ='test gift';
        gift.id__c ='9876';
        gift.isActive__c = true;
        insert gift;
        System.assert(gift.id!=null);
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        Corporate_gift__GiftingSetup__c  merchant = new Corporate_gift__GiftingSetup__c ();
        merchant.Corporate_gift__Merchant_Id__c = 'testMerchant1';
        merchant.Corporate_gift__Security_Header__c = 'testSecurityHeader1';
        merchant.Corporate_gift__Enable_gift_frequency__c = true;
        insert merchant;
        
        Test.starttest();
        
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(leadList);
        MassGiftSendControllerLead masslead = new MassGiftSendControllerLead(setcontroller);
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
        
        masslead.sendGift();
        
        setcontroller.setSelected(leadList);
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
       
        Test.stoptest();
        
    }
    
      private Static testmethod void test1March(){
        List<Lead> leadList = new List<Lead>();
        Lead ld = new Lead();
        ld.FirstName ='abhishek';
        ld.LastName ='gupta';
        ld.Last_Gift_send__c =Date.today()-10;
        ld.Email ='abhishek@hicglobalsolutions.com';
        ld.Company ='HIC Global Solutions';
        insert ld;
        leadList.add(ld);
        System.assert(ld.id!=null);
        products__c gift = new products__c();
        gift.Name ='test gift';
        gift.id__c ='9876';
        gift.isActive__c = true;
        insert gift;
        System.assert(gift.id!=null);
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        Corporate_gift__GiftingSetup__c  merchant = new Corporate_gift__GiftingSetup__c ();
        merchant.Corporate_gift__Merchant_Id__c = 'testMerchant1';
        merchant.Corporate_gift__Security_Header__c = 'testSecurityHeader1';
        merchant.Corporate_gift__Enable_gift_frequency__c = true;
        insert merchant;
        
        Test.starttest();
        
        
        
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(leadList);
    
        
        setcontroller.setSelected(leadList);
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        E_GiftSendControllerLead emassgift = new E_GiftSendControllerLead(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
        
        emassgift.sendGift();
        
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());

        E_GiftSendControllerLead.wrapContact wrap = new E_GiftSendControllerLead.wrapContact();
        Test.stoptest();
        
    }
    
    
    private Static testmethod void test11(){
        List<Lead> leadList = new List<Lead>();
        Lead ld = new Lead();
        ld.FirstName ='abhishek';
        ld.LastName ='gupta';
        ld.Last_Gift_send__c =Date.today()-10;
        ld.Email ='abhishek@hicglobalsolutions.com';
        ld.Company ='HIC Global Solutions';
        insert ld;
        leadList.add(ld);
        System.assert(ld.id!=null);
        products__c gift = new products__c();
        gift.Name ='test gift';
        gift.id__c ='9876';
        gift.isActive__c = true;
        insert gift;
        System.assert(gift.id!=null);
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        Corporate_gift__GiftingSetup__c  merchant = new Corporate_gift__GiftingSetup__c ();
        merchant.Corporate_gift__Merchant_Id__c = 'testMerchant1';
        merchant.Corporate_gift__Security_Header__c = 'testSecurityHeader1';
        merchant.Corporate_gift__Enable_gift_frequency__c = true;
        insert merchant;
        
        Test.starttest();
        
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(leadList);
        MassGiftSendControllerLead masslead = new MassGiftSendControllerLead(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
        
        masslead.sendGift();
        
       
        Test.stopTest();
        
    }
    
    private Static testmethod void test11March(){
        List<Lead> leadList = new List<Lead>();
        Lead ld = new Lead();
        ld.FirstName ='abhishek';
        ld.LastName ='gupta';
        ld.Last_Gift_send__c =Date.today()-10;
        ld.Email ='abhishek@hicglobalsolutions.com';
        ld.Company ='HIC Global Solutions';
        insert ld;
        leadList.add(ld);
        System.assert(ld.id!=null);
        products__c gift = new products__c();
        gift.Name ='test gift';
        gift.id__c ='9876';
        gift.isActive__c = true;
        insert gift;
        System.assert(gift.id!=null);
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        Corporate_gift__GiftingSetup__c  merchant = new Corporate_gift__GiftingSetup__c ();
        merchant.Corporate_gift__Merchant_Id__c = 'testMerchant1';
        merchant.Corporate_gift__Security_Header__c = 'testSecurityHeader1';
        merchant.Corporate_gift__Enable_gift_frequency__c = true;
        insert merchant;
        
        Test.starttest();
        
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(leadList);
        
        setcontroller.setSelected(leadList);
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        E_GiftSendControllerLead emassgift = new E_GiftSendControllerLead(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock());
        
        emassgift.E_GiftName = '';
        emassgift.greetSelected = 'Other';
        emassgift.sendGift();
        Test.stopTest();
        
    }
    
    private static testmethod void test24(){
        
        List<Lead> conList = new List<Lead>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Lead con11 = new Lead();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.phone ='9871234560';
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.email = 'test@test.com';
        con11.Company = 'test';
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
        
        Corporate_gift__GiftingSetup__c  merchant = new Corporate_gift__GiftingSetup__c ();
        merchant.Corporate_gift__Merchant_Id__c = 'testMerchant1';
        merchant.Corporate_gift__Security_Header__c = 'testSecurityHeader1';
        merchant.Corporate_gift__Enable_gift_frequency__c = true;
        insert merchant;
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        PageReference pageRef = Page.MassGiftSendPageLead; // Add your VF page Name here
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        
        Test.startTest();
        
        
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        MassGiftSendControllerLead masssend = new MassGiftSendControllerLead(setcontroller);
        masssend.E_GiftName = 'test';
        masssend.giftSelected = gift.id__c;
        
        masssend.invalidContactWrapper.add(new MassGiftSendControllerLead.wrapperClass(true,con11));
        masssend.giftVsIdMap.put(gift.id__c,gift.id);
        masssend.giftIdVsNameMap.put(gift.id__c,gift.name);
        
        masssend.Daysflag = true;
        masssend.contactVsValidAddress.put(con11,'Valid Address');
        masssend.customSendGift();
        masssend.idVal = con11.id;
        masssend.setWrapperVal();
        masssend.proceed();
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        
        masssend.createRecordsAfterEGiftCallout('test','test','test','test', 'gift',contactId,1);
        masssend.E_GiftName  ='';
        masssend.greetSelected = 'Other';
        masssend.otherSalution = 'Other';
        masssend.sendGift();
        masssend.sendMassEGiftCallout(contactId, 'test','test','test','test','test','test','test','test',false,'test',1);
        Test.stopTest();
        
        
    }
    
    private static testmethod void test2(){
        
        List<Lead> conList = new List<Lead>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Lead con11 = new Lead();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.phone ='9871234560';
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.Company = 'test';
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
        
        Corporate_gift__GiftingSetup__c  merchant = new Corporate_gift__GiftingSetup__c ();
        merchant.Corporate_gift__Merchant_Id__c = 'testMerchant1';
        merchant.Corporate_gift__Security_Header__c = 'testSecurityHeader1';
        insert merchant;
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        PageReference pageRef = Page.MassGiftSendPageLead; // Add your VF page Name here
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        MassGiftSendControllerLead masssend = new MassGiftSendControllerLead(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.E_GiftName = 'test';
        masssend.giftSelected = gift.id__c;
        
        masssend.invalidContactWrapper.add(new MassGiftSendControllerLead.wrapperClass(true,con11));
        masssend.giftVsIdMap.put(gift.id__c,gift.id);
        masssend.giftIdVsNameMap.put(gift.id__c,gift.name);
        
        masssend.Daysflag = true;
        masssend.contactVsValidAddress.put(con11,'Valid Address');
        masssend.customSendGift();
        masssend.idVal = con11.id;
        masssend.setWrapperVal();
        masssend.proceed();
        
        
        
        
      //  masssend.createRecordsAfterEGiftCallout('test','test','test','test', 'gift',contactId);
        masssend.E_GiftName  ='';
        masssend.greetSelected = 'Other';
        masssend.otherSalution = 'Other';
        masssend.sendGift();
        masssend.sendMassEGiftCallout(contactId, 'test','test','test','test','test','test','test','test',false,'test',1);
        Test.stopTest();
        
        
    }
    
    
      private static testmethod void test2March(){
        
        List<Lead> conList = new List<Lead>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Lead con11 = new Lead();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.phone ='9871234560';
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.Company = 'test';
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
        
        Corporate_gift__GiftingSetup__c  merchant = new Corporate_gift__GiftingSetup__c ();
        merchant.Corporate_gift__Merchant_Id__c = 'testMerchant1';
        merchant.Corporate_gift__Security_Header__c = 'testSecurityHeader1';
        insert merchant;
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        PageReference pageRef = Page.MassGiftSendPageLead; // Add your VF page Name here
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        MassGiftSendControllerLead masssend = new MassGiftSendControllerLead(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.E_GiftName = 'test';
        masssend.giftSelected = gift.id__c;
        
        masssend.invalidContactWrapper.add(new MassGiftSendControllerLead.wrapperClass(true,con11));
        masssend.giftVsIdMap.put(gift.id__c,gift.id);
        masssend.giftIdVsNameMap.put(gift.id__c,gift.name);
        
        masssend.Daysflag = true;
        masssend.contactVsValidAddress.put(con11,'Valid Address');
        masssend.customSendGift();
        masssend.idVal = con11.id;
        masssend.setWrapperVal();
        masssend.proceed();
        
        
        
        
      //  masssend.createRecordsAfterEGiftCallout('test','test','test','test', 'gift',contactId);
        masssend.E_GiftName  ='';
        masssend.greetSelected = 'Other';
        masssend.otherSalution = 'Other';
        masssend.sendGift();
      //  masssend.sendMassEGiftCallout(contactId, 'test','test',con11.id,'test','test','test','test','test',false);
        Test.stopTest();
        
        
    }
    
    
    private static testmethod void test5(){
        
        List<Lead> conList = new List<Lead>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Lead con11 = new Lead();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.phone ='9871234560';
        con11.Last_Gift_Send__c =Date.today()-25;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.Company = 'test';
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
        
        Corporate_gift__GiftingSetup__c  merchant = new Corporate_gift__GiftingSetup__c ();
        merchant.Corporate_gift__Merchant_Id__c = 'testMerchant1';
        merchant.Corporate_gift__Security_Header__c = 'testSecurityHeader1';
        merchant.Corporate_gift__Enable_gift_frequency__c = true;
        insert merchant;
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        PageReference pageRef = Page.MassGiftSendPageLead; // Add your VF page Name here
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        
        MassGiftSendControllerLead masssend = new MassGiftSendControllerLead(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.giftSelected = gift.id__c;
        masssend.contactVsValidAddress.put(con11,'Valid Address');
        masssend.customSendGift();
        
     
        
        Test.stopTest();
        
        
    }
    
    
    private static testmethod void test5March(){
        
        List<Lead> conList = new List<Lead>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Lead con11 = new Lead();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.phone ='9871234560';
        con11.Last_Gift_Send__c =Date.today()-25;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.Company = 'test';
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
        
        Corporate_gift__GiftingSetup__c  merchant = new Corporate_gift__GiftingSetup__c ();
        merchant.Corporate_gift__Merchant_Id__c = 'testMerchant1';
        merchant.Corporate_gift__Security_Header__c = 'testSecurityHeader1';
        merchant.Corporate_gift__Enable_gift_frequency__c = true;
        insert merchant;
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        PageReference pageRef = Page.MassGiftSendPageLead; // Add your VF page Name here
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        
      
        
        E_GiftSendControllerLead emassgift = new E_GiftSendControllerLead(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        emassgift.contactVsValidAddress.put(con11,'Valid Address');
        emassgift.recipientSelected = 'Include Just Recipient First Name';
        emassgift.customSendGift();
        
        Test.stopTest();
        
        
    }
    
    
    private static testmethod void test6(){
        
        List<Lead> conList = new List<Lead>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        
        
        Lead con11 = new Lead();
        con11.FirstName ='testcon';
        con11.LastName = 'NewTest';
        con11.phone ='9871234560';
        con11.Last_Gift_Send__c =Date.today()-35;
        con11.Gift_Name__c ='test gift';
        con11.Gift_Id__c ='00213';
        con11.email = 'test@test.com';
        con11.Company = 'test';
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
        
        Corporate_gift__GiftingSetup__c  merchant = new Corporate_gift__GiftingSetup__c ();
        merchant.Corporate_gift__Merchant_Id__c = 'testMerchant1';
        merchant.Corporate_gift__Security_Header__c = 'testSecurityHeader1';
        merchant.Corporate_gift__Enable_gift_frequency__c = true;
        insert merchant;
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        PageReference pageRef = Page.MassGiftSendPageLead; // Add your VF page Name here
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
        setcontroller.setSelected(conList);
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        MassGiftSendControllerLead masssend = new MassGiftSendControllerLead(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.giftSelected = gift.id__c;
        
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        
        E_GiftSendControllerLead emassgift = new E_GiftSendControllerLead(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        emassgift.invalidContactWrapper.add(new E_GiftSendControllerLead.wrapperClass(true,con11));
        emassgift.recipientSelected = 'Include Just Recipient Last Name';
        emassgift.customSendGift();
        emassgift.idVal = con11.id;
        emassgift.setWrapperVal();
        emassgift.proceed();
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        GiftSendFromContactPage giftContactPage = new GiftSendFromContactPage();
        Test.stopTest();
    }
    
    
}