@isTest
private class SfmohprogramsHousingAppAssetTriggerTest {
	
	private static Account acc;
    private static Contact con;
    private static List<Properties__c> lProperties = new List<Properties__c>();
    private static List<Housing_Application__c> housingApps = new List<Housing_Application__c>();
    private static List<Housing_Application_Member__c> housingAppMembers = new List<Housing_Application_Member__c>();
    private static List<Housing_Application_Asset__c> housingAppAssets = new List<Housing_Application_Asset__c>();
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
	
	static testMethod void testHAppAssetOnInsert() {

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

	        housingAppMembers.add(new Housing_Application_Member__c(Housing_Application__c=housingApps[0].Id, First_Name__c = 'FTest1',
                                    Last_Name__c = 'LTest1',Work_Phone__c='9421341099',Relationship_to_Head_of_Household__c = 'Brother',
                                    Occupation__c='Student',Date_of_Birth__c=Date.today()-7000, In_School__c='No',Gender__c='Female',
                                    Full_Time_Student__c='Yes',Married_or_Domestic_Partnered__c='Yes',Live_Or_Work_in_San_Francisco__c='Yes',
                                    Does_this_appear_on_another_title__c='Yes',Has_owned_a_unit_last_3_yrs__c='No'));

	        housingAppMembers.add(new Housing_Application_Member__c(Housing_Application__c=housingApps[1].Id, First_Name__c = 'FTest2',
                                    Last_Name__c = 'LTest2',Work_Phone__c='9421341099',Relationship_to_Head_of_Household__c = 'Sister',
                                    Occupation__c='Student',Date_of_Birth__c=Date.today()-7000, In_School__c='No',Gender__c='Female',
                                    Full_Time_Student__c='Yes',Married_or_Domestic_Partnered__c='Yes',Live_Or_Work_in_San_Francisco__c='Yes',
                                    Does_this_appear_on_another_title__c='Yes',Has_owned_a_unit_last_3_yrs__c='No'));

	        housingAppMembers.add(new Housing_Application_Member__c(Housing_Application__c=housingApps[2].Id, First_Name__c = 'FTest3',
                                    Last_Name__c = 'LTest3',Work_Phone__c='9421341099',Relationship_to_Head_of_Household__c = 'Self',
                                    Occupation__c='Student',Date_of_Birth__c=Date.today()-7000, In_School__c='No',Gender__c='Female',
                                    Full_Time_Student__c='Yes',Married_or_Domestic_Partnered__c='Yes',Live_Or_Work_in_San_Francisco__c='Yes',
                                    Does_this_appear_on_another_title__c='Yes',Has_owned_a_unit_last_3_yrs__c='No'));

        	insert housingAppMembers;
        	

        	housingAppAssets.add(new Housing_Application_Asset__c(Housing_Application_Member__c = housingAppMembers[0].Id));
        	housingAppAssets.add(new Housing_Application_Asset__c(Housing_Application_Member__c = housingAppMembers[1].Id));
        	housingAppAssets.add(new Housing_Application_Asset__c(Housing_Application_Member__c = housingAppMembers[2].Id));

        	Test.startTest();
        		insert housingAppAssets;
        	Test.stopTest();
            
        	Set<Id> hAssetIds = new Set<Id>();

            for(Housing_Application_Asset__c hAppAss : housingAppAssets){
            	hAssetIds.add(hAppAss.Id);
            }

			housingAppAssets = new List<Housing_Application_Asset__c>([SELECT Housing_Application__c 
									FROM Housing_Application_Asset__c WHERE Id IN :hAssetIds]);            

			for(Integer i=0;i<housingAppAssets.size();i++){
				System.assert(housingAppAssets[i].Housing_Application__c != null);
			}
        }
    }
}