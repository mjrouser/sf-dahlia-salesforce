@isTest
private class SfmohprogramsFinAppIncomeTriggerTest {
	
	private static Account acc;
    private static Contact con;
    private static List<Properties__c> lProperties = new List<Properties__c>();
    private static List<Housing_Application__c> housingApps = new List<Housing_Application__c>();
    private static List<Financial_Application__c> finApps = new List<Financial_Application__c>();
    private static List<Financial_Application_Member__c> finAppMembers = new List<Financial_Application_Member__c>();
    private static List<Financial_Application_Income__c> finAppIncomes = new List<Financial_Application_Income__c>();
    private static User hUser;

	static void testData(){
		Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
        insert acc;
        System.assertNotEquals(null, acc.Id);
        
        Id lenderConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        con = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', lenderConRTId);
        insert con;        
        System.assertNotEquals(null, con.Id);
            
        Id mohcdHouseholdProfileId = [SELECT Id FROM Profile WHERE Name = :StringConstants.HOUSEHOLD_PROFILE LIMIT 1].Id;
        hUser = CS_TestDataSetup.createTestPortalUser('FName1', 'LName1', 'test1@fakemail.com', mohcdHouseholdProfileId, con.Id);
        insert hUser;
	}
	
	static testMethod void testFAppIncomeOnInsert() {

		testData();

        System.runAs(hUser){

	        Id propRtId = Schema.SObjectType.Properties__c.getRecordTypeInfosByName().get('Property').getRecordTypeId();
	        lProperties.add(CS_TestDataSetup.createTestProperties(130000, 'Rental', 4.5, 2, 'New', 'Condo', 'Castro', propRtId));           
	        lProperties.add(CS_TestDataSetup.createTestProperties(130000, 'Ownership', 4.5, 2, 'New', 'Apartment', 'Castro', propRtId));
	        lProperties.add(CS_TestDataSetup.createTestProperties(130000, 'Rental', 4.5, 2, 'New', 'Condo', 'Castro', propRtId));           
	        insert lProperties;       

	        housingApps.add(CS_TestDataSetup.createHousingApplication(lProperties[0].Id, 'Submitted'));
	        housingApps.add(CS_TestDataSetup.createHousingApplication(lProperties[1].Id, 'Submitted'));
	        housingApps.add(CS_TestDataSetup.createHousingApplication(lProperties[2].Id, 'Submitted'));
	        insert housingApps;

			Id dalpRTId = Schema.SObjectType.Financial_Application__c.getRecordTypeInfosByName().get('DALP').getRecordTypeId();        
        	finApps.add(CS_TestDataSetup.createFinancialApplication(housingApps[0].Id, 'Submitted', acc.Id, dalpRTId, con.Id));
        	finApps.add(CS_TestDataSetup.createFinancialApplication(housingApps[1].Id, 'Submitted', acc.Id, dalpRTId, con.Id));
        	finApps.add(CS_TestDataSetup.createFinancialApplication(housingApps[2].Id, 'Submitted', acc.Id, dalpRTId, con.Id));
        	insert finApps;

        	finAppMembers.add(CS_TestDataSetup.createFinancialApplicationMember(finApps[0].Id, 'Primary Borrower', 'Test', 'Member', System.today()-10000, 'Spouse'));
        	finAppMembers.add(CS_TestDataSetup.createFinancialApplicationMember(finApps[0].Id, 'Primary Borrower', 'Test', 'Member', System.today()-10000, 'Spouse'));
        	finAppMembers.add(CS_TestDataSetup.createFinancialApplicationMember(finApps[0].Id, 'Primary Borrower', 'Test', 'Member', System.today()-10000, 'Spouse'));
        	insert finAppMembers;

        	Id fimIncomeRTId = Schema.SObjectType.Financial_Application_Income__c.getRecordTypeInfosByName().get('Unemployed').getRecordTypeId();        
        	finAppIncomes.add(CS_TestDataSetup.createFinancialApplicationMemberIncome(finApps[0].Id, finAppMembers[0].Id, fimIncomeRTId));
        	finAppIncomes.add(CS_TestDataSetup.createFinancialApplicationMemberIncome(finApps[0].Id, finAppMembers[1].Id, fimIncomeRTId));
        	finAppIncomes.add(CS_TestDataSetup.createFinancialApplicationMemberIncome(finApps[0].Id, finAppMembers[2].Id, fimIncomeRTId));

        	Test.startTest();
        		insert finAppIncomes;
        	Test.stopTest();
            
        	Set<Id> fIncomesIds = new Set<Id>();

            for(Financial_Application_Income__c fAppInc : finAppIncomes){
            	fIncomesIds.add(fAppInc.Id);
            }

			finAppIncomes = new List<Financial_Application_Income__c>([SELECT Financial_Application__c 
									FROM Financial_Application_Income__c WHERE Id IN :fIncomesIds]);            

			for(Integer i=0;i<finAppIncomes.size();i++){
				System.assert(finAppIncomes[i].Financial_Application__c != null);
			}
        }
    }
}