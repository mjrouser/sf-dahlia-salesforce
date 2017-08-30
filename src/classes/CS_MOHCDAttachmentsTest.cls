/**
 * @author:      Mason Weng
 * @date:        04/22/2014
 * @description: Test class for CS_MOHCDAttachments
 * @history:     06/01/2015 - Heidi Tang - Edited
*/
@isTest
private class CS_MOHCDAttachmentsTest {
        
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
        lProperties.add(CS_TestDataSetup.createTestProperties(130000, StringConstants.PROP_RENTAL, 4.5, 2, 'New', 'Condo', 'Castro', propRtId));
        lProperties.add(CS_TestDataSetup.createTestProperties(130000, StringConstants.PROP_OWNERSHIP, 4.5, 2, 'New', 'Apartment', 'Castro', propRtId));
        insert lProperties;
                
        housingApp = CS_TestDataSetup.createHousingApplication(lProperties[0].Id, 'Submitted');
        insert housingApp;
        
        Id dalpRTId = Schema.SObjectType.Financial_Application__c.getRecordTypeInfosByName().get(StringConstants.FAPP_DALP).getRecordTypeId();        
        financialApp = CS_TestDataSetup.createFinancialApplication(housingApp.Id, 'Submitted', acc.Id, dalpRTId, con.Id);
        //insert financialApp;
        
        //financialMember = CS_TestDataSetup.createFinancialApplicationMember(financialApp.Id, 'Primary Borrower', 'Test', 'Member', System.today()-10000, 'Spouse');
        //insert financialMember;
    }

    static testMethod void testMOHCDattachments() {
    
        Custom_Attachment__c attachment = new Custom_Attachment__c(Financial_Application__c = financialApp.Id,
            Name='Sample Attachment');

        CS_MOHCDAttachments controller;
        PageReference pageRef;

        Test.startTest();    
            ApexPages.StandardController stdController = new ApexPages.StandardController(attachment); 
            controller = new CS_MOHCDAttachments(stdController);   
            pageRef = controller.doCancel();    
        Test.stopTest();    

        System.assert(pageRef.getUrl().contains('/'+financialApp.Id));

        controller.doSave();
        controller.fileBody = Blob.ValueOf('this is a test blob');
        controller.doSave();
        controller.finAttachment.Document_Type__c = Label.DOC_TYPE_BANK_STATEMENT;
        controller.fileName = 'Sample Attachment';
        //controller.doSave();        
    }    
}