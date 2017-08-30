/**
 * @author:      Sumit Shingavi
 * @date:        07/29/2014
 * @description: Test Class for CS_MOHCDChangePasswordCC
 * @history:     06/10/2015 - Heidi Tang - Edited
*/
@isTest
private with sharing class CS_MOHCDChangePasswordCCTest {

    private static User householdUser;

    static void testData(){
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(StringConstants.ACCT_HOUSEHOLD).getRecordTypeId();
        Account acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
        insert acc;
        
        Id householdConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(StringConstants.CONTACT_HOUSEHOLD).getRecordTypeId();
        Contact con = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', householdConRTId);
        insert con;

        Profile prof = [SELECT Id, Name FROM Profile WHERE Name = :StringConstants.LENDER_PROFILE LIMIT 1];
        householdUser = CS_TestDataSetup.createTestPortalUser('FName1', 'LName1', 'test1@fakemail.com', prof.Id, con.Id);
        insert householdUser;

    }// end of testData.


    static testMethod void testChangePasswordController() {
        testData();

        System.runAs(householdUser) {
            // Instantiate a new controller with all parameters in the page
            CS_MOHCDChangePasswordCC controller = new CS_MOHCDChangePasswordCC();

            Test.startTest();
                controller.oldPassword = '123456';
                controller.newPassword = 'qwerty1'; 
                controller.verifyNewPassword = 'qwerty1';                
            Test.stopTest();

            System.assertEquals(controller.changePassword(),null);                           
        }
    }    
}