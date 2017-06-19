@isTest
private class CS_MOHCDTemplateCCTest {
    
    private static Account acc;
    private static Contact con;
    private static User usr;    

    static {
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
        insert acc;
        System.assertNotEquals(null, acc.Id);
        
        Id householdConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        con = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', householdConRTId);
        insert con;
        System.assertNotEquals(null, con.Id); 

        Profile prof = [SELECT Id, Name FROM Profile WHERE Name = 'MOHCD - Lender' LIMIT 1];
        usr = CS_TestDataSetup.createTestPortalUser('FName1', 'LName1', 'test1@fakemail.com', prof.Id, con.Id);
        insert usr;
        System.assertNotEquals(null, usr.Id);
    }
    
    static testMethod void testMOHCDTemplateCC() {

        PageReference pageRet;
    
        Test.startTest();
        
        System.runAs(usr) {            
            CS_MOHCDTemplateCC controller = new CS_MOHCDTemplateCC();  
            pageRet = controller.forwardToCustomAuthPage();
        }
        
        System.assert(pageRet.getUrl().contains('/home/home.jsp'));

        CS_MOHCDTemplateCC controller = new CS_MOHCDTemplateCC();  
        pageRet = controller.forwardToCustomAuthPage();
        
        Test.stopTest();    

        System.assert(pageRet == null);
    }    

    static testMethod void testMOHCDTemplateCCForGuest() {       
        PageReference pageReturn;

        User guestUser = CS_TestDataSetup.createGuestUser();

        Test.startTest();
            System.runAs(guestUser) {            
                CS_MOHCDTemplateCC controller = new CS_MOHCDTemplateCC();  
                pageReturn = controller.forwardToCustomAuthPage();
            }                
        Test.stopTest();

        System.assert(pageReturn.getUrl().contains('/mohcdLogin'));            
    }    
}