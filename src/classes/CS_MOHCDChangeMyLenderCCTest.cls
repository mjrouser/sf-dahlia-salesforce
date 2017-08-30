/**
 * @author:      Sumit Shingavi
 * @date:        07/29/2014
 * @description: Test class for CS_MOHCDChangeMyLenderCC
 * @history:     06/10/2015 - Heidi Tang - Edited
*/
@isTest
private class CS_MOHCDChangeMyLenderCCTest {
    
    private static Account acc;
    private static Account acc1;
    private static Contact con;
    private static Contact con1;
    private static Contact con2;
    private static User user;
    private static User lenderUser;
    private static User notLenderUser;
    private static List<Properties__c> lProperties;
    private static Housing_Application__c housingApp;
    
    static {    
        List<Profile> profiles = new List<Profile>([SELECT Id FROM Profile where Name = :StringConstants.LENDER_PROFILE LIMIT 1]);
        
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(StringConstants.ACCT_HOUSEHOLD).getRecordTypeId();
        acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
        insert acc;

        Id rtId2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get(StringConstants.ACCT_LENDER).getRecordTypeId();
        acc1 = CS_TestDataSetup.createTestAccount('Test Account 2', '1234512345', 'IT Software', rtId2);
        insert acc1;

        Id lenderConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(StringConstants.CONTACT_LENDING_AGENT).getRecordTypeId();
        con = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', lenderConRTId);
        insert con;

        con1 = CS_TestDataSetup.createTestContact(acc.Id, 'Contact2', 'Test2', 'test@mail.com', lenderConRTId);
        insert con1;

        con2 = CS_TestDataSetup.createTestContact(acc1.Id, 'Contact3', 'Test3', 'test@mail.com', lenderConRTId);
        insert con2;

        user = CS_TestDataSetup.createTestPortalUser('testUserData userFirstName', 'testUserData userLName', 'testUserDataUnique0@email.com', profiles.get(0).Id, con.Id);
        insert user;

        lenderUser = CS_TestDataSetup.createTestPortalUser('testUserData userFirstName1', 'testUserData userLName1', 'testUserDataUnique2@email.com', profiles.get(0).Id, con1.Id);
        insert lenderUser;

        notLenderUser = CS_TestDataSetup.createTestPortalUser('testUserData userFirstName2', 'testUserData userLName2', 'testUserDataUnique3@email.com', profiles.get(0).Id, con2.Id);
        insert notLenderUser;

        lProperties = new List<Properties__c>();
        Id propRtId = Schema.SObjectType.Properties__c.getRecordTypeInfosByName().get(StringConstants.LISTING_PROPERTY).getRecordTypeId();
        lProperties.add(CS_TestDataSetup.createTestProperties(130000, StringConstants.PROP_RENTAL, 4.5, 2, 'New', 'Condo', 'Castro', propRtId));
        lProperties.add(CS_TestDataSetup.createTestProperties(130000, StringConstants.PROP_OWNERSHIP, 4.5, 2, 'New', 'Apartment', 'Castro', propRtId));
        insert lProperties;
        
        housingApp = CS_TestDataSetup.createHousingApplication(lProperties[0].Id, 'Submitted');
        insert housingApp;
    }
    
    static testMethod void testMOHCDChangeMyLenderCC1() {
        
            User usr = [SELECT ID, Name, ContactId, Contact.AccountId FROM User WHERE Id =: Userinfo.getUserId() LIMIT 1];
            Id dalpRTId = Schema.SObjectType.Financial_Application__c.getRecordTypeInfosByName().get(StringConstants.FAPP_DALP).getRecordTypeId();
            Financial_Application__c financialApp = CS_TestDataSetup.createFinancialApplication(housingApp.Id, 'Submitted', usr.Contact.AccountId, dalpRTId, con2.Id);
            insert financialApp;

            DALP_Request__c ldap = new DALP_Request__c(Requested_By__c = usr.ContactId);
            DALP_Request__c ldap2 = new DALP_Request__c(HousingApp__c = housingApp.Id, Requested_By__c = usr.ContactId);
            insert ldap;
            insert ldap2;       

                Test.startTest();
                    PageReference pref = Page.mohcdAttachFiles; 
                        pref.getParameters().put(StringConstants.PARAM_LENDER, con1.Id);
                    Test.setCurrentPage(pref);
            
                    CS_MOHCDChangeMyLenderCC controller = new CS_MOHCDChangeMyLenderCC();
                    controller.ChangeMyLender();
                    controller.lFinancialAppWraps[0].isSelected = true;
                    controller.ChangeMyLender();
                    controller.lFinancialAppWraps.clear();
                    controller.ChangeMyLender();
                Test.stopTest();
                System.assert(controller.usr.Contact.AccountId != acc.Id);    
    } 

    static testMethod void testMOHCDChangeMyLenderCC2() {
        System.runAs(user){
            Test.startTest();
                PageReference pref = Page.mohcdAttachFiles; 
                Test.setCurrentPage(pref);
        
                CS_MOHCDChangeMyLenderCC controller = new CS_MOHCDChangeMyLenderCC();
                controller.ChangeMyLender();
            Test.stopTest();
            System.assert(controller.conLender.Id == null,controller.conLender.Id);    
            System.assert(user.Id == Userinfo.getUserId(),Userinfo.getUserId());      
        }
    }

    static testMethod void testMOHCDChangeMyLenderCC3() {
       
        System.runAs(user){
            DALP_Request__c ldap = new DALP_Request__c(Requested_By__c = con.Id);
            insert ldap;

            PageReference pref = Page.mohcdAttachFiles; 
                        pref.getParameters().put(StringConstants.PARAM_LENDER, con1.Id);
            Test.setCurrentPage(pref);

            CS_MOHCDChangeMyLenderCC controller = new CS_MOHCDChangeMyLenderCC();

            Boolean isError = false;

            try{
                controller.changeBMRLender();
            } catch (DmlException dmle) {
                isError = true;
            }

            System.assert(isError);
        }
    } 
}