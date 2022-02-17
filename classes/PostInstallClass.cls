/*-************************************************************************************************************
* Name         : PostInstallClass
* @Author      : 
* @Date        : 
* @Description : The PostInstallClass class is used for upsert the Gifting setup custom setting record from gift merchant record if present.
* UPDATES
* Version          Developer                    Date                        Description
*-------------------------------------------------------------------------------------------
*     1.0          Nishank Gupta                30 July 2021                 Initial Creation 
***************************************************************************************************************/
global class PostInstallClass implements InstallHandler {
    
    global void onInstall(InstallContext context) {
        
        if(context.previousVersion() == null) {
            
        }else{
            
            if(context.isUpgrade()) {
                
                  createSetting();
            }
            
            
        }
        
    }
    
    global void createSetting(){
        Corporate_gift__GiftingSetup__c setting = Corporate_gift__GiftingSetup__c.getOrgDefaults();
        
        for(GiftMerchant__c giftSetup : [Select Id ,Corporate_gift__Admin_Email__c,Corporate_gift__Create_task_on_status_change__c,Corporate_gift__Enable_gift_frequency__c,
                                         Corporate_gift__Gift_Frequency__c,Corporate_gift__MerchantId__c,Corporate_gift__Security_Header__c From GiftMerchant__c WITH SECURITY_ENFORCED Limit 1]){
                                             
                                             if(Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Admin_Email__c.isAccessible()       
                                                && Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Admin_Email__c.isCreateable()
                                                &&Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Admin_Email__c.isUpdateable()){
                                                    setting.Corporate_gift__Admin_Email__c = giftSetup.Corporate_gift__Admin_Email__c;
                                                }
                                             if(Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Create_task_on_status_change__c.isAccessible()       
                                                && Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Create_task_on_status_change__c.isCreateable()
                                                &&Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Create_task_on_status_change__c.isUpdateable()){
                                                    setting.Corporate_gift__Create_task_on_status_change__c = giftSetup.Corporate_gift__Create_task_on_status_change__c;
                                                }
                                             if(Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Enable_gift_frequency__c.isAccessible()       
                                                && Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Enable_gift_frequency__c.isCreateable()
                                                &&Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Enable_gift_frequency__c.isUpdateable()){
                                                    setting.Corporate_gift__Enable_gift_frequency__c = giftSetup.Corporate_gift__Enable_gift_frequency__c;
                                                }
                                             if(Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Gift_Frequency__c.isAccessible()       
                                                && Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Gift_Frequency__c.isCreateable()
                                                &&Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Gift_Frequency__c.isUpdateable()){
                                                    setting.Corporate_gift__Gift_Frequency__c = giftSetup.Corporate_gift__Gift_Frequency__c;
                                                }
                                             if(Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Merchant_Id__c.isAccessible()       
                                                && Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Merchant_Id__c.isCreateable()
                                                &&Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Merchant_Id__c.isUpdateable()){
                                                    setting.Corporate_gift__Merchant_Id__c = giftSetup.Corporate_gift__MerchantId__c;
                                                }
                                             if(Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Security_Header__c.isAccessible()       
                                                && Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Security_Header__c.isCreateable()
                                                &&Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Security_Header__c.isUpdateable()){
                                                    setting.Corporate_gift__Security_Header__c = giftSetup.Corporate_gift__Security_Header__c;
                                                }                   
                                         }
        
        try{
            if(setting != null && Schema.sObjectType.Corporate_gift__GiftingSetup__c.isAccessible()       
               && Schema.sObjectType.Corporate_gift__GiftingSetup__c.isCreateable()
               &&Schema.sObjectType.Corporate_gift__GiftingSetup__c.isUpdateable()){
                   upsert setting;
               }
        }catch(Exception e){
            system.debug('Error msg - '+e.getLineNumber()+' '+e.getMessage()+' '+e.getCause());
        }
    }
}