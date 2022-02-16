trigger GetAvailableGift on GiftMerchant__c (after insert) {
    
    if(trigger.isAfter && trigger.isInsert){
        GetAvailableGiftController.getGifts(trigger.newMap.keySet());   
    }
    
}