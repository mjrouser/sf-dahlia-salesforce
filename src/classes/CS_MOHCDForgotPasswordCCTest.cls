/**
 * @author:      Sumit Shingavi
 * @date:        07/29/2014
 * @description: Test class for CS_MOHCDForgotPasswordCC VF Page
 * @history:     06/11/2015 - Heidi Tang - Edited
*/ 
@isTest
private class CS_MOHCDForgotPasswordCCTest {
    
    private static Account acc;
    private static Contact con;
    private static User usr;
    
    static {
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(StringConstants.ACCT_HOUSEHOLD).getRecordTypeId();
        acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
        insert acc;

        Id lenderConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(StringConstants.CONTACT_LENDING_AGENT).getRecordTypeId();
        con = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', lenderConRTId);
        insert con;

        usr = CS_TestDataSetup.createTestUser('FName1', 'LName1', [SELECT Id FROM Profile WHERE Name = :StringConstants.ADMIN_PROFILE LIMIT 1].Id);
        insert usr;
    }
    
    static testMethod void testMOHCDForgotPasswordCC() {
        Test.startTest();
            CS_MOHCDForgotPasswordCC controller = new CS_MOHCDForgotPasswordCC();
            controller.email = [SELECT Email FROM User WHERE Id =: usr.Id LIMIT 1].Email;
            controller.forgotPassword();
    
            controller.email = 'yolala@fakemail.com';
            controller.forgotPassword();
            
            controller.email = '';
            controller.forgotPassword();       
    
            System.assertNotEquals(usr.Id, null);
        Test.stopTest();    
    }    
}