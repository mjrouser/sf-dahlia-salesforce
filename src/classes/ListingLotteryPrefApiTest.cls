// *****************************************************************************
// CLASS: ListingLotteryPrefApiTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Test class for ListingLotteryPrefApi.cls and ListingLotteryService.cls
//
// *

@isTest
public with sharing class ListingLotteryPrefApiTest {
     
    private static List<Properties__c> lProperties;
    private static Account acc;
    private static Contact con;
    private static User usr;
    private static AMI__c ami;
    static ID lotteryPrefId;
    static ID lotteryPrefId2;
    static List<Id> listlotteryId;
    static String preferenceName ;
    // --test--//
    
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
        
        Lottery_Preference__c lotteryPref = new Lottery_Preference__c();
        lotteryPref.Name = 'Test Lottery Preference';
        lotteryPref.Status__c = 'New';
        preferenceName = lotteryPref.Name;
        
        Lottery_Preference__c lotteryPref1 = new Lottery_Preference__c();
        lotteryPref1.Name = 'Test1 Lottery Preference';
        lotteryPref1.Status__c = 'New';
        
        Lottery_Preference__c lotteryPref2 = new Lottery_Preference__c();
        lotteryPref2.Name = 'Test2 Lottery Preference';
        lotteryPref2.Status__c = 'New';
        insert new List<Lottery_Preference__c>{lotteryPref, lotteryPref1, lotteryPref2};
        
        Listing_Lottery_Preference__c listingLotteryPref = new Listing_Lottery_Preference__c();
        listingLotteryPref.Listing__c = listing.Id;
        listingLotteryPref.Lottery_Preference__c = lotteryPref.Id;
        insert listingLotteryPref;
        
        Unit__c unit = new Unit__c();
        unit.property__c  = build.id;
        unit.BMR_Rent_Monthly__c = 400;
        unit.Rent_Multiple__c=3;
        unit.of_AMI_for_Pricing_Unit__c=55;
        unit.Listing__c = listing.id;
        unit.Maximum_Household_Size__c  = 8;
        unit.Number_of_Bedrooms__c = 3;
        insert unit;
        
        lotteryPrefId = lotteryPref.id;
        lotteryPrefId2 = lotteryPref2.id;
        listlotteryId = new List<Id>();
        listlotteryId.add(lotteryPrefId);
        
    }
    
    /*
     * test get all lottery preferences and get lottery preference by id
     */
    static testMethod void testGetAll() {
        setupTestData();
        RestRequest reqContext = new RestRequest();

        reqContext.requestURI = '/LotteryPreference/' + lotteryPrefId;
        System.RestContext.request =reqContext; 
        List<Lottery_Preference__c> resultLotteryPrefs = new List<Lottery_Preference__c>();
        resultLotteryPrefs = ListingLotteryPrefApi.doGet();
        
        //verify the returned lottery preference matches the lottery preference id passed as param
        system.assert(resultLotteryPrefs[0].Id == lotteryPrefId);
        system.assert(resultLotteryPrefs.size() == 1);
        
        reqContext.requestURI = '/LotteryPreference';
        System.RestContext.request =reqContext;
        
        //verify there are returned all Lottery Preference (3 records)
        system.assert(ListingLotteryPrefApi.doGet().size() == 3);
        
    }
    
    /*
     * test get lottery preference by id
     */
    static testMethod void testGetByID() {
        setupTestData();
        RestRequest reqContext = new RestRequest();

        reqContext.requestURI = '/LotteryPreference';
        reqContext.addParameter('id', lotteryPrefId);
        System.RestContext.request =reqContext; 
        List<Lottery_Preference__c> resultLotteryPrefs = new List<Lottery_Preference__c>();
        resultLotteryPrefs = ListingLotteryPrefApi.doGet();
        
        //verify the returned lottery preference matches lottery preference id passed as param
        system.assert(resultLotteryPrefs[0].Id == lotteryPrefId);
        system.assert(resultLotteryPrefs.size() == 1);
        
        
    }
    
    /*
     * test get lottery preference by ids
     */
    static testMethod void testGetByIDs() {
        setupTestData();
        RestRequest reqContext = new RestRequest();

        reqContext.requestURI = '/LotteryPreference';
        reqContext.addParameter('ids', lotteryPrefId + ',' + lotteryPrefId2);
        System.RestContext.request =reqContext; 
        List<Lottery_Preference__c> resultLotteryPrefs = new List<Lottery_Preference__c>();
        resultLotteryPrefs = ListingLotteryPrefApi.doGet();
        
         //verify the returned lottery preferences 
        system.assert(resultLotteryPrefs.size() == 2);
        
        
    }
}