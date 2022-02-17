@Istest
private class GiftSendFromContactController_Test {
    
    private static testmethod void test1(){
        
        Try{
            
            List<Contact> conList = new List<Contact>();
            Account ac = new Account();
            ac.name = 'Abhi';
            ac.BillingCity = '';
            ac.BillingCountry = '';
            ac.BillingPostalCode = '';
            ac.BillingState = '';
            ac.BillingStreet = '';
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
            con.MailingState = 'UP';
            con.Gift_Id__c ='00213';
            insert con;
            conList.add(con);
            
            Contact con1 = new Contact();
            con1.Email ='testextar@hicglobalsolutions.com';
            con1.FirstName ='testcon';
            con1.LastName = 'NewTest';
            con1.Message__c ='test 1message';
            con1.phone ='9871234560';
            con1.AccountId = ac.Id;
            con1.Last_Gift_Send__c =Date.today()-35;
            con1.Gift_Name__c ='test gift';
            con.MailingCity ='';
            con.MailingCountry ='';
            con.MailingStreet ='';
            con.MailingPostalCode ='';
            con.MailingState = '';
            con1.Gift_Id__c ='00213';
            insert con1;
            conList.add(con1);
            Set<String> conSetId = new set<String>{con.Id,con1.id};
                
                System.assert(con.id!=null);
            
            Profile prof = [select id from profile where Name='System Administrator' limit 1];
            User user = new User();
            user.firstName = 'test1';
            user.lastName = 'test2';
            user.profileId = prof.id;
            user.username = 'testfinal@test.com';
            user.email = 'test@test.com';
            user.Gift__c = 'Test';
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
            
            
            
            String testLbl = Label.GreetingLabel;
            String testLbl1 = Label.Recipient_Name;
            
            Corporate_gift__GiftingSetup__c giftMerchantObj = new Corporate_gift__GiftingSetup__c();
            giftMerchantObj.Corporate_gift__Merchant_Id__c = '11';
            giftMerchantObj.Corporate_gift__Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
            giftMerchantObj.Corporate_gift__Enable_gift_frequency__c = true;
            insert giftMerchantObj;
            
            PageReference pageRef = Page.GiftSendFromContactPageClassic; // Add your VF page Name here
            pageRef.getParameters().put('id', con.id);
            
            Test.setCurrentPage(pageRef);
            Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
            
            //ApexPages.currentPage().getParameters().put('SetId',conSetId);
            
            Test.startTest();
            GiftSendFromContactController giftSend = new GiftSendFromContactController();
            giftSend.giftSelected = gift.id__c;
            
            Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
            giftSend.recipientSelected = 'Include Just Recipient Last Name';
            giftSend.sendGift();
            giftSend.errorClose();
            giftSend.showMag();
            GiftSendFromContactController.wrapContact wrap = new GiftSendFromContactController.wrapContact();
            Test.stopTest();
        }catch(Exception ex){
            
        }
        
    }
    
    private static testmethod void test2(){
        
        
        
        List<Contact> conList = new List<Contact>();
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
        /*con.MailingCity ='Noida';
con.MailingCountry ='India';
con.MailingStreet ='Sector 2';
con.MailingPostalCode ='201301';
con.MailingState = 'UP';*/
        con.Gift_Id__c ='00213';
        insert con;
        conList.add(con);
        
        Contact con1 = new Contact();
        con1.Email ='testextar@hicglobalsolutions.com';
        con1.FirstName ='testcon';
        con1.LastName = 'NewTest';
        con1.Message__c ='test 1message';
        con1.phone ='9871234560';
        con1.AccountId = ac.Id;
        con1.Last_Gift_Send__c =Date.today()-35;
        con1.Gift_Name__c ='test gift';
        con1.Gift_Id__c ='00213';
        insert con1;
        conList.add(con1);
        Set<String> conSetId = new set<String>{con.Id,con1.id};
            
            System.assert(con.id!=null);
        
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
        
        
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        Corporate_gift__GiftingSetup__c giftMerchantObj = new Corporate_gift__GiftingSetup__c();
        giftMerchantObj.Corporate_gift__Merchant_Id__c = '11';
        giftMerchantObj.Corporate_gift__Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
        insert giftMerchantObj;
        
        PageReference pageRef = Page.GiftSendFromContactPageClassic; // Add your VF page Name here
        pageRef.getParameters().put('id', con.id);
        
        Test.setCurrentPage(pageRef);
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        //ApexPages.currentPage().getParameters().put('SetId',conSetId);
        
        Test.startTest();
        GiftSendFromContactController giftSend = new GiftSendFromContactController();
        giftSend.giftSelected = gift.id__c;
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        giftSend.isEgift = true;
        giftSend.recipientSelected = 'Include Just Recipient First Name';
        giftSend.sendGift();
        
        GiftSendFromContactController.wrapContact wrap = new GiftSendFromContactController.wrapContact();
        Test.stopTest();
        
    }
    
