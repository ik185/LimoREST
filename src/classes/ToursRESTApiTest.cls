@isTest
public class ToursRESTApiTest{
    public static testmethod void goodTest() {
        String testAccId = 'abc123';
        SingleRequestMock accessTokenRespond = new SingleRequestMock(200,
                                                    'Complete',
                                                    '{"access_token": "bfVDyAZzPV5UsuYrdYM6B0eiPc3o7LP2","token_type": "bearer","expires_in": "12962929"}',
                                                    null);

        SingleRequestMock toursRespond = new SingleRequestMock(200,
                                                    'Complete',
                                                    '{"tours":[{"accountID": "' + testAccId + '","bookingNr": "123456","timeLocale": "2016-02-02T12:00:00+0100","driverID": "123456","destination": "Schonefeld Airport"}]}', 
                                                    null);

        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('https://backend.universal-limo.com/api/v2/oauth/token', accessTokenRespond);
        endpoint2TestResp.put('https://backend.universal-limo.com/api/v2/tours?accountID=' + testAccId, toursRespond);

        HttpCalloutMock multiCalloutMock =
                                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        ToursRESTApi controller = new ToursRESTApi();
        controller.getTours(testAccId);
        System.assertEquals(controller.toursResult.tours[0].accountID, testAccId);
        System.assertEquals(controller.errorResult, null);
    }

    public static testmethod void badTokenTest() {
        String testAccId = 'abc123';
        SingleRequestMock accessTokenRespond = new SingleRequestMock(200,
                                                    'Complete',
                                                    '{"accesstoken": "bfVDyAZzPV5UsuYrdYM6B0eiPc3o7LP2"}',
                                                    null);

        SingleRequestMock toursRespond = new SingleRequestMock(200,
                                                    'Complete',
                                                    '{"tours":[{"accountID": "' + testAccId + '","bookingNr": "123456","timeLocale": "2016-02-02T12:00:00+0100","driverID": "123456","destination": "Schonefeld Airport"}]}', 
                                                    null);

        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('https://backend.universal-limo.com/api/v2/oauth/token',accessTokenRespond);
        endpoint2TestResp.put('https://backend.universal-limo.com/api/v2/tours?accountID=' + testAccId, toursRespond);

        HttpCalloutMock multiCalloutMock =
                                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        ToursRESTApi controller = new ToursRESTApi();
        controller.getTours(testAccId);
        System.assertEquals(controller.errorResult.error, 'no_access_token');

    }    
    
    public static testmethod void badToursTest() {
        String testAccId = 'abc123';
        SingleRequestMock accessTokenRespond = new SingleRequestMock(200,
                                                    'Complete',
                                                    '{"access_token": "bfVDyAZzPV5UsuYrdYM6B0eiPc3o7LP2","token_type": "bearer","expires_in": "12962929"}',
                                                    null);

        SingleRequestMock toursRespond = new SingleRequestMock(200,
                                                    'Complete',
                                                    '{"error": "invalid_accountID","errorMessage": "AccountID not found"}',
                                                    null);

        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('https://backend.universal-limo.com/api/v2/oauth/token',accessTokenRespond);
        endpoint2TestResp.put('https://backend.universal-limo.com/api/v2/tours?accountID=' + testAccId, toursRespond);

        HttpCalloutMock multiCalloutMock =
                                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        ToursRESTApi controller = new ToursRESTApi();
        controller.getTours(testAccId);
        System.assertEquals(controller.errorResult.error, 'invalid_accountID');

    }     
}