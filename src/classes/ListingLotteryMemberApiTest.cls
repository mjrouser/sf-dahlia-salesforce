@isTest
public with sharing class ListingLotteryMemberApiTest {
    private static List<Properties__c> lProperties;
        private static Account acc;
        private static Contact con;
        private static User usr;
        private static AMI__c ami;
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
            insert listing;
            
            Lottery_Preference__c lp = new Lottery_Preference__c();
            lp.Name = 'Test Lottery Preference';
            lp.Status__c = 'New';
            insert lp;
            preferenceName = lp.Name;
            
            Listing_Lottery_Preference__c llp = new Listing_Lottery_Preference__c();
            llp.Listing__c = listing.Id;
            llp.Lottery_Preference__c = lp.Id;
            insert llp;
            
            Lottery_Member__c lm = new Lottery_Member__c();
            lm.Listing__c = listing.Id;
            lm.Status__c = 'Winner';
            lm.Lottery_Number__c = 1234;
            insert lm;
            
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
            listListingId = new List<Id>();
            listListingId.add(listingID);
            
            ami = new AMI__c();
            ami.name='asdf';
            ami.amount__c = 40000;
            ami.Num_of_HouseHold__c=2;
            ami.Percent_of_Median__c=100;
            insert ami;
            //select id, amount__c, Num_of_HouseHold__c, Percent_of_Median__c from AMI__c]
    }
    
    static testMethod void testGetByID() {
        setupTestData();
        RestRequest reqContext = new RestRequest();

        reqContext.requestURI = '/LotteryMember/' + listingId;
        System.RestContext.request =reqContext; 
        List<Lottery_Member__c> testLm = new List<Lottery_Member__c>();
        testLm = ListingLotteryMemberApi.doGet();
        //verify the returned Id is the right one 
        system.assert(testLm[0].Listing__c == listingID);
        
        //ListingLotteryMemberApi.doGet();
        
        
    }
     static testMethod void testGetByIdParam() {
        setupTestData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/ami';  
        req.addParameter('id', listingID);
        req.addParameter('amount', '20000');
        req.addParameter('householdsize', '2');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
         
        List<Lottery_Member__c> testLm = new List<Lottery_Member__c>();
        testLm = ListingLotteryMemberApi.doGet();
        //verify the returned Id is the right one 
        system.assert(testLm[0].Listing__c == listingID);
        //ListingLotteryMemberApi.doGet();
        
    }
    
    static testMethod void testGetByIDs() {
        setupTestData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/ami';  
        req.addParameter('ids', listingID);
        req.addParameter('amount', '20000');
        req.addParameter('householdsize', '2');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        List<Lottery_Member__c> testLm = new List<Lottery_Member__c>();
        testLm = ListingLotteryMemberApi.doGet();
        //verify the returned Id is the right one 
        system.assert(testLm[0].Listing__c == listingID);
        //ListingLotteryMemberApi.doGet();
        
    }
}