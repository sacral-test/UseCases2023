/* Description : Utility calss for http Callouts
     * Author Name : Nagarjuna.S
     * Created Date: 09/02/2024
     */
    public class HttpUtility{
        /**
         * Makes a GET request to the specified endpoint URL.
         * 
         * @param endpointurl The URL of the endpoint to which the request is made.
         * @return HttpResponse object containing the response from the HTTP request.
         */
        
        public static HttpResponse makeGetRequest(String endpointurl){
            Http http = new Http();	
            HttpRequest request = new HttpRequest();
            request.setMethod(HttpConstants.GET_METHOD);
            request.setEndpoint(endpointurl);
            request.setTimeout(HttpConstants.REQUEST_TIMEOUT);
            
            return http.send(request);
        }
    
    /**
     * Retrieves full address details from the specified endpoint.
     * 
     * @param endpoint The URL of the endpoint from which to retrieve the address details.
     * @return HttpResponse object containing the response from the HTTP request.
     */
    
    /*public static HttpResponse getFullAddress(String endpoint){
        HTTP http = new HTTP();
        HttpRequest request = new HttpRequest();
        request.setMethod(HttpConstants.GET_METHOD);
        request.setEndpoint(endpoint);
        request.setTimeout(HttpConstants.Reqest_Timeout);
        
        return http.send(request);
    }*/
    
    
}