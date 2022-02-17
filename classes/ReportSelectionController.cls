public with sharing class  ReportSelectionController {
    public String reportId{get;set;}
    public String reportSelected {get;set;}
    public  Boolean reportSelectionPanel{get;set;}
    public  Boolean afterSelectionPanel{get;set;}
    public Integer numberOfRecords {get;set;}
    public string senderEmail{get;set;}
    public List<SelectOption> giftList {get;set;}
    public String giftSelected{get;set;}
    public List<SelectOption> giftTypeOption {get;set;}
    public String giftTypeSelected{get;set;}
    public Boolean validReport {get;set;}
    public Set<ID> contactIDSet;
    public Boolean msgForm {get;set;}
    public String fetchObjectName ;
    public String nameString{get;set;}
    public string E_GiftName{get;set;}
    public String greetSelected {get;set;}
    public List<SelectOption> greetingList {get;set;}
    public string otherSalution {get;set;}
    public String recipientSelected {get;set;}
    public List<SelectOption> recipientList {get;set;}
    public map<String,String> giftNameVsgiftImage {get;set;}
    public map<string,string> giftVsIdMap {get;set;}
    public map<string,string> giftIdVsNameMap {get;set;}
    public map<String,products__c> giftIdVsgiftProduct {get;set;}
    public String messageGreeting{get;set;}
    public boolean previewFlag {get;set;}
    public Integer Quantity{get;set;}
    public Integer Last_Quantity{get;set;}
    public boolean reGift {get;set;}
    public list<Account> accountList = new list<Account>();
    public list<Contact> contactList = new list<Contact>();
    public list<Lead> leadList = new list<Lead>();
    public Set<String> validIdSet = new Set<String>();
    public string calloutResult{get;set;}// Final result message
    public string recipientFirstName {get;set;}
    public string recipientLastName {get;set;}
    public string recipientEmail {get;set;}
    public boolean dedicatedLink{get;set;}
    public String video_url{get;set;}
    public String emailSubject{get;set;}
    public list<Corporate_gift__GiftingSetup__c> giftSetup = new list<GiftingSetup__c>([Select Id ,Corporate_gift__Create_task_on_status_change__c ,Corporate_gift__Enable_gift_frequency__c ,Corporate_gift__Merchant_Id__c  ,Corporate_gift__Status_Merchant_Id__c From Corporate_gift__GiftingSetup__c WITH SECURITY_ENFORCED Limit 1]);
    public String merchnat_id {get;set;}
    public String budgetSelected {get;set;}
    public List<SelectOption> budgetList {get;set;}
    public boolean displayPopup {get;set;}
    public String methodName {get;set;}

    public ReportSelectionController(ApexPages.StandardController controller){ 
        budgetList = new List<SelectOption>();
        quantity=1;
        if(giftSetup != null && !giftSetup.isEmpty()){
            merchnat_id = giftSetup[0].Merchant_Id__c;
        }
        fetchObjectName = null;
        reportSelectionPanel = true;
        afterSelectionPanel = false;
        contactIDSet = new set<ID>();
        validReport = false;
        giftList = new  List<SelectOption>();
        giftSelected = '';
        msgForm = false;
        greetSelected = '';
        greetingList = new List<SelectOption>();
        otherSalution = '';
        recipientSelected= '';
        recipientList = new List<SelectOption>();
        giftNameVsgiftImage = new  map<String,String>();
        giftVsIdMap = new map<string,string>();
        giftIdVsNameMap = new  map<string,string> ();
        giftIdVsgiftProduct = new map<String,products__c>();
        previewFlag = false;
        reGift = false;
        dedicatedLink = false;
        video_url = '';
        emailSubject = '';
        
        
        
        giftTypeOption = new  List<SelectOption>();
        giftTypeSelected = '';
        
        User usr = [Select id,name,Email,Gift__c,Recipient_Name__c,Salutation__c from User where id=:userinfo.getuserid() WITH SECURITY_ENFORCED ];
        senderEmail = (usr != null && usr.Email != null && usr.Email != '') ? usr.Email : '';
      //  system.debug('usr');
     //   system.debug(usr);
        E_GiftName = usr.name ;
        
        
        Map<String, Object> JsonBody = new Map<String,Object>();

        JsonBody.put('user',usr.Email); // replace with current user email id 
        JsonBody.put('merchant_id',merchnat_id);
        
        HttpResponse response = new HttpResponse();
        response = GiftSendFromContactController.calloutMethod(JSON.serialize(JsonBody),'GET',System.Label.GetAvailableGift);
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
            for(products__c productObject : [SELECT id__c , name,Corporate_gift__Description__c,Corporate_gift__Price__c, Corporate_gift__Gift_Image__c FROM products__c Where isActive__c = true and name =: usr.Gift__c WITH SECURITY_ENFORCED limit 1]){
              //  giftList.add(new SelectOption(productObject.id__c , productObject.name));
             //   giftNameVsgiftImage.put(productObject.id__c,productObject.Corporate_gift__Gift_Image__c);
                giftVsIdMap.put(productObject.id__c , productObject.Id);
             //   giftIdVsNameMap.put(productObject.id__c , productObject.name);
             //   giftIdVsgiftProduct.put(productObject.id__c,productObject);
                
            }
        }
        for(products__c productObject : [SELECT id__c , name,Corporate_gift__Description__c,Corporate_gift__Price__c,Corporate_gift__Gift_Image__c FROM products__c Where isActive__c = true and name !=: usr.Gift__c WITH SECURITY_ENFORCED limit 10000]){
           // giftList.add(new SelectOption(productObject.id__c , productObject.name));
          //  giftNameVsgiftImage.put(productObject.id__c,productObject.Corporate_gift__Gift_Image__c);
            giftVsIdMap.put(productObject.id__c , productObject.Id);
         //   giftIdVsNameMap.put(productObject.id__c , productObject.name);
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
    
    @RemoteAction
    public static list<Report> getReport(){
        return [select id, developerName, Description, FolderName, Name, OwnerId, Owner.Name from Report WITH SECURITY_ENFORCED];
    }
    
    public void processReportAction(){
        
        try{
            Reports.ReportDescribeResult  results = Reports.ReportManager.describeReport(reportId);
            list<String> columnNameList = new list<String>();
            columnNameList = results.getReportMetadata().getDetailColumns();
            String objectNameUsed = results.getReportMetadata().getReportType().getType();
            Integer countVariable = 0;
            Integer index = 0;
            
            validReport = false;
            fetchObjectName = null;
            for(String colName : columnNameList){
                
                if(objectNameUsed.contains('Account')){
                    if(colName == 'ACCOUNT_ID' || colName == 'ACCOUNT.NAME'  ){
                        validReport = true;
                        fetchObjectName = 'Account';
                        index = countVariable;
                        break;
                    }
                }else if(objectNameUsed.contains('Contact') ){
                    if(colName == 'CONTACT_ID' || colName == 'FIRST_NAME' || colName == 'LAST_NAME' ||colName == 'NAME'){
                        validReport = true;
                        fetchObjectName = 'Contact';
                        index = countVariable;
                        break; 
                    }
                } else if(objectNameUsed.contains('Lead')){
                    if(   colName == 'LEAD_ID' || colName == 'FIRST_NAME' || colName == 'LAST_NAME'  ){
                        validReport = true;
                        fetchObjectName = 'Lead';
                        index = countVariable;
                        break; 
                    }
                }else{
                    validReport =false;
                }
                countVariable++;
            } 
            
            if(validReport == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Report does not contains column having record ID or Name or may be this report not related to account, contact or lead object.'));
            }else{
                giftTypeOption = new  List<SelectOption>();
                if(fetchObjectName == 'Account'){
                    giftTypeOption.add(new SelectOption('P-Gift' , 'P-Gift'));
                }else{
                    giftTypeOption.add(new SelectOption('E-Gift' , 'E-Gift'));
                    giftTypeOption.add(new SelectOption('P-Gift' , 'P-Gift'));                    
                }
                
                String factMapKey = null;
                Reports.reportResults results1 = Reports.ReportManager.runReport(reportId, true);
                Reports.Dimension dim = results1.getGroupingsDown();
                if(dim != null && dim.getGroupings() != null && !dim.getGroupings().isEmpty()){
                    Reports.GroupingValue groupingVal = dim.getGroupings()[0];
                    factMapKey = groupingVal.getKey() + '!T';
                }
                
                if(factMapKey == null){
                    factMapKey =  'T!T';
                }
                
                Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results1.getFactMap().get(factMapKey);
                
                Reports.SummaryValue sumVal = factDetails.getAggregates()[0];
                numberOfRecords = Integer.valueOf(sumVal.getLabel());
                
                for(Reports.ReportDetailRow detailRow : factDetails.getRows()){
                    if(index != null && detailRow.getDataCells().size() > index){
                        contactIDSet.add(String.valueOf(detailRow.getDataCells()[index].getValue()));
                    }
                }
            }
        }catch(Exception e){
            validReport = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
        
    }
    
    public void sendGiftInit(){
        
        Integer errorRecordCount = 0;
        try{
            
        //    System.debug('*********here***'+fetchObjectName);            
            msgForm = true;
            reportSelectionPanel = false;
            afterSelectionPanel = false;
            boolean eflag = true;
            boolean pflag = true;
            

            if(fetchObjectName == 'Account'){
                
                for (Account mem : [select id,name,BillingCity,BillingState,BillingCountry,BillingStreet,BillingPostalCode , Last_Gift_Send__c FROM Account Where Id IN :contactIDSet WITH SECURITY_ENFORCED]){ 
                    if(mem.BillingCity ==null || mem.BillingCity =='' || mem.BillingState ==null || mem.BillingState =='' || mem.BillingCountry ==null || mem.BillingCountry ==''
                       || mem.BillingStreet ==null || mem.BillingStreet =='' || mem.BillingPostalCode ==null || mem.BillingPostalCode ==''){
                           pflag = false;
                           errorRecordCount++;
                       }else{
                           accountList.add(mem);
                           validIdSet.add(mem.id);
                       }
                }
            }else if(fetchObjectName == 'Contact'){
                for (Contact mem : [select id,FirstName,lastName,Last_Gift_Send__c,Email,Name,MailingCity,MailingState,MailingCountry,MailingStreet,MailingPostalCode FROM Contact Where Id IN :contactIDSet WITH SECURITY_ENFORCED]){ 
                    if(giftTypeSelected == 'E-Gift'){
                        if(mem.Email == null || mem.Email ==''){
                            eflag = false;
                            errorRecordCount++;
                            
                        }else{
                            contactList.add(mem);
                            validIdSet.add(mem.id);
                            
                        }
                        
                        
                    }else if(giftTypeSelected == 'P-Gift'){
                        if(mem.MailingCity ==null || mem.MailingCity =='' || mem.MailingState ==null || mem.MailingState =='' || mem.MailingCountry ==null || mem.MailingCountry ==''
                           || mem.MailingStreet ==null || mem.MailingStreet =='' || mem.MailingPostalCode ==null || mem.MailingPostalCode ==''){
                               pflag = false;
                               errorRecordCount++;
                               
                           }else{
                               validIdSet.add(mem.id);
                               contactList.add(mem);
                               
                           } 
                    }
                    
                }
            }else if(fetchObjectName == 'Lead'){
                for (Lead mem : [select id,FirstName,lastName,Last_Gift_Send__c,Email,Name,City,State,Country,Street,PostalCode FROM Lead Where Id IN :contactIDSet WITH SECURITY_ENFORCED]){ 
                    if(giftTypeSelected == 'E-Gift'){
                        if(mem.Email == null || mem.Email ==''){
                            eflag = false;
                            errorRecordCount++;
                            
                        }else{
                            validIdSet.add(mem.id);
                            leadList.add(mem);
                        }
                        
                        
                    }else if(giftTypeSelected == 'P-Gift'){
                        if(mem.City ==null || mem.City =='' || mem.State ==null || mem.State =='' || mem.Country ==null || mem.Country ==''
                           || mem.Street ==null || mem.Street =='' || mem.PostalCode ==null || mem.PostalCode ==''){
                               pflag = false;
                               errorRecordCount++;
                               
                           }else{
                               validIdSet.add(mem.id);
                               leadList.add(mem);
                           } 
                    }
                }
                
            }
            
         //   System.debug('****giftTypeSelected*****'+giftTypeSelected+'****pflag****  '+pflag+'*****eflag******'+eflag);
            if(giftTypeSelected == 'P-Gift' && pflag == false){
             //   System.debug('****P-Gift*****');
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Report does not contains column having record ID or Name.'));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,errorRecordCount + ' out of ' + contactIDSet.size() +' '+ fetchObjectName+' does not have physical address on it.'));
            }
            
            if(giftTypeSelected == 'E-Gift' && eflag == false){
             //   System.debug('****E-Gift*****');
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Report does not contains column having record ID or Name.'));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,errorRecordCount + ' out of ' + contactIDSet.size() +' '+ fetchObjectName+' does not have email address on it.'));  
            }
            
            if(fetchObjectName =='Account' && accountList.size() > 1  ){
                nameString = accountList[0].name + ' + ' + (accountList.size() -1) + ' others';
            }else if(fetchObjectName =='Account' && accountList.size() == 1){
                nameString = accountList[0].name;
            }else if(fetchObjectName =='Contact' && contactList.size() > 1  ){
                nameString = contactList[0].name + ' + ' + (contactList.size() -1) + ' others';
            }else if(fetchObjectName =='Contact' && contactList.size() == 1){
                nameString = contactList[0].name;
            }else if(fetchObjectName =='Lead' && leadList.size() > 1  ){
                nameString = leadList[0].name + ' + ' + (leadList.size() -1) + ' others';
            }else if(fetchObjectName =='Lead' && leadList.size() == 1){
                nameString = leadList[0].name;
            }
            
            
            if(giftTypeSelected == 'P-Gift'){
                previewFlag = false;
            }else if(giftTypeSelected == 'E-Gift'){
                previewFlag = true;
            }
        }catch(Exception e){
          //  System.debug('**********e***'+e.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            msgForm = false;
        }
    }
    
    
    public void showPopup(){
        
        
        budgetList = new List<SelectOption>();
        map<String,String> budgetResposne = new map<String,String>();
        budgetResposne = FinalSendGift_Class.checkBudgetPrice(senderEmail,giftIdVsgiftProduct.get(giftSelected).Price__c,merchnat_id);            
     //   System.debug('showPopup budgetResposne * '+budgetResposne);
        
        for(String key : budgetResposne.keySet()){
            budgetList.add(new SelectOption(key ,budgetResposne.get(key)));
               // budgetList.add(new SelectOption('test' ,'1125'));
            
        }
        System.debug('Size: '+budgetList.size());
        if(budgetList != null && !budgetList.isEmpty() && budgetList.size() > 1){
            displayPopup = true;
            
        }else if(budgetList != null && !budgetList.isEmpty() && budgetList.size() == 1){
            displayPopup = false;
            budgetSelected = budgetList[0].getValue();
        //    System.debug('methodName**'+methodName);
            
            if(methodName == 'sendgift'){
                System.debug('go to send 1');
                sendGift();
                System.debug('go to send');
            }
        }    
        
    }
    
    public void closePopup(){
        displayPopup = false;
    }
    
    
    
    
    public void sendGift(){
        
        if(E_GiftName == null || E_GiftName == ''){
            E_GiftName = [Select id,name from User where id=:userinfo.getuserid() WITH SECURITY_ENFORCED limit 1].name ;
        }
        if(greetSelected.contains('Other')){
            greetSelected = otherSalution;
        }
        
        
        if(giftTypeSelected == 'P-Gift'){
          
            if(fetchObjectName =='Account' && accountList != null && !accountList.isEmpty()){
              
                String result = sendGiftAccountCallout(validIdSet , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'P_gift',giftVsIdMap.get(giftSelected),budgetSelected,Quantity);
                //String result = sendGiftAccountCallout(validIdSet , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'P_gift',giftVsIdMap.get(giftSelected));
            //    System.debug('result ******/////'+result);
                calloutResult = result;
             
            } else if(fetchObjectName =='Contact' && contactList != null && !contactList.isEmpty()){
                String result = sendMassGiftCalloutContact(validIdSet , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'P_gift',giftVsIdMap.get(giftSelected),budgetSelected,Quantity);
             //   System.debug('result ******////'+result);
                calloutResult = result;
          
            }else if(fetchObjectName =='Lead' && leadList != null && !leadList.isEmpty()){
                String  result = sendMassGiftCalloutLead(validIdSet , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'P_gift',giftVsIdMap.get(giftSelected),budgetSelected,Quantity);
             //   System.debug('result ******/////'+result);
                calloutResult = result;
            
            }
        }else if(giftTypeSelected == 'E-Gift'){
            if(fetchObjectName =='Contact' && contactList != null && !contactList.isEmpty()){
                String result = sendMassEGiftCalloutContact(validIdSet , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'E_gift',giftVsIdMap.get(giftSelected) ,E_GiftName, reGift,budgetSelected,Quantity);
             //   system.debug('### RESULT MESSAGE **'+result);
                calloutResult = result;
            }else if(fetchObjectName =='Lead' && leadList != null && !leadList.isEmpty()){
                String result = sendMassEGiftCalloutLead(validIdSet , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'E_gift',giftVsIdMap.get(giftSelected) ,E_GiftName, reGift,budgetSelected,Quantity);
             //   system.debug('### RESULT MESSAGE **'+result);
                calloutResult = result;
            }           
        }
        displayPopup = false;
        
    }
    
    // Account Mass P-Gift
    public string sendGiftAccountCallout(set<string> ContactIds , String giftId , String message ,string greeting ,string recipientName ,
                                        string giftName ,string giftType ,string recId,String budgetSelected,Integer Quantity){
        
        try{
            list<GiftingSetup__c> merchantList = new list<GiftingSetup__c>();
            Map<String, Object> JsonBody = new Map<String,Object>();
            String greetMessage ='';
            list<string> contactIdsList = new list<string>();
            
            merchantList = [Select Id,Merchant_Id__c ,Security_Header__c From GiftingSetup__c WITH SECURITY_ENFORCED limit 1];
            string UserEmail = [Select id,email from user where Id =: UserInfo.getUserId() WITH SECURITY_ENFORCED ].email ;
            JsonBody.put('user',UserEmail);
            JsonBody.put('merchant_id',merchantList[0].Merchant_Id__c);
            if(giftId != null){
                JsonBody.put('gift_id',giftId);  
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
            
           /* 
            for(Account con : [Select id,Message__c,Phone,Gift_Name__c,Name,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account where Id IN :ContactIds]){
                contactIdsList.add(con.id);
                if(con.name ==null && Schema.sObjectType.Account.fields.name.isUpdateable()){
                    con.name = '';
                }
                JsonBody.put('firstname',con.name); 
                greetMessage = greetMessage +' '+con.name  ; 
                
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
            } 
            */
            JsonBody.put('user',UserInfo.getUserEmail());
            if(budgetSelected != null){
                JsonBody.put('budget_id',budgetSelected);
            }
            if(Quantity !=null){
                JsonBody.put('qty',Quantity);  
            }
            string body = JSON.serialize(JsonBody) ;
          //  system.debug('#### Line 107 AccBatch JOSN Body**'+body);
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
             //   system.debug('rest2**'+rest2);
                if(!responseBody2.isEmpty() && responseBody2.containsKey('success') && rest2=='true'){
                    createRecordsAfterCalloutAccount(String.valueOf(responseBody2.get('order_id')),giftId,recId, giftName, giftType ,contactIdsList,Quantity);
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
        //    system.debug('#### EXCEPTION '+JSON.serialize(msgMap));
            return JSON.serialize(msgMap);
            // return '{"success":"false","message":"Gift can not be send, Exception : "'+ex.getMessage()+'}';
        }
    }
    
    
    public void createRecordsAfterCalloutAccount(string gft_id ,string giftId,string recId,string giftName, String giftType,List<string> contactIdsList,Integer Quantity){
        
        string status = '';
        list<Account> conLstToUpdate = new List<Account>();
        
        
        map<String,String > recordIdMap = new map<String,String >();
        for(RecordType type : [select id, developerName from RecordType where SobjectType='Corporate_gift__Gift_History__c' WITH SECURITY_ENFORCED]){
            recordIdMap.put( type.developerName.tolowercase(), type.Id);
        }

        map<String,Account > contactIdVsContactObject = new map<String,Account >();
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
                //contct.id = conId;
                    }}
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
                 && Schema.sObjectType.Gift_History__c.fields.Account__c.isCreateable())
                    {
                        gh.Account__c = conId;
                    }
             //   SYSTEM.DEBUG('>>>>>>>>>'+conId);
                if(Schema.sObjectType.Gift_History__c.fields.Gift__c.isAccessible()
                 && Schema.sObjectType.Gift_History__c.fields.Gift__c.isCreateable())
                    {
                        if(FinalSendGift_Class.validId(recId )){
                            gh.Gift__c = recId ;
                        }else{
                            gh.Gift__c = null;
                        }
                }
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isAccessible()
                 && Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isCreateable())
                    {
                        gh.Gift_Id__c = giftId ;
                    }
                //  gh.Gift_Name__c = giftName ;
                if(Schema.sObjectType.Gift_History__c.fields.Quantity__c.isAccessible()
                && Schema.sObjectType.Gift_History__c.fields.Quantity__c.isCreateable()){
                    gh.Quantity__c = Quantity ;
                }
                if(Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isAccessible()
                 && Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isCreateable())
                    {
                        gh.Sent_Date__c = system.today();
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isAccessible()
                 && Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isCreateable())
                    {
                        gh.Gift_Status_Id__c = gft_id;
                    }
                
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isAccessible()
                 && Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isCreateable())
                    {
                        gh.Gift_Status__c = 'Created';
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isAccessible()
                 && Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isCreateable())
                    {
                        gh.Shipping_Status__c = 'Created';
                    }
                if( giftType != null &&  giftType.toLowerCase() == 'p_gift' 
                 && (Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isAccessible()
                 && Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isCreateable())){
                     gh.gift_Type__c = 'P-Gift';
                 }else if ( giftType != null &&  giftType.toLowerCase() == 'e_gift'){
                     gh.gift_Type__c = 'E-Gift';
                 }
                if(Schema.sObjectType.Gift_History__c.fields.Price__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Price__c.isCreateable()){
                    gh.Price__c = giftIdVsgiftProduct != null && !giftIdVsgiftProduct.isEmpty() && giftIdVsgiftProduct.containsKey(giftId) ?  giftIdVsgiftProduct.get(giftId).Price__c : null;
                }


               
             //   system.debug('>>>>>>#'+gh);
                giftHistoryList.add(gh); 

                if(Schema.sObjectType.Account.fields.Gift_On_The_Way__c.isAccessible()
                    &&  Schema.sObjectType.Account.fields.Gift_On_The_Way__c.isUpdateable()) {
                    contct.Gift_On_The_Way__c = true;
                }
                if (Schema.sObjectType.Account.fields.Gift_Name__c.isAccessible()
                    && Schema.sObjectType.Account.fields.Gift_Name__c.isUpdateable() ) {
                    contct.Gift_Name__c = giftName ;
                }
                if (Schema.sObjectType.Account.fields.Last_Gift_Send__c.isAccessible()
                    && Schema.sObjectType.Account.fields.Last_Gift_Send__c.isUpdateable() ) {
                    contct.Last_Gift_Send__c = system.today();
                }
                conLstToUpdate.add(contct);
                check = true;
                Task taskObject = new Task();
            if(Schema.sObjectType.Task.fields.subject.isAccessible()
            && Schema.sObjectType.Task.fields.subject.isCreateable())
                {
                    taskObject.subject ='Gift Intiated - ' + giftName ; 
                }
            if(Schema.sObjectType.Task.fields.WhatId.isAccessible()
             && Schema.sObjectType.Task.fields.WhatId.isCreateable())
                {
                    taskObject.WhatId = conId;
                }
            if(Schema.sObjectType.Task.fields.ActivityDate.isAccessible()
             && Schema.sObjectType.Task.fields.ActivityDate.isCreateable())
                {
                    taskObject.ActivityDate = system.today();
                }
                
                tList.add(taskObject);
            }
        //    System.debug('Gift History**** '+giftHistoryList);
            
            if(check 
                 && (Schema.sObjectType.Account.isAccessible()
                 && Schema.sObjectType.Account.isUpdateable())){
               // system.debug('Account**'+conLstToUpdate);
                update conLstToUpdate;
            }
            if(!tList.isEmpty() && 
            (Schema.sObjectType.Task.isAccessible() && Schema.sObjectType.Task.isCreateable())){
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
         //   system.debug('Message '+ex.getMessage() + '  Line'+ex.getLineNumber());
            
            FinalSendGift_Class.createExceptionRecord(ex.getMessage());
        } 
    }
    // Account Mass P-Gift ended//
    
    //Contact P-GIft
    //
    /*
* Method Name     : sendMassGiftCallout
* @Description    : This method is used to make single callout to send mass gift.
*/
    public string sendMassGiftCalloutContact(set<string> ContactIds , String giftId , String message ,string greeting ,string recipientName ,string giftName ,string giftType ,string recId,String budgetSelected,Integer Quantity){
        
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
            if(budgetSelected != null){
                JsonBody.put('budget_id',budgetSelected);
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
            JsonBody.put('user',UserInfo.getUserEmail());
            
            JsonBody.put('recipients',recipientsList);
            
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
          // d761b7b70cc11bc523731fab56f780fc
          //  system.debug('#### BODY MAP '+JsonBody);
         //   system.debug('#### JSON BODY'+JSON.serialize(JsonBody));
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

            HttpResponse resp2 = http2.send(request2); 
            if(resp2.getStatusCode() == 200){
                map<string,object> responseBody2 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
                
                string rest2 = (string.valueOf(responseBody2.get('success')));

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
                    
                //    System.debug('increamentIds*****'+increamentIds);
                    
                    createRecordsAfterContactCallout(increamentIds ,giftId,recId, giftName, giftType, contactIdsList,Quantity); 
                //    system.debug('#### SUCCESS '+JSON.serialize(responseBody2));
                    return '{"success":"true","message":"Gift send successfully!"}';
                }else{
                //    system.debug('#### SUCCESS '+JSON.serialize(responseBody2));
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
    public void createRecordsAfterContactCallout(List<String> increamentIds,string giftId,string recId,string giftName, String giftType, List<String> contactIdsList,Integer Quantity){
        
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
        
        
        string status = '';
        Integer index = 0;
        try{
            for(String contId : contactIdsList){
                Contact contct = new Contact();
                
                if(Schema.sObjectType.Contact.fields.Id.isAccessible()){
                    if(contactIdVsContactObject != null && !contactIdVsContactObject.isEmpty() && contactIdVsContactObject.containsKey(contId)){
                        contct =contactIdVsContactObject.get(contId);    
                        // contct.id =contId;
                    }                }
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
                if( index < increamentIds.size() && increamentIds[index] != null
                && Schema.sObjectType.Contact.fields.Gift_Id__c.isAccessible() 
                && Schema.sObjectType.Contact.fields.Gift_Id__c.isUpdateable()){
                    contct.Gift_Id__c = increamentIds[index];
                }
                
                //CREATE GIFT HISTORY RECORD ***
            //    system.debug('gift_name++'+recId);
                if(Schema.sObjectType.Gift_History__c.fields.Sent_To__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Sent_To__c.isCreateable())
                    {
                        gh.Sent_To__c = contId;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Gift__c.isCreateable())
                    {
                        if(FinalSendGift_Class.validId(recId )){
                            gh.Gift__c = recId ;
                        }else{
                            gh.Gift__c = null;
                        }
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isCreateable())
                    {
                        gh.Gift_Id__c = giftId ;
                    }
                    if(Schema.sObjectType.Gift_History__c.fields.Quantity__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Quantity__c.isCreateable()){
                        gh.Quantity__c = Quantity ;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isCreateable())
                    {
                        gh.Sent_Date__c = system.today();
                    }
                //  if(Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isCreateable())
                //gh.Gift_Status_Id__c = gft_id;   
                if( index < increamentIds.size() && increamentIds[index] != null 
                 && (Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isCreateable()))
                    {
                        gh.Gift_Status_Id__c = increamentIds[index];
                    }
                
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isCreateable())
                    {
                        gh.Gift_Status__c = 'Created';
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isCreateable())
                    {
                        gh.Shipping_Status__c = 'Created';
                    }
                if( giftType != null &&  giftType.toLowerCase() == 'p_gift'
                 && (Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isCreateable())){
                     gh.gift_Type__c = 'P-Gift';
                 }else if ( giftType != null &&  giftType.toLowerCase() == 'e_gift'){
                     gh.gift_Type__c = 'E-Gift';
                 }
                 if(Schema.sObjectType.Gift_History__c.fields.Price__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Price__c.isCreateable()){
                    gh.Price__c = giftIdVsgiftProduct != null && !giftIdVsgiftProduct.isEmpty() && giftIdVsgiftProduct.containsKey(giftId) ?  giftIdVsgiftProduct.get(giftId).Price__c : null;
                  }



                giftHistoryList.add(gh);
               
                
                // UPDATE CONTACT RECORD***s

                       if(Schema.sObjectType.Contact.fields.GiftOnTheWay__c.isAccessible()
                        && Schema.sObjectType.Contact.fields.GiftOnTheWay__c.isUpdateable()) {
                        contct.GiftOnTheWay__c = true;
                       if(Schema.sObjectType.Contact.fields.Gift_Name__c.isAccessible()
                         && Schema.sObjectType.Contact.fields.Gift_Name__c.isUpdateable() ) {
                            contct.Gift_Name__c = giftName ;
                       }
                      if(Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isAccessible()
                      && Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isUpdateable()) {
                        contct.Last_Gift_Send__c = system.today();
                    }
                    conLstToUpdate.add(contct);
                //}
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
                 && Schema.sObjectType.Task.fields.subject.isCreateable())
                    {
                        taskObject.subject = 'Gift Intiated - ' + giftName ;
                    }
                if(Schema.sObjectType.Task.fields.WhoId.isAccessible()
                 && Schema.sObjectType.Task.fields.WhoId.isCreateable())
                    {
                        taskObject.WhoId = contId;
                    }
                if(Schema.sObjectType.Task.fields.ActivityDate.isAccessible()
                 && Schema.sObjectType.Task.fields.ActivityDate.isCreateable())
                    {
                        taskObject.ActivityDate = system.today();
                    }
                 if(Schema.sObjectType.Task.fields.whatId.isAccessible()
                    && Schema.sObjectType.Task.fields.whatId.isCreateable() ){
                        taskObject.whatId= contactIdVsAccountId != null && !contactIdVsAccountId .isEmpty() && contactIdVsAccountId.containsKey(contId) ?  contactIdVsAccountId.get(contId) : null;
                    }
                tList.add(taskObject);
                
                index++;
            }
            
            if(!conLstToUpdate.isEmpty()
                && (Schema.sObjectType.Contact.isAccessible()
                && Schema.sObjectType.Contact.isUpdateable())){
                //system.debug('Update contct**'+conLstToUpdate);
                update conLstToUpdate;
            }
            if(!tList.isEmpty()
             && (Schema.sObjectType.Task.isAccessible() && Schema.sObjectType.Task.isCreateable())){
                //system.debug('Update Task**'+tList);
                insert tList;
            }
            if(!giftHistoryList.isEmpty() && 
             (Schema.sObjectType.Gift_History__c.isAccessible() 
             && Schema.sObjectType.Gift_History__c.isCreateable())){
                //system.debug('Update giftHistoryList**'+giftHistoryList);
                insert giftHistoryList;
            }
        }
    }   catch(Exception ex){
         //   system.debug('EXCEPTION => '+ex.getMessage() + '  Line'+ex.getLineNumber());
            
            FinalSendGift_Class.createExceptionRecord(ex.getMessage());
        } 
    }
    //conatct p-gift ended
    //
    
    
    
    /*
* Method Name     : sendMassGiftCallout
* @Description    : This method is used to make single callout to send mass gift.
*/
    public string sendMassGiftCalloutLead(set<string> ContactIds , String giftId , String message ,string greeting ,string recipientName ,string giftName ,string giftType ,string recId,String budgetSelected,Integer Quantity){
        
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
            if(budgetSelected != null){
                JsonBody.put('budget_id',budgetSelected);
            }
            List<MassGiftSendController.wrapContact> recipientsList = new List<MassGiftSendController.wrapContact>();
            Map<String,String> recipientsMap = new Map<String,String>();
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
            
         //   System.debug('contactIdsList*****'+contactIdsList);
            
            
            JsonBody.put('recipients',recipientsList);
            JsonBody.put('user',UserInfo.getUserEmail());
            
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
        
         //   system.debug('#### BODY MAP '+JsonBody);
         //   system.debug('#### JSON BODY'+JSON.serialize(JsonBody));
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
        //    system.debug('**** REQUEST BODY '+request2);
            HttpResponse resp2 = http2.send(request2); 
            if(resp2.getStatusCode()==200){
             //   system.debug('SUCCESS responseBody2**'+resp2.getBody());
                map<string,object> responseBody2 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
             //   system.debug('responseBody2**'+responseBody2);
                string rest2 = (string.valueOf(responseBody2.get('success')));
              //  system.debug('rest2**'+rest2);
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
                    
                    createRecordsAfterLeadCallout(increamentIds ,giftId,recId, giftName, giftType, contactIdsList,Quantity); 
                  //  system.debug('#### SUCCESS '+JSON.serialize(responseBody2));
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
        //    System.debug('**** EXCEPTION ENCOUNTERED ****'+ex.getLineNumber()+' =>'+ex.getMessage() );
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
    public void createRecordsAfterLeadCallout(List<String> increamentIds,string giftId,string recId,string giftName, String giftType, List<String> contactIdsList,Integer Quantity){
        
        List<Task> tList = new List<Task>();
        List<Gift_History__c> giftHistoryList = new List<Gift_History__c>();
        list<Lead> conLstToUpdate = new List<Lead>();
        Boolean check = false;
        //system.debug('gft_id**'+gft_id);
     //   system.debug('conId List**'+contactIdsList);
        string status = '';

        map<String,String > recordIdMap = new map<String,String >();
        for(RecordType type : [select id, developerName from RecordType where SobjectType='Corporate_gift__Gift_History__c' WITH SECURITY_ENFORCED]){
            recordIdMap.put( type.developerName.tolowercase(), type.Id);
        }
        map<String,Lead > contactIdVsContactObject = new map<String,Lead >();
        for(Lead con : [Select id from Lead where id in : contactIdsList WITH SECURITY_ENFORCED ]){
            contactIdVsContactObject.put(con.id,con);
        }
        
        
        Integer index = 0;
        try{
            for(String contId : contactIdsList){
                Lead contct = new Lead();
                if(Schema.sObjectType.Lead.fields.Id.isAccessible()){
                    if(contactIdVsContactObject != null && !contactIdVsContactObject.isEmpty() && contactIdVsContactObject.containsKey(contId)){
                        contct =contactIdVsContactObject.get(contId);    
               // contct.id =contId;
                    }}
                 
                Gift_History__c gh = new Gift_History__c();
                if( giftType != null && recordIdMap != null && !recordIdMap.isEmpty() 
                && recordIdMap.containsKey( giftType.toLowerCase() )){
                    if(Schema.sObjectType.Gift_History__c.fields.recordTypeId.isAccessible()){        
                        if(Schema.sObjectType.Gift_History__c.fields.recordTypeId.isCreateable()){
                        gh.recordTypeId = recordIdMap.get( giftType.toLowerCase() );
                        }
                    }
         
                }
                //   if(Schema.sObjectType.Lead.fields.Gift_Id__c.isUpdateable())
                //contct.Gift_Id__c = gft_id ;
                if( index < increamentIds.size() && increamentIds[index] != null
                     && (Schema.sObjectType.Lead.fields.Gift_Id__c.isAccessible() 
                     && Schema.sObjectType.Lead.fields.Gift_Id__c.isUpdateable())){
                      contct.Gift_Id__c = increamentIds[index];
                }
                
                //CREATE GIFT HISTORY RECORD ***
             //   system.debug('gift_name++'+recId);
                if(Schema.sObjectType.Gift_History__c.fields.Lead__c.isCreateable() 
                 && Schema.sObjectType.Gift_History__c.fields.Lead__c.isCreateable())
                    {
                        gh.Lead__c = contId;
                    }
                    if(Schema.sObjectType.Gift_History__c.fields.Gift__c.isCreateable() 
                 && Schema.sObjectType.Gift_History__c.fields.Gift__c.isCreateable())
                    {
                        if(FinalSendGift_Class.validId(recId )){
                            gh.Gift__c = recId ;
                        }else{
                            gh.Gift__c = null;
                        }
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isCreateable())
                    {
                        gh.Gift_Id__c = giftId ;
                    }
                    if(Schema.sObjectType.Gift_History__c.fields.Quantity__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Quantity__c.isCreateable()){
                        gh.Quantity__c = Quantity ;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isCreateable())
                    {
                        gh.Sent_Date__c = system.today();
                    }
                // if(Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isCreateable())
                //gh.Gift_Status_Id__c = gft_id;   
                if( index < increamentIds.size() && increamentIds[index] != null 
                 && (Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isCreateable()))
                    {
                        gh.Gift_Status_Id__c = increamentIds[index];
                    }
                
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isCreateable())
                    {
                        gh.Gift_Status__c = 'Created';
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isCreateable())
                    {
                        gh.Shipping_Status__c = 'Created';
                    }
                if( giftType != null &&  giftType.toLowerCase() == 'p_gift'
                 && (Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isCreateable())){
                     gh.gift_Type__c = 'P-Gift';
                 }else if ( giftType != null &&  giftType.toLowerCase() == 'e_gift'){
                     gh.gift_Type__c = 'E-Gift';
                 }
                 
                if(Schema.sObjectType.Gift_History__c.fields.Price__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Price__c.isCreateable()){
                    gh.Price__c = giftIdVsgiftProduct != null && !giftIdVsgiftProduct.isEmpty() && giftIdVsgiftProduct.containsKey(giftId) ?  giftIdVsgiftProduct.get(giftId).Price__c : null;
                }


                giftHistoryList.add(gh);
                
                // UPDATE CONTACT RECORD***s

                if(Schema.sObjectType.Lead.fields.Gift_On_The_Way__c.isAccessible()
                    && Schema.sObjectType.Lead.fields.Gift_On_The_Way__c.isUpdateable()) {
                        contct.Gift_On_The_Way__c = true;}
                if(Schema.sObjectType.Lead.fields.Gift_Name__c.isAccessible()
                    && Schema.sObjectType.Lead.fields.Gift_Name__c.isUpdateable()) {
                        contct.Gift_Name__c = giftName ;
                }
                if(Schema.sObjectType.Lead.fields.Last_Gift_Send__c.isAccessible()
                    && Schema.sObjectType.Lead.fields.Last_Gift_Send__c.isUpdateable() ) {
                        contct.Last_Gift_Send__c = system.today();
                 }
                conLstToUpdate.add(contct);
                //}
                // else if(Schema.sObjectType.Lead.fields.Gift_Name__c.isUpdateable()) {
                //   contct.Gift_Name__c = giftName ;
                // if(Schema.sObjectType.Lead.fields.Last_Gift_Send__c.isUpdateable()) {
                //   contct.Last_Gift_Send__c = system.today();
                //}
                //conLstToUpdate.add(contct);
                //              }
                //                else if(Schema.sObjectType.Lead.fields.Last_Gift_Send__c.isUpdateable()) {
                //                contct.Last_Gift_Send__c = system.today();
                //              conLstToUpdate.add(contct);
                //        }
                
                // CREATE A NEW TASK***
                Task taskObject = new Task();
                if(Schema.sObjectType.Task.fields.subject.isAccessible() 
                && Schema.sObjectType.Task.fields.subject.isCreateable())
                    {
                        taskObject.subject = 'Gift Intiated - ' + giftName ;
                    }
                if(Schema.sObjectType.Task.fields.WhoId.isAccessible() 
                 && Schema.sObjectType.Task.fields.WhoId.isCreateable())
                    {
                        taskObject.WhoId = contId;
                    }
                if(Schema.sObjectType.Task.fields.ActivityDate.isAccessible() 
                 && Schema.sObjectType.Task.fields.ActivityDate.isCreateable())
                    {
                        taskObject.ActivityDate = system.today();
                    }
                
                tList.add(taskObject);
                
                index++;
            }
            
            if(!conLstToUpdate.isEmpty()
                 && (Schema.sObjectType.Lead.isAccessible()
                 && Schema.sObjectType.Lead.isUpdateable())){
            //    system.debug('Update contct**'+conLstToUpdate);
                update conLstToUpdate;
            }
            if(!tList.isEmpty() && 
            (Schema.sObjectType.Task.isAccessible() && Schema.sObjectType.Task.isCreateable())){
                //system.debug('Update Task**'+tList);
                insert tList;
            }
            if(!giftHistoryList.isEmpty() && (Schema.sObjectType.Gift_History__c.isAccessible() 
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
    
    /// lead p-gift ended
    
    
    //contact e-gift
    
    /*
* Method Name     : sendMassEGiftCallout
* @Description    : This method is used to make single callout to send mass Egift.
*/
    public string sendMassEGiftCalloutContact(set<string> ContactIds , String giftId , String message ,string greeting ,string recipientName ,string giftName ,string giftType ,string recId ,string E_GiftName, Boolean reGift,String budgetSelected,Integer Quantity){
        
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

            Integer can_create_dedicated_links = null;
            if( dedicatedLink ){
                can_create_dedicated_links = 1;
            }
            if(budgetSelected != null){
                JsonBody.put('budget_id',budgetSelected);
            }
            if(giftType=='E_gift'){
                JsonBody.put('egift_name',E_GiftName);  

                if( video_url != null && video_url.trim() != ''){
                    JsonBody.put('video_url',video_url);
                }

                if( emailSubject != null && emailSubject.trim() != '' && 
                    ( can_create_dedicated_links == null || can_create_dedicated_links == 0) ){
                    JsonBody.put('subject',emailSubject);
                }

                if( can_create_dedicated_links != null ){
                    JsonBody.put('can_create_dedicated_links',can_create_dedicated_links);
                }

            }

            
            
            
            List<FinalSendGift_Class.wrapContact> recipientsList = new List<FinalSendGift_Class.wrapContact>();
            Map<String,String> recipientsMap = new Map<String,String>();

            map<String,String> recordIdVsEmail = new map<String,String>();
            for(Contact cont : [Select id, email,Message__c,Phone,Last_Gift_Send__c,Gift_Name__c, firstName,lastName,Name,mailingStreet,mailingCity,mailingState,mailingPostalCode,MailingCountry,Account.Name from contact where Id IN :ContactIds WITH SECURITY_ENFORCED]){
                FinalSendGift_Class.wrapContact cont_Recd = new FinalSendGift_Class.wrapContact();
                cont_Recd.firstname =cont.FirstName;
                cont_Recd.email =cont.email;
                cont_Recd.lastname =cont.lastname;
                recipientsList.add(cont_Recd); 
                recordIdVsEmail.put(cont.id, cont.email);
            }
            
            if(recipientName !=null && recipientName !='' && recipientName.contains('Include Just Recipient First Name')){
                greetMessage = greetMessage +' '+'<First Name>'  ; 
                
            }else if(recipientName !=null && recipientName !='' && recipientName.contains('Include Just Recipient Last Name')){
                greetMessage = greetMessage +' '+'<Last Name>' ; 
                
            }else if(recipientName !=null && recipientName !='' && recipientName.contains('Include Both First and Last Name (Recommended)')){
                greetMessage = greetMessage +' '+'<First Name> <Last Name>' ; 
                
            }
            
            if(message !=null && ( can_create_dedicated_links == null || can_create_dedicated_links == 0 )){
                greetMessage = greetMessage +'\n\n'+message; 
            }
            if(greetMessage !=null){
                JsonBody.put('message',greetMessage);  
            } 
            JsonBody.put('user',UserInfo.getUserEmail());
            JsonBody.put('upgrade_regift' , reGift);
            
            JsonBody.put('recipients',recipientsList);
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
         //   system.debug('*** RAW BODY '+JsonBody);
        //    system.debug('**** REQUEST BODY '+request2);
            HttpResponse resp2 = http2.send(request2); 
            map<string,object> responseBody3 = new map<string,object>();
            
            if(resp2.getStatusCode()==200){
         //       system.debug('SUCCESS responseBody3**'+resp2.getBody());
                responseBody3 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
          //      system.debug('responseBody3**'+responseBody3);
                string rest2 = (string.valueOf(responseBody3.get('success')));
          //      system.debug('rest2**'+rest2);
                if(!responseBody3.isEmpty() && responseBody3.containsKey('success') && rest2=='true'){

                    String dedicatedUrl = null;
                    if( responseBody3.containskey('url') && responseBody3.get('url') != null  ){
                        dedicatedUrl = String.valueof(responseBody3.get('url'));
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
                        //    system.debug('SUCCESS responseBody CSV**'+responseInnerCsv.getBody());
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

                    //createRecordsAfterCallout(String.valueOf(responseBody3.get('order_id')),con.Id,recId,giftId);
                    createRecordsAfterEGiftContactCallout(String.valueOf(responseBody3.get('order_id')) ,giftId,recId, giftName, ContactIds, dedicatedUrl,recordIdVsEmail, emailVsUrlMap,Quantity); 
                    
                    Map<String,String> msgMap = new Map<String,String>();
                    msgMap.put('success', 'true');
                    msgMap.put('message', 'Gift send successfully!');
                    msgMap.put('Url', dedicatedUrl);

                    return JSON.serialize(msgMap);
                }else{
                 //   system.debug('#### SUCCESS '+JSON.serialize(responseBody3));
                    return JSON.serialize(responseBody3);
                }
            }
            else{
                Map<String,String> msgMap = new Map<String,String>();
                msgMap.put('success', 'false');
                msgMap.put('message',resp2.getStatusCode()+' Error Occure');
                FinalSendGift_Class.createExceptionRecord(resp2.getBody()); 
              //  system.debug('#### ERROR '+JSON.serialize(msgMap));
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
          //  system.debug('#### EXCEPTION '+JSON.serialize(msgMap));
            return JSON.serialize(msgMap);
            // return '{"success":"false","message":"Gift can not be send, Exception : "'+ex.getMessage()+'}';
        }   
    }
    
    //AFTER RESPONSE METHOD
    public void createRecordsAfterEGiftContactCallout(string gft_id,string giftId,string recId,string giftName, set<String> ContactIds,
                                                        String dedicatedUrl, map<String, String> recordIdVsEmail, map<String, String> emailVsUrlMap,Integer Quantity){
        
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
        

     //   system.debug('gft_id**'+gft_id);
     //   system.debug('conId List**'+ContactIds);
        string status = '';
        try{
            for(String contId : ContactIds){
                Contact contct = new Contact();
                if(Schema.sObjectType.Contact.fields.Id.isAccessible()) 
                {
                    if(contactIdVsContactObject != null && !contactIdVsContactObject.isEmpty() && contactIdVsContactObject.containsKey(contId)){
                        contct =contactIdVsContactObject.get(contId);    
                        // contct.id =contId;
                    }
                }
                Gift_History__c gh = new Gift_History__c();
                if( recordIdMap != null && !recordIdMap.isEmpty() 
                 && recordIdMap.containsKey('e_gift')){
                    if(Schema.sObjectType.Gift_History__c.fields.recordTypeId.isAccessible()){        
                        if(Schema.sObjectType.Gift_History__c.fields.recordTypeId.isCreateable()){
                            gh.recordTypeID = recordIdMap.get( 'e_gift' );
                        }
                    }
                    
                }
                
                 if(Schema.sObjectType.Contact.fields.Gift_Id__c.isAccessible() 
                    &&  Schema.sObjectType.Contact.fields.Gift_Id__c.isUpdateable()  ){
                        contct.Gift_Id__c = gft_id ;
                    }
                //CREATE GIFT HISTORY RECORD *** 
             //   system.debug('gift_name++'+recId);
                if(Schema.sObjectType.Gift_History__c.fields.Sent_To__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Sent_To__c.isCreateable())
                    {
                        gh.Sent_To__c = contId;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Gift__c.isCreateable())
                    {
                        if(FinalSendGift_Class.validId(recId )){
                            gh.Gift__c = recId ;
                        }else{
                            gh.Gift__c = null;
                        }
                     }
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isCreateable())
                    {
                        gh.Gift_Id__c = giftId ;
                    }
                    if(Schema.sObjectType.Gift_History__c.fields.Quantity__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Quantity__c.isCreateable()){
                        gh.Quantity__c = Quantity ;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isCreateable())
                    {
                        gh.Sent_Date__c = system.today();
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isCreateable())
                    {
                        gh.Gift_Status_Id__c = gft_id;
                    }       
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isCreateable())
                    {
                        gh.Gift_Status__c = 'Created';
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isCreateable())
                    {
                        gh.Shipping_Status__c = 'Created';
                    }
                if(Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isCreateable())
                    {
                        gh.gift_Type__c = 'E-Gift';
                    } 

                if(Schema.sObjectType.Gift_History__c.fields.Price__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Price__c.isCreateable()){
                    gh.Price__c = giftIdVsgiftProduct != null && !giftIdVsgiftProduct.isEmpty() && giftIdVsgiftProduct.containsKey(giftId) ?  giftIdVsgiftProduct.get(giftId).Price__c : null;
                }


                

                //add dedicated url 
                if( dedicatedUrl != null && dedicatedUrl != ''
                 &&(Schema.sObjectType.Gift_History__c.fields.Corporate_gift__Dedicated_link__c.isAccessible() 
                 && Schema.sObjectType.Gift_History__c.fields.Corporate_gift__Dedicated_link__c.isCreateable())){
                    gh.Corporate_gift__Dedicated_link__c = dedicatedUrl;
                }
                if(recordIdVsEmail != null && !recordIdVsEmail.isEmpty() && recordIdVsEmail.containsKey(contId) && emailVsUrlMap != null && !emailVsUrlMap.isEmpty() && emailVsUrlMap.containsKey(recordIdVsEmail.get(contId))){
                    gh.Corporate_gift__Dedicated_link__c = emailVsUrlMap.get(recordIdVsEmail.get(contId));
                }

                giftHistoryList.add(gh);
                
                // UPDATE CONTACT RECORD***s

                if(Schema.sObjectType.Contact.fields.GiftOnTheWay__c.isAccessible()
                    && Schema.sObjectType.Contact.fields.GiftOnTheWay__c.isUpdateable() ) {
                        contct.GiftOnTheWay__c = true;
                   if(Schema.sObjectType.Contact.fields.Gift_Name__c.isAccessible()
                   && Schema.sObjectType.Contact.fields.Gift_Name__c.isUpdateable()) {
                        contct.Gift_Name__c = giftName ;
                 }
                if(Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isAccessible()
                && Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isUpdateable()) {
                contct.Last_Gift_Send__c = system.today();
                }
                conLstToUpdate.add(contct);
                // }
                // else if(Schema.sObjectType.Contact.fields.Gift_Name__c.isUpdateable()) {
                //   contct.Gift_Name__c = giftName ;
                //  if(Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isUpdateable()) {
                ///    contct.Last_Gift_Send__c = system.today();
                //}
                //    conLstToUpdate.add(contct);
                //}
                //else if(Schema.sObjectType.Contact.fields.Last_Gift_Send__c.isUpdateable()) {
                //  contct.Last_Gift_Send__c = system.today();
                //conLstToUpdate.add(contct);
                //}
                
                // CREATE A NEW TASK***
                Task taskObject = new Task();
                if(Schema.sObjectType.Task.fields.subject.isAccessible() 
                && Schema.sObjectType.Task.fields.subject.isCreateable())
                    {
                        taskObject.subject = 'Gift Intiated - ' + giftName ;
                    }
                if(Schema.sObjectType.Task.fields.WhoId.isAccessible() 
                && Schema.sObjectType.Task.fields.WhoId.isCreateable())
                    {
                        taskObject.WhoId = contId;
                    }
                if(Schema.sObjectType.Task.fields.ActivityDate.isAccessible() 
                && Schema.sObjectType.Task.fields.ActivityDate.isCreateable())
                    {
                        taskObject.ActivityDate = system.today();
                    }
             if(Schema.sObjectType.Task.fields.whatId.isAccessible()
                && Schema.sObjectType.Task.fields.whatId.isCreateable() ){
                        taskObject.whatId= contactIdVsAccountId != null && !contactIdVsAccountId .isEmpty() && contactIdVsAccountId.containsKey(contId) ?  contactIdVsAccountId.get(contId) : null;
                    }
                tList.add(taskObject);
            }
            
            if(!conLstToUpdate.isEmpty()
                 && (Schema.sObjectType.Contact.isAccessible()
                 && Schema.sObjectType.Contact.isUpdateable())){
             //   system.debug('Update contct**'+conLstToUpdate);
                update conLstToUpdate;
            }
            if(!tList.isEmpty() && 
            (Schema.sObjectType.Task.isAccessible() && Schema.sObjectType.Task.isCreateable())){
                //system.debug('Update Task**'+tList);
                insert tList;
            }
            if(!giftHistoryList.isEmpty() && 
            (Schema.sObjectType.Gift_History__c.isAccessible() 
            && Schema.sObjectType.Gift_History__c.isCreateable())){
                //system.debug('Update giftHistoryList**'+giftHistoryList);
                insert giftHistoryList;
            }
        }
    }   catch(Exception ex){
        //    system.debug('EXCEPTION => '+ex.getMessage() + '  Line'+ex.getLineNumber());
            FinalSendGift_Class.createExceptionRecord(ex.getMessage());
            
        } 
    }
    // contact e-gift ended
    
    
    // lead e-gift 
    /*
* Method Name     : sendMassEGiftCallout
* @Description    : This method is used to make single callout to send mass Egift.
*/
    public string sendMassEGiftCalloutLead(set<string> ContactIds , String giftId , String message ,string greeting ,string recipientName ,string giftName ,string giftType ,string recId ,string E_GiftName, Boolean reGift,String budgetSelected,Integer Quantity){
        
        try{
            list<GiftingSetup__c> merchantList = new list<GiftingSetup__c>();
            merchantList = [Select Id,Merchant_Id__c ,Security_Header__c From GiftingSetup__c  WITH SECURITY_ENFORCED limit 1];
            Map<String, Object> JsonBody = new Map<String,Object>();
            String greetMessage ='';
            JsonBody.put('merchant_id',merchantList[0].Merchant_Id__c);
            if(giftId != null){
                JsonBody.put('gift_id',giftId);  
            }
            if(greeting != null){
                greetMessage =greetMessage + greeting ; 
            }

            Integer can_create_dedicated_links = null;
            if( dedicatedLink ){
                can_create_dedicated_links = 1;
            }
            if(budgetSelected != null){
                JsonBody.put('budget_id',budgetSelected);
            }
            if(giftType=='E_gift'){
                JsonBody.put('egift_name',E_GiftName); 
                
                if( can_create_dedicated_links != null ){
                    JsonBody.put('can_create_dedicated_links',can_create_dedicated_links);
                }

                if( video_url != null && video_url.trim() != ''){
                    JsonBody.put('video_url',video_url);
                }

                if( emailSubject != null && emailSubject.trim() != ''){
                    JsonBody.put('subject',emailSubject);
                }

            }
            
            List<FinalSendGift_Class.wrapContact> recipientsList = new List<FinalSendGift_Class.wrapContact>();
            Map<String,String> recipientsMap = new Map<String,String>();
            map<String, String> recordIdVsEmail = new map <String,String>();

            for(Lead cont : [Select id, email,Phone,Last_Gift_Send__c,Gift_Name__c, firstName,lastName,Name,Street,City,State,PostalCode,Country from Lead where Id IN :ContactIds WITH SECURITY_ENFORCED]){
                FinalSendGift_Class.wrapContact cont_Recd = new FinalSendGift_Class.wrapContact();
                cont_Recd.firstname =cont.FirstName;
                cont_Recd.email =cont.email;
                cont_Recd.lastname =cont.lastname;
                recipientsList.add(cont_Recd); 
                recordIdVsEmail.put(cont.id, cont.email);
            }
            
            if(recipientName !=null && recipientName !='' && recipientName.contains('Include Just Recipient First Name')){
                greetMessage = greetMessage +' '+'<First Name>'  ; 
                
            }else if(recipientName !=null && recipientName !='' && recipientName.contains('Include Just Recipient Last Name')){
                greetMessage = greetMessage +' '+'<Last Name>' ; 
                
            }else if(recipientName !=null && recipientName !='' && recipientName.contains('Include Both First and Last Name (Recommended)')){
                greetMessage = greetMessage +' '+'<First Name> <Last Name>' ; 
                
            }
            
            if(message !=null && ( can_create_dedicated_links == null || can_create_dedicated_links == 0)){
                greetMessage = greetMessage +'\n\n'+message; 
            }
            if(greetMessage !=null){
                JsonBody.put('message',greetMessage);  
            } 
            JsonBody.put('recipients',recipientsList);
            JsonBody.put('user',UserInfo.getUserEmail());
            JsonBody.put('upgrade_regift' , reGift);
            if(Quantity !=null){
                JsonBody.put('qty',Quantity);  
            }
            string body = JSON.serialize(JsonBody) ;
         //   system.debug('Body**'+body);
            String requestInput = body + '' + merchantList[0].Security_Header__c ;
            Blob requestBlob = Blob.valueOf(requestInput);
            Blob hash = Crypto.generateDigest('MD5', requestBlob);
            String SecurityHeader = EncodingUtil.convertToHex(hash);
       
        //    system.debug('#### BODY MAP '+JsonBody);
        //    system.debug('#### JSON BODY'+JSON.serialize(JsonBody));
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
            map<string,object> responseBody3 = new map<string,object>();
            if(resp2.getStatusCode()==200){

                responseBody3 =(Map<string,Object>)JSON.deserializeUntyped(resp2.getBody());
            //    system.debug('responseBody3**'+responseBody3);
                string rest2 = (string.valueOf(responseBody3.get('success')));
            //    system.debug('rest2**'+rest2);
                if(!responseBody3.isEmpty() && responseBody3.containsKey('success') && rest2=='true'){
                    
                    String dedicatedUrl = null;
                    if( responseBody3.containskey('url') && responseBody3.get('url') != null  ){
                        dedicatedUrl = String.valueof(responseBody3.get('url'));
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
                        //    system.debug('SUCCESS responseBody CSV**'+responseInnerCsv.getBody());
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

                    createRecordsAfterEGiftLeadCallout(String.valueOf(responseBody3.get('order_id')) ,giftId,recId, giftName, ContactIds, dedicatedUrl,recordIdVsEmail, emailVsUrlMap,Quantity); 
                    
                    Map<String,String> msgMap = new Map<String,String>();
                    msgMap.put('success', 'true');
                    msgMap.put('message', 'Gift send successfully!');
                    msgMap.put('Url', dedicatedUrl);
                    return JSON.serialize(msgMap);

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
              //  system.debug('#### ERROR '+JSON.serialize(msgMap));
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
    public void createRecordsAfterEGiftLeadCallout(string gft_id,string giftId,string recId,string giftName, set<String> ContactIds,
                    String dedicatedUrl, map<String, String> recordIdVsEmail, map<String, String> emailVsUrlMap,Integer Quantity){
        
        List<Task> tList = new List<Task>();
        List<Gift_History__c> giftHistoryList = new List<Gift_History__c>();
        list<Lead> conLstToUpdate = new List<Lead>();
        Boolean check = false;

        map<String,String > recordIdMap = new map<String,String >();
        for(RecordType type : [select id, developerName from RecordType where SobjectType='Corporate_gift__Gift_History__c' WITH SECURITY_ENFORCED]){
            recordIdMap.put( type.developerName.tolowercase(), type.Id);
        }

        map<String,Lead > contactIdVsContactObject = new map<String,Lead >();
        for(Lead con : [Select id from Lead where id in : ContactIds WITH SECURITY_ENFORCED ]){
            contactIdVsContactObject.put(con.id,con);
        }
        
        
     //   system.debug('gft_id**'+gft_id);
     //   system.debug('conId List**'+ContactIds);
        string status = '';
        try{
            for(String contId : ContactIds){
                Lead contct = new Lead();
                if(Schema.sObjectType.Lead.fields.Id.isAccessible()) 
              {if(contactIdVsContactObject != null && !contactIdVsContactObject.isEmpty() && contactIdVsContactObject.containsKey(contId)){
                        contct =contactIdVsContactObject.get(contId);    
                //contct.id =contId;
              }    }               
                Gift_History__c gh = new Gift_History__c();
                
               if( recordIdMap != null && !recordIdMap.isEmpty() 
                && recordIdMap.containsKey('e_gift')){
                if(Schema.sObjectType.Gift_History__c.fields.recordTypeId.isAccessible()){        
                    if(Schema.sObjectType.Gift_History__c.fields.recordTypeId.isCreateable()){
                    gh.recordTypeId = recordIdMap.get( 'e_gift');
                    }
                }
                }
                
                   if(Schema.sObjectType.Lead.fields.Gift_Id__c.isAccessible() 
                        && Schema.sObjectType.Lead.fields.Gift_Id__c.isUpdateable()){
                        contct.Gift_Id__c = gft_id ;
                    }
                //CREATE GIFT HISTORY RECORD ***
                //system.debug('gift_name++'+recId);
                if(Schema.sObjectType.Gift_History__c.fields.Lead__c.isAccessible() 
                    && Schema.sObjectType.Gift_History__c.fields.Lead__c.isCreateable())
                    {
                        gh.Lead__c = contId;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Gift__c.isCreateable())
                        {
                            if(FinalSendGift_Class.validId(recId )){
                                gh.Gift__c = recId ;
                            }else{
                                gh.Gift__c = null;
                            }
                        }
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Gift_Id__c.isCreateable())
                    {
                        gh.Gift_Id__c = giftId ;
                    }
                    if(Schema.sObjectType.Gift_History__c.fields.Quantity__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Quantity__c.isCreateable()){
                        gh.Quantity__c = Quantity ;
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Sent_Date__c.isCreateable())
                    {
                        gh.Sent_Date__c = system.today();
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isAccessible() 
                    && Schema.sObjectType.Gift_History__c.fields.Gift_Status_Id__c.isCreateable())
                    {
                        gh.Gift_Status_Id__c = gft_id; 
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isAccessible() 
                    && Schema.sObjectType.Gift_History__c.fields.Gift_Status__c.isCreateable())
                    {
                        gh.Gift_Status__c = 'Created';
                    }
                if(Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isAccessible() 
                    && Schema.sObjectType.Gift_History__c.fields.Shipping_Status__c.isCreateable())
                    {
                        gh.Shipping_Status__c = 'Created';
                    }
                
                if(Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.gift_Type__c.isCreateable())
                    {
                        gh.gift_Type__c = 'E-Gift';
                    }
                
                if(Schema.sObjectType.Gift_History__c.fields.Price__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Price__c.isCreateable()){
                    gh.Price__c = giftIdVsgiftProduct != null && !giftIdVsgiftProduct.isEmpty() && giftIdVsgiftProduct.containsKey(giftId) ?  giftIdVsgiftProduct.get(giftId).Price__c : null;
                 }
                 

               
 

                //add dedicated url 
                if( dedicatedUrl != null && dedicatedUrl != ''
                    &&(Schema.sObjectType.Gift_History__c.fields.Corporate_gift__Dedicated_link__c.isAccessible()
                    && Schema.sObjectType.Gift_History__c.fields.Corporate_gift__Dedicated_link__c.isCreateable()))
                    {
                        gh.Corporate_gift__Dedicated_link__c = dedicatedUrl;
                    }
                if(recordIdVsEmail != null && !recordIdVsEmail.isEmpty() && recordIdVsEmail.containsKey(contId) && emailVsUrlMap != null && !emailVsUrlMap.isEmpty() && emailVsUrlMap.containsKey(recordIdVsEmail.get(contId))){
                    gh.Corporate_gift__Dedicated_link__c = emailVsUrlMap.get(recordIdVsEmail.get(contId));
                }

                giftHistoryList.add(gh);
                
                // UPDATE CONTACT RECORD***s

                    if(Schema.sObjectType.Lead.fields.Gift_On_The_Way__c.isAccessible()
                     && Schema.sObjectType.Lead.fields.Gift_On_The_Way__c.isUpdateable() ) {
                        contct.Gift_On_The_Way__c = true;
                    if(Schema.sObjectType.Lead.fields.Gift_Name__c.isAccessible()
                     && Schema.sObjectType.Lead.fields.Gift_Name__c.isUpdateable()) {
                        contct.Gift_Name__c = giftName ;
                    }
                    if(Schema.sObjectType.Lead.fields.Last_Gift_Send__c.isAccessible()
                        && Schema.sObjectType.Lead.fields.Last_Gift_Send__c.isUpdateable()) {
                            contct.Last_Gift_Send__c = system.today();
                    }
                    conLstToUpdate.add(contct);
                // }
                //  else if(Schema.sObjectType.Lead.fields.Gift_Name__c.isUpdateable()) {
                //  contct.Gift_Name__c = giftName ;
                //    if(Schema.sObjectType.Lead.fields.Last_Gift_Send__c.isUpdateable()) {
                //       contct.Last_Gift_Send__c = system.today();
                // }
                // conLstToUpdate.add(contct);
                // }
                // else if(Schema.sObjectType.Lead.fields.Last_Gift_Send__c.isUpdateable()) {
                //   contct.Last_Gift_Send__c = system.today();
                // conLstToUpdate.add(contct);
                //}
                
                // CREATE A NEW TASK***
                Task taskObject = new Task();
                if(Schema.sObjectType.Task.fields.subject.isAccessible() 
                    && Schema.sObjectType.Task.fields.subject.isCreateable())
                    {
                        taskObject.subject = 'Gift Intiated - ' + giftName ;
                    }
                if(Schema.sObjectType.Task.fields.WhoId.isAccessible() 
                     && Schema.sObjectType.Task.fields.WhoId.isCreateable())
                    {
                        taskObject.WhoId = contId;
                    }
                if(Schema.sObjectType.Task.fields.ActivityDate.isAccessible() 
                    && Schema.sObjectType.Task.fields.ActivityDate.isCreateable())
                    {
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
            if(!tList.isEmpty() && (Schema.sObjectType.Task.isAccessible() 
                && Schema.sObjectType.Task.isCreateable())){
                //system.debug('Update Task**'+tList);
                insert tList;
            }
            if(!giftHistoryList.isEmpty() && (Schema.sObjectType.Gift_History__c.isAccessible() 
                && Schema.sObjectType.Gift_History__c.isCreateable())){
                //system.debug('Update giftHistoryList**'+giftHistoryList);
                insert giftHistoryList;
            }
        }
    }   catch(Exception ex){
         //   system.debug('EXCEPTION => '+ex.getMessage() + '  Line'+ex.getLineNumber());
            
            FinalSendGift_Class.createExceptionRecord(ex.getMessage());
            
            
        } 
    }
}