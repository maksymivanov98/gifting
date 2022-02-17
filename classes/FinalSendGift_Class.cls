/*-************************************************************************************************************
* Name         : FinalSendGift_Class
* @Author      : 
* @Date        : 
* @Description : The FinalSendGift_Class class is used for Sending gifts to selected contacts.
* UPDATES
* Version          Developer                    Date                        Description
*-------------------------------------------------------------------------------------------
*     1.0          Piyush kalra                17 Apr 2020                 Initial Creation 
***************************************************************************************************************/
public with sharing class FinalSendGift_Class {
    
    /* public static string sendGiftCallout(set<string> ContactIds , String giftId , String message ,string greeting ,
            string recipientName ,string giftName ,string giftType ,string recId ,string E_GiftName ,Boolean reGift, String sObjectType, Integer can_create_dedicated_links, String video_url, String emailSubject,map<String,products__c> giftIdVsgiftProduct){
       
        try{
            User runningUser = [SELECT id , email FROM User where id=:UserInfo.getUserId() WITH SECURITY_ENFORCED];
            list<GiftMerchant__c> merchantList = new list<GiftMerchant__c>();
            merchantList = [Select Id,MerchantId__c ,Security_Header__c From GiftMerchant__c WITH SECURITY_ENFORCED limit 1];
            Map<String, Object> JsonBody = new Map<String,Object>();
            String greetMessage ='';
            JsonBody.put('merchant_id',merchantList[0].MerchantId__c);
            if(giftId != null){
                JsonBody.put('gift_id',giftId);  
            }
            if(greeting != null){
                greetMessage =greetMessage + greeting ; 
            }
            if(giftType=='E_gift'){
                JsonBody.put('egift_name',E_GiftName);

                if( can_create_dedicated_links != null ){
                    JsonBody.put('can_create_dedicated_links',can_create_dedicated_links);
                }

                if( video_url != null && video_url.trim() != ''){
                    JsonBody.put('video_url',video_url);
                }

                if( emailSubject != null && emailSubject.trim() != ''
                    && ( can_create_dedicated_links == null || can_create_dedicated_links == 0 )){
                    JsonBody.put('subject',emailSubject);
                }
                
            }
            
            List<FinalSendGift_Class.wrapContact> recipientsList = new List<FinalSendGift_Class.wrapContact>();
            Map<String,String> recipientsMap = new Map<String,String>();
            map<String, String> recordIdVsEmail = new map <String,String>();
            
            //Added method to generalise object in one mthod. 
            // Fixed by PK on 2nd Aug
            if(sObjectType != null && sObjectType == 'Contact'){
                for(Contact cont : [Select id, email,Message__c,Phone,Last_Gift_Send__c,Gift_Name__c, firstName,lastName FROM Contact where Id IN :ContactIds]){
                    FinalSendGift_Class.wrapContact cont_Recd = new FinalSendGift_Class.wrapContact();
                    cont_Recd.firstname =cont.FirstName;
                    cont_Recd.email =cont.email;
                    cont_Recd.lastname =cont.lastname;
                    recipientsList.add(cont_Recd);  
                    recordIdVsEmail.put(cont.id, cont.email);
                }
            }
            else if(sObjectType != null && sObjectType == 'Lead'){
                for(Lead  cont : [Select id, email,Phone,Last_Gift_Send__c,Gift_Name__c, firstName,lastName FROM Lead where Id IN :ContactIds]){
                    FinalSendGift_Class.wrapContact cont_Recd = new FinalSendGift_Class.wrapContact();
                    cont_Recd.firstname =cont.FirstName;
                    cont_Recd.email =cont.email;
                    cont_Recd.lastname =cont.lastname;
                    recipientsList.add(cont_Recd);  
                    recordIdVsEmail.put(cont.id, cont.email);
                }   
            }            
            
            if(recipientName !=null && recipientName !='' && recipientName.contains('Include Just Recipient First Name')){
                greetMessage = greetMessage +' '+'<First Name>'  ; 
                
            }else if(recipientName !=null && recipientName !='' && recipientName.contains('Include Just Recipient Last Name')){
                greetMessage = greetMessage +' '+'<Last Name>' ; 
                
            }else if(recipientName !=null && recipientName !='' && recipientName.contains('Include Both First and Last Name (Recommended)')){
                greetMessage = greetMessage +' '+'<First Name> <Last Name>' ; 
                
            }
            
            if(message !=null && (can_create_dedicated_links == null || can_create_dedicated_links == 0) ){
                greetMessage = greetMessage +'\n\n'+message; 
            }
            if(greetMessage !=null){
                JsonBody.put('message',greetMessage);  
            } 
            JsonBody.put('upgrade_regift' , reGift);

            JsonBody.put('user' , runningUser.Email);
            JsonBody.put('recipients',recipientsList);

            string body = JSON.serialize(JsonBody) ;
            system.debug('Body**'+body);
            String requestInput = body + '' + merchantList[0].Security_Header__c ;
            System.debug('requestInput **'+requestInput );
            Blob requestBlob = Blob.valueOf(requestInput);
            Blob hash = Crypto.generateDigest('MD5', requestBlob);
            String SecurityHeader = EncodingUtil.convertToHex(hash);
            System.debug('SecurityHeader **'+SecurityHeader );

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

            if( resp2.getStatusCode() == 200 ){
                map<string,object> responseBody2 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
                
                string rest2 = (string.valueOf(responseBody2.get('success')));
                if(!responseBody2.isEmpty() && responseBody2.containsKey('success') && rest2=='true'){
                    //createRecordsAfterCallout(String.valueOf(responseBody2.get('order_id')),con.Id,recId,giftId);
                    
                    String dedicatedUrl = null;
                    if( responseBody2.containskey('url') && responseBody2.get('url') != null  ){
                        dedicatedUrl = String.valueof(responseBody2.get('url'));
                    }
                    
                    map<String, String> emailVsUrlMap = new map<String, String>();
                    String showUrl = 'false';
                    if(can_create_dedicated_links == 1 && giftType == 'E_gift' && ContactIds.size() > 1
                        && dedicatedUrl != null ){

                        showUrl = 'true';
                        http httpObj = new http();
                        httpRequest requestInner = new httpRequest();
                        requestInner.setEndpoint(dedicatedUrl);
                        requestInner.setMethod('GET');
                        requestInner.setHeader('Accept','application/json');
                        requestInner.setHeader('Content-Type','application/json');
                        requestInner.setTimeout(120000);
                        
                        HttpResponse responseInnerCsv = httpObj.send(requestInner); 
                        if(responseInnerCsv.getStatusCode()==200){
                            
                            String[] contactDataLines = new String[]{};
                                contactDataLines = responseInnerCsv.getBody().split('\n');
                            
                            Map < String, Integer > fieldNumberMap = new Map < String, Integer > ();
                            string[] csvFieldNames = contactDataLines[0].split(',');
                            for (Integer i = 0; i < csvFieldNames.size(); i++) {
                                fieldNumberMap.put(csvFieldNames[i], i);
                            }
                            
                            for (Integer i = 1; i < contactDataLines.size(); i++) {
                                string[] csvRecordData = contactDataLines[i].split(',');
                                emailVsUrlMap.put(csvRecordData[fieldNumberMap.get('Email')], csvRecordData[fieldNumberMap.get('Url')]);
                                
                            }
                        }
                        
                    }
                    createRecordsAfterCallout(String.valueOf(responseBody2.get('order_id')) ,giftId, recId, giftName, giftType, ContactIds , sObjectType, dedicatedUrl,recordIdVsEmail, emailVsUrlMap,giftIdVsgiftProduct); 
                     
                    
                    Map<String,String> msgMap = new Map<String,String>();
                    msgMap.put('success', 'true');
                    msgMap.put('message', 'Gift send successfully!');
                    msgMap.put('showUrl', showUrl);
                    msgMap.put('Url', dedicatedUrl);
                    msgMap.put('size', ContactIds.size() + '');
                    
                    
                    return JSON.serialize(msgMap);
                   // return '{"success":"true","message":"Gift send successfully!", "showUrl" : "' + showUrl '" , "Url": "'+ dedicatedUrl +'" }';
                }else{
                    system.debug('#### SUCCESS '+JSON.serialize(responseBody2));
                    return JSON.serialize(responseBody2);
                }
            }
            else{
                Map<String,String> msgMap = new Map<String,String>();
                msgMap.put('success', 'false');
                msgMap.put('message',resp2.getStatusCode()+' Error Occure');
                system.debug('#### ERROR '+JSON.serialize(msgMap));
                createExceptionRecord(resp2.getBody()); 
                return JSON.serialize(msgMap);
                // return '{"success":"false","message":"'+resp2.getStatusCode()+' Error encountered"}';
            }
               
        }
        catch(Exception ex){
            System.debug('**** EXCEPTION ENCOUNTERED ****'+ex.getLineNumber()+' =>'+ex.getMessage() );
            Map<String,String> msgMap = new Map<String,String>();
                msgMap.put('success', 'false');
                createExceptionRecord(ex.getMessage());
                msgMap.put('message',' Gift can not be send, Exception '+ex.getMessage()+' Encountered');
            system.debug('#### EXCEPTION '+JSON.serialize(msgMap));
                return JSON.serialize(msgMap);
                // return '{"success":"false","message":"Gift can not be send, Exception : "'+ex.getMessage()+'}';
        }   
    }
    */
    public static string sendGiftCallout(set<string> ContactIds , String giftId , String message ,string greeting ,
            string recipientName ,string giftName ,string giftType ,string recId ,string E_GiftName ,Boolean reGift, String sObjectType, Integer can_create_dedicated_links, String video_url, String emailSubject,map<String,products__c> giftIdVsgiftProduct, String budgetSelected,Integer Quantity){
       System.debug('potapenko in sendGiftCallout method');
        try{
            User runningUser = [SELECT id , email FROM User where id=:UserInfo.getUserId() WITH SECURITY_ENFORCED];
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

                if( can_create_dedicated_links != null ){
                    JsonBody.put('can_create_dedicated_links',can_create_dedicated_links);
                }

                if( video_url != null && video_url.trim() != ''){
                    JsonBody.put('video_url',video_url);
                }

                if( emailSubject != null && emailSubject.trim() != ''
                    && ( can_create_dedicated_links == null || can_create_dedicated_links == 0 )){
                    JsonBody.put('subject',emailSubject);
                }
                
            }
            if(budgetSelected != null){
                JsonBody.put('budget_id',budgetSelected);

            }
            List<FinalSendGift_Class.wrapContact> recipientsList = new List<FinalSendGift_Class.wrapContact>();
            Map<String,String> recipientsMap = new Map<String,String>();
            map<String, String> recordIdVsEmail = new map <String,String>();
            
            //Added method to generalise object in one mthod. 
            // Fixed by PK on 2nd Aug
            if(sObjectType != null && sObjectType == 'Contact'){
                for(Contact cont : [Select id, email,Message__c,Phone,Last_Gift_Send__c,Gift_Name__c, firstName,lastName FROM Contact where Id IN :ContactIds WITH SECURITY_ENFORCED]){
                    FinalSendGift_Class.wrapContact cont_Recd = new FinalSendGift_Class.wrapContact();
                    cont_Recd.firstname =cont.FirstName;
                    cont_Recd.email =cont.email;
                    cont_Recd.lastname =cont.lastname;
                    recipientsList.add(cont_Recd);  
                    recordIdVsEmail.put(cont.id, cont.email);
                }
            }
            else if(sObjectType != null && sObjectType == 'Lead'){
                for(Lead  cont : [Select id, email,Phone,Last_Gift_Send__c,Gift_Name__c, firstName,lastName FROM Lead where Id IN :ContactIds WITH SECURITY_ENFORCED]){
                    FinalSendGift_Class.wrapContact cont_Recd = new FinalSendGift_Class.wrapContact();
                    cont_Recd.firstname =cont.FirstName;
                    cont_Recd.email =cont.email;
                    cont_Recd.lastname =cont.lastname;
                    recipientsList.add(cont_Recd);  
                    recordIdVsEmail.put(cont.id, cont.email);
                }   
            }            
            
            if(recipientName !=null && recipientName !='' && recipientName.contains('Include Just Recipient First Name')){
                greetMessage = greetMessage +' '+'<First Name>'  ; 
                
            }else if(recipientName !=null && recipientName !='' && recipientName.contains('Include Just Recipient Last Name')){
                greetMessage = greetMessage +' '+'<Last Name>' ; 
                
            }else if(recipientName !=null && recipientName !='' && recipientName.contains('Include Both First and Last Name (Recommended)')){
                greetMessage = greetMessage +' '+'<First Name> <Last Name>' ; 
                
            }
            
            if(message !=null && (can_create_dedicated_links == null || can_create_dedicated_links == 0) ){
                greetMessage = greetMessage +'\n\n'+message; 
            }
            if(greetMessage !=null){
                JsonBody.put('message',greetMessage);  
            } 
            JsonBody.put('upgrade_regift' , reGift);

            JsonBody.put('user' , runningUser.Email);
            JsonBody.put('recipients',recipientsList);
            if(Quantity !=null){
                JsonBody.put('qty',Quantity);  
            }
            string body = JSON.serialize(JsonBody) ;
        //    system.debug('Body**'+body);
            String requestInput = body + '' + merchantList[0].Security_Header__c ;
        //    System.debug('requestInput **'+requestInput );
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
            System.debug('potapenko send gift checking second response ' + resp2.getStatusCode() + ' ' + resp2.getBody());
            if( resp2.getStatusCode() == 200 ){
                map<string,object> responseBody2 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
                
                string rest2 = (string.valueOf(responseBody2.get('success')));
                if(!responseBody2.isEmpty() && responseBody2.containsKey('success') && rest2=='true'){
                    //createRecordsAfterCallout(String.valueOf(responseBody2.get('order_id')),con.Id,recId,giftId);
                    
                    String dedicatedUrl = null;
                    if( responseBody2.containskey('url') && responseBody2.get('url') != null  ){
                        dedicatedUrl = String.valueof(responseBody2.get('url'));
                    }
                    
                    map<String, String> emailVsUrlMap = new map<String, String>();
                    String showUrl = 'false';
                    if(can_create_dedicated_links == 1 && giftType == 'E_gift' && ContactIds.size() > 1
                        && dedicatedUrl != null ){

                        showUrl = 'true';
                        http httpObj = new http();
                        httpRequest requestInner = new httpRequest();
                        requestInner.setEndpoint(dedicatedUrl);
                        requestInner.setMethod('GET');
                        requestInner.setHeader('Accept','application/json');
                        requestInner.setHeader('Content-Type','application/json');
                        requestInner.setTimeout(120000);
                        
                        HttpResponse responseInnerCsv = httpObj.send(requestInner); 
                        if(responseInnerCsv.getStatusCode()==200){
                            
                            String[] contactDataLines = new String[]{};
                                contactDataLines = responseInnerCsv.getBody().split('\n');
                            
                            Map < String, Integer > fieldNumberMap = new Map < String, Integer > ();
                            string[] csvFieldNames = contactDataLines[0].split(',');
                            for (Integer i = 0; i < csvFieldNames.size(); i++) {
                                fieldNumberMap.put(csvFieldNames[i], i);
                            }
                            
                            for (Integer i = 1; i < contactDataLines.size(); i++) {
                                string[] csvRecordData = contactDataLines[i].split(',');
                                emailVsUrlMap.put(csvRecordData[fieldNumberMap.get('Email')], csvRecordData[fieldNumberMap.get('Url')]);
                                
                            }
                        }
                        
                    }
                    createRecordsAfterCallout(String.valueOf(responseBody2.get('order_id')) ,giftId, recId, giftName, giftType, ContactIds , sObjectType, dedicatedUrl,recordIdVsEmail, emailVsUrlMap,giftIdVsgiftProduct,Quantity); 
                     
                    
                    Map<String,String> msgMap = new Map<String,String>();
                    msgMap.put('success', 'true');
                    msgMap.put('message', 'Gift send successfully!');
                    msgMap.put('showUrl', showUrl);
                    msgMap.put('Url', dedicatedUrl);
                    msgMap.put('size', ContactIds.size() + '');
                    
                    
                    return JSON.serialize(msgMap);
                   // return '{"success":"true","message":"Gift send successfully!", "showUrl" : "' + showUrl '" , "Url": "'+ dedicatedUrl +'" }';
                }else{
                 //   system.debug('#### SUCCESS '+JSON.serialize(responseBody2));
                    return JSON.serialize(responseBody2);
                }
            }
            else{
                Map<String,String> msgMap = new Map<String,String>();
                msgMap.put('success', 'false');
                msgMap.put('message',resp2.getStatusCode()+' Error Occure');
              //  system.debug('#### ERROR '+JSON.serialize(msgMap));
                createExceptionRecord(resp2.getBody()); 
                return JSON.serialize(msgMap);
                // return '{"success":"false","message":"'+resp2.getStatusCode()+' Error encountered"}';
            }
               
        }
        catch(Exception ex){
         //   System.debug('**** EXCEPTION ENCOUNTERED ****'+ex.getLineNumber()+' =>'+ex.getMessage() );
            Map<String,String> msgMap = new Map<String,String>();
                msgMap.put('success', 'false');
                createExceptionRecord(ex.getMessage());
                msgMap.put('message',' Gift can not be send, Exception '+ex.getMessage()+' Encountered');
         //   system.debug('#### EXCEPTION '+JSON.serialize(msgMap));
                return JSON.serialize(msgMap);
                // return '{"success":"false","message":"Gift can not be send, Exception : "'+ex.getMessage()+'}';
        }   
    }    
   
    public static void createExceptionRecord(String message){
        Error_Log__c errorLogRecord = new Error_Log__c();
        if(Schema.sObjectType.Error_Log__c.fields.Error_Message__c.isAccessible()
            && Schema.sObjectType.Error_Log__c.fields.Error_Message__c.isCreateable()){
            errorLogRecord.Error_Message__c = message;
        }
        
        if(Schema.sObjectType.Error_Log__c.isAccessible()
            && Schema.sObjectType.Error_Log__c.isCreateable()){
            insert errorLogRecord;
         }
        
        
    }
    //AFTER RESPONSE METHOD

    public static void createRecordsAfterCallout(string gft_id,string giftId,string recId,string giftName, String giftType, set<String> ContactIds , String sobjectType, String dedicatedUrl, map<String, String> recordIdVsEmail, map<String, String> emailVsUrlMap, map<String,products__c> giftIdVsgiftProduct,Integer Quantity){
        
        List<Task> tList = new List<Task>();
        List<Gift_History__c> giftHistoryList = new List<Gift_History__c>();
        list<Sobject> conLstToUpdate = new List<Sobject>();
        Boolean check = false;

        map<String,Id > recordIdMap = new map<String,ID >();
        for(RecordType type : [select id, developerName from RecordType where SobjectType='Corporate_gift__Gift_History__c' WITH SECURITY_ENFORCED ]){
            recordIdMap.put( type.developerName.tolowercase(), type.Id);
        }
        map<String,Contact> contactIdVsContactObject = new map<String,Contact>();
        map<String,Lead> leadIdVsLeadObject = new map<String,Lead>();
        map<String,String> contactIdVsAccountId = new map<String,String>();

        if(sobjectType != null && sobjectType.equalsIgnoreCase('Lead')){
             for(Lead con : [Select id from Lead where id in : ContactIds WITH SECURITY_ENFORCED ]){
                leadIdVsLeadObject.put(con.id,con);
            }        
        }
        else if(sobjectType != null && sobjectType.equalsIgnoreCase('Contact')){
            for(Contact con : [Select id,AccountId from Contact where id in : ContactIds WITH SECURITY_ENFORCED ]){
                contactIdVsContactObject.put(con.id,con);
                if(con.AccountId != null ){
                    contactIdVsAccountId.put(con.id,con.AccountId);
                }
            }
        }
        

        
        string status = '';
        try{
            for(String contId : ContactIds){
                Sobject contct;
                if(sobjectType != null && sobjectType.equalsIgnoreCase('Lead')){
                    contct = new Lead();
                }
                else if(sobjectType != null && sobjectType.equalsIgnoreCase('Contact')){
                    contct = new Contact();
                }
                
                                // UPDATE CONTACT RECORD***s
              
                contct.id =contId;
             
                
                Gift_History__c gh = new Gift_History__c();
                if( giftType != null && recordIdMap != null && !recordIdMap.isEmpty() 
                    && recordIdMap.containsKey( giftType.toLowerCase() )){
                    if(Schema.sObjectType.Gift_History__c.fields.recordTypeId.isAccessible()){        
                        if(Schema.sObjectType.Gift_History__c.fields.recordTypeId.isCreateable()){
                         gh.recordTypeId = recordIdMap.get( giftType.toLowerCase() );
                        }
                    }
         
                }
                if(sobjectType != null && sobjectType.equalsIgnoreCase('Contact')
                    && (Schema.sObjectType.Gift_History__c.fields.Sent_To__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Sent_To__c.isCreateable())){
                    contct.put('Gift_Id__c' , gft_id) ;
                    gh.Sent_To__c = contId;
                
                }
                else if(sobjectType != null && sobjectType.equalsIgnoreCase('Lead') 
                    && Schema.sObjectType.Gift_History__c.fields.Lead__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Lead__c.isCreateable()
                    && Schema.sObjectType.Lead.fields.Gift_Id__c.isUpdateable() ){
                    contct.put('Gift_Id__c' , gft_id) ;
                    gh.Lead__c = contId;
                } 
                
                //add dedicated url 
                if( dedicatedUrl != null && dedicatedUrl != '' 
                && (Schema.sObjectType.Gift_History__c.fields.Corporate_gift__Dedicated_link__c.isAccessible()
                && Schema.sObjectType.Gift_History__c.fields.Corporate_gift__Dedicated_link__c.isCreateable())){
                    gh.Corporate_gift__Dedicated_link__c = dedicatedUrl;
                }
                if(recordIdVsEmail != null && !recordIdVsEmail.isEmpty() && recordIdVsEmail.containsKey(contId) && emailVsUrlMap != null && !emailVsUrlMap.isEmpty() && emailVsUrlMap.containsKey(recordIdVsEmail.get(contId))){
                    gh.Corporate_gift__Dedicated_link__c = emailVsUrlMap.get(recordIdVsEmail.get(contId));
                }
                //CREATE GIFT HISTORY RECORD ***
             //   system.debug('gift_name++'+recId);
                
                if(Schema.sObjectType.Gift_History__c.fields.Gift__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Gift__c.isCreateable()){
                        if(FinalSendGift_Class.validId(recId )){
                            gh.Gift__c = recId ;
                        }else{
                            gh.Gift__c = null;
                        }                
                }
                
                if(Schema.sObjectType.Gift_History__c.fields.Price__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Price__c.isCreateable()){
                    gh.Price__c = giftIdVsgiftProduct != null && !giftIdVsgiftProduct.isEmpty() && giftIdVsgiftProduct.containsKey(giftId) ?  giftIdVsgiftProduct.get(giftId).Price__c : null;
                }
                    
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isCreateable()){
                    gh.Gift_Id__c = giftId ;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isCreateable()){
                    gh.Sent_Date__c = system.today();
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isCreateable()){
                    gh.Gift_Status_Id__c = gft_id;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Quantity__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Quantity__c.isCreateable()){
                    gh.Quantity__c = Quantity ;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isCreateable()){
                    gh.Gift_Status__c = 'Created';
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isCreateable()){
                    gh.Shipping_Status__c = 'Created';
                    }



                if( giftType != null &&  giftType.toLowerCase() == 'p_gift'
                    && (Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isCreateable())){
                    gh.gift_Type__c = 'P-Gift';
                    }else if ( giftType != null &&  giftType.toLowerCase() == 'e_gift'){
                    gh.gift_Type__c = 'E-Gift';
                }

                giftHistoryList.add(gh);
                

                if(sobjectType != null && sobjectType.equalsIgnoreCase('Contact')){
               //     if(Schema.sObjectType.Contact.fields.GiftOnTheWay__c.isUpdateable()) {
                        contct.put('GiftOnTheWay__c' , true);
                 //       if(Schema.sObjectType.Contact.fields.Gift_Name__c.isUpdateable()) {
                            contct.put('Gift_Name__c' , giftName) ;
                   //     }
                    //    if(Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isUpdateable()) {
                            contct.put('Last_Gift_Send__c' , system.today());
                      //  }
                        conLstToUpdate.add(contct);
                   // }
                }else if(sobjectType != null && sobjectType.equalsIgnoreCase('Lead')){
                    contct.put('Gift_On_The_Way__c' , true);

                  //   if(Schema.sObjectType.Lead.fields.Gift_Name__c.isUpdateable()) {
                        contct.put('Gift_Name__c' , giftName) ;
                    //    if(Schema.sObjectType.Lead.fields.Last_Gift_Send__c.isUpdateable()) {
                            contct.put('Last_Gift_Send__c' , system.today());
                      //  }
                        conLstToUpdate.add(contct);
    //                
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
               
                if(Schema.sObjectType.Task.fields.whatId.isAccessible()
                   && Schema.sObjectType.Task.fields.whatId.isCreateable() ){
                       Id contact18DigitId = contId;
                       taskObject.whatId= contactIdVsAccountId != null && !contactIdVsAccountId.isEmpty() && contactIdVsAccountId.containsKey(contact18DigitId) ?  contactIdVsAccountId.get(contact18DigitId) : null;
                   }
                tList.add(taskObject);
            }
            
            if(!conLstToUpdate.isEmpty()){

                if (conLstToUpdate instanceof list<Contact>)
                {
                    List<Contact> innerconList = new  List<Contact>();
                    innerconList =  (List<Contact>) conLstToUpdate;

                    if((Schema.sObjectType.Contact.isAccessible()
                    && Schema.sObjectType.Contact.isCreateable() 
                    && Schema.sObjectType.Contact.isUpdateable())){
                    //    system.debug('Update contct**'+conLstToUpdate);
                        update innerconList;
                    }
                }
                if (conLstToUpdate instanceof list<Lead>)
                {
                    List<Lead> innerconList = new  List<Lead>();
                    innerconList =  (List<Lead>) conLstToUpdate;

                    if( (Schema.sObjectType.Lead.isAccessible()
                    && Schema.sObjectType.Lead.isCreateable() 
                    && Schema.sObjectType.Lead.isUpdateable())){
                       // system.debug('Update contct**'+conLstToUpdate);
                        update innerconList;
                    }
                }
               
                
            }
            if(!tList.isEmpty()
                && (Schema.sObjectType.Task.isAccessible()
                && Schema.sObjectType.Task.isCreateable())){
             //   system.debug('Update Task**'+tList);
                insert tList;
            }
            if(!giftHistoryList.isEmpty()
                && (Schema.sObjectType.Gift_History__c.isAccessible()
                && Schema.sObjectType.Gift_History__c.isCreateable())){
             //   system.debug('Update giftHistoryList**'+giftHistoryList);
                insert giftHistoryList;
            }
        }
        catch(Exception ex){
         //   system.debug('EXCEPTION => '+ex.getMessage() + '  Line'+ex.getLineNumber());
            createExceptionRecord(ex.getMessage());
        } 
    }
    
    //WRAPPER CLASS
    public class wrapContact {
        public string lastname='';
        public string firstname='';
        public string email=''; 
    }
    
    
    
    
    
    /*
    * Method Name     : sendMassGiftCallout
    * @Description    : This method is used to make single callout to send mass gift.
    */
  /*  public static string sendMassPhysicalGift(set<string> ContactIds , String giftId , String message ,string greeting ,string recipientName ,string giftName ,string giftType ,string recId , String sobjectType,map<String,products__c> giftIdVsgiftProduct){
       
        try{
            User runningUser = [SELECT id , email FROM User where id=:UserInfo.getUserId() WITH SECURITY_ENFORCED];
            list<GiftMerchant__c> merchantList = new list<GiftMerchant__c>();
            merchantList = [Select Id,MerchantId__c ,Security_Header__c From GiftMerchant__c WITH SECURITY_ENFORCED limit 1];
            //Map<String, Map<String, Object>> reqBody = new Map<String, Map<String, Object>>();
            Map<String, Object> JsonBody = new Map<String,Object>();
            String greetMessage ='';
            
            List<String> contactIdsList = new List<String>();

            if(giftId != null){
                JsonBody.put('gift_id',giftId);  
            }

            JsonBody.put('merchant_id',merchantList[0].MerchantId__c);

            if(greeting != null){
                greetMessage =greetMessage + greeting ; 
            }
            List<MassGiftSendController.wrapContact> recipientsList = new List<MassGiftSendController.wrapContact>();
            Map<String,String> recipientsMap = new Map<String,String>();
            if(sobjectType !=  null && sObjectType.equalsIgnoreCase('Contact')){
                for(Contact cont : [Select id, email,Message__c,Phone,Last_Gift_Send__c,Gift_Name__c, firstName,lastName,Name,mailingStreet,mailingCity,mailingState,mailingPostalCode,MailingCountry,Account.Name from contact where Id IN :ContactIds]){
                    
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
            }else if(sobjectType !=  null && sObjectType.equalsIgnoreCase('Lead')){
                for(Lead cont : [Select id, email,Phone,Last_Gift_Send__c,Gift_Name__c, firstName,lastName,Name,Street,City,State,PostalCode,Country from Lead where Id IN :ContactIds]){
                
                    contactIdsList.add(cont.Id);
    
                    String greetMessage1 = greetMessage;
                    
                    MassGiftSendController.wrapContact cont_Recd = new MassGiftSendController.wrapContact();
                    cont_Recd.firstname =cont.FirstName;
                    cont_Recd.lastname =cont.lastname;
                    //cont_Recd.email =cont.email;
                    cont_Recd.street = cont.Street;
                    cont_Recd.zip = cont.PostalCode;
                    cont_Recd.state = cont.State;
                    cont_Recd.city = cont.City;
                    
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
            }

            JsonBody.put('recipients',recipientsList);
            JsonBody.put('user',UserInfo.getUserEmail());

            //reqBody.put('payload', JsonBody);
            
            //string body = JSON.serialize(JsonBody) ;
            string body = JSON.serialize(JsonBody);
            String requestInput = body + '' + merchantList[0].Security_Header__c ;
            Blob requestBlob = Blob.valueOf(requestInput);
            Blob hash = Crypto.generateDigest('MD5', requestBlob);
            String SecurityHeader = EncodingUtil.convertToHex(hash);
            
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
            system.debug('*** RAW BODY '+JSON.serialize(JsonBody));
            system.debug('**** REQUEST BODY '+request2);
            HttpResponse resp2 = http2.send(request2); 
            
            if(resp2.getStatusCode()==200){
                system.debug('SUCCESS responseBody2**'+resp2.getBody());
                map<string,object> responseBody2 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
                
                string rest2 = (string.valueOf(responseBody2.get('success')));
                system.debug('rest2**'+rest2);
                if(!responseBody2.isEmpty() && responseBody2.containsKey('success') && rest2=='true'){
                    List<Object> ordersObjList = new List<Object>();
                    ordersObjList = (List<Object>) responseBody2.get('orders');

                    List<String> increamentIds = new List<String>();

                    for(Object obj : ordersObjList){

                        Map<String, Object> objMap = new Map<String, Object>();

                        objMap = (Map<string,Object>) obj;

                        increamentIds.add(String.valueOf(objMap.get('increment_id')));
                    }

                    createRecordsAfterCallout(increamentIds ,giftId, recId, giftName, giftType, contactIdsList , sobjectType,giftIdVsgiftProduct); 
                     
                    return '{"success":"true","message":"Gift send successfully!"}';
                }else{
                    
                    return JSON.serialize(responseBody2);
                }
            }
            else{
                Map<String,String> msgMap = new Map<String,String>();
                msgMap.put('success', 'false');
                msgMap.put('message',resp2.getStatusCode()+' Error Occure');
                createExceptionRecord(resp2.getBody());

                return JSON.serialize(msgMap);

            }
               
        }
        catch(Exception ex){

            System.debug('**** EXCEPTION ENCOUNTERED ****'+ex.getLineNumber()+' =>'+ex.getMessage() );
            Map<String,String> msgMap = new Map<String,String>();
                msgMap.put('success', 'false');
                msgMap.put('message',' Gift can not be send, Exception '+ex.getMessage()+' Encountered');
                createExceptionRecord(ex.getMessage());
                
                return JSON.serialize(msgMap);
        }   
    }
    
    */
      /*
    * Method Name     : sendMassGiftCallout
    * @Description    : This method is used to make single callout to send mass gift.
    */
    public static string sendMassPhysicalGift(set<string> ContactIds , String giftId , String message ,string greeting ,string recipientName ,string giftName ,string giftType ,string recId , String sobjectType,map<String,products__c> giftIdVsgiftProduct,String budgetSelected,Integer Quantity){
       
        try{
            User runningUser = [SELECT id , email FROM User where id=:UserInfo.getUserId() WITH SECURITY_ENFORCED];
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
            List<MassGiftSendController.wrapContact> recipientsList = new List<MassGiftSendController.wrapContact>();
            Map<String,String> recipientsMap = new Map<String,String>();
            if(sobjectType !=  null && sObjectType.equalsIgnoreCase('Contact')){
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
            }else if(sobjectType !=  null && sObjectType.equalsIgnoreCase('Lead')){
                for(Lead cont : [Select id, email,Phone,Last_Gift_Send__c,Gift_Name__c, firstName,lastName,Name,Street,City,State,PostalCode,Country from Lead where Id IN :ContactIds WITH SECURITY_ENFORCED]){
                
                    contactIdsList.add(cont.Id);
    
                    String greetMessage1 = greetMessage;
                    
                    MassGiftSendController.wrapContact cont_Recd = new MassGiftSendController.wrapContact();
                    cont_Recd.firstname =cont.FirstName;
                    cont_Recd.lastname =cont.lastname;
                    //cont_Recd.email =cont.email;
                    cont_Recd.street = cont.Street;
                    cont_Recd.zip = cont.PostalCode;
                    cont_Recd.state = cont.State;
                    cont_Recd.city = cont.City;
                    
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
            }

            JsonBody.put('recipients',recipientsList);
            JsonBody.put('user',UserInfo.getUserEmail());

            if(budgetSelected != null){
                JSONBody.put('budget_id',budgetSelected);
            }
            //reqBody.put('payload', JsonBody);
            
            //string body = JSON.serialize(JsonBody) ;
            if(Quantity !=null){
                JsonBody.put('qty',Quantity);  
            }
            string body = JSON.serialize(JsonBody);
            String requestInput = body + '' + merchantList[0].Security_Header__c ;
            Blob requestBlob = Blob.valueOf(requestInput);
            Blob hash = Crypto.generateDigest('MD5', requestBlob);
            String SecurityHeader = EncodingUtil.convertToHex(hash);
            
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
          //  system.debug('*** RAW BODY '+JSON.serialize(JsonBody));
          //  system.debug('**** REQUEST BODY '+request2);
            HttpResponse resp2 = http2.send(request2); 
            
            if(resp2.getStatusCode()==200){
            //    system.debug('SUCCESS responseBody2**'+resp2.getBody());
                map<string,object> responseBody2 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
                
                string rest2 = (string.valueOf(responseBody2.get('success')));
             //   system.debug('rest2**'+rest2);
                if(!responseBody2.isEmpty() && responseBody2.containsKey('success') && rest2=='true'){
                    List<Object> ordersObjList = new List<Object>();
                    ordersObjList = (List<Object>) responseBody2.get('orders');

                    List<String> increamentIds = new List<String>();

                    for(Object obj : ordersObjList){

                        Map<String, Object> objMap = new Map<String, Object>();

                        objMap = (Map<string,Object>) obj;

                        increamentIds.add(String.valueOf(objMap.get('increment_id')));
                    }

                    createRecordsAfterCallout(increamentIds ,giftId, recId, giftName, giftType, contactIdsList , sobjectType,giftIdVsgiftProduct,Quantity); 
                     
                    return '{"success":"true","message":"Gift send successfully!"}';
                }else{
                    
                    return JSON.serialize(responseBody2);
                }
            }
            else{
                Map<String,String> msgMap = new Map<String,String>();
                msgMap.put('success', 'false');
                msgMap.put('message',resp2.getStatusCode()+' Error Occure');
                createExceptionRecord(resp2.getBody());

                return JSON.serialize(msgMap);

            }
               
        }
        catch(Exception ex){

          //  System.debug('**** EXCEPTION ENCOUNTERED ****'+ex.getLineNumber()+' =>'+ex.getMessage() );
            Map<String,String> msgMap = new Map<String,String>();
                msgMap.put('success', 'false');
                msgMap.put('message',' Gift can not be send, Exception '+ex.getMessage()+' Encountered');
                createExceptionRecord(ex.getMessage());
                
                return JSON.serialize(msgMap);
        }   
    }



    
      /*
  * Method Name     : sendMassGiftCallout
  * @Description    : This method is used to make single callout to send mass gift with overloading (added billing address to the parameters).
  */
  public static string sendMassPhysicalGift(set<string> ContactIds ,BillingAddressCustom billaddress, String giftId , String message ,string greeting ,string recipientName ,string giftName ,string giftType ,string recId , String sobjectType,map<String,products__c> giftIdVsgiftProduct,String budgetSelected,Integer Quantity){
     
    try{
        User runningUser = [SELECT id , email FROM User where id=:UserInfo.getUserId() WITH SECURITY_ENFORCED];
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
        List<MassGiftSendController.wrapContact> recipientsList = new List<MassGiftSendController.wrapContact>();
        Map<String,String> recipientsMap = new Map<String,String>();
        if(sobjectType !=  null && sObjectType.equalsIgnoreCase('Contact')){
            for(Contact cont : [Select id, email,Message__c,Phone,Last_Gift_Send__c,Gift_Name__c, firstName,lastName,Name,mailingStreet,mailingCity,mailingState,mailingPostalCode,MailingCountry,Account.Name from contact where Id IN :ContactIds WITH SECURITY_ENFORCED]){
                
                contactIdsList.add(cont.Id);

                String greetMessage1 = greetMessage;
                
                MassGiftSendController.wrapContact cont_Recd = new MassGiftSendController.wrapContact();
                cont_Recd.firstname =cont.FirstName;
                cont_Recd.lastname =cont.lastname;
                //cont_Recd.email =cont.email;
                cont_Recd.street = billaddress.billingStreet;
                cont_Recd.zip = billaddress.billingPostalCode;
                cont_Recd.state = billaddress.billingState;
                cont_Recd.city = billaddress.billingCity;
                
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
        }else if(sobjectType !=  null && sObjectType.equalsIgnoreCase('Lead')){
            for(Lead cont : [Select id, email,Phone,Last_Gift_Send__c,Gift_Name__c, firstName,lastName,Name,Street,City,State,PostalCode,Country from Lead where Id IN :ContactIds WITH SECURITY_ENFORCED]){
            
                contactIdsList.add(cont.Id);

                String greetMessage1 = greetMessage;
                
                MassGiftSendController.wrapContact cont_Recd = new MassGiftSendController.wrapContact();
                cont_Recd.firstname =cont.FirstName;
                cont_Recd.lastname =cont.lastname;
                //cont_Recd.email =cont.email;
                cont_Recd.street = billaddress.billingStreet;
                cont_Recd.zip = billaddress.billingPostalCode;
                cont_Recd.state = billaddress.billingState;
                cont_Recd.city = billaddress.billingCity;
                
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
        }

        JsonBody.put('recipients',recipientsList);
        JsonBody.put('user',UserInfo.getUserEmail());

        if(budgetSelected != null){
            JSONBody.put('budget_id',budgetSelected);
        }
        //reqBody.put('payload', JsonBody);
        
        //string body = JSON.serialize(JsonBody) ;
        if(Quantity !=null){
            JsonBody.put('qty',Quantity);  
        }
        string body = JSON.serialize(JsonBody);
        String requestInput = body + '' + merchantList[0].Security_Header__c ;
        Blob requestBlob = Blob.valueOf(requestInput);
        Blob hash = Crypto.generateDigest('MD5', requestBlob);
        String SecurityHeader = EncodingUtil.convertToHex(hash);
        
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
       system.debug('*** RAW BODY '+JSON.serialize(JsonBody));
      //  system.debug('**** REQUEST BODY '+request2);
        HttpResponse resp2 = http2.send(request2); 
        
        if(resp2.getStatusCode()==200){
        //    system.debug('SUCCESS responseBody2**'+resp2.getBody());
            map<string,object> responseBody2 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
            
            string rest2 = (string.valueOf(responseBody2.get('success')));
         //   system.debug('rest2**'+rest2);
            if(!responseBody2.isEmpty() && responseBody2.containsKey('success') && rest2=='true'){
                List<Object> ordersObjList = new List<Object>();
                ordersObjList = (List<Object>) responseBody2.get('orders');

                List<String> increamentIds = new List<String>();

                for(Object obj : ordersObjList){

                    Map<String, Object> objMap = new Map<String, Object>();

                    objMap = (Map<string,Object>) obj;

                    increamentIds.add(String.valueOf(objMap.get('increment_id')));
                }

                createRecordsAfterCallout(increamentIds ,giftId, recId, giftName, giftType, contactIdsList , sobjectType,giftIdVsgiftProduct,Quantity); 
                 
                return '{"success":"true","message":"Gift send successfully!"}';
            }else{
                
                return JSON.serialize(responseBody2);
            }
        }
        else{
            Map<String,String> msgMap = new Map<String,String>();
            msgMap.put('success', 'false');
            msgMap.put('message',resp2.getStatusCode()+' Error Occure');
            createExceptionRecord(resp2.getBody());

            return JSON.serialize(msgMap);

        }
           
    }
    catch(Exception ex){

      //  System.debug('**** EXCEPTION ENCOUNTERED ****'+ex.getLineNumber()+' =>'+ex.getMessage() );
        Map<String,String> msgMap = new Map<String,String>();
            msgMap.put('success', 'false');
            msgMap.put('message',' Gift can not be send, Exception '+ex.getMessage()+' Encountered');
            createExceptionRecord(ex.getMessage());
            
            return JSON.serialize(msgMap);
    }   
}
    
    
    
    public static void createRecordsAfterCallout(List<String> increamentIds,string giftId,string recId,string giftName, String giftType, List<String> contactIdsList , String sobjectType,map<String,products__c> giftIdVsgiftProduct,Integer Quantity){
        
        List<Task> tList = new List<Task>();
        List<Gift_History__c> giftHistoryList = new List<Gift_History__c>();
        list<SObject> conLstToUpdate = new List<SObject>();
        Boolean check = false;
        //system.debug('gft_id**'+gft_id);
      //  system.debug('conId List**'+contactIdsList);
        string status = '';

        map<String,String > recordIdMap = new map<String,String >();
        for(RecordType type : [select id, developerName from RecordType where SobjectType='Corporate_gift__Gift_History__c' WITH SECURITY_ENFORCED]){
            recordIdMap.put( type.developerName.tolowercase(), type.Id);
        }

        map<String,Contact> contactIdVsContactObject = new map<String,Contact>();
        map<String,Lead> leadIdVsLeadObject = new map<String,Lead>();
        map<String,String> contactIdVsAccountId = new map<String,String>();

        if(sobjectType != null && sobjectType.equalsIgnoreCase('Lead')){
             for(Lead con : [Select id from Lead where id in : contactIdsList WITH SECURITY_ENFORCED ]){
                leadIdVsLeadObject.put(con.id,con);
            }        
        }
        else if(sobjectType != null && sobjectType.equalsIgnoreCase('Contact')){
            for(Contact con : [Select id,AccountId from Contact where id in : contactIdsList WITH SECURITY_ENFORCED ]){
                contactIdVsContactObject.put(con.id,con);
                if(con.AccountId != null ){
                    contactIdVsAccountId.put(con.id,con.AccountId);
                }
            }
        }
        


        Integer index = 0;
        try{
            for(String contId : contactIdsList){
                Sobject contct;
                
                Gift_History__c gh = new Gift_History__c();
                
                if( giftType != null && recordIdMap != null && !recordIdMap.isEmpty() 
                && recordIdMap.containsKey( giftType.toLowerCase() )){
                if(Schema.sObjectType.Gift_History__c.fields.recordTypeId.isAccessible()){        
                    if(Schema.sObjectType.Gift_History__c.fields.recordTypeId.isCreateable()){
                     gh.recordTypeId = recordIdMap.get( giftType.toLowerCase() );
                    }
                }
     
                }
                    
                if(sobjectType != null && sobjectType.equalsIgnoreCase('Lead')
                    && Schema.sObjectType.Gift_History__c.fields.Lead__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Lead__c.isCreateable()
                    && Schema.sObjectType.Lead.fields.Gift_Id__c.isUpdateable()){
                    contct = new Lead();
                    gh.Lead__c = contId;
                }
                else if(sobjectType != null && sobjectType.equalsIgnoreCase('Contact')
                    && (Schema.sObjectType.Gift_History__c.fields.Sent_To__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Sent_To__c.isCreateable())){
                    contct = new Contact();
                    gh.Sent_To__c = contId;
                }
                
               
                contct.id =contId;
               
                

                if( index < increamentIds.size() && increamentIds[index] != null){
                    contct.put('Gift_Id__c' , increamentIds[index]);
                }
                if(Schema.sObjectType.Gift_History__c.fields.Gift__c.isAccessible() 
                    && Schema.sObjectType.Gift_History__c.fields.Gift__c.isCreateable()){
                        if(FinalSendGift_Class.validId(recId )){
                            gh.Gift__c = recId ;
                        }else{
                            gh.Gift__c = null;
                        }
                }  
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isCreateable()){
                    gh.Gift_Id__c = giftId ;
                }
               
               if(Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isCreateable()){
                    gh.Sent_Date__c = system.today();
               }
               // if(Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isCreateable())
                    //gh.Gift_Status_Id__c = gft_id;   
                    if( index < increamentIds.size() && increamentIds[index] != null
                        && (Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isAccessible())
                        && Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isCreateable()){
                        gh.Gift_Status_Id__c = increamentIds[index];
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Quantity__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Quantity__c.isCreateable()){
                    gh.Quantity__c = Quantity ;
                    }
               
                if(Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isCreateable()){
                    gh.Shipping_Status__c = 'Created';
                }
                if(Schema.sObjectType.Gift_History__c.fields.Price__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Price__c.isCreateable()){
                    gh.Price__c = giftIdVsgiftProduct != null && !giftIdVsgiftProduct.isEmpty() && giftIdVsgiftProduct.containsKey(giftId) ?  giftIdVsgiftProduct.get(giftId).Price__c : null;
                }


                     if( giftType != null &&  giftType.toLowerCase() == 'p_gift'
                        && (Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isAccessible()
                        && Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isCreateable())){
                        gh.gift_Type__c = 'P-Gift';
                     }else if ( giftType != null &&  giftType.toLowerCase() == 'e_gift'){
                         gh.gift_Type__c = 'E-Gift';
                     }
                giftHistoryList.add(gh);
                
                if(sobjectType != null && sobjectType.equalsIgnoreCase('Contact')){
                    contct.put('GiftOnTheWay__c' , true);
                    contct.put('Gift_Name__c' , giftName) ;
                    contct.put('Last_Gift_Send__c' , system.today());
                    conLstToUpdate.add(contct);
                    
                }else if(sobjectType != null && sobjectType.equalsIgnoreCase('Lead')){
                        contct.put('Gift_On_The_Way__c' , true);

                 //    if(Schema.sObjectType.Lead.fields.Gift_Name__c.isUpdateable()) {
                        contct.put('Gift_Name__c' , giftName) ;
                   //     if(Schema.sObjectType.Lead.fields.Last_Gift_Send__c.isUpdateable()) {
                            contct.put('Last_Gift_Send__c' , system.today());
                     //   }
                        conLstToUpdate.add(contct);
                    //}
                    //else if(Schema.sObjectType.Lead.fields.Last_Gift_Send__c.isUpdateable()) {
                      //  contct.put('Last_Gift_Send__c' , system.today());
                        //conLstToUpdate.add(contct);
                    //}
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
               if(Schema.sObjectType.Task.fields.whatId.isAccessible()
            && Schema.sObjectType.Task.fields.whatId.isCreateable() ){
                    taskObject.whatId= contactIdVsAccountId != null && !contactIdVsAccountId .isEmpty() && contactIdVsAccountId.containsKey(contId) ?  contactIdVsAccountId.get(contId) : null;
                }
                tList.add(taskObject);

                index++;
            }
            
            if(!conLstToUpdate.isEmpty()){

                
                
                if (conLstToUpdate instanceof list<Contact>)
                {
                    List<Contact> innerconList = new  List<Contact>();
                    innerconList =  (List<Contact>) conLstToUpdate;

                    if((Schema.sObjectType.Contact.isAccessible()
                    && Schema.sObjectType.Contact.isCreateable() 
                    && Schema.sObjectType.Contact.isUpdateable())){
                    //    system.debug('Update contct**'+conLstToUpdate);
                        update innerconList;
                    }
                }
                if (conLstToUpdate instanceof list<Lead>)
                {
                    List<Lead> innerconList = new  List<Lead>();
                    innerconList =  (List<Lead>) conLstToUpdate;

                    if( (Schema.sObjectType.Lead.isAccessible()
                    && Schema.sObjectType.Lead.isCreateable() 
                    && Schema.sObjectType.Lead.isUpdateable())){
                       // system.debug('Update contct**'+conLstToUpdate);
                        update innerconList;
                    }
                }
               
               
            }
            if(!tList.isEmpty()
                && (Schema.sObjectType.Task.isAccessible()
                && Schema.sObjectType.Task.isCreateable())){
              //  system.debug('Update Task**'+tList);
                insert tList;
            }
            if(!giftHistoryList.isEmpty()
                && (Schema.sObjectType.Gift_History__c.isAccessible()
                && Schema.sObjectType.Gift_History__c.isCreateable())){
                insert giftHistoryList;
            }
        }
        catch(Exception ex){
            createExceptionRecord(ex.getMessage());
          //  system.debug('EXCEPTION => '+ex.getMessage() + '  Line'+ex.getLineNumber());
        } 
    }
    
    
    public static boolean validId (String id){
        String s = id;
        if (s instanceOf Id){
            return true;
        } else{
            return false;
        }
    }
    
    public static map<String,String> checkBudgetPrice(String emailId,Decimal giftPrice, String merchantId){
        
        map<string,String> budgetResponseBody = new map <String,String>();
        Http httpInstance = new Http();
        HttpRequest request2 = new HttpRequest();
        //String budgetEndpoint = System.Label.budgetEndpoint+'?amount='+giftPrice+'&merchant_id='+merchantId+'&email='+emailId; 
        String budgetEndpoint = 'https://staging.corporategift.com/salesforce/account/budgets'+'?amount='+giftPrice+'&merchant_id='+merchantId+'&email='+emailId;
        request2.setEndpoint(budgetEndpoint);
        request2.setMethod('GET');
        request2.setHeader('Accept','application/json');
        request2.setHeader('Content-Type','application/json');
        request2.setTimeout(120000);
     //   system.debug('**** REQUEST BODY '+request2);
        HttpResponse resp2 = httpInstance.send(request2); 
        System.debug('potapenko budget check ' + resp2.getStatusCode() + '   ' + resp2.getBody());
        if(resp2 != null && resp2.getStatusCode()==200 && resp2.getBody() != null){
            map<string,object> responseBody = new map <String,Object>();
            responseBody  = (Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
         //   System.debug('checkBudgetPrice responseBody : '+responseBody);
       
            if(responseBody != null && responseBody.containskey('success')){
            
                //System.debug(resp2.getEndPoint());
                string success = (string.valueOf(responseBody.get('success')));
            
                if(success == 'true' && responseBody.get('data') != null){
                    List<Object> budgetList = new List<Object>();
                    budgetList = (List<Object>) responseBody.get('data');
                    
                    for(Object obj : budgetList){
                        Map<String, Object> objMap = new Map<String, Object>();
                        
                        objMap = (Map<string,Object>) obj;
                        
                        budgetResponseBody.put(String.valueOf(objMap.get('id')),String.valueOf(objMap.get('name')));
                    }
                    return budgetResponseBody;
                }else{
                    return null;
                }
            }else{
                return null;
            }

        }else{
            return null;
        }

    }
    

    public class BillingAddressCustom{
        public String billingStreet ;
        public String billingCity ;
        public String billingState ;
        public String billingPostalCode;
    }
}