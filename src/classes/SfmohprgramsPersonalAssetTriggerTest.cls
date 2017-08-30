@isTest
private class SfmohprgramsPersonalAssetTriggerTest {
		
	private static List<Account> accts = new List<Account>();
    private static List<Contact> cons = new List<Contact>();
    private static List<Personal_Asset__c> pAssets = new List<Personal_Asset__c>();
    private static User hUser;

	static testMethod void testPAssetOnInsert() {

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

        Id pAssetRTId = Schema.SObjectType.Personal_Asset__c.getRecordTypeInfosByName().get('Assets with an Account').getRecordTypeId();
        pAssets.add(new Personal_Asset__c(Household_Member__c=cons[0].Id, RecordTypeId =pAssetRTId));
		pAssets.add(new Personal_Asset__c(Household_Member__c=cons[1].Id, RecordTypeId =pAssetRTId));
		pAssets.add(new Personal_Asset__c(Household_Member__c=cons[2].Id, RecordTypeId =pAssetRTId));            

       	Test.startTest();
        	insert pAssets;
        Test.stopTest();
        
        Set<Id> pAssetIds = new Set<Id>();

        for(Personal_Asset__c pAss : pAssets){
            	pAssetIds.add(pAss.Id);
        }

		pAssets = new List<Personal_Asset__c>([SELECT Household_Account__c 
						FROM Personal_Asset__c WHERE Id IN :pAssetIds]);            

		for(Integer i=0;i<pAssets.size();i++){
			System.assert(pAssets[i].Household_Account__c != null);
		}
    }
	
}