@isTest
private class GooglePlacesServiceTest {

    @isTest
    static void placeSearch() {
        Test.setMock(HttpCalloutMock.class, new GooglePlacesResponseMock());

        GooglePlacesService.RetrievedGooglePlace response = GooglePlacesService.getInstance().placeSearch('The best beer in town');
        System.assertEquals('OK', response.status);
        System.assertEquals('Twijnstraat 47', response.street);
        System.assertEquals('3511ZH', response.postalCode);
        System.assertEquals('Utrecht', response.city);
        System.assertEquals('Netherlands', response.country);
    }

    public class GooglePlacesResponseMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            Map<String, Object> response = new Map<String, Object>{
                'status' => 'OK',
                'candidates' => new List<Object>{new Map<String, Object>{
                    'formatted_address' => 'Twijnstraat 47, 3511 ZH Utrecht, Netherlands'
                }}
            };
            res.setBody(JSON.serialize(response));
            return res;
        }
    }
}