@isTest
public class RefreshMerchantProductsBatch_Mock implements HttpCalloutMock {
  public HTTPResponse respond(HTTPRequest req) { 
        string JSONBody='{"success": true,"products": [{"id": "5882","name": "Secure funding gift","image": "https://staging.corporategift.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/s/c/screen_shot_2017-01-12_at_10.09.41_am.png"}]}';
        HttpResponse resp = new HttpResponse();
        resp.setBody(JSONBody);
        resp.setHeader('Content-Type', 'application/json');
        resp.setStatusCode(200);
        return resp;
    }
}