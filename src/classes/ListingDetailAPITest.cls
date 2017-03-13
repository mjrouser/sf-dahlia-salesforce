// *****************************************************************************
// CLASS: ListingDetailAPITest
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Test class for ListingDetailAPI.cls and ListingService.cls
//
// *

@isTest
private class ListingDetailAPITest {
	
    private static List<Properties__c> lProperties;
    private static Account acc;
    private static Contact con;
    private static User usr;
    private static AMI__c ami;
    static  ID listingID, listing1ID;
    static List<Id> listListingId;
    static String preferenceName ;
    
    static void setupTestData() {
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        acc = new Account();
        acc.Name = 'Test Account';
        acc.RecordTypeId = rtId;
        acc.AccountNumber = '12345';
        insert acc;
        
        Development__c dev = new Development__c();
        dev.Name_of_Development__c = 'amli';
        insert dev;
      
        Building__c build = new Building__c();
        build.Development__c = dev.Id;
        build.Developer__c = acc.Id;
       	insert build;
        
        Listing__c listing = new Listing__c();
        listing.name='somelisting';
        listing.Building__c  = build.id;
        listing.Account__c = acc.Id;
        listing.Status__c = 'Active';
        listing.Does_Match__c = true;
        insert listing;
        
        Listing__c listing1 = new Listing__c();
        listing1.name='somelisting';
        listing1.Building__c  = build.id;
        listing1.Account__c = acc.Id;
        listing1.Status__c = 'Active';
        listing1.Does_Match__c = true;
        insert listing1;
        
        listingID = listing.id;
        listing1ID = listing1.id;
        listListingId = new List<Id>();
        listListingId.add(listingID);
        
        Unit__c unit = new Unit__c();
        unit.property__c  = build.id;
        unit.BMR_Rent_Monthly__c = 400;
        unit.Rent_Multiple__c=3;
        unit.of_AMI_for_Pricing_Unit__c=55;
        unit.Listing__c = listing.id;
        unit.Number_of_Bedrooms__c = 3;
        insert unit;
        
        Unit__c unit1 = new Unit__c();
        unit1.property__c  = build.id;
        unit1.BMR_Rent_Monthly__c = 400;
        unit1.Rent_Multiple__c=3;
        unit1.of_AMI_for_Pricing_Unit__c=55;
        unit1.Listing__c = listing1.id;
        unit1.Number_of_Bedrooms__c = 3;
        insert unit1;

        /*ami = new AMI__c();
        ami.name='Test Lottery Preference';
        ami.amount__c = 40000;
        ami.Num_of_HouseHold__c=2;
        ami.Percent_of_Median__c=100;
        insert ami;*/
        
    }
        
    static testMethod void doGetById() {
        setupTestData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/listings/'+listingID;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        List<ListingService.ListingDetail> listingList = new List<ListingService.ListingDetail>();
        listingList = ListingDetailAPI.doGet();
        //verify the returned listing matches the id was passed as param 
        system.assert(listingList[0].listingID == listingID);
    }
    static testMethod void doGetByIdParam() {
        setupTestData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/listings';  
        req.addParameter('id', listingID);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        List<ListingService.ListingDetail> listingList = new List<ListingService.ListingDetail>();
        listingList = ListingDetailAPI.doGet();
        //verify the returned listing matches the id was passed as param 
        system.assert(listingList[0].listingID == listingID);	
        
    }
     static testMethod void doGetByIds() {
         setupTestData();
         RestRequest req = new RestRequest(); 
         RestResponse res = new RestResponse();
         req.requestURI = '/listings';  
         req.addParameter('ids', listingID + ',' + listing1ID);
         req.httpMethod = 'GET';
         RestContext.request = req;
         RestContext.response = res;
         
		 List<ListingService.ListingDetail> listingList = new List<ListingService.ListingDetail>();
         listingList = ListingDetailAPI.doGet();
         //verify the returned listing match the idd were passed as params
         for (ListingService.ListingDetail listing : listingList) {
         	system.assert(listing.listingID == listingID || listing.listingID == listing1ID);
         }
     }
    
     static testMethod void doGetByCriteria() {
         setupTestData();
         RestRequest req = new RestRequest(); 
         RestResponse res = new RestResponse();
         req.requestURI = '/listings';  
         req.addParameter('incomelevel', '20');
         req.addParameter('householdsize', '4');
         req.addParameter('childrenUnder6', '2');
         req.addParameter('preferenceName', 'Test Lottery Preference');
         req.httpMethod = 'GET';
         RestContext.request = req;
         RestContext.response = res;
         
         //return all records that met criteria
         system.assert(ListingDetailAPI.doGet().size() == 2);
         
     }
}