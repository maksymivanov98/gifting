trigger CreateTaskOnStatusChange on Gift_History__c (after update) {
    
    list<Task> taskList = new list<Task>();
    list<GiftingSetup__c> giftMerchant = new list<GiftingSetup__c>([Select Id , Create_task_on_status_change__c From GiftingSetup__c limit 1]);
    if(trigger.isUpdate && trigger.isAfter){
        
        try{
            for(Gift_History__c gh: [Select id ,Gift_Status__c ,Gift_Status_Id__c,Sent_To__c,Lead__c,Account__c,Gift__c,Gift__r.Name , ownerId FROM Gift_History__c Where Id IN : trigger.new]){
                
                Gift_History__c oldgh = trigger.oldMap.get(gh.Id);
                 system.debug('oldgh** '+oldgh.Gift_Status__c);
                 system.debug('NewMap** '+gh.Gift_Status__c); 
                
                if(gh.Gift_Status_Id__c !=null && giftMerchant !=null && !giftMerchant.isEmpty() && giftMerchant[0].Create_task_on_status_change__c && 
                   oldgh !=null && oldgh.Gift_Status__c != gh.Gift_Status__c){
                      
                       system.debug('^^^** ');
                       Task taskObject = new Task();
                       
                       taskObject.ownerId = gh.ownerId;
                       if(Schema.sObjectType.Task.fields.subject.isCreateable()){
                           taskObject.subject = 'Gift ' + gh.Gift_Status__c + ' - ' +gh.Gift__r.Name;
                       } 
                       if(Schema.sObjectType.Task.fields.ActivityDate.isCreateable()){ 
                           taskObject.ActivityDate = system.today();
                       }
                       
                       if(Schema.sObjectType.Task.fields.Description.isCreateable()){ 
                           taskObject.Description = gh.Gift_Status__c;
                       }
                       
                       if(gh.Sent_To__c !=null && Schema.sObjectType.Task.fields.WhoId.isCreateable()){
                           taskObject.WhoId = gh.Sent_To__c;
                           
                       }else if(gh.Lead__c !=null && Schema.sObjectType.Task.fields.WhoId.isCreateable()){
                           taskObject.WhoId = gh.Lead__c;
                       }else if(gh.Account__c !=null && Schema.sObjectType.Task.fields.WhoId.isCreateable()){
                           taskObject.WhatId = gh.Account__c;
                       }                
                       
                       taskList.add(taskObject);
                   }
            }
            
            system.debug('taskList** '+taskList);
            if(taskList !=null && !taskList.isEmpty()){
                //test
                insert taskList ;
            }
            
        }catch(exception ex){
            system.debug('Message** '+ex.getMessage() + '  Line*** '+ ex.getLineNumber());
            
        }
    }
    
    
}