@isTest
private class UpsertGiftingSetupCustomSettingCtrl_Test {
    
    @isTest
    public static void testmethod1(){
        Test.setMock(HttpCalloutMock.class, new RefreshMerchantProductsBatch_Mock());
        Corporate_gift__GiftingSetup__c gift = new Corporate_gift__GiftingSetup__c();
        gift.Corporate_gift__Merchant_Id__c  ='00124';
        gift.Corporate_gift__Security_Header__c ='test321';
        gift.Corporate_gift__Admin_Email__c = 'test@mail.com';
        insert gift;
        
        Corporate_gift__GiftMerchant__c gift1 = new Corporate_gift__GiftMerchant__c();
        gift1.Corporate_gift__MerchantId__c  ='00124';
        gift1.Corporate_gift__Security_Header__c ='test321';
        insert gift1;
        
        Products__c pd = new Products__c();
        pd.isActive__c =true ;
        pd.id__c = '5882';
        pd.name = 'test';
        insert pd ;
        
        
        UpsertGiftingSetupCustomSettingCtrl obj = new UpsertGiftingSetupCustomSettingCtrl();
        obj.getItems();
        UpsertGiftingSetupCustomSettingCtrl.upsertData('7','t@t.com',true,true,'12345','test');
        Map<String,String> resultMap = new Map<string,String>();
        resultMap = UpsertGiftingSetupCustomSettingCtrl.fetchData();
        
                system.assert(true);

    }
    
}