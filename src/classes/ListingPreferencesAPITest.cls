// *****************************************************************************
// CLASS: ListingPreferencesAPITest
// *****************************************************************************
//
// Author: Vertiba
// Date: 20/10/16
// Description: Test class for ListingPreferencesAPI.cls
//
// *

@isTest
public with sharing class ListingPreferencesAPITest {
    private static Account acc;
    private static Contact con;
    static  ID listingID;
    
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
                    
        insert new List<Listing__c>{listing};
        listingID = listing.Id;
        
        Lottery_Preference__c lotPref = new Lottery_Preference__c();
        insert lotPref;
        
        Listing_Lottery_Preference__c lp = new Listing_Lottery_Preference__c();
        lp.Listing__c = listing.id;
        lp.Lottery_Preference__c = lotPref.Id;
        insert lp;
        
    }
    
    /*
     * test get lottery preference by listing id
     */
    static testMethod void testGetByID() {
        setupTestData();
        RestRequest reqContext = new RestRequest();

        reqContext.requestURI = '/Listing/Preferences/' + listingId;
        System.RestContext.request = reqContext; 
        List<ListingService.ListingPreference> listingPref = new List<ListingService.ListingPreference>();
        listingPref = ListingPreferencesAPI.doGet();
        
        //verify the returned lottery preference match what we have inserted
        system.assert(listingPref.size() == 1);
   }
    
    /*
     * test get lottery preference by listing id as param
     */
     static testMethod void testGetByIdParam() {
        setupTestData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/Listing/Preferences';  
        req.addParameter('id', listingID);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
         
        List<ListingService.ListingPreference> listingPref = new List<ListingService.ListingPreference>();
        listingPref = ListingPreferencesAPI.doGet();
        
        //verify the returned lottery preference match what we have inserted
        system.assert(listingPref.size() == 1);
        
    }
}