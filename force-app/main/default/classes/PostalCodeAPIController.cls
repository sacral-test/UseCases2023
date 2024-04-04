/* Description: Displying the address lookup information based on postal code
*  Author Name: Nagarjuna.S
* Created Date: 06/02/2024
*/

public class PostalCodeAPIController {
    
    /**
     * Method to make an API call to retrieve address suggestions based on a postal code.
     * @param postcode The postal code for which address suggestions are requested.
     * @return List of LookupAddressResponse objects containing address suggestions.
     */ 
    @AuraEnabled(cacheable = true)
    public static List<LookupAddressResponse> makeAPICall(String postcode) {
        List<LookupAddressResponse> addressResponses = new List<LookupAddressResponse>();
        if (String.isBlank(postcode)) {
            return addressResponses;
        }           
        String endpointUrl = buildAutocompleteEndpoint(postcode);
        HttpResponse httpResponse = sendHttpRequest(endpointUrl);
        if(httpResponse != null && httpResponse.getStatusCode() == 200){
            addressResponses = extractAddressSuggestions(httpResponse);
        } 
        return addressResponses;
    }
    
    /**
     * Method to retrieve the full address details for a given address ID.
     * @param id The address ID for which full address details are requested.
     * @return List of LookupfulladdressResponse objects containing full address details.
     */
    @AuraEnabled(cacheable = true)
    public static List<LookupfulladdressResponse> getFullAddressforpostcode(String id){
        List<LookupfulladdressResponse> addressResponses = new List<LookupfulladdressResponse>();
        if (String.isBlank(id)) {
            return addressResponses;
        } 
        String endpointUrl = buildGetAddressEndpoint(id);
        HttpResponse httpResponse = sendHttpRequest(endpointUrl);
        if (httpResponse != null && httpResponse.getStatusCode() == 200){
            addressResponses = extractFullAddressDetails(httpResponse);
        }
        return addressResponses;
    }
    
    /**
     * Method to build the autocomplete API endpoint URL.
     * @param postcode The postal code for which address suggestions are requested.
     * @return Autocomplete API endpoint URL.
     */
    private static String buildAutocompleteEndpoint(String postcode) {
        return 'https://api.getaddress.io/autocomplete/'
            + EncodingUtil.urlEncode(postcode.replaceAll('\\s', ''), 'UTF-8')
            + '?api-key=' + Label.Postal_Api_Key;
    }
    
    /**
     * Method to build the get address API endpoint URL.
     * @param id The address ID for which full address details are requested.
     * @return Get address API endpoint URL.
     */
    private static String buildGetAddressEndpoint(String id) {
        return 'https://api.getaddress.io/get/'
            + EncodingUtil.urlEncode(id.replaceAll('\\s', ''), 'UTF-8')
            + '?api-key=' + Label.Postal_Api_Key;
    }
    
    /**
     * Method to send an HTTP request and get the response.
     * @param endpointUrl The API endpoint URL.
     * @return HttpResponse object containing the response.
     */
    private static HttpResponse sendHttpRequest(String endpointUrl) {
        try {
            return HttpUtility.makeGetRequest(endpointUrl);
        } catch (Exception ex) {
            return null;
        }
    }
    
    /**
     * Method to extract address suggestions from the HTTP response.
     * @param httpResponse The HTTP response.
     * @return List of LookupAddressResponse objects containing address suggestions.
     */
    private static List<LookupAddressResponse> extractAddressSuggestions(HttpResponse httpResponse) {
        List<LookupAddressResponse> addressResponses = new List<LookupAddressResponse>();
        Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(httpResponse.getBody());
        List<Object> suggestionsList = (List<Object>) meta.get('suggestions');
            for (Object suggestionObject : suggestionsList) {
                    Map<String, Object> suggestion = (Map<String, Object>) suggestionObject;
                    String address = (String) suggestion.get('address');
                    String url = (String) suggestion.get('url');
                    String id = (String) suggestion.get('id');
                    LookupAddressResponse response = new LookupAddressResponse();
                    response.address = address;
                    response.url = url;
                    response.id = id;
                    addressResponses.add(response);
            }
        return addressResponses;
    }
    
    /**
     * Method to extract full address details from the HTTP response.
     * @param httpResponse The HTTP response.
     * @return List of LookupfulladdressResponse objects containing full address details.
     */
    private static List<LookupfulladdressResponse> extractFullAddressDetails(HttpResponse httpResponse) {
        List<LookupfulladdressResponse> addressResponses = new List<LookupfulladdressResponse>();
        Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(httpResponse.getBody());
        LookupfulladdressResponse response = new LookupfulladdressResponse();
        response.country = (String) meta.get('country');
        response.town_or_city = (String) meta.get('town_or_city');
        response.district = (String) meta.get('district');
        addressResponses.add(response);
        return addressResponses;
    }
    
    /**
     * This class representing the response structure for address lookup.
     */
    public class LookupAddressResponse {
        @AuraEnabled
        public String address {get;set;}
        @AuraEnabled
        public String url {get;set;}
        @AuraEnabled
        public String id {get;set;}
    }
    
    /**
     * Inner class representing the response structure for full address lookup.
     */
    @TestVisible
    public class LookupfulladdressResponse{
        @AuraEnabled
        public String country {get;set;}
        @AuraEnabled
        public String town_or_city {get;set;}
        @AuraEnabled
        public String district {get;set;}
    }
}