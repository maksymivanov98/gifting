public with sharing class GetAvailableGiftController {
    
    @future(callout=true)
    public static void getGifts(Set<Id> MerchantIds){
        list<GiftingSetup__c> gm = [Select id ,Merchant_Id__c,Security_Header__c,Admin_Email__c FROM GiftingSetup__c where Id IN : MerchantIds WITH SECURITY_ENFORCED limit 1];
        list<Products__c> productToUpsertList = new List<Products__c>();
        list<Products__c> productToUpdateList = new List<Products__c>();
        list<Products__c> productToUpdateListInsert = new List<Products__c>();
        map<string , Products__c> idVsOldProdMap = new map<string , Products__c>();
        for(Products__c pd :[Select id ,id__c,name,Gift_Image__c,isActive__c from Products__c limit 10000]){
            idVsOldProdMap.put(pd.id__c,pd);
        }
        
        
        Map<String, Object> JsonBody = new Map<String,Object>();
        set<string> IdsSet = new set<string>();
        list<ProductWrapperClass> productsToUpsert = new list<ProductWrapperClass>();

        JsonBody.put('user',gm[0].Admin_Email__c ); 
        JsonBody.put('merchant_id',gm[0].Merchant_Id__c);
        
        HttpResponse resp =  new HttpResponse();
        resp = calloutMethod(JSON.serialize(JsonBody),'GET',System.Label.GetAvailableGift);
       /* 
        
        Http http = new http();
        httpRequest request = new httpRequest();
        string endPoint=Label.GiftItems+'='+gm[0].MerchantId__c;
        system.debug('endPoint**'+endPoint);
        request.setEndpoint(endPoint);
        // request.setEndpoint('https://staging.corporategift.com/salesforce/gift/get?merchant_id=11');
        request.setMethod('GET');
        request.setHeader('Accept','application/json');
        request.setHeader('Content-Type','application/json');
        HttpResponse resp = http.send(request);
        
        */
        if(resp.getStatusCode()==200){
            map<string,object> responseBody =(Map<string,Object>)JSON.deserializeUntyped(resp.getBody());
            if(!responseBody.isEmpty() && responseBody.containsKey('products')){
                list<Object> productsList= (list<Object>)responseBody.get('products');
                for(object ob : productsList){
                    Products__c productObj = new Products__c();
                    Products__c productObj2 = new Products__c();

                    map<string,object> productItem = (map<string,object>)ob;
                    if(productItem.containsKey('id') && productItem.containsKey('name') && !idVsOldProdMap.isEmpty() && idVsOldProdMap.containsKey(string.valueOf(productItem.get('id')))
                     ){
                     
                            productObj = idVsOldProdMap.get(string.valueOf(productItem.get('id')));
                        

                        if(Schema.sObjectType.Products__c.fields.isActive__c.isCreateable() 
                        && Schema.sObjectType.Products__c.fields.isActive__c.isUpdateable() 
                        && Schema.sObjectType.Products__c.fields.isActive__c.isAccessible()){
                            productObj.isActive__c = true ;
                        }
                        if(Schema.sObjectType.Products__c.fields.id__c.isCreateable() && Schema.sObjectType.Products__c.fields.id__c.isUpdateable() && Schema.sObjectType.Products__c.fields.id__c.isAccessible()){
                            productObj.id__c =string.valueOf(productItem.get('id'));
                            IdsSet.add(string.valueOf(productItem.get('id')));
                       }
                        
                    //    if(Schema.sObjectType.Products__c.fields.name.isCreateable() && Schema.sObjectType.Products__c.fields.name.isUpdateable()){
                            // productObj.name =string.valueOf(productItem.get('name'));
                    //    }
                        if(Schema.sObjectType.Products__c.fields.Gift_Image__c.isCreateable() && Schema.sObjectType.Products__c.fields.Gift_Image__c.isUpdateable() && Schema.sObjectType.Products__c.fields.Gift_Image__c.isAccessible()){
                            productObj.Gift_Image__c=productItem.get('image') != null ? '<img src="'+string.valueOf(productItem.get('image'))+'"/>' : null ;
                        }
                        if(Schema.sObjectType.Products__c.fields.Description__c.isCreateable() && Schema.sObjectType.Products__c.fields.Description__c.isUpdateable() && Schema.sObjectType.Products__c.fields.Description__c.isAccessible()){
                            productObj.Description__c= productItem.get('description') != null ? string.valueOf(productItem.get('description')) : null;
                        }
                      //  if(Schema.sObjectType.Products__c.fields.Price__c.isCreateable() && Schema.sObjectType.Products__c.fields.Price__c.isUpdateable() && productItem.containsKey('price')){
                        if(productItem.containsKey('price') && (Schema.sObjectType.Products__c.fields.Price__c.isUpdateable() && Schema.sObjectType.Products__c.fields.Price__c.isAccessible())){
                            productObj.Price__c=productItem.get('price') != null ? Decimal.valueOf(string.valueOf(productItem.get('price'))).setScale(2) : null;
                        }
                        productToUpsertList.add(productObj);
                    }else { 
                        if(Schema.sObjectType.Products__c.fields.isActive__c.isCreateable() 
                        && Schema.sObjectType.Products__c.fields.isActive__c.isUpdateable() 
                        && Schema.sObjectType.Products__c.fields.isActive__c.isAccessible()){
                            productObj2.isActive__c = true ;
                        }

                        if(Schema.sObjectType.Products__c.fields.id__c.isAccessible()
                            && Schema.sObjectType.Products__c.fields.id__c.isCreateable() 
                            && Schema.sObjectType.Products__c.fields.id__c.isUpdateable()){
                            productObj2.id__c =string.valueOf(productItem.get('id'));
                            IdsSet.add(string.valueOf(productItem.get('id')));
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
 
                            productObj2.Price__c=productItem.get('price') != null ? Decimal.valueOf(string.valueOf(productItem.get('price'))).setScale(2) : null;
                        }
                        productToUpdateListInsert.add(productObj2);
                    }
                }
            }
        }
        try{
            
            for(CronTrigger job: [select Id from CronTrigger where CronJobDetail.name= 'Two Hourly Batch Schedule job'] ){
                System.abortJob(job.id);
            }
            String CRON_EXP = '0 0 */2 * * ?';
            BatchCheckStatusOnSendingGiftSchedule sch = new BatchCheckStatusOnSendingGiftSchedule();
           
             system.schedule('Two Hourly Batch Schedule job', CRON_EXP, sch);
          //   system.debug('--- Upserting--- '+productToUpsertList);
            if(productToUpsertList !=null && !productToUpsertList.isEmpty() && (Schema.sObjectType.Products__c.isUpdateable() 
                && Schema.sObjectType.Products__c.isAccessible())){
                update productToUpsertList ;
            }
            
         //   system.debug('--- Inserting--- '+productToUpdateListInsert);
            if(productToUpdateListInsert !=null && !productToUpdateListInsert.isEmpty()
                && (Schema.sObjectType.Products__c.fields.Gift_Image__c.isAccessible() 
                && Schema.sObjectType.Products__c.fields.Gift_Image__c.isCreateable())){
                insert productToUpdateListInsert ;
            }
            
            if(IdsSet !=null && !IdsSet.isEmpty() && 
            Schema.sObjectType.Products__c.isAccessible()){
                for(Products__c pd :[Select id ,isActive__c from Products__c where id__c NOT IN : IdsSet AND isActive__c =true]){
                    if((Schema.sObjectType.Products__c.fields.isActive__c.isAccessible() 
                    && Schema.sObjectType.Products__c.fields.isActive__c.isUpdateable())){
                    pd.isActive__c = false ;
                    productToUpdateList.add(pd);
                    }
                }
                
              //  system.debug('**productToUpdateList**'+productToUpdateList);
                if(!productToUpdateList.isEmpty() && 
                (Schema.sObjectType.Products__c.isAccessible() && Schema.sObjectType.Products__c.isUpdateable())){
                    update productToUpdateList ;
                }
            }
            
        }
        catch(Exception ex){
          //  system.debug('** Exception*** '+ex);
            FinalSendGift_Class.createExceptionRecord(ex.getMessage() + ex.getLineNumber()); 

        }
    }
    
       /*
    * Method Name     : calloutMethod
    * @Description    : This method is used to make callout.
    **/
    public static HttpResponse calloutMethod(String body, String methodType,String endpoint){
        
        httpRequest request2 = new httpRequest();
        request2.setEndpoint(endpoint);
        if(methodType != null){
            request2.setMethod(methodType);
        }
        request2.setHeader('Accept','application/json');
        request2.setHeader('Content-Type','application/json');
        request2.setTimeout(120000);
        request2.setBody(body); 
        http http2 = new http();
     //   SYstem.debug('request2**'+request2);
        HttpResponse response = http2.send(request2); 
        return response;
        
    }
}