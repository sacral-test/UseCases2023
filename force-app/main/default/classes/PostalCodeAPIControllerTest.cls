/* Description: Test class for PostalCodeAPIController class
* Author Name: Nagarjuna S
* Created Date: 12/02/2024
*/

@isTest
private class PostalCodeAPIControllerTest {
    // Mock response for the HTTP callout
    private class MockHttpResponse implements HttpCalloutMock {
        String responseType;
        public MockHttpResponse(String responseType){
            this.responseType= responseType;
        }
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            try {
                if(responseType == 'getPost'){
                    res.setHeader('Content-Type', 'application/json');
                    if (req.getMethod() == 'GET' && req.getEndpoint().Contains('autocomplete')) {
                        res.setBody('{"suggestions":[{"address":"Sample Address","url":"sample_url","id":"123"}]}');
                        res.setStatusCode(200);
                    }
                }
                else if(responseType == 'getId'){ 
                    res.setHeader('Content-Type', 'application/json');
                    if (req.getMethod() == 'GET' && req.getEndpoint().Contains('getaddress.io/get/')) {    
                        res.setBody('{"town_or_city":"Nottingham","country":"Nottinghamshire","district":"Nottingham"}');
                        res.setStatusCode(200);
                    }
                }
            } catch(Exception e) {
                System.debug('Exception occurred: ' + e.getMessage());
            }
            return res;
        }
    }  
    
    @isTest
    static void testMakeAPICall() {
        try {
            Test.startTest(); // Start of test execution
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse('getPost'));
            // Call the method to test
            List<PostalCodeAPIController.LookupAddressResponse> addressResponses = PostalCodeAPIController.makeAPICall('12345');
            // Verify the result
            System.assertEquals(1, addressResponses.size());
            PostalCodeAPIController.LookupAddressResponse response = addressResponses[0];
            System.assertEquals('Sample Address', response.address);
            System.assertEquals('sample_url', response.url);
            System.assertEquals('123', response.id);
        } catch(Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
        } finally {
            Test.stopTest(); // End of test execution
        }
    }
    
    @isTest
    static void testgetFullAddressforpostcode() {
        try {
            // Create a mock HTTP response
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse('getId'));
            // Call the method to test
            List<PostalCodeAPIController.LookupfulladdressResponse> addressResponses = PostalCodeAPIController.getFullAddressforpostcode('123');
            system.debug('addressResponses'+addressResponses); 
            // Verify the result
            System.assertEquals(1, addressResponses.size());
            PostalCodeAPIController.LookupfulladdressResponse response = addressResponses[0];
            System.assertEquals('Nottinghamshire', response.country);
            System.assertEquals('Nottingham', response.town_or_city);
            System.assertEquals('Nottingham',response.district);
        } catch(Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
        } finally {
            Test.stopTest();
        }
    }
}