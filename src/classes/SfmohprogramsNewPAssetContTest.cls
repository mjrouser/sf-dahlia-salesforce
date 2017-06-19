@isTest
private class SfmohprogramsNewPAssetContTest {
	
	static testMethod void testNewPAssetCont() {
		
		String retValue;

        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        Account acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
        insert acc;

		Test.startTest();
			ApexPages.StandardController stdController = new ApexPages.StandardController(acc);
			SfmohprogramsNewPAssetCont ctrl = new SfmohprogramsNewPAssetCont(stdController);
			retValue = ctrl.getRecordName();
		Test.stopTest();

		System.assert(retValue.contains('Hello'));
	}	
}