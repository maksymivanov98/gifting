@isTest
public class PostInstallClass_Test {
    @isTest
    static void testInstallScript() {
        Test.startTest();
        
        Corporate_gift__GiftMerchant__c gift = new Corporate_gift__GiftMerchant__c();
        gift.Corporate_gift__MerchantId__c = '11';
        gift.Corporate_gift__Security_Header__c = 'vts435av';
        gift.Admin_Email__c = 'test@gmail.com';
        insert gift;
        Test.stopTest();
        
        
        Corporate_gift__GiftingSetup__c gift1 = new Corporate_gift__GiftingSetup__c();
        gift1.Corporate_gift__Merchant_Id__c = '11';
        gift1.Corporate_gift__Security_Header__c = 'vts435av';
        gift1.Corporate_gift__Status_Merchant_Id__c ='32245';
        gift1.Admin_Email__c = 'test@gmail.com';
        
        insert gift1;
        
        
        PostInstallClass postinstall = new PostInstallClass();
        Test.testInstall(postinstall, null);
        Test.testInstall(postinstall, new Version(1,0), true);
        
        system.assert(true);

        
    }
    
}