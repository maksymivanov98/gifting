public with sharing class UpsertGiftingSetupCustomSettingCtrl {
    public String name{get; set;}
    public String selectedValue{get; set;}
    public String adminEmail{get; set;}
    public Boolean createTaskOnStatusChange{get; set;}
    public Boolean enableGiftFrequency{get; set;}
    public String merchantId{get; set;}
    public String securityHeader{get; set;}
    public String statusMerchantId{get; set;}
    
    
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('7','7'));
        options.add(new SelectOption('15','15'));
        options.add(new SelectOption('30','30'));
        return options;
    }
    
    @AuraEnabled
    public static String upsertData(String selectedValue,String adminEmail,Boolean createTaskOnStatusChange,Boolean enableGiftFrequency,String merchantId,String securityHeader){
        
        system.debug('save called');
        Corporate_gift__GiftingSetup__c setting = Corporate_gift__GiftingSetup__c.getOrgDefaults();
        if(Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Admin_Email__c.isAccessible()       
           && Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Admin_Email__c.isCreateable()
           &&Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Admin_Email__c.isUpdateable()){
               setting.Corporate_gift__Admin_Email__c = adminEmail;
           }
        if(Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Create_task_on_status_change__c.isAccessible()       
           && Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Create_task_on_status_change__c.isCreateable()
           &&Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Create_task_on_status_change__c.isUpdateable()){
               setting.Corporate_gift__Create_task_on_status_change__c = createTaskOnStatusChange;
           }
        if(Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Enable_gift_frequency__c.isAccessible()       
           && Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Enable_gift_frequency__c.isCreateable()
           &&Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Enable_gift_frequency__c.isUpdateable()){
               setting.Corporate_gift__Enable_gift_frequency__c = enableGiftFrequency;
           }
        if(Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Gift_Frequency__c.isAccessible()       
           && Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Gift_Frequency__c.isCreateable()
           &&Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Gift_Frequency__c.isUpdateable()){
               setting.Corporate_gift__Gift_Frequency__c = selectedValue;
           }
        if(Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Merchant_Id__c.isAccessible()       
           && Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Merchant_Id__c.isCreateable()
           &&Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Merchant_Id__c.isUpdateable()){
               setting.Corporate_gift__Merchant_Id__c = merchantId;
           }
        if(Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Security_Header__c.isAccessible()       
           && Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Security_Header__c.isCreateable()
           &&Schema.sObjectType.Corporate_gift__GiftingSetup__c.fields.Corporate_gift__Security_Header__c.isUpdateable()){
               setting.Corporate_gift__Security_Header__c = securityHeader;
           }
        
        
        
        try{
            if(Schema.sObjectType.Corporate_gift__GiftingSetup__c.isAccessible()       
               && Schema.sObjectType.Corporate_gift__GiftingSetup__c.isCreateable()
               &&Schema.sObjectType.Corporate_gift__GiftingSetup__c.isUpdateable()){
                   upsert setting;
                   system.debug('setting** '+setting);

                   set<ID> settingIDSet = new set<ID>();
                   settingIDSet.add(setting.Id);
                   GetAvailableGiftController.getGifts(settingIDSet);
                   return string.valueOf(setting.id);   
               }
        }catch(Exception e){
            system.debug('Error msg - '+e.getLineNumber()+' '+e.getMessage()+' '+e.getCause());
            return null;
        }
        return null;
        
    }
    
    @AuraEnabled
    public static Map<String,String> fetchData(){
        Corporate_gift__GiftingSetup__c giftsetup = Corporate_gift__GiftingSetup__c.getOrgDefaults();
        Map<String,String> fieldnameVsFieldvalueMap = new Map<String,String>();
        fieldnameVsFieldvalueMap.put('Admin_Email',giftsetup.Corporate_gift__Admin_Email__c);
        fieldnameVsFieldvalueMap.put('Create_task_on_status_change',string.valueOf(giftsetup.Corporate_gift__Create_task_on_status_change__c));
        fieldnameVsFieldvalueMap.put('Enable_gift_frequency',string.valueOf(giftsetup.Corporate_gift__Enable_gift_frequency__c));
        fieldnameVsFieldvalueMap.put('Gift_Frequency',giftsetup.Corporate_gift__Gift_Frequency__c);
        fieldnameVsFieldvalueMap.put('Merchant_Id',giftsetup.Corporate_gift__Merchant_Id__c);
        fieldnameVsFieldvalueMap.put('Security_Header',giftsetup.Corporate_gift__Security_Header__c);
        
        
        return fieldnameVsFieldvalueMap;
    }
}