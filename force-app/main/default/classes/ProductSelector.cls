/* Description: Getting the products and update the salesprice in this apex class
*  Author: Mukesh J & Nagarjuna
* Created Date: 22/11/2023
  Modification Date:27/11/2023
  Modified by : Nagarjuna Sadhu
*/
public class ProductSelector {
    
    //This method fetches the products and their sales prices from OpportunityLineItem records.
    //It queries the OpportunityLineItem object with a limit based on the custom label 'limits_Custom_Labels'.
    // The returned list includes OpportunityLineItem records containing Id, Name, and UnitPrice fields.
    // Note: Ensure the custom label 'limits_Custom_Labels' is properly configured to control the query limit.

    public static List<OpportunityLineItem> fetchProducts(){
       
        Integer queryLimit = Integer.ValueOf(System.label.limits_Custom_Labels);
        
        return [select Id,Name,UnitPrice from OpportunityLineItem limit :queryLimit];
    }
    

}