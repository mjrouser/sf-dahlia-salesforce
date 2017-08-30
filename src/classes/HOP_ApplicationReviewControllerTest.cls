// *****************************************************************************
// CLASS: HOP_ApplicationReviewControllerTest
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Test class for the HOP_ApplicationReviewController class.
//
// *****************************************************************************

@isTest
private class HOP_ApplicationReviewControllerTest {
    
    @isTest
    static void emptyIdTest() {
        Test.startTest();
            HOP_ApplicationReviewController cnt = new HOP_ApplicationReviewController();
            System.assert(cnt.hasErrors == true);
        Test.stopTest();
    }
    
    @isTest
    static void badIdTest() {
        Test.startTest();
            ApexPages.currentPage().getParameters().put('id', UserInfo.getUserId());
            HOP_ApplicationReviewController cnt = new HOP_ApplicationReviewController();
            System.assert(cnt.hasErrors == true);
        Test.stopTest();
    }

    @isTest
    static void communityUser_diffAccountTest() {
        Test.startTest();

            List<Profile> communityUserProfiles = [SELECT Id FROM Profile WHERE UserLicense.Name = :HOP_Constants.COMMUNITY_LICENSE_NAME LIMIT 1];
            if (communityUserProfiles.size() == 0) return;
            Id communityUserProfileId = communityUserProfiles[0].Id;

            Account otherAccount = new Account(Name = 'OA');
            insert otherAccount;
            
            Listing__c listing = new Listing__c(Name = 'MyListing', Account__c = otherAccount.Id);
            insert listing;

            Flagged_Record_Set__c frs = new Flagged_Record_Set__c(Listing__c = listing.Id);
            insert frs;

            Id PROPERTY_MANAGEMENT_ACCOUNT_RTID = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Property_Management'].Id;
            Account cuAccount = new Account(RecordTypeId = PROPERTY_MANAGEMENT_ACCOUNT_RTID, Name = 'PMA');
            insert cuAccount;
        
            Id LENDING_AGENT_CONTACT_RTID = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Lending_Agent'].Id;
            Contact cuContact = new Contact(RecordTypeId = LENDING_AGENT_CONTACT_RTID, AccountId = cuAccount.Id, LastName = 'PMC');
            insert cuContact;
        
            User cuUser = new User( UserName = 'cuUser@cuUser.comcom', Alias = 'PMU', LastName = 'PMU', Email = 'cuUser@cuUser.comcom', IsActive = true,
                                    ProfileId = communityUserProfileId, EmailEncodingKey = 'UTF-8', TimeZoneSidKey = 'America/Denver',
                                    LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ContactId = cuContact.Id);
            insert cuUser;
        
            System.runAs(cuUser) {
                ApexPages.currentPage().getParameters().put('id', frs.Id);
                HOP_ApplicationReviewController cnt = new HOP_ApplicationReviewController();
                System.assert(cnt.hasErrors == true);
            }
        Test.stopTest();
    }
    
    @isTest
    static void updateTest() {
        
        HOP_ApplicationReviewController obj = new  HOP_ApplicationReviewController();
        Flagged_Application__c FARec =[select id,Application__c from Flagged_Application__c limit 1];
         Test.startTest();
            obj.getItems();                                                             
            obj.flaggedApplicationId=FARec.id;
            obj.applicationId=FARec.Application__c;
            obj.applicationName=FARec.Application__c;
            obj.pApplicant=FARec.Application__c;
            obj.ReviewStatus='Pending Review';
            obj.updateFlaggedApplication();
            Flagged_Application__c FARec2 =[select id,Review_Status__c,createddate,lastmodifieddate from Flagged_Application__c where id=:FARec.id];
            system.assertEquals(FARec2.Review_Status__c,'Pending Review');
        Test.stopTest();
    }
    @testsetup static void setupData(){
            Account otherAccount = new Account(Name = 'OthAcc');
            insert otherAccount;
            
            Listing__c listing = new Listing__c(Name = 'testListing', Account__c = otherAccount.Id);
            insert listing;

            Flagged_Record_Set__c frs = new Flagged_Record_Set__c(Listing__c = listing.Id);
            insert frs;

            
        
            Application__c appRec = new Application__c(Listing__c=listing.id);
            insert appRec;
        
            Flagged_Application__c FARec = new Flagged_Application__c(Application__c=appRec.id,Flagged_Record_Set__c=FRS.id);
            insert FARec;
    }
    
}