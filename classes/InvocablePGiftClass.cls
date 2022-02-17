global class InvocablePGiftClass {
    
    @InvocableMethod(label='Send PGift' description='invocable method to send pgifts')
    // here input param is giftRequest of List type
    global static void giftList(giftRequest[] requests){
        if( !System.isFuture() && !System.IsBatch()){
            
            processGiftList(json.serialize(requests));
        }
    }
    
    
    @future(callout=true)
    global static void processGiftList(String jsonString){

        giftRequest[] requests = new list<giftRequest>();
        requests = (List<giftRequest>)Json.deserialize(jsonString,List<giftRequest>.class);
        for(giftRequest request : requests){
            set<string> tempSet = new set<string>();
            tempSet.add(request.ContactIds);
            Id idRec = request.ContactIds;
            Schema.sObjectType sObjType = idRec.getSObjectType();
            Schema.DescribeSObjectResult sObjDescribeResult = sObjType.getDescribe();
              map<String,products__c> giftIdVsgiftProduct = new map<String,products__c>();
             for(products__c productObject : [SELECT id__c , id,name,Corporate_gift__Description__c,Corporate_gift__Price__c,Corporate_gift__Gift_Image__c FROM products__c Where isActive__c = true WITH SECURITY_ENFORCED limit 10000]){
                giftIdVsgiftProduct.put(productObject.id__c,productObject);
            
             }
           Id tempGiftSFId = giftIdVsgiftProduct != null && !giftIdVsgiftProduct.isEmpty() && giftIdVsgiftProduct.containsKey(request.giftId) ?  giftIdVsgiftProduct.get(request.giftId).id : null; 
           FinalSendGift_Class.sendMassPhysicalGift(tempSet , request.giftId , request.message , request.greeting ,request.recipientName ,
                                                     request.giftName ,'P_gift',tempGiftSFId, String.valueof(sObjDescribeResult.getName()),giftIdVsgiftProduct,null,request.quantity);

        }
    }
    
    
    global class giftRequest {
        
        @InvocableVariable(label='Record Id' description='Record Id of the Salesforce object' required=true)
        global string ContactIds;
        
        @InvocableVariable(label='Gift Id' description='Gift Id from the API' required=true)
        global String giftId;
        
        @InvocableVariable(label='Message' description='Message to be sent' required=true)
        global String message;
        
        @InvocableVariable(label='Salutation' description='Salutation'  required=true)
        global string greeting;
        
        @InvocableVariable(label='RECIPIENT NAME' description='RECIPIENT NAME'  required=true)
        global string recipientName;
        
        @InvocableVariable( label='Gift Name' description='Name of the Gift' required=true)
        global string giftName;
        
        @InvocableVariable(label='Salesforce Gift Record Id' description='Salesforce Gift Record Id')
        global string recId;

         @InvocableVariable(label='Quantity' description='Quantity' required=true)
        global Integer quantity;

        @InvocableVariable(label='Greeting Message ' description='Greeting Message ')
        global string greetingMessage;
        
    }
}