/* Description: Test calss for ProductController
* Author: Nagarjuna Sadhu & Mukesh J
* Created Date: 20/11/2023
*/
@isTest
private class ProductControllerTest {
    
    public static testmethod void testGetProducts() {
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert prod;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id =  pricebookId ,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        
        // Creating opportunity
        Opportunity op = new Opportunity();
        op.name = 'test';
        op.closedate = Date.today();
        op.StageName = 'Init';
        op.pricebook2Id  = pricebookId   ;
        insert op;
        
        // Creating opportunityLineItem
        OpportunityLineItem  ol = new OpportunityLineItem();
        ol.opportunityid = op.id;
        ol.quantity = 4;       
        ol.TotalPrice = ol.quantity * pbEntry.UnitPrice ;
        ol.PricebookEntryId = pbEntry.id ;
        insert ol;
        
        
        List<OpportunityLineItem> productList = new List<OpportunityLineItem>();
        productList.add(ol);
        
        Test.Starttest();
        string result = ProductController.Updatesalesprices(productList);
        System.assertEquals(result,ProductConstants.SUCCESS_MESSAGE);
        Test.stoptest();
        
    }
    @isTest
    public static void testfetchProducts(){
        Id pricebookId = Test.getStandardPricebookId();
        
        List<OpportunityLineItem> productslists = new List<OpportunityLineItem>();
        List<OpportunityLineItem> productslists1 = new List<OpportunityLineItem>();
          Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert prod;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id =  pricebookId ,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        Opportunity op = new Opportunity();
        op.name = 'test';
        op.closedate = Date.today();
        op.StageName = 'Init';
        op.pricebook2Id  = pricebookId   ;
        insert op;
        
        // Creating opportunityLineItem
        OpportunityLineItem  ol = new OpportunityLineItem();
        ol.opportunityid = op.id;
        ol.quantity = 4;    
        ol.TotalPrice = ol.quantity * pbEntry.UnitPrice ;
        ol.PricebookEntryId = pbEntry.id ;
        productslists.add(ol);
        insert productslists;
    
         Test.Starttest();
        List<OpportunityLineItem> optlist=ProductController.getProducts();
        string result = ProductController.Updatesalesprices(productslists);
        System.assertEquals(result,ProductConstants.SUCCESS_MESSAGE);
         string result1 = ProductController.Updatesalesprices(productslists1);
        System.assertEquals(result1,ProductConstants.FAILED_MESSAGE);
        ProductSelector.fetchProducts();
        Test.stoptest();
        
        
    }
    @isTest
    
    public static void checkingEmptyProducts(){
        List<OpportunityLineItem> optlist=ProductController.getProducts();
    }
    
}