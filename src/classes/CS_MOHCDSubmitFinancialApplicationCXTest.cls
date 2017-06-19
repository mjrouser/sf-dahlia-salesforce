@isTest
private class CS_MOHCDSubmitFinancialApplicationCXTest {
    
    private static Account acc;
    private static Contact con;
    private static Contact con1;
    private static List<Properties__c> lProperties;
    private static Housing_Application__c housingApp;
    private static Financial_Application__c financialApp;
    private static Financial_Application_Member__c financialMember;
    private static Financial_Application_Income__c financialIncome;
    private static Financial_Application_Asset__c financialAsset;
    private static User hUser;
    
    static void testData(){
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
        insert acc;
        
        Id lenderConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        con = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', lenderConRTId);
        insert con;        
        
        Id pIncomeRTId = Schema.SObjectType.Personal_Income__c.getRecordTypeInfosByName().get('Employment Income').getRecordTypeId();
        Personal_Income__c pIncome = new Personal_Income__c(Household_Account__c=acc.Id,Household_Member__c=con.Id, RecordTypeId =pIncomeRTId);
        insert pIncome;

        Id pAssetRTId = Schema.SObjectType.Personal_Asset__c.getRecordTypeInfosByName().get('Assets with an Account').getRecordTypeId();
        Personal_Asset__c pAsset = new Personal_Asset__c(Household_Account__c=acc.Id,Household_Member__c=con.Id,RecordTypeId =pAssetRTId);
        insert pAsset;

        Id mohcdHouseholdProfileId = [SELECT Id FROM Profile WHERE Name = :StringConstants.HOUSEHOLD_PROFILE LIMIT 1].Id;
        hUser = CS_TestDataSetup.createTestPortalUser('FName1', 'LName1', 'test1@fakemail.com', mohcdHouseholdProfileId, con.Id);
        insert hUser;

        lProperties = new List<Properties__c>();
        Id propRtId = Schema.SObjectType.Properties__c.getRecordTypeInfosByName().get('Property').getRecordTypeId();
        lProperties.add(CS_TestDataSetup.createTestProperties(130000, 'Rental', 4.5, 2, 'New', 'Condo', 'Castro', propRtId));
        lProperties.add(CS_TestDataSetup.createTestProperties(130000, 'Ownership', 4.5, 2, 'New', 'Apartment', 'Castro', propRtId));
        insert lProperties;
                
        housingApp = CS_TestDataSetup.createHousingApplication(lProperties[0].Id, 'Submitted');
        insert housingApp;
        
        Id dalpRTId = Schema.SObjectType.Financial_Application__c.getRecordTypeInfosByName().get('DALP').getRecordTypeId();        
        financialApp = CS_TestDataSetup.createFinancialApplication(housingApp.Id, 'Submitted', acc.Id, dalpRTId, con.Id);
        insert financialApp;
        
        financialMember = CS_TestDataSetup.createFinancialApplicationMember(financialApp.Id, 'Primary Borrower', 'Test', 'Member', System.today()-10000, 'Spouse');
        insert financialMember;
        
        Id fimIncomeRTId = Schema.SObjectType.Financial_Application_Income__c.getRecordTypeInfosByName().get('Unemployed').getRecordTypeId();        
        financialIncome = CS_TestDataSetup.createFinancialApplicationMemberIncome(financialApp.Id, financialMember.Id, fimIncomeRTId);
        insert financialIncome;
        
        Id fimAssetRTId = Schema.SObjectType.Financial_Application_Asset__c.getRecordTypeInfosByName().get('Cash without an Account').getRecordTypeId();        
        financialAsset = CS_TestDataSetup.createFinancialApplicationMemberAsset(financialApp.Id, financialMember.Id, fimAssetRTId);
        insert financialAsset;
    }

    static testMethod void testMOHCDSubmitFinancialApplicationCX() {
        testData();
    
        Test.startTest();
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(financialApp); 
        CS_MOHCDSubmitFinancialApplicationCX controller = new CS_MOHCDSubmitFinancialApplicationCX(stdController);       
        controller.init();
        
        financialApp = new Financial_Application__c();
        stdController = new ApexPages.StandardController(financialApp); 
        controller = new CS_MOHCDSubmitFinancialApplicationCX(stdController);
        controller.init();
        
        Test.stopTest();

        System.assert(financialApp.Id == null);
    }    

    static testMethod void testMOHCDSubmitFinancialApplicationCXError() {
        testData();
    
        Test.startTest();
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(financialApp); 
        CS_MOHCDSubmitFinancialApplicationCX controller = new CS_MOHCDSubmitFinancialApplicationCX(stdController);       
        controller.init();
        
        financialApp = new Financial_Application__c();
        stdController = new ApexPages.StandardController(financialApp); 
        controller = new CS_MOHCDSubmitFinancialApplicationCX(stdController);
        controller.faInstance.Application_Status__c = 'Submitted';
        controller.init();
        
        Test.stopTest();    

        System.assert(controller.faInstance.Application_Status__c == 'Submitted');
    }    

    static testMethod void testMOHCDSubmitFinancialApplicationCXPrepareContactList() {
        testData();

        Test.startTest();
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(financialApp); 
        CS_MOHCDSubmitFinancialApplicationCX controller = new CS_MOHCDSubmitFinancialApplicationCX(stdController);       
        Map<String, Contact> contacts = controller.prepareContactList(new List<Financial_Application_Member__c>());                
        Test.stopTest();    

        System.assert(contacts == null);
    }   

