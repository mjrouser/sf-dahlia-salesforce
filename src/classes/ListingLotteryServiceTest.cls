@isTest
private class ListingLotteryServiceTest {

    private static List<Properties__c> lProperties;
    private static Account acc;
    private static Contact con;
    private static User usr;
    private static AMI__c ami;
    static  ID lotteryId , listingID ;
    static List<Id> listlotteryId, listListingId;
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
        listingID = listing.ID;
        listListingId = new List<Id>();
        listListingId.add(listingID);
        
        Lottery_Preference__c lp = new Lottery_Preference__c();
        lp.Name = 'Test Lottery Preference';
        lp.Status__c = 'New';
        insert lp;
       	preferenceName = lp.Name;
        
        Lottery_Preference__c lp1 = new Lottery_Preference__c();
        lp1.Name = 'Test1 Lottery Preference';
        lp1.Status__c = 'New';
        insert lp1;
        
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
        
        lotteryId = lp.id;
        listlotteryId = new List<Id>();
        listlotteryId.add(lotteryId);
        
        ami = new AMI__c();
        ami.name='asdf';
        ami.amount__c = 40000;
        ami.Num_of_HouseHold__c=2;
        ami.Percent_of_Median__c=100;
        insert ami;
        //select id, amount__c, Num_of_HouseHold__c, Percent_of_Median__c from AMI__c]
    }
    
    static testMethod void testGetLotteryPreferenceByID() {
        setupTestData();
        
        List<Lottery_Preference__c> testLp = new List<Lottery_Preference__c>();
        testLp = ListingLotteryService.getLotteryPreferenceByID(lotteryId);
        //verify the returned Id is the right one 
        system.assert(testLp[0].Id == lotteryId);
    }
    static testMethod void testGetLotteryPreferenceByIDs() {
        setupTestData();
        
        List<Lottery_Preference__c> testLp = new List<Lottery_Preference__c>();
       
        List<Lottery_Preference__c> testLp1 = new List<Lottery_Preference__c>();
        testLp1 = ListingLotteryService.getLotteryPreferenceByIDs(listlotteryId);
        //verify the returned Id is the right one 
        system.assert(testLp1[0].Id == lotteryId);
     }
    static testMethod void testGetAllLotteryPreference() {
        setupTestData();
        
        List<Lottery_Preference__c> testLp = new List<Lottery_Preference__c>();
       
        testLp = ListingLotteryService.getAllLotteryPreference();
        system.assert(testLp.size() == 2);
    }
    static testMethod void testGetLotteryMembersByListingID() {
        setupTestData();
        
        List<Lottery_Preference__c> testLp = new List<Lottery_Preference__c>();
        
        List<Lottery_Member__c> testLm = new List<Lottery_Member__c>();
        testLm = ListingLotteryService.getLotteryMembersByListingID(listingId);
        //verify the returned Id is the right one 
        system.assert(testLm[0].Listing__c == listingId);
     }
    static testMethod void testGetLotteryMembersByListingIDs() {
        setupTestData();
        
        List<Lottery_Preference__c> testLp = new List<Lottery_Preference__c>();
       
        List<Lottery_Member__c> testLm = new List<Lottery_Member__c>();
        testLm = ListingLotteryService.getLotteryMembersByListingIDs(listListingId);
        //verify the returned Id is the right one 
        system.assert(testLm[0].Listing__c == listingId);
    }
}