@isTest
private class SfmohprogramsFinAppTriggerTest {
	
	private static Account acc;
    private static Contact con;
    private static List<Properties__c> lProperties = new List<Properties__c>();
    private static List<Housing_Application__c> housingApps = new List<Housing_Application__c>();
    private static List<Financial_Application__c> finApps = new List<Financial_Application__c>();
    private static User hUser;

	static void testData(){
		Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
        insert acc;
        
        Id lenderConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        con = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', lenderConRTId);
        insert con;        
        
        Id pIncomeRTId = Schema.SObjectType.Personal_Income__c.getRecordTypeInfosByName().get('Employment Income').getRecordTypeId();
        Personal_Income__c pIncome = new Personal_Income__c(Household_Account__c=acc.Id,Household_Member__c=con.Id, RecordTypeId =pIncomeRTId);
        insert pIncome;

        Id pAssetRTId = Schema.SObjectType.Personal_Asset__c.getRecordTypeInfosByName().get('Assets with an Account').getRecordTypeId();
        Personal_Asset__c pAsset = new Personal_Asset__c(Household_Account__c=acc.Id,Household_Member__c=con.Id,RecordTypeId =pAssetRTId);
        insert pAsset;

        Id mohcdHouseholdProfileId = [SELECT Id FROM Profile WHERE Name = :StringConstants.HOUSEHOLD_PROFILE LIMIT 1].Id;
        hUser = CS_TestDataSetup.createTestPortalUser('FName1', 'LName1', 'test1@fakemail.com', mohcdHouseholdProfileId, con.Id);
        insert hUser;
	}
	
	static testMethod void testFAppAssetOnInsert() {

		testData();

        System.runAs(hUser){

	        Id propRtId = Schema.SObjectType.Properties__c.getRecordTypeInfosByName().get('Property').getRecordTypeId();
	        
	       	Properties__c lProp = CS_TestDataSetup.createTestProperties(130000, 'Rental', 4.5, 2, 'New', 'Condo', 'Castro', propRtId);
	       	lProp.Development_Name__c = 'Property Ownership';
	        lProperties.add(lProp);           
	        lProperties.add(CS_TestDataSetup.createTestProperties(130000, 'Ownership', 4.5, 2, 'New', 'Apartment', 'Castro', propRtId));
	        lProperties.add(CS_TestDataSetup.createTestProperties(130000, 'Rental', 4.5, 2, 'New', 'Condo', 'Castro', propRtId));           
	        insert lProperties;       

	        Housing_Application__c hApp = CS_TestDataSetup.createHousingApplication(lProperties[0].Id, 'Submitted');
	        hApp.Household_Account__c = acc.Id;
	        housingApps.add(hApp);
	        housingApps.add(CS_TestDataSetup.createHousingApplication(lProperties[1].Id, 'Submitted'));
	        housingApps.add(CS_TestDataSetup.createHousingApplication(lProperties[2].Id, 'Submitted'));
	        insert housingApps;

			Id dalpRTId = Schema.SObjectType.Financial_Application__c.getRecordTypeInfosByName().get('DALP').getRecordTypeId();        
        	Financial_Application__c finApp = CS_TestDataSetup.createFinancialApplication(housingApps[0].Id, 'Submitted', acc.Id, dalpRTId, con.Id);
        	finApp.Copy_Existing_Info__c = true;
        	finApps.add(finApp);
        	
        	Test.startTest();
        		insert finApps;

        	    finApps = new List<Financial_Application__c>();
        		finApps.add(CS_TestDataSetup.createFinancialApplication(housingApps[1].Id, 'Submitted', acc.Id, dalpRTId, con.Id));
	        	finApps.add(CS_TestDataSetup.createFinancialApplication(housingApps[2].Id, 'Submitted', acc.Id, dalpRTId, con.Id));

	        	insert finApps;

        	Test.stopTest();
            
        	for(Financial_Application__c fApp : finApps){
        		System.assert(fApp.Id != null);
        	}
        }
    }
}