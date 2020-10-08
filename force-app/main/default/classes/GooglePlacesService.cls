public inherited sharing class GooglePlacesService {
    @testVisible
    private static GooglePlacesService instance;

    public static GooglePlacesService getInstance() {
        if (instance == null) {
            instance = new GooglePlacesService();
        }
        return instance;
    }

    public RetrievedGooglePlace placeSearch(String input) {
        Pagereference pageref = new Pagereference('https://maps.googleapis.com/maps/api/place/findplacefromtext/json');
        pageref.getParameters().put('input', input);
        pageref.getParameters().put('inputtype', 'textquery');
        pageref.getParameters().put('fields', 'formatted_address');
        pageref.getParameters().put('key', GooglePlacesAPI__c.getOrgDefaults().Key__c);

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('GET');
        req.setEndpoint(pageref.getUrl());
        res = new Http().send(req);
        GooglePlacesResponse googlePlacesResponse = (GooglePlacesResponse) JSON.deserialize(
            res.getBody(),
            GooglePlacesResponse.class
        );

        RetrievedGooglePlace ret = new RetrievedGooglePlace();
        ret.status = googlePlacesResponse.status;
        if (
            googlePlacesResponse.status == 'OK' &&
            !googlePlacesResponse.candidates.isEmpty() &&
            String.isNotEmpty(googlePlacesResponse.candidates[0].formatted_address)
        ) {
            ret = new RetrievedGooglePlace(googlePlacesResponse);
        }
        return ret;
    }

    public class GooglePlacesResponse {
        public String status;
        public List<Candidates> candidates;
    }

    public class Candidates {
        public String formatted_address;
    }

    public class RetrievedGooglePlace {
        public String status;
        public String street;
        public String postalCode;
        public String city;
        public String country;

        public RetrievedGooglePlace() { }
        public RetrievedGooglePlace(GooglePlacesResponse googleplacesResponse) {
            this.status = googleplacesResponse.status;
            String formattedAddress = googlePlacesResponse.candidates[0].formatted_address;
            // example: Twijnstraat 3, 3511 ZG Utrecht, Netherlands
            List<String> addressfields = formattedAddress.split(',');
            this.street = addressfields[0];
            this.postalCode = addressfields[1].left(8).deleteWhitespace();
            this.city = addressfields[1].substring(8, addressfields[1].length()).trim();
            this.country = addressfields[2].trim();
        }
    }
}
