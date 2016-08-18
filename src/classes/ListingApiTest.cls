// *****************************************************************************
// CLASS: ListingApiTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Test class for ListingApi.cls and ListingService.cls
//
// *

@isTest
private class ListingApiTest {
     
    private static List<Properties__c> lProperties;
    private static Account acc;
    private static Contact con;
    private static User usr;
    static  ID listingID ;
    static  ID listingID2 ;
    static String preferenceName;
    
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
        
        //Property__c prop = new Property__c();//
        //prop.development__c=dev.id;//
       // insert prop;//
       
        Building__c build = new Building__c();
        build.Development__c = dev.Id;
        build.Developer__c = acc.Id;
       	insert build;
        
        List<Listing__c> listingList = new List<Listing__c>();
        Listing__c listing = new Listing__c();
        listing.name='somelisting';
        listing.Building__c  = build.id;
        listing.Account__c = acc.Id;
        listing.Status__c= 'Active';
        listingList.add(listing);
        
        Listing__c listing1 = new Listing__c();
        listing1.name='somelisting';
        listing1.Building__c  = build.id;
        listing1.Account__c = acc.Id;
        listing1.Status__c= 'Active';
        listingList.add(listing1);
        
        Listing__c listing2 = new Listing__c();
        listing2.name='somelisting';
        listing2.Building__c  = build.id;
        listing2.Account__c = acc.Id;
        listing2.Status__c= 'Active';
        listingList.add(listing2);
        insert listingList;
        
        Lottery_Preference__c lp = new Lottery_Preference__c();
        lp.Name = 'Test Lottery Preference';
        lp.Status__c = 'New';
        insert lp;
       	preferenceName = lp.Name;
        
        Listing_Lottery_Preference__c llp = new Listing_Lottery_Preference__c();
        llp.Listing__c = listing.Id;
        llp.Lottery_Preference__c = lp.Id;
        insert llp;
        
        Unit__c unit = new Unit__c();
        unit.property__c  = build.id;
        unit.BMR_Rent_Monthly__c = 400;
        unit.Rent_Multiple__c=3;
        unit.of_AMI_for_Pricing_Unit__c=55;
        unit.Listing__c = listing.id;
        unit.Maximum_Household_Size__c  =2;
        insert unit;
        listingID = listing.id;
        listingID2 = listing2.id;
        
        AMI__c ami = new AMI__c();
        ami.name='asdf';
        ami.amount__c = 40000;
        ami.Num_of_HouseHold__c=2;
        ami.Percent_of_Median__c=55;
        insert ami;
    }
    
    static testMethod void testGetAll() {
         setupTestData();
        RestRequest reqContext = new RestRequest();

        reqContext.requestURI = '/Listings/';
        System.RestContext.request =reqContext; 
        
        //get all listings if no params are passed
        system.assert(ListingApi.doGet().size() == 3);
        
        
    }
    static testMethod void testGetByID() {
        setupTestData();
        RestRequest reqContext = new RestRequest();

        reqContext.requestURI = '/Listings/' + listingID;
        System.RestContext.request =reqContext; 
        
        List<Listing__c> listingList = new List<Listing__c>();
        listingList = ListingApi.doGet();
        
        //verify the returned listing is the right one 
        system.assert(listingList[0].Id == listingID);
    }
    
     static testMethod void testGetByIDs() {
        setupTestData();
        RestRequest reqContext = new RestRequest();
        String listingIds = listingID + ',' + listingID2;
        reqContext.params.put('ids', listingIds);

        reqContext.requestURI = '/Listings/';
        System.RestContext.request =reqContext; 
        
        List<Listing__c> listingList = new List<Listing__c>();
        listingList = ListingApi.doGet();
        
        //verify the returned listings are the right ones
        for (Listing__c listing : listingList) {
        	system.assert(listing.Id == listingID || listing.Id == listingID2);
        }
    }
    static testMethod void testGetByIDParam() {
        setupTestData();
        RestRequest reqContext = new RestRequest();
        reqContext.params.put('id', listingID); 

        reqContext.requestURI = '/Listings/';
        System.RestContext.request =reqContext; 
        
        List<Listing__c> listingList = new List<Listing__c>();
        listingList = ListingApi.doGet();
        //verify the returned listing is the right one 
        system.assert(listingList[0].Id == listingID);
    }
    
    static testMethod void testParamListing() {
        setupTestData();
        
        RestRequest reqContext = new RestRequest();
        reqContext.params.put('householdsize','1');
        reqContext.params.put('incomelevel','31000');
        reqContext.requestURI = '/Listings/';
        System.RestContext.request =reqContext;
        
        List<Listing__c> listingList = new List<Listing__c>();
        listingList = ListingApi.doGet();
        //verify the returned listing is the right one 
        system.assert(listingList[0].Id == listingID);
    }

    static testMethod void getActiveListingsByPreference() {
         setupTestData();
        RestRequest reqContext = new RestRequest();

        reqContext.requestURI = '/Listings/';
        reqContext.params.put('preference', preferenceName);
        System.RestContext.request =reqContext; 
        
        List<Listing__c> listingList = new List<Listing__c>();
        listingList = ListingApi.doGet();
        //verify the returned listing is the right one
        system.assert(listingList[0].Id == listingID);
    }
}