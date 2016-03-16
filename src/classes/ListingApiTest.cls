@isTest
private class ListingApiTest {
     
    static  ID listingID ;
    static void setupTestData() {
        Development__c dev = new Development__c();
        dev.Name_of_Development__c = 'amli';
        insert dev;
        
        //Property__c prop = new Property__c();//
        //prop.development__c=dev.id;//
       // insert prop;//
        Listing__c listing = new Listing__c();
        listing.name='somelisting';
        //listing.Property__c  = prop.id;//
        insert listing;
        Unit__c unit = new Unit__c();
       // unit.property__c  =prop.id;//
        unit.BMR_Rent_Monthly__c = 400;
        unit.Rent_Multiple__c=3;
        unit.of_AMI_for_Pricing_Unit__c=55;
        unit.Listing__c = listing.id;
        unit.Maximum_Household_Size__c  =2;
        insert unit;
        listingID = listing.id;
        
        AMI__c ami = new AMI__c();
        ami.name='asdf';
        ami.amount__c = 40000;
        ami.Num_of_HouseHold__c=2;
        ami.Percent_of_Median__c=55;
        insert ami;
        //select id, amount__c, Num_of_HouseHold__c, Percent_of_Median__c from AMI__c]
    }
    static testMethod void testGetAll() {
         setupTestData();
        RestRequest reqContext = new RestRequest();

        reqContext.requestURI = '/Listings/';
        System.RestContext.request =reqContext; 
        ListingApi.doGet();
        
        
    }
    static testMethod void testGetByID() {
        setupTestData();
        RestRequest reqContext = new RestRequest();

        reqContext.requestURI = '/Listings/' + listingID;
        System.RestContext.request =reqContext; 
        ListingApi.doGet();
        
        
    }
     static testMethod void testGetByIDs() {
        setupTestData();
        RestRequest reqContext = new RestRequest();
        reqContext.params.put('ids','listingID');

        reqContext.requestURI = '/Listings/';
        System.RestContext.request =reqContext; 
        ListingApi.doGet();
        
        
    }
    static testMethod void testGetByIDParam() {
        setupTestData();
        RestRequest reqContext = new RestRequest();
        reqContext.params.put('id','listingID');

        reqContext.requestURI = '/Listings/';
        System.RestContext.request =reqContext; 
        ListingApi.doGet();
        
        
    }
    
    static testMethod void testParamListing() {
        setupTestData();
        
        RestRequest reqContext = new RestRequest();
        reqContext.params.put('householdsize','1');
        reqContext.params.put('incomelevel','31000');
        reqContext.requestURI = '/Listings/';
        System.RestContext.request =reqContext; 
        ListingApi.doGet();
    }

    static testMethod void testParamListingWChildren() {
        setupTestData();
        
        RestRequest reqContext = new RestRequest();
        reqContext.params.put('householdsize','1');
        reqContext.params.put('incomelevel','31000');
        reqContext.params.put('childrenUnder6','0');
        reqContext.requestURI = '/Listings/';
        System.RestContext.request =reqContext; 
        ListingApi.doGet();
    }
}