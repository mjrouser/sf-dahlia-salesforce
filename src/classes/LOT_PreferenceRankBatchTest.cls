// *****************************************************************************
// CLASS: LOT_PreferenceRankBatchTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 9/16/2016
// Description: Test class for LOT_PreferenceRankBatch.cls
//
// *
@isTest
private class LOT_PreferenceRankBatchTest {
    private static List<Application__c> apps;
    private static Listing__c listing;
    
    static void setupTestData() {
        // Implement test code
        listing = new Listing__c();
        listing.Name = 'test';
        insert listing;

        apps = new List<Application__c>();
        Application__c ap = new Application__c();
        ap.Listing__c = listing.Id;
        apps.add(ap);

        ap = new Application__c();
        ap.Listing__c = listing.Id;
        ap.COP_Preference_Manual__c = 'Confirmed - Added';
        apps.add(ap);

        ap = new Application__c();
        ap.Listing__c = listing.Id;
        ap.Neighborhood_Preference_Manual__c = 'Confirmed - Added';
        apps.add(ap);

        ap = new Application__c();
        ap.Listing__c = listing.Id;
        ap.Live_Work_Preference_Paper__c = true;
        apps.add(ap);

        ap = new Application__c();
        ap.Listing__c = listing.Id;
        ap.DTHP_Preference_Manual__c = 'Confirmed - Added';
        apps.add(ap); 

        insert apps;
        
    }
    
    @isTest static void test_method_PreferenceRankBatch() {
        setupTestData();

        LOT_PreferenceRankBatch prefBatch = new LOT_PreferenceRankBatch('DTHP_Preference__c','DTHP_Preference_Rank__c','DTHP_App_Total__c',listing.Id);
        Database.executeBatch(prefBatch);
        prefBatch.calculateRank(apps);

    }
    
    
}