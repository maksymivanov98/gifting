public with sharing class MassGiftSendWithNoPhysicalAddressContr {
	 
	 public list<WrapperClass> wrappedSobject {get;set;}
	 public set<String> ConList {get;set;}
	 public integer rowNum {get;set;}
	 public integer rowNum1 {get;set;}
	 private ApexPages.StandardSetController standardController;
	 public string FilterId {get;set;}
	
	 public MassGiftSendWithNoPhysicalAddressContr(ApexPages.StandardSetController standardController){
	 	this.standardController = standardController;
        FilterId = standardController.getFilterId();
        wrappedSobject = new list<WrapperClass>();
        ConList = new set<String>();
        for (Contact mem : (List<Contact>)standardController.getSelected()){ 
            ConList.add(mem.Id);
        }
        
        for(contact mem :[select id,FirstName,lastName,Last_Gift_Send__c,Email,Name,MailingCity,MailingState,MailingCountry,MailingStreet,MailingPostalCode FROM Contact where Id IN : ConList WITH SECURITY_ENFORCED]){
        	if(mem.MailingCity ==null || mem.MailingCity =='' || mem.MailingState ==null || mem.MailingState =='' || mem.MailingCountry ==null || mem.MailingCountry ==''
               || mem.MailingStreet ==null || mem.MailingStreet =='' || mem.MailingPostalCode ==null || mem.MailingPostalCode =='' && (mem.Email != null || mem.Email != '') ){
        	     wrappedSobject.add(new WrapperClass(mem,true ,false,'No Address','E_Gift'));
             }else if(mem.MailingCity !=null &&  mem.MailingCity !='' && mem.MailingState !=null && mem.MailingState !='' && mem.MailingCountry !=null && mem.MailingCountry !=''
               && mem.MailingStreet !=null && mem.MailingStreet !='' &&  mem.MailingPostalCode !=null && mem.MailingPostalCode !='' && (mem.Email == null || mem.Email == '') ){
             	wrappedSobject.add(new WrapperClass(mem,false,true ,'No Email','P_Gift'));
             }else if(mem.MailingCity !=null &&  mem.MailingCity !='' && mem.MailingState !=null && mem.MailingState !='' && mem.MailingCountry !=null && mem.MailingCountry !=''
               && mem.MailingStreet !=null && mem.MailingStreet !='' &&  mem.MailingPostalCode !=null && mem.MailingPostalCode !='' && mem.Email != null && mem.Email != '') {
             	wrappedSobject.add(new WrapperClass(mem,false,false ,'OK','P_Gift' ));
             }if(mem.MailingCity ==null || mem.MailingCity =='' || mem.MailingState ==null || mem.MailingState =='' || mem.MailingCountry ==null || mem.MailingCountry ==''
               || mem.MailingStreet ==null || mem.MailingStreet =='' || mem.MailingPostalCode ==null || mem.MailingPostalCode =='' || mem.Email != null || mem.Email != ''){
        	     wrappedSobject.add(new WrapperClass(mem,false ,false,'Not Valid','P_Gift'));
             }
        }
        
	 	
	 }
	 
	 public void deSelecMethod(){
	 //	system.debug('rowNum***'+rowNum);
	 	if(rowNum !=null && wrappedSobject[rowNum].SendEgift){
	 		wrappedSobject[rowNum].skip = false ;
	 	}else if(rowNum !=null && !wrappedSobject[rowNum].SendEgift){
	 		wrappedSobject[rowNum].skip = true ;
	 	}
	 	
	 	
	 }
	  public void deSelecMethod2(){
	 //	system.debug('rowNum***'+rowNum);
	 	if(rowNum !=null && wrappedSobject[rowNum].SendPgift){
	 		wrappedSobject[rowNum].skip = false ;
	 	}else if(rowNum !=null && !wrappedSobject[rowNum].SendPgift){
	 		wrappedSobject[rowNum].skip = true ;
	 	}
	 }
	 
	 public void deSelecMethod1(){
	 //	system.debug('rowNum1***'+rowNum1);
	 	
	 	if(rowNum1 !=null && wrappedSobject[rowNum1].skip){
	 		wrappedSobject[rowNum1].SendEgift = false ;
	 	}else if(rowNum1 !=null && !wrappedSobject[rowNum1].skip){
	 		wrappedSobject[rowNum1].SendEgift = true ;
	 	}
	 }
	 
	 public PageReference onNext(){
	 	set<string> selectedRecords_E = new set<string>();
	 	set<string> selectedRecords_P = new set<string>();
	 	for(WrapperClass ws : wrappedSobject){ 
	 		if(ws.SendEgift ){
	 		  selectedRecords_E.add(ws.obj.Id);
	 		}
	 		if(ws.SendPgift ){
	 		  selectedRecords_P.add(ws.obj.Id);
	 		}
	 		if(ws.ShipStatus == 'OK' ){
	 		  selectedRecords_P.add(ws.obj.Id);
	 		}
	 	}
	 	
	 //	system.debug('selectedRecords_E**'+selectedRecords_E);
	 	String SelectedRec_E ;
	 	String SelectedRec_P ;
	 	if(!selectedRecords_E.isEmpty()){
	 		SelectedRec_E = JSON.serialize(selectedRecords_E);
	 	}
	 	if(!selectedRecords_P.isEmpty()){
	 		SelectedRec_P = JSON.serialize(selectedRecords_P);
	 	}
	 	 
	 	 
	 	String Url = '/apex/MassGiftSendPage?SetId_E='+SelectedRec_E +'&SetId_P='+SelectedRec_P;
	 	PageReference pageRef = new PageReference(Url);
	 	pageRef.setRedirect(true);
        return pageRef;
	 }
	
	public class WrapperClass {
    public contact obj { get; set; }
    public Boolean SendEgift { get; set; }
    public Boolean SendPgift { get; set; }
    public Boolean skip { get; set; }
    public string ShipStatus {get;set;}
    public string giftType {get;set;}
    public WrapperClass(contact con ,boolean SendEgift ,boolean SendPgift ,string ShipStatus ,string giftType) {
        this.obj = con;
        this.SendEgift = SendEgift;
        this.SendPgift = SendPgift ;
        this.skip = false ;
        this.ShipStatus = ShipStatus ;
        this.giftType = giftType;
    }
}
    
}