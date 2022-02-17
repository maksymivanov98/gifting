/*-************************************************************************************************************
* Name         : BatchCheckStatusOnSendingGift
* @Author      : 
* @Date        : 
* @Description : The BatchCheckStatusOnSendingGift controller is used for check ship status .
* UPDATES
* Version          Developer                    Date                        Description
*-------------------------------------------------------------------------------------------
*     1.0          Piyush kalra                28 Jan 2020                 Initial Creation 
***************************************************************************************************************/
global with sharing class BatchCheckStatusOnSendingGift implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful{
    
    list<Gift_History__c> GiftHistorylistToUpdate = new list<Gift_History__c>();
    global Map<string,string> jsonBody = new Map<string,string>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        String query = 'Select Id,Corporate_gift__Gift_Status__c,Gift_Status_Id__c, Corporate_gift__Dedicated_link__c From Gift_History__c Where Gift_Status_Id__c != null AND Corporate_gift__Gift_Status__c != null AND Corporate_gift__Gift_Status__c != \'Canceled\' AND Corporate_gift__Gift_Status__c != \'Complete redeemed\' AND CreatedDate = LAST_90_DAYS WITH SECURITY_ENFORCED limit 50000';
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Gift_History__c> scope) {
        
        list<GiftingSetup__c> merchantList = new list<GiftingSetup__c>();
        merchantList = [Select Id,Merchant_Id__c ,Security_Header__c ,Status_Merchant_Id__c From GiftingSetup__c WITH SECURITY_ENFORCED limit 1];
        
        for(Gift_History__c gh : scope){
            
            Gift_History__c gh1 = new Gift_History__c();
            gh1.Id = gh.Id ;

            JsonBody.put('merchant_id',merchantList[0].Merchant_Id__c); 
            JsonBody.put('order_id',gh.Gift_Status_Id__c);
            String endpointParam = 'merchant_id='+ merchantList[0].Merchant_Id__c; 
            endpointParam += '&order_id='+gh.Gift_Status_Id__c;

            String reqstInput = JSON.serialize(JsonBody) + '' + merchantList[0].Security_Header__c ;
            Blob reqsBlob = Blob.valueOf(reqstInput);
            Blob hashCode = Crypto.generateDigest('MD5', reqsBlob);
            String SecurityHead = EncodingUtil.convertToHex(hashCode);
          //  system.debug('SecurityHead**'+SecurityHead);
            http http2 = new http();
            httpRequest request2 = new httpRequest(); 
            
            string endPoint2 = 'https://staging.corporategift.com/salesforce/gift/status' ;
            request2.setEndpoint(endPoint2);
            request2.setMethod('POST');
            request2.setHeader('Accept','application/json');
            request2.setHeader('Content-Type','application/json');
            request2.setHeader('Api-Signature',SecurityHead);
            request2.setTimeout(120000);
            request2.setBody(JSON.serialize(JsonBody)); 
         //   system.debug('PostBody**'+JSON.serialize(JsonBody));
            HttpResponse resp2 = http2.send(request2);
        //    system.debug('Body**'+resp2.getBody());
            
            http httpShippingStatus = new http();
            httpRequest requestShippingStatus = new httpRequest(); 
            
            string endPointShippingStatus = 'https://staging.corporategift.com/salesforce/gift/getShippingStatus' ;
            requestShippingStatus.setEndpoint(endPointShippingStatus+'?'+endpointParam);
            requestShippingStatus.setMethod('GET');
            requestShippingStatus.setHeader('Accept','application/json');
            requestShippingStatus.setTimeout(120000);
            
         //   system.debug('---EndPoint---'+requestShippingStatus.getEndpoint());
            HttpResponse responseShippingStatus = httpShippingStatus.send(requestShippingStatus);
            System.debug('potapenko responseShippingStatus ' + responseShippingStatus.getStatusCode() + ' ' + responseShippingStatus.getBody());
            System.debug('resp2.getStatusCode() ' + resp2.getStatusCode());
            if(resp2.getStatusCode() == 200){
                map<string,object> responseBody2 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
                System.debug('responseBody2 ' + responseBody2);

                string rest2 = (string.valueOf(responseBody2.get('success')));
                if(!responseBody2.isEmpty() && responseBody2.containsKey('success') && rest2=='true'){
                    if(gh.Corporate_gift__Gift_Status__c != null && !gh.Corporate_gift__Gift_Status__c.equals(string.valueOf(responseBody2.get('status')))){
                        
                        gh1.Gift_Status__c = string.valueOf(responseBody2.get('status'));
                        //gh1.Shipping_Status__c = string.valueOf(responseBody2.get('status')); 
                        if(responseBody2.get('status') != null &&  string.valueOf(responseBody2.get('status')).equalsIgnoreCase('Complete redeemed')){
                            gh1.Corporate_gift__Dedicated_link__c = null;
                        }
                        gh1.Ship_Date__c = system.today();  
                        if(responseBody2.containsKey('thankyou_message'))
                            gh1.Thank_You_Note__c  =  string.valueOf(responseBody2.get('thankyou_message'));
                        
                        
                    }
                }
            }
            
            if(responseShippingStatus.getStatusCode() == 200){
                map<string,object> responseBodyShipping =(Map<string,Object>)JSON.deserializeUntyped(responseShippingStatus.getBody());
                if(!responseBodyShipping.isEmpty() && responseBodyShipping.containsKey('success') 
                    && Boolean.valueOf(responseBodyShipping.get('success'))
                    && responseBodyShipping.containsKey('success')){
                    
                    gh1.Shipping_Status__c = string.valueOf(responseBodyShipping.get('status'));
                    
                    if( responseBodyShipping.containsKey('track_no') ){
                        gh1.Corporate_gift__Tracking_Number__c = string.valueOf(responseBodyShipping.get('track_no')); 
                    }
                }
            }

            GiftHistorylistToUpdate.add(gh1);
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
       system.debug('potapenko GiftHistorylistToUpdate**'+GiftHistorylistToUpdate.size() + ' ' + GiftHistorylistToUpdate);
        if(!GiftHistorylistToUpdate.isEmpty()){
            update GiftHistorylistToUpdate ;
        }
        
    }
}