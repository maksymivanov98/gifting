/*-************************************************************************************************************
* Name         : BatchFetchAvailableGifts
* @Author      : 
* @Date        : 
* @Description : The BatchFetchAvailableGifts batch class is used for fetching available gifts from the corporate gifting api .
* UPDATES
* Version          Developer                    Date                        Description
*-------------------------------------------------------------------------------------------
*     1.0          Nishank Gupta                30 July 2021                 Initial Creation 
***************************************************************************************************************/
global with sharing class  BatchFetchAvailableGifts implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful{
    
    global set<string> IdsSet = new set<string>();
    global list<Products__c> productToUpdateList = new List<Products__c>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String query = 'Select Id,Merchant_Id__c ,Security_Header__c,Admin_Email__c From GiftingSetup__c WITH SECURITY_ENFORCED limit 1';
        return Database.getQueryLocator(query);
        
    }
    
    
    global void execute(Database.BatchableContext BC, List<GiftingSetup__c> scope) {
        list<Products__c> productToUpsertList = new List<Products__c>();
        list<Products__c> productToUpdateListInsert = new List<Products__c>();
        map<string , Products__c> idVsOldProdMap = new map<string , Products__c>();
        for(Products__c pd :[Select id ,id__c,name,Gift_Image__c,isActive__c from Products__c WITH SECURITY_ENFORCED limit 10000]){
            idVsOldProdMap.put(pd.id__c,pd);
        }
        
        
        for(GiftingSetup__c obj : scope){ 
            
            
        Map<String, Object> JsonBody = new Map<String,Object>();
            
            JsonBody.put('user',obj.Admin_Email__c ); 
            JsonBody.put('merchant_id',obj.Merchant_Id__c);
            
            HttpResponse resp =  new HttpResponse();
            resp = GetAvailableGiftController.calloutMethod(JSON.serialize(JsonBody),'GET',System.Label.GetAvailableGift);
            /*
            
            Http http = new http();
            httpRequest request = new httpRequest();
            string endPoint=Label.GiftItems+'='+obj.MerchantId__c;
            system.debug('endPoint**'+endPoint);
            request.setEndpoint(endPoint);
            
            request.setMethod('GET');
            request.setHeader('Accept','application/json');
            request.setHeader('Content-Type','application/json');
            HttpResponse resp = http.send(request);*/
            if(resp.getStatusCode()==200){
              //  system.debug(resp.getBody());
                map<string,object> responseBody =(Map<string,Object>)JSON.deserializeUntyped(resp.getBody()); 
                if(!responseBody.isEmpty() && responseBody.containsKey('products')){
                    list<Object> productsList= (list<Object>)responseBody.get('products');
                    for(object ob : productsList){
                        Products__c productObj = new Products__c();
                        Products__c productObj2 = new Products__c();
                        
                         map<string,object> productItem = (map<string,object>)ob;
                     //   system.debug('idVsOldProdMap***'+idVsOldProdMap);
                     //   system.debug('productItem***'+productItem);
                        if(productItem.containsKey('id') && productItem.containsKey('name') && !idVsOldProdMap.isEmpty() && idVsOldProdMap.containsKey(string.valueOf(productItem.get('id'))) 
                         ){
                            
                                productObj = idVsOldProdMap.get(string.valueOf(productItem.get('id')));
                           
                            
                            if(Schema.sObjectType.Products__c.fields.isActive__c.isAccessible() 
                            &&( Schema.sObjectType.Products__c.fields.isActive__c.isCreateable() 
                            && Schema.sObjectType.Products__c.fields.isActive__c.isUpdateable())){
                                productObj.isActive__c = true ;
                            }
                            if(Schema.sObjectType.Products__c.fields.id__c.isCreateable() && Schema.sObjectType.Products__c.fields.id__c.isUpdateable() && Schema.sObjectType.Products__c.fields.id__c.isAccessible()){
                                productObj.id__c =string.valueOf(productItem.get('id'));
                                IdsSet.add(string.valueOf(productItem.get('id')));
                            }
                            
                          //  if(Schema.sObjectType.Products__c.fields.name.isCreateable() && Schema.sObjectType.Products__c.fields.name.isUpdateable()){
                          // productObj.name =string.valueOf(productItem.get('name'));
                          //  }
                            if(Schema.sObjectType.Products__c.fields.Gift_Image__c.isCreateable() && Schema.sObjectType.Products__c.fields.Gift_Image__c.isUpdateable() && Schema.sObjectType.Products__c.fields.Gift_Image__c.isAccessible()){
                                productObj.Gift_Image__c=productItem.get('image') != null ? '<img src="'+string.valueOf(productItem.get('image'))+'"/>' : null;
                            }
                            if(Schema.sObjectType.Products__c.fields.Description__c.isCreateable() && Schema.sObjectType.Products__c.fields.Description__c.isUpdateable() && Schema.sObjectType.Products__c.fields.Description__c.isAccessible()){
                                productObj.Description__c=productItem.get('description') != null ? string.valueOf(productItem.get('description')) : null;
                            }
                            //if(Schema.sObjectType.Products__c.fields.Price__c.isCreateable() && Schema.sObjectType.Products__c.fields.Price__c.isUpdateable() && productItem.containsKey('price')){
                            if(productItem.containsKey('price')&& ( Schema.sObjectType.Products__c.fields.Price__c.isUpdateable() && Schema.sObjectType.Products__c.fields.Price__c.isAccessible())){
                                                          
                                productObj.Price__c= productItem.get('price') != null ? Decimal.valueOf(string.valueOf(productItem.get('price'))).setscale(2) : null;
                            }
                            productToUpsertList.add(productObj);
                         //   system.debug('productItem**'+productItem); 
                        }else {
                            if(Schema.sObjectType.Products__c.fields.id__c.isAccessible()
                                && Schema.sObjectType.Products__c.fields.id__c.isCreateable() 
                                && Schema.sObjectType.Products__c.fields.id__c.isUpdateable()){
                                productObj2.id__c =string.valueOf(productItem.get('id'));
                                IdsSet.add(string.valueOf(productItem.get('id')));
                            }
                            
                            if(Schema.sObjectType.Products__c.fields.isActive__c.isAccessible() 
                            &&( Schema.sObjectType.Products__c.fields.isActive__c.isCreateable() 
                            && Schema.sObjectType.Products__c.fields.isActive__c.isUpdateable())){
                                productObj2.isActive__c = true ;
                            }
                            if(Schema.sObjectType.Products__c.fields.name.isAccessible()
                                && Schema.sObjectType.Products__c.fields.name.isCreateable() 
                                && Schema.sObjectType.Products__c.fields.name.isUpdateable()){
                                productObj2.name =string.valueOf(productItem.get('name'));
                            }
                            if(Schema.sObjectType.Products__c.fields.Gift_Image__c.isAccessible()
                                && Schema.sObjectType.Products__c.fields.Gift_Image__c.isCreateable() 
                                && Schema.sObjectType.Products__c.fields.Gift_Image__c.isUpdateable()){
                                productObj2.Gift_Image__c=productItem.get('image') != null ? '<img src="'+string.valueOf(productItem.get('image'))+'"/>' : null;
                            }
                            if(Schema.sObjectType.Products__c.fields.Description__c.isAccessible()
                                && Schema.sObjectType.Products__c.fields.Description__c.isCreateable() 
                                && Schema.sObjectType.Products__c.fields.Description__c.isUpdateable()){
                                productObj2.Description__c=productItem.get('description') != null ? string.valueOf(productItem.get('description')) : null;
                            }
                           // if(Schema.sObjectType.Products__c.fields.Price__c.isCreateable() && Schema.sObjectType.Products__c.fields.Price__c.isUpdateable() && productItem.containsKey('price')){
                            if(productItem.containsKey('price')
                                && Schema.sObjectType.Products__c.fields.Price__c.isAccessible() 
                                && Schema.sObjectType.Products__c.fields.Price__c.isCreateable()){
                                
                                productObj2.Price__c= productItem.get('price') != null ? Decimal.valueOf(string.valueOf(productItem.get('price'))).setScale(2) : null;
                            }
                            
                            productToUpdateListInsert.add(productObj2);
                        }
                    }
                }
            }
        }
        try{
            
            
         //   system.debug('--- Upserting Product*** '+productToUpsertList);
            if(productToUpsertList !=null && !productToUpsertList.isEmpty() && 
            (Schema.sObjectType.Products__c.isUpdateable() && Schema.sObjectType.Products__c.isAccessible())){
                update productToUpsertList ;
            }
            
        //    system.debug('--- Inserting Product --- '+productToUpdateListInsert);
            if(productToUpdateListInsert !=null && !productToUpdateListInsert.isEmpty()
                && (Schema.sObjectType.Products__c.isAccessible()
                && Schema.sObjectType.Products__c.isCreateable())){ 
                insert productToUpdateListInsert ;
            }
            
        }
        catch(Exception ex){
          //  system.debug('** Exception Occure while updateing Products/Gift '+ex);
            FinalSendGift_Class.createExceptionRecord(ex.getMessage() + ex.getLineNumber()); 

        }
    }
    
    global void finish(Database.BatchableContext BC) {
        if(IdsSet !=null && !IdsSet.isEmpty()
        && Schema.sObjectType.Products__c.isAccessible()){
            for(Products__c pd :[Select id ,isActive__c from Products__c where id__c NOT IN : IdsSet AND isActive__c =true WITH SECURITY_ENFORCED ]){
                if ((Schema.sObjectType.Products__c.fields.isActive__c .isUpdateable() 
                && Schema.sObjectType.Products__c.fields.isActive__c .isAccessible())){
                pd.isActive__c = false ;
                productToUpdateList.add(pd);
                }
            }
            
         //   system.debug('**productToUpdateList**'+productToUpdateList); 
            if(!productToUpdateList.isEmpty() 
                &&( Schema.sObjectType.Products__c.isUpdateable() 
                && Schema.sObjectType.Products__c.isAccessible())){
                update productToUpdateList ;
            }
        }
    }
}