    private static testmethod void test3(){
        
        
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        Lead ld = new Lead();
        ld.FirstName ='Test';
        ld.LastName ='Test';
        ld.Last_Gift_send__c =Date.today()-10;
        ld.Email ='test@test.com';
        ld.Company ='Test Company';
        ld.Street = '';
        ld.City = '';
        ld.PostalCode = '';
        ld.Status  = '';
        ld.Country = '';
        insert ld;
        
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
        con.MailingState = 'UP';
        con.Gift_Id__c ='00213';
        insert con;
        conList.add(con);
        
        Contact con1 = new Contact();
        con1.Email ='testextar@hicglobalsolutions.com';
        con1.FirstName ='testcon';
        con1.LastName = 'NewTest';
        con1.Message__c ='test 1message';
        con1.phone ='9871234560';
        con1.AccountId = ac.Id;
        con1.Last_Gift_Send__c =Date.today()-35;
        con1.Gift_Name__c ='test gift';
        con1.Gift_Id__c ='00213';
        insert con1;
        conList.add(con1);
        Set<String> conSetId = new set<String>{con.Id,con1.id};
            
            System.assert(con.id!=null);
        
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
        
        
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        Corporate_gift__GiftingSetup__c giftMerchantObj = new Corporate_gift__GiftingSetup__c();
        giftMerchantObj.Corporate_gift__Merchant_Id__c = '11';
        giftMerchantObj.Corporate_gift__Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
        giftMerchantObj.Corporate_gift__Enable_gift_frequency__c = true;
        insert giftMerchantObj;
        
        PageReference pageRef = Page.GiftSendFromContactPageClassic; // Add your VF page Name here
        pageRef.getParameters().put('id', ld.id);
        
        Test.setCurrentPage(pageRef);
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        //ApexPages.currentPage().getParameters().put('SetId',conSetId);
        
        Test.startTest();
        GiftSendFromContactController giftSend = new GiftSendFromContactController();
        giftSend.giftSelected = gift.id__c;
        
        try{
            GiftSendFromContactController obj = new GiftSendFromContactController();
            obj.closePopup();
        }catch(Exception e){
            
        }
        
        try{
            GiftSendFromContactController obj1 = new GiftSendFromContactController();
            obj1.showPopup();
        }catch(Exception e){
            
        }
        
        try{
            GiftSendFromContactController obj2 = new GiftSendFromContactController();
            obj2.sendGiftTypeMethod();
        }catch(Exception e){
            
        }
        
        try{
            GiftSendFromContactController obj3 = new GiftSendFromContactController();
            obj3.customSendGift();
        }catch(Exception e){
            
        }
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        giftSend.isEgift = true;
        giftSend.sendGift();
        
        GiftSendFromContactController.wrapContact wrap = new GiftSendFromContactController.wrapContact();
        
        Test.stopTest();
        
    }
    
