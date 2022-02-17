/*-************************************************************************************************************
* Name         : AccMassGiftSendBatchClass
* @Author      : 
* @Date        : 
* @Description : The AccMassGiftSendBatchClass controller is used for Sending gifts to selected contacts.
* UPDATES
* Version          Developer                    Date                        Description
*-------------------------------------------------------------------------------------------
*     1.0          Bhagwan Chuphal              12 Nov 2019                 Initial Creation 
***************************************************************************************************************/
global with Sharing class AccMassGiftSendBatchClass implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
    global set<string> ContactIds ;
    global String giftId ;
    global String message ;
    global string greeting ;
    global string recipientName ;
    global string giftName ;
    global string giftType ;
    global string recId ;
    global string greetMessage = '';
    global Boolean check=false;
    global Account contct = new Account();
    global List<Task> tList = new List<Task>();
    global List<Gift_History__c> giftHistoryList = new List<Gift_History__c>();
    global Map<string,string> jsonBody = new Map<string,string>();
    global Map<string,string> jsonBodyStatus = new Map<string,string>();
    global string E_GiftName ;
    
    global AccMassGiftSendBatchClass(set<string> conIds){
        ContactIds = conIds ;
    }
    global AccMassGiftSendBatchClass(set<string> conIds , String giftId1 , String message1 ,string greeting1 ,string recipientName1 ,string giftName1 ,string giftType1 ,string recId1 ){
      //  system.debug('recipientName1**'+recipientName1);
        ContactIds = conIds ;
        giftId = giftId1;
        message = message1;
        greeting = greeting1;
        recipientName = recipientName1 ;
        giftName = giftName1 ;
        giftType = giftType1 ;
        recId = recId1 ;
        
    }
    
    global AccMassGiftSendBatchClass(set<string> conIds , String giftId1 , String message1 ,string greeting1 ,string recipientName1 ,string giftName1 ,string giftType1 ,string recId1 ,String E_GiftName ){
       // system.debug('recipientName1**'+recipientName1);
        ContactIds = conIds ;
        giftId = giftId1;
        message = message1;
        greeting = greeting1;
        recipientName = recipientName1 ;
        giftName = giftName1 ;
        giftType = giftType1 ;
        recId = recId1 ;
        this.E_GiftName = E_GiftName ;
        
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
       // system.debug('greeting**'+greeting);
        String query = 'Select id,Message__c,Phone,Gift_Name__c,Name,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account where Id IN :ContactIds WITH SECURITY_ENFORCED';
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) {
     //  system.debug('giftName**'+giftName);
    //   system.debug('message**'+message);
        list<GiftingSetup__c> merchantList = new list<GiftingSetup__c>();
        merchantList = [Select Id,Merchant_Id__c ,Security_Header__c From GiftingSetup__c WITH SECURITY_ENFORCED limit 1];
        string UserEmail = [Select id,email from user where Id =: UserInfo.getUserId() WITH SECURITY_ENFORCED].email ;
        JsonBody.put('user',UserEmail);
        JsonBody.put('merchant_id',merchantList[0].Merchant_Id__c);
        if(giftId != null){
            JsonBody.put('gift_id',giftId);  
        }
        if(greeting != null){
            greetMessage =greetMessage + greeting ; 
        }
        if(giftType=='E_gift'){
           JsonBody.put('egift_name',E_GiftName);  
        }
        for(Account con : scope){
            if(con.name ==null && Schema.sObjectType.Account.fields.name.isUpdateable()){
                con.name = '';
            }
            JsonBody.put('firstname',con.name); 
            // if(recipientName !=null && recipientName !='' && recipientName == 'Include just recipient first name(Recommended)'){
            greetMessage = greetMessage +' '+con.name  ; 
            // }else if(recipientName !=null && recipientName !='' && recipientName == 'Include just recipient last name(Recommended)'){
            //    greetMessage = greetMessage +' '+con.LastName ; 
            //}else if(recipientName !=null && recipientName !='' && recipientName == 'Include just both(Recommended)'){
            //     greetMessage = greetMessage +' '+con.Name ; 
            // }
            // if(con.email!=null){
            JsonBody.put('email','test@gmail.com'); 
            // }
            if(con.name!=null){
                JsonBody.put('lastname','Office Staff');
            }
            if(con.Phone!=null){
                JsonBody.put('phone',con.Phone);  
            }
            if(giftType !=null && giftType !='' && giftType=='P_gift'){
                if(con.BillingStreet!=null){
                    JsonBody.put('street',con.BillingStreet);  
                }
                if(con.BillingCity!=null){
                    JsonBody.put('city',con.BillingCity);  
                }
                if(con.BillingState!=null){
                    JsonBody.put('state',con.BillingState);  
                }
                if(con.BillingPostalCode!=null){
                    JsonBody.put('zip',con.BillingPostalCode);  
                }
            }
            
           
            if(message !=null){
                greetMessage = greetMessage +'\n\n'+message; 
            }
            if(greetMessage !=null){
                JsonBody.put('message',greetMessage);  
            }
            string body = JSON.serialize(JsonBody) ;
         //   system.debug('#### Line 107 AccBatch JOSN Body**'+body);
            String requestInput = body + '' + merchantList[0].Security_Header__c ;
            Blob requestBlob = Blob.valueOf(requestInput);
            Blob hash = Crypto.generateDigest('MD5', requestBlob);
            String SecurityHeader = EncodingUtil.convertToHex(hash);
         
            
            http http2 = new http();
            httpRequest request2 = new httpRequest();
            string endPoint2= System.Label.sendGiftURL;
           // string endPoint2= 'https://staging.corporategift.com/salesforce/gift/send';
            request2.setEndpoint(endPoint2);
            request2.setMethod('POST');
            request2.setHeader('Accept','application/json');
            request2.setHeader('Content-Type','application/json');
            request2.setHeader('Api-Signature',SecurityHeader);
            request2.setTimeout(120000);
            request2.setBody(JSON.serialize(JsonBody)); 
          //  system.debug('#### REQUEST BODY **'+request2.getBody());//<---
            
            HttpResponse resp2 = http2.send(request2); 
            if(resp2.getStatusCode()==200){
            //    system.debug('resp2.getBody()-----'+resp2.getBody());
                map<string,object> responseBody2 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
             //   system.debug('### responseBody2**'+responseBody2);
                string rest2 = (string.valueOf(responseBody2.get('success')));
             //   system.debug('rest2**'+rest2);
                if(!responseBody2.isEmpty() && responseBody2.containsKey('success') && rest2=='true'){
                    createRecordsAfterCallout(String.valueOf(responseBody2.get('order_id')),con.Id);
                }   
                
                
            } 
        }  
    }
    
    
    global void createRecordsAfterCallout(string gft_id ,string conId){
     //   system.debug('@@@ gft_id**'+gft_id);
      //  system.debug(' @@@ conId**'+conId);
        string status = '';
        jsonBodyStatus.put('merchant_id','6200');
        jsonBodyStatus.put('order_id',gft_id);

        Account account = new Account();
        account = [Select id from Account where id =: conId WITH SECURITY_ENFORCED LIMIT 1];
      /*  if(Schema.sObjectType.Account.fields.Id.isAccessible()){
        account.Id = conId;
        }*/
                //contct.id =contId;
        
        if (Schema.sObjectType.Account.fields.Gift_Id__c.isUpdateable()) {
            account.Gift_Id__c = gft_id ;
        }
        /* 
        String reqstInput = JSON.serialize(jsonBodyStatus) + '' + 'asd#D343ss' ;
        Blob reqsBlob = Blob.valueOf(reqstInput);
        Blob hashCode = Crypto.generateDigest('MD5', reqsBlob);
        String SecurityHead = EncodingUtil.convertToHex(hashCode);
        system.debug('SecurityHead**'+SecurityHead); // d761b7b70cc11bc523731fab56f780fc
        http http = new http();
        httpRequest request = new httpRequest(); 
        string endPoint= 'https://staging.corporategift.com/salesforce/gift/status';
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        request.setHeader('Accept','application/json');
        request.setHeader('Content-Type','application/json');
        request.setHeader('Api-Signature',SecurityHead);
        request.setTimeout(120000);
        request.setBody(JSON.serialize(jsonBodyStatus)); 
        system.debug('@@@@ PostBody**'+JSON.serialize(jsonBodyStatus));
        system.debug('@@@@ PostBody *** '+request.getBody());
        HttpResponse resp = http.send(request);
        system.debug('Body**'+resp.getBody());
        if(resp.getStatusCode()==200){
        map<string,object> responseBody =(Map<string,Object>)JSON.deserializeUntyped(resp.getBody());
        system.debug('@@@ responseBody**'+responseBody);
        string rest = (string.valueOf(responseBody.get('success')));
        system.debug('rest**'+rest);
        if(!responseBody.isEmpty() && responseBody.containsKey('success') && rest=='true'){
        status = string.valueOf(responseBody.get('status')); 
        system.debug('status***'+status);
        }
        } */
        Gift_History__c gh = new Gift_History__c();
        // gh.name = giftName ;
        // gh.Sent_To__c = conId;
        if(Schema.sObjectType.Gift_History__c.fields.Account__c.isCreateable()){
           gh.Account__c = conId;
        }
      //  SYSTEM.DEBUG('>>>>>>>>>'+conId);
        if(Schema.sObjectType.Gift_History__c.fields.Gift__c.isAccessible() 
            &&  Schema.sObjectType.Gift_History__c.fields.Gift__c.isCreateable()){
          gh.Gift__c = recId ;
        }
        if(Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isCreateable()){
           gh.Gift_Id__c = giftId ;
        }
        //  gh.Gift_Name__c = giftName ;
        if(Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isCreateable()){
            gh.Sent_Date__c = system.today();
        }
        if(Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isCreateable()){
           gh.Gift_Status_Id__c = gft_id;
        }
        
       if(Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isCreateable()){
          gh.Gift_Status__c = 'Created';
       }
       if(Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isCreateable()){
          gh.Shipping_Status__c = 'Created';
       }
         /*  if(status !=null){
        gh.Gift_Status__c = status ;
        gh.Shipping_Status__c = status; 
        }else{
        gh.Gift_Status__c = '' ;
        gh.Shipping_Status__c = ''; 
        } */
     //   system.debug('>>>>>>#'+gh);
        giftHistoryList.add(gh); 


        if(Schema.sObjectType.Account.fields.Gift_On_The_Way__c.isUpdateable()) {
            account.Gift_On_The_Way__c = true;
        }
        if (Schema.sObjectType.Account.fields.Gift_Name__c.isUpdateable()) {
            account.Gift_Name__c = giftName ;
        }
        if (Schema.sObjectType.Account.fields.Last_Gift_Send__c.isUpdateable()) {
            account.Last_Gift_Send__c = system.today();
        }
        check = true;
        Task taskObject = new Task();
        if(Schema.sObjectType.Task.fields.subject.isCreateable()){
            taskObject.subject ='Gift Intiated - ' + giftName ; 
        }
        if(Schema.sObjectType.Task.fields.WhatId.isCreateable()){
            taskObject.WhatId = conId;
        }
        if(Schema.sObjectType.Task.fields.ActivityDate.isCreateable()){
            taskObject.ActivityDate = system.today();
        }
        
        tList.add(taskObject);
        
      //  System.debug('Gift History**** '+giftHistoryList);
        try{
            if(check 
            && (Schema.sObjectType.Account.isAccessible() && 
            Schema.sObjectType.Account.isUpdateable())){
           //     system.debug('Account**'+account);
                update account;
            }
            if(!tList.isEmpty()){
              //  system.debug('tList**'+tList);
                insert tList;
            }
            if(!giftHistoryList.isEmpty() 
                && (Schema.sObjectType.Gift_History__c.isAccessible() && 
                Schema.sObjectType.Gift_History__c.isCreateable())){
                system.debug('giftHistoryList**'+giftHistoryList);
                insert giftHistoryList;
            }
        }
        catch(Exception ex){
          //  system.debug('Message '+ex.getMessage() + '  Line'+ex.getLineNumber());
        } 
    }
    
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
}