@isTest
private class CS_MOHCDHousingAppCCTest {  

    private static Account acc;
    private static Account acc2;
    private static Contact con;
    private static List<Properties__c> lProperties = new List<Properties__c>();
    private static Housing_Application__c housingApp = new Housing_Application__c();
    private static User hUser;
    
    private static Certificate_Program__c copCert;
    private static Certificate_Program__c eahpCert;
    private static List<RecordType> incomeRecordTypes;
    private static List<RecordType> assetRecordTypes;

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

        hUser = CS_TestDataSetup.createTestPortalUser(con.FirstName,con.LastName,con.Email,getProfile(StringConstants.HOUSEHOLD_PROFILE).Id,con.Id);
        insert hUser;
        
        System.runAs(hUser) {
            lProperties = new List<Properties__c>();
            Id propRtId = Schema.SObjectType.Properties__c.getRecordTypeInfosByName().get('Property').getRecordTypeId();
            Properties__c lProperty1 = CS_TestDataSetup.createTestProperties(130000, 'Rental', 4.5, 2, 'New', 'Condo', 'Castro', propRtId);           
            Properties__c lProperty2 = CS_TestDataSetup.createTestProperties(130000, 'Ownership', 4.5, 2, 'New', 'Apartment', 'Castro', propRtId);
            Properties__c lProperty3 = CS_TestDataSetup.createTestProperties(130000, 'Rental', 4.5, 2, 'New', 'Condo', 'Castro', propRtId);           

            lProperty1.Property_Program__c = 'City 2nd';

            lProperties.add(lProperty1);
            lProperties.add(lProperty2);
            lProperties.add(lProperty3);

            insert lProperties;      
            
            List<Personal_Asset__c> pAssets = new List<Personal_Asset__c>();
            
            Id pAssetRTId = Schema.SObjectType.Personal_Asset__c.getRecordTypeInfosByName().get('Assets with an Account').getRecordTypeId();
            pAssets.add(new Personal_Asset__c(Household_Member__c=con.Id, RecordTypeId =pAssetRTId));
    		pAssets.add(new Personal_Asset__c(Household_Member__c=con.Id, RecordTypeId =pAssetRTId));
    		pAssets.add(new Personal_Asset__c(Household_Member__c=con.Id, RecordTypeId =pAssetRTId));  
            insert pAssets;
            
            List<Personal_Income__c> pIncomes = new List<Personal_Income__c>();
            
            Id pIncomeRTId = Schema.SObjectType.Personal_Income__c.getRecordTypeInfosByName().get('Employment Income').getRecordTypeId();
            pIncomes.add(new Personal_Income__c(Household_Member__c=con.Id, RecordTypeId =pIncomeRTId));
    		pIncomes.add(new Personal_Income__c(Household_Member__c=con.Id, RecordTypeId =pIncomeRTId));
    		pIncomes.add(new Personal_Income__c(Household_Member__c=con.Id, RecordTypeId =pIncomeRTId));   
    		insert pIncomes;
        }        
    }

    static Profile getProfile(String profName) {
        return [SELECT Id FROM Profile WHERE Name =: profName];
    }
    
    static Id getIncomeRecordType(String rType) {
        return Schema.SObjectType.Housing_Application_Income__c.getRecordTypeInfosByName().get(rType).getRecordTypeId();
    }

    static Id getAssetRecordType(String rType) {
        return Schema.SObjectType.Housing_Application_Asset__c.getRecordTypeInfosByName().get(rType).getRecordTypeId();
    }

    static testmethod void testHousingAppExtras(){     
        testData();

        System.runAs(hUser) {
            CS_MOHCDHousingAppCC ctrl;
            PageReference pref;
            
            Test.startTest();
                ctrl = new CS_MOHCDHousingAppCC();
                System.assert(ApexPages.getMessages().size()>0);
                
                pref = Page.mohcdHousingApp;
                    pref.getParameters().put('t', '1');
                    pref.getParameters().put('pid', lProperties[0].Id);
                Test.setCurrentPage(pref);

                ctrl = new CS_MOHCDHousingAppCC();
                ctrl.nextTab();

                pref = Page.mohcdHousingApp;
                    pref.getParameters().put('t', '6');
                    pref.getParameters().put('pid', lProperties[0].Id);
                Test.setCurrentPage(pref);

                ctrl = new CS_MOHCDHousingAppCC();
                ctrl.nextTab();
                ctrl.prevTab();

                pref = Page.mohcdHousingApp;
                    pref.getParameters().put('t', '2');
                    pref.getParameters().put('pid', lProperties[0].Id);
                Test.setCurrentPage(pref);
                
                ctrl = new CS_MOHCDHousingAppCC();
                ctrl.nextTab();

                pref = Page.mohcdHousingApp;
                    pref.getParameters().put('t', '3');
                    pref.getParameters().put('pid', lProperties[0].Id);
                Test.setCurrentPage(pref);
                
                ctrl = new CS_MOHCDHousingAppCC();
                ctrl.nextTab();

                pref = Page.mohcdHousingApp;    
                    pref.getParameters().put('t', '4');
                    pref.getParameters().put('pid', lProperties[0].Id);
               Test.setCurrentPage(pref);
                ctrl = new CS_MOHCDHousingAppCC();
                ctrl.nextTab();

                pref = Page.mohcdHousingApp;
                    pref.getParameters().put('t', '5');
                    pref.getParameters().put('pid', lProperties[0].Id);
                Test.setCurrentPage(pref);
                ctrl = new CS_MOHCDHousingAppCC();
                ctrl.nextTab();
                
                pref = Page.mohcdHousingApp;
                    pref.getParameters().put('t', '1');
                    pref.getParameters().put('pid', lProperties[1].Id);
                Test.setCurrentPage(pref);

                ctrl = new CS_MOHCDHousingAppCC();
                ctrl.nextTab();

                ctrl.refreshTab();
                ctrl.getErrorsPresent();
                ctrl.getSuccessPresent();
                ctrl.clearAssetErrorsCtrl();
                ctrl.clearAssetErrorsCtrl2();
                ctrl.clearErrors();
                ctrl.clearIncomeErrorsCtrl();
                ctrl.clearIncomeErrorsCtrl2();
                ctrl.clearMemberErrorsCtrl();
                ctrl.updateHousingApp();
            Test.stopTest();
            
            System.assert(ApexPages.getMessages().size()>0);
        }
    }
    
    static testmethod void testHousingAppWithExistingHApp(){ 
         testData();
         
         System.runAs(hUser) {
            housingApp = CS_TestDataSetup.createHousingApplication(lProperties[0].Id, 'Submitted');
            insert housingApp;
            
            Attachment hAttach = new Attachment(Name='Sample Attachment',ParentId=housingApp.Id,Body=Blob.ValueOf('this is a test blob'));
            insert hAttach;
            
            Note note = new Note(ParentId=housingApp.Id,Title ='MOHCD Document Submission');
            insert note;
    
            CS_MOHCDHousingAppCC ctrl;
            PageReference pref;
            
            Test.startTest();
                pref = Page.mohcdHousingApp;
                    pref.getParameters().put('t', '1');
                    pref.getParameters().put('pid', lProperties[0].Id);
                Test.setCurrentPage(pref);
                
                ctrl = new CS_MOHCDHousingAppCC();
                ctrl.createNote();
                
                ctrl.strDeleteAttachmentId = housingApp.Id;
                ctrl.deleteAttachment();
                
                ctrl.strDeleteAttachmentId = hAttach.Id;
                ctrl.deleteAttachment();
                ctrl.updateHousingApp();
            Test.stopTest();
            
            System.assert(ApexPages.getMessages().size()>0);
         }
    }
    
    static testMethod void testCreateHAppMember() {
        testData();
         
         System.runAs(hUser) {
            housingApp = CS_TestDataSetup.createHousingApplication(lProperties[0].Id, 'Submitted');
            insert housingApp;
            
            Note note = new Note(ParentId=housingApp.Id,Title ='MOHCD Document Submission');
            insert note;
    
            CS_MOHCDHousingAppCC ctrl;
            PageReference pref;
            
            Test.startTest();
                pref = Page.mohcdHousingApp;
                    pref.getParameters().put('t', '1');
                    pref.getParameters().put('pid', lProperties[0].Id);
                Test.setCurrentPage(pref);
                
                ctrl = new CS_MOHCDHousingAppCC();
                ctrl.addMember();
                
                ctrl.memberInstance.Has_owned_a_unit_last_3_yrs__c = 'Yes';
                ctrl.memberInstance.In_School__c = 'Yes';
                ctrl.addMember();
                
                ctrl.memberInstance.First_Name__c = 'FName';
                ctrl.memberInstance.Last_Name__c = 'LName';
                ctrl.memberInstance.Gender__c = 'Female';
                ctrl.memberInstance.Occupation__c = 'Dev';
                ctrl.memberInstance.Date_of_Birth__c = date.newinstance(1900, 1, 1);
                ctrl.memberInstance.Applicant_Role__c = 'TestRole';
                ctrl.memberInstance.Relationship_to_Head_of_Household__c = 'Self';
                ctrl.memberInstance.Married_or_Domestic_Partnered__c = 'Yes';
                ctrl.memberInstance.Live_Or_Work_in_San_Francisco__c = 'Yes';
                ctrl.memberInstance.Does_this_appear_on_another_title__c = 'Yes';
                ctrl.memberInstance.Has_owned_a_unit_last_3_yrs__c = 'No';
                ctrl.memberInstance.In_School__c = 'No';
                ctrl.addMember();
                ctrl.getMembersList();
                
                Housing_Application_Member__c hMem = [SELECT Id FROM Housing_Application_Member__c WHERE Housing_Application__c = :housingApp.Id];
                ctrl.strEditMemberId = hMem.Id;
                ctrl.editMemberCtrl();
                ctrl.updateMember();
                
                ctrl.strMemberId = housingApp.Id;
                ctrl.deleteMember();
                
                ctrl.strMemberId = hMem.Id;
                ctrl.deleteMember();
            Test.stopTest();
            
            System.assert(ApexPages.getMessages().size()==0);
         }
    }
    
    static testMethod void testCreateHAppIncome() {
        testData();
         
         System.runAs(hUser) {
            housingApp = CS_TestDataSetup.createHousingApplication(lProperties[0].Id, 'Submitted');
            insert housingApp;
            
            Note note = new Note(ParentId=housingApp.Id,Title ='MOHCD Document Submission');
            insert note;
    
            CS_MOHCDHousingAppCC ctrl;
            PageReference pref;
            
            Test.startTest();
                pref = Page.mohcdHousingApp;
                    pref.getParameters().put('t', '1');
                    pref.getParameters().put('pid', lProperties[0].Id);
                Test.setCurrentPage(pref);
                
                ctrl = new CS_MOHCDHousingAppCC();

                ctrl.memberInstance.First_Name__c = 'FName';
                ctrl.memberInstance.Last_Name__c = 'LName';
                ctrl.memberInstance.Gender__c = 'Female';
                ctrl.memberInstance.Occupation__c = 'Dev';
                ctrl.memberInstance.Date_of_Birth__c = date.newinstance(1900, 1, 1);
                ctrl.memberInstance.Applicant_Role__c = 'TestRole';
                ctrl.memberInstance.Relationship_to_Head_of_Household__c = 'Self';
                ctrl.memberInstance.Married_or_Domestic_Partnered__c = 'Yes';
                ctrl.memberInstance.Live_Or_Work_in_San_Francisco__c = 'Yes';
                ctrl.memberInstance.Does_this_appear_on_another_title__c = 'Yes';
                ctrl.memberInstance.Has_owned_a_unit_last_3_yrs__c = 'No';
                ctrl.memberInstance.In_School__c = 'No';
                ctrl.addMember();
                
                Housing_Application_Member__c hMem = [SELECT Id FROM Housing_Application_Member__c WHERE Housing_Application__c = :housingApp.Id];
                
                ctrl.addMemberIncome();
                
                ctrl.memberIncomeInstance.RecordTypeId = getIncomeRecordType('Employment Income');
                ctrl.addMemberIncome();
                
                ctrl.memberIncomeInstance.RecordTypeId = getIncomeRecordType('Other Income');
                ctrl.addMemberIncome();

                ctrl.memberIncomeInstance.RecordTypeId = getIncomeRecordType('Self-Employment Income');
                ctrl.addMemberIncome();

                ctrl.memberIncomeInstance.RecordTypeId = getIncomeRecordType('Unemployed');
                ctrl.addMemberIncome();
                
                ctrl.memberIncomeInstance.RecordTypeId = getIncomeRecordType('Unemployed');
                ctrl.memberIncomeInstance.Housing_Application_Member__c = hMem.Id;
                ctrl.memberIncomeInstance.Annual_Unemployment_Benefits_Amount__c = 0;
                ctrl.memberIncomeInstance.Year_Unemployed__c = '1991';
                ctrl.memberIncomeInstance.Month_Unemployed__c = '10';
                ctrl.addMemberIncome();
                
                Housing_Application_Income__c hIncome = [SELECT Id FROM Housing_Application_Income__c WHERE Housing_Application__c = :housingApp.Id];
                ctrl.strEditIncomeId = hIncome.Id;
                ctrl.editIncomeCtrl();
                ctrl.updateIncome();
                
                ctrl.strIncomeId = housingApp.Id;
                ctrl.deleteIncome();
                
                ctrl.strIncomeId = hIncome.Id;
                ctrl.deleteIncome();
            Test.stopTest();
            
            System.assert(ApexPages.getMessages().size()==0);
         }
    }
    
    static testMethod void testCreateHAppAsset() {
        testData();
         
         System.runAs(hUser) {
            housingApp = CS_TestDataSetup.createHousingApplication(lProperties[0].Id, 'Submitted');
            insert housingApp;
            
            Note note = new Note(ParentId=housingApp.Id,Title ='MOHCD Document Submission');
            insert note;
    
            CS_MOHCDHousingAppCC ctrl;
            PageReference pref;
            
            Test.startTest();
                pref = Page.mohcdHousingApp;
                    pref.getParameters().put('t', '1');
                    pref.getParameters().put('pid', lProperties[0].Id);
                Test.setCurrentPage(pref);
                
                ctrl = new CS_MOHCDHousingAppCC();

                ctrl.memberInstance.First_Name__c = 'FName';
                ctrl.memberInstance.Last_Name__c = 'LName';
                ctrl.memberInstance.Gender__c = 'Female';
                ctrl.memberInstance.Occupation__c = 'Dev';
                ctrl.memberInstance.Date_of_Birth__c = date.newinstance(1900, 1, 1);
                ctrl.memberInstance.Applicant_Role__c = 'TestRole';
                ctrl.memberInstance.Relationship_to_Head_of_Household__c = 'Self';
                ctrl.memberInstance.Married_or_Domestic_Partnered__c = 'Yes';
                ctrl.memberInstance.Live_Or_Work_in_San_Francisco__c = 'Yes';
                ctrl.memberInstance.Does_this_appear_on_another_title__c = 'Yes';
                ctrl.memberInstance.Has_owned_a_unit_last_3_yrs__c = 'No';
                ctrl.memberInstance.In_School__c = 'No';
                ctrl.addMember();
                
                Housing_Application_Member__c hMem = [SELECT Id FROM Housing_Application_Member__c WHERE Housing_Application__c = :housingApp.Id];
                
                ctrl.addMemberAsset();
                
                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('Assets with an Account');
                ctrl.addMemberAsset();
                
                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('Assets with an Account');
                ctrl.memberAssetInstance.Asset_Type__c = 'Settlement';
                ctrl.memberAssetInstance.Is_this_a_joint_account__c = true;
                ctrl.addMemberAsset();

                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('Assets with an Account');
                ctrl.memberAssetInstance.Asset_Type__c = 'Stocks';
                ctrl.addMemberAsset();

                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('Business Ownership');
                ctrl.memberAssetInstance.Asset_Type__c = null;
                ctrl.addMemberAsset();

                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('Cash without an Account');
                ctrl.memberAssetInstance.Asset_Type__c = null;
                ctrl.addMemberAsset();

                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('Gifts');
                ctrl.memberAssetInstance.Asset_Type__c = null;
                ctrl.addMemberAsset();

                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('Gifts');
                ctrl.memberAssetInstance.Gifter_Donor_Relationship_to_Recipient__c = 'Other';
                ctrl.memberAssetInstance.Gifter_Donor_Phone_Number__c = '11111';
                ctrl.memberAssetInstance.Gift_Funds_Location_Phone__c = '11111';
                ctrl.memberAssetInstance.Gift_Funds_Type_of_Account__c = 'Other';
                ctrl.memberAssetInstance.GR_Acct_Inst_Phone__c = '11111';
                ctrl.addMemberAsset();

                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('Land Ownership');
                ctrl.memberAssetInstance.Asset_Type__c = null;
                ctrl.addMemberAsset();

                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('Land Ownership');
                ctrl.memberAssetInstance.Asset_Type__c = null;
                ctrl.memberAssetInstance.Landowner_Earns_Income_from_Land__c = 'Yes';
                ctrl.addMemberAsset();
                
                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('No Assets');
                ctrl.memberAssetInstance.Asset_Type__c = null;
                ctrl.addMemberAsset();
                
                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('No Assets');
                ctrl.memberAssetInstance.Housing_Application_Member__c = hMem.Id;
                ctrl.memberAssetInstance.Asset_Type__c = 'No Assets';
                ctrl.memberAssetInstance.Land_Earned_Income_Per_Year__c = 0.0;
                ctrl.addMemberAsset();

                Housing_Application_Asset__c hAsset = [SELECT Id FROM Housing_Application_Asset__c WHERE Housing_Application__c = :housingApp.Id];
                ctrl.strEditAssetId = hAsset.Id;
                ctrl.editAssetCtrl();
                ctrl.updateAsset();
                
                ctrl.strAssetId = housingApp.Id;
                ctrl.deleteAsset();
                
                ctrl.strAssetId = hAsset.Id;
                ctrl.deleteAsset();
            Test.stopTest();
            
            System.assert(ApexPages.getMessages().size()==0);
         }
    }
    
    static testMethod void testCreateHApp() {
        testData();
         
         System.runAs(hUser) {
            housingApp = CS_TestDataSetup.createHousingApplication(lProperties[0].Id, 'Submitted');
            insert housingApp;
            
            Note note = new Note(ParentId=housingApp.Id,Title ='MOHCD Document Submission');
            insert note;
        
            CS_MOHCDHousingAppCCContainer ctrlCC = new CS_MOHCDHousingAppCCContainer();
            ctrlCC.memberInstance = new Housing_Application_Member__c();
            ctrlCC.memberAssetInstance = new Housing_Application_Asset__c();
        
            CS_MOHCDHousingAppCC ctrl;
            PageReference pref;
            
            Test.startTest();
                pref = Page.mohcdHousingApp;
                    pref.getParameters().put('t', '1');
                    pref.getParameters().put('pid', lProperties[0].Id);
                Test.setCurrentPage(pref);
                
                ctrl = new CS_MOHCDHousingAppCC();

                ctrl.memberInstance.First_Name__c = 'FName';
                ctrl.memberInstance.Last_Name__c = 'LName';
                ctrl.memberInstance.Gender__c = 'Female';
                ctrl.memberInstance.Occupation__c = 'Dev';
                ctrl.memberInstance.Date_of_Birth__c = date.newinstance(1900, 1, 1);
                ctrl.memberInstance.Applicant_Role__c = 'TestRole';
                ctrl.memberInstance.Relationship_to_Head_of_Household__c = 'Self';
                ctrl.memberInstance.Married_or_Domestic_Partnered__c = 'Yes';
                ctrl.memberInstance.Live_Or_Work_in_San_Francisco__c = 'Yes';
                ctrl.memberInstance.Does_this_appear_on_another_title__c = 'Yes';
                ctrl.memberInstance.Has_owned_a_unit_last_3_yrs__c = 'No';
                ctrl.memberInstance.In_School__c = 'No';
                ctrl.addMember();

                Housing_Application_Member__c hMem = [SELECT Id FROM Housing_Application_Member__c WHERE Housing_Application__c = :housingApp.Id];

                ctrl.memberIncomeInstance.RecordTypeId = getIncomeRecordType('Unemployed');
                ctrl.memberIncomeInstance.Housing_Application_Member__c = hMem.Id;
                ctrl.memberIncomeInstance.Annual_Unemployment_Benefits_Amount__c = 100;
                ctrl.memberIncomeInstance.Year_Unemployed__c = '1991';
                ctrl.memberIncomeInstance.Month_Unemployed__c = '10';
                ctrl.addMemberIncome();
                
                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('No Assets');
                ctrl.memberAssetInstance.Housing_Application_Member__c = hMem.Id;
                ctrl.memberAssetInstance.Asset_Type__c = 'No Assets';
                ctrl.memberAssetInstance.Land_Earned_Income_Per_Year__c = 100.00;
                ctrl.addMemberAsset();

                ctrl.haInstance = null;
                ctrl.createHousingApp();
            Test.stopTest();
            
            System.assert(ApexPages.getMessages().size()==0);
         }
    }
    
    static testMethod void testCreateHAppOwnership() {
        testData();
         
         System.runAs(hUser) {
            housingApp = CS_TestDataSetup.createHousingApplication(lProperties[1].Id, 'Submitted');
            insert housingApp;
            
            Note note = new Note(ParentId=housingApp.Id,Title ='MOHCD Document Submission');
            insert note;
        
            CS_MOHCDHousingAppCC ctrl;
            PageReference pref;
            
            Test.startTest();
                pref = Page.mohcdHousingApp;
                    pref.getParameters().put('t', '1');
                    pref.getParameters().put('pid', lProperties[1].Id);
                Test.setCurrentPage(pref);
                
                ctrl = new CS_MOHCDHousingAppCC();

                ctrl.memberInstance.First_Name__c = 'FName';
                ctrl.memberInstance.Last_Name__c = 'LName';
                ctrl.memberInstance.Gender__c = 'Female';
                ctrl.memberInstance.Occupation__c = 'Dev';
                ctrl.memberInstance.Date_of_Birth__c = date.newinstance(1900, 1, 1);
                ctrl.memberInstance.Applicant_Role__c = 'TestRole';
                ctrl.memberInstance.Relationship_to_Head_of_Household__c = 'Self';
                ctrl.memberInstance.Married_or_Domestic_Partnered__c = 'Yes';
                ctrl.memberInstance.Live_Or_Work_in_San_Francisco__c = 'Yes';
                ctrl.memberInstance.Does_this_appear_on_another_title__c = 'Yes';
                ctrl.memberInstance.Has_owned_a_unit_last_3_yrs__c = 'No';
                ctrl.memberInstance.In_School__c = 'No';
                ctrl.addMember();

                Housing_Application_Member__c hMem = [SELECT Id FROM Housing_Application_Member__c WHERE Housing_Application__c = :housingApp.Id];

                ctrl.memberIncomeInstance.RecordTypeId = getIncomeRecordType('Unemployed');
                ctrl.memberIncomeInstance.Housing_Application_Member__c = hMem.Id;
                ctrl.memberIncomeInstance.Annual_Unemployment_Benefits_Amount__c = 100;
                ctrl.memberIncomeInstance.Year_Unemployed__c = '1991';
                ctrl.memberIncomeInstance.Month_Unemployed__c = '10';
                ctrl.addMemberIncome();
                
                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('No Assets');
                ctrl.memberAssetInstance.Housing_Application_Member__c = hMem.Id;
                ctrl.memberAssetInstance.Asset_Type__c = 'No Assets';
                ctrl.memberAssetInstance.Land_Earned_Income_Per_Year__c = 100.00;
                ctrl.addMemberAsset();

                ctrl.haInstance = null;
                ctrl.createHousingApp();
            Test.stopTest();
            
            System.assert(ApexPages.getMessages().size()==0);
         }
    }
    
    static testMethod void testNoExistingHApp() {
        testData();
         
         System.runAs(hUser) {
            CS_MOHCDHousingAppCC ctrl;
            PageReference pref;
            
            Test.startTest();
                pref = Page.mohcdHousingApp;
                    pref.getParameters().put('t', '1');
                    pref.getParameters().put('pid', lProperties[1].Id);
                Test.setCurrentPage(pref);
                
                ctrl = new CS_MOHCDHousingAppCC();
                ctrl.haInstance = null;
                ctrl.createHousingApp();
                ctrl.haInstance = new Housing_Application__c();
                ctrl.submitApplication();
            Test.stopTest();
            
            System.assert(ApexPages.getMessages().size()==0);
         }
    }
    
    static testMethod void testsubmitHousingApp() {
       testData();
         
         System.runAs(hUser) {
            housingApp = CS_TestDataSetup.createHousingApplication(lProperties[1].Id, 'Submitted');
            insert housingApp;
            
            Note note = new Note(ParentId=housingApp.Id,Title ='MOHCD Document Submission');
            insert note;
        
            CS_MOHCDHousingAppCC ctrl;
            PageReference pref;
            
            Test.startTest();
                pref = Page.mohcdHousingApp;
                    pref.getParameters().put('t', '1');
                    pref.getParameters().put('pid', lProperties[1].Id);
                Test.setCurrentPage(pref);
                
                ctrl = new CS_MOHCDHousingAppCC();

                ctrl.memberInstance.First_Name__c = 'FName';
                ctrl.memberInstance.Last_Name__c = 'LName';
                ctrl.memberInstance.Gender__c = 'Female';
                ctrl.memberInstance.Occupation__c = 'Dev';
                ctrl.memberInstance.Date_of_Birth__c = date.newinstance(1900, 1, 1);
                ctrl.memberInstance.Applicant_Role__c = 'TestRole';
                ctrl.memberInstance.Relationship_to_Head_of_Household__c = 'Self';
                ctrl.memberInstance.Married_or_Domestic_Partnered__c = 'Yes';
                ctrl.memberInstance.Live_Or_Work_in_San_Francisco__c = 'Yes';
                ctrl.memberInstance.Does_this_appear_on_another_title__c = 'Yes';
                ctrl.memberInstance.Has_owned_a_unit_last_3_yrs__c = 'No';
                ctrl.memberInstance.In_School__c = 'No';
                ctrl.addMember();

                Housing_Application_Member__c hMem = [SELECT Id FROM Housing_Application_Member__c WHERE Housing_Application__c = :housingApp.Id];

                ctrl.memberInstance.First_Name__c = 'FName3';
                ctrl.memberInstance.Last_Name__c = 'LName3';
                ctrl.memberInstance.Gender__c = 'Male';
                ctrl.memberInstance.Occupation__c = 'Dev';
                ctrl.memberInstance.Date_of_Birth__c = date.newinstance(2005, 1, 1);
                ctrl.memberInstance.Applicant_Role__c = 'TestRole';
                ctrl.memberInstance.Relationship_to_Head_of_Household__c = 'Son';
                ctrl.memberInstance.Married_or_Domestic_Partnered__c = 'Yes';
                ctrl.memberInstance.Live_Or_Work_in_San_Francisco__c = 'Yes';
                ctrl.memberInstance.Does_this_appear_on_another_title__c = 'Yes';
                ctrl.memberInstance.Has_owned_a_unit_last_3_yrs__c = 'No';
                ctrl.memberInstance.In_School__c = 'No';
                ctrl.addMember();
                
                ctrl.memberIncomeInstance.RecordTypeId = getIncomeRecordType('Unemployed');
                ctrl.memberIncomeInstance.Housing_Application_Member__c = hMem.Id;
                ctrl.memberIncomeInstance.Annual_Unemployment_Benefits_Amount__c = 100;
                ctrl.memberIncomeInstance.Year_Unemployed__c = '1991';
                ctrl.memberIncomeInstance.Month_Unemployed__c = '10';
                ctrl.addMemberIncome();
                
                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('No Assets');
                ctrl.memberAssetInstance.Housing_Application_Member__c = hMem.Id;
                ctrl.memberAssetInstance.Asset_Type__c = 'No Assets';
                ctrl.memberAssetInstance.Land_Earned_Income_Per_Year__c = 100.00;
                ctrl.addMemberAsset();
                
                ctrl.submitApplication();
                
                ctrl.memberInstance.First_Name__c = 'FName2';
                ctrl.memberInstance.Last_Name__c = 'LName2';
                ctrl.memberInstance.Gender__c = 'Male';
                ctrl.memberInstance.Occupation__c = 'Dev';
                ctrl.memberInstance.Date_of_Birth__c = date.newinstance(1900, 1, 1);
                ctrl.memberInstance.Applicant_Role__c = 'TestRole';
                ctrl.memberInstance.Relationship_to_Head_of_Household__c = 'Self';
                ctrl.memberInstance.Married_or_Domestic_Partnered__c = 'Yes';
                ctrl.memberInstance.Live_Or_Work_in_San_Francisco__c = 'Yes';
                ctrl.memberInstance.Does_this_appear_on_another_title__c = 'Yes';
                ctrl.memberInstance.Has_owned_a_unit_last_3_yrs__c = 'No';
                ctrl.memberInstance.In_School__c = 'No';
                ctrl.addMember();
                
                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('Business Ownership');
                ctrl.memberAssetInstance.Housing_Application_Member__c = hMem.Id;
                ctrl.memberAssetInstance.Asset_Type__c = 'Business Ownership';
                ctrl.memberAssetInstance.Land_Earned_Income_Per_Year__c = 100.00;
                ctrl.memberAssetInstance.Name_of_Business__c = 'Business Test';
                ctrl.memberAssetInstance.Address_of_Business__c = 'Business Test Address';
                ctrl.memberAssetInstance.Amount_Earned_Per_Year_from_Business__c = 100;
                ctrl.addMemberAsset();

                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('Land Ownership');
                ctrl.memberAssetInstance.Housing_Application_Member__c = hMem.Id;
                ctrl.memberAssetInstance.Asset_Type__c = 'Land Ownership';
                ctrl.memberAssetInstance.Land_Earned_Income_Per_Year__c = 100.00;
                ctrl.memberAssetInstance.Land_Address_or_Parcel_Desc__c = 'Business Test';
                ctrl.memberAssetInstance.Current_Value_of_Land__c = 100;
                ctrl.memberAssetInstance.Landowner_Earns_Income_from_Land__c = 'No';
                ctrl.addMemberAsset();
                
                ctrl.submitApplication();
            Test.stopTest();
            
            System.assert(ApexPages.getMessages().size()>0);
            
            Boolean isNotCreated = false;
            
            try {
                SFMOHCD_DAO.createhAppAsset(acc.Id,housingApp.Id);
            } catch (Exception e) {
                isNotCreated = true;
            }
            System.assert(isNotCreated);
   
            try {
                SFMOHCD_DAO.createhAppIncome(acc.Id,housingApp.Id);
            } catch (Exception e) {
                isNotCreated = true;    
            }
            System.assert(isNotCreated);
         }
    }
    
    static testMethod void testsubmitWrongHousingApp() {
       testData();
         
         System.runAs(hUser) {
             
            Id copCertRTId = [SELECT Id FROM RecordType Where Name = 'COP' AND SobjectType = 'Certificate_Program__c' LIMIT 1].Id;
            Id eahpCertRTId = [SELECT Id FROM RecordType Where Name = 'EAHP' AND SobjectType = 'Certificate_Program__c' LIMIT 1].Id;
            
            List<Certificate_Program__c> lCP = new List<Certificate_Program__c>();        
            copCert = new Certificate_Program__c(Household_Contact__c = con.Id, Household_Account__c = acc.Id, RecordTypeId = copCertRTId, COPP_Rental_Used__c = TRUE, COPP_Ownership_Used__c = TRUE); 
            eahpCert = new Certificate_Program__c(Household_Contact__c = con.Id, Household_Account__c = acc.Id, RecordTypeId = eahpCertRTId, EAHP_Certificate_Used__c = TRUE, Expiration_Date_for_Existing_Properties__c = System.Today()); 
            lCP.add(copCert);
            lCP.add(eahpCert);
            insert lCP;
             
            copCert = [SELECT Name FROM Certificate_Program__c WHERE Id = :lCP[0].Id];
             
            housingApp = CS_TestDataSetup.createHousingApplication(lProperties[1].Id, 'Submitted');
            housingApp.Certificate_of_Preference_Holder__c = true;
            housingApp.Certificate_of_Preference_Number__c = copCert.Name;
            housingApp.EAHP_Certificate_Holder__c = true;
            housingApp.EAHP_Certificate_Expiration_Date__c = Date.TODAY();
            
            insert housingApp;
            
            Note note = new Note(ParentId=housingApp.Id,Title ='MOHCD Document Submission');
            insert note;
        
            CS_MOHCDHousingAppCC ctrl;
            PageReference pref;
            
            Test.startTest();
                pref = Page.mohcdHousingApp;
                    pref.getParameters().put('t', '1');
                    pref.getParameters().put('pid', lProperties[1].Id);
                Test.setCurrentPage(pref);
                
                ctrl = new CS_MOHCDHousingAppCC();

                ctrl.memberInstance.First_Name__c = 'FName';
                ctrl.memberInstance.Last_Name__c = 'LName';
                ctrl.memberInstance.Gender__c = 'Female';
                ctrl.memberInstance.Occupation__c = 'Dev';
                ctrl.memberInstance.Date_of_Birth__c = date.newinstance(1900, 1, 1);
                ctrl.memberInstance.Applicant_Role__c = 'TestRole';
                ctrl.memberInstance.Relationship_to_Head_of_Household__c = 'Self';
                ctrl.memberInstance.Married_or_Domestic_Partnered__c = 'Yes';
                ctrl.memberInstance.Live_Or_Work_in_San_Francisco__c = 'Yes';
                ctrl.memberInstance.Does_this_appear_on_another_title__c = 'Yes';
                ctrl.memberInstance.Has_owned_a_unit_last_3_yrs__c = 'No';
                ctrl.memberInstance.In_School__c = 'No';
                ctrl.addMember();

                Housing_Application_Member__c hMem = [SELECT Id FROM Housing_Application_Member__c WHERE Housing_Application__c = :housingApp.Id];

                ctrl.memberIncomeInstance.RecordTypeId = getIncomeRecordType('Unemployed');
                ctrl.memberIncomeInstance.Housing_Application_Member__c = hMem.Id;
                ctrl.memberIncomeInstance.Annual_Unemployment_Benefits_Amount__c = 100;
                ctrl.memberIncomeInstance.Year_Unemployed__c = '1991';
                ctrl.memberIncomeInstance.Month_Unemployed__c = '10';
                ctrl.addMemberIncome();
                
                ctrl.memberAssetInstance.RecordTypeId = getAssetRecordType('No Assets');
                ctrl.memberAssetInstance.Housing_Application_Member__c = hMem.Id;
                ctrl.memberAssetInstance.Asset_Type__c = 'No Assets';
                ctrl.memberAssetInstance.Land_Earned_Income_Per_Year__c = 100.00;
                ctrl.addMemberAsset();
                
                ctrl.submitApplication();
                
                ctrl.memberInstance.First_Name__c = 'FName3';
                ctrl.memberInstance.Last_Name__c = 'LName3';
                ctrl.memberInstance.Gender__c = 'Male';
                ctrl.memberInstance.Occupation__c = 'Dev';
                ctrl.memberInstance.Date_of_Birth__c = date.newinstance(1900, 1, 1);
                ctrl.memberInstance.Applicant_Role__c = 'TestRole';
                ctrl.memberInstance.Relationship_to_Head_of_Household__c = 'Brother';
                ctrl.memberInstance.Married_or_Domestic_Partnered__c = 'Yes';
                ctrl.memberInstance.Live_Or_Work_in_San_Francisco__c = 'Yes';
                ctrl.memberInstance.Does_this_appear_on_another_title__c = 'Yes';
                ctrl.memberInstance.Has_owned_a_unit_last_3_yrs__c = 'No';
                ctrl.memberInstance.In_School__c = 'No';
                ctrl.addMember();
                
                ctrl.submitApplication();
            Test.stopTest();
            
            System.assert(ApexPages.getMessages().size()>0);
         }
    }
}