    private static testmethod void test4(){
        
        
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        Lead ld = new Lead();
        ld.FirstName ='Test';
        ld.LastName ='Test';
        ld.Last_Gift_send__c =Date.today()-10;
        //ld.Email ='test@test.com';
        ld.Company ='Test Company';
        insert ld;
        
        Contact con = new Contact();
        con.Email ='abhishek@hicglobalsolutions.com';
        con.FirstName ='Abhi';
        con.LastName = 'Gupta';
        con.Message__c ='test message';
        con.phone ='123456789';
        con.AccountId = ac.Id;
        con.Last_Gift_Send__c =Date.today()-15;
        con.Gift_Name__c ='test gift';
        /*  con.MailingCity ='Noida';
con.MailingCountry ='India';
con.MailingStreet ='Sector 2';
con.MailingPostalCode ='201301';
con.MailingState = 'UP';*/
        con.Gift_Id__c ='00213';
        insert con;
        conList.add(con);
        
        Contact con1 = new Contact();
        con1.Email ='testextar@hicglobalsolutions.com';
        con1.FirstName ='testcon';
        con1.LastName = 'NewTest';
        con1.Message__c ='test 1message';
        con1.phone ='9871234560';
        con1.AccountId = ac.Id;
        con1.Last_Gift_Send__c =Date.today()-35;
        con1.Gift_Name__c ='test gift';
        con1.Gift_Id__c ='00213';
        insert con1;
        conList.add(con1);
        Set<String> conSetId = new set<String>{con.Id,con1.id};
            
            System.assert(con.id!=null);
        
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
        
        
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        Corporate_gift__GiftingSetup__c giftMerchantObj = new Corporate_gift__GiftingSetup__c();
        giftMerchantObj.Corporate_gift__Merchant_Id__c = '11';
        giftMerchantObj.Corporate_gift__Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
        insert giftMerchantObj;
        
        PageReference pageRef = Page.GiftSendFromContactPageClassic; // Add your VF page Name here
        pageRef.getParameters().put('id', ld.id);
        
        Test.setCurrentPage(pageRef);
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        //ApexPages.currentPage().getParameters().put('SetId',conSetId);
        
        Test.startTest();
        GiftSendFromContactController giftSend = new GiftSendFromContactController();
        giftSend.giftSelected = gift.id__c;
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        giftSend.isEgift = true;
        giftSend.sendGift();
        
        GiftSendFromContactController.wrapContact wrap = new GiftSendFromContactController.wrapContact();
        Test.stopTest();
        
    }
    
    private static testmethod void test7(){
        
        
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        Lead ld = new Lead();
        ld.FirstName ='Test';
        ld.LastName ='Test';
        ld.Last_Gift_send__c =Date.today()-10;
        ld.Email ='test@test.com';
        ld.Company ='Test Company';
        insert ld;
        
        Contact con = new Contact();
        con.Email ='abhishek@hicglobalsolutions.com';
        con.FirstName ='Abhi';
        con.LastName = 'Gupta';
        con.Message__c ='test message';
        con.phone ='123456789';
        con.AccountId = ac.Id;
        con.Last_Gift_Send__c =Date.today()-15;
        con.Gift_Name__c ='test gift';
        /*  con.MailingCity ='Noida';
con.MailingCountry ='India';
con.MailingStreet ='Sector 2';
con.MailingPostalCode ='201301';
con.MailingState = 'UP';*/
        con.Gift_Id__c ='00213';
        insert con;
        conList.add(con);
        
        Contact con1 = new Contact();
        con1.Email ='testextar@hicglobalsolutions.com';
        con1.FirstName ='testcon';
        con1.LastName = 'NewTest';
        con1.Message__c ='test 1message';
        con1.phone ='9871234560';
        con1.AccountId = ac.Id;
        con1.Last_Gift_Send__c =Date.today()-35;
        con1.Gift_Name__c ='test gift';
        con1.Gift_Id__c ='00213';
        insert con1;
        conList.add(con1);
        Set<String> conSetId = new set<String>{con.Id,con1.id};
            
            System.assert(con.id!=null);
        
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
        
        
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        Corporate_gift__GiftingSetup__c giftMerchantObj = new Corporate_gift__GiftingSetup__c();
        giftMerchantObj.Corporate_gift__Merchant_Id__c = '11';
        giftMerchantObj.Corporate_gift__Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
        insert giftMerchantObj;
        
        PageReference pageRef = Page.GiftSendFromContactPageClassic; // Add your VF page Name here
        pageRef.getParameters().put('id', ld.id);
        
        Test.setCurrentPage(pageRef);
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        //ApexPages.currentPage().getParameters().put('SetId',conSetId);
        
        Test.startTest();
        
        GiftSendFromContactController giftSend = new GiftSendFromContactController();
        giftSend.giftSelected = gift.id__c;
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        giftSend.isEgift = true;
        giftSend.sendGift();
        
        GiftSendFromContactController.wrapContact wrap = new GiftSendFromContactController.wrapContact();
        Test.stopTest();
        
    }
    
