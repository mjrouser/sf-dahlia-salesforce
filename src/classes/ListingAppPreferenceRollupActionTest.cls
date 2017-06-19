@isTest
public class ListingAppPreferenceRollupActionTest {
	
    static testMethod void appPrefTriggerTest() {
        Account someAccount = new Account(Name = 'someAccount');
        insert someAccount;
        
        Listing__c someListing = new Listing__c(Name = 'someListing', Account__c = someAccount.Id);
        insert someListing;
        
        Application__c someApplication = new Application__c(Listing__c = someListing.Id, Status__c =  'Submitted');
        insert someApplication;
        
        Application_Member__c householdMember = new Application_Member__c(	Application__c = someApplication.Id,
                                                                          First_Name__c = 'Household', Last_Name__c = 'Member', Date_of_Birth__c = Date.today());
        insert householdMember;
        
        Lottery_Preference__c lotPref = new Lottery_Preference__c(Name = 'Neighborhood Resident Housing Preference (NRHP)');
        insert lotPref;
        
        Listing_Lottery_Preference__c listingPref = new Listing_Lottery_Preference__c(Listing__c = someListing.Id, Lottery_Preference__c = lotPref.Id);
        insert listingPref;
        
        Test.startTest();
        
        	Application_Preference__c appPref = new Application_Preference__c(Application__c = someApplication.Id, Listing_Preference_ID__c = listingPref.Id, Application_Member__c = householdMember.Id);
            List<Application_Preference__c> appPrefs = new List<Application_Preference__c>{appPref};
            insert appPrefs;
        	
        	listingPref = [SELECT Id, Total_Submitted_Apps__c FROM Listing_Lottery_Preference__c where Id = :listingPref.Id];
        	System.assertEquals(listingPref.Total_Submitted_Apps__c, 1);
        	
        	delete appPref;
        	listingPref = [SELECT Id, Total_Submitted_Apps__c FROM Listing_Lottery_Preference__c where Id = :listingPref.Id];
        	System.assertEquals(listingPref.Total_Submitted_Apps__c, 0);
        
            ListingApplicationPreferenceRollupAction trg = new ListingApplicationPreferenceRollupAction(new List<Application_Preference__c>{appPref});
            boolean del = trg.shouldRunOnDelete();
            boolean ins = trg.shouldRunOnInsert();
            boolean upd = trg.shouldRunOnUpdate();
        	
        Test.stopTest();
    }
}