@isTest
public with sharing class CS_MOHCDRegisterCCTest{
    
    private static Account acc;
    private static Account acc2;
    private static Contact con;
    private static List<Properties__c> lProperties = new List<Properties__c>();
    private static List<Housing_Application__c> housingApps = new List<Housing_Application__c>();
    private static List<Financial_Application__c> finApps = new List<Financial_Application__c>();
    private static User guestUser;

    static void testData(){
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
        insert acc;
        
        acc2 = CS_TestDataSetup.createTestAccount('SFMOHCD Inclusionary Programs', '1234512345', 'IT Software', rtId);
        insert acc2;

        Id lenderConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        con = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'testUserDataUnique@email.com', lenderConRTId);
        con.FirstName = 'FirstName';
        con.LastName = 'LastName';
        con.Zip_Code__c = '11111';
        con.Birthdate = date.newinstance(1900, 1, 1);
        insert con;        

        Contact con2 = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'testUserDataUnique3@email.com', lenderConRTId);
        con2.FirstName = 'FirstName3';
        con2.LastName = 'LastName3';
        con2.Zip_Code__c = '11112';
        con2.Birthdate = date.newinstance(1900, 1, 1);
        con2.Registration_Code__c = '1234';
        insert con2;

        Contact con4 = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'testUserDataUnique4@email.com', lenderConRTId);
        con4.FirstName = 'FirstName4';
        con4.LastName = 'LastName4';
        con4.Zip_Code__c = '11113';
        con4.Birthdate = date.newinstance(1900, 1, 1);
        con4.Registration_Code__c = '12345';
        insert con4;

        Contact con5 = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'testUserDataUnique4@email.com', lenderConRTId);
        con5.FirstName = 'FirstName4';
        con5.LastName = 'LastName4';
        con5.Zip_Code__c = '11113';
        con5.Birthdate = date.newinstance(1900, 1, 1);
        con5.Registration_Code__c = '12345';
        insert con5;

        Contact con6 = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'testUserDataUnique6@email.com', lenderConRTId);
        con6.FirstName = 'FirstName6';
        con6.LastName = 'LastName6';
        con6.Zip_Code__c = '11116';
        con6.Birthdate = date.newinstance(1900, 1, 1);
        con6.Registration_Code__c = '123456';
        insert con6;

        Contact con7 = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'testUserDataUnique7@email.com', lenderConRTId);
        con7.FirstName = 'FirstName7';
        con7.LastName = 'LastName7';
        con7.Zip_Code__c = '11117';
        con7.Birthdate = date.newinstance(1900, 1, 1);
        con7.Registration_Code__c = '123456';
        insert con7;


        Contact con8 = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'testUserDataUnique8@email.com', lenderConRTId);
        con8.FirstName = 'FirstName8';
        con8.LastName = 'LastName7';
        con8.Zip_Code__c = '11117';
        con8.Birthdate = date.newinstance(1900, 1, 1);
        con8.Registration_Code__c = '123456';
        insert con8;

        User hUser = CS_TestDataSetup.createTestPortalUser(con2.FirstName,con2.LastName,con2.Email,getProfile(StringConstants.HOUSEHOLD_PROFILE).Id,con2.Id);
        insert hUser;
        
        guestUser = CS_TestDataSetup.createGuestUser();
        insert guestuser;
    }

    static Profile getProfile(String profName) {
        return [SELECT Id FROM Profile WHERE Name =: profName];
    }

	static testmethod void testSelfRegistration(){     
        testData();

        System.runAs(guestUser) {
            Test.startTest();
                CS_MOHCDRegisterCC ctrl = new CS_MOHCDRegisterCC();

                System.assert(ctrl.checkApptype() == null);
                ctrl.getType();
                ctrl.getmonthsList();
                ctrl.getdaysList();
                ctrl.getyearsList();

                ctrl.currentMonth = 1;
                ctrl.getdaysList();
                ctrl.currentMonth = 2;
                ctrl.getdaysList();
                ctrl.currentMonth = 4;
                ctrl.getdaysList();
                ctrl.isRequired = true;
                ctrl.communityNickname = 'FName';
                
                ctrl.setAppType(StringConstants.EXISTING_APPLICANT_YES);
                ctrl.checkAppType();
                
                ctrl.email = 'heidi.tang';
                ctrl.registerUser();
                
                System.assert(ctrl.getAppType() == StringConstants.EXISTING_APPLICANT_YES);
            Test.stopTest();
        }
    }

    static testmethod void testSelfRegistrationRegister(){     
        testData();

        System.runAs(guestuser) {
            Test.startTest();
                PageReference pref = Page.mohcdRegister; 
                    pref.getHeaders().put('Host','https://dev-mohcdsfhousing.cs18.force.com/housingprograms/mohcdRegister');
                Test.setCurrentPage(pref);

                CS_MOHCDRegisterCC ctrl = new CS_MOHCDRegisterCC();
                System.assert(ctrl.registerUser()== null);

                ctrl.zipcode = '123456';
                System.assert(ctrl.registerUser()== null);

                ctrl.firstName = 'FirstName';
                ctrl.lastName = 'LastName';
                ctrl.zipcode = '11111';
                ctrl.email = 'testUserDataUnique@email.com';
                ctrl.currentMonth = 1;
                ctrl.currentDay = 1;
                ctrl.currentYear = 1900;
                System.assert(ctrl.registerUser().getUrl().contains('/mohcdnewusercontactmatch'));

                ctrl.firstName = 'FirstName2';
                ctrl.lastName = 'LastName';
                ctrl.zipcode = '11111';
                ctrl.email = 'testUserDataUnique@email.com';
                ctrl.currentMonth = 1;
                ctrl.currentDay = 1;
                ctrl.currentYear = 1900;
                ctrl.regId = '1234';
                ctrl.setAppType(StringConstants.EXISTING_APPLICANT_YES);
                System.assert(ctrl.registerUser().getUrl().contains('/mohcdnewusercontactmatch'));
                
                ctrl.setAppType(StringConstants.EXISTING_APPLICANT_NO);
                ctrl.registerUser();

                ctrl.firstName = 'FirstName2';
                ctrl.lastName = 'LastName3';
                ctrl.zipcode = '11112';
                ctrl.email = 'testUserDataUnique4@email.com';
                ctrl.currentMonth = 1;
                ctrl.currentDay = 1;
                ctrl.currentYear = 1900;
                ctrl.regId = '1234';
                ctrl.setAppType(StringConstants.EXISTING_APPLICANT_YES);
                ctrl.registerUser();

                ctrl.setAppType(StringConstants.EXISTING_APPLICANT_NO);
                ctrl.registerUser();                
            Test.stopTest();
        }
    }

    static testmethod void testSelfRegistrationRegisterWithRegId(){     
        testData();

        System.runAs(guestuser) {
            Test.startTest();
                PageReference pref = Page.mohcdRegister; 
                    pref.getHeaders().put('Host','https://dev-mohcdsfhousing.cs18.force.com/housingprograms/mohcdRegister');
                Test.setCurrentPage(pref);

                CS_MOHCDRegisterCC ctrl = new CS_MOHCDRegisterCC();
                ctrl.firstName = 'FirstName2';
                ctrl.lastName = 'LastName3';
                ctrl.zipcode = '11112';
                ctrl.email = 'testUserDataUnique4@email.com';
                ctrl.currentMonth = 1;
                ctrl.currentDay = 1;
                ctrl.currentYear = 1900;
                ctrl.regId = '1234';
                ctrl.setAppType(StringConstants.EXISTING_APPLICANT_YES);
                System.assert(ctrl.registerUser().getUrl().contains('/mohcdregconfirmation'));

                ctrl.firstName = 'FirstName5';
                ctrl.lastName = 'LastName5';
                ctrl.email = 'testUserDataUnique5@email.com';
                ctrl.setAppType(StringConstants.EXISTING_APPLICANT_NO);
                ctrl.registerUser();                
            Test.stopTest();
        }
    }

    static testmethod void testSelfRegistrationRegisterWithRegIdMoreThan1(){     
        testData();

        System.runAs(guestuser) {
            Test.startTest();
                PageReference pref = Page.mohcdRegister; 
                    pref.getHeaders().put('Host','https://dev-mohcdsfhousing.cs18.force.com/housingprograms/mohcdRegister');
                Test.setCurrentPage(pref);

                CS_MOHCDRegisterCC ctrl = new CS_MOHCDRegisterCC();
                ctrl.firstName = 'FirstName5';
                ctrl.lastName = 'LastName4';
                ctrl.zipcode = '11113';
                ctrl.email = 'testUserDataUnique5@email.com';
                ctrl.currentMonth = 1;
                ctrl.currentDay = 1;
                ctrl.currentYear = 1900;
                ctrl.regId = '12345';
                ctrl.setAppType(StringConstants.EXISTING_APPLICANT_YES);
                System.assert(ctrl.registerUser().getUrl().contains('/mohcdmultiplecontactmatch'));
            Test.stopTest();
        }
    }

    static testmethod void testSelfRegistrationRegisterWithNoRegContact(){     
        testData();

        System.runAs(guestuser) {
            Test.startTest();
                PageReference pref = Page.mohcdRegister; 
                    pref.getHeaders().put('Host','https://dev-mohcdsfhousing.cs18.force.com/housingprograms/mohcdRegister');
                Test.setCurrentPage(pref);

                CS_MOHCDRegisterCC ctrl = new CS_MOHCDRegisterCC();
                ctrl.firstName = 'FirstName6';
                ctrl.lastName = 'LastName6';
                ctrl.zipcode = '11113';
                ctrl.email = 'testUserDataUnique6@email.com';
                ctrl.currentMonth = 1;
                ctrl.currentDay = 1;
                ctrl.currentYear = 1900;
                ctrl.regId = '123456';
                ctrl.setAppType(StringConstants.EXISTING_APPLICANT_YES);
                ctrl.registerUser();
                System.assert(ApexPages.getMessages().size()>0);

                ctrl.regId = '';
                ctrl.registerUser();
            Test.stopTest();
        }
    }

    static testmethod void testSelfRegistrationRegisterWith1NoRegContact(){     
        testData();

        System.runAs(guestuser) {
            Test.startTest();
                PageReference pref = Page.mohcdRegister; 
                    pref.getHeaders().put('Host','https://dev-mohcdsfhousing.cs18.force.com/housingprograms/mohcdRegister');
                Test.setCurrentPage(pref);

                CS_MOHCDRegisterCC ctrl = new CS_MOHCDRegisterCC();
                ctrl.firstName = 'FirstName';
                ctrl.lastName = 'LastName6';
                ctrl.zipcode = '11116';
                ctrl.email = 'testUserDataUnique6@email.com';
                ctrl.currentMonth = 1;
                ctrl.currentDay = 1;
                ctrl.currentYear = 1900;
                ctrl.regId = '';
                ctrl.setAppType(StringConstants.EXISTING_APPLICANT_YES);
                ctrl.registerUser();
                System.assert(ApexPages.getMessages().size()>0);
            Test.stopTest();
        }
    }

    static testmethod void testSelfRegistrationRegisterWith2NoRegContact(){     
        testData();

        System.runAs(guestuser) {
            Test.startTest();
                PageReference pref = Page.mohcdRegister; 
                    pref.getHeaders().put('Host','https://dev-mohcdsfhousing.cs18.force.com/housingprograms/mohcdRegister');
                Test.setCurrentPage(pref);

                CS_MOHCDRegisterCC ctrl = new CS_MOHCDRegisterCC();
                ctrl.firstName = 'FirstName';
                ctrl.lastName = 'LastName7';
                ctrl.zipcode = '11117';
                ctrl.email = 'testUserDataUnique7@email.com';
                ctrl.currentMonth = 1;
                ctrl.currentDay = 1;
                ctrl.currentYear = 1900;
                ctrl.regId = '';
                ctrl.setAppType(StringConstants.EXISTING_APPLICANT_YES);
                System.assert(ctrl.registerUser().getUrl().contains('/mohcdnewusercontactmatch'));
            Test.stopTest();
        }
    }  

    static testMethod void getUtils(){
        Integer randomNumber = 0;
        
        Test.startTest();
            randomNumber = SfmohUtils.getRandomInt(10,20);
        Test.stopTest();
        
        System.assert(randomNumber != 0);
    }
}