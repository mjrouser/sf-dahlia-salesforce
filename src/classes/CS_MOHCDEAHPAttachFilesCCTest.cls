/**
 * @author:      Ronald Martinez
 * @date:        08/04/2014
 * @description: Controller class for mohcdEAHPAttachFiles
 * @history:     06/10/2015 - Heidi Tang - Edited
*/
@isTest
private class CS_MOHCDEAHPAttachFilesCCTest {
    public static String CP_EAHP = 'EAHP';
        
    static testMethod void testAttachFiles() {
        //Create Account
        Account oAcc = new Account(Name = 'Test Account');
        insert oAcc;
        
        //Create Contact       
        Contact oCon = new Contact(FirstName = 'Test FN', 
                                        LastName = 'LN:', 
                                        Phone = '987654321',
                                        Email = 'test01@email.com',
                                        Street_Number__c = '01',
                                        Street_Name__c = 'Street Name',
                                        Street_Type__c = 'Not Applicable',
                                        Apt_Unit__c = '02', 
                                        Address_Line_2__c = 'AL2',
                                        City__c = 'TestCity',
                                        Zip_Code__c = '11111',
                                        AccountId = oAcc.Id);
        insert oCon;
        
        //Profile
        Profile oProf = [Select Id from Profile where Name =: StringConstants.HOUSEHOLD_PROFILE];
        
        //Create User
        User user01 = new User(LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles', LastName = 'User01', 
                            Alias = 'User01', Email = 'user01@test.com.test', CommunityNickname = 'User01', EmailEncodingKey='UTF-8', 
                            UserName='user01@test.com.test', IsActive = true, ProfileId = oProf.Id, ContactId = oCon.Id);    
 
        insert user01;
        RecordType oRec = [Select Id from RecordType where Name =: CP_EAHP AND SobjectType =: 'Certificate_Program__c'];    
        Certificate_Program__c oCP = new Certificate_Program__c(Household_Contact__c = oCon.Id, Household_Account__c = oAcc.Id, RecordTypeId = oRec.Id); 
        insert oCP;    
        Test.startTest();
        
        PageReference pageRef = Page.mohcdEAHPAttachFiles; 
        pageRef.getParameters().put(StringConstants.PARAM_PID, oCP.Id);
        Test.setCurrentPage(pageRef);
        
        CS_MOHCDEAHPAttachFilesCC oControl = new CS_MOHCDEAHPAttachFilesCC();
        oControl.getEAHPTypes();
        oControl.fileAttachmentName = 'Test';
        oControl.fileAttachmentContentType = 'text';
        oControl.fileAttachmentDescription = Label.DOC_TYPE_BANK_STATEMENT;
        oControl.fileAttachmentBody = Blob.ValueOf('this is a test blob');
        oControl.addAttachment();
        oControl.done();
        System.assertEquals(1, [SELECT Id FROM Attachment WHERE ParentId =: oCP.Id].size());

        pageRef = Page.mohcdEAHPAttachFiles; 
        pageRef.getParameters().put(StringConstants.PARAM_PID, oCP.Id);
        Test.setCurrentPage(pageRef);
        
        oControl = new CS_MOHCDEAHPAttachFilesCC();
        oControl.getEAHPTypes();
        oControl.fileAttachmentName = 'Test';   
        oControl.fileAttachmentDescription = '';
        oControl.addAttachment();

        Test.stopTest();    
    }

    static testMethod void testAttachFilesError() {
        //Create Account
        Account oAcc = new Account(Name = 'Test Account');
        insert oAcc;
        
        //Create Contact       
        Contact oCon = new Contact(FirstName = 'Test FN', 
                                        LastName = 'LN:', 
                                        Phone = '987654321',
                                        Email = 'test01@email.com',
                                        Street_Number__c = '01',
                                        Street_Name__c = 'Street Name',
                                        Street_Type__c = 'Not Applicable',
                                        Apt_Unit__c = '02', 
                                        Address_Line_2__c = 'AL2',
                                        City__c = 'TestCity',
                                        Zip_Code__c = '11111',
                                        AccountId = oAcc.Id);
        insert oCon;
        
        //Profile
        Profile oProf = [Select Id from Profile where Name =: StringConstants.HOUSEHOLD_PROFILE];
        
        //Create User
        User user01 = new User(LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles', LastName = 'User01', 
                            Alias = 'User01', Email = 'user01@test.com.test', CommunityNickname = 'User01', EmailEncodingKey='UTF-8', 
                            UserName='user01@test.com.test', IsActive = true, ProfileId = oProf.Id, ContactId = oCon.Id);    
 
        insert user01;
        RecordType oRec = [Select Id from RecordType where Name =: CP_EAHP AND SobjectType =: 'Certificate_Program__c'];    
        Certificate_Program__c oCP = new Certificate_Program__c(Household_Contact__c = oCon.Id, Household_Account__c = oAcc.Id, RecordTypeId = oRec.Id); 
        insert oCP;    
        Test.startTest();
        
        PageReference pageRef = Page.mohcdEAHPAttachFiles; 
        pageRef.getParameters().put(StringConstants.PARAM_PID, oCP.Id);
        Test.setCurrentPage(pageRef);
        
        CS_MOHCDEAHPAttachFilesCC oControl = new CS_MOHCDEAHPAttachFilesCC();
        oControl.getEAHPTypes();
        oControl.fileAttachmentName = 'Test';
        oControl.fileAttachmentDescription = Label.DOC_TYPE_BANK_STATEMENT;
        oControl.addAttachment();
        oControl.done();
        System.assertEquals(0, [SELECT Id FROM Attachment WHERE ParentId =: oCP.Id].size());

        pageRef = Page.mohcdEAHPAttachFiles; 
        pageRef.getParameters().put(StringConstants.PARAM_PID, oCP.Id);
        Test.setCurrentPage(pageRef);
        
        oControl = new CS_MOHCDEAHPAttachFilesCC();
        oControl.getEAHPTypes();
        oControl.fileAttachmentName = 'Test';   
        oControl.fileAttachmentDescription = '';
        oControl.addAttachment();

        Test.stopTest();    
    }

    static testMethod void checkSizes(){
        Test.startTest();
            String kiloSize = CS_MOHCDGetListOfAttachments.convertedSize(2000);
            System.assert(kiloSize.contains('KB'));

            String megaSize = CS_MOHCDGetListOfAttachments.convertedSize(2000000);
            System.assert(megaSize.contains('MB'));

            String gigaSize = CS_MOHCDGetListOfAttachments.convertedSize(2000000000);
            System.assert(gigaSize.contains('GB'));
        Test.stopTest();
    }
}