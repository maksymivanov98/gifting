@isTest
public class RefreshMerchantProductsBatch_Test {
@isTest
    public static void test1(){
        Test.setMock(HttpCalloutMock.class, new RefreshMerchantProductsBatch_Mock());
        GiftMerchantId__c customsetting = new GiftMerchantId__c();
        customsetting.name='First';
        customsetting.Id__c='001';
        insert customsetting;
        
        System.assert(customsetting.id!=null);
        
        Database.executeBatch(new RefreshMerchantProducts(),1);
    }
}