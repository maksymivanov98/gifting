/*-************************************************************************************************************
* Name         : MassGiftSendBatchClass
* @Author      : 
* @Date        : 
* @Description : The MassGiftSendBatchClass controller is used for Sending gifts to selected contacts.
* UPDATES
* Version          Developer                    Date                        Description
*-------------------------------------------------------------------------------------------
*     1.0          Piyush kalra                20 Nov 2019                 Initial Creation 
***************************************************************************************************************/
global with Sharing class MassGiftSendBatchClass implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
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
    global string E_GiftName ;
    global Contact contct = new Contact();
    global List<Task> tList = new List<Task>();
    global List<Gift_History__c> giftHistoryList = new List<Gift_History__c>();
    global Map<string,string> jsonBody = new Map<string,string>();
    global Map<string,string> jsonBodyStatus = new Map<string,string>();
    
    
    global MassGiftSendBatchClass(set<string> conIds){
        ContactIds = conIds ;
       // system.debug('##### Selected Contact List'+conIds);
    }
    global MassGiftSendBatchClass(set<string> conIds , String giftId1 , String message1 ,string greeting1 ,string recipientName1 ,string giftName1 ,string giftType1 ,string recId1){
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
    global MassGiftSendBatchClass(set<string> conIds , String giftId1 , String message1 ,string greeting1 ,string recipientName1 ,string giftName1 ,string giftType1 ,string recId1 ,string E_GiftName){
     //   system.debug('recipientName1**'+recipientName1);
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
     //   system.debug('### greeting**'+greeting);
     //   system.debug('### ContactIds**'+ContactIds);
        String query = 'Select id, email,Message__c,Phone,Last_Gift_Send__c,Gift_Name__c, firstName,lastName,Name,mailingStreet,mailingCity,mailingState,mailingPostalCode,MailingCountry,Account.Name from contact where Id IN :ContactIds WITH SECURITY_ENFORCED';
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope) {
      //  system.debug('giftName**'+giftName);
     //   system.debug('recipientName**'+recipientName);
      //  system.debug('E_GiftName**'+E_GiftName);
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
        for(Contact con : scope){
            if(con.FirstName ==null && Schema.sObjectType.Contact.fields.FirstName.isUpdateable()){
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
                if(con.mailingStreet!=null){
                    JsonBody.put('street',con.mailingStreet);  
                }
                if(con.mailingCity!=null){
                    JsonBody.put('city',con.mailingCity);  
                }
                if(con.mailingState!=null){
                    JsonBody.put('state',con.mailingState);  
                }
                if(con.mailingPostalCode!=null){
                    JsonBody.put('zip',con.mailingPostalCode);  
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
            String requestInput = body + '' + merchantList[0].Security_Header__c ;
            Blob requestBlob = Blob.valueOf(requestInput);
            Blob hash = Crypto.generateDigest('MD5', requestBlob);
            String SecurityHeader = EncodingUtil.convertToHex(hash);
          
            
            http http2 = new http();
            httpRequest request2 = new httpRequest();
            string endPoint2= System.Label.sendGiftURL; 
            //string endPoint2= 'https://staging.corporategift.com/salesforce/gift/send';
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
     //   system.debug('gft_id**'+gft_id);
     //   system.debug('conId**'+conId);
        string status = '';
        jsonBodyStatus.put('merchant_id','6200');
        jsonBodyStatus.put('order_id',gft_id);
        map<String,Contact> contactIdVsContactObject = new map<String,Contact>();
        
        
        if(Schema.sObjectType.Contact.fields.Id.isAccessible() 
        && Schema.sObjectType.Contact.fields.Id.isUpdateable()){
         contct.id =conId;        
        }
        
        if(Schema.sObjectType.Contact.fields.Gift_Id__c.isUpdateable()) {
           contct.Gift_Id__c = gft_id ;
        }
      
        
      //  system.debug('gift_name++'+recId);
        Gift_History__c gh = new Gift_History__c();
       // gh.name = giftName ;
        if(Schema.sObjectType.Gift_History__c.fields.Sent_To__c.isCreateable()){
           gh.Sent_To__c = conId;
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
      
      /*  if(status !=null){
            gh.Gift_Status__c = status ;
            gh.Shipping_Status__c = status; 
        }else{
            gh.Gift_Status__c = '' ;
            gh.Shipping_Status__c = ''; 
        } */
        
        giftHistoryList.add(gh);

        if(Schema.sObjectType.Contact.fields.GiftOnTheWay__c.isUpdateable()) {
          contct.GiftOnTheWay__c = true;
        }
        if(Schema.sObjectType.Contact.fields.Gift_Name__c.isUpdateable()) {
         contct.Gift_Name__c = giftName ;
        }
        if(Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isUpdateable()) {
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
                && (Schema.sObjectType.Contact.isAccessible()
                && Schema.sObjectType.Contact.isUpdateable())){
             //   system.debug('contct**'+contct);
                update contct;
            }
            if(!tList.isEmpty()){
             //   system.debug('tList**'+tList);
                insert tList;
            }
            if(!giftHistoryList.isEmpty() && (Schema.sObjectType.Gift_History__c.isAccessible()
                && Schema.sObjectType.Gift_History__c.isCreateable())){
              //  system.debug('giftHistoryList**'+giftHistoryList);
                insert giftHistoryList;
            }
        }
        catch(Exception ex){
         //   system.debug('Message '+ex.getMessage() + '  Line'+ex.getLineNumber());
        } 
    }
    
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
}