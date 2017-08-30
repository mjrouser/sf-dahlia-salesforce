@isTest
private class CS_MOHCDLoginCCTest {
    
    private static List<Properties__c> lProperties;
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
        
        Profile prof = [SELECT Id, Name FROM Profile WHERE Name = 'MOHCD - Household' LIMIT 1];
        usr = CS_TestDataSetup.createTestPortalUser('FName1', 'LName1', 'test@salesforce.com', prof.Id, con.Id);
        insert usr;
        System.assertNotEquals(null, usr.Id);         
        
        lProperties = new List<Properties__c>();
        Id propRtId = Schema.SObjectType.Properties__c.getRecordTypeInfosByName().get('Property').getRecordTypeId();
        lProperties.add(CS_TestDataSetup.createTestProperties(130000, 'Rental', 4.5, 2, 'New', 'Condo', 'Castro', propRtId));
        lProperties.add(CS_TestDataSetup.createTestProperties(130000, 'Ownership', 4.5, 2, 'New', 'Apartment', 'Castro', propRtId));
        insert lProperties;       
        
    }
    
    static testMethod void testMOHCDLoginCC() {
    
        Test.startTest();
       
        PageReference pref = Page.mohcdLoginDirect; 
            pref.getParameters().put('propid', lProperties[0].Id);
        Test.setCurrentPage(pref);        
        
        CS_MOHCDLoginCC controller = new CS_MOHCDLoginCC();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
        controller.login(); 
        
        controller.username = '';
        controller.password = '123456'; 
        controller.login(); 
        
        for(Integer i=0; i<=5; i++) {
            controller.login();
        }
        
        pref = Page.mohcdLogin;
            pref.getParameters().put('propid', lProperties[0].Id);
        Test.setCurrentPage(pref);        
        
        controller = new CS_MOHCDLoginCC();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
        controller.login(); 
        
        controller.username = '';
        controller.password = '123456'; 
        controller.login(); 
        
        System.runAs(usr){
            controller.getItems();
            controller.setRadio('0');
            controller.getRadio();
            controller.onNext();    
            controller.setRadio('1');
            controller.getRadio();
            controller.onNext();    
        }        
                    
        for(Integer i=0; i<=5; i++) {
            controller.login();
        }

        Test.stopTest(); 

        System.assert(System.currentPageReference().getParameters().get('propid') == lProperties[0].Id,System.currentPageReference().getParameters().get('propid'));   
    }

    static testMethod void testMOHCDLoginCCWithoutProperty() {
    
        Test.startTest();
       
        PageReference pref = Page.mohcdLoginDirect; 
        Test.setCurrentPage(pref);        
        
        CS_MOHCDLoginCC controller = new CS_MOHCDLoginCC();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
        controller.login(); 
        
        controller.username = '';
        controller.password = '123456'; 
        controller.login(); 
        
        for(Integer i=0; i<=5; i++) {
            controller.login();
        }
        
        pref = Page.mohcdLogin;
            pref.getParameters().put('propid', lProperties[0].Id);
        Test.setCurrentPage(pref);        
        
        controller = new CS_MOHCDLoginCC();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
        controller.login(); 
        controller.closePopUp();

        controller.username = '';
        controller.password = '123456'; 
        controller.login(); 
        
        for(Integer i=0; i<=5; i++) {
            controller.login();
        }
        
        Test.stopTest(); 

        System.assert(controller.login()==null,controller.login());   
    }       
}