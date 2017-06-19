@isTest
private class SfmohprgramsPersonalIncomeTriggerTest {
	
	private static List<Account> accts = new List<Account>();
    private static List<Contact> cons = new List<Contact>();
    private static List<Personal_Income__c> pIncomes = new List<Personal_Income__c>();
    private static User hUser;

	static testMethod void testPIncomeOnInsert() {

		Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        accts.add(CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId));
        accts.add(CS_TestDataSetup.createTestAccount('Test Account 2', '1234512345', 'IT Software', rtId));
        accts.add(CS_TestDataSetup.createTestAccount('Test Account 3', '1234512345', 'IT Software', rtId));
        insert accts;
        
        Id hConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        cons.add(CS_TestDataSetup.createTestContact(accts[0].Id, 'Contact01', 'Test01', 'test@mail01.com', hConRTId));
        cons.add(CS_TestDataSetup.createTestContact(accts[0].Id, 'Contact02', 'Test02', 'test@mail02.com', hConRTId));
        cons.add(CS_TestDataSetup.createTestContact(accts[0].Id, 'Contact03', 'Test03', 'test@mail03.com', hConRTId));
        insert cons;   

		Id pIncomeRTId = Schema.SObjectType.Personal_Income__c.getRecordTypeInfosByName().get('Employment Income').getRecordTypeId();
        pIncomes.add(new Personal_Income__c(Household_Member__c=cons[0].Id, RecordTypeId =pIncomeRTId));
		pIncomes.add(new Personal_Income__c(Household_Member__c=cons[1].Id, RecordTypeId =pIncomeRTId));
		pIncomes.add(new Personal_Income__c(Household_Member__c=cons[2].Id, RecordTypeId =pIncomeRTId));            

       	Test.startTest();
        	insert pIncomes;
        Test.stopTest();
        
        Set<Id> pIncomeIds = new Set<Id>();

        for(Personal_Income__c pInc : pIncomes){
            	pIncomeIds.add(pInc.Id);
        }

		pIncomes = new List<Personal_Income__c>([SELECT Household_Account__c 
						FROM Personal_Income__c WHERE Id IN :pIncomeIds]);            

		for(Integer i=0;i<pIncomes.size();i++){
			System.assert(pIncomes[i].Household_Account__c != null);
		}
    }
}