@istest
public class E_GiftSendController_Test {
    @istest
    Public static void getE_Gift(){
        

        List<Contact> conList = new List<Contact>();
        Account ac = new Account();
        ac.name = 'Abhi';
        insert ac;
        System.assert(ac.id!=null); 
        
        Contact con = new Contact();
       // con.Email ='abhishek@hicglobalsolutions.com';
        con.FirstName ='Abhi';
        con.LastName = 'Gupta';
        con.Message__c ='test message';
        con.phone ='123456789';
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
        Test.setMock(HttpCalloutMock.class, new GetAvailableGiftMockTestClass());

        Test.startTest();
        E_GiftSendController emassgift = new E_GiftSendController(setcontroller);
        Test.setMock(HttpCalloutMock.class, new TestHttpCalloutMock2());

        emassgift.sendGift();
        emassgift.customSendGift();
        Test.stopTest();
    }


    
    
}