    private static testmethod void test8(){
        
        
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        Lead ld = new Lead();
        ld.FirstName ='Test';
        ld.LastName ='Test';
        ld.Last_Gift_send__c =Date.today()-10;
        //  ld.Email ='test@test.com';
        ld.Company ='Test Company';
        ld.City = 'test';
        ld.Street = 'test';
        ld.PostalCode = '123456';
        ld.State = 'test';
        insert ld;
        
        Contact con = new Contact();
        con.Email ='abhishek@hicglobalsolutions.com';
        con.FirstName ='Abhi';
        con.LastName = 'Gupta';
        con.Message__c ='test message';
        con.phone ='123456789';
        con.AccountId = ac.Id;
        con.Last_Gift_Send__c =Date.today()-15;
        con.Gift_Name__c ='test gift';
        /*con.MailingCity ='Noida';
con.MailingCountry ='India';
con.MailingStreet ='Sector 2';
con.MailingPostalCode ='201301';
con.MailingState = 'UP';*/
        con.Gift_Id__c ='00213';
        insert con;
        conList.add(con);
        
        Contact con1 = new Contact();
        con1.Email ='testextar@hicglobalsolutions.com';
        con1.FirstName ='testcon';
        con1.LastName = 'NewTest';
        con1.Message__c ='test 1message';
        con1.phone ='9871234560';
        con1.AccountId = ac.Id;
        con1.Last_Gift_Send__c =Date.today()-35;
        con1.Gift_Name__c ='test gift';
        con1.Gift_Id__c ='00213';
        /*con.MailingCity =null;
con.MailingCountry =' ';
con.MailingStreet =null;
con.MailingPostalCode =null;
con.MailingState = null;*/
        insert con1;
        conList.add(con1);
        Set<String> conSetId = new set<String>{con.Id,con1.id};
            
            System.assert(con.id!=null);
        
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
        
        
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        Corporate_gift__GiftingSetup__c giftMerchantObj = new Corporate_gift__GiftingSetup__c();
        giftMerchantObj.Corporate_gift__Merchant_Id__c = '11';
        giftMerchantObj.Corporate_gift__Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
        insert giftMerchantObj;
        
        PageReference pageRef = Page.GiftSendFromContactPageClassic; // Add your VF page Name here
        pageRef.getParameters().put('id', ld.id);
        
        Test.setCurrentPage(pageRef);
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        //ApexPages.currentPage().getParameters().put('SetId',conSetId);
        Test.startTest();
        
        GiftSendFromContactController giftSend = new GiftSendFromContactController();
        giftSend.giftSelected = gift.id__c;
        giftSend.recipientSelected = 'Include Just Recipient First Name';
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        giftSend.isEgift = false;
        giftSend.sendGift();
        
        GiftSendFromContactController.wrapContact wrap = new GiftSendFromContactController.wrapContact();
        Test.stopTest();
        
    }
    private static testmethod void test5(){
        
        
        
        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        Contact con = new Contact();
        //con.Email ='abhishek@hicglobalsolutions.com';
        con.FirstName ='Abhi';
        con.LastName = 'Gupta';
        con.Message__c ='test message';
        con.phone ='123456789';
        con.AccountId = ac.Id;
        con.Last_Gift_Send__c =Date.today()-15;
        con.Gift_Name__c ='test gift';
        /*  con.MailingCity ='Noida';
con.MailingCountry ='India';
con.MailingStreet ='Sector 2';
con.MailingPostalCode ='201301';
con.MailingState = 'UP';*/
        con.Gift_Id__c ='00213';
        insert con;
        conList.add(con);
        
        Contact con1 = new Contact();
        con1.Email ='testextar@hicglobalsolutions.com';
        con1.FirstName ='testcon';
        con1.LastName = 'NewTest';
        con1.Message__c ='test 1message';
        con1.phone ='9871234560';
        con1.AccountId = ac.Id;
        con1.Last_Gift_Send__c =Date.today()-35;
        con1.Gift_Name__c ='test gift';
        con1.Gift_Id__c ='00213';
        insert con1;
        conList.add(con1);
        Set<String> conSetId = new set<String>{con.Id,con1.id};
            
            System.assert(con.id!=null);
        
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
        gift.id__c = 'empty';
        gift.name = 'None';
        gift.Description__c = null;
        gift.Price__c = null;
        gift.Corporate_gift__Gift_Image__c = null;
        gift.Name ='test gift';
        gift.id__c ='9876';
        gift.isActive__c = true;
        insert gift;
        
        System.assert(gift.id!=null);
        
        /* products__c gift0 = new products__c();
gift0.id__c = 'empty';
gift0.name = 'None';
gift0.Description__c = null;
gift0.Price__c = null;
gift0.Corporate_gift__Gift_Image__c = null;
insert gift0;

System.assert(gift0.id!=null);*/
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        Corporate_gift__GiftingSetup__c giftMerchantObj = new Corporate_gift__GiftingSetup__c();
        giftMerchantObj.Corporate_gift__Merchant_Id__c = '11';
        giftMerchantObj.Corporate_gift__Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
        insert giftMerchantObj;
        
        PageReference pageRef = Page.GiftSendFromContactPageClassic; // Add your VF page Name here
        pageRef.getParameters().put('id', con.id);
        
        Test.setCurrentPage(pageRef);
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        //ApexPages.currentPage().getParameters().put('SetId',conSetId);
        
        Test.startTest();
        GiftSendFromContactController giftSend = new GiftSendFromContactController();
        giftSend.giftSelected = gift.id__c;
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        giftSend.recipientSelected = 'Include Both First and Last Name (Recommended)';
        giftSend.sendGift();
        giftSend.errorClose();
        giftSend.showMag();
        giftSend.setWrapperVal();
        GiftSendFromContactController.wrapContact wrap = new GiftSendFromContactController.wrapContact();
        Test.stopTest();
        
    }
    
    
    private static testmethod void test6(){
        
        
        
        List<Contact> conList = new List<Contact>();
        List<products__c> proLst = new List<products__c>();
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
        /*  con.MailingCity ='Noida';
con.MailingCountry ='India';
con.MailingStreet ='Sector 2';
con.MailingPostalCode ='201301';
con.MailingState = 'UP';*/
        con.Gift_Id__c ='00213';
        insert con;
        conList.add(con);
        
        Contact con1 = new Contact();
        con1.Email ='testextar@hicglobalsolutions.com';
        con1.FirstName ='testcon';
        con1.LastName = 'NewTest';
        con1.Message__c ='test 1message';
        con1.phone ='9871234560';
        con1.AccountId = ac.Id;
        con1.Last_Gift_Send__c =Date.today()-35;
        con1.Gift_Name__c ='test gift';
        con1.Gift_Id__c ='00213';
        insert con1;
        conList.add(con1);
        Set<String> conSetId = new set<String>{con.Id,con1.id};
            
            System.assert(con.id!=null);
        
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
        
        
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        Corporate_gift__GiftingSetup__c giftMerchantObj = new Corporate_gift__GiftingSetup__c();
        giftMerchantObj.Corporate_gift__Merchant_Id__c = '11';
        giftMerchantObj.Corporate_gift__Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
        insert giftMerchantObj;
     
        
        PageReference pageRef = Page.GiftSendFromContactPageClassic; // Add your VF page Name here
        pageRef.getParameters().put('id', con.id);
        
        Test.setCurrentPage(pageRef);
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        //ApexPages.currentPage().getParameters().put('SetId',conSetId);
        
        Test.startTest();
        GiftSendFromContactController giftSend = new GiftSendFromContactController();
        giftSend.giftSelected = gift.id__c;
        
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        giftSend.sendGift();
        giftSend.errorClose();
        giftSend.showMag();
        giftSend.customSendGift();
        //  giftSend.setWrapperVal();
        giftSend.proceed();
        GiftSendFromContactController.wrapContact wrap = new GiftSendFromContactController.wrapContact();
        
        Test.stopTest();
        
    }
    
