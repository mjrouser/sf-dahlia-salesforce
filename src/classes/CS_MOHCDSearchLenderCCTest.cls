@isTest
private class CS_MOHCDSearchLenderCCTest {
    
    private static Account acc;
    private static Contact con;
    private static Contact con1;

    static {
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
        insert acc;
        System.assertNotEquals(null, acc.Id);
        
        Id lenderConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Lending Agent').getRecordTypeId();
        con = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', lenderConRTId);
        insert con;
        System.assertNotEquals(null, con.Id); 
        
        con1 = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', lenderConRTId);
        insert con1;
        System.assertNotEquals(null, con1.Id); 
    }
    
    static testMethod void testMOHCDSearchLenderCC() {
    
        Test.startTest();        
        
        PageReference pref = Page.mohcdSearchLender; 
            pref.getParameters().put('m', 'dpa');
        Test.setCurrentPage(pref);
               
        CS_MOHCDSearchLenderCC controller = new CS_MOHCDSearchLenderCC();       
        System.assert(controller.lLenderWraps.size() > 0);
        controller.goBackToFinRequest();
        
        controller = new CS_MOHCDSearchLenderCC();       
        System.assert(controller.lLenderWraps.size() > 0);
        controller.lLenderWraps[0].isSelected = true;        
        controller.goBackToFinRequest();
        
        controller = new CS_MOHCDSearchLenderCC();       
        System.assert(controller.lLenderWraps.size() > 0);
        controller.lLenderWraps[0].isSelected = true;
        controller.lLenderWraps[1].isSelected = true;
        controller.goBackToFinRequest();
        
        pref = Page.mohcdSearchLender; 
            pref.getParameters().put('m', 'cml');
        Test.setCurrentPage(pref);
        
        controller = new CS_MOHCDSearchLenderCC();       
        System.assert(controller.lLenderWraps.size() > 0);
        controller.lLenderWraps[0].isSelected = true;
        controller.goBackToFinRequest();
        
        Test.stopTest();    
    }    
}