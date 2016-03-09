public with sharing class ToursRESTApi {
    private final string tokenURL = 'https://backend.universal-limo.com/api/v2/oauth/token';
    private final string toursURL = 'https://backend.universal-limo.com/api/v2/tours';

    public ToursDTO toursResult { get; set; }
    public ErrorDTO errorResult { get; set; }
    private access_token__c accessToken { get; set; }

    public class TokenDTO {
    	public String access_token { get; set; }
    	public String token_type { get; set; }
    	public Integer expires_in { get; set; }
    }

    public class TourDTO {
    	public String accountID { get; set; }
    	public String bookingNr { get; set; }
    	public String timeLocale { get; set; }
    	public String driverID { get; set; }
    	public String destination { get; set; }    
    }

    public class ToursDTO {
    	public List<TourDTO> tours { get; set; }
    }

    public class ErrorDTO {
    	public String error { get; set; }
    	public String errorMessage { get; set; }
    }

    public void checkToken() {
    }

    public TokenDTO getToken() {
    	return null;
	}

	public void getTours(string accountID) {
		checkToken();
		//
		updateToken();
	}

	public void updateToken() {

	}

	public ToursRESTApi() {
		
	}
}