    static testMethod void testMOHCDSubmitFinancialApplicationCXCatchMessage() {
        testData();
        
        Test.startTest();
            
             System.RunAs(hUser){
                LIst<Properties__c> lProperties2 = new List<Properties__c>();
                Id propRtId = Schema.SObjectType.Properties__c.getRecordTypeInfosByName().get('Property').getRecordTypeId();
                lProperties2.add(CS_TestDataSetup.createTestProperties(130000, 'Rental', 4.5, 2, 'New', 'Condo', 'Castro', propRtId));
                lProperties2.add(CS_TestDataSetup.createTestProperties(130000, 'Ownership', 4.5, 2, 'New', 'Apartment', 'Castro', propRtId));
                insert lProperties2;
                        
                Housing_Application__c housingApp2 = CS_TestDataSetup.createHousingApplication(lProperties2[0].Id, 'Submitted');
                insert housingApp2;
                
                Id dalpRTId = Schema.SObjectType.Financial_Application__c.getRecordTypeInfosByName().get('DALP').getRecordTypeId();        
                Financial_Application__c financialApp2 = CS_TestDataSetup.createFinancialApplication(housingApp2.Id, 'Not Yet Submitted', acc.Id, dalpRTId, con.Id);
                financialApp2.Copy_Existing_Info__c = true;
                insert financialApp2;
                
                Financial_Application_Member__c financialMember2 = CS_TestDataSetup.createFinancialApplicationMember(financialApp2.Id, 'Primary Borrower', 'Test', 'Member', System.today()-10000, 'Spouse');
                insert financialMember2;
                
                Id fimIncomeRTId = Schema.SObjectType.Financial_Application_Income__c.getRecordTypeInfosByName().get('Employment Income').getRecordTypeId();        
                Financial_Application_Income__c financialIncome2 = CS_TestDataSetup.createFinancialApplicationMemberIncome(financialApp2.Id, financialMember2.Id, fimIncomeRTId);
                insert financialIncome2;
                
                Id fimAssetRTId = Schema.SObjectType.Financial_Application_Asset__c.getRecordTypeInfosByName().get('Cash without an Account').getRecordTypeId();        
                Financial_Application_Asset__c financialAsset2 = CS_TestDataSetup.createFinancialApplicationMemberAsset(financialApp2.Id, financialMember2.Id, fimAssetRTId);
                insert financialAsset2;
        
                ApexPages.StandardController stdController = new ApexPages.StandardController(financialApp2); 
                CS_MOHCDSubmitFinancialApplicationCX controller = new CS_MOHCDSubmitFinancialApplicationCX(stdController);       
                controller.init();                                
            }
        Test.stopTest();
    }

    static testMethod void testMOHCDSubmitFinancialApplicationCXHappyPath() {
        testData();
        
        Test.startTest();
            
             System.RunAs(hUser){
                LIst<Properties__c> lProperties2 = new List<Properties__c>();
                Id propRtId = Schema.SObjectType.Properties__c.getRecordTypeInfosByName().get('Property').getRecordTypeId();
                lProperties2.add(CS_TestDataSetup.createTestProperties(130000, 'Rental', 4.5, 2, 'New', 'Condo', 'Castro', propRtId));
                lProperties2.add(CS_TestDataSetup.createTestProperties(130000, 'Ownership', 4.5, 2, 'New', 'Apartment', 'Castro', propRtId));
                insert lProperties2;
                        
                Housing_Application__c housingApp2 = CS_TestDataSetup.createHousingApplication(lProperties2[0].Id, 'Submitted');
                housingApp2.Household_Account__c = acc.Id;
                insert housingApp2;
                
                Id dalpRTId = Schema.SObjectType.Financial_Application__c.getRecordTypeInfosByName().get('DALP').getRecordTypeId();        
                Financial_Application__c financialApp2 = CS_TestDataSetup.createFinancialApplication(housingApp2.Id, 'Not Yet Submitted', acc.Id, dalpRTId, con.Id);
                financialApp2.Copy_Existing_Info__c = true;
                insert financialApp2;
                
                Financial_Application_Member__c financialMember2 = CS_TestDataSetup.createFinancialApplicationMember(financialApp2.Id, 'Primary Borrower', 'Test', 'Member', System.today()-10000, 'Spouse');
                insert financialMember2;
                
                Id fimIncomeRTId = Schema.SObjectType.Financial_Application_Income__c.getRecordTypeInfosByName().get('Employment Income').getRecordTypeId();        
                Financial_Application_Income__c financialIncome2 = CS_TestDataSetup.createFinancialApplicationMemberIncome(financialApp2.Id, financialMember2.Id, fimIncomeRTId);
                insert financialIncome2;
                
                Id fimAssetRTId = Schema.SObjectType.Financial_Application_Asset__c.getRecordTypeInfosByName().get('Cash without an Account').getRecordTypeId();        
                Financial_Application_Asset__c financialAsset2 = CS_TestDataSetup.createFinancialApplicationMemberAsset(financialApp2.Id, financialMember2.Id, fimAssetRTId);
                insert financialAsset2;
        
                ApexPages.StandardController stdController = new ApexPages.StandardController(financialApp2); 
                CS_MOHCDSubmitFinancialApplicationCX controller = new CS_MOHCDSubmitFinancialApplicationCX(stdController);       
                controller.init();                                
            }
        Test.stopTest();
    }

}