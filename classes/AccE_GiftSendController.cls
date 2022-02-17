/*-************************************************************************************************************
* Name         : AccE_GiftSendController
* @Author      : 
* @Date        : 
* @Description : The AccE_GiftSendController controller is used for Sending E-gifts to selected Account.
* UPDATES
* Version          Developer                    Date                        Description
*-------------------------------------------------------------------------------------------
*     1.0          Bhagwan Chuphal             12 Nov 2019                 Initial Creation 
***************************************************************************************************************/
public with sharing class  AccE_GiftSendController {
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
    public string E_GiftName{get;set;}
    public boolean Daysflag {get;set;}
    public string contactsWithoutAddress ;
    public string contactsWithGiftSend ;
    public map<string,string> giftIdVsNameMap = new map<string,string>();
    public map<string,string> giftVsIdMap = new map<string,string>();
    public list<Corporate_gift__GiftingSetup__c> giftSetup = new list<GiftingSetup__c>([Select Id ,Corporate_gift__Create_task_on_status_change__c ,Corporate_gift__Enable_gift_frequency__c ,Corporate_gift__Merchant_Id__c  ,Corporate_gift__Status_Merchant_Id__c From Corporate_gift__GiftingSetup__c WITH SECURITY_ENFORCED Limit 1]);
    private ApexPages.StandardSetController standardController;
    
    public AccE_GiftSendController(ApexPages.StandardSetController standardController){
        this.standardController = standardController;
        FilterId = standardController.getFilterId();
        Daysflag = true ;
        contactsWithGiftSend = '';
        giftList = new List<SelectOption>();
        greetingList = new List<SelectOption>();
        recipientList = new List<SelectOption>();
        greetSelected = '';
        recipientSelected= '';
        User usr = [Select id,name,Gift__c,Recipient_Name__c,Salutation__c from User where id=:userinfo.getuserid() WITH SECURITY_ENFORCED];
        E_GiftName = usr.name ;
      //  greetingList.add(new SelectOption('','None'));
        ConList2 = new list<String>();
        if(usr.Gift__c !=null && usr.Gift__c != ''){
            for(products__c productObject : [SELECT id__c , name FROM products__c Where isActive__c = true and name =: usr.Gift__c WITH SECURITY_ENFORCED limit 1]){
                giftList.add(new SelectOption(productObject.id__c , productObject.name));
                giftIdVsNameMap.put(productObject.id__c , productObject.name);
                giftVsIdMap.put(productObject.id__c , productObject.Id);
            }
        }
        for(products__c productObject : [SELECT id__c , name FROM products__c Where isActive__c = true and name !=: usr.Gift__c WITH SECURITY_ENFORCED limit 10000]){
            giftList.add(new SelectOption(productObject.id__c , productObject.name));
            giftIdVsNameMap.put(productObject.id__c , productObject.name);
            giftVsIdMap.put(productObject.id__c , productObject.Id);
            
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
        
        for (Account mem : [select id,Last_Gift_Send__c,Name,BillingCity,BillingState,BillingCountry,BillingStreet,BillingPostalCode FROM Account Where Id IN :ConList WITH SECURITY_ENFORCED]){ 
            if(!giftSetup.isEmpty() && giftSetup[0].Corporate_gift__Enable_gift_frequency__c && mem.Last_Gift_Send__c !=null && mem.Last_Gift_Send__c.daysBetween(system.today()) < Integer.ValueOf(System.label.SendAnotherGiftIn_N_days )){
                Daysflag = false; 
                contactsWithGiftSend += '<br/>';
                contactsWithGiftSend +=  Mem.Name ; 
            }
        }
        
        
        if(!Daysflag){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,' <b>  Gift cannot be sent twice in less than 30 days for the following Account </b>' + contactsWithGiftSend ));
        }
        
        ConList2.addAll(ConList);
        conIds = JSON.serialize(ConList);
        
    }
    
    /*
    * Method Name     : sendGift
    * @Description    : This method is used to invoking batch class.
    */
    public void sendGift(){
        //system.debug('AccountList**'+ConList);
        if(E_GiftName == null || E_GiftName == ''){
            E_GiftName = [Select id,name from User where id=:userinfo.getuserid() WITH SECURITY_ENFORCED limit 1].name ;
        }
        AccMassGiftSendBatchClass obj = new AccMassGiftSendBatchClass(ConList , giftSelected , messageGreeting ,greetSelected,recipientSelected ,giftIdVsNameMap.get(giftSelected),'E_gift,'+E_GiftName,giftVsIdMap.get(giftSelected) ,E_GiftName );
        Database.executeBatch(obj,1);
    }
}