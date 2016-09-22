// *****************************************************************************
// CLASS: HOP_ApplicationFormControllerTest
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Test class for the HOP_ApplicationFormController class.
//
// *****************************************************************************

@isTest
private class HOP_ApplicationFormControllerTest {
	
	@isTest
	static void emptyIdTest() {
		Test.startTest();
			HOP_ApplicationFormController cnt = new HOP_ApplicationFormController();
			System.assert(cnt.hasErrors == true);
		Test.stopTest();
	}
	
	@isTest
	static void badIdTest() {
		Test.startTest();
			ApexPages.currentPage().getParameters().put('id', UserInfo.getUserId());
			HOP_ApplicationFormController cnt = new HOP_ApplicationFormController();
			System.assert(cnt.hasErrors == true);
		Test.stopTest();
	}

	@isTest
	static void badListingIdTest() {
		Test.startTest();
			ApexPages.currentPage().getParameters().put('listingId', UserInfo.getUserId());
			HOP_ApplicationFormController cnt = new HOP_ApplicationFormController();
			System.assert(cnt.hasErrors == true);
		Test.stopTest();
	}

	@isTest
	static void goodListingIdTest() {
		Test.startTest();
			
			Account someAccount = new Account(Name = 'someAccount');
        	insert someAccount;
        	
			Listing__c someListing = new Listing__c(Name = 'someListing', Account__c = someAccount.Id);
			insert someListing;

			ApexPages.currentPage().getParameters().put('listingId', someListing.Id);
			HOP_ApplicationFormController cnt = new HOP_ApplicationFormController();
			System.assert(cnt.hasErrors == false);
			System.assert(cnt.app.Listing__c == someListing.Id);
            System.assert(cnt.app.Application_Submission_Type__c == HOP_Constants.PAPER_APPLICATION);
		Test.stopTest();
	}

	@isTest
	static void completeLotteryTest() {
		Test.startTest();

			Account someAccount = new Account(Name = 'someAccount');
        	insert someAccount;
        	
			Listing__c someListing = new Listing__c(Name = 'someListing', Account__c = someAccount.Id, Lottery_Status__c = 'Lottery Complete');
			insert someListing;

			Application__c someApp = new Application__c(Listing__c = someListing.Id);
			insert someApp;

			ApexPages.currentPage().getParameters().put('id', someApp.Id);
			HOP_ApplicationFormController cnt = new HOP_ApplicationFormController();
			System.assert(cnt.hasErrors == true);
		Test.stopTest();
	}

	@isTest
	static void communityUser_noAccessAccountTest() {
		Test.startTest();

			List<Profile> communityUserProfiles = [SELECT Id FROM Profile WHERE UserLicense.Name = :HOP_Constants.COMMUNITY_LICENSE_NAME LIMIT 1];
			if (communityUserProfiles.size() == 0) return;
			Id communityUserProfileId = communityUserProfiles[0].Id;

			Id PROPERTY_MANAGEMENT_ACCOUNT_RTID = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Property_Management'].Id;
			Account cuAccount = new Account(RecordTypeId = PROPERTY_MANAGEMENT_ACCOUNT_RTID, Name = 'PMA');
        	insert cuAccount;
        
        	Account otherAccount = new Account(Name = 'OA');
        	insert otherAccount;
        	
			Listing__c otherListing = new Listing__c(Name = 'OtherListing', Account__c = otherAccount.Id);
			insert otherListing;

			Listing__c myListing = new Listing__c(Name = 'MyListing', Account__c = cuAccount.Id);
			insert myListing;

			Application__c otherApp = new Application__c(Listing__c = otherListing.Id);
			insert otherApp;

			Application__c myDraftApp = new Application__c(Listing__c = myListing.Id, Status__c = HOP_Constants.DRAFT_APPLICATION);
			insert myDraftApp;

	        Id LENDING_AGENT_CONTACT_RTID = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Lending_Agent'].Id;
			Contact cuContact = new Contact(RecordTypeId = LENDING_AGENT_CONTACT_RTID, AccountId = cuAccount.Id, LastName = 'PMC');
	        insert cuContact;
        
	        User cuUser = new User(	UserName = 'cuUser@cuUser.comcom', Alias = 'PMU', LastName = 'PMU', Email = 'cuUser@cuUser.comcom', IsActive = true,
	        						ProfileId = communityUserProfileId, EmailEncodingKey = 'UTF-8', TimeZoneSidKey = 'America/Denver',
	        						LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ContactId = cuContact.Id);
	        insert cuUser;
        
			System.runAs(cuUser) {
				ApexPages.currentPage().getParameters().put('id', otherApp.Id);
				HOP_ApplicationFormController cnt = new HOP_ApplicationFormController();
				System.assert(cnt.hasErrors == true);

				ApexPages.currentPage().getParameters().put('id', myDraftApp.Id);
				cnt = new HOP_ApplicationFormController();
				System.assert(cnt.hasErrors == true);
			}
		Test.stopTest();
	}

