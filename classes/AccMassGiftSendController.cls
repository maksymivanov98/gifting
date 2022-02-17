/*-************************************************************************************************************
* Name         : AccMassGiftSendController
* @Author      : 
* @Date        : 
* @Description : The AccMassGiftSendController controller is used for Sending Physical gifts to selected Account.
* UPDATES
* Version          Developer                    Date                        Description
*-------------------------------------------------------------------------------------------
*     1.0          Bhagwan Chuphal               12 Dec 2019                 Initial Creation 
***************************************************************************************************************/
public with Sharing class AccMassGiftSendController {
    public set<String> ConList {get;set;}
    public list<String> ConList2 {get;set;}
    public List<SelectOption> giftList {get;set;}
    public List<SelectOption> greetingList {get;set;}
    public List<SelectOption> recipientList {get;set;}
    public String messageGreeting{get;set;}
    public String giftSelected {get;set;}
    public String greetSelected {get;set;}
    public String recipientSelected {get;set;}
    public string conIds {get;set;}
    public list<String> conName {get;set;}
    public map<String,String> giftNameVsgiftImage {get;set;}
    public string FilterId {get;set;}
    public boolean flag {get;set;}
    public boolean Daysflag {get;set;}
    public string contactsWithoutAddress ;
    public string contactsWithGiftSend ;
    public boolean errorFlag{get;set;} // ERROR FLAG
    public String errorMessage{get;set;}// ERROR MSG
    public string calloutResult{get;set;}// Final result message
    public map<String,products__c> giftIdVsgiftProduct {get;set;}
    public Integer Quantity{get;set;}
    public Integer Last_Quantity{get;set;}
    public map<string,string> giftIdVsNameMap{get;set;}
    public map<string,string> giftVsIdMap {get;set;}
    private ApexPages.StandardSetController standardController;
    public map<Account,String> accountVsValidAddress {get;set;}
    public boolean disableProceed {get;set;}
    public map<Account,String> accountVsInvalidPhysicalAddress {get;set;}
    public Boolean msgForm {get;set;} 
    public String nameString {get;set;}
    
    public String budgetSelected {get;set;}
    public List<SelectOption> budgetList {get;set;}
    public boolean displayPopup {get;set;}
    public string senderEmail{get;set;}
    public String merchnat_id {get;set;}
    public String methodName {get;set;}

    
    
    public list<Corporate_gift__GiftingSetup__c> giftSetup = new list<GiftingSetup__c>([Select Id ,Corporate_gift__Create_task_on_status_change__c ,Corporate_gift__Enable_gift_frequency__c ,Corporate_gift__Merchant_Id__c  ,Corporate_gift__Status_Merchant_Id__c From Corporate_gift__GiftingSetup__c WITH SECURITY_ENFORCED Limit 1]);
    public AccMassGiftSendController(ApexPages.StandardSetController standardController){
        Quantity=1;
        this.standardController = standardController;
        FilterId = standardController.getFilterId();
        User usr = [Select id,name,email,Gift__c,Recipient_Name__c,Salutation__c from User where id=:userinfo.getuserid() WITH SECURITY_ENFORCED];
        flag = true ;
        budgetList = new List<SelectOption>();
        senderEmail =usr.email;
        merchnat_id  = giftSetup[0].Merchant_Id__c;
        Daysflag =true ;
        contactsWithoutAddress = '';
        contactsWithGiftSend = '';
        accountVsValidAddress = new  map<Account,String> ();
        disableProceed = true;
        nameString = '';
        conName = new list<String>();
        giftIdVsNameMap = new map<string,string>();
        giftNameVsgiftImage = new  map<String,String>();
        accountVsInvalidPhysicalAddress = new map<Account,String>();
        msgForm =false;
        giftList = new List<SelectOption>();
        greetingList = new List<SelectOption>();
        recipientList = new List<SelectOption>();
        greetSelected = '';
        giftIdVsgiftProduct = new map<String,products__c>();
        giftVsIdMap = new map<string,string>();
        recipientSelected= '';
       // greetingList.add(new SelectOption('','None'));
        ConList2 = new list<String>();
        
          Map<String, Object> JsonBody = new Map<String,Object>();

        JsonBody.put('user',usr.email); // replace with current user email id 
        JsonBody.put('merchant_id',giftSetup[0].Merchant_Id__c);

        HttpResponse response = new HttpResponse();
        response = GiftSendFromContactController.calloutMethod(JSON.serialize(JsonBody),'GET',System.Label.GetAvailableGift);
        if(response != null && response.getStatusCode() == 200 ){
            map<String,object> responseMap = new map<String,object>();
            responseMap = (map<String,object>)JSON.deserializeUntyped(response.getBody());
            if(responseMap != null && !responseMap.isEmpty()  && Boolean.valueof(String.valueof(responseMap.get('success'))) && responseMap.containsKey('products')){
                list<object> productsList = new list<object>();
                productsList = (list<object>)responseMap.get('products');
                
                if(productsList != null && !productsList.isEmpty()){
                    for(object instanceObject : productsList){
                        map<String,object> productResMap = new map<String,object>();
                        productResMap = (map<String,object>)instanceObject;
                        
                        if(productResMap != null && !productResMap.isEmpty()){
                            
                            if(productResMap.containsKey('id') && productResMap.containsKey('name')  && productResMap.containsKey('description')  
                               && productResMap.containsKey('price') && productResMap.containsKey('image')){
                                   products__c productObject = new products__c();
                                   
                                   productObject.id__c = String.valueof(productResMap.get('id'));
                                   productObject.name = String.valueof(productResMap.get('name'));
                                   productObject.Description__c = productResMap.get('description') != null ?String.valueof(productResMap.get('description')) : '' ;
                                   productObject.Price__c = null != productResMap.get('price') ? Decimal.valueof(String.valueof(productResMap.get('price'))).setScale(2) : null;
                                   productObject.Corporate_gift__Gift_Image__c = productResMap.get('image') != null ? '<img src="'+String.valueof(productResMap.get('image'))+'" > </img>' : null;
                                   
                                   
                                   giftList.add(new SelectOption(String.valueof(productResMap.get('id')) ,String.valueof(productResMap.get('name'))));
                                   giftIdVsNameMap.put(String.valueof(productResMap.get('id')) ,String.valueof(productResMap.get('name')));
                                   giftVsIdMap.put(String.valueof(productResMap.get('id')) , String.valueof(productResMap.get('id')));
                                   giftNameVsgiftImage.put(String.valueof(productResMap.get('id')), productObject.Corporate_gift__Gift_Image__c);
                                   giftIdVsgiftProduct.put(String.valueof(productResMap.get('id')),productObject);
                                   
                               }
                            
                        }
                        
                    }
                    
                }else{
                    products__c productObject = new products__c();
                    productObject.id__c = 'empty';
                    productObject.name = 'None';
                    productObject.Description__c = null;
                    productObject.Price__c = null;
                    productObject.Corporate_gift__Gift_Image__c = null;
                    
                    giftList.add(new SelectOption('empty' ,'None'));
                    giftIdVsNameMap.put('empty','None');
                    giftVsIdMap.put('empty' , 'empty');
                    giftNameVsgiftImage.put('empty', '<img src="'+null+'" > </img>');
                    giftIdVsgiftProduct.put('empty',productObject);
                
                }
            }else{
                
                if(responseMap.containskey('message')){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,String.valueof(responseMap.get('message')  )));
                }
                products__c productObject = new products__c();
                productObject.id__c = 'empty';
                productObject.name = 'None';
                productObject.Description__c = null;
                productObject.Price__c = null;
                productObject.Corporate_gift__Gift_Image__c = null;
                
                giftList.add(new SelectOption('empty' ,'None'));
                giftIdVsNameMap.put('empty','None');
                giftVsIdMap.put('empty' , 'empty');
                giftNameVsgiftImage.put('empty', '<img src="'+null+'" > </img>');
                giftIdVsgiftProduct.put('empty',productObject);
                
             
                
            }
            
        }else{
                
              
                products__c productObject = new products__c();
                productObject.id__c = 'empty';
                productObject.name = 'None';
                productObject.Description__c = null;
                productObject.Price__c = null;
                productObject.Corporate_gift__Gift_Image__c = null;
                
                giftList.add(new SelectOption('empty' ,'None'));
                giftIdVsNameMap.put('empty','None');
                giftVsIdMap.put('empty' , 'empty');
                giftNameVsgiftImage.put('empty', '<img src="'+null+'" > </img>');
                giftIdVsgiftProduct.put('empty',productObject);
                
                     
                
            }
            
        
        if(usr.Gift__c !=null && usr.Gift__c != ''){
            for(products__c productObject : [SELECT id__c , name,Corporate_gift__Description__c,Corporate_gift__Price__c,Corporate_gift__Gift_Image__c  FROM products__c Where isActive__c = true and name =: usr.Gift__c WITH SECURITY_ENFORCED limit 1]){
              //  giftList.add(new SelectOption(productObject.id__c , productObject.name));
             //   giftIdVsNameMap.put(productObject.id__c , productObject.name);
                giftVsIdMap.put(productObject.id__c , productObject.Id);
             //   giftNameVsgiftImage.put(productObject.id__c,productObject.Corporate_gift__Gift_Image__c);
             //   giftIdVsgiftProduct.put(productObject.id__c,productObject);

            }
        }
        for(products__c productObject : [SELECT id__c , name,Corporate_gift__Description__c,Corporate_gift__Price__c,Corporate_gift__Gift_Image__c  FROM products__c Where isActive__c = true and name !=: usr.Gift__c WITH SECURITY_ENFORCED limit 10000]){
           // giftList.add(new SelectOption(productObject.id__c , productObject.name));
          //  giftIdVsNameMap.put(productObject.id__c , productObject.name);
            giftVsIdMap.put(productObject.id__c , productObject.Id);
          //  giftNameVsgiftImage.put(productObject.id__c,productObject.Corporate_gift__Gift_Image__c);
          //  giftIdVsgiftProduct.put(productObject.id__c,productObject);

            
        }
        
        if(usr.Salutation__c !=null && usr.Salutation__c != ''){
            for(String val : Label.GreetingLabel.split(',')){
                if(usr.Salutation__c==val){
                    greetingList.add(new SelectOption(val,val));
                }
            }
        }
        for(String val : Label.GreetingLabel.split(',')){
          if(usr.Salutation__c !=val){
                greetingList.add(new SelectOption(val,val));
            }
        }
        
        if(usr.Recipient_Name__c !=null && usr.Recipient_Name__c != ''){
            
          for(String v : Label.Recipient_Name.split(',')){
                if( usr.Recipient_Name__c == v){
                    recipientList.add(new SelectOption(v,v));
                }
            }  
        }   
        for(String v : Label.Recipient_Name.split(',')){
             if(usr.Recipient_Name__c != v){
                recipientList.add(new SelectOption(v,v));
            }
        }
        ConList = new set<String>(); 
        for (Account mem : (List<Account>)standardController.getSelected()){ 
            ConList.add(mem.Id);
        }
        for (Account mem : [select id,name,BillingCity,BillingState,BillingCountry,BillingStreet,BillingPostalCode , Last_Gift_Send__c FROM Account Where Id IN :ConList WITH SECURITY_ENFORCED]){ 
            //system.debug('date++'+mem.Last_Gift_Send__c);
            conName.add(mem.Name);
            if(mem.BillingCity ==null || mem.BillingCity =='' || mem.BillingState ==null || mem.BillingState =='' || mem.BillingCountry ==null || mem.BillingCountry ==''
               || mem.BillingStreet ==null || mem.BillingStreet =='' || mem.BillingPostalCode ==null || mem.BillingPostalCode ==''){
                   flag = false ;
                   contactsWithoutAddress += '<br/>';
                   contactsWithoutAddress +=  Mem.Name ; 
                   accountVsInvalidPhysicalAddress.put(mem,'Disabled');
                   
               }else if(mem.BillingCity !=null || mem.BillingCity !='' || mem.BillingState !=null || mem.BillingState !='' || mem.BillingCountry !=null || mem.BillingCountry !=''
               || mem.BillingStreet !=null || mem.BillingStreet !='' || mem.BillingPostalCode !=null || mem.BillingPostalCode !=''){
                
                   accountVsValidAddress.put(mem,'Valid Address');
               }
        }
        
     /*   if(!flag){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,' <b>  The following Account do not have an address on their Account record - please add an address and try again </b>'+contactsWithoutAddress ));
        } */
        if(!Daysflag){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,' <b>  Gift cannot be sent twice in less than 30 days for the following Account </b>' + contactsWithGiftSend ));
        }
        ConList2.addAll(ConList);
        conIds = JSON.serialize(ConList);
        if(accountVsValidAddress.isEmpty()){
            disableProceed = false;

        }
        if(flag){
            proceed();
        }
    }
    
    public void notzero()
    {
        
      //  system.debug(giftIdVsgiftProduct.get(giftSelected).Price__c);
        if (Quantity<1)
        {
            
            Quantity=Last_Quantity;
        } else {
            Last_Quantity = Quantity;
        }
    }
    
    
    
    public void showPopup(){
        
        
        budgetList = new List<SelectOption>();
        map<String,String> budgetResposne = new map<String,String>();
        budgetResposne = FinalSendGift_Class.checkBudgetPrice(senderEmail,giftIdVsgiftProduct.get(giftSelected).Price__c,merchnat_id);            
      //  System.debug('showPopup budgetResposne * '+budgetResposne);
        
        for(String key : budgetResposne.keySet()){
            budgetList.add(new SelectOption(key ,budgetResposne.get(key)));
            //    budgetList.add(new SelectOption('test' ,'1125'));
            
        }
        if(budgetList != null && !budgetList.isEmpty() && budgetList.size() > 1){
            displayPopup = true;
            
        }else if(budgetList != null && !budgetList.isEmpty() && budgetList.size() == 1){
            displayPopup = false;
            budgetSelected = budgetList[0].getValue();
              if(methodName == 'sendgift'){
                sendGift();
            }else if(methodName == 'customSendGift'){
                customSendGift();
            }
            
        }
        
        
        
        
    }
    
    public void closePopup(){
        displayPopup = false;
    }
    
    
    /*
    * Method Name     : sendGift
    * @Description    : This method is used to invoke Batch Class.
    */
    public void sendGift(){
      /*  system.debug('ConList**'+ConList);
        AccMassGiftSendBatchClass obj = new AccMassGiftSendBatchClass(ConList , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'P_gift',giftVsIdMap.get(giftSelected));
        Database.executeBatch(obj,1); */
        
        String result = sendGiftAccountCallout(ConList , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'P_gift',giftVsIdMap.get(giftSelected),budgetSelected,Quantity);
        
      //  System.debug('result ******/////'+result);
        //calloutResult = JSON.serialize(result);
        calloutResult = result;
        
     //   System.debug('calloutResult ******/////'+calloutResult);
        displayPopup = false;
    }
    
    
    
    
      public string sendGiftAccountCallout(set<string> ContactIds , String giftId , String message ,string greeting ,string recipientName ,string giftName ,string giftType ,string recId,String budgetSelected,Integer Quantity){
       
        try{
            list<GiftingSetup__c> merchantList = new list<GiftingSetup__c>();
            Map<String, Object> JsonBody = new Map<String,Object>();
            String greetMessage ='';
            list<string> contactIdsList = new list<string>();

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
           
            list<object> recipients = new list<Object>();
            for(Account con : [Select id,Message__c,Phone,Gift_Name__c,Name,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account where Id IN :ContactIds WITH SECURITY_ENFORCED ]){
               contactIdsList.add(con.id);
                if(con.name ==null && Schema.sObjectType.Account.fields.name.isUpdateable()){
                    con.name = '';
                }
                map<String,object> recipientMap = new map<String,Object>();
                recipientMap.put('firstname',con.name); 
                greetMessage = greetMessage +' '+con.name  ; 
               
                if(con.name!=null){
                    recipientMap.put('lastname','Office Staff');
                }
                if(con.Phone!=null){
                    recipientMap.put('phone',con.Phone);  
                }
                if(giftType !=null && giftType !='' && giftType=='P_gift'){
                    if(con.BillingStreet!=null){
                        recipientMap.put('street',con.BillingStreet);  
                    }
                    if(con.BillingCity!=null){
                        recipientMap.put('city',con.BillingCity);  
                    }
                    if(con.BillingState!=null){
                        recipientMap.put('state',con.BillingState);  
                    }
                    if(con.BillingPostalCode!=null){
                        recipientMap.put('zip',con.BillingPostalCode);  
                    }
                }
                
                
                if(message !=null){
                    greetMessage = greetMessage +'\n\n'+message; 
                }
                if(greetMessage !=null){
                    recipientMap.put('message',greetMessage);  
                }

                recipients.add(recipientMap);
            } 
            JsonBody.put('recipients',recipients);
            JsonBody.put('user',UserInfo.getUserEmail());
            if(budgetSelected != null ){
                JSONBody.put('budget_id',budgetSelected);
            }
                string body = JSON.serialize(JsonBody) ;
            //    system.debug('#### Line 107 AccBatch JOSN Body**'+body);
                String requestInput = body + '' + merchantList[0].Security_Header__c ;
                Blob requestBlob = Blob.valueOf(requestInput);
                Blob hash = Crypto.generateDigest('MD5', requestBlob);
                String SecurityHeader = EncodingUtil.convertToHex(hash);
             
                
                http http2 = new http();
                httpRequest request2 = new httpRequest();
                string endPoint2= System.Label.sendGiftForPhysical;
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
                 //   system.debug('resp2.getBody()-----'+resp2.getBody());
                    map<string,object> responseBody2 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
                 //   system.debug('### responseBody2**'+responseBody2);
                    string rest2 = (string.valueOf(responseBody2.get('success')));
                  //  system.debug('rest2**'+rest2);
                    if(!responseBody2.isEmpty() && responseBody2.containsKey('success') && rest2=='true'){
                        createRecordsAfterCalloutAccount(String.valueOf(responseBody2.get('order_id')),giftId,recId, giftName, giftType, contactIdsList,Quantity);
                        return '{"success":"true","message":"Gift send successfully!"}';
                    }else{
                   //     system.debug('#### SUCCESS '+JSON.serialize(responseBody2));
                        return JSON.serialize(responseBody2);
                    }   
                    
                    
                } else{
                    Map<String,String> msgMap = new Map<String,String>();
                    msgMap.put('success', 'false');
                    FinalSendGift_Class.createExceptionRecord(resp2.getBody()); 

                    msgMap.put('message',resp2.getStatusCode()+' Error Occure');
                 //   system.debug('#### ERROR '+JSON.serialize(msgMap));
                    return JSON.serialize(msgMap);
                    // return '{"success":"false","message":"'+resp2.getStatusCode()+' Error encountered"}';
                } 
            
        }catch(Exception ex){
         //   System.debug('**** EXCEPTION ENCOUNTERED ****'+ex.getLineNumber()+' =>'+ex.getMessage() );
            Map<String,String> msgMap = new Map<String,String>();
            msgMap.put('success', 'false');

            FinalSendGift_Class.createExceptionRecord(ex.getMessage());
            msgMap.put('message',' Gift can not be send, Exception '+ex.getMessage()+' Encountered');
         //   system.debug('#### EXCEPTION '+JSON.serialize(msgMap));
            return JSON.serialize(msgMap);
            // return '{"success":"false","message":"Gift can not be send, Exception : "'+ex.getMessage()+'}';
        }
    }
    
    
    public void createRecordsAfterCalloutAccount(string gft_id ,string giftId,string recId,string giftName, String giftType,List<string> contactIdsList,Integer Quantity){
        
        map<String,String > recordIdMap = new map<String,String >();
        for(RecordType type : [select id, developerName from RecordType where SobjectType='Corporate_gift__Gift_History__c' WITH SECURITY_ENFORCED]){
            recordIdMap.put( type.developerName.tolowercase(), type.Id);
        }

        string status = '';
        list<Account> conLstToUpdate = new List<Account>();

        map<String,Account> contactIdVsContactObject = new map<String,Account>();
        for(Account con : [Select id from Account where id in : contactIdsList WITH SECURITY_ENFORCED ]){
            contactIdVsContactObject.put(con.id,con);
        }
        
        List<Gift_History__c> giftHistoryList = new List<Gift_History__c>();
        Boolean check=false;
        List<Task> tList = new List<Task>();
          Integer index = 0;
        try{
            for(String conId : contactIdsList){
            Account contct = new Account();
            if(Schema.sObjectType.Account.fields.Id.isAccessible()){
                if(contactIdVsContactObject != null && !contactIdVsContactObject.isEmpty() && contactIdVsContactObject.containsKey(conId)){
                        contct =contactIdVsContactObject.get(conId);  
                }
          //  contct.Id = conId;
            }
                
      //  jsonBodyStatus.put('merchant_id','6200');
      //  jsonBodyStatus.put('order_id',gft_id);
        if (Schema.sObjectType.Account.fields.Gift_Id__c.isAccessible() 
            && Schema.sObjectType.Account.fields.Gift_Id__c.isUpdateable()) {
           contct.Gift_Id__c = gft_id ;
        }
       
        Gift_History__c gh = new Gift_History__c();
        if( giftType != null && recordIdMap != null && !recordIdMap.isEmpty() 
            && recordIdMap.containsKey( giftType.toLowerCase() )){
           
            if(Schema.sObjectType.Gift_History__c.fields.recordTypeId.isAccessible()){        
                if(Schema.sObjectType.Gift_History__c.fields.recordTypeId.isCreateable()){
                 gh.recordTypeId = recordIdMap.get( giftType.toLowerCase() );
                }
            }
        }
        // gh.name = giftName ;
        // gh.Sent_To__c = conId;
        if(Schema.sObjectType.Gift_History__c.fields.Account__c.isAccessible()
            && Schema.sObjectType.Gift_History__c.fields.Account__c.isCreateable()){
            gh.Account__c = conId;
        }
     //   SYSTEM.DEBUG('>>>>>>>>>'+conId);
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
         if(Schema.sObjectType.Gift_History__c.fields.Quantity__c.isAccessible()
            && Schema.sObjectType.Gift_History__c.fields.Quantity__c.isCreateable()){
             gh.Quantity__c = Quantity ;
              }
        //  gh.Gift_Name__c = giftName ;
        if(Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isAccessible()
            && Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isCreateable()){
            gh.Sent_Date__c = system.today();
        }
        if(Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isAccessible()
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
        
         /*  if(status !=null){
        gh.Gift_Status__c = status ;
        gh.Shipping_Status__c = status; 
        }else{
        gh.Gift_Status__c = '' ;
        gh.Shipping_Status__c = ''; 
        } */
     //   system.debug('>>>>>>#'+gh);
        giftHistoryList.add(gh); 


        if(Schema.sObjectType.Account.fields.Gift_On_The_Way__c.isAccessible()
            && Schema.sObjectType.Account.fields.Gift_On_The_Way__c.isUpdateable()) {
           contct.Gift_On_The_Way__c = true;
        }
        if (Schema.sObjectType.Account.fields.Gift_Name__c.isAccessible()
            && Schema.sObjectType.Account.fields.Gift_Name__c.isUpdateable()) {
          contct.Gift_Name__c = giftName ;
        }
        if (Schema.sObjectType.Account.fields.Last_Gift_Send__c.isAccessible()
            && Schema.sObjectType.Account.fields.Last_Gift_Send__c.isUpdateable()) {
          contct.Last_Gift_Send__c = system.today();
        }
                conLstToUpdate.add(contct);
        check = true;
        Task taskObject = new Task();
        if(Schema.sObjectType.Task.fields.subject.isAccessible()
            && Schema.sObjectType.Task.fields.subject.isCreateable()){
            taskObject.subject ='Gift Intiated - ' + giftName ; 
        }
        if(Schema.sObjectType.Task.fields.WhatId.isAccessible()
            && Schema.sObjectType.Task.fields.WhatId.isCreateable()){
            taskObject.WhatId = conId;
        }
        if(Schema.sObjectType.Task.fields.ActivityDate.isAccessible()
            && Schema.sObjectType.Task.fields.ActivityDate.isCreateable()){
            taskObject.ActivityDate = system.today();
        }
        
        tList.add(taskObject);
    }
      //  System.debug('Gift History**** '+giftHistoryList);
        
            if(check && 
                (Schema.sObjectType.Account.isAccessible()
                && Schema.sObjectType.Account.isUpdateable())){
            //    system.debug('Account**'+conLstToUpdate);
                update conLstToUpdate;
            }
            if(!tList.isEmpty()
                && (Schema.sObjectType.Task.isAccessible()
                && Schema.sObjectType.Task.isCreateable())){
           //     system.debug('tList**'+tList);
                insert tList;
            }
            if(!giftHistoryList.isEmpty()
                && (Schema.sObjectType.Gift_History__c.isAccessible()
                && Schema.sObjectType.Gift_History__c.isCreateable())){
            //    system.debug('giftHistoryList**'+giftHistoryList);
                insert giftHistoryList;
            }
        }
        catch(Exception ex){
        //    system.debug('Message '+ex.getMessage() + '  Line'+ex.getLineNumber());

            FinalSendGift_Class.createExceptionRecord(ex.getMessage());
        } 
    }

    /*
    * Method Name     : customSendGift
    * @Description    : This method is used to .
    */
    public void customSendGift(){
     //   system.debug('accountVsValidAddress**'+accountVsValidAddress.keySet());
        
        set<String> validAddContactList = new set<String>();
        if(accountVsValidAddress != null && !accountVsValidAddress.isEmpty()){
            for(Account con : accountVsValidAddress.keySet()){
                validAddContactList.add(con.id);
            }
        }
        
        String result = sendGiftAccountCallout(validAddContactList , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'P_gift',giftVsIdMap.get(giftSelected),budgetSelected,Quantity);
        
      //  System.debug('result ******/////'+result);
        //calloutResult = JSON.serialize(result);
        calloutResult = result;
        displayPopup = false;

        
        
    }
    
    public void sendGiftTypeMethod(){
        if(methodName == 'sendgift'){
            sendGift();
        }else if(methodName == 'customSendGift'){
            customSendGift();
        }
    }
    
       /*
    * Method Name     : proceed
    * @Description    : This method is used to set the render of output panel.
    */
    public void proceed(){
        list<String> nameList = new list<String>();
        set<String> validAddContactList = new set<String>();
        if(accountVsValidAddress != null && !accountVsValidAddress.isEmpty()){
            for(Account con : accountVsValidAddress.keySet()){
                validAddContactList.add(con.id);
                nameList.add(con.name);
            }
            msgForm = true;
        }
        
                
        if(nameList != null && nameList.size() > 1){
            nameString = nameList[0] + ' + ' + (nameList.size() -1) + ' others';
        }else if (nameList != null && nameList.size() == 1){
            nameString = nameList[0];
        }
        
    }
}