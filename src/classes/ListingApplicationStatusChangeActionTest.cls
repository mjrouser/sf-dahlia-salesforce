// *****************************************************************************
// CLASS: ApplicationStatusChangeActionTest
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 2016-11-02
// Description: Test class for ApplicationStatusChangeAction
//            
// *****************************************************************************
// MODIFICATIONS:  NOTE MOD#, DATE of mod, who made the change and description
// *****************************************************************************
// 
// *****************************************************************************
@isTest
private class ListingApplicationStatusChangeActionTest {
	
	@isTest static void ApplicationStatusChangeActionTest() {
        Test.startTest();

            Account acc = new Account(Name = 'someAccount');
            insert acc;
            
            Listing__c lst = new Listing__c(Name = 'someListing', Account__c = acc.Id);
            insert lst;

            Application__c app = new Application__c(Listing__c = lst.Id, Status__c = 'Draft');
            insert app;

            Application_Member__c primaryApplicant = new Application_Member__c(
                Application__c = app.Id, Type__c = 'Primary Applicant',
                First_Name__c = 'Primary', Last_Name__c = 'Applicant', Date_of_Birth__c = Date.today()
            );
            insert primaryApplicant;

			primaryApplicant = [SELECT isFiltered__c FROM Application_Member__c WHERE Id = :primaryApplicant.Id];
            System.assert(primaryApplicant.isFiltered__c == 'TRUE');

            app.Status__c = 'Submitted';
            update app;

            primaryApplicant = [SELECT isFiltered__c FROM Application_Member__c WHERE Id = :primaryApplicant.Id];
            System.assert(primaryApplicant.isFiltered__c != 'TRUE');

            app.Status__c = 'Draft';
            update app;

            primaryApplicant = [SELECT isFiltered__c FROM Application_Member__c WHERE Id = :primaryApplicant.Id];
            System.assert(primaryApplicant.isFiltered__c == 'TRUE');

        Test.stopTest();
    }
	
}