/*-************************************************************************************************************
* Name         : MassGiftSendController
* @Author      : 
* @Date        : 
* @Description : The MassGiftSendController controller is used for Sending Physical gifts to selected contacts.
* UPDATES
* Version          Developer                    Date                        Description
*-------------------------------------------------------------------------------------------
*     1.0          Piyush Kalra               20 Nov 2019                 Initial Creation 
***************************************************************************************************************/
public with Sharing class MassGiftSendController {
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
    public string FilterId {get;set;}
    public boolean flag {get;set;}
    public boolean Daysflag {get;set;}
    public string contactsWithoutAddress ;
    public string contactsWithGiftSend ;
    public map<string,string> giftIdVsNameMap {get;set;}
    public map<string,string> giftVsIdMap {get;set;}
    public string calloutResult{get;set;}// Final result message
    public string otherSalution {get;set;}
    public map<Contact,String> contactVsValidAddress {get;set;}
    public list<wrapperClass> invalidContactWrapper {get;set;}
    public map<Contact,String> contactVsInvalidEmailAddress {get;set;}
    public string E_GiftName{get;set;}
    public Integer Quantity{get;set;}
    public Integer Last_Quantity{get;set;}
    public String idVal {get;set;}
    public Boolean boolVal {get;set;}
    public Boolean msgForm {get;set;} 
    public map<string,object> responseBody3 {get;set;}
    public Boolean voidMap {get;set;} 
    public boolean disableProceed {get;set;}
    public boolean previewFlag {get;set;}
    public string senderEmail{get;set;}
    public string recipientFirstName {get;set;}
    public string recipientLastName {get;set;}
    public string recipientEmail {get;set;}
    public list<String> conName {get;set;}
    public map<String,String> giftNameVsgiftImage {get;set;}
    public map<String,products__c> giftIdVsgiftProduct {get;set;}
    public boolean reGift {get;set;}
    public String nameString {get;set;}
    public String budgetSelected {get;set;}
    public List<SelectOption> budgetList {get;set;}
    public boolean displayPopup {get;set;}
    public String methodName {get;set;}

    //mass gift variables
    /*public set<string> ContactIds ;
    public String giftId ;
    public String message ;
    public string greeting ;
    public string recipientName ;
    public string giftName ;
    public string giftType ;
    public string recId ;
    public string greetMessage = '';
    public Boolean check=false;
    //public string E_GiftName ;
    public Contact contct = new Contact();
    public List<Task> tList = new List<Task>();
    public List<Gift_History__c> giftHistoryList = new List<Gift_History__c>();
    //public Map<string,string> jsonBody = new Map<string,string>();
    public String jsonBody = '';
    public Map<string,string> jsonBodyStatus = new Map<string,string>();*/

    private ApexPages.StandardSetController standardController;
    
    public list<Corporate_gift__GiftingSetup__c> giftSetup = new list<GiftingSetup__c>([Select Id ,Corporate_gift__Create_task_on_status_change__c ,Corporate_gift__Enable_gift_frequency__c ,Corporate_gift__Merchant_Id__c  ,Corporate_gift__Status_Merchant_Id__c From Corporate_gift__GiftingSetup__c WITH SECURITY_ENFORCED Limit 1]);
    public String merchnat_id {get;set;}
    
    public MassGiftSendController(ApexPages.StandardSetController standardController){
        
        Quantity=1;
        if(giftSetup != null && !giftSetup.isEmpty()){
            merchnat_id = giftSetup[0].Merchant_Id__c;
        }
        
        budgetList = new List<SelectOption>();

        this.standardController = standardController;
        FilterId = standardController.getFilterId();
        User usr = [Select id,name,Gift__c,Recipient_Name__c,Salutation__c,Email from User where id=:userinfo.getuserid() WITH SECURITY_ENFORCED];
        senderEmail = (usr != null && usr.Email != null && usr.Email != '') ? usr.Email : '';
        reGift =false;
        E_GiftName = usr.name ;
        contactVsValidAddress = new map<Contact,String>();
        invalidContactWrapper = new list<wrapperClass>();
        idVal = '';
        giftVsIdMap = new map<string,string>();
        nameString = '';
        boolVal = true;
        msgForm = false;
        voidMap = true;
        previewFlag = false;
        disableProceed = true;
        conName = new list<String>();
        giftNameVsgiftImage = new  map<String,String>();
        giftIdVsNameMap = new  map<string,string> ();

        contactVsInvalidEmailAddress = new map<Contact,String>();
        otherSalution = '';
        responseBody3 = new map<string,object>();
        giftIdVsgiftProduct = new map<String,products__c>();

        flag = true ;
        Daysflag =true ;
        contactsWithoutAddress = '';
        contactsWithGiftSend = '';
        giftList = new List<SelectOption>();
        greetingList = new List<SelectOption>();
        recipientList = new List<SelectOption>();
        greetSelected = '';
        recipientSelected= '';
        ConList = new set<String>(); 
        
        if(ApexPages.currentPage().getParameters().containsKey('SetId')){
            String SelectedRecords = ApexPages.currentPage().getParameters().get('SetId');
          //  system.debug('Params***'+ SelectedRecords );
            ConList = (Set<string>)JSON.deserialize(SelectedRecords, Set<string>.class);
         //   system.debug('ConList^^^'+ ConList );
            
        }
       
        ConList2 = new list<String>();
        
          Map<String, Object> JsonBody = new Map<String,Object>();

        JsonBody.put('user',senderEmail); // replace with current user email id 
        JsonBody.put('merchant_id',merchnat_id);
        
        HttpResponse response = new HttpResponse();
        response = GiftSendFromContactController.calloutMethod(JSON.serialize(JsonBody),'GET',System.Label.GetAvailableGift);
        if(response != null && response.getStatusCode() == 200){
            map<String,object> responseMap = new map<String,object>();
            responseMap = (map<String,object>)JSON.deserializeUntyped(response.getBody());
            if(responseMap != null && !responseMap.isEmpty() && Boolean.valueof(String.valueof(responseMap.get('success'))) && responseMap.containsKey('products')){
                list<object> productsList = new list<object>();
                productsList = (list<object>)responseMap.get('products');
                
                for(object instanceObject : productsList){
                    map<String,object> productResMap = new map<String,object>();
                    productResMap = (map<String,object>)instanceObject;
                    
                    if(productResMap != null && !productResMap.isEmpty()){
                        
                        if(productResMap.containsKey('id') && productResMap.containsKey('name')  && productResMap.containsKey('description')  
                           && productResMap.containsKey('price') && productResMap.containsKey('image')){
                               products__c productObject = new products__c();
                               
                               productObject.id__c = String.valueof(productResMap.get('id'));
                               productObject.name = String.valueof(productResMap.get('name'));
                               productObject.Description__c = String.valueof(productResMap.get('description'));
                               productObject.Price__c = Decimal.valueof(String.valueof(productResMap.get('price')));
                               productObject.Corporate_gift__Gift_Image__c = '<img src="'+String.valueof(productResMap.get('image'))+'" > </img>';
                               
                               
                               giftList.add(new SelectOption(String.valueof(productResMap.get('id')) ,String.valueof(productResMap.get('name'))));
                               giftIdVsNameMap.put(String.valueof(productResMap.get('id')) ,String.valueof(productResMap.get('name')));
                               giftVsIdMap.put(String.valueof(productResMap.get('id')) , String.valueof(productResMap.get('id')));
                               giftNameVsgiftImage.put(String.valueof(productResMap.get('id')), '<img src="'+String.valueof(productResMap.get('image'))+'" > </img>');
                               giftIdVsgiftProduct.put(String.valueof(productResMap.get('id')),productObject);
                               
                           }
                        
                    }
                    
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
            for(products__c productObject : [SELECT id__c, name ,Corporate_gift__Description__c,Corporate_gift__Price__c,Corporate_gift__Gift_Image__c FROM products__c Where isActive__c = true and name =: usr.Gift__c WITH SECURITY_ENFORCED limit 1]){
               // giftList.add(new SelectOption(productObject.id__c , productObject.name));
               // giftIdVsNameMap.put(productObject.id__c , productObject.name);
                giftVsIdMap.put(productObject.id__c , productObject.Id);
              //  giftNameVsgiftImage.put(productObject.id__c,productObject.Corporate_gift__Gift_Image__c);
             //   giftIdVsgiftProduct.put(productObject.id__c,productObject);

            }
        }
        for(products__c productObject : [SELECT id__c , name ,Corporate_gift__Description__c,Corporate_gift__Price__c,Corporate_gift__Gift_Image__c FROM products__c Where isActive__c = true and name !=: usr.Gift__c WITH SECURITY_ENFORCED limit 10000]){
           // giftList.add(new SelectOption(productObject.id__c , productObject.name));
           // giftIdVsNameMap.put(productObject.id__c , productObject.name);
            giftVsIdMap.put(productObject.id__c , productObject.Id);
           // giftNameVsgiftImage.put(productObject.id__c,productObject.Corporate_gift__Gift_Image__c);
           // giftIdVsgiftProduct.put(productObject.id__c,productObject);

            
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
        
        for (Contact mem : (List<Contact>)standardController.getSelected()){ 
            ConList.add(mem.Id);
        }
        
        List<Contact> contactList = [Select id, FirstName, LastName, Email From Contact Where Id IN: ConList  WITH SECURITY_ENFORCED limit 1];
        
        recipientFirstName = (!contactList.isEmpty() && contactList[0].FirstName != null && contactList[0].FirstName != '') ? contactList[0].FirstName : '';
        recipientLastName = (!contactList.isEmpty() && contactList[0].LastName != null && contactList[0].LastName != '') ? contactList[0].LastName : '';
        recipientEmail = (!contactList.isEmpty() && contactList[0].Email != null && contactList[0].Email != '') ? contactList[0].Email : '';
        
        for (Contact mem : [select id,FirstName,lastName,Last_Gift_Send__c,Email,Name,MailingCity,MailingState,MailingCountry,MailingStreet,MailingPostalCode FROM Contact Where Id IN :ConList WITH SECURITY_ENFORCED]){ 
            conName.add(mem.Name);
         //   system.debug('date++'+mem.Last_Gift_Send__c);
            if(mem.MailingCity ==null || mem.MailingCity =='' || mem.MailingState ==null || mem.MailingState =='' || mem.MailingCountry ==null || mem.MailingCountry ==''
               || mem.MailingStreet ==null || mem.MailingStreet =='' || mem.MailingPostalCode ==null || mem.MailingPostalCode ==''){
                   flag = false ;
               //    system.debug('entered--- '+flag+' '+msgForm);
                   contactsWithoutAddress += '<br/>';
                   contactsWithoutAddress +=  Mem.Name ; 
                   if(mem.Email == null || mem.Email ==''){
                       contactVsInvalidEmailAddress.put(mem,'Disabled');
                   }else{
                       invalidContactWrapper.add(new wrapperClass(true,mem));
                   }
               }else{
                   contactVsValidAddress.put(mem,'Valid Address');
               }
        }
        if(!Daysflag){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,' <b>  Gift cannot be sent twice in less than 30 days for the following Contacts </b>' + contactsWithGiftSend ));
        }
        ConList2.addAll(ConList);
        conIds = JSON.serialize(ConList);
        
        if(contactVsValidAddress.isEmpty() && invalidContactWrapper.isEmpty()){
            disableProceed = false;
        }

        if(flag ){
            proceed();
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
        //    System.debug('methodName**'+methodName);

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
        if(greetSelected.contains('Other')){
                greetSelected = otherSalution;
        }
      //  system.debug('giftSelected**'+giftSelected);
        //MassGiftSendBatchClass obj = new MassGiftSendBatchClass(ConList , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'P_gift',giftVsIdMap.get(giftSelected));
        //Database.executeBatch(obj,1);

        String result;

        result = sendMassGiftCallout(ConList , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'P_gift',giftVsIdMap.get(giftSelected),budgetSelected,Quantity);
       // System.debug('result ******/////'+result);
        //calloutResult = JSON.serialize(result);
        calloutResult = result;

     //   System.debug('calloutResult******'+calloutResult);
        displayPopup = false;

    }

    
        /*
    * Method Name     : sendMassEGiftCallout
    * @Description    : This method is used to make single callout to send mass Egift.
    */
    public string sendMassEGiftCallout(set<string> ContactIds , String giftId , String message ,string greeting ,string recipientName ,string giftName ,string giftType ,string recId ,string E_GiftName, Boolean reGift,String budgetSelected,Integer Quantity){
        
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
            for(Contact cont : [Select id, email,Message__c,Phone,Last_Gift_Send__c,Gift_Name__c, firstName,lastName,Name,mailingStreet,mailingCity,mailingState,mailingPostalCode,MailingCountry,Account.Name from contact where Id IN :ContactIds WITH SECURITY_ENFORCED]){
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
            JsonBody.put('user',UserInfo.getUserEmail());
            JsonBody.put('upgrade_regift' , reGift);
            if(budgetSelected != null){
                JSONBody.put('budget_id',budgetSelected);
            }
            JsonBody.put('recipients',recipientsList);
            JsonBody.put('qty',Quantity);
            if(Quantity !=null){
                JsonBody.put('qty',Quantity);  
            }
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
            string endPoint2= System.Label.sendGiftURL; 
           // string endPoint2= 'https://staging.corporategift.com/salesforce/gift/send';
            request2.setEndpoint(endPoint2);
            request2.setMethod('POST');
            request2.setHeader('Accept','application/json');
            request2.setHeader('Content-Type','application/json');
            request2.setHeader('Api-Signature',SecurityHeader);
            request2.setTimeout(120000);
            request2.setBody(JSON.serialize(JsonBody)); 
          //  system.debug('*** RAW BODY '+JsonBody);
         //   system.debug('**** REQUEST BODY '+request2);
            HttpResponse resp2 = http2.send(request2); 
            if(resp2.getStatusCode()==200){
             //   system.debug('SUCCESS responseBody3**'+resp2.getBody());
                responseBody3 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
              //  system.debug('responseBody3**'+responseBody3);
                string rest2 = (string.valueOf(responseBody3.get('success')));
              //  system.debug('rest2**'+rest2);
                if(!responseBody3.isEmpty() && responseBody3.containsKey('success') && rest2=='true'){
                    //createRecordsAfterCallout(String.valueOf(responseBody3.get('order_id')),con.Id,recId,giftId);
                    //createRecordsAfterEGiftCallout(String.valueOf(responseBody3.get('order_id')) ,giftId,recId, giftName, ContactIds); 
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
                FinalSendGift_Class.createExceptionRecord(resp2.getBody()); 

                msgMap.put('message',resp2.getStatusCode()+' Error Occure');
              //   system.debug('#### ERROR '+JSON.serialize(msgMap));
                return JSON.serialize(msgMap);
                // return '{"success":"false","message":"'+resp2.getStatusCode()+' Error encountered"}';
            }
               
        }
        catch(Exception ex){
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
    
    //AFTER RESPONSE METHOD
    public void createRecordsAfterEGiftCallout(string gft_id,string giftId,string recId,string giftName, set<String> ContactIds,Integer Quantity){
        
        List<Task> tList = new List<Task>();
        List<Gift_History__c> giftHistoryList = new List<Gift_History__c>();
        list<Contact> conLstToUpdate = new List<Contact>();
        Boolean check = false;

        map<String,String > recordIdMap = new map<String,String >();
        for(RecordType type : [select id, developerName from RecordType where SobjectType='Corporate_gift__Gift_History__c' WITH SECURITY_ENFORCED]){
            recordIdMap.put( type.developerName.tolowercase(), type.Id);
        }
        
        map<String,Contact> contactIdVsContactObject = new map<String,Contact>();
        map<String,String> contactIdVsAccountId = new map<String,String>();

        for(Contact con : [Select id,AccountId from Contact where id in : ContactIds WITH SECURITY_ENFORCED ]){
            contactIdVsContactObject.put(con.id,con);
            if(con.AccountId != null ){
                contactIdVsAccountId.put(con.id,con.AccountId);
            }
        }

      //  system.debug('gft_id**'+gft_id);
      //  system.debug('conId List**'+ContactIds);
        string status = '';
        try{
            for(String contId : ContactIds){
                Contact contct = new Contact();
                
                if(Schema.sObjectType.Contact.fields.Id.isAccessible() 
                && Schema.sObjectType.Contact.fields.Id.isUpdateable()){
                contct.id =contId;   
                }
                
                Gift_History__c gh = new Gift_History__c();
                String giftType = 'E-Gift';
                if( giftType != null && recordIdMap != null && !recordIdMap.isEmpty() 
                && recordIdMap.containsKey( giftType.toLowerCase() )){
                    if(Schema.sObjectType.Gift_History__c.fields.recordTypeId.isAccessible()){        
                        if(Schema.sObjectType.Gift_History__c.fields.recordTypeId.isCreateable()){
                        gh.recordTypeId = recordIdMap.get( giftType.toLowerCase() );
                        }
                    }
         
                }
                    
                    
                if(Schema.sObjectType.Contact.fields.Gift_Id__c.isAccessible()
                    && Schema.sObjectType.Contact.fields.Gift_Id__c.isUpdateable() ){
                    contct.Gift_Id__c = gft_id ;
                    }
                //CREATE GIFT HISTORY RECORD ***
                //system.debug('gift_name++'+recId);
                if(Schema.sObjectType.Gift_History__c.fields.Sent_To__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Sent_To__c.isCreateable()){
                    gh.Sent_To__c = contId;
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
                if(Schema.sObjectType.Gift_History__c.fields.Quantity__c.isAccessible()
                   && Schema.sObjectType.Gift_History__c.fields.Quantity__c.isCreateable()){
                       gh.Quantity__c = Quantity ;
                   }
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
                if(Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isCreateable()){
                    gh.gift_Type__c = 'E-Gift';
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Price__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Price__c.isCreateable()){
                    gh.Price__c = giftIdVsgiftProduct != null && !giftIdVsgiftProduct.isEmpty() && giftIdVsgiftProduct.containsKey(giftId) ?  giftIdVsgiftProduct.get(giftId).Price__c : null;
                    }


                giftHistoryList.add(gh);
                
                // UPDATE CONTACT RECORD***s

                    if(Schema.sObjectType.Contact.fields.GiftOnTheWay__c.isAccessible() && 
                        Schema.sObjectType.Contact.fields.GiftOnTheWay__c.isUpdateable()) {
                        contct.GiftOnTheWay__c = true;
                    if(Schema.sObjectType.Contact.fields.Gift_Name__c.isAccessible() && 
                        Schema.sObjectType.Contact.fields.Gift_Name__c.isUpdateable()) {
                        contct.Gift_Name__c = giftName ;
                    }
                    if(Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isAccessible() && 
                        Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isUpdateable()) {
                        contct.Last_Gift_Send__c = system.today();
                    }
                    conLstToUpdate.add(contct);
                }
                //else if(Schema.sObjectType.Contact.fields.Gift_Name__c.isUpdateable()) {
                  //  contct.Gift_Name__c = giftName ;
                   // if(Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isUpdateable()) {
                    //    contct.Last_Gift_Send__c = system.today();
                   // }
                //    conLstToUpdate.add(contct);
                //}
                //else if(Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isUpdateable()) {
                 //   contct.Last_Gift_Send__c = system.today();
                 //   conLstToUpdate.add(contct);
                //}
                
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
                    taskObject.whatId= contactIdVsAccountId != null && !contactIdVsAccountId .isEmpty() && contactIdVsAccountId.containsKey(contact18DigitId) ?  contactIdVsAccountId.get(contact18DigitId) : null;
                    }
                tList.add(taskObject);
            }
            
            if(!conLstToUpdate.isEmpty() && 
                (Schema.sObjectType.Contact.isAccessible() && 
                Schema.sObjectType.Contact.isUpdateable())){
                //system.debug('Update contct**'+conLstToUpdate);
                update conLstToUpdate;
            }
            if(!tList.isEmpty()
                && (Schema.sObjectType.Task.isAccessible()
                && Schema.sObjectType.Task.isCreateable())){
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

            FinalSendGift_Class.createExceptionRecord(ex.getMessage());
        } 
    }
    
    
    

    /*
    * Method Name     : sendMassGiftCallout
    * @Description    : This method is used to make single callout to send mass gift.
    */
    public string sendMassGiftCallout(set<string> ContactIds , String giftId , String message ,string greeting ,string recipientName ,string giftName ,string giftType ,string recId,String budgetSelected,Integer Quantity){
       
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

          //  System.debug('contactIdsList*****'+contactIdsList);

            JsonBody.put('user',UserInfo.getUserEmail());
            
            JsonBody.put('recipients',recipientsList);
            JsonBody.put('qty',Quantity);
            if(budgetSelected != null ){
                JSONBody.put('budget_id',budgetSelected);
            }
            //reqBody.put('payload', JsonBody);

            //string body = JSON.serialize(JsonBody) ;
            if(Quantity !=null){
                JsonBody.put('qty',Quantity);  
            }
            string body = JSON.serialize(JsonBody) ;
         //   system.debug('Body**'+body);
            String requestInput = body + '' + merchantList[0].Security_Header__c ;
            Blob requestBlob = Blob.valueOf(requestInput);
            Blob hash = Crypto.generateDigest('MD5', requestBlob);
            String SecurityHeader = EncodingUtil.convertToHex(hash);
          
          //  system.debug('#### BODY MAP '+JsonBody);
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
            //    system.debug('SUCCESS responseBody2**'+resp2.getBody());
                map<string,object> responseBody2 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
             //   system.debug('responseBody2**'+responseBody2);
                string rest2 = (string.valueOf(responseBody2.get('success')));
             //   system.debug('rest2**'+rest2);
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

                  //  System.debug('increamentIds*****'+increamentIds);

                    createRecordsAfterCallout(increamentIds ,giftId,recId, giftName, giftType, contactIdsList,Quantity); 
                 //    system.debug('#### SUCCESS '+JSON.serialize(responseBody2));
                    return '{"success":"true","message":"Gift send successfully!"}';
                }else{
                 //   system.debug('#### SUCCESS '+JSON.serialize(responseBody2));
                    return JSON.serialize(responseBody2);
                }
            }
            else{
                Map<String,String> msgMap = new Map<String,String>();
                msgMap.put('success', 'false');
                FinalSendGift_Class.createExceptionRecord(resp2.getBody()); 

                msgMap.put('message',resp2.getStatusCode()+' Error Occure');
              //   system.debug('#### ERROR '+JSON.serialize(msgMap));
                return JSON.serialize(msgMap);
                // return '{"success":"false","message":"'+resp2.getStatusCode()+' Error encountered"}';
            }
               
        }
        catch(Exception ex){
          //  System.debug('**** EXCEPTION ENCOUNTERED ****'+ex.getLineNumber()+' =>'+ex.getMessage() );
            Map<String,String> msgMap = new Map<String,String>();
                msgMap.put('success', 'false');

            FinalSendGift_Class.createExceptionRecord(ex.getMessage());
                msgMap.put('message',' Gift can not be send, Exception '+ex.getMessage()+' Encountered');
         //   system.debug('#### EXCEPTION '+JSON.serialize(msgMap));
                return JSON.serialize(msgMap);
                // return '{"success":"false","message":"Gift can not be send, Exception : "'+ex.getMessage()+'}';
        }   
    }
    
    //AFTER RESPONSE METHOD
    public void createRecordsAfterCallout(List<String> increamentIds,string giftId,string recId,string giftName, String giftType,List<String> contactIdsList,Integer Quantity){
        
        List<Task> tList = new List<Task>();
        List<Gift_History__c> giftHistoryList = new List<Gift_History__c>();
        list<Contact> conLstToUpdate = new List<Contact>();
        Boolean check = false;
        map<String,String > recordIdMap = new map<String,String >();
        for(RecordType type : [select id, developerName from RecordType where SobjectType='Corporate_gift__Gift_History__c' WITH SECURITY_ENFORCED]){
            recordIdMap.put( type.developerName.tolowercase(), type.Id);
        }
        
        map<String,Contact> contactIdVsContactObject = new map<String,Contact>();
        map<String,String> contactIdVsAccountId = new map<String,String>();

        for(Contact con : [Select id,AccountId from Contact where id in : contactIdsList WITH SECURITY_ENFORCED ]){
            contactIdVsContactObject.put(con.id,con);
            if(con.AccountId != null ){
                contactIdVsAccountId.put(con.id,con.AccountId);
            }
        }
        
        
        //system.debug('gft_id**'+gft_id);
      //  system.debug('conId List**'+contactIdsList);
        string status = '';
        Integer index = 0;
        try{
            for(String contId : contactIdsList){
                Contact contct = new Contact();
                
                if(Schema.sObjectType.Contact.fields.Id.isAccessible()){
                    if(contactIdVsContactObject != null && !contactIdVsContactObject.isEmpty() && contactIdVsContactObject.containsKey(contId)){
                        contct =contactIdVsContactObject.get(contId);    
                    }
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
                    
                    
            //    if(Schema.sObjectType.Contact.fields.Gift_Id__c.isUpdateable())
                    //contct.Gift_Id__c = gft_id ;
                    if( index < increamentIds.size() && increamentIds[index] != null && 
                        (Schema.sObjectType.Contact.fields.Gift_Id__c.isAccessible() &&
                        Schema.sObjectType.Contact.fields.Gift_Id__c.isUpdateable())){
                        contct.Gift_Id__c = increamentIds[index];
                    }
                    
                //CREATE GIFT HISTORY RECORD ***
              //  system.debug('gift_name++'+recId);
                if(Schema.sObjectType.Gift_History__c.fields.Sent_To__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Sent_To__c.isCreateable()){
                    gh.Sent_To__c = contId;
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
                 if(Schema.sObjectType.Gift_History__c.fields.Quantity__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Quantity__c.isCreateable()){
                    gh.Quantity__c = Quantity ;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isCreateable()){
                    gh.Sent_Date__c = system.today();
                    }
              //  if(Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isCreateable())
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
                if(Schema.sObjectType.Gift_History__c.fields.Price__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Price__c.isCreateable()){
                    gh.Price__c = giftIdVsgiftProduct != null && !giftIdVsgiftProduct.isEmpty() && giftIdVsgiftProduct.containsKey(giftId) ?  giftIdVsgiftProduct.get(giftId).Price__c : null;
                    }

                if( giftType != null &&  giftType.toLowerCase() == 'p_gift'
                    &&(Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isCreateable())){
                    gh.gift_Type__c = 'P-Gift';
                     }else if ( giftType != null &&  giftType.toLowerCase() == 'e_gift'){
                         gh.gift_Type__c = 'E-Gift';
                     }
                   


                giftHistoryList.add(gh);
                
                // UPDATE CONTACT RECORD***s

                if(Schema.sObjectType.Contact.fields.GiftOnTheWay__c.isAccessible() && 
                    Schema.sObjectType.Contact.fields.GiftOnTheWay__c.isUpdateable()) {
                        contct.GiftOnTheWay__c = true;
                if(Schema.sObjectType.Contact.fields.Gift_Name__c.isAccessible() && 
                    Schema.sObjectType.Contact.fields.Gift_Name__c.isUpdateable()) {
                        contct.Gift_Name__c = giftName ;
                    }
                if(Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isAccessible() && 
                    Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isUpdateable()  ) {
                        contct.Last_Gift_Send__c = system.today();
                   }
                            conLstToUpdate.add(contct);
                }
               // else if(Schema.sObjectType.Contact.fields.Gift_Name__c.isUpdateable()) {
                //    contct.Gift_Name__c = giftName ;
                 //   if(Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isUpdateable()) {
                  //      contct.Last_Gift_Send__c = system.today();
                   // }
                   // conLstToUpdate.add(contct);
                //}
                //else if(Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isUpdateable()) {
                  //  contct.Last_Gift_Send__c = system.today();
                   // conLstToUpdate.add(contct);
               // }
                
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
                        taskObject.whatId= contactIdVsAccountId != null && !contactIdVsAccountId .isEmpty() && contactIdVsAccountId.containsKey(contact18DigitId) ?  contactIdVsAccountId.get(contact18DigitId) : null;
                }
                tList.add(taskObject);

                index++;
            }
            
            if(!conLstToUpdate.isEmpty() && 
                (Schema.sObjectType.Contact.isAccessible() && 
                Schema.sObjectType.Contact.isUpdateable())){
             //   system.debug('Update contct**'+conLstToUpdate);
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
         //   system.debug('EXCEPTION => '+ex.getMessage() + '  Line'+ex.getLineNumber());

            FinalSendGift_Class.createExceptionRecord(ex.getMessage());
        } 
    }
    
    //WRAPPER CLASS
    public class wrapContact {
        public string firstname='';
        public string lastname='';
        //public string email=''; 
        public string street = '';
        public string zip = '';
        public string state = '';
        public string city = '';
        public string message = '';
        public string telephone = '';
        public string location_type = '';
    }


        /*
    * Method Name     : customSendGift
    * @Description    : This method is used to .
    */
    public void customSendGift(){
     //   system.debug('contactVsValidAddress**'+contactVsValidAddress.keySet());
     //   system.debug('invalidContactWrapper**'+invalidContactWrapper);
        
        set<String> validAddContactList = new set<String>();
        set<String> invalidAddContactList = new set<String>();
        if(contactVsValidAddress != null && !contactVsValidAddress.isEmpty()){
            for(Contact con : contactVsValidAddress.keySet()){
                validAddContactList.add(con.id);
            }
        }
        
        if(invalidContactWrapper != null && !invalidContactWrapper.isEmpty()){
            for(wrapperClass wrpObj : invalidContactWrapper){
             //   System.debug('wrpObj.toggleFlag***'+wrpObj.toggleFlag);
                if(wrpObj.toggleFlag == true){
                    invalidAddContactList.add(wrpObj.conWrap.id);
                }
            }
        }
        
      //  System.debug('validAddContactList**'+validAddContactList);
      //  System.debug('invalidAddContactList**'+invalidAddContactList);
        
        if(invalidAddContactList != null && !invalidAddContactList.isEmpty()){
            if(E_GiftName == null || E_GiftName == ''){
                E_GiftName = [Select id,name from User where id=:userinfo.getuserid() WITH SECURITY_ENFORCED limit 1].name ;
            }
            
            if(greetSelected.contains('Other')){
                 greetSelected = otherSalution;
            }
            String result = sendMassEGiftCallout(invalidAddContactList , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'E_gift',giftVsIdMap.get(giftSelected) ,E_GiftName, reGift,budgetSelected,Quantity);
         //   system.debug('### RESULT MESSAGE **'+result);
             calloutResult = result;
            
            /* MassGiftSendBatchClass obj = new MassGiftSendBatchClass(invalidAddContactList , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'E_gift',giftVsIdMap.get(giftSelected) ,E_GiftName);
            Database.executeBatch(obj,1); */
        }
        
        if(validAddContactList != null && !validAddContactList.isEmpty()){

            if(greetSelected.contains('Other')){
                greetSelected = otherSalution;
            }
            
             String result;

            result = sendMassGiftCallout(validAddContactList , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'P_gift',giftVsIdMap.get(giftSelected),budgetSelected,Quantity);
         //   System.debug('result ******/////'+result);
            //calloutResult = JSON.serialize(result);
            calloutResult = result;
        }
        
        if(invalidAddContactList != null && !invalidAddContactList.isEmpty()){
            if(!responseBody3.isEmpty() && responseBody3.containsKey('success')){
                string rest2 = (string.valueOf(responseBody3.get('success')));
            //    system.debug('rest2**'+rest2);
                if(!responseBody3.isEmpty() && responseBody3.containsKey('success') && rest2=='true'){
                    createRecordsAfterEGiftCallout(String.valueOf(responseBody3.get('order_id')) ,giftSelected,giftVsIdMap.get(giftSelected), giftIdVsNameMap.get(giftSelected), invalidAddContactList,Quantity); 
                }
            }
        }
        displayPopup = false;

    }
    
    /*
    * Method Name     : setWrapperVal
    * @Description    : This method is used to set the value in wrapper list from the VF Page toggle button.
    */
    public void setWrapperVal(){
      //  system.debug('idVal**'+idVal);
     //   system.debug('boolVal**'+boolVal);

        for(wrapperClass wrpObj : invalidContactWrapper){
            if(wrpObj.conWrap.id == idVal){
                wrpObj.toggleFlag = boolVal;
            }
        }
        
        set<String> validAddContactList = new set<String>();
        set<String> invalidAddContactList = new set<String>();
        if(contactVsValidAddress != null && !contactVsValidAddress.isEmpty()){
            for(Contact con : contactVsValidAddress.keySet()){
                validAddContactList.add(con.id);
            }
        }
        
        if(invalidContactWrapper != null && !invalidContactWrapper.isEmpty()){
            for(wrapperClass wrpObj : invalidContactWrapper){
            //    System.debug('wrpObj.toggleFlag***'+wrpObj.toggleFlag);
                if(wrpObj.toggleFlag == true){
                    invalidAddContactList.add(wrpObj.conWrap.id);
                }
            }
        }
        
        if(invalidAddContactList.isEmpty() && validAddContactList.isEmpty()){
            voidMap = false;
        }else{
            voidMap = true;
            
        }
        
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
        
        msgForm = true;


        list<String> nameList = new list<String>();

        set<String> validAddContactList = new set<String>();
        set<String> invalidAddContactList = new set<String>();
        if(contactVsValidAddress != null && !contactVsValidAddress.isEmpty()){
            for(Contact con : contactVsValidAddress.keySet()){
                validAddContactList.add(con.id);
                nameList.add(con.name);
            }
        }
        
        if(invalidContactWrapper != null && !invalidContactWrapper.isEmpty()){
            for(wrapperClass wrpObj : invalidContactWrapper){
              //  System.debug('wrpObj.toggleFlag***'+wrpObj.toggleFlag);
                if(wrpObj.toggleFlag == true){
                    invalidAddContactList.add(wrpObj.conWrap.id);
                    nameList.add(wrpObj.conWrap.name);
                }
            }
        }
        
        if(nameList != null && nameList.size() > 1){
            nameString = nameList[0] + ' + ' + (nameList.size() -1) + ' others';
        }else if (nameList != null && nameList.size() == 1){
            nameString = nameList[0];
        }
        
        
        if(invalidAddContactList.isEmpty()){
            previewFlag = false;
        }else{
            previewFlag = true;
        }    
    }
    public void notzero()
    {
        
       // system.debug(giftIdVsgiftProduct.get(giftSelected).Price__c);
        if (Quantity<1)
        {
            
            Quantity=Last_Quantity;
        } else {
            Last_Quantity = Quantity;
        }
    }
    
    /*
    * Wrapper Class Name     : wrapperClass
    * @Description         : This Class is used to bind toggle button with Contact.
    */    
    public class wrapperClass{
        public boolean toggleFlag{get;set;}
        public Contact conWrap{get;set;}
        
        public wrapperClass(boolean toggleFlag, Contact conWrap ){
            this.toggleFlag = toggleFlag;
            this.conWrap = conWrap;
        } 
    }
    
}