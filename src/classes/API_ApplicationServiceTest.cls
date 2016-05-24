@isTest
private without sharing class API_ApplicationServiceTest {

	static testMethod void newShortformTest() {
		API_Application.Person pa = new API_Application.Person();
		pa.lastName = 'pa';

		API_Application.Person sc = new API_Application.Person();
		sc.lastName = 'sc';
		
		API_Application.ShortForm sf = new API_Application.ShortForm();
		sf.primaryApplicant = pa;
		sf.secondaryContact = sc;
		sf.householdMembers = new List<API_Application.Person>();
		sf.householdMembers.add(pa);
		sf.householdMembers.add(sc);

		sf = API_ApplicationService.upsertShortform(sf);
		System.assertNotEquals(sf.id, null);
		System.assertNotEquals(sf.primaryApplicant.id, null);
		System.assertNotEquals(sf.secondaryContact.id, null);
		System.assertEquals(sf.householdMembers.size(), 2);
        
        List<Application__c> appList = API_ApplicationService.getApplicationsByPrimaryApplicantId(null);
        API_Application.Person person = API_ApplicationService.getPersonById(sc.Id);
        System.assertEquals(person, null);
	}

}