	@isTest
	static void positiveTest() {
		Test.startTest();

			Account someAccount = new Account(Name = 'someAccount');
        	insert someAccount;
        	
			Listing__c someListing = new Listing__c(Name = 'someListing', Account__c = someAccount.Id);
			insert someListing;

			Application__c someApplication = new Application__c(Listing__c = someListing.Id);
			insert someApplication;

			Application_Member__c primaryApplicant = new Application_Member__c(	Application__c = someApplication.Id, Type__c = 'Primary Applicant',
																				First_Name__c = 'Primary', Last_Name__c = 'Applicant', Date_of_Birth__c = Date.today());
			insert primaryApplicant;

			Application_Member__c alternateContact = new Application_Member__c(	Application__c = someApplication.Id, Type__c = 'Alternate Contact',
																				First_Name__c = 'Alternate', Last_Name__c = 'Contact', Date_of_Birth__c = Date.today());
			insert alternateContact;
			
			Application_Member__c householdMember = new Application_Member__c(	Application__c = someApplication.Id,
																				First_Name__c = 'Household', Last_Name__c = 'Member', Date_of_Birth__c = Date.today());
			insert householdMember;
			
			someApplication.Applicant__c = primaryApplicant.Id;
			someApplication.Alternate_Contact__c = alternateContact.Id;
			someApplication.Neighborhood_Preference_Member__c = householdMember.Id;
			someApplication.DTHP_Preference_Member__c = householdMember.Id;
			someApplication.COP_Preference_Member__c = householdMember.Id;
			someApplication.Live_in_SF_Preference_Member__c = householdMember.Id;
			someApplication.Work_in_SF_Preference_Member__c = householdMember.Id;
			update someApplication;
			
			ApexPages.currentPage().getParameters().put('id', someApplication.Id);
			HOP_ApplicationFormController cnt = new HOP_ApplicationFormController();
			System.assert(cnt.hasErrors == false);
			System.assert(cnt.app.Id == someApplication.Id);

			List<Integer> householdMembersIndexes = cnt.householdMembersIndexes;
			System.assert(householdMembersIndexes.size() == 1);
			
			List<SelectOption> householdMembersSO = cnt.householdMembersSO;
			System.assert(householdMembersSO.size() == 3);

			cnt.newHouseholdMember();
			cnt.currentHouseholdMember.First_Name__c = 'Neww';
			cnt.currentHouseholdMember.Last_Name__c = 'Member';
			cnt.currentHouseholdMember.Date_of_Birth__c = Date.today();
			cnt.addHouseholdMemberAndNew();
			cnt.cancelHouseholdMember();
			
			cnt.selectedHouseholdMemberIdx = cnt.householdMembers.size() - 1;
			cnt.editHouseholdMember();
			cnt.currentHouseholdMember.First_Name__c = 'New';
			cnt.saveHouseholdMember();

			householdMembersIndexes = cnt.householdMembersIndexes;
			System.assert(householdMembersIndexes.size() == 2);
			
			householdMembersSO = cnt.householdMembersSO;
			System.assert(householdMembersSO.size() == 4);
			
			cnt.saveApplicationFormAndNew();

			List<Application_Member__c> applicationMembers = [SELECT Id FROM Application_Member__c WHERE Application__c = :someApplication.Id];
			System.assert(applicationMembers.size() == 4);

		Test.stopTest();
	}
	
}