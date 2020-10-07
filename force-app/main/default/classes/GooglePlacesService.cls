public inherited sharing class GooglePlacesService {
    @testVisible
    private static GooglePlacesService instance;

    public static GooglePlacesService getInstance() {
        if (instance == null) {
            instance = new GooglePlacesService();
        }
        return instance;
    }

    public GooglePlacesResponse placeSearch(String input) {
        Pagereference pageref = new Pagereference('https://maps.googleapis.com/maps/api/place/findplacefromtext/json');
        pageref.getParameters().put('input', input);
        pageref.getParameters().put('inputtype', 'textquery');
        pageref.getParameters().put('fields', 'formatted_address');
        pageref.getParameters().put('key', GooglePlacesAPI__c.getOrgDefaults().Key__c);

        System.debug('request uri: ' + pageref.getUrl());
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('GET');
        req.setEndpoint(pageref.getUrl());
        res = new Http().send(req);
        return (GooglePlacesResponse) JSON.deserialize(res.getBody(), GooglePlacesResponse.class);
    }

    public class GooglePlacesResponse {
        public String status;
        public List<Candidates> candidates;
    }

    public class Candidates {
        public String formatted_address;
    }
}
