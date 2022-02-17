@IsTest
public class TestHttpCalloutMock2_3 Implements HttpCalloutMock {

    public static HTTPResponse respond(HTTPRequest req){
         
        String jsonstring = '{ "message": true,"products":[{"id":"123","name":"test","description":"123", "price":"123","image":"demo"}], "orders": [ { "increment_id": "100031005", "delivery_date": "2020-06-15 15:22:11" }, { "increment_id": "100031006", "delivery_date": "2020-06-15 15:22:11" } ] }';
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        res.setHeader('Contant/type', 'application/json');
        res.setBody(jsonstring);
        res.setStatusCode(200);
        return res;
        
    }
}