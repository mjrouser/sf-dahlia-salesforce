@isTest
public with sharing class ListingLotteryPrefApiTest {
     
    static id lotteryId; 
    
    static void setupTestData() {
    	Lottery_Preference__c lp = new Lottery_Preference__c();
    	lp.Name = 'test';
    	lp.Description__c = 'test';
    	insert lp;
    	lotteryId = lp.Id;
    }
    
    static testMethod void testGetAll() {
         setupTestData();
        RestRequest reqContext = new RestRequest();

        reqContext.requestURI = '/LotteryPreference/';
        System.RestContext.request =reqContext; 
        ListingLotteryPrefApi.doGet();
        
        
    }
    static testMethod void testGetByID() {
        setupTestData();
        RestRequest reqContext = new RestRequest();

        reqContext.requestURI = '/LotteryPreference/' + lotteryId;
        System.RestContext.request =reqContext; 
        ListingLotteryPrefApi.doGet();
        
        
    }
     static testMethod void testGetByIDs() {
        setupTestData();
        RestRequest reqContext = new RestRequest();

        reqContext.requestURI = '/LotteryPreference/Ids=' + lotteryId;
        System.RestContext.request =reqContext; 
        ListingLotteryPrefApi.doGet();
        
        
    }
}