/**
 * @author:      Sumit Shingavi
 * @date:        07/29/2014
 * @description: Test class for CS_MOHCDDownPayRequestCC
 * @history:     06/10/2015 - Heidi Tang - Edited
*/
@isTest
private class CS_MOHCDDownPayRequestCCTest {
    
    private static Account acc;
    private static Contact con;
    private static Contact con1;
    private static List<Properties__c> lProperties;
    private static Housing_Application__c housingApp;
    private static Housing_Application__c housingApp1;
    
    static {    
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(StringConstants.ACCT_HOUSEHOLD).getRecordTypeId();
        acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
        insert acc;
        System.assertNotEquals(null, acc.Id);
        
        Id lenderConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(StringConstants.CONTACT_LENDING_AGENT).getRecordTypeId();
        con = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', lenderConRTId);
        insert con;
        System.assertNotEquals(null, con.Id); 
        
        con1 = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', lenderConRTId);
        insert con1;
        System.assertNotEquals(null, con1.Id);
                
        lProperties = new List<Properties__c>();
        Id propRtId = Schema.SObjectType.Properties__c.getRecordTypeInfosByName().get(StringConstants.LISTING_PROPERTY).getRecordTypeId();
        lProperties.add(CS_TestDataSetup.createTestProperties(130000,StringConstants.PROP_RENTAL, 4.5, 2, 'New', 'Condo', 'Castro', propRtId));
        lProperties.add(CS_TestDataSetup.createTestProperties(130000,StringConstants.PROP_OWNERSHIP, 4.5, 2, 'New', 'Apartment', 'Castro', propRtId));
        insert lProperties;
                
        housingApp = CS_TestDataSetup.createHousingApplication(lProperties[0].Id, 'Submitted');
        insert housingApp;
        
        housingApp1 = CS_TestDataSetup.createHousingApplication(lProperties[1].Id, 'Submitted');
        insert housingApp1;
    }
    
    static testMethod void testMOHCDDownPayRequestCC() {
    
        Test.startTest();
        
        PageReference pref = Page.mohcdDownPayRequest; 
            pref.getParameters().put(StringConstants.PARAM_LENDER, con.Id);            
        Test.setCurrentPage(pref);
        
        CS_MOHCDDownPayRequestCC controller = new CS_MOHCDDownPayRequestCC();       
        controller.getRequestTypes();
        
        System.assertNotEquals(con.Id, null);
        
        controller.conLender = con;
        controller.lHousingAppWraps[0].isSelected = true;
        controller.submitFinancialProgramRequest();
        
        controller.conLender = null;
        controller.submitFinancialProgramRequest();
        
        controller.conLender = con;
        controller.lHousingAppWraps[0].isSelected = true;
        controller.lHousingAppWraps[1].isSelected = true;
        controller.submitFinancialProgramRequest();

        Test.stopTest();    
    } 
}