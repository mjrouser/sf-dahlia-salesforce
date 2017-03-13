// *****************************************************************************
// CLASS: LOT_RandomDrawServiceTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 9/16/2016
// Description: Test class for LOT_RandomDrawService.cls, LOT_RandomBaseRequest.cls, LOT_RandomDrawReq.cls
//
// *
@isTest
public with sharing class LOT_RandomDrawServiceTest {
    
    private static List<Properties__c> lProperties;
    private static Account acc;
    private static Contact con;
    private static User usr;
    private static AMI__c ami;
    private static Application__c app;
    static  ID listingID ;
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
        listing.Lottery_Status__c = 'Not Yet Run';
        insert listing;
        
        
        app = new Application__c(Applicant_Household__c = acc.Id, Listing__c = listing.Id, Status__c = 'Submitted');
        insert app;
        
        Application_Member__c appM = new Application_Member__c(Application__c = app.Id, First_Name__c = 'Test', Last_Name__c = 'lastName', Date_of_Birth__c = date.today().addYears(-20), Neighborhood_Preference_Match__c = 'Matches');
        insert appM;
        
        app.COP_Preference_Member__c = appM.Id;
        app.Neighborhood_Preference_Member__c = appM.Id;
        app.Work_in_SF_Preference_Member__c = appM.Id;
        app.DTHP_Preference_Member__c = appM.Id;
        app.Live_in_SF_Preference_Member__c = appM.Id;
        app.Lottery_Rank__c = 22;
        update app;
        
        Unit__c unit = new Unit__c();
        unit.property__c  = build.id;
        unit.BMR_Rent_Monthly__c = 400;
        unit.Rent_Multiple__c=3;
        unit.of_AMI_for_Pricing_Unit__c=55;
        unit.Listing__c = listing.id;
        unit.Number_of_Bedrooms__c = 3;
        insert unit;
        
        listingID = listing.id;
        listListingId = new List<Id>();
        listListingId.add(listingID);
        
        ami = new AMI__c();
        ami.name='asdf';
        ami.amount__c = 40000;
        ami.Num_of_HouseHold__c=2;
        ami.Percent_of_Median__c=100;
        insert ami;
        
        ami = new AMI__c();
        ami.name='asde';
        ami.amount__c = 30000;
        ami.Num_of_HouseHold__c=1;
        ami.Percent_of_Median__c=90;
        insert ami;
        
        External_Connections__c extConnection = new External_Connections__c();
        extConnection.Name = 'random.org';
        extConnection.API_Key__c = '59431712-899c-44d0-9b78-b033f1469be8';
        extConnection.End_Point__c = 'https://draws.random.org/api/json-rpc/2/invoke';
        extConnection.Password__c = 'asdf1234';
        extConnection.User_Name__c = 'luke@vertiba.com';
		extConnection.RecordType__c = 'test';
		extConnection.Active__c = true;
		insert extConnection;
    }
    public static testmethod void testReRunLottery() {
    	setupTestData();
        app = [SELECT Id, Name, Lottery_Number__c from Application__c WHERE Id = :app.Id];
    	//LOT_PreferenceRankBatch prefRankBatch = new LOT_PreferenceRankBatch();
    	test.startTest();
			HttpCalloutMockGeneratorTest mock = new HttpCalloutMockGeneratorTest();
			mock.statusCode=200;
			mock.status = 'OK';
			mock.body = '{    "jsonrpc": "2.0","result": {        "drawId": 22993,        "status": "completed",        "entryCount": 3,        "winners": ["' + app.Name + '"],        "completionTime": "2011-10-10 13:19:12Z",        "recordUrl": "https://draws.random.org/records/draw=22993"    },   "error": null,    "id": 42}';
			Test.setMock(HttpCalloutMock.class, mock);
	    	LOT_RandomDrawService.runLottery(listingID,true);
        	
        test.stopTest();
    }
    
    public static testmethod void testRunLottery() {
    	setupTestData();
        app = [SELECT Id, Name, Lottery_Number__c from Application__c WHERE Id = :app.Id];
    	//LOT_PreferenceRankBatch prefRankBatch = new LOT_PreferenceRankBatch();
    	test.startTest();
			HttpCalloutMockGeneratorTest mock = new HttpCalloutMockGeneratorTest();
			mock.statusCode=200;
			mock.status = 'OK';
			mock.body = '{    "jsonrpc": "2.0","result": {        "drawId": 22993,        "status": "completed",        "entryCount": 3,        "winners": ["' + app.Name + '"],        "completionTime": "2011-10-10 13:19:12Z",        "recordUrl": "https://draws.random.org/records/draw=22993"    },   "error": null,    "id": 42}';
			Test.setMock(HttpCalloutMock.class, mock);
	    	LOT_RandomDrawService.runLottery(listingID,false);
        	
        test.stopTest();
    }
}