    private static testmethod void testAccountCallout(){   
        
        List<Contact> conList = new List<Contact>();
        List<account> acclist = new List<account>();
        Account ac = new Account();
        ac.name = 'Abhi';
        ac.BillingStreet = 'Street';
        ac.BillingCity = 'California';
        ac.BillingState = 'USA';
        ac.BillingPostalCode = '1231234';
        insert ac;
        acclist.add(ac);
        
        Contact con = new Contact();
        con.Email ='abhishek@hicglobalsolutions.com';
        con.FirstName ='Abhi';
        con.LastName = 'Gupta';
        con.Message__c ='test message';
        con.phone ='123456789';
        con.AccountId = ac.Id;
        con.Last_Gift_Send__c =Date.today()-15;
        con.Gift_Name__c ='test gift';
        con.Gift_Id__c ='00213';
        insert con;
        conList.add(con);
        
        Contact con1 = new Contact();
        con1.Email ='testextar@hicglobalsolutions.com';
        con1.FirstName ='testcon';
        con1.LastName = 'NewTest';
        con1.Message__c ='test 1message';
        con1.phone =null;
        con1.AccountId = ac.Id;
        con1.Last_Gift_Send__c =Date.today();
        con1.Gift_Name__c ='test gift';
        con1.Gift_Id__c ='00213';
        insert con1;
        conList.add(con1);
        
        
        
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
        gift.id__c ='1234';
        gift.Description__c = null;
        gift.Price__c = null;
        gift.Corporate_gift__Gift_Image__c = null;
        gift.isActive__c = true;
        
        insert gift;
        
        System.assert(gift.id!=null);
        
        products__c gift3 = new products__c();
        gift3.Name ='test gift';
        gift3.id__c ='123';
        gift3.Description__c = null;
        gift3.Price__c = null;
        gift3.Corporate_gift__Gift_Image__c = null;
        gift3.isActive__c = true;
        insert gift3;
        
        System.assert(gift3.id!=null);
        
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
        GiftSendFromContactController masssend = new GiftSendFromContactController();
        //Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        masssend.giftSelected = gift.id__c;
         FinalSendGift_Class.BillingAddressCustom billingCustom = new FinalSendGift_Class.BillingAddressCustom();
        billingCustom.billingStreet = 'billingStreet';
        billingCustom.billingPostalCode = 'billingPostalCode';
        billingCustom.billingState = 'billingState';
        billingCustom.billingCity = 'billingCity';
        masssend.sendGiftAccountCallout(ContactId ,billingCustom,'giftId' ,'message' ,'greeting' ,'recipientName' ,'giftName' ,'P_gift' ,'recId', 'budgetSelected',1);
        
        
        
        Test.stopTest();
        
    }
    
