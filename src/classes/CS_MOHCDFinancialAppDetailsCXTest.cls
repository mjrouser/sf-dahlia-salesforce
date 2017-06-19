/**
 * @author:      Sumit Shingavi
 * @date:        07/29/2014
 * @description: Test class for CS_MOHCDFinancialAppDetailsCX
 * @history:     06/10/2015 - Heidi Tang - Edited
*/ 
@isTest
private class CS_MOHCDFinancialAppDetailsCXTest {
    
    private static Account acc;
    private static Contact con;
    private static Contact con1;
    private static List<Properties__c> lProperties;
    private static Housing_Application__c housingApp;
    private static Financial_Application__c financialApp;
    private static Financial_Application_Member__c financialMember;
    
    static {
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(StringConstants.ACCT_HOUSEHOLD).getRecordTypeId();
        acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
        insert acc;
        
        Id lenderConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(StringConstants.CONTACT_LENDING_AGENT).getRecordTypeId();
        con = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', lenderConRTId);
        insert con;

        con1 = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', lenderConRTId);
        insert con1;

        lProperties = new List<Properties__c>();
        Id propRtId = Schema.SObjectType.Properties__c.getRecordTypeInfosByName().get(StringConstants.LISTING_PROPERTY).getRecordTypeId();
        lProperties.add(CS_TestDataSetup.createTestProperties(130000,StringConstants.PROP_RENTAL, 4.5, 2, 'New', 'Condo', 'Castro', propRtId));
        lProperties.add(CS_TestDataSetup.createTestProperties(130000,StringConstants.PROP_OWNERSHIP, 4.5, 2, 'New', 'Apartment', 'Castro', propRtId));
        insert lProperties;
                
        housingApp = CS_TestDataSetup.createHousingApplication(lProperties[0].Id, 'Submitted');
        insert housingApp;
        
        Id dalpRTId = Schema.SObjectType.Financial_Application__c.getRecordTypeInfosByName().get(StringConstants.FAPP_DALP).getRecordTypeId();        
        financialApp = CS_TestDataSetup.createFinancialApplication(housingApp.Id, 'Submitted', acc.Id, dalpRTId, con.Id);
        insert financialApp;
        
        financialMember = CS_TestDataSetup.createFinancialApplicationMember(financialApp.Id, 'Primary Borrower', 'Test', 'Member', System.today()-10000, 'Spouse');
        insert financialMember;
    }
    
    static testMethod void testMOHCDFinancialAppDetailsCX() {
    
        Test.startTest();
            ApexPages.StandardController stdController = new ApexPages.StandardController(financialApp); 
            CS_MOHCDFinancialAppDetailsCX controller = new CS_MOHCDFinancialAppDetailsCX(stdController);       
        Test.stopTest();    
        
        System.assertNotEquals(null, acc.Id);
   }    
}