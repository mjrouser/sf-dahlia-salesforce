/**
 * @author:      Sumit Shingavi
 * @date:        07/28/2014
 * @description: Test class for CS_MOHCDAttachFilesCC
 * @history:     06/10/2015 - Heidi Tang - Edited
*/
@isTest
private class CS_MOHCDAttachFilesCCTest {
        
    private static List<Properties__c> lProperties;
    private static Housing_Application__c housingApp;
    
    static {           
        lProperties = new List<Properties__c>();
        Id propRtId = Schema.SObjectType.Properties__c.getRecordTypeInfosByName().get(StringConstants.LISTING_PROPERTY).getRecordTypeId();
        lProperties.add(CS_TestDataSetup.createTestProperties(130000, StringConstants.PROP_RENTAL, 4.5, 2, 'New', 'Condo', 'Castro', propRtId));
        lProperties.add(CS_TestDataSetup.createTestProperties(130000, StringConstants.PROP_OWNERSHIP, 4.5, 2, 'New', 'Apartment', 'Castro', propRtId));
        insert lProperties;
          
        housingApp = CS_TestDataSetup.createHousingApplication(lProperties[0].Id, 'Submitted');
        insert housingApp;
    }
    
    static testMethod void testMOHCDAttachFilesCC() {
    
        Test.startTest();
        
        PageReference pref = Page.mohcdAttachFiles; 
            pref.getParameters().put('haId', housingApp.Id);
            pref.getParameters().put('pId', lProperties[0].Id);
        Test.setCurrentPage(pref);
        
        CS_MOHCDAttachFilesCC controller = new CS_MOHCDAttachFilesCC();
        controller.getDocumentTypes();
        controller.fileAttachmentName = 'Test';
        controller.fileAttachmentContentType = 'text';
        controller.fileAttachmentDescription = Label.DOC_TYPE_BANK_STATEMENT;
        controller.fileAttachmentBody = Blob.ValueOf('this is a test blob');
        controller.addAttachment();
        controller.done();
        
        System.assertEquals(1, [SELECT Id FROM Attachment WHERE ParentId =: housingApp.Id].size());
        
        pref = Page.mohcdAttachFiles; 
            pref.getParameters().put('haId', housingApp.Id);
            pref.getParameters().put('pId', lProperties[1].Id);
        Test.setCurrentPage(pref);
        
        controller = new CS_MOHCDAttachFilesCC();
        controller.getDocumentTypes();
        controller.fileAttachmentName = 'Test';   
        controller.fileAttachmentDescription = '';
        controller.addAttachment();
        
        Test.stopTest();    
    }

    static testMethod void testMOHCDAttachFilesCCError() {
    
        Test.startTest();
        
        PageReference pref = Page.mohcdAttachFiles; 
            pref.getParameters().put('haId', housingApp.Id);
            pref.getParameters().put('pId', lProperties[0].Id);
        Test.setCurrentPage(pref);
        
        CS_MOHCDAttachFilesCC controller = new CS_MOHCDAttachFilesCC();
        controller.getDocumentTypes();
        controller.fileAttachmentName = 'Test';
        controller.fileAttachmentDescription = Label.DOC_TYPE_BANK_STATEMENT;
        controller.addAttachment();
        controller.done();
        
        System.assertEquals(0, [SELECT Id FROM Attachment WHERE ParentId =: housingApp.Id].size());
        
        pref = Page.mohcdAttachFiles; 
            pref.getParameters().put('haId', housingApp.Id);
            pref.getParameters().put('pId', lProperties[1].Id);
        Test.setCurrentPage(pref);
        
        controller = new CS_MOHCDAttachFilesCC();
        controller.getDocumentTypes();
        controller.fileAttachmentName = 'Test';   
        controller.fileAttachmentDescription = '';
        controller.addAttachment();
        
        Test.stopTest();    
    }
}