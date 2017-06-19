@isTest
private class SfmohprgramsContactTriggerTest {
	
	private static List<Account> accts = new List<Account>();
    private static List<Contact> cons = new List<Contact>();

	static testMethod void testContactOnUpdate() {

		Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        accts.add(CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId));
        accts.add(CS_TestDataSetup.createTestAccount('Test Account 2', '1234512345', 'IT Software', rtId));
        accts.add(CS_TestDataSetup.createTestAccount('Test Account 3', '1234512345', 'IT Software', rtId));
        insert accts;
        
        Id hConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        cons.add(CS_TestDataSetup.createTestContact(accts[0].Id, 'Contact01', 'Test01', 'test@mail01.com', hConRTId));
        cons.add(CS_TestDataSetup.createTestContact(accts[1].Id, 'Contact02', 'Test02', 'test@mail02.com', hConRTId));
        cons.add(CS_TestDataSetup.createTestContact(accts[2].Id, 'Contact03', 'Test03', 'test@mail03.com', hConRTId));
        insert cons;   

        cons[0].Relationship_to_Head_of_Household__c = 'Self';
        cons[0].City__c = 'Manila';
		cons[1].Relationship_to_Head_of_Household__c = 'Self';

       	Test.startTest();
        	update cons;
        Test.stopTest();
        
		cons = new List<Contact>([SELECT City__c,Account.City__c FROM Contact WHERE Id = :cons[0].Id]);            
		System.assert(cons[0].Account.City__c == cons[0].City__c);
    }
}