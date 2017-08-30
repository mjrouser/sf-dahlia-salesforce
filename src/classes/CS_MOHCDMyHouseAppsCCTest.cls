@isTest
private class CS_MOHCDMyHouseAppsCCTest {
        
    private static List<Properties__c> lProperties;
    private static Housing_Application__c housingApp;
    
    static {           
        lProperties = new List<Properties__c>();
        Id propRtId = Schema.SObjectType.Properties__c.getRecordTypeInfosByName().get('Property').getRecordTypeId();
        lProperties.add(CS_TestDataSetup.createTestProperties(130000, 'Rental', 4.5, 2, 'New', 'Condo', 'Castro', propRtId));
        lProperties.add(CS_TestDataSetup.createTestProperties(130000, 'Ownership', 4.5, 2, 'New', 'Apartment', 'Castro', propRtId));
        insert lProperties;
          
        housingApp = CS_TestDataSetup.createHousingApplication(lProperties[0].Id, 'Submitted');
        insert housingApp;
    }
    
    static testMethod void testMOHCDMyHouseAppsCC() {
    
        Test.startTest();
        
        CS_MOHCDMyHouseAppsCC controller = new CS_MOHCDMyHouseAppsCC();
        System.assert(controller.lMyHousingApps.size() > 0);
        
        Test.stopTest();    
    }
}