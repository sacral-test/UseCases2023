/* Description: Getting the products and update the salesprice in this apex class
* Author: Mukesh J & Nagarjuna
* Created Date: 20/11/2023
*/
public with sharing class ProductController {
	
    /**
     * Retrieves a list of OpportunityLineItems representing products.
     *
     * @return List<OpportunityLineItem> - List of products if available, otherwise null.
     */
    
    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getProducts(){	
       
            List<OpportunityLineItem> productslist = ProductSelector.fetchProducts();
            if(!productslist.isEmpty()){
                //System.debug('productslist'+productslist);
                return productslist;
            }else {
                return Null;
            }
                         
    } 
    
    /**
     * Updates the sales prices of the provided OpportunityLineItems.
     *
     * @param productData - JSON data containing the OpportunityLineItems to be updated.
     * @return String - Success message if the update is successful, otherwise a failure message.
     */
    
        @AuraEnabled 
        public static string updateSalesPrices(Object productdata){
            //System.debug('productdata'+productdata);
            //return 'done';
            
            // json.deserialize() method takes a JSON string and a class type as arguments and returns an object of the specified class type.
            // serialization means to convert an object into that string.
            List<OpportunityLineItem> updatesalesprices = 
                (List<OpportunityLineItem>)JSON.deserialize(Json.serialize(productdata),  List<OpportunityLineItem>.class);
            
            
            if(!updatesalesprices.isEmpty()){
                Update updatesalesprices;
                //updating the sales price is successfully to get success message.
                return ProductConstants.SUCCESS_MESSAGE;
            }
            return ProductConstants.FAILED_MESSAGE;
        }
        
}