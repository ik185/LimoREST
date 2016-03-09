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
    	access_token__c	AC = access_token__c.getInstance('ToursRESTApi');
    	if( AC == null || (Datetime.now() >= AC.created_at__c.addSeconds(Integer.valueof(AC.expires_in__c*1000)))) {
    		TokenDTO tdto = new TokenDTO();
    		tdto = getToken();
    		if(tdto != null) {
    			AC = new access_token__c();
				AC.Name = 'ToursRESTApi';
				AC.access_token__c = tdto.access_token;
				AC.token_type__c = tdto.token_type;
				AC.expires_in__c = tdto.expires_in;
				AC.created_at__c = Datetime.now();
				accessToken = AC;
    		}
    	}
    	else {
			accessToken = AC;
    	}    	
    }

    public TokenDTO getToken() {
    	errorResult = null;
    	HttpRequest req = new HttpRequest();
    	req.setEndpoint(tokenURL);
    	req.setMethod('POST');
    	Http http = new Http();
    	try {
    		HTTPResponse res = http.send(req);
        	TokenDTO result = (TokenDTO)JSON.deserialize(res.getBody(), TokenDTO.class);
        	return result;
    	} catch(Exception e) {
			errorResult = new ErrorDTO();
			errorResult.error = 'no_access_token';
			errorResult.errorMessage = 'Can\'t obtain access token';    		
      		return null;
    	}  
	}

	public void getTours(string accountID) {
		checkToken();
    	if(accessToken != null && accountID != null && accountID != '' && errorResult == null) {
	    	HttpRequest req = new HttpRequest();
	    	req.setEndpoint(toursURL);
	    	req.setMethod('POST');
	    	req.setHeader('Authorization', 'Bearer' + accessToken.access_token__c);
	    	req.setBody(JSON.serialize(new Map<String, Object>{
	        	'accountID'=>accountID
	    	}));

	    	Http http = new Http();
	    	try {
	    		HTTPResponse res = http.send(req);
	    		if(res.getBody().contains('errorMessage')) {
	    			errorResult = (ErrorDTO)JSON.deserialize(res.getBody(), ErrorDTO.class);
    			}
    			else {
		    		toursResult = (ToursDTO)JSON.deserialize(res.getBody(), ToursDTO.class);
    			}
	    	}
	    	catch (Exception e) {
    			errorResult = new ErrorDTO();
    			errorResult.error = 'connection_error';
    			errorResult.errorMessage = 'Service not avaliable';    	    		
	    	}
	    	
    	}
    	else {
    		if(accessToken == null) {
				errorResult = new ErrorDTO();
				errorResult.error = 'no_access_token';
				errorResult.errorMessage = 'Can\'t connect to service'; 	
    		}
    		else if(errorResult == null) {
				errorResult = new ErrorDTO();
				errorResult.error = 'no_accountID';
				errorResult.errorMessage = 'Specify correct Account';    			
    		}
    	}
		updateToken();
	}

	public void updateToken() {
    	if(accessToken != null) {
	    	access_token__c at = new access_token__c();
			at.Name = 'ToursRESTApi';
			at.access_token__c = accessToken.access_token__c;
			at.token_type__c = accessToken.token_type__c;
			at.expires_in__c = accessToken.expires_in__c;
			at.created_at__c = accessToken.created_at__c;
			upsert at accesstoken__c.Name;   
    	}
	}

	public ToursRESTApi() {
		
	}
}