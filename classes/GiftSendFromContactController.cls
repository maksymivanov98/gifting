/*-************************************************************************************************************
* Name         : GiftSendFromContactController
* @Author      : 
* @Date        : 
* @Description : The GiftSendFromContactController controller is used for Sending gifts to contact.
* UPDATES
* Version          Developer                    Date                        Description
*-------------------------------------------------------------------------------------------
*     1.0          Piyush Kalra               11 Feb 2020                 Initial Creation 
***************************************************************************************************************/
public with sharing class GiftSendFromContactController {
    
    
    public set<String> ConList {get;set;}
    public list<String> ConList2 {get;set;}
    public List<SelectOption> giftList {get;set;}
    public List<SelectOption> budgetList {get;set;}
    public List<SelectOption> greetingList {get;set;}
    public List<SelectOption> recipientList {get;set;}
    public String messageGreeting{get;set;}
    public String giftSelected {get;set;}
    public String budgetSelected {get;set;}
    public String greetSelected {get;set;}
    public String recipientSelected {get;set;}
    public string conIds {get;set;}
    public string FilterId {get;set;}
    public boolean Daysflag {get;set;}
    public boolean Emailflag {get;set;}
    public string contactsWithoutAddress ;
    public string contactsWithoutEmail;
    public string contactsWithGiftSend ;
    public boolean isEgift{get;set;}
    public boolean flag {get;set;}
    public map<string,string> giftIdVsNameMap{get;set;}
    public map<string,string> giftVsIdMap {get;set;}
    public string recId {get;set;}
    public string recipientFirstName {get;set;}
    public string recipientLastName {get;set;}
    public string recipientEmail {get;set;}
    public string E_GiftName{get;set;}
    public Integer Quantity{get;set;}
    public Integer Last_Quantity{get;set;}
    public string senderEmail{get;set;}
    public string calloutResult{get;set;}// Final result message
    public boolean errorFlag{get;set;} // ERROR FLAG
    public String errorMessage{get;set;}// ERROR MSG
    public String otherSalution{get;set;}
    public list<String> conName {get;set;}
    public map<String,String> giftNameVsgiftImage {get;set;}
    public map<String,products__c> giftIdVsgiftProduct {get;set;}
    
    public map<Contact,String> contactVsValidAddress {get;set;}
    public list<wrapperClass> invalidContactWrapper {get;set;}
    public map<Contact,String> contactVsInvalidEmailAddress {get;set;}
    public list<wrapperClassLead> invalidLeadWrapper {get;set;}
    public map<Lead,String> leadVsInvalidEmailAddress {get;set;}
    public map<Account,String> accountVsInvalidPhysicalAddress {get;set;}
    public Boolean accountFlag {get;set;}
    public boolean disableProceed {get;set;}
    public boolean disableProceed1 {get;set;}
    public boolean reGift {get;set;}
    public boolean dedicatedLink {get;set;}
    public String video_url {get;set;}
    public String idVal {get;set;}
    public Boolean boolVal {get;set;}
    public Boolean pageError {get;set;}
    
    public Boolean msgForm {get;set;}
    public Boolean msgForm1 {get;set;} 
    public Boolean voidMap {get;set;} 
    public Boolean voidMap1 {get;set;}
    public String objectName {get;set;}
    public string emailSubject{get;set;}
    public list<GiftingSetup__c> giftSetup = new list<GiftingSetup__c>([Select Id ,Create_task_on_status_change__c ,Corporate_gift__Gift_Frequency__c,Enable_gift_frequency__c ,Merchant_Id__c  ,Status_Merchant_Id__c From GiftingSetup__c WITH SECURITY_ENFORCED Limit 1]);
    
    public String merchnat_id {get;set;}
    public boolean displayPopup {get;set;}
    public String methodName {get;set;}
    public String billingStreet {get;set;}
    public String billingCity {get;set;}
    public String billingState {get;set;}
    public String billingPostalCode {get;set;}
    public FinalSendGift_Class.BillingAddressCustom billingCustom {get;set;}
    public boolean displayPopup1 {get;set;}
    public boolean disableAddOneTimeAddress {get;set;}
    public GiftSendFromContactController(){

        displayPopup = false;
        displayPopup1 = false;
        Quantity =1;
        if(giftSetup != null && !giftSetup.isEmpty()){
            merchnat_id = giftSetup[0].Merchant_Id__c;
        }
        billingCustom = new FinalSendGift_Class.BillingAddressCustom();
        contactVsValidAddress = new map<Contact,String>();
        invalidContactWrapper = new list<wrapperClass>();    
        leadVsInvalidEmailAddress = new map<Lead,String>();
        accountVsInvalidPhysicalAddress = new map<Account,String>();
        invalidLeadWrapper = new list<wrapperClassLead>();
        idVal = '';
        conName = new list<String>();
        giftNameVsgiftImage = new map<String,String>();
        giftIdVsNameMap = new map<string,string>();
        boolVal = true;
        giftVsIdMap = new map<string,string>();
        msgForm = false;
        msgForm1 = false;
        voidMap = true;
        pageError = false;
        voidMap1 = false;
        disableAddOneTimeAddress=true;
        accountFlag = false;
        contactVsInvalidEmailAddress = new map<Contact,String>();
        objectName = '';
        disableProceed = true;
        disableProceed1 = true;
        giftIdVsgiftProduct = new map<String,products__c>();
        reGift = false;
        dedicatedLink = false;
        emailSubject = UserInfo.getOrganizationName() + ' - Sent You a Gift!';
        video_url = '';
        recId = ApexPages.currentPage().getParameters().get('id');
        //system.debug('recId***'+recId);
        
        //Get prefix from record ID
        //This assumes that you have passed at least 3 characters
        if(recId != null){
            String myIdPrefix = String.valueOf(recId).substring(0,3);
            
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
            
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){
                
                //if (!sObj.contains('__')) to exclude managed package objects
                
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                //   System.debug('Prefix is ' + prefix);
                
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    //   System.debug('Object Name! ' + objectName);
                    break;
                }
            }
        }
        ConList = new set<String>();
        ConList.add(recId);
        Daysflag = true ;
        Emailflag = true ;
        flag = true ;
        isEgift = false;
        User usr = [Select id, name, Email, Gift__c,Recipient_Name__c,Salutation__c from User where id=:userinfo.getuserid() WITH SECURITY_ENFORCED];
        E_GiftName = usr.name ;
        senderEmail = (usr != null && usr.Email != null && usr.Email != '') ? usr.Email : '';
        String giftType = ApexPages.currentPage().getParameters().get('giftType');
        if(ApexPages.currentPage().getParameters() != null  && giftType =='E_Gift'){
            isEgift = true;
            
        }
        
        
        String theme = UserInfo.getUiThemeDisplayed();
        
        contactsWithGiftSend = '';
        giftList = new List<SelectOption>();
        budgetList = new List<SelectOption>();
        greetingList = new List<SelectOption>();
        recipientList = new List<SelectOption>();
        greetSelected = '';
        recipientSelected= '';
        contactsWithoutEmail = '';
        contactsWithoutAddress = '';
        //greetingList.add(new SelectOption('','None'));
        ConList2 = new list<String>();
        
        Map<String, Object> JsonBody = new Map<String,Object>();
        
        JsonBody.put('user',senderEmail ); // replace with current user email id 
        JsonBody.put('merchant_id',merchnat_id);
        
        HttpResponse response = new HttpResponse();
        response = calloutMethod(JSON.serialize(JsonBody),'GET',System.Label.GetAvailableGift);
        //   System.debug('response**'+response.getBody());
        if(response != null && response.getStatusCode() == 200 ){
            map<String,object> responseMap = new map<String,object>();
            responseMap = (map<String,object>)JSON.deserializeUntyped(response.getBody());
            if(responseMap != null && !responseMap.isEmpty() && Boolean.valueof(String.valueof(responseMap.get('success'))) && responseMap.containsKey('products')){
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
                                   giftVsIdMap.put(String.valueof(productResMap.get('id')) ,String.valueof(productResMap.get('id')));
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
            for(products__c productObject : [SELECT id__c , name,Corporate_gift__Description__c,Corporate_gift__Price__c,Corporate_gift__Gift_Image__c FROM products__c Where isActive__c = true and name =: usr.Gift__c WITH SECURITY_ENFORCED limit 1]){
                //giftList.add(new SelectOption(productObject.id__c , productObject.name));
                // giftIdVsNameMap.put(productObject.id__c , productObject.name);
                giftVsIdMap.put(productObject.id__c , productObject.Id);
                // giftNameVsgiftImage.put(productObject.id__c,productObject.Corporate_gift__Gift_Image__c);
                // giftIdVsgiftProduct.put(productObject.id__c,productObject);
                
            }
        }
        for(products__c productObject : [SELECT id__c , name,Corporate_gift__Description__c,Corporate_gift__Price__c,Corporate_gift__Gift_Image__c FROM products__c Where isActive__c = true and name !=: usr.Gift__c WITH SECURITY_ENFORCED limit 10000]){
            //  giftList.add(new SelectOption(productObject.id__c , productObject.name));
            //  giftIdVsNameMap.put(productObject.id__c , productObject.name);
            giftVsIdMap.put(productObject.id__c , productObject.Id);
            //   giftNameVsgiftImage.put(productObject.id__c,productObject.Corporate_gift__Gift_Image__c);
            //   giftIdVsgiftProduct.put(productObject.id__c,productObject);
            
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
        
        // ConList = new set<String>(); 
        
        if(recId != null && recId.startsWith('003')){
            
            for (Contact mem : [select id,FirstName,lastName,Last_Gift_Send__c,Email,Name,MailingCity,MailingState,MailingCountry,MailingStreet,MailingPostalCode FROM Contact Where Id =: recId WITH SECURITY_ENFORCED]){ 
                conName.add(mem.Name);
                
                billingStreet = mem.MailingStreet;
                billingCity = mem.MailingCity;
                billingState = mem.MailingState;
                billingPostalCode = mem.MailingPostalCode;
                
                if(!giftSetup.isEmpty() && giftSetup[0].Corporate_gift__Enable_gift_frequency__c && mem.Last_Gift_Send__c !=null && giftSetup[0].Corporate_gift__Gift_Frequency__c != null && mem.Last_Gift_Send__c.daysBetween(system.today()) < Integer.ValueOf(giftSetup[0].Corporate_gift__Gift_Frequency__c) ){
                    Daysflag = false; 
                    contactsWithGiftSend += '<br/>';
                    contactsWithGiftSend +=  Mem.Name ; 
                }else if(mem.Email ==null || mem.Email ==''){
                    Emailflag = false ;
                    contactsWithoutEmail += '<br/>';
                    contactsWithoutEmail +=  Mem.Name ; 
                    if(isEGift){
                        if(mem.MailingCity ==null || mem.MailingCity =='' || mem.MailingState ==null || mem.MailingState =='' || mem.MailingCountry ==null || mem.MailingCountry ==''
                           || mem.MailingStreet ==null || mem.MailingStreet =='' || mem.MailingPostalCode ==null || mem.MailingPostalCode ==''){
                               contactVsInvalidEmailAddress.put(mem,'Disabled');
                               
                           }else{
                               invalidContactWrapper.add(new wrapperClass(true,mem));
                           }
                    }
                    if(!isEGift){
                        if(mem.MailingCity ==null || mem.MailingCity =='' || mem.MailingState ==null || mem.MailingState =='' || mem.MailingCountry ==null || mem.MailingCountry ==''
                           || mem.MailingStreet ==null || mem.MailingStreet =='' || mem.MailingPostalCode ==null || mem.MailingPostalCode ==''){
                               contactVsInvalidEmailAddress.put(mem,'Disabled');
                               flag = false ;
                           }else{
                               invalidContactWrapper.add(new wrapperClass(true,mem));
                           }
                    }
                }else if(mem.MailingCity ==null || mem.MailingCity =='' || mem.MailingState ==null || mem.MailingState =='' || mem.MailingCountry ==null || mem.MailingCountry ==''
                         || mem.MailingStreet ==null || mem.MailingStreet =='' || mem.MailingPostalCode ==null || mem.MailingPostalCode ==''){
                             flag = false ;
                             contactsWithoutAddress += '<br/>';
                             contactsWithoutAddress +=  Mem.Name ; 
                             if(!isEGift){
                                 if(mem.Email ==null || mem.Email ==''){
                                     contactVsInvalidEmailAddress.put(mem,'Disabled');
                                 }else{
                                     invalidContactWrapper.add(new wrapperClass(true,mem));  
                                 }
                             }
                             if(isEGift){
                                 if(mem.Email ==null || mem.Email ==''){
                                     contactVsInvalidEmailAddress.put(mem,'Disabled');
                                 }else{
                                     invalidContactWrapper.add(new wrapperClass(true,mem));  
                                 }
                             }
                         }
            }
            
            if(invalidContactWrapper.isEmpty()){
                disableProceed = false;
                disableProceed1 = false;
            }
            
            List<Contact> contactList = [Select id, FirstName, LastName, Email From Contact Where Id = :recId WITH SECURITY_ENFORCED limit 1];
            recipientFirstName = (!contactList.isEmpty() && contactList[0].FirstName != null && contactList[0].FirstName != '') ? contactList[0].FirstName : '';
            recipientLastName = (!contactList.isEmpty() && contactList[0].LastName != null && contactList[0].LastName != '') ? contactList[0].LastName : '';
            recipientEmail = (!contactList.isEmpty() && contactList[0].Email != null && contactList[0].Email != '') ? contactList[0].Email : '';
            
        }
        else if(recId != null && recId.startsWith('00Q')){
            //   system.debug('Lead**');
            for (Lead mem : [select id,FirstName,lastName,Last_Gift_Send__c,Email,Name,City,state,country,street,postalcode FROM Lead Where Id =: recId WITH SECURITY_ENFORCED]){ 
                conName.add(mem.Name);
                
                billingStreet = mem.Street;
                billingCity = mem.City;
                billingState = mem.State;
                billingPostalCode = mem.PostalCode;
                
                if(!giftSetup.isEmpty() && giftSetup[0].Enable_gift_frequency__c && mem.Last_Gift_Send__c !=null && giftSetup[0].Corporate_gift__Gift_Frequency__c != null && mem.Last_Gift_Send__c.daysBetween(system.today()) < Integer.ValueOf(giftSetup[0].Corporate_gift__Gift_Frequency__c) ){
                    Daysflag = false; 
                    contactsWithGiftSend += '<br/>';
                    contactsWithGiftSend +=  Mem.Name ; 
                }else if(mem.Email ==null || mem.Email ==''){
                    Emailflag = false ;
                    contactsWithoutEmail += '<br/>';
                    contactsWithoutEmail +=  Mem.Name ;
                    if(isEGift){
                        if(mem.City ==null || mem.City =='' || mem.State ==null || mem.State =='' || mem.Country ==null || mem.Country ==''
                           || mem.Street ==null || mem.Street =='' || mem.PostalCode ==null || mem.PostalCode ==''){
                               leadVsInvalidEmailAddress.put(mem,'Disabled');
                           }else{
                               invalidLeadWrapper.add(new wrapperClassLead(true,mem));
                           }
                    }
                    if(!isEGift){
                        if(mem.City ==null || mem.City =='' || mem.State ==null || mem.State =='' || mem.Country ==null || mem.Country ==''
                           || mem.Street ==null || mem.Street =='' || mem.PostalCode ==null || mem.PostalCode ==''){
                               leadVsInvalidEmailAddress.put(mem,'Disabled');
                               flag = false ;
                           }else{
                               invalidLeadWrapper.add(new wrapperClassLead(true,mem));
                           }
                    }
                }else if(mem.City ==null || mem.City =='' || mem.State ==null || mem.State =='' || mem.Country ==null || mem.Country ==''
                         || mem.Street ==null || mem.Street =='' || mem.PostalCode ==null || mem.PostalCode ==''){
                             flag = false ;
                             contactsWithoutAddress += '<br/>';
                             contactsWithoutAddress +=  Mem.Name ; 
                             if(!isEGift){
                                 if(mem.Email ==null || mem.Email ==''){
                                     leadVsInvalidEmailAddress.put(mem,'Disabled');
                                 }else{
                                     invalidLeadWrapper.add(new wrapperClassLead(true,mem));  
                                 }
                             }
                             if(isEGift){
                                 if(mem.Email ==null || mem.Email ==''){
                                     leadVsInvalidEmailAddress.put(mem,'Disabled');
                                 }else{
                                     invalidLeadWrapper.add(new wrapperClassLead(true,mem));  
                                 }
                             }
                         }
            }
            
            if(invalidLeadWrapper.isEmpty()){
                disableProceed = false;
                disableProceed1 = true;
            }
            
            List<Lead> contactList = [Select id, FirstName, LastName, Email From Lead Where Id IN: ConList WITH SECURITY_ENFORCED limit 1];
            recipientFirstName = (!contactList.isEmpty() && contactList[0].FirstName != null && contactList[0].FirstName != '') ? contactList[0].FirstName : '';
            recipientLastName = (!contactList.isEmpty() && contactList[0].LastName != null && contactList[0].LastName != '') ? contactList[0].LastName : '';
            recipientEmail = (!contactList.isEmpty() && contactList[0].Email != null && contactList[0].Email != '') ? contactList[0].Email : '';
            
            
        }else if(recId != null && recId.startsWith('001')){
            accountFlag = true;
            //   system.debug('Account**');
            for (Account mem : [select id,name,BillingCity,BillingState,BillingCountry,BillingStreet,BillingPostalCode , Last_Gift_Send__c FROM Account Where Id IN :ConList WITH SECURITY_ENFORCED]){ 
                //system.debug('date++'+mem.Last_Gift_Send__c);
                conName.add(mem.Name);
                
                billingStreet = mem.billingStreet;
                billingCity = mem.billingCity;
                billingState = mem.billingState;
                billingPostalCode = mem.billingPostalCode;
                
                if(mem.BillingCity ==null || mem.BillingCity =='' || mem.BillingState ==null || mem.BillingState =='' || mem.BillingCountry ==null || mem.BillingCountry ==''
                   || mem.BillingStreet ==null || mem.BillingStreet =='' || mem.BillingPostalCode ==null || mem.BillingPostalCode ==''){
                       flag = false ;
                       contactsWithoutAddress += '<br/>';
                       contactsWithoutAddress +=  Mem.Name ;  
                       accountVsInvalidPhysicalAddress.put(mem,'Disabled');
                       
                   }else if(!giftSetup.isEmpty() && giftSetup[0].Corporate_gift__Enable_gift_frequency__c && mem.Last_Gift_Send__c !=null && giftSetup[0].Corporate_gift__Gift_Frequency__c != null && mem.Last_Gift_Send__c.daysBetween(system.today()) < Integer.ValueOf(giftSetup[0].Corporate_gift__Gift_Frequency__c) ){
                       Daysflag = false; 
                       contactsWithGiftSend += '<br/>';
                       contactsWithGiftSend +=  Mem.Name ; 
                   }
            }
            if(!accountVsInvalidPhysicalAddress.isEmpty()){
                disableProceed = false;
                disableProceed1 = true;
            }
            
        }
        
        
        if(!Daysflag){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,' <b>  Gift cannot be sent twice in less than ' + System.label.SendAnotherGiftIn_N_days + ' days </b>' + contactsWithGiftSend ));
        }
        /*   if(!Emailflag && isEgift){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,' <b>  The record do not have an email address - please add an email address and try again </b>'+contactsWithoutEmail ));
}
if(!isEgift && !flag){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,' <b> The record do not have an address - please add an address and try again </b>'+contactsWithoutAddress ));
}
*/
        
    }
    public void notzero()
    {
        
        //   system.debug(giftIdVsgiftProduct.get(giftSelected).Price__c);
        if (Quantity<1)
        {
            
            Quantity=Last_Quantity;
        } else {
            Last_Quantity = Quantity;
        }
    }
    
    public void showPopup(){
        System.debug('Send gift called' );
        System.debug('billingState' + billingState);
        
        
        budgetList = new List<SelectOption>();
        map<String,String> budgetResposne = new map<String,String>();
        budgetResposne = FinalSendGift_Class.checkBudgetPrice(senderEmail,giftIdVsgiftProduct.get(giftSelected).Price__c,merchnat_id);            
        //  System.debug('showPopup budgetResposne * '+budgetResposne);
        
        for(String key : budgetResposne.keySet()){
            budgetList.add(new SelectOption(key ,budgetResposne.get(key)));
            //     budgetList.add(new SelectOption('test' ,'1125'));
            
        }
        if(budgetList != null && !budgetList.isEmpty() && budgetList.size() > 1){
            displayPopup = true;
            if(String.isBlank(billingState)  ||String.isBlank(billingStreet)  || String.isBlank(billingCity)  || String.isBlank(billingPostalCode) )
            {
                pageError = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Fill all One Time Address fields!'));  
            }else{
                pageError = false;

            }
        }else if(budgetList != null && !budgetList.isEmpty() && budgetList.size() == 1){
            displayPopup = false;
            budgetSelected = budgetList[0].getValue();
            //    System.debug('methodName**'+methodName);
               System.debug('billingState' + billingState);
            
            if(String.isBlank(billingState)  ||String.isBlank(billingStreet)  || String.isBlank(billingCity)  || String.isBlank(billingPostalCode) )
            {
                pageError = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Fill all One Time Address fields!'));  
            }else{
                pageError = false;

                if(methodName == 'sendgift'){
                    sendGift();
                }else if(methodName == 'customSendGift'){
                    customSendGift();
                }
            }
        }
        
        
        
        
    }
    
    public void closePopup(){
        displayPopup = false;
        
    }
    
    public void closePopup1(){
        System.debug(invalidContactWrapper);
        system.debug('@@@@@@@@@@@@@@@@@@@');
        displayPopup1 = false;
        
        
    }
    
    /*
* Method Name     : sendGift
* @Description    : This method is used to invoking batch class.
*/
    public void sendGift(){
        System.debug('potapenko in sendGift method');
        if(greetSelected.contains('Other')){
            greetSelected = otherSalution;
        }
        
        System.debug('billingCustom***'+billingCustom);
        System.debug('billingStreet***'+billingStreet);
        System.debug('billingPostalCode***'+billingPostalCode);
        System.debug('billingState***'+billingState);
        System.debug('billingCity***'+billingCity);
        
        billingCustom.billingStreet = billingStreet;
        billingCustom.billingPostalCode = billingPostalCode;
        billingCustom.billingState = billingState;
        billingCustom.billingCity = billingCity;
        
        if(isEgift){
            
            if(E_GiftName == null || E_GiftName == ''){
                E_GiftName = [Select id,name from User where id=:userinfo.getuserid() WITH SECURITY_ENFORCED limit 1].name ;
            }
            if(recId != null && recId.startsWith('003')){
                
                //MassGiftSendBatchClass obj = new MassGiftSendBatchClass(ConList , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'E_gift',giftVsIdMap.get(giftSelected) ,E_GiftName);
                //Database.executeBatch(obj,1);
                Integer can_create_dedicated_links = 0;
                if( dedicatedLink ){
                    can_create_dedicated_links = 1;
                }
                String result = FinalSendGift_Class.sendGiftCallout(ConList , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'E_gift',giftVsIdMap.get(giftSelected) ,E_GiftName ,reGift, 'Contact', can_create_dedicated_links, video_url, emailSubject,giftIdVsgiftProduct,budgetSelected,Quantity);
                
                errorMessage = result;
            }
            if(recId != null && recId.startsWith('00Q')){
                Integer can_create_dedicated_links = 0;
                if( dedicatedLink ){
                    can_create_dedicated_links = 1;
                } 
                
                String result = FinalSendGift_Class.sendGiftCallout(ConList , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'E_gift',giftVsIdMap.get(giftSelected) ,E_GiftName ,reGift, 'Lead', can_create_dedicated_links, video_url, emailSubject,giftIdVsgiftProduct,budgetSelected,Quantity);
                
                errorMessage = result;
            }
        }else{
            
            
            if(recId != null && recId.startsWith('003')){
                String result = FinalSendGift_Class.sendMassPhysicalGift(ConList ,billingCustom, giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'P_gift',giftVsIdMap.get(giftSelected) , 'Contact',giftIdVsgiftProduct,budgetSelected,Quantity);
                
                errorMessage = result;
            }
            if(recId != null && recId.startsWith('00Q')){
                String result = FinalSendGift_Class.sendMassPhysicalGift(ConList ,billingCustom, giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'P_gift',giftVsIdMap.get(giftSelected) , 'Lead',giftIdVsgiftProduct,budgetSelected,Quantity);
                
                errorMessage = result;
            }
            
            
        }
        if(recId != null && recId.startsWith('001')){
            String result = sendGiftAccountCallout(ConList ,billingCustom, giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'P_gift',giftVsIdMap.get(giftSelected),budgetSelected,Quantity);
            
            errorMessage = result;
        }
        displayPopUp = false;
    } 
    
    public string sendGiftAccountCallout(set<string> ContactIds ,FinalSendGift_Class.BillingAddressCustom billingCustom, String giftId , String message ,string greeting ,string recipientName ,string giftName ,string giftType ,string recId,String budgetSelected,Integer Quantity){
        
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
            if(budgetSelected != null ){
                JSONBody.put('budget_id',budgetSelected);
            }
            if(greeting != null){
                greetMessage =greetMessage + greeting ; 
            }
            
            list<object> recipients = new list<Object>();
            for(Account con : [Select id,Message__c,Phone,Gift_Name__c,Name,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account where Id IN :ContactIds WITH SECURITY_ENFORCED]){
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
                        recipientMap.put('street',billingCustom.BillingStreet);  
                    }
                    if(con.BillingCity!=null){
                        recipientMap.put('city',billingCustom.BillingCity);  
                    }
                    if(con.BillingState!=null){
                        recipientMap.put('state',billingCustom.BillingState);  
                    }
                    if(con.BillingPostalCode!=null){
                        recipientMap.put('zip',billingCustom.BillingPostalCode);  
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
            if(Quantity !=null){
                JsonBody.put('qty',Quantity);  
            }
            string body = JSON.serialize(JsonBody) ;
            //   system.debug('#### Line 107 AccBatch JOSN Body**'+body);
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
            //   system.debug('#### REQUEST BODY **'+request2.getBody());//<---
            
            HttpResponse resp2 = http2.send(request2); 
            //   system.debug('response code --->> '+resp2.getStatusCode());
            //   system.debug('response body -->> '+resp2.getBody());
            if(resp2.getStatusCode()==200){
                //    system.debug('resp2.getBody()-----'+resp2.getBody());
                map<string,object> responseBody2 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
                //   system.debug('### responseBody2**'+responseBody2);
                string rest2 = (string.valueOf(responseBody2.get('success')));
                //   system.debug('rest2**'+rest2);
                if(!responseBody2.isEmpty() && responseBody2.containsKey('success') && rest2=='true'){
                    createRecordsAfterCalloutAccount(String.valueOf(responseBody2.get('order_id')),giftId,recId, giftName, giftType, contactIdsList,Quantity);
                    return '{"success":"true","message":"Gift send successfully!"}';
                }else{
                    //    system.debug('#### SUCCESS '+JSON.serialize(responseBody2));
                    return JSON.serialize(responseBody2);
                }   
                
                
            } else{
                Map<String,String> msgMap = new Map<String,String>();
                msgMap.put('success', 'false');
                msgMap.put('message',resp2.getStatusCode()+' Error Occure');
                //  system.debug('#### ERROR '+JSON.serialize(msgMap));
                return JSON.serialize(msgMap);
                // return '{"success":"false","message":"'+resp2.getStatusCode()+' Error encountered"}';
            } 
            
        }catch(Exception ex){
            //   System.debug('**** EXCEPTION ENCOUNTERED ****'+ex.getLineNumber()+' =>'+ex.getMessage() );
            Map<String,String> msgMap = new Map<String,String>();
            msgMap.put('success', 'false');
            msgMap.put('message',' Gift can not be send, Exception '+ex.getMessage()+' Encountered');
            //   system.debug('#### EXCEPTION '+JSON.serialize(msgMap));
            return JSON.serialize(msgMap);
            // return '{"success":"false","message":"Gift can not be send, Exception : "'+ex.getMessage()+'}';
        }
    }
    
    
    public void createRecordsAfterCalloutAccount(string gft_id ,string giftId,string recId,string giftName, String giftType, List<string> contactIdsList,Integer Quantity){
        //    system.debug('@@@ gft_id**'+gft_id);
        // system.debug(' @@@ conId**'+conId);
        string status = '';
        list<Account> conLstToUpdate = new List<Account>();
        
        List<Gift_History__c> giftHistoryList = new List<Gift_History__c>();
        Boolean check=false;
        
        map<String,String > recordIdMap = new map<String,String >();
        for(RecordType type : [select id, developerName from RecordType where SobjectType='Corporate_gift__Gift_History__c' WITH SECURITY_ENFORCED]){
            recordIdMap.put( type.developerName.tolowercase(), type.Id);
        }
        
        map<String,Account > contactIdVsContactObject = new map<String,Account >();
        for(Account con : [Select id from Account where id in : contactIdsList WITH SECURITY_ENFORCED ]){
            contactIdVsContactObject.put(con.id,con);
        }
        
        List<Task> tList = new List<Task>();
        Integer index = 0;
        try{
            for(String conId : contactIdsList){
                Account contct = new Account();
                if(Schema.sObjectType.Account.fields.id.isAccessible() ){
                    if(contactIdVsContactObject != null && !contactIdVsContactObject.isEmpty() && contactIdVsContactObject.containsKey(conId )){
                        contct = contactIdVsContactObject.get(conId );
                    }
                    //contct.id =contId;
                }
                //  jsonBodyStatus.put('merchant_id','6200');
                //  jsonBodyStatus.put('order_id',gft_id);
                if (Schema.sObjectType.Account.fields.Gift_Id__c.isAccessible() &&
                    Schema.sObjectType.Account.fields.Gift_Id__c.isUpdateable() ) {
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
                       System.debug(gh.Price__c);
                   }
                if(Schema.sObjectType.Gift_History__c.fields.Quantity__c.isAccessible()
                   && Schema.sObjectType.Gift_History__c.fields.Quantity__c.isCreateable()){
                       gh.Quantity__c = Quantity ;
                   }
                
                
                if( giftType != null &&  giftType.toLowerCase() == 'p_gift'
                   && (Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isAccessible()
                       && Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isCreateable())){
                           gh.gift_Type__c = 'P-Gift';
                       }else if ( giftType != null &&  giftType.toLowerCase() == 'e_gift'){
                           gh.gift_Type__c = 'E-Gift';
                       }
                
                giftHistoryList.add(gh);
                System.debug(giftHistoryList);
                
                if(Schema.sObjectType.Account.fields.Gift_On_The_Way__c.isAccessible() && 
                   Schema.sObjectType.Account.fields.Gift_On_The_Way__c.isUpdateable()) {
                       contct.Gift_On_The_Way__c = true;
                   }
                if (Schema.sObjectType.Account.fields.Gift_Name__c.isAccessible() &&
                    Schema.sObjectType.Account.fields.Gift_Name__c.isUpdateable()) {
                        contct.Gift_Name__c = giftName ;
                    }
                if (Schema.sObjectType.Account.fields.Last_Gift_Send__c.isAccessible() &&
                    Schema.sObjectType.Account.fields.Last_Gift_Send__c.isUpdateable() ) {
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
            // System.debug('Gift History**** '+giftHistoryList);
            
            if(check && (Schema.sObjectType.Account.isAccessible()&&
                         Schema.sObjectType.Account.isUpdateable())){
                             //system.debug('Account**'+conLstToUpdate);
                             update conLstToUpdate;
                         }
            if(!tList.isEmpty() 
               && (Schema.sObjectType.Task.isAccessible()
                   && Schema.sObjectType.Task.isCreateable())){
                       //system.debug('tList**'+tList);
                       insert tList;
                   }
            if(!giftHistoryList.isEmpty()
               && (Schema.sObjectType.Gift_History__c.isAccessible()
                   && Schema.sObjectType.Gift_History__c.isCreateable())){
                       //system.debug('giftHistoryList**'+giftHistoryList);
                       insert giftHistoryList;
                   }
        }
        catch(Exception ex){
            //  system.debug('Message '+ex.getMessage() + '  Line'+ex.getLineNumber());
        } 
    }
    
    
    public void sendGiftTypeMethod(){
        if(methodName == 'sendgift'){
            sendGift();
        }else if(methodName == 'customSendGift'){
            customSendGift();
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
    
    
    
    //ERROR RENDERER
    public void errorClose(){
        errorFlag = false;
        errorMessage = ''; 
    }
    
    // ENABLE MESSAGE
    public void showMag(){
        errorFlag = true;
    }
    
    
    /*
* Method Name     : customSendGift
* @Description    : This method is used to .
*/
    public void customSendGift(){
        
        billingCustom.billingStreet = billingStreet;
        billingCustom.billingPostalCode = billingPostalCode;
        billingCustom.billingState = billingState;
        billingCustom.billingCity = billingCity;
        
        if(isEGift && recId != null && recId.startsWith('003')){
            
            set<String> invalidAddContactList = new set<String>();
            if(invalidContactWrapper != null && !invalidContactWrapper.isEmpty()){
                for(wrapperClass wrpObj : invalidContactWrapper){
                    if(wrpObj.toggleFlag == true){
                        invalidAddContactList.add(wrpObj.conWrap.id);
                    }
                }
            }
            
            if(invalidAddContactList != null && !invalidAddContactList.isEmpty()){
                if(greetSelected.contains('Other')){
                    greetSelected = otherSalution;
                }
                String result;
                
                result = FinalSendGift_Class.sendMassPhysicalGift(invalidAddContactList ,billingCustom, giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'P_gift',giftVsIdMap.get(giftSelected) , 'Contact',giftIdVsgiftProduct,budgetSelected,Quantity);
                errorMessage = result;
                
            }
        }else if(isEGift && recId != null && recId.startsWith('00Q')){
            
            set<String> invalidAddLeadList = new set<String>();
            if(invalidLeadWrapper != null && !invalidLeadWrapper.isEmpty()){ 
                for(wrapperClassLead wrpObj : invalidLeadWrapper){
                    if(wrpObj.toggleFlag == true){
                        invalidAddLeadList.add(wrpObj.leadWrap.id);
                    }
                }
            }
            if(invalidAddLeadList != null && !invalidAddLeadList.isEmpty()){
                if(greetSelected.contains('Other')){
                    greetSelected = otherSalution;
                }
                String result;
                result = FinalSendGift_Class.sendMassPhysicalGift(invalidAddLeadList , billingCustom,giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'P_gift',giftVsIdMap.get(giftSelected) , 'Lead',giftIdVsgiftProduct,budgetSelected,Quantity);
                errorMessage = result;
                
            }
        }else if(!isEGift && recId != null && recId.startsWith('003')){
            
            set<String> invalidAddContactList = new set<String>();
            if(invalidContactWrapper != null && !invalidContactWrapper.isEmpty()){
                for(wrapperClass wrpObj : invalidContactWrapper){
                    if(wrpObj.toggleFlag == true){
                        invalidAddContactList.add(wrpObj.conWrap.id);
                    }
                }
            }
            
            if(invalidAddContactList != null && !invalidAddContactList.isEmpty()){
                if(greetSelected.contains('Other')){
                    greetSelected = otherSalution;
                }
                String result;
                Integer can_create_dedicated_links = 0;
                if( dedicatedLink ){
                    can_create_dedicated_links = 1;
                }
                result = FinalSendGift_Class.sendGiftCallout(invalidAddContactList , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'E_gift',giftVsIdMap.get(giftSelected) ,E_GiftName,reGift, 'Contact', can_create_dedicated_links, video_url, emailSubject,giftIdVsgiftProduct,budgetSelected,Quantity);
                
                errorMessage = result;
                
            }
        }else if(!isEGift && recId != null && recId.startsWith('00Q')){
            set<String> invalidAddLeadList = new set<String>(); 
            
            
            if(invalidLeadWrapper != null && !invalidLeadWrapper.isEmpty()){ 
                for(wrapperClassLead wrpObj : invalidLeadWrapper){
                    if(wrpObj.toggleFlag == true){
                        invalidAddLeadList.add(wrpObj.leadWrap.id);
                    }
                }
            }
            
            if(invalidAddLeadList != null && !invalidAddLeadList.isEmpty()){
                if(greetSelected.contains('Other')){
                    greetSelected = otherSalution;
                }
                
                Integer can_create_dedicated_links = 0;
                if( dedicatedLink ){
                    can_create_dedicated_links = 1;
                }
                
                String result;
                result = FinalSendGift_Class.sendGiftCallout(invalidAddLeadList , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'E_gift',giftVsIdMap.get(giftSelected) ,E_GiftName,reGift, 'Lead', can_create_dedicated_links, video_url, emailSubject,giftIdVsgiftProduct,budgetSelected,Quantity);
                
                errorMessage = result;
            }
        }
        displayPopUp = false;
        
        
    }
    
    /*
* Method Name     : setWrapperVal
* @Description    : This method is used to set the value in wrapper list from the VF Page toggle button.
*/
    public void setWrapperVal(){
        disableAddOneTimeAddress=false;
        if(recId != null && recId.startsWith('003')){
            for(wrapperClass wrpObj : invalidContactWrapper){
                if(wrpObj.conWrap.id == idVal){
                    wrpObj.toggleFlag = boolVal;
                }
            }
        }else if(recId != null && recId.startsWith('00Q')){
            for(wrapperClassLead wrpObj : invalidLeadWrapper){
                if(wrpObj.leadWrap.id == idVal){
                    wrpObj.toggleFlag = boolVal;
                }
            }
        }
        
        if(recId != null && recId.startsWith('00Q')){
            set<String> invalidAddLeadList = new set<String>();
            if(invalidLeadWrapper != null && !invalidLeadWrapper.isEmpty()){
                for(wrapperClassLead wrpObj : invalidLeadWrapper){
                    //  System.debug('wrpObj.toggleFlag***'+wrpObj.toggleFlag);
                    if(wrpObj.toggleFlag == true){
                        invalidAddLeadList.add(wrpObj.leadWrap.id);
                    }
                }
            }
            //   System.debug('invalidAddLeadList**'+invalidAddLeadList);
            if(invalidAddLeadList.isEmpty()){
                voidMap = false;
                voidMap1 = true;
            }else{
                voidMap = true;
                voidMap1 = false;
                
            }
        }else if(recId != null && recId.startsWith('003')){
            set<String> invalidAddContactList = new set<String>();
            if(invalidContactWrapper != null && !invalidContactWrapper.isEmpty()){
                for(wrapperClass wrpObj : invalidContactWrapper){
                    //    System.debug('wrpObj.toggleFlag***'+wrpObj.toggleFlag);
                    if(wrpObj.toggleFlag == true){
                        invalidAddContactList.add(wrpObj.conWrap.id);
                    }
                }
            }
            //   System.debug('invalidAddContactList**'+invalidAddContactList);
            
            if(invalidAddContactList.isEmpty()){
                voidMap = false;
                voidMap1 = true;
            }else{
                voidMap = true;
                voidMap1 = false;
                
            }
        }
        
    }
    
    /*
* Method Name     : proceed
* @Description    : This method is used to set the render of output panel.
*/
    public void proceed(){
        
        msgForm = true;
        disableProceed=true;
        disableAddOneTimeAddress=false;
       // voidMap1=false;
        //  System.debug('msgForm**'+msgForm);
        
    }
    
    public void proceed1(){
        
      //  msgForm1=true;
        displayPopUp1=true;
        System.debug('msgForm**');
        
    }
    
    public void save(){
       
        if(recId != null && recId.startsWith('003')){
            Contact mem = [select id,FirstName,lastName,Last_Gift_Send__c,Email,Name,MailingCity,MailingState,MailingCountry,MailingStreet,MailingPostalCode FROM Contact Where Id =: recId WITH SECURITY_ENFORCED];
            mem.MailingState=billingState;
            mem.MailingStreet=billingStreet;
            mem.MailingCity=billingCity;
            mem.MailingPostalCode=billingPostalCode;
        }
        else if(recId != null && recId.startsWith('00Q')){
            Lead lead = [select id,FirstName,lastName,Last_Gift_Send__c,Email,Name,City,state,country,street,postalcode FROM Lead Where Id =: recId WITH SECURITY_ENFORCED];
            lead.state=billingState;
            lead.street=billingStreet;
            lead.city=billingCity;
            lead.postalcode=billingPostalCode;
        }
        if(String.isBlank(billingState)  ||String.isBlank(billingStreet)  || String.isBlank(billingCity)  || String.isBlank(billingPostalCode) )
        {
            //flag1=false;
            //System.debug('here'+invalidContactWrapper);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'All Fields Are Mandatory'));  
            //voidMap = true;
            //voidMap1 = false;
        }
        else
        {
            
            
            system.debug('here>>');
            Daysflag =true; 
            flag=true;
            accountFlag=false;
            displayPopUp1 = false; 
            voidMap1 = false;
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
    
    /*
* Wrapper Class Name     : wrapperClass
* @Description         : This Class is used to bind toggle button with Lead.
*/    
    public class wrapperClassLead{
        public boolean toggleFlag{get;set;}
        public Lead leadWrap{get;set;}
        
        public wrapperClassLead(boolean toggleFlag, Lead leadWrap ){
            this.toggleFlag = toggleFlag;
            this.leadWrap = leadWrap;
        } 
    }
    
    
    /*
* Method Name     : calloutMethod
* @Description    : This method is used to make callout.
**/
    public static HttpResponse calloutMethod(String body, String methodType,String endpoint){
        
        httpRequest request2 = new httpRequest();
        request2.setEndpoint(endpoint);
        if(methodType != null){
            request2.setMethod(methodType);
        }
        request2.setHeader('Accept','application/json');
        request2.setHeader('Content-Type','application/json');
        request2.setTimeout(120000);
        request2.setBody(body); 
        http http2 = new http();
        //   SYstem.debug('request2**'+request2);
        //   SYstem.debug('body**'+body);
        
        HttpResponse response = http2.send(request2); 
        return response;
        
    }
    
    
}