public with sharing class CheckStatusOnSendingGiftController
{   
    @AuraEnabled
    public static string CheckStatusOnSendingGiftController(String recId) {
     //   system.debug('recId**'+recId);
        string giftId = '' ;
        if(recId !=null && recId !='' && recId.startsWith('003')){
            giftId = [select id ,gift_Id__c From Contact Where Id =: recId WITH SECURITY_ENFORCED].gift_Id__c; 
        }else if(recId !=null && recId !='' && recId.startsWith('001')){
            giftId = [select id ,gift_Id__c From Account Where Id =: recId WITH SECURITY_ENFORCED].gift_Id__c;
        }else if(recId !=null && recId !='' && recId.startsWith('00Q')){
            giftId = [select id ,gift_Id__c From Lead Where Id =: recId WITH SECURITY_ENFORCED].gift_Id__c;
        }  
        
     //   system.debug('giftId **' + giftId );
        if(giftId !=null && giftId !=''){
            
            Map<string,string> jsonBody = new Map<string,string>();
            list<GiftingSetup__c> merchantList = new list<GiftingSetup__c>();
            merchantList = [Select Id,Merchant_Id__c ,Security_Header__c ,Status_Merchant_Id__c From GiftingSetup__c WITH SECURITY_ENFORCED limit 1];
            JsonBody.put('merchant_id',merchantList[0].Merchant_Id__c);
            JsonBody.put('order_id',giftId);
           // String reqstInput = JSON.serialize(JsonBody) + '' + 'asd#D343ss' ;
            String reqstInput = JSON.serialize(JsonBody) + '' + merchantList[0].Security_Header__c ;
            Blob reqsBlob = Blob.valueOf(reqstInput);
            Blob hashCode = Crypto.generateDigest('MD5', reqsBlob);
            String SecurityHead = EncodingUtil.convertToHex(hashCode);
         //   system.debug('SecurityHead**'+SecurityHead);
            http http2 = new http();
            httpRequest request2 = new httpRequest(); 
            // string endPoint2= 'https://corporategift.com/salesforce/gift/status';
           // string endPoint2= 'https://staging.corporategift.com/salesforce/gift/status';
            string endPoint2 = System.Label.GiftStatus ;
            request2.setEndpoint(endPoint2);
            request2.setMethod('POST');
            request2.setHeader('Accept','application/json');
            request2.setHeader('Content-Type','application/json');
            request2.setHeader('Api-Signature',SecurityHead);
            request2.setTimeout(120000);
            request2.setBody(JSON.serialize(JsonBody)); 
         //   system.debug('PostBody**'+JSON.serialize(JsonBody));
            HttpResponse resp2 = http2.send(request2);
         //   system.debug('Body**'+resp2.getBody());
            if(resp2.getStatusCode()==200){
                map<string,object> responseBody2 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
              //  system.debug('responseBody**'+responseBody2);
                string rest2 = (string.valueOf(responseBody2.get('success')));
             //   system.debug('rest**'+rest2);
                if(!responseBody2.isEmpty() && responseBody2.containsKey('success') && rest2=='true'){
                    return string.valueOf(responseBody2.get('status'));  
                }
            } 
        }
        return null ;  
    }
}