    private static testmethod void testAccountCallout_2(){   
        
        List<Contact> conList = new List<Contact>();
        List<account> acclist = new List<account>();
        Account ac = new Account();
        ac.name = 'Abhi';
        ac.BillingStreet = 'Street';
        ac.BillingCity = 'California';
        ac.BillingState = 'USA';
        ac.BillingPostalCode = '1231234';
        insert ac;
        acclist.add(ac);
        
        Contact con = new Contact();
        con.Email ='abhishek@hicglobalsolutions.com';
        con.FirstName ='Abhi';
        con.LastName = 'Gupta';
        con.Message__c ='test message';
        con.phone ='123456789';
        con.AccountId = ac.Id;
        con.Last_Gift_Send__c =Date.today()-15;
        con.Gift_Name__c ='test gift';
        con.Gift_Id__c ='00213';
        insert con;
        conList.add(con);
        
        Contact con1 = new Contact();
        con1.Email ='testextar@hicglobalsolutions.com';
        con1.FirstName ='testcon';
        con1.LastName = 'NewTest';
        con1.Message__c ='test 1message';
        con1.phone ='9871234560';
        con1.AccountId = ac.Id;
        con1.Last_Gift_Send__c =Date.today()-35;
        con1.Gift_Name__c ='test gift';
        con1.Gift_Id__c ='00213';
        insert con1;
        conList.add(con1);
        
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
        gift.id__c ='1234';
        gift.Description__c = null;
        gift.Price__c = null;
        gift.Corporate_gift__Gift_Image__c = null;
        gift.isActive__c = true;
        insert gift;
        
        System.assert(gift.id!=null);
        
        products__c gift3 = new products__c();
        gift3.Name ='test gift';
        gift3.id__c ='123';
        gift3.Description__c = null;
        gift3.Price__c = null;
        gift3.Corporate_gift__Gift_Image__c = null;
        gift3.isActive__c = true;
        insert gift3;
        
        System.assert(gift3.id!=null);
        
        Corporate_gift__GiftingSetup__c giftMerchantObj = new Corporate_gift__GiftingSetup__c();
        giftMerchantObj.Corporate_gift__Merchant_Id__c = '11';
        giftMerchantObj.Corporate_gift__Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
        insert giftMerchantObj;
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2_2());
        Test.startTest();
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        //Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(acclist);
        setcontroller.setSelected(acclist);
        GiftSendFromContactController masssend = new GiftSendFromContactController();
        
        
        masssend.giftSelected = gift.id__c;
         FinalSendGift_Class.BillingAddressCustom billingCustom = new FinalSendGift_Class.BillingAddressCustom();
        billingCustom.billingStreet = 'billingStreet';
        billingCustom.billingPostalCode = 'billingPostalCode';
        billingCustom.billingState = 'billingState';
        billingCustom.billingCity = 'billingCity';
        masssend.sendGiftAccountCallout(ContactId ,billingCustom,'giftId' ,'message' ,'greeting' ,'recipientName' ,'giftName' ,'giftType' ,'recId', 'budgetSelected',1);
        
        
        
