@isTest
public with sharing class ListingLotteryMemberApiTest {
    static id listingId;
    
    static void setupTestData() {
    	Development__c dev = new Development__c();
        dev.Name_of_Development__c = 'amli';
        insert dev;
        
        
        Listing__c listing = new Listing__c();
        listing.name='somelisting';
        insert listing;
        Unit__c unit = new Unit__c();
        unit.BMR_Rent_Monthly__c = 400;
        unit.Rent_Multiple__c=3;
        unit.of_AMI_for_Pricing_Unit__c=55;
        unit.Listing__c = listing.id;
        unit.Maximum_Household_Size__c  =2;
        insert unit;
        listingId = listing.id;
        Lottery_Member__c lm = new Lottery_Member__c();
        lm.Listing__c = listing.id;
        lm.Status__c = 'Wininer';
        insert lm;
    }
    
    static testMethod void testGetByID() {
        setupTestData();
        RestRequest reqContext = new RestRequest();

        reqContext.requestURI = '/LotteryMember/' + listingId;
        System.RestContext.request =reqContext; 
        ListingLotteryMemberApi.doGet();
        
        
    }
     static testMethod void testGetByIDs() {
        setupTestData();
        RestRequest reqContext = new RestRequest();

        reqContext.requestURI = '/LotteryMember/Ids=' + listingId;
        System.RestContext.request =reqContext; 
        ListingLotteryMemberApi.doGet();
        
        
    }
}