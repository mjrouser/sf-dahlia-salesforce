@isTest
private without sharing class API_ShortFormTest {
	
	static testMethod void API_ShortForm_GetTest() {
        Account a = new Account(Name = 'Household');
        insert a;

        Contact c = new Contact(LastName = 'LastName', AccountId = a.Id);
        insert c;

        Application__c app = new Application__c(Primary_Applicant__c = c.Id, Applicant_Household__c = a.Id);
        insert app;
        
        Test.startTest();
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/shortForm/' + app.Id;
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;

            API_Application.ShortForm sf = API_ShortForm.doGet();
        Test.stopTest();
        
        System.assertEquals(sf.id, app.Id);
    }

	static testMethod void API_ShortForm_PostTest() {
        Account a = new Account(Name = 'Household');
        insert a;

        Contact c = new Contact(LastName = 'LastName', AccountId = a.Id);
        insert c;

        Application__c app = new Application__c(Primary_Applicant__c = c.Id, Applicant_Household__c = a.Id);
        insert app;
        
        API_Application.ShortForm sf = API_ApplicationService.getShortformById(app.Id);
        sf.worksInSanFrancisco = true;
        sf.primaryApplicant.workState = 'CO';
        sf.householdMembers = new List<API_Application.Person>();

        Test.startTest();
        	RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/shortForm';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(JSON.serialize(sf));
            RestContext.request = req;
            RestContext.response = res;

            API_ShortForm.doPost();

			app = API_ApplicationService.getApplicationById(app.id);
        Test.stopTest();
        
        System.assertEquals(app.Works_In_SF__c, true);
        System.assertEquals(app.Primary_Applicant__r.Work_State__c, 'CO');
    }
    
    static testMethod void failAPI_ShortForm_GetTest() {
        Account a = new Account(Name = 'Household');
        insert a;

        Contact c = new Contact(LastName = 'LastName', AccountId = a.Id);
        insert c;

        Application__c app = new Application__c(Primary_Applicant__c = c.Id, Applicant_Household__c = a.Id);
        insert app;
        
        Test.startTest();
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/shortForm/fail/' + app.Id;
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;

            API_Application.ShortForm sf = API_ShortForm.doGet();
        Test.stopTest();
        
        System.assertEquals(res.statusCode, 400);
    }
    
}