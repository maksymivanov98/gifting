@istest
private class ReportSelectionController_Test {
    
    Public static testMethod void getE_Gift(){
        
        try{
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        
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
        /*con.GiftOnTheWay__c = True;
        con.Gift_Name__c ='test gift';
        con.Last_Gift_Send__c = system.today();
        con.Gift_Id__c ='00213';*/
        insert con;
        conList.add(con);
        
        Contact con1 = new Contact();
        // con1.Email ='testextar@hicglobalsolutions.com';
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
            gift.Description__c = null;
            gift.Price__c = null;
            gift.Corporate_gift__Gift_Image__c = null;
            gift.isActive__c = true;
            insert gift;
        
        System.assert(gift.id!=null);
        
        String testLbl = Label.GreetingLabel;
        String testLbl1 = Label.Recipient_Name;
        
        Corporate_gift__GiftingSetup__c giftMerchantObj = new Corporate_gift__GiftingSetup__c();
        giftMerchantObj.Corporate_gift__Merchant_Id__c = '11';
        giftMerchantObj.Corporate_gift__Security_Header__c = 'd761b7b70cc11bc523731fab56f780fc';
        insert giftMerchantObj;
        
        PageReference pageRef = Page.MassGiftSendPage; // Add your VF page Name here
        pageRef.getParameters().put('SetId', Json.serialize(conSetId));
        
        Test.setCurrentPage(pageRef);
            //ApexPages.currentPage().getParameters().put('SetId',conSetId);
            ApexPages.StandardSetController setcontroller = new ApexPages.StandardSetController(conList);
            setcontroller.setSelected(conList);
            Test.startTest();
            E_GiftSendController emassgift = new E_GiftSendController(setcontroller);
            emassgift.sendGift();
            emassgift.customSendGift();
            
            
            
        Test.stopTest();
            
        }catch(Exception ex){
            
        }
    }
    
    @isTest(SeeAllData='true')
    public static void testAsyncReportWithTestData() {
         Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());
        
        List<Contact> conList = new List<Contact>();
        
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
        System.assert(ac.id!=null); 
        
        Contact con = new Contact();
        // con.Email ='abhishek@hicglobalsolutions.com';
        con.FirstName ='Abhi';
        con.LastName = 'Gupta';
        con.Message__c ='test message';
        con.phone ='123456789';
        con.Email = 'test@gmail.com';
        con.AccountId = ac.Id;
        con.Last_Gift_Send__c =Date.today()-15;
        //con.Gift_Name__c ='test gift';
        con.Gift_Id__c ='00213';
        insert con;
        conList.add(con);
        
        Contact con1 = new Contact();
        // con1.Email ='testextar@hicglobalsolutions.com';
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
        gift.Description__c = null;
        gift.Price__c = null;
        gift.Corporate_gift__Gift_Image__c = null;
        gift.isActive__c = true;
        insert gift;
        
        System.assert(gift.id!=null);
        
        products__c gift2 = new products__c();
        gift2.Name ='test gift2';
        gift2.id__c ='9876';
        gift2.Description__c = null;
        gift2.Price__c = null;
		gift2.isActive__c = true;
        insert gift2;
        
        System.assert(gift2.id!=null);
        
        
        Lead LdObj = new Lead();
        LdObj.LastName = 'Test';
        LdObj.company = 'test';
        ldoBj.Email = 'test@gmail.com';
        ldObj.Status = 'Working - Contacted';
        insert LdObj;
        
        Lead LdObj1 = new Lead();
        LdObj1.LastName = 'Test';
        LdObj1.company = 'test';
        LdObj1.Status = 'Working - Contacted';
        insert LdObj1;
        
        Report reportObj = new Report();
        
        Test.startTest();
            ApexPages.StandardController reportObjsc = new ApexPages.StandardController(reportObj);
            ReportSelectionController reportController = new ReportSelectionController(reportObjsc);
         	
        	//For lead
        	reportController.fetchObjectName = 'Lead';  
        	reportController.contactIDSet = new set<Id>{LdObj.id, LdObj1.Id};
        	reportController.giftTypeSelected = 'E-Gift';
        	reportController.sendGiftInit();
        	reportController.sendGift();
        
        	reportController.giftTypeSelected = 'P-Gift';
        	reportController.sendGiftInit();
        	reportController.sendGift();
        
        	//For Account
        	reportController.fetchObjectName = 'Account';
        	reportController.contactIDSet = new set<Id>{ac.id};
            
            reportController.giftTypeSelected = 'E-Gift';
        	reportController.sendGiftInit();
        	reportController.sendGift();
        
        	reportController.giftTypeSelected = 'P-Gift';
        	reportController.sendGiftInit();
        	reportController.sendGift();
        
        
        	//For Contact
        	reportController.fetchObjectName = 'Contact';  
        	reportController.contactIDSet = new set<Id>{con.id, con1.id};
            
            reportController.giftTypeSelected = 'E-Gift';
        	reportController.sendGiftInit();
        	reportController.sendGift();
        
        	reportController.giftTypeSelected = 'P-Gift';
        	reportController.sendGiftInit();
        	reportController.sendGift();
        	
        	list<Report> reportList = new list<Report>();
        	reportList = ReportSelectionController.getReport();
        
