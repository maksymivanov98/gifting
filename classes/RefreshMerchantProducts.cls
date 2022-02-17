/*
*  @@ Corporate Gift WiserSpread
*  - Batch get refresh list of products under Merchandise 
*  - Update the products__c Object records @@
*/

public with sharing class RefreshMerchantProducts implements Database.Batchable<ProductWrapperClass>, DataBase.allowsCallouts{
    
    public static Iterable<ProductWrapperClass> start(Database.BatchableContext BC){
        Http http = new http();
        list<ProductWrapperClass> productsToUpsert = new list<ProductWrapperClass>();
        httpRequest request = new httpRequest();
        string endPoint=Label.GiftItems+'='+GiftMerchantId__c.getValues('First').id__c;
     //   system.debug('endPoint**'+endPoint);
        request.setEndpoint(endPoint);
       // request.setEndpoint('https://staging.corporategift.com/salesforce/gift/get?merchant_id=11');
        request.setMethod('GET');
        request.setHeader('Accept','application/json');
        request.setHeader('Content-Type','application/json');
        HttpResponse resp = http.send(request);
        if(resp.getStatusCode()==200){
            map<string,object> responseBody =(Map<string,Object>)JSON.deserializeUntyped(resp.getBody());
            if(!responseBody.isEmpty() && responseBody.containsKey('products')){
                list<Object> productsList= (list<Object>)responseBody.get('products');
                for(object ob : productsList){
                    map<string,object> productItem = (map<string,object>)ob;
                    if(productItem.containsKey('id') && productItem.containsKey('name')){
                        ProductWrapperClass prodOb = new ProductWrapperClass();
                        prodOb.productId=string.valueOf(productItem.get('id'));
                        prodOb.prodName=string.valueOf(productItem.get('name'));
                        prodOb.giftImage=string.valueOf(productItem.get('image'));
                        productsToUpsert.add(prodOb);  
                    }
                }
            }
        }
        if(!productsToUpsert.isEmpty())
            return productsToUpsert;
        else
            return null;
    }
    public static void execute(Database.BatchableContext BC,List<ProductWrapperClass> productList){
        list<Products__c> productToUpsertList = new List<Products__c>();
        for(ProductWrapperClass wrapOb : productList){
            Products__c productObj = new Products__c();
            if(Schema.sObjectType.Products__c.fields.id__c.isCreateable() && Schema.sObjectType.Products__c.fields.id__c.isUpdateable()){
                productObj.id__c =wrapOb.productId;
            }
            
            if(Schema.sObjectType.Products__c.fields.name.isCreateable() && Schema.sObjectType.Products__c.fields.name.isUpdateable()){
               productObj.name =wrapOb.prodName;
            }
            if(Schema.sObjectType.Products__c.fields.Gift_Image__c.isCreateable() && Schema.sObjectType.Products__c.fields.Gift_Image__c.isUpdateable()){
               productObj.Gift_Image__c='<img src="'+wrapOb.giftImage+'"/>';
            }
            productToUpsertList.add(productObj);
        }
        try{
        //    system.debug('--- Upserting '+productToUpsertList);
            upsert productToUpsertList id__c;
        }
        catch(Exception ex){
          //  system.debug('** Exception Occure while updateing Products/Gift '+ex);
        }
    }
    
    public static void finish(Database.BatchableContext BC){
        system.debug('*** Finished Batch ***');
    }
}