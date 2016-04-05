@isTest
private without sharing class API_ShortForm_PostDeleteTest {
	
	static testMethod void API_ShortForm_PostDeleteTest() {
        Account a = new Account(Name = 'Household');
        insert a;

        Contact c = new Contact(LastName = 'LastName', AccountId = a.Id);
        insert c;
        
        Application__c app = new Application__c(Primary_Applicant__c = c.Id, Applicant_Household__c = a.Id);
        insert app;
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
        
        System.assertEquals(app, null);
    }

}