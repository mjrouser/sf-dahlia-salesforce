// *****************************************************************************
// CLASS: API_ShortForm_PostDeleteTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Test class for API_ShortForm_PostDelete.cls and API_ApplicationService.cls
//
// *

@isTest
private without sharing class API_ShortForm_PostDeleteTest {
	private static Application__c app;
	
	private static void init() {
		Account a = new Account(Name = 'Household');
        insert a;
        
        Contact c = new Contact(FirstName = 'FirstName', LastName = 'LastName', Work_State__c = 'CO', Birthdate = date.today());
        //insert c;
        
        Listing__c listing = new Listing__c();
        insert listing;
        
        app = new Application__c(Listing__c = listing.Id, Primary_Applicant__c = c.Id, Applicant_Household__c = a.Id);
        insert app;
        
	}
	
	static testMethod void API_ShortForm_PostDeleteTest() {
        init();
        Id shortformId = app.Id;

        Test.startTest();
        	RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/shortForm/delete';
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;

            API_ShortForm_PostDelete.doPost(shortformId);

			app = API_ApplicationService.getApplicationById(shortformId);
        Test.stopTest();
        
        //check if shortform was deleted
        System.assertEquals(app, null);
    }
    
    static testMethod void failFormIdNull() {
        Test.startTest();
        	RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/shortForm/delete';
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;

            API_ShortForm_PostDelete.doPost(null);

		Test.stopTest();
        
        System.assertEquals(res.statusCode, 400);
    }
    
    static testMethod void failAppSfId() {
        Account a = new Account(Name = 'Household');
        insert a;

        Test.startTest();
        	RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/shortForm/delete';
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;

            API_ShortForm_PostDelete.doPost(a.Id);

		Test.stopTest();
        
        System.assertEquals(res.statusCode, 404);
    }
    
    static testMethod void API_ShortForm_doDeleteTest() {
        init();
        Id shortformId = app.Id;

        Test.startTest();
        	RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = 'services/apexrest/shortForm/' + shortformId;
            req.httpMethod = 'DELETE';
            RestContext.request = req;
            RestContext.response = res;

            API_ShortForm_PostDelete.doDelete();
			system.debug('shortformId::' + shortformId);
			app = API_ApplicationService.getApplicationById(shortformId);
        Test.stopTest();
        
        //check if shortform was deleted
        System.assertEquals(app, null);
    }

}