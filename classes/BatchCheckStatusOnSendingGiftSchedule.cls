global with sharing class BatchCheckStatusOnSendingGiftSchedule implements Schedulable {
	
	global void execute(SchedulableContext SC) {
       BatchCheckStatusOnSendingGift obj = new BatchCheckStatusOnSendingGift();  
       BatchFetchAvailableGifts obj2 = new BatchFetchAvailableGifts() ;
        database.executebatch(obj,1);
        database.executebatch(obj2,1); 
   } 
    
}