        	if( reportList != null && !reportList.isEMpty()){
                reportController.reportId = reportList[0].Id;
                reportController.processReportAction();
            }
        	
        
        	reportController.createRecordsAfterCalloutAccount( '123', '123', gift.Id, 'test','p_gift', new list<String>{Ac.Id},1);
        	reportController.createRecordsAfterContactCallout( new list<String>{'123', '124'}, '123', gift.Id, 'test', 'p_gift', new list<String>{con.Id, con1.Id},1);
        	reportController.createRecordsAfterLeadCallout( new list<String>{'123', '124'}, '123', gift.Id, 'test', 'p_gift', new list<String>{LdObj.Id},1);
        
        
        Test.stopTest();
    }
    @isTest
    public static void TestMethod2() {
         Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2_2());
        
        List<Contact> conList = new List<Contact>();
        
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
        System.assert(ac.id!=null); 
        
        Contact con = new Contact();
        // con.Email ='abhishek@hicglobalsolutions.com';
        con.FirstName ='Abhi';
        con.LastName = 'Gupta';
        con.Message__c ='test message';
        con.phone ='123456789';
        con.Email = 'test@gmail.com';
        con.AccountId = ac.Id;
        con.Last_Gift_Send__c =Date.today()-15;
        //con.Gift_Name__c ='test gift';
        con.Gift_Id__c ='00213';
        insert con;
        conList.add(con);
        
        Contact con1 = new Contact();
        // con1.Email ='testextar@hicglobalsolutions.com';
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
        gift.Description__c = null;
        gift.Price__c = null;
        gift.Corporate_gift__Gift_Image__c = null;
        gift.isActive__c = true;
        insert gift;
        
        System.assert(gift.id!=null);
        
        products__c gift2 = new products__c();
        gift2.Name ='test gift2';
        gift2.id__c ='9876';
        gift2.Description__c = null;
        gift2.Price__c = null;
		gift2.isActive__c = true;
        insert gift2;
        
        System.assert(gift2.id!=null);
        
        
        Lead LdObj = new Lead();
        LdObj.LastName = 'Test';
        LdObj.company = 'test';
        ldoBj.Email = 'test@gmail.com';
        ldObj.Status = 'Working - Contacted';
        insert LdObj;
        
        Lead LdObj1 = new Lead();
        LdObj1.LastName = 'Test';
        LdObj1.company = 'test';
        LdObj1.Status = 'Working - Contacted';
        insert LdObj1;
        
        Report reportObj = new Report();
        
        Test.startTest();
            ApexPages.StandardController reportObjsc = new ApexPages.StandardController(reportObj);
            ReportSelectionController reportController = new ReportSelectionController(reportObjsc);
         	
        	//For lead
        	reportController.fetchObjectName = 'Lead';  
        	reportController.contactIDSet = new set<Id>{LdObj.id, LdObj1.Id};
        	reportController.giftTypeSelected = 'E-Gift';
        	reportController.sendGiftInit();
        	reportController.sendGift();
        
        	reportController.giftTypeSelected = 'P-Gift';
        	reportController.sendGiftInit();
        	reportController.sendGift();
        
        	//For Account
        	reportController.fetchObjectName = 'Account';
        	reportController.contactIDSet = new set<Id>{ac.id};
            
            reportController.giftTypeSelected = 'E-Gift';
        	reportController.sendGiftInit();
        	reportController.sendGift();
        
        	reportController.giftTypeSelected = 'P-Gift';
        	reportController.sendGiftInit();
        	reportController.sendGift();
        
        
        	//For Contact
        	reportController.fetchObjectName = 'Contact';  
        	reportController.contactIDSet = new set<Id>{con.id, con1.id};
            
            reportController.giftTypeSelected = 'E-Gift';
        	reportController.sendGiftInit();
        	reportController.sendGift();
        
        	reportController.giftTypeSelected = 'P-Gift';
        	reportController.sendGiftInit();
        	reportController.sendGift();
        	
        	list<Report> reportList = new list<Report>();
        	reportList = ReportSelectionController.getReport();
        
        	if( reportList != null && !reportList.isEMpty()){
                reportController.reportId = reportList[0].Id;
                reportController.processReportAction();
            }
        	
        
        	reportController.createRecordsAfterCalloutAccount( '123', '123', gift.Id, 'test','p_gift', new list<String>{Ac.Id},1);
        	reportController.createRecordsAfterContactCallout( new list<String>{'123', '124'}, '123', gift.Id, 'test', 'p_gift', new list<String>{con.Id, con1.Id},1);
        	reportController.createRecordsAfterLeadCallout( new list<String>{'123', '124'}, '123', gift.Id, 'test', 'p_gift', new list<String>{LdObj.Id},1);
       
        set<String> ContactIds = new set<String>();
        ContactIds.add(con.Id);
        ContactIds.add(con1.Id);
        map<String, String> recordIdVsEmail = new map<String, String>();
        
        reportController.createRecordsAfterEGiftContactCallout('test' ,'1234','test1','test2',ContactIds,
                                                        'test3',recordIdVsEmail , recordIdVsEmail,1);
        
        
     
        
        Test.stopTest();
    }
}