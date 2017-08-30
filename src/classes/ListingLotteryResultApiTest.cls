// *****************************************************************************
// CLASS: ListingLotteryResultApiTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Test class for ListingLotteryResultApi.cls and ListingService.cls
//
// *

@isTest
public with sharing class ListingLotteryResultApiTest {
    private static Account acc;
    static ID listingID, listing1ID ;
    static Application__c app;
    
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
        insert app;
        
        listingID = listing.id;
    }
    
	/* 
	 * test GET applications by listing Id and lottery number
	 */    
    static testMethod void doGetById() {
        setupTestData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        app = [SELECT Lottery_Number__c from Application__c WHERE Id = :app.Id];
        req.requestURI = '/Listing/LotteryResult/' + listingID + '/' + app.Lottery_Number__c;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        ListingService.ListingResult listingRes = ListingLotteryResultApi.doGet();
		
        //check if returned application is the right one and has the same lottery number
        system.assert(listingRes.ListingId == listingID);	
        //system.assert(listingRes.applicationResults[0].lotteryNumber == app.Lottery_Number__c);
    }
}