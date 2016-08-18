// *****************************************************************************
// CLASS: API_ShortForm_PostContactDeleteTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Test class for API_ShortForm_PostContactDelete.cls and API_ApplicationService.cls
//
// *
@isTest
private without sharing class API_ShortForm_PostContactDeleteTest {
	
	static testMethod void API_ShortForm_PostContactDeleteTest() {
        Account a = new Account(Name = 'Household');
        insert a;

        Contact c = new Contact(LastName = 'LastName', AccountId = a.Id);
        insert c;
        Id contactId = c.Id;

        Test.startTest();
        	RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/shortForm/contact/delete';
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;

            API_ShortForm_PostContactDelete.doPost(contactId);

			c = API_ApplicationService.getContactById(contactId);
        Test.stopTest();
        
        //check if contact was deleted
        System.assertEquals(c, null);
    }
    
    static testMethod void failAPI_ShortForm_PostContactDeleteTest() {
        Test.startTest();
        	RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/shortForm/contact/delete';
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;

            API_ShortForm_PostContactDelete.doPost(null);

		Test.stopTest();
        
        System.assertEquals(res.StatusCode, 400);
    }
    
    static testMethod void failInvalidId() {
        Account a = new Account(Name = 'Household');
        insert a;

        Test.startTest();
        	RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/shortForm/contact/delete';
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;

            API_ShortForm_PostContactDelete.doPost(a.Id);

		Test.stopTest();
        
        System.assertEquals(res.StatusCode, 404);
    }

}