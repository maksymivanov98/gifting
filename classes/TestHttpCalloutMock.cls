@IsTest
public class TestHttpCalloutMock Implements HttpCalloutMock {

    public Static HTTPResponse respond(HTTPRequest req){
         
        String jsonstring = '{"success":true,"products":[{"id":"9723","name":" 12 Pc. Chocolate Ba (21 more)","image":"https://corporategif"}]}';
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        res.setHeader('Contant/type', 'application/json');
        res.setBody(jsonstring);
        res.setStatusCode(200);
        return res;
        
    }
}