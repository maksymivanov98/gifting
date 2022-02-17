@IsTest
public class TestHttpCalloutMock2_2 Implements HttpCalloutMock {

    public static HTTPResponse respond(HTTPRequest req){
         
        String jsonstring = '{ "success": true, "orders": [ { "increment_id": "100031005", "delivery_date": "2020-06-15 15:22:11" }, { "increment_id": "100031006", "delivery_date": "2020-06-15 15:22:11" } ] }';
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        res.setHeader('Contant/type', 'application/json');
        res.setBody(jsonstring);
        res.setStatusCode(300);
        return res;
        
    }
}