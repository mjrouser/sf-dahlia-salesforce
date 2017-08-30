/**
 * @author:      Ronald Martinez
 * @date:        08/04/2014
 * @description: Test class for CommunitiesLoginController
 * @history:     06/10/2015 - Heidi Tang - Edited
*/ 
@isTest
public with sharing class CS_MOHCDEAHPCCTest{
    
    static testmethod void testEAHP(){
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
        User user01 = new User();    
            user01.LanguageLocaleKey='en_US';
            user01.LocaleSidKey='en_US'; 
            user01.TimeZoneSidKey='America/Los_Angeles';
            user01.LastName = 'User01';
            user01.Alias = 'User01';
            user01.Email = 'user01@test.com.test';
            user01.CommunityNickname = 'User01';
            user01.EmailEncodingKey='UTF-8';
            user01.UserName='user01@test.com.test';
            user01.IsActive = true;
            user01.ProfileId = oProf.Id;
            user01.ContactId = oCon.Id;
 
            insert user01;
        Test.StartTest();
        System.RunAs(user01){
            PageReference pageRef = page.mohcdEAHP;
            Test.setCurrentPage(pageRef);
            CS_MOHCDEAHPCC oControl = new CS_MOHCDEAHPCC();
            oControl.getPicklist();
            oControl.getHouseholdSize();
            oControl.getmonthsList();
            oControl.getdaysList();
            oControl.getyearsList();
            pageRef = oControl.submitRequest();
            List<Certificate_Program__c> lCP = [Select Id from Certificate_Program__c];
            System.AssertEquals(lCP.size(), 1);
            
            System.AssertEquals(pageRef.getUrl(), '/housingprograms/mohcdEAHPPrintandSign?Id=' +lCP[0].Id);
            
            pageRef = page.mohcdEAHP;           
            oControl = new CS_MOHCDEAHPCC();
            Test.setCurrentPage(pageRef);
            oControl.moveInMonth = 1;
            oControl.NOIMonth = 1;
            oControl.moveOutMonth = 1;
            oControl.birthMonth = 1;
            oControl.submitRequest();
            List<Apexpages.Message> msgs = ApexPages.getMessages();
                boolean b = false;
                for(Apexpages.Message msg:msgs){
                    if (msg.getDetail().contains('Provide Information:')) 
                        b = true;
                }
                system.assert(b);
            
            pageRef = page.mohcdEAHP;           
            oControl = new CS_MOHCDEAHPCC();
            oControl.getmonthsList();
            oControl.getdaysList();
            oControl.getyearsList();
            oControl.moveInMonth = 1;
            oControl.moveInDay = 1;
            oControl.moveInYear = 1900;
            oControl.NOIMonth = 1;
            oControl.NOIDay = 1;
            oControl.NOIYear = 1900;            
            oControl.moveOutMonth = 1;
            oControl.moveOutDay = 1;
            oControl.moveOutYear = 1900; 
            oControl.birthMonth = 1;
            oControl.birthDay = 1;
            oControl.birthYear = 1900;
            oControl.getdaysList();
            
            oControl.moveInMonth = 2;
            oControl.NOIMonth = 2;
            oControl.moveOutMonth = 2;
            oControl.birthMonth = 2;
            oControl.getdaysList();
            oControl.moveInMonth = 4;
            oControl.NOIMonth = 4;
            oControl.moveOutMonth = 4;
            oControl.birthMonth = 4;
            oControl.getdaysList();
            oControl.strReqMailAddress = 'Test Address';
            oControl.selValue = 'Test';
            oControl.currentMonth =10;
            oControl.currentDay = 1;
            oControl.currentYear = 2000;
            oControl.question3Visibility = true;

            List<SelectOption> genders = oControl.getGender();
            List<SelectOption> ethnicities = oControl.getEthnicity();
            List<SelectOption> languages = oControl.getLanguage();
            List<SelectOption> sexualities = oControl.getSexualOrientation();
            List<SelectOption> years = oControl.getyearsNOIList();
                      
            
            pageRef = oControl.submitRequest();
            String cpId = pageRef.getParameters().get(StringConstants.PARAM_ID);
            lCP = [Select Id, Date_of_Move_In__c, Date_NOI_was_Filed__c, Date_of_Move_Out__c, Patient_Birthdate__c from Certificate_Program__c where Id =: cpId];            
            System.AssertEquals('1900-04-01', String.valueOf(lCP[0].Date_of_Move_In__c));
            System.AssertEquals('1900-04-01', String.valueOf(lCP[0].Date_NOI_was_Filed__c));
            System.AssertEquals('1900-04-01', String.valueOf(lCP[0].Date_of_Move_Out__c));
            System.AssertEquals('1900-04-01', String.valueOf(lCP[0].Patient_Birthdate__c ));
            System.assert(genders.size()==5,genders.size());
            System.assert(ethnicities.size()==21,ethnicities.size());
            System.assert(languages.size()==150,languages.size());
            System.assert(sexualities.size()==7,sexualities.size());
        }    
        Test.StopTest();
    }
}