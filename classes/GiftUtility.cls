/*
    Name : GiftUtility
    Description - This class is used as utility to send gifts to Coporate gift api
*/

public with sharing class GiftUtility {

    
    /*
    * Method Name     : sendMassGiftCallout
    * @Description    : This method is used to make single callout to send mass gift.
    */
    public string sendMassGiftCallout(set<string> ContactIds , String giftId , String message ,string greeting ,string recipientName ,string giftName ,string giftType ,string recId){
       
        try{
            list<GiftingSetup__c> merchantList = new list<GiftingSetup__c>();
            merchantList = [Select Id,Merchant_Id__c ,Security_Header__c From GiftingSetup__c WITH SECURITY_ENFORCED limit 1];
            //Map<String, Map<String, Object>> reqBody = new Map<String, Map<String, Object>>();
            Map<String, Object> JsonBody = new Map<String,Object>();
            String greetMessage ='';
            
            List<String> contactIdsList = new List<String>();

            if(giftId != null){
                JsonBody.put('gift_id',giftId);  
            }

            JsonBody.put('merchant_id',merchantList[0].Merchant_Id__c);

            if(greeting != null){
                greetMessage =greetMessage + greeting ;  
            }
            /*if(giftType=='E_gift'){
                JsonBody.put('egift_name',E_GiftName);  
            }*/
            
            List<MassGiftSendController.wrapContact> recipientsList = new List<MassGiftSendController.wrapContact>();
            Map<String,String> recipientsMap = new Map<String,String>();
            for(Contact cont : [Select id, email,Message__c,Phone,Last_Gift_Send__c,Gift_Name__c, firstName,lastName,Name,mailingStreet,mailingCity,mailingState,mailingPostalCode,MailingCountry,Account.Name from contact where Id IN :ContactIds WITH SECURITY_ENFORCED]){
                
                contactIdsList.add(cont.Id);

                String greetMessage1 = greetMessage;
                
                MassGiftSendController.wrapContact cont_Recd = new MassGiftSendController.wrapContact();
                cont_Recd.firstname =cont.FirstName;
                cont_Recd.lastname =cont.lastname;
                //cont_Recd.email =cont.email;
                cont_Recd.street = cont.mailingStreet;
                cont_Recd.zip = cont.mailingPostalCode;
                cont_Recd.state = cont.mailingState;
                cont_Recd.city = cont.mailingCity;
                
                if(recipientName !=null && recipientName !='' && recipientName.contains('Include Just Recipient First Name')){
                    greetMessage1 = greetMessage1 +' '+cont.FirstName  ; 
                    
                }else if(recipientName !=null && recipientName !='' && recipientName.contains('Include Just Recipient Last Name')){
                    greetMessage1 = greetMessage1 +' '+cont.LastName ; 
                    
                }else if(recipientName !=null && recipientName !='' && recipientName.contains('Include Both First and Last Name (Recommended)')){
                    greetMessage1 = greetMessage1 +' '+cont.Name ; 
                    
                }
                
                if(message !=null){
                    greetMessage1 = greetMessage1 +'\n\n'+message; 
                }
                if(greetMessage1 !=null){  
                    cont_Recd.message = greetMessage1;
                } 

                recipientsList.add(cont_Recd);  
            }

         //   System.debug('contactIdsList*****'+contactIdsList);

            
            JsonBody.put('recipients',recipientsList);

            //reqBody.put('payload', JsonBody);

            //string body = JSON.serialize(JsonBody) ;
            string body = JSON.serialize(JsonBody) ;
         //   system.debug('Body**'+body);
            String requestInput = body + '' + merchantList[0].Security_Header__c ;
            Blob requestBlob = Blob.valueOf(requestInput);
            Blob hash = Crypto.generateDigest('MD5', requestBlob);
            String SecurityHeader = EncodingUtil.convertToHex(hash);
       
         //   system.debug('#### BODY MAP '+JsonBody);
          //  system.debug('#### JSON BODY'+JSON.serialize(JsonBody));
            http http2 = new http();
            httpRequest request2 = new httpRequest();
            string endPoint2= System.Label.sendGiftForPhysical; 
            //string endPoint2= 'https://staging.corporategift.com/salesforce/gift/send';
            //string endPoint2= 'https://staging.corporategift.com/salesforce/gift/sendMultiple/';
            request2.setEndpoint(endPoint2);
            request2.setMethod('POST');
            request2.setHeader('Accept','application/json');
            request2.setHeader('Content-Type','application/json');
            request2.setHeader('Api-Signature',SecurityHeader);
            request2.setTimeout(120000);
            request2.setBody(body); 
         //   system.debug('*** RAW BODY '+JsonBody);
         //   system.debug('**** REQUEST BODY '+request2);
            HttpResponse resp2 = http2.send(request2); 
            if(resp2.getStatusCode()==200){
           //     system.debug('SUCCESS responseBody2**'+resp2.getBody());
                map<string,object> responseBody2 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
            //    system.debug('responseBody2**'+responseBody2);
                string rest2 = (string.valueOf(responseBody2.get('success')));
            //    system.debug('rest2**'+rest2);
                if(!responseBody2.isEmpty() && responseBody2.containsKey('success') && rest2=='true'){
                    //createRecordsAfterCallout(String.valueOf(responseBody2.get('order_id')),con.Id,recId,giftId);

                    List<Object> ordersObjList = new List<Object>();

                    ordersObjList = (List<Object>) responseBody2.get('orders');

                    List<String> increamentIds = new List<String>();

                    for(Object obj : ordersObjList){

                        Map<String, Object> objMap = new Map<String, Object>();

                        objMap = (Map<string,Object>) obj;

                        increamentIds.add(String.valueOf(objMap.get('increment_id')));
                    }

                 //   System.debug('increamentIds*****'+increamentIds);

                    createRecordsAfterCallout(increamentIds ,giftId,recId, giftName, contactIdsList); 
                  //   system.debug('#### SUCCESS '+JSON.serialize(responseBody2));
                    return '{"success":"true","message":"Gift send successfully!"}';
                }else{
                  //  system.debug('#### SUCCESS '+JSON.serialize(responseBody2));
                    return JSON.serialize(responseBody2);
                }
            }
            else{
                Map<String,String> msgMap = new Map<String,String>();
                msgMap.put('success', 'false');
                msgMap.put('message',resp2.getStatusCode()+' Error Occure');
               //  system.debug('#### ERROR '+JSON.serialize(msgMap));
                return JSON.serialize(msgMap);
                // return '{"success":"false","message":"'+resp2.getStatusCode()+' Error encountered"}';
            }
               
        }
        catch(Exception ex){
         //   System.debug('**** EXCEPTION ENCOUNTERED ****'+ex.getLineNumber()+' =>'+ex.getMessage() );
            Map<String,String> msgMap = new Map<String,String>();
                msgMap.put('success', 'false');
                msgMap.put('message',' Gift can not be send, Exception '+ex.getMessage()+' Encountered');
        //    system.debug('#### EXCEPTION '+JSON.serialize(msgMap));
                return JSON.serialize(msgMap);
                // return '{"success":"false","message":"Gift can not be send, Exception : "'+ex.getMessage()+'}';
        }   
    }
    
    
    
    //AFTER RESPONSE METHOD
    public void createRecordsAfterCallout(List<String> increamentIds,string giftId,string recId,string giftName, List<String> contactIdsList){
        
        List<Task> tList = new List<Task>();
        List<Gift_History__c> giftHistoryList = new List<Gift_History__c>();
        list<Contact> conLstToUpdate = new List<Contact>();
        Boolean check = false;
        //system.debug('gft_id**'+gft_id);
      //  system.debug('conId List**'+contactIdsList);
        string status = '';
        Integer index = 0;
        
        map<String,Contact> contactIdVsContactObject = new map<String,Contact>();
        for(Contact con : [Select id from Contact where id in : contactIdsList WITH SECURITY_ENFORCED ]){
            contactIdVsContactObject.put(con.id,con);
        }
        
        try{
            for(String contId : contactIdsList){
                Contact contct = new Contact();
               
                contct.id =contId;
                
                Gift_History__c gh = new Gift_History__c();
                if(Schema.sObjectType.Contact.fields.Gift_Id__c.isUpdateable())
                    //contct.Gift_Id__c = gft_id ;
                    if( index < increamentIds.size() && increamentIds[index] != null &&
                        (Schema.sObjectType.Contact.fields.Gift_Id__c.isAccessible()&&
                        Schema.sObjectType.Contact.fields.Gift_Id__c.isUpdateable())){
                        contct.Gift_Id__c = increamentIds[index];
                    }
                    
                //CREATE GIFT HISTORY RECORD ***
             //   system.debug('gift_name++'+recId);
                if(Schema.sObjectType.Gift_History__c.fields.Sent_To__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Sent_To__c.isCreateable()){
                    gh.Sent_To__c = contId;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Gift__c.isCreateable()){
                    gh.Gift__c = recId ;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isCreateable()){
                    gh.Gift_Id__c = giftId ;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isCreateable()){
                    gh.Sent_Date__c = system.today();
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isCreateable())
                    //gh.Gift_Status_Id__c = gft_id;   
                if( index < increamentIds.size() && increamentIds[index] != null
                    && (Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isCreateable())){
                    gh.Gift_Status_Id__c = increamentIds[index];
                    }
                       
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isCreateable()){
                    gh.Gift_Status__c = 'Created';
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isCreateable()){
                    gh.Shipping_Status__c = 'Created';
                    }
                giftHistoryList.add(gh);
                
                // UPDATE CONTACT RECORD***s

                    if(Schema.sObjectType.Contact.fields.GiftOnTheWay__c.isUpdateable()) {
                        contct.GiftOnTheWay__c = true;
                    if(Schema.sObjectType.Contact.fields.Gift_Name__c.isUpdateable()) {
                        contct.Gift_Name__c = giftName ;
                    }
                    if(Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isUpdateable()) {
                        contct.Last_Gift_Send__c = system.today();
                    }
                    conLstToUpdate.add(contct);
                }
                else if(Schema.sObjectType.Contact.fields.Gift_Name__c.isUpdateable()) {
                    contct.Gift_Name__c = giftName ;
                    if(Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isUpdateable()) {
                        contct.Last_Gift_Send__c = system.today();
                    }
                    conLstToUpdate.add(contct);
                }
                else if(Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isUpdateable()) {
                    contct.Last_Gift_Send__c = system.today();
                    conLstToUpdate.add(contct);
                }
                
                // CREATE A NEW TASK***
                Task taskObject = new Task();
                if(Schema.sObjectType.Task.fields.subject.isAccessible()
                    && Schema.sObjectType.Task.fields.subject.isCreateable()){
                    taskObject.subject = 'Gift Intiated - ' + giftName ;
                    }
                if(Schema.sObjectType.Task.fields.WhoId.isAccessible()
                    && Schema.sObjectType.Task.fields.WhoId.isCreateable()){
                    taskObject.WhoId = contId;
                    }
                if(Schema.sObjectType.Task.fields.ActivityDate.isAccessible()
                    && Schema.sObjectType.Task.fields.ActivityDate.isCreateable()){
                    taskObject.ActivityDate = system.today();
                    }
                
                tList.add(taskObject);

                index++;
            }
            
            if(!conLstToUpdate.isEmpty()&&
            (Schema.sObjectType.Contact.isAccessible()&&
            Schema.sObjectType.Contact.isUpdateable())){
             //   system.debug('Update contct**'+conLstToUpdate);
                update conLstToUpdate;
            }
            if(!tList.isEmpty()
                && (Schema.sObjectType.Task.isCreateable() && Schema.sObjectType.Task.isCreateable())){
                //system.debug('Update Task**'+tList);
                insert tList;
            }
            if(!giftHistoryList.isEmpty()
                && (Schema.sObjectType.Gift_History__c.isAccessible()
                && Schema.sObjectType.Gift_History__c.isCreateable())){
                //system.debug('Update giftHistoryList**'+giftHistoryList);
                insert giftHistoryList;
            }
        }
        catch(Exception ex){
         //   system.debug('EXCEPTION => '+ex.getMessage() + '  Line'+ex.getLineNumber());
        } 
    }
    /*
    * Method Name     : sendMassEGiftCallout
    * @Description    : This method is used to make single callout to send mass Egift.
    */
    public string sendMassEGiftCalloutLead(set<string> ContactIds , String giftId , String message ,string greeting ,string recipientName ,string giftName ,string giftType ,string recId ,string E_GiftName){
        
        try{
            list<GiftingSetup__c> merchantList = new list<GiftingSetup__c>();
            merchantList = [Select Id,Merchant_Id__c ,Security_Header__c From GiftingSetup__c WITH SECURITY_ENFORCED limit 1];
            Map<String, Object> JsonBody = new Map<String,Object>();
            String greetMessage ='';
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
            
            List<FinalSendGift_Class.wrapContact> recipientsList = new List<FinalSendGift_Class.wrapContact>();
            Map<String,String> recipientsMap = new Map<String,String>();
            for(Lead cont : [Select id, email,Phone,Last_Gift_Send__c,Gift_Name__c, firstName,lastName,Name,Street,City,State,PostalCode,Country from Lead where Id IN :ContactIds WITH SECURITY_ENFORCED]){
                FinalSendGift_Class.wrapContact cont_Recd = new FinalSendGift_Class.wrapContact();
                cont_Recd.firstname =cont.FirstName;
                cont_Recd.email =cont.email;
                cont_Recd.lastname =cont.lastname;
                recipientsList.add(cont_Recd);  
                
              
            }
            
             if(recipientName !=null && recipientName !='' && recipientName.contains('Include Just Recipient First Name')){
                    greetMessage = greetMessage +' '+'<First Name>'  ; 
                    
                }else if(recipientName !=null && recipientName !='' && recipientName.contains('Include Just Recipient Last Name')){
                    greetMessage = greetMessage +' '+'<Last Name>' ; 
                    
                }else if(recipientName !=null && recipientName !='' && recipientName.contains('Include Both First and Last Name (Recommended)')){
                    greetMessage = greetMessage +' '+'<First Name> <Last Name>' ; 
                    
                }
                
                if(message !=null){
                    greetMessage = greetMessage +'\n\n'+message; 
                }
                if(greetMessage !=null){
                    JsonBody.put('message',greetMessage);  
                } 
            JsonBody.put('recipients',recipientsList);
            string body = JSON.serialize(JsonBody) ;
         //   system.debug('Body**'+body);
            String requestInput = body + '' + merchantList[0].Security_Header__c ;
            Blob requestBlob = Blob.valueOf(requestInput);
            Blob hash = Crypto.generateDigest('MD5', requestBlob);
            String SecurityHeader = EncodingUtil.convertToHex(hash);
       
         //   system.debug('#### BODY MAP '+JsonBody);
         //   system.debug('#### JSON BODY'+JSON.serialize(JsonBody));
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
        //    system.debug('*** RAW BODY '+JsonBody);
        //    system.debug('**** REQUEST BODY '+request2);
            HttpResponse resp2 = http2.send(request2); 
            map<string,object> responseBody3 = new map<string,object>();
            if(resp2.getStatusCode()==200){
           //     system.debug('SUCCESS responseBody3**'+resp2.getBody());
                responseBody3 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
            //    system.debug('responseBody3**'+responseBody3);
                string rest2 = (string.valueOf(responseBody3.get('success')));
            //    system.debug('rest2**'+rest2);
                if(!responseBody3.isEmpty() && responseBody3.containsKey('success') && rest2=='true'){
                    //createRecordsAfterCallout(String.valueOf(responseBody3.get('order_id')),con.Id,recId,giftId);
                    createRecordsAfterEGiftCalloutLead(String.valueOf(responseBody3.get('order_id')) ,giftId,recId, giftName, ContactIds); 
                //     system.debug('#### SUCCESS '+JSON.serialize(responseBody3));
                    return '{"success":"true","message":"Gift send successfully!"}';
                }else{
                  //  system.debug('#### SUCCESS '+JSON.serialize(responseBody3));
                    return JSON.serialize(responseBody3);
                }
            }
            else{
                Map<String,String> msgMap = new Map<String,String>();
                msgMap.put('success', 'false');
                msgMap.put('message',resp2.getStatusCode()+' Error Occure');
               //  system.debug('#### ERROR '+JSON.serialize(msgMap));
                return JSON.serialize(msgMap);
                // return '{"success":"false","message":"'+resp2.getStatusCode()+' Error encountered"}';
            }
               
        }
        catch(Exception ex){
         //   System.debug('**** EXCEPTION ENCOUNTERED ****'+ex.getLineNumber()+' =>'+ex.getMessage() );
            Map<String,String> msgMap = new Map<String,String>();
                msgMap.put('success', 'false');
                msgMap.put('message',' Gift can not be send, Exception '+ex.getMessage()+' Encountered');
          //  system.debug('#### EXCEPTION '+JSON.serialize(msgMap));
                return JSON.serialize(msgMap);
                // return '{"success":"false","message":"Gift can not be send, Exception : "'+ex.getMessage()+'}';
        }   
    }
    
    //AFTER RESPONSE METHOD
    public void createRecordsAfterEGiftCalloutLead(string gft_id,string giftId,string recId,string giftName, set<String> ContactIds){
        
        List<Task> tList = new List<Task>();
        List<Gift_History__c> giftHistoryList = new List<Gift_History__c>();
        list<Lead> conLstToUpdate = new List<Lead>();
        Boolean check = false;
     //   system.debug('gft_id**'+gft_id);
    //    system.debug('conId List**'+ContactIds);
        string status = '';
        
        map<String,Lead > contactIdVsContactObject = new map<String,Lead >();
        for(Lead con : [Select id from Lead where id in : ContactIds WITH SECURITY_ENFORCED ]){
            contactIdVsContactObject.put(con.id,con);
        }
        
        try{
            for(String contId : ContactIds){
                Lead contct = new Lead();
                if(Schema.sObjectType.Lead.fields.Id.isAccessible() 
                && Schema.sObjectType.Lead.fields.Id.isUpdateable()){
                contct.id =contId;
                }
                Gift_History__c gh = new Gift_History__c();
                if(Schema.sObjectType.Lead.fields.Gift_Id__c.isAccessible()
                    && Schema.sObjectType.Lead.fields.Gift_Id__c.isUpdateable()){
                    contct.Gift_Id__c = gft_id ;
                    }
                //CREATE GIFT HISTORY RECORD ***
             //   system.debug('gift_name++'+recId);
                if(Schema.sObjectType.Gift_History__c.fields.Lead__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Lead__c.isCreateable()){
                    gh.Lead__c = contId;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Gift__c.isCreateable()){
                    gh.Gift__c = recId ;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isCreateable()){
                    gh.Gift_Id__c = giftId ;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isCreateable()){
                    gh.Sent_Date__c = system.today();
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isCreateable()
                    && Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isCreateable()){
                    gh.Gift_Status_Id__c = gft_id;
                    }       
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isCreateable()){
                    gh.Gift_Status__c = 'Created';
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isCreateable()){
                    gh.Shipping_Status__c = 'Created';
                    }
                giftHistoryList.add(gh);
                
                // UPDATE CONTACT RECORD***s

                    if(Schema.sObjectType.Lead.fields.Gift_On_The_Way__c.isUpdateable()) {
                        contct.Gift_On_The_Way__c = true;
                    if(Schema.sObjectType.Lead.fields.Gift_Name__c.isUpdateable()) {
                        contct.Gift_Name__c = giftName ;
                    }
                    if(Schema.sObjectType.Lead.fields.Last_Gift_Send__c.isUpdateable()) {
                        contct.Last_Gift_Send__c = system.today();
                    }
                    conLstToUpdate.add(contct);
                }
                else if(Schema.sObjectType.Lead.fields.Gift_Name__c.isUpdateable()) {
                    contct.Gift_Name__c = giftName ;
                    if(Schema.sObjectType.Lead.fields.Last_Gift_Send__c.isUpdateable()) {
                        contct.Last_Gift_Send__c = system.today();
                    }
                    conLstToUpdate.add(contct);
                }
                else if(Schema.sObjectType.Lead.fields.Last_Gift_Send__c.isUpdateable()) {
                    contct.Last_Gift_Send__c = system.today();
                    conLstToUpdate.add(contct);
                }
                
                // CREATE A NEW TASK***
                Task taskObject = new Task();
                if(Schema.sObjectType.Task.fields.subject.isAccessible()
                    && Schema.sObjectType.Task.fields.subject.isCreateable()){
                    taskObject.subject = 'Gift Intiated - ' + giftName ;
                    }
                if(Schema.sObjectType.Task.fields.WhoId.isAccessible()
                    && Schema.sObjectType.Task.fields.WhoId.isCreateable()){
                    taskObject.WhoId = contId;
                    }
                if(Schema.sObjectType.Task.fields.ActivityDate.isAccessible()
                    && Schema.sObjectType.Task.fields.ActivityDate.isCreateable()){
                    taskObject.ActivityDate = system.today();
                    }
                
                tList.add(taskObject);
            }
            
            if(!conLstToUpdate.isEmpty()
                && (Schema.sObjectType.Lead.isAccessible()
                && Schema.sObjectType.Lead.isUpdateable())){
                //system.debug('Update contct**'+conLstToUpdate);
                update conLstToUpdate;
            }
            if(!tList.isEmpty()
                && (Schema.sObjectType.Task.isAccessible() && Schema.sObjectType.Task.isCreateable())){
                //system.debug('Update Task**'+tList);
                insert tList;
            }
            if(!giftHistoryList.isEmpty()
                && (Schema.sObjectType.Gift_History__c.isAccessible()
                && Schema.sObjectType.Gift_History__c.isCreateable())){
                //system.debug('Update giftHistoryList**'+giftHistoryList);
                insert giftHistoryList;
            }
        }
        catch(Exception ex){
          //  system.debug('EXCEPTION => '+ex.getMessage() + '  Line'+ex.getLineNumber());
        } 
    }
}