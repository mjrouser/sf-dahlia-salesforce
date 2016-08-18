// *****************************************************************************
// CLASS: ListingUnitApiTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Test class for ListingUnitApi.cls and ListingService.cls
//
// *
@isTest
private class ListingUnitApiTest {

    private static List<Properties__c> lProperties;
    private static Account acc;
    private static Contact con;
    static  ID listingId ;
        
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
        
        Unit__c unit = new Unit__c();
        unit.property__c  = build.id;
        unit.BMR_Rent_Monthly__c = 400;
        unit.Rent_Multiple__c=3;
        unit.of_AMI_for_Pricing_Unit__c=55;
        unit.Listing__c = listing.id;
        unit.Maximum_Household_Size__c  = 8;
        unit.Number_of_Bedrooms__c = 3;
        insert unit;
        
        listingID = listing.id;
    }

    static testMethod void testGetUnitsByListingID() {
        setupTestData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/Listing/Units/' + listingID;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        List<Unit__c> unitList = new List<Unit__c>();
        unitList = ListingUnitApi.doGet();
        Unit__c unit = [SELECT ID FROM Unit__c WHERE Listing__c = :listingID];
        
        //verify the returned unit is the right one
        system.assert(unitList[0].ID == unit.Id);
        
    }
    
    static testMethod void testGetUnitsByListingIDParam() {
        setupTestData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/Listing/Units';  
        req.addParameter('id', listingID);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        List<Unit__c> unitList = new List<Unit__c>();
        unitList = ListingUnitApi.doGet();
        Unit__c unit = [SELECT ID FROM Unit__c WHERE Listing__c = :listingID];
        
        //verify the returned unit is the right one 
        system.assert(unitList[0].ID == unit.Id);
        
    }
    
}