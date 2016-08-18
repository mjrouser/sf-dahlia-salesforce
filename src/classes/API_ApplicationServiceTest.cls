@isTest
private without sharing class API_ApplicationServiceTest {

    static testMethod void newShortformTest() {
        Account a = new Account(Name = 'Household');
        insert a;
        
        date myDate = date.newInstance(1998, 10, 21);
        Contact c = new Contact(FirstName = 'FirstName', LastName = 'LastName', AccountId = a.Id, Work_State__c = 'CO', Birthdate = myDate);
        insert c;

        Listing__c listing = new Listing__c();
        insert listing;
        
        Application__c app = new Application__c(Listing__c = listing.Id, Applicant_Household__c = a.Id, Primary_Applicant__c = c.id, Lottery_Number_Manual__c = '2');
        
        Application_Member__c appM = new Application_Member__c(Contact__c = c.Id, First_Name__c = 'Test', Last_Name__c = 'Test Name', Date_of_Birth__c = myDate, Type__c = 'Household Member');
        
        Application_Member__c appM1 = new Application_Member__c(Contact__c = c.Id, First_Name__c = 'Test');
        
        API_Application.Person pa = new API_Application.Person();
        pa.lastName = 'pa';
        pa.firstname = 'fa';
        pa.contactId = c.Id;
        pa.DOB = c.Birthdate;

        API_Application.Person sc = new API_Application.Person(appM);
        
        API_Application.ShortForm sf = new API_Application.ShortForm();
        sf.alternateContact = pa;
        sf.householdMembers = new List<API_Application.Person>();
        sf.householdMembers.add(sc);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/shortForm';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(sf));
        RestContext.request = req;
        RestContext.response = res;

        sf = API_ShortForm.doPost();
      
        System.assertNotEquals(sf.Id, null);
        System.assertEquals(sf.primaryApplicant, null);
        System.assertEquals(sf.householdMembers.size(), 1);
        
        sf.primaryApplicant = sc;
        System.assertEquals(API_ApplicationService.upsertShortform(sf).primaryApplicant.appMemberId, appM.Id);
        sf.householdMembers.add(pa);
        System.assertEquals(sf.householdMembers.size(), 2);
        

        
        System.assertEquals(API_ApplicationService.getPersonByApplicationMemberId(appM.id).contactId, c.id);
        System.assertEquals(API_ApplicationService.getApplicationMemberByContactId(c.id).size(), 3);
        
        
        
    }
    
    static testMethod void existingShortformTest() {
        Account a = new Account(Name = 'Household');
        insert a;
        
        date myDate = date.newInstance(1998, 10, 21);
        Contact c = new Contact(FirstName = 'FirstName', LastName = 'LastName', AccountId = a.Id, Work_State__c = 'CO', Birthdate = myDate);
        insert c;

        Listing__c listing = new Listing__c();
        insert listing;
        
        Application__c app = new Application__c( Applicant_Household__c = a.Id, Lottery_Number_Manual__c = '2', Listing__c = listing.Id);
        insert app;
        
        Application_Member__c appM = new Application_Member__c(Application__c = app.Id, Contact__c = c.Id, First_Name__c = 'Test', Last_Name__c = 'Test Name', Date_of_Birth__c = myDate, Type__c = 'Household Member');
        insert appM;
        
        Application_Member__c appM1 = new Application_Member__c(Application__c = app.Id, Contact__c = c.Id, First_Name__c = 'Test');
        insert appM1;
        
        API_Application.Person pa = new API_Application.Person(c);
        
        API_Application.Person sc = new API_Application.Person(appM);
        
        List<Application_Member__c> appMList = new List<Application_Member__c>();
        appMList.add(appM);
        appMList.add(appM1);
        
        API_Application.ShortForm sf = new API_Application.ShortForm(app,appMList);
        sf.primaryApplicant = pa;
        sf.alternateContact = sc;
        System.assertEquals(API_ApplicationService.upsertShortform(sf).Id, app.id);
        
        
    }
    static testMethod void getShortformsByContactIdTest() {
        Account a = new Account(Name = 'Household');
        insert a;
        
        date myDate = date.newInstance(1998, 10, 21);
        Contact c = new Contact(FirstName = 'FirstName', LastName = 'LastName', AccountId = a.Id, Work_State__c = 'CO', Birthdate = myDate);
        insert c;

        Listing__c listing = new Listing__c();
        insert listing;
        
        Application__c app = new Application__c(Listing__c = listing.id, Applicant_Household__c = a.Id, Lottery_Number_Manual__c = '2', Primary_Applicant__c = c.id);
        insert app;
        
        Application_Member__c appM = new Application_Member__c(Application__c = app.Id, Contact__c = c.Id, First_Name__c = 'Test', Last_Name__c = 'Test Name', Date_of_Birth__c = myDate, Type__c = 'Household Member');
        insert appM;
        
        Application_Member__c appM1 = new Application_Member__c(Application__c = app.Id, Contact__c = c.Id, First_Name__c = 'Test');
        insert appM1;
        
        API_Application.Person pa = new API_Application.Person(c);
        
        API_Application.Person sc = new API_Application.Person(appM);
        
        List<Application_Member__c> appMList = new List<Application_Member__c>();
        appMList.add(appM);
        appMList.add(appM1);
        
        System.assertEquals(API_ApplicationService.getShortformsByContactId(c.id).size(), 1);
        System.assertEquals(API_ApplicationService.getPersonById(c.id).contactId, c.id);
        
        
    }

}