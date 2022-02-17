public class GiftSendController {
    
    public PageReference sendGiftMethod() {
        
        
        string recId = ApexPages.currentPage().getParameters().get('id');
        string giftType = ApexPages.currentPage().getParameters().get('giftType'); 
        String theme = UserInfo.getUiThemeDisplayed();
        string url = '/apex/Corporate_gift__';
        if(recId !=null && theme !=null && theme =='Theme4d' && giftType=='E_Gift'){
            url = url + 'GiftSendFromContactPage?giftType='+giftType +'&id='+recId ;
        } 
        if(recId !=null && theme !=null && theme =='Theme3' && giftType=='E_Gift'){
            //url = url + 'GiftSendFromContactPageClassic?giftType='+giftType +'&id='+recId ;
            url = url + 'GiftSendFromContactPage?giftType='+giftType +'&id='+recId ;
        }
        if(recId !=null && theme !=null && theme =='Theme4d' && giftType=='P_Gift'){
            url = url + 'P_GiftSendFromDetailPage?giftType='+giftType +'&id='+recId ;
        }
        if(recId !=null && theme !=null && theme =='Theme3' && giftType=='P_Gift'){
            url = url + 'P_GiftSendFromDetailPage?giftType='+giftType +'&id='+recId ;
            //url = url + 'P_GiftSendFromDetailPageClassic?giftType='+giftType +'&id='+recId ;
        }
        PageReference pageRef = new PageReference('/'+url);
        pageRef.setRedirect(true);
        return pageRef; 
    }
}