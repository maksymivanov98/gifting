/*-************************************************************************************************************
* Name         : MassGiftSendBatchClassLead
* @Author      : 
* @Date        : 
* @Description : The MassGiftSendBatchClassLead controller is used for Sending gifts to selected Leads.
* UPDATES
* Version          Developer                    Date                        Description
*-------------------------------------------------------------------------------------------
*     1.0          Piyush kalra                08 Jan 2020                 Initial Creation 
***************************************************************************************************************/
global with Sharing class MassGiftSendBatchClassLead implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
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
    global Lead contct = new Lead();
    global string E_GiftName ;
    global List<Task> tList = new List<Task>();
    global List<Gift_History__c> giftHistoryList = new List<Gift_History__c>();
    global Map<string,string> jsonBody = new Map<string,string>();
    global Map<string,string> jsonBodyStatus = new Map<string,string>();
    
    
    global MassGiftSendBatchClassLead(set<string> conIds){
        ContactIds = conIds ;
      //  system.debug('##### Selected Lead List'+conIds);
    }
    global MassGiftSendBatchClassLead(set<string> conIds , String giftId1 , String message1 ,string greeting1 ,string recipientName1 ,string giftName1 ,string giftType1 ,string recId1){
     //   system.debug('recipientName1**'+recipientName1);
        ContactIds = conIds ;
        giftId = giftId1;
        message = message1;
        greeting = greeting1;
        recipientName = recipientName1 ;
        giftName = giftName1 ;
        giftType = giftType1 ;
      //  System.debug('***recId1**'+recId1);
        recId = recId1 ;
        
    }
    global MassGiftSendBatchClassLead(set<string> conIds , String giftId1 , String message1 ,string greeting1 ,string recipientName1 ,string giftName1 ,string giftType1 ,string recId1 ,string E_GiftName){
     //   system.debug('recipientName1**'+recipientName1);
        ContactIds = conIds ;
        giftId = giftId1;
        message = message1;
        greeting = greeting1;
        recipientName = recipientName1 ;
        giftName = giftName1 ;
        giftType = giftType1 ;
     //   System.debug('***recId1**'+recId1);
        recId = recId1 ;
        this.E_GiftName = E_GiftName ;
        
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
     //   system.debug('### greeting**'+greeting);
        String query = 'Select id, email,Phone,Last_Gift_Send__c,Gift_Name__c, firstName,lastName,Name,Street,City,State,PostalCode,Country from Lead where Id IN :ContactIds WITH SECURITY_ENFORCED';
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> scope) {
     //   system.debug('giftName**'+giftName);
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
        for(Lead con : scope){
            if(con.FirstName ==null && Schema.sObjectType.Lead.fields.FirstName.isUpdateable()){
                con.FirstName = '';
            }
            JsonBody.put('firstname',con.FirstName); 
            if(recipientName !=null && recipientName !='' && recipientName.contains('Include Just Recipient First Name')){
                greetMessage = greetMessage +' '+con.FirstName  ; 
                
            }else if(recipientName !=null && recipientName !='' && recipientName.contains('Include Just Recipient Last Name')){
                greetMessage = greetMessage +' '+con.LastName ; 
                
            }else if(recipientName !=null && recipientName !='' && recipientName.contains('Include Both First and Last Name (Recommended)')){
                greetMessage = greetMessage +' '+con.Name ; 
                
            }
            if(con.email!=null){
                JsonBody.put('email',con.email);  
            }
            if(con.lastName!=null){
                JsonBody.put('lastname',con.lastName);  
            }
            if(con.Phone!=null){
                JsonBody.put('phone',con.Phone);  
            }
            if(giftType !=null && giftType !='' && giftType=='P_gift'){
                if(con.Street!=null){
                    JsonBody.put('street',con.Street);  
                }
                if(con.City!=null){
                    JsonBody.put('city',con.City);  
                }
                if(con.State!=null){
                    JsonBody.put('state',con.State);  
                }
                if(con.PostalCode!=null){
                    JsonBody.put('zip',con.PostalCode);  
                }
            }
            if(message !=null){
                greetMessage = greetMessage +'\n\n'+message; 
            }
            if(greetMessage !=null){
                JsonBody.put('message',greetMessage);  
            }
            string body = JSON.serialize(JsonBody) ;
         //   system.debug('Body**'+body);
            //String requestInput = body + '' + 'asd#D343ss' ;
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
            
            HttpResponse resp2 = http2.send(request2); 
            if(resp2.getStatusCode()==200){
             //   system.debug('responseBody2**'+resp2.getBody());
                map<string,object> responseBody2 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
             //   system.debug('responseBody2**'+responseBody2);
                string rest2 = (string.valueOf(responseBody2.get('success')));
             //   system.debug('rest2**'+rest2);
                if(!responseBody2.isEmpty() && responseBody2.containsKey('success') && rest2=='true'){
                    createRecordsAfterCallout(String.valueOf(responseBody2.get('order_id')),con.Id);
                }   
                
                
            } 
        }  
    }
    
    
    global void createRecordsAfterCallout(string gft_id ,string conId){
      //  system.debug('gft_id**'+gft_id);
      //  system.debug('conId**'+conId);
        string status = '';
        jsonBodyStatus.put('merchant_id','6200');
        jsonBodyStatus.put('order_id',gft_id);
        map<String,Lead > contactIdVsContactObject = new map<String,Lead >();
        for(Lead con : [Select id from Lead where id =: conId WITH SECURITY_ENFORCED ]){
            contactIdVsContactObject.put(con.id,con);
        }
        
        if(Schema.sObjectType.Lead.fields.Id.isAccessible() 
                && Schema.sObjectType.Lead.fields.Id.isUpdateable()){
            contct.id =conId;        
                }
  
  
        if(Schema.sObjectType.Lead.fields.Gift_Id__c.isUpdateable()) {
          contct.Gift_Id__c = gft_id ;
        }
        
        Gift_History__c gh = new Gift_History__c();
       // gh.name = giftName ;
       if(Schema.sObjectType.Gift_History__c.fields.Lead__c.isCreateable()){
          gh.Lead__c = conId;
       }
        if(Schema.sObjectType.Gift_History__c.fields.Gift__c.isAccessible()
            && Schema.sObjectType.Gift_History__c.fields.Gift__c.isCreateable()){
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
    
        giftHistoryList.add(gh); 

        if(Schema.sObjectType.Lead.fields.Gift_On_The_Way__c.isUpdateable()) {
          contct.Gift_On_The_Way__c = true;
        }
        if(Schema.sObjectType.Lead.fields.Gift_Name__c.isUpdateable()) {
          contct.Gift_Name__c = giftName ;
        }
        if(Schema.sObjectType.Lead.fields.Last_Gift_Send__c.isUpdateable()) {
           contct.Last_Gift_Send__c = system.today();
        }
        check = true;
        Task taskObject = new Task();
        if(Schema.sObjectType.Task.fields.subject.isCreateable()){
           taskObject.subject = 'Gift Intiated - ' + giftName ;
        }
        if(Schema.sObjectType.Task.fields.WhoId.isCreateable()){
           taskObject.WhoId = conId;
        }
        if(Schema.sObjectType.Task.fields.ActivityDate.isCreateable()){
           taskObject.ActivityDate = system.today();
        }
        tList.add(taskObject);
        
        try{
            if(check 
                && (Schema.sObjectType.Lead.isAccessible()
                && Schema.sObjectType.Lead.isUpdateable())){
              //  system.debug('contct**'+contct);
                update contct;
            }
            if(!tList.isEmpty()){
              //  system.debug('tList**'+tList); 
                insert tList;
            }
            if(!giftHistoryList.isEmpty() && (Schema.sObjectType.Gift_History__c.isAccessible()
                && Schema.sObjectType.Gift_History__c.isCreateable())){
              //  system.debug('giftHistoryList**'+giftHistoryList);
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