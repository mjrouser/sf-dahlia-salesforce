@isTest
private class CS_MOHCDViewMyCertsCCTest {
    
    private static Account acc;
    private static Contact con;
    private static User usr;    
    private static Certificate_Program__c certPgm;

    static {
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
        insert acc;
        System.assertNotEquals(null, acc.Id);
        
        Id lenderConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Lending Agent').getRecordTypeId();
        con = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', lenderConRTId);
        insert con;
        System.assertNotEquals(null, con.Id); 

        Profile prof = [SELECT Id, Name FROM Profile WHERE Name = 'MOHCD - Household' LIMIT 1];
        usr = CS_TestDataSetup.createTestPortalUser('FName1', 'LName1', 'test1@fakemail.com', prof.Id, con.Id);
        insert usr;
        System.assertNotEquals(null, usr.Id); 
        
        Id eahpRTId = Schema.SObjectType.Certificate_Program__c.getRecordTypeInfosByName().get('EAHP').getRecordTypeId();
        certPgm = CS_TestDataSetup.createCertificateProgram('Submitted', con.Id, acc.Id, System.today(), eahpRTId);
        insert certPgm;
        System.assertNotEquals(null, certPgm.Id); 
    }
    
    static testMethod void testMOHCDViewMyCertsCC() {
    
        Test.startTest();        
        
        System.runAs(usr) {            
            CS_MOHCDViewMyCertsCC controller = new CS_MOHCDViewMyCertsCC();       
            System.assert(controller.lMyCertificatePrograms.size() > 0);
        }
        
        Test.stopTest();    
    }    
}