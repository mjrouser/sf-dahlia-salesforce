// *****************************************************************************
// CLASS: ListingLotteryResultSummaryAPITest
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Test class for ListingLotteryResultSummaryAPI.cls and ListingService.cls
//
// *

@isTest
public with sharing class ListingLotteryResultSummaryAPITest {
    private static Account acc;
    static ID listingID, listing1ID ;
    static Application__c app;
    static Application__c app2;
    
    static void setupTestData() {
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        acc = new Account();
        acc.Name = 'Test Account';
        acc.RecordTypeId = rtId;
        acc.AccountNumber = '12345';
        insert acc;
        
        Development__c dev = new Development__c();
        dev.Name_of_Development__c = 'amli';
        dev.Project_ID__c = '123';
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
        
        app = new Application__c(Listing__c = listing.Id, Lottery_Number_Manual__c = '1');
                
        app2 = new Application__c(Listing__c = listing.Id, Lottery_Number_Manual__c = '1');
        insert new List<Application__c>{app,app2};
        
        Application_Member__c appM = new Application_Member__c(Application__c = app.Id, Date_of_Birth__c = date.today().addYears(-20), First_Name__c = 'firstName', Last_Name__c = 'lastName');
        insert appM;
        
        app.Live_in_SF_Preference_Member__c = appM.Id;
        app.DTHP_Preference_Member__c = appM.Id;
        app.COP_Preference_Member__c = appM.Id;
        app.Neighborhood_Preference_Member__c = appM.Id;
        app.Work_in_SF_Preference_Member__c = appM.Id;
        update app;
        
        listingID = listing.id;
    }
    
	/* 
	 * test GET summary lottery results
	 */    
    static testMethod void doGetById() {
        setupTestData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        //app = [SELECT Lottery_Number__c from Application__c WHERE Id = :app.Id];
        req.requestURI = '/Listing/LotteryResult/Summary/' + listingID;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        ListingService.ListingResult listingRes = ListingLotteryResultSummaryAPI.doGet();
		
        //check if returned application is the right one and has the same listing Id
        system.assert(listingRes.ListingId == listingID);	
        
        //check if no applications are returned because the Lottery Rank is null
        system.assert(listingRes.applicationResults.size() == 0);	
        
        app.Lottery_Rank__c = 1;
        update app;
        
		req.requestURI = '/Listing/LotteryResult/Summary/' + listingID;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        listingRes = ListingLotteryResultSummaryAPI.doGet();
		
        //check if all applications with Lottery Rank != null are returned
        system.assert(listingRes.applicationResults.size() == 1);	
                
    }
}