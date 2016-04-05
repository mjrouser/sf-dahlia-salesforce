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
        
        System.assertEquals(c, null);
    }

}