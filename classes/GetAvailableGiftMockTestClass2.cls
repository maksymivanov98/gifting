@IsTest
public class GetAvailableGiftMockTestClass2 Implements HttpCalloutMock {
    
    public static HTTPResponse respond(HTTPRequest req){
        
        String jsonstring = '{ "success": true, "email": "kalra.p@head-in-cloud.com", "products": [{ "id": "12981", "name": "Closing", "image": "", "description": null, "price": 30, "associated_ids": [12993, 10582, 11390, 12992] }] }';
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        res.setHeader('Contant/type', 'application/json');
        res.setBody(jsonstring);
        res.setStatusCode(300);
        return res;
        
    }
}