        Test.stopTest();
        
    }
    private static testmethod void testAccountCallout_3(){   
        
        List<Contact> conList = new List<Contact>();
        List<account> acclist = new List<account>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        acclist.add(ac);
        
        Contact con = new Contact();
        con.Email ='abhishek@hicglobalsolutions.com';
        con.FirstName ='Abhi';
        con.LastName = 'Gupta';
        con.Message__c ='test message';
        con.phone ='123456789';
        con.AccountId = ac.Id;
        con.Last_Gift_Send__c =Date.today()-15;
        con.Gift_Name__c ='test gift';
        con.Gift_Id__c ='00213';
        insert con;
        conList.add(con);
        
        Contact con1 = new Contact();
        con1.Email ='testextar@hicglobalsolutions.com';
        con1.FirstName ='testcon';
        con1.LastName = 'NewTest';
        con1.Message__c ='test 1message';
        con1.phone ='9871234560';
        con1.AccountId = ac.Id;
        con1.Last_Gift_Send__c =Date.today()-35;
        con1.Gift_Name__c ='test gift';
        con1.Gift_Id__c ='00213';
        insert con1;
        conList.add(con1);
        
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
        gift.id__c ='1234';
        gift.Description__c = null;
        gift.Price__c = null;
        gift.Corporate_gift__Gift_Image__c = null;
        gift.isActive__c = true;
        insert gift;
        
        System.assert(gift.id!=null);
        
        products__c gift3 = new products__c();
        gift3.Name ='test gift';
        gift3.id__c ='123';
        gift3.Description__c = null;
        gift3.Price__c = null;
        gift3.Corporate_gift__Gift_Image__c = null;
        gift3.isActive__c = true;
        insert gift3;
        
        System.assert(gift3.id!=null);
        
        Corporate_gift__GiftingSetup__c giftMerchantObj = new Corporate_gift__GiftingSetup__c();
        giftMerchantObj.Corporate_gift__Merchant_Id__c = '11';
        giftMerchantObj.Corporate_gift__Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
        insert giftMerchantObj;
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2_3());
        Test.startTest();
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        //Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(acclist);
        setcontroller.setSelected(acclist);
        //     GiftSendFromContactController masssend = new GiftSendFromContactController();
        
        
        //  masssend.giftSelected = gift.id__c;
        
        //   masssend.sendGiftAccountCallout(ContactId ,'giftId' ,'message' ,'greeting' ,'recipientName' ,'giftName' ,'giftType' ,'recId');
        
        
        
        Test.stopTest();
        
    }
    
    private static testmethod void testAccountCallout_33(){   
        
        List<Contact> conList = new List<Contact>();
        List<account> acclist = new List<account>();
        List<products__c> proLst = new List<products__c>();
        
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        acclist.add(ac);
        
        Contact con = new Contact();
        con.Email ='abhishek@hicglobalsolutions.com';
        con.FirstName ='Abhi';
        con.LastName = 'Gupta';
        con.Message__c ='test message';
        con.phone ='123456789';
        con.AccountId = ac.Id;
        con.Last_Gift_Send__c =Date.today()-15;
        con.Gift_Name__c ='test gift';
        con.Gift_Id__c ='00213';
        insert con;
        conList.add(con);
        
        Contact con1 = new Contact();
        con1.Email ='testextar@hicglobalsolutions.com';
        con1.FirstName ='testcon';
        con1.LastName = 'NewTest';
        con1.Message__c ='test 1message';
        con1.phone ='9871234560';
        con1.AccountId = ac.Id;
        con1.Last_Gift_Send__c =Date.today()-35;
        con1.Gift_Name__c ='test gift';
        con1.Gift_Id__c ='00213';
        insert con1;
        conList.add(con1);
        
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
        gift.Name =null;
        gift.id__c =' ';
        gift.Description__c = null;
        gift.Price__c = null;
        gift.Corporate_gift__Gift_Image__c = null;
        gift.isActive__c = true;
        gift.Corporate_gift__id__c = 'test';
        insert gift;
        //proLst.add(gift);        
        
        
        
        System.assert(gift.id!=null);
        
        products__c gift3 = new products__c();
        gift3.Name ='test gift';
        gift3.id__c ='123';
        gift3.Description__c = null;
        gift3.Price__c = null;
        gift3.Corporate_gift__Gift_Image__c = null;
        gift3.isActive__c = true;
        insert gift3;
        
        System.assert(gift3.id!=null);
        
        Corporate_gift__GiftingSetup__c giftMerchantObj = new Corporate_gift__GiftingSetup__c();
        giftMerchantObj.Corporate_gift__Merchant_Id__c = '11';
        giftMerchantObj.Corporate_gift__Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
        insert giftMerchantObj;
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass2());
        Test.startTest();
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        //Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(acclist);
        setcontroller.setSelected(acclist);
        //     GiftSendFromContactController masssend = new GiftSendFromContactController();
        
        
        //  masssend.giftSelected = gift.id__c;
        
        //   masssend.sendGiftAccountCallout(ContactId ,'giftId' ,'message' ,'greeting' ,'recipientName' ,'giftName' ,'giftType' ,'recId');
        
        
        
        Test.stopTest();
        
    }
    
}