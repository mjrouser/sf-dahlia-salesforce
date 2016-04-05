@isTest
private without sharing class API_ShortForm_GetListByContactIdTest {
	
	static testMethod void API_ShortForm_GetListByContactIdTest() {
		Account a = new Account(Name = 'Household');
        insert a;

        Contact c = new Contact(LastName = 'LastName', AccountId = a.Id);
        insert c;

        Application__c app = new Application__c(Primary_Applicant__c = c.Id, Applicant_Household__c = a.Id);
        insert app;
        
        Test.startTest();
        	RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/shortForm/list/' + c.Id;
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;

            List<API_Application.ShortForm> sfs = API_ShortForm_GetListByContactId.doGet();
        Test.stopTest();
        
        System.assertEquals(sfs.size(), 1);
        System.assertEquals(sfs[0].primaryApplicant.id, c.Id);
	}

}