// *****************************************************************************
// CLASS: ListingApplicationMemberDuplicateActionTest
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 2016-11-02
// Description: Test class for ApplicationMemberDuplicateAction
//            
// *****************************************************************************
// MODIFICATIONS:  NOTE MOD#, DATE of mod, who made the change and description
// *****************************************************************************
// 
// *****************************************************************************
@isTest
private class ListingApplicationMemberDuplicateTest {
    
    @isTest static void ListingApplicationMemberDuplicateActionTest() {
        Test.startTest();

            Account acc = new Account(Name = 'someAccount');
            insert acc;
            
            Listing__c lst = new Listing__c(Name = 'someListing', Account__c = acc.Id);
            insert lst;

            Application__c draftApp = new Application__c(Listing__c = lst.Id, Status__c = 'Draft');
            Application__c submittedApp = new Application__c(Listing__c = lst.Id, Status__c = 'Submitted');
            insert new List<Application__c> {draftApp, submittedApp};

            Application_Member__c draftApplicant = new Application_Member__c(Application__c = draftApp.Id, Type__c = 'Primary Applicant',
                                                                             First_Name__c = 'Draft', Last_Name__c = 'Applicant', Date_of_Birth__c = Date.today());
            Application_Member__c primaryApplicant = new Application_Member__c(Application__c = submittedApp.Id, Type__c = 'Primary Applicant',
                                                                               First_Name__c = 'Primary', Last_Name__c = 'Applicant', Date_of_Birth__c = Date.today());
            Application_Member__c alternateContact = new Application_Member__c(Application__c = submittedApp.Id, Type__c = 'Alternate Contact',
                                                                               First_Name__c = 'Alternate', Last_Name__c = 'Contact', Date_of_Birth__c = Date.today());
            Application_Member__c householdMember = new Application_Member__c(Application__c = submittedApp.Id, Type__c = 'Household Member',
                                                                              First_Name__c = 'Household', Last_Name__c = 'Member', Date_of_Birth__c = Date.today());
            insert new List<Application_Member__c> {draftApplicant, primaryApplicant, alternateContact, householdMember};



            draftApplicant = [SELECT isFiltered__c FROM Application_Member__c WHERE Id = :draftApplicant.Id];
            System.assert(draftApplicant.isFiltered__c == 'TRUE');

            primaryApplicant = [SELECT isFiltered__c FROM Application_Member__c WHERE Id = :primaryApplicant.Id];
            System.assert(primaryApplicant.isFiltered__c != 'TRUE');

            alternateContact = [SELECT isFiltered__c FROM Application_Member__c WHERE Id = :alternateContact.Id];
            System.assert(alternateContact.isFiltered__c == 'TRUE');

            householdMember = [SELECT isFiltered__c FROM Application_Member__c WHERE Id = :householdMember.Id];
            System.assert(householdMember.isFiltered__c != 'TRUE');

        Test.stopTest();
    }
    
}