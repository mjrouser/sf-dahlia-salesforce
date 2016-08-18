@isTest
private without sharing class API_ShortFormTest {
   	
    private static Leasing_Settings__c leasingSettings;
    
    private static void init() {
        leasingSettings = new Leasing_Settings__c(SetupOwnerId=UserInfo.getOrganizationId(), Default_Owner__c=UserInfo.getUserId());
        insert leasingSettings;
    }
	
    /*
     * get shortform
    */
	static testMethod void API_ShortForm_GetTest() {
        Account a = new Account(Name = 'Household');
        insert a;

        Contact c = new Contact(LastName = 'LastName', AccountId = a.Id, Work_State__c = 'CO');
        insert c;

		Listing__c listing = new Listing__c();
        insert listing;
        
        Application__c app = new Application__c( Applicant_Household__c = a.Id, Listing__c = listing.Id);
        insert app;
        
        Application_Member__c appM = new Application_Member__c(Application__c = app.Id, Contact__c = c.Id, First_Name__c = 'Test');
        insert appM;
            
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
    
    /*
     * call GET without Id should fail
    */
    static testMethod void API_ShortForm_failGetTest() {
       Test.startTest();
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/shortForm/';
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;

            API_Application.ShortForm sf = API_ShortForm.doGet();
        Test.stopTest();
        
    }
    
    /*
    * method used to check if new household Contact and Account record types are set, household members are updated
    */
    static testMethod void API_ShortForm_Post_updateHouseholdMembers() {
        init();
        
        Account a = new Account(Name = 'Household');
        
        Contact c = new Contact(FirstName = 'FirstName', LastName = 'LastName', Work_State__c = 'CO', Birthdate = date.today());
        
        Application__c app = new Application__c(Primary_Applicant__c = c.Id, Applicant_Household__c = a.Id);
        
        Application_Member__c appM = new Application_Member__c(Application__c = app.Id, Work_in_SF__c = True, First_Name__c = 'Name', Last_Name__c = 'LastName', Date_of_Birth__c = date.today());
        Application_Member__c alternateContact = new Application_Member__c(Application__c = app.Id, Work_in_SF__c = True, First_Name__c = 'Name1', Last_Name__c = 'LastName1', Date_of_Birth__c = date.today());
        
        Listing__c listing = new Listing__c();
        insert listing;
        
        API_Application.ShortForm sf = new API_Application.ShortForm(app, new List<Application_Member__c>{appM});
        sf.primaryApplicant = new API_Application.Person(c);
        sf.alternateContact = new API_Application.Person(alternateContact);
        sf.worksInSanFrancisco = true;
        sf.listingID = listing.Id;
        
        Test.startTest();
        	RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/shortForm';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(JSON.serialize(sf));
            RestContext.request = req;
            RestContext.response = res;

            API_Application.ShortForm resSf = API_ShortForm.doPost();
			
		Test.stopTest();
        
        Id accoutHouseholdRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        Id contactApplicantRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Applicant').getRecordTypeId();
        
        Contact cnt = API_ApplicationService.getContactById(resSf.primaryApplicant.contactId);
        //check if household contact Record type is 'Household'
        System.assertEquals(cnt.RecordTypeId, contactApplicantRTId);
        //check if household account Record type is 'Household'
        System.assertEquals(API_ApplicationService.getHouseholdById(cnt.AccountId).RecordTypeId, accoutHouseholdRTId);
        
        resSf.PrimaryApplicant.FirstName = 'Changed Name';
        resSf.alternateContact.FirstName = 'Changed Name1';
        resSf.householdMembers[0].FirstName = 'Changed Name2';
        req = new RestRequest();
        res = new RestResponse();
        req.requestURI = '/shortForm';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(resSf));
        RestContext.request = req;
        RestContext.response = res;
		
		resSf = API_ShortForm.doPost();
		//check if primary applicant was updated
        System.assertEquals(resSf.PrimaryApplicant.FirstName, 'Changed Name');
        //check if alternate contact was updated
        System.assertEquals(resSf.alternateContact.FirstName, 'Changed Name1');
        //check if household member was updated
        System.assertEquals(resSf.householdMembers[0].FirstName, 'Changed Name2');
        
    }
    
    /*
    * method used to check household members that are not in the request are deleted and the existing are updated
    */
    static testMethod void API_ShortForm_Post_DeleteApplicationMembers() {
        init();
        
        Listing__c listing = new Listing__c();
        insert listing;
        
        Application__c app = new Application__c(Listing__c = listing.Id);
        insert app;
        
        List<Application_Member__c> appMList = new List<Application_Member__c>();
        Application_Member__c appM = new Application_Member__c(Application__c = app.Id, Work_in_SF__c = True);
        appMList.add(appM);
        
            
        Application_Member__c appM1 = new Application_Member__c(Application__c = app.Id, Work_in_SF__c = True);
        appMList.add(appM1);
        insert appMList;
        
        API_Application.ShortForm sf = new API_Application.ShortForm(app, new List<Application_Member__c>{appM, appM1});
        sf.worksInSanFrancisco = true;
        sf.listingID = listing.Id;
        
        Test.startTest();
        	RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/shortForm';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(JSON.serialize(sf));
            RestContext.request = req;
            RestContext.response = res;

            API_Application.ShortForm resSf = API_ShortForm.doPost();
            system.assertEquals(resSf.householdMembers.size(), 2);
            
            appM.First_Name__c = 'Test';
            sf = new API_Application.ShortForm(app, new List<Application_Member__c>{appM});
			
			req = new RestRequest();
            res = new RestResponse();
            req.requestURI = '/shortForm';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(JSON.serialize(sf));
            RestContext.request = req;
            RestContext.response = res;
			
			resSf = API_ShortForm.doPost();
        	//check if hosehold members are deleted
            system.assertEquals(resSf.householdMembers.size(), 1);
        	//check if household members are updated
            system.assertEquals(resSf.householdMembers[0].FirstName, 'Test');
		Test.stopTest();
    }
    
    /*
    * method used to check if natural keys are set
    */
    static testMethod void API_ShortForm_Post_SetNaturalKeys() {
        init();
        
        Account a = new Account(Name = 'Household');
        
        Contact c = new Contact(FirstName = 'FirstName', LastName = 'LastName', Work_State__c = 'CO', Birthdate = date.today());
        
        Application__c app = new Application__c(Primary_Applicant__c = c.Id, Applicant_Household__c = a.Id);
        
        Application_Member__c appM = new Application_Member__c(Application__c = app.Id, Work_in_SF__c = True);
        
        Listing__c listing = new Listing__c();
        insert listing;
        
        API_Application.ShortForm sf = new API_Application.ShortForm(app, new List<Application_Member__c>{appM});
        sf.primaryApplicant = new API_Application.Person(c);
        sf.worksInSanFrancisco = true;
        sf.listingID = listing.Id;
        API_Application.Person p = new API_Application.Person(c);
        sf.liveInSfPreferenceNatKey = p.getKey();
        sf.workInSfPreferenceNatKey = p.getKey();
        sf.displacedPreferenceNatKey = p.getKey();
        sf.certOfPreferenceNatKey = p.getKey();
        sf.neighborhoodResidencePreferenceNatKey = p.getKey();
        
        Test.startTest();
        	RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/shortForm';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(JSON.serialize(sf));
            RestContext.request = req;
            RestContext.response = res;

            API_Application.ShortForm resSf = API_ShortForm.doPost();
			
		Test.stopTest();
        
        //check if natural keys are set
        System.assert(resSf.liveInSfPreferenceID != null);
        System.assert(resSf.worksInSfPreferenceID != null);
        System.assert(resSf.displacedPreferenceID != null);
        System.assert(resSf.certOfPreferenceID != null);
        System.assert(resSf.neighborhoodPreferenceID != null);
        
    }
    
    /*
    * method used to check if shortform is created
    */
    static testMethod void API_ShortForm_Post_insertAndUpdateShortform() {
        init();
        
        Application__c app = new Application__c();
        
        Listing__c listing = new Listing__c();
        insert listing;
        
        API_Application.ShortForm sf = new API_Application.ShortForm(app, new List<Application_Member__c>());
        sf.listingID = listing.Id;
        
        Test.startTest();
        	RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/shortForm';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(JSON.serialize(sf));
            RestContext.request = req;
            RestContext.response = res;

            API_Application.ShortForm resSf = API_ShortForm.doPost();
        	//check is shortform is created
			system.assert(resSf.Id != null);
        
        	Application_Member__c primaryApplicant = new Application_Member__c(Work_in_SF__c = True, First_Name__c = 'Name', Last_Name__c = 'LastName', Date_of_Birth__c = date.today());
            Application_Member__c alternateContact = new Application_Member__c(Work_in_SF__c = True, First_Name__c = 'Name1', Last_Name__c = 'LastName1', Date_of_Birth__c = date.today());
            Application_Member__c appMember = new Application_Member__c(Work_in_SF__c = True, First_Name__c = 'Name2', Last_Name__c = 'LastName2', Date_of_Birth__c = date.today());
        	
        	resSf.primaryApplicant = new API_Application.Person(primaryApplicant);
        	resSf.alternateContact = new API_Application.Person(alternateContact);
        	resSf.householdMembers = new List<API_Application.Person>{new API_Application.Person(appMember)};
        	
        	req = new RestRequest();
            res = new RestResponse();
            req.requestURI = '/shortForm';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueOf(JSON.serialize(resSf));
            RestContext.request = req;
            RestContext.response = res;
        	resSf = API_ShortForm.doPost();
        
        	//check if primary & alternate contact & household members are created
			system.assert(resSf.primaryApplicant.appMemberId != null);
        	system.assert(resSf.primaryApplicant.contactId != null);
        	system.assert(resSf.alternateContact.appMemberId != null);
        	system.assert(resSf.householdMembers[0].appMemberId != null);
        	
        	Contact c = [SELECT Id, Account.OwnerId from Contact WHERE Id = :resSf.primaryApplicant.contactId];
        	
		Test.stopTest();
    }
}