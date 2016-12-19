@isTest
private class ListingServiceTest {
    private static List<Properties__c> lProperties;
    private static Account acc;
    private static Contact con;
    private static User usr;
    private static ListingService.criteria crit;
    static  ID listingID ;
    static List<Id> listListingId;
    static String preferenceName ;
    static AMI__c ami;
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
        insert dev;
        
        //Property__c prop = new Property__c();//
        //prop.development__c=dev.id;//
       // insert prop;//
       
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
        listing.Min_Occupancy__c = 3;
        insert listing;
        
        Listing__c listing1 = new Listing__c();
        listing1.name='somelisting1';
        listing1.Building__c  = build.id;
        listing1.Account__c = acc.Id;
        listing1.Status__c = 'Active';
        listing1.Does_Match__c = true;
        insert listing1;
        
        app = new Application__c();
        app.listing__c = listing.Id;
        app.Lottery_Number_Manual__c  = '1234';
        app.Lottery_Rank__c = 1;
        insert app;
        /*
        Lottery_Preference__c lp = new Lottery_Preference__c();
        lp.Name = 'Test Lottery Preference';
        lp.Status__c = 'New';
        insert lp;
        preferenceName = lp.Name;
        
        Listing_Lottery_Preference__c llp = new Listing_Lottery_Preference__c();
        llp.Listing__c = listing.Id;
        llp.Lottery_Preference__c = lp.Id;
        insert llp;
        */
        Unit__c unit = new Unit__c();
        unit.property__c  = build.id;
        unit.BMR_Rent_Monthly__c = 400;
        unit.Rent_Multiple__c=2;
        unit.of_AMI_for_Pricing_Unit__c=55;
        unit.Listing__c = listing.id;
        unit.Maximum_Household_Size__c  = 8;
        unit.Number_of_Bedrooms__c = 3;
        insert unit;
        
        Unit__c unit1 = new Unit__c();
        unit1.property__c  = build.id;
        unit1.BMR_Rent_Monthly__c = 400;
        unit1.Rent_Multiple__c=2;
        unit1.of_AMI_for_Pricing_Unit__c=55;
        unit1.Listing__c = listing1.id;
        unit1.Maximum_Household_Size__c  = 8;
        unit1.Number_of_Bedrooms__c = 3;
        insert unit1;
        
        listingID = listing.id;
        listListingId = new List<Id>();
        listListingId.add(listingID);
        
        ami = new AMI__c();
        ami.name='Test Lottery Preference';
        ami.amount__c = 40000;
        ami.Num_of_HouseHold__c=2;
        ami.Percent_of_Median__c=55;
        insert ami;
        //select id, amount__c, Num_of_HouseHold__c, Percent_of_Median__c from AMI__c]
        
        crit = new ListingService.criteria();
        crit.childrenUnder6 = 6;
        crit.householdSize = 10;
        crit.incomelevel = 15000;
        crit.PreferenceName = 'Test Lottery Preference';
        
        
    }
    static testMethod void testGetListingByID() {
        setupTestData();
        
        List<Listing__c> testL = new List<Listing__c>();
        testL = ListingService.getListingByID(listingID);
        //verify the returned Id is the right one 
        system.assert(testL[0].Id == listingId);
    }
    static testMethod void testGetListingByIDs() {
        setupTestData();
        
        List<Listing__c> testL = new List<Listing__c>();
    
        testL = ListingService.getListingByIDs(listListingID);
        //verify the returned Id is the right one 
        system.assert(testL[0].Id == listingId);
    }
    /* removed for now  -LL until we do new preference model 
    static testMethod void testGetActiveListingsByPreference() {
        setupTestData();
        
        List<Listing__c> testL = new List<Listing__c>();
    
        testL = ListingService.getActiveListingsByPreference(preferenceName);
        //verify the returned Id is the right one 
        system.assert(testL[0].Id == listingId); 
    }
    */
    static testMethod void testGetAllActiveListings() {
        setupTestData();
        
        List<Listing__c> testL = new List<Listing__c>();
    
        testL = ListingService.getAllActiveListings();
        //number of expected result is met
        system.assert(testL.size() == 2);
    }
    
    static testMethod void testGetListingDetailByCriteria() {
        setupTestData();
        
        LIst<ListingService.ListingDetail> testLD = new LIst<ListingService.ListingDetail>();
        testLD = ListingService.getListingDetailByCriteria(crit);
        //number of expected result is met
        system.assert(testLd.size() == 2);
    }  
    static testMethod void testGetListingDetailByID() {
        setupTestData();
        
        LIst<ListingService.ListingDetail> testLD = new LIst<ListingService.ListingDetail>();
        testLD = ListingService.getListingDetailByID(listingId);
        //number of expected result is met
        system.assert(testLd.size() == 1);
    }
    static testMethod void testGetListingDetailByIDs() {
        setupTestData();
        
        LIst<ListingService.ListingDetail> testLD = new LIst<ListingService.ListingDetail>();
        testLD = ListingService.getListingDetailByIDs(listListingId);
        //number of expected result is met
        system.assert(testLd.size() == 1);
    }
    static testMethod void testGetAllActiveListingDetails() {
        setupTestData();
        
        LIst<ListingService.ListingDetail> testLD = new LIst<ListingService.ListingDetail>();
         testLD = ListingService.getAllActiveListingDetails();
        //number of expected result is met
        system.assert(testLd.size() == 2);
    }
    static testMethod void testGetUnitsByListingID() {
        setupTestData();
        
        LIst<ListingService.ListingDetail> testLD = new LIst<ListingService.ListingDetail>();
             
        List<Unit__c> testU = new List<Unit__c>();
        testU = ListingService.getUnitsByListingID(listingID);
        //number of expected result is met
        system.assert(testU.size() == 1);
     }
    static testMethod void testGetUnitSummaryByListingID() {
        setupTestData();
        
        LIst<ListingService.ListingDetail> testLD = new LIst<ListingService.ListingDetail>();
        
        //ListingService.getUnitsByListingID(listingId);
        List<ListingService.UnitSummary> testUS = new List<ListingService.UnitSummary>();
        testUS = ListingService.getUnitSummaryByListingID(listingID);
        //number of expected result is met
        system.assert(testUS.size() == 1);
     }
    static testMethod void testGetListingDetailAll() {
        setupTestData();
        
        LIst<ListingService.ListingDetail> testLD = new LIst<ListingService.ListingDetail>();
        
        //ListingService.getUnitSummaryByListingID(listingId);
        System.assertEquals(ListingService.getListingDetailAll().size(), 2);
        //Map<Decimal,  Map<Decimal,Decimal>> x = ListingService.AMIMap;
       	
    } 
    
      static testMethod void getListingResults() {
          setupTestData();
          System.assertEquals(ListingService.checkEligibility(crit, listingID).incomeEligibilityResult, 'Too High');
          System.assertEquals(ListingService.getListingResults(listingID, '1234', true).listingId, listingID);
          System.assertEquals(ListingService.getListingResults(listingID, '1234', false).listingId, listingID);
      }
    
    static testMethod void getUnits() {
          setupTestData();
          System.assertEquals(ListingService.getAll(listingID).size(), 2);
          System.assertEquals(ListingService.getUnitByListingId(listingID).size(), 1);
    }

}