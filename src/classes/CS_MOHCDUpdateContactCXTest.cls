@isTest
private class CS_MOHCDUpdateContactCXTest {

    private static Account acc;
    private static Account portalAccount1;
    private static Contact con;
    private static Contact contact1;
    private static User user1;
    private static User testUser;
    private static User portalUser;
    private static User portalAccountOwner1;
    
    
    
    static testMethod void UpdateContactCX(){
    
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile testUserID = [Select Id from Profile where name = 'System Administrator'];
        testUser = CS_TestDataSetup.createTestUser('FName1', 'LName1', testUserID.Id);       
        testUser.UserRoleId = portalRole.Id;    
        insert testUser;
        
        System.RunAs(testUser){
            Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
            acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
            acc.OwnerId = testUser.Id;
            acc.Work_Phone__c = '5082444';
            acc.Mobile_Phone__c = '09161445787';
            acc.Phone = '09161445890';
            acc.Zip_Code__c = '4012';
            acc.City__c = 'sta rosa';
            acc.Street_Name__c = 'name';
            acc.Street_Number__c = 'num';
            acc.Street_Type__c = 'type';
            acc.Apt_Unit__c = 'unit';
            acc.State__c = 'California';
            acc.Email__c = 'email@email.com';
            insert acc;
            System.assertNotEquals(null, acc.Id);     
            
            Id lenderConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Lending Agent').getRecordTypeId();          
            con = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', lenderConRTId);
            con.Work_Phone__c = '5082444';
            con.MobilePhone = '09161445787';
            con.Phone = '09161445890';
            con.Zip_Code__c = '4012';
            con.City__c = 'sta rosa';
            con.Street_Name__c = 'name';
            con.Street_Number__c = 'num';
            con.Street_Type__c = 'type';
            con.Apt_Unit__c = 'unit';
            con.State__c = 'California';
            con.Email = 'email@email.com';
            insert con;
            System.assertNotEquals(null, con.Id);           
            
            
            Profile portalUserID = [SELECT Id, Name FROM Profile WHERE Name = 'MOHCD - Household' LIMIT 1];
            portalUser = CS_TestDataSetup.createTestPortalUser('First Name', 'Last Name', 'email@email.com' , portalUserID.id, con.id);
            insert portalUser;          
        }  
    
        Test.startTest();
        System.RunAs(portalUser){
            CS_MOHCDUpdateContactCX controller = new CS_MOHCDUpdateContactCX();
              
            controller.updatePhone = '09161445890';
            controller.updateMobilePhone = '09161445787';
            controller.updateWorkPhone = '5082444';
            controller.updateEmail = 'email@email.com';
            controller.updateStreetNumber = 'num';
            controller.updateStreetName = 'name';
            controller.updateStreetType = 'type';
            controller.updateAptUnit = 'unit';
            controller.updateCity = 'sta rosa';
            controller.updateState = 'California';
            controller.updateZipCode = '4012';
            controller.updateInfo();
        }
    
        Test.stopTest();        
    }

    static testMethod void UpdateContactCXUpdateContactInfo(){
        List<Profile> profiles = new List<Profile>([SELECT Id FROM Profile where Name = 'MOHCD - Household' LIMIT 1]);
        
        Account a = new Account(Name='Test Account Name');
        insert a;
 
        Contact contact = new Contact(LastName='testUserData',Email='testUserDataUnique@email.com', AccountId = a.id);
        insert contact;

        User usrVar = new User( Username = 'testUserDataUnique@email.com', FirstName='testUserData userFirstName', LastName = 'testUserData userLName', Alias = 'testA',
                                    CommunityNickname = 'testUserData',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',EmailEncodingKey = 'ISO-8859-1',
                                    LanguageLocaleKey = 'en_US', Email = 'test@email.com',ProfileId = profiles.get(0).Id, ContactId = contact.Id, IsActive = true);

        System.runAs(usrVar){
            ApexPages.StandardController thecontroller = new ApexPages.StandardController(usrVar);
            
            CS_MOHCDUpdateContactCX controller = new CS_MOHCDUpdateContactCX(thecontroller);
            controller.updateInfo();
        }
    }

    static testMethod void UpdateContactCXUpdateContactInfoDMLException(){
        try{
            List<Profile> profiles = new List<Profile>([SELECT Id FROM Profile where Name = 'MOHCD - Household' LIMIT 1]);
            
            Account a = new Account(Name='Test Account Name');
            insert a;
     
            Contact contact = new Contact(LastName='testUserData',Email='testUserDataUnique@email.com', AccountId = a.id);
            insert contact;

            User usrVar = new User( Username = 'testUserDataUnique@email.com', FirstName='testUserData userFirstName', LastName = 'testUserData userLName', Alias = 'testA',
                                        CommunityNickname = 'testUserData',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',EmailEncodingKey = 'ISO-8859-1',
                                        LanguageLocaleKey = 'en_US', Email = 'test@email.com',ProfileId = profiles.get(0).Id, ContactId = contact.Id, IsActive = true);

            System.runAs(usrVar){
                ApexPages.StandardController thecontroller = new ApexPages.StandardController(usrVar);
                
                CS_MOHCDUpdateContactCX controller = new CS_MOHCDUpdateContactCX(thecontroller);
                controller.currentUserContact.LastName = null;
                controller.updateInfo();
            }
        }catch(Exception e){
            System.assert(e.getMessage()=='',e.getMessage());
        }
    }
    
    static testMethod void UpdateContactCXStandardController(){
    
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile testUserID = [Select Id from Profile where name = 'System Administrator'];
        testUser = CS_TestDataSetup.createTestUser('FName1', 'LName1', testUserID.Id);       
        testUser.UserRoleId = portalRole.Id;    
        insert testUser;
        
        System.RunAs(testUser){
            Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
            acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
            acc.OwnerId = testUser.Id; 
            acc.Work_Phone__c = '5082444';
            acc.Mobile_Phone__c = '09161445787';
            acc.Phone = '09161445890';
            acc.Zip_Code__c = '4012';
            acc.City__c = 'sta rosa';
            acc.Street_Name__c = 'name';
            acc.Street_Number__c = 'num';
            acc.Street_Type__c = 'type';
            acc.Apt_Unit__c = 'unit';
            acc.State__c = 'California';
            acc.Email__c = 'email@email.com';
            insert acc;
            System.assertNotEquals(null, acc.Id);     
            
            Id lenderConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Lending Agent').getRecordTypeId();          
            con = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', lenderConRTId);
            con.Work_Phone__c = '5082444';
            con.MobilePhone = '09161445787';
            con.Phone = '09161445890';
            con.Zip_Code__c = '4012';
            con.City__c = 'sta rosa';
            con.Street_Name__c = 'name';
            con.Street_Number__c = 'num';
            con.Street_Type__c = 'type';
            con.Apt_Unit__c = 'unit';
            con.State__c = 'California';
            con.Email = 'email@email.com';
            insert con;
            System.assertNotEquals(null, con.Id);           
            
            
            Profile portalUserID = [SELECT Id, Name FROM Profile WHERE Name = 'MOHCD - Household' LIMIT 1];
            portalUser = CS_TestDataSetup.createTestPortalUser('First Name', 'Last Name', 'email@email.com' , portalUserID.id, con.id);
            insert portalUser;          
        }  
    
        Test.startTest();
        System.RunAs(portalUser){
    
            ApexPages.StandardController thecontroller = new ApexPages.StandardController(portalUser);
            
            CS_MOHCDUpdateContactCX controller = new CS_MOHCDUpdateContactCX(thecontroller);     
            
            controller.updatePhone = '09161445890';
            controller.updateMobilePhone = '09161445787';
            controller.updateWorkPhone = '5082444';
            controller.updateEmail = 'email@email.com';
            controller.updateStreetNumber = 'num';
            controller.updateStreetName = 'name';
            controller.updateStreetType = 'type';
            controller.updateAptUnit = 'unit';
            controller.updateCity = 'sta rosa';
            controller.updateState = 'California';
            controller.updateZipCode = '4012';
            controller.contactID = con.Id;
            controller.updateInfo();
        }
    
        Test.stopTest();        
    }

    static testMethod void SelfUpdateContactCX(){
    
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile testUserID = [Select Id from Profile where name = 'System Administrator'];
        testUser = CS_TestDataSetup.createTestUser('FName1', 'LName1', testUserID.Id);       
        testUser.UserRoleId = portalRole.Id;    
        insert testUser;
        
        System.RunAs(testUser){
            Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
            acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
            acc.OwnerId = testUser.Id;
            acc.Work_Phone__c = '5082444';
            acc.Mobile_Phone__c = '09161445787';
            acc.Phone = '09161445890';
            acc.Zip_Code__c = '4012';
            acc.City__c = 'sta rosa';
            acc.Street_Name__c = 'name';
            acc.Street_Number__c = 'num';
            acc.Street_Type__c = 'type';
            acc.Apt_Unit__c = 'unit';
            acc.State__c = 'California';
            acc.Email__c = 'email@email.com';
            insert acc;
            System.assertNotEquals(null, acc.Id);     
            
            Id lenderConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Lending Agent').getRecordTypeId();          
            con = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', lenderConRTId);
            con.Work_Phone__c = '5082444';
            con.MobilePhone = '09161445787';
            con.Phone = '09161445890';
            con.Zip_Code__c = '4012';
            con.City__c = 'sta rosa';
            con.Street_Name__c = 'name';
            con.Street_Number__c = 'num';
            con.Street_Type__c = 'type';
            con.Apt_Unit__c = 'unit';
            con.State__c = 'California';
            con.Email = 'email@email.com';
            insert con;
            System.assertNotEquals(null, con.Id);           
            
            
            Profile portalUserID = [SELECT Id, Name FROM Profile WHERE Name = 'MOHCD - Household' LIMIT 1];
            portalUser = CS_TestDataSetup.createTestPortalUser('First Name', 'Last Name', 'email@email.com' , portalUserID.id, con.id);
            insert portalUser;          
        }  
    
        Test.startTest();
        System.RunAs(portalUser){
            UpdateContactController controller = new UpdateContactController();
              
            controller.updatePhone = '09161445890';
            controller.updateMobilePhone = '09161445787';
            controller.updateWorkPhone = '5082444';
            controller.updateEmail = 'email@email.com';
            controller.updateStreetNumber = 'num';
            controller.updateStreetName = 'name';
            controller.updateStreetType = 'type';
            controller.updateAptUnit = 'unit';
            controller.updateCity = 'sta rosa';
            controller.updateState = 'California';
            controller.updateZipCode = '4012';
            controller.contactID = con.Id;
            controller.updateInfo();
        }
    
        Test.stopTest();        
    }

    static testMethod void SelfUpdateContactCXUpdateContactInfo(){
        List<Profile> profiles = new List<Profile>([SELECT Id FROM Profile where Name = 'MOHCD - Household' LIMIT 1]);
        
        Account a = new Account(Name='Test Account Name');
        insert a;
 
        Contact contact = new Contact(LastName='testUserData',Email='testUserDataUnique@email.com', AccountId = a.id);
        insert contact;

        User usrVar = new User( Username = 'testUserDataUnique@email.com', FirstName='testUserData userFirstName', LastName = 'testUserData userLName', Alias = 'testA',
                                    CommunityNickname = 'testUserData',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',EmailEncodingKey = 'ISO-8859-1',
                                    LanguageLocaleKey = 'en_US', Email = 'test@email.com',ProfileId = profiles.get(0).Id, ContactId = contact.Id, IsActive = true);

        System.runAs(usrVar){
            ApexPages.StandardController thecontroller = new ApexPages.StandardController(usrVar);
            
            UpdateContactController controller = new UpdateContactController(thecontroller);
            controller.updateInfo();
        }
    }

    static testMethod void SelfUpdateContactCXUpdateContactInfoDMLException(){
        try{
            List<Profile> profiles = new List<Profile>([SELECT Id FROM Profile where Name = 'MOHCD - Household' LIMIT 1]);
            
            Account a = new Account(Name='Test Account Name');
            insert a;
     
            Contact contact = new Contact(LastName='testUserData',Email='testUserDataUnique@email.com', AccountId = a.id);
            insert contact;

            User usrVar = new User( Username = 'testUserDataUnique@email.com', FirstName='testUserData userFirstName', LastName = 'testUserData userLName', Alias = 'testA',
                                        CommunityNickname = 'testUserData',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',EmailEncodingKey = 'ISO-8859-1',
                                        LanguageLocaleKey = 'en_US', Email = 'test@email.com',ProfileId = profiles.get(0).Id, ContactId = contact.Id, IsActive = true);

            System.runAs(usrVar){
                ApexPages.StandardController thecontroller = new ApexPages.StandardController(usrVar);
                
                UpdateContactController controller = new UpdateContactController(thecontroller);
                controller.currentUserContact.LastName = null;
                controller.updateInfo();
            }
        }catch(Exception e){
            System.assert(e.getMessage()=='',e.getMessage());
        }
    }
    
    static testMethod void SelfUpdateContactCXStandardController(){
    
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile testUserID = [Select Id from Profile where name = 'System Administrator'];
        testUser = CS_TestDataSetup.createTestUser('FName1', 'LName1', testUserID.Id);       
        testUser.UserRoleId = portalRole.Id;    
        insert testUser;
        
        System.RunAs(testUser){
            Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
            acc = CS_TestDataSetup.createTestAccount('Test Account', '1234512345', 'IT Software', rtId);
            acc.OwnerId = testUser.Id; 
            acc.Work_Phone__c = '5082444';
            acc.Mobile_Phone__c = '09161445787';
            acc.Phone = '09161445890';
            acc.Zip_Code__c = '4012';
            acc.City__c = 'sta rosa';
            acc.Street_Name__c = 'name';
            acc.Street_Number__c = 'num';
            acc.Street_Type__c = 'type';
            acc.Apt_Unit__c = 'unit';
            acc.State__c = 'California';
            acc.Email__c = 'email@email.com';
            insert acc;
            System.assertNotEquals(null, acc.Id);     
            
            Id lenderConRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Lending Agent').getRecordTypeId();          
            con = CS_TestDataSetup.createTestContact(acc.Id, 'Contact', 'Test', 'test@mail.com', lenderConRTId);
            con.Work_Phone__c = '5082444';
            con.MobilePhone = '09161445787';
            con.Phone = '09161445890';
            con.Zip_Code__c = '4012';
            con.City__c = 'sta rosa';
            con.Street_Name__c = 'name';
            con.Street_Number__c = 'num';
            con.Street_Type__c = 'type';
            con.Apt_Unit__c = 'unit';
            con.State__c = 'California';
            con.Email = 'email@email.com';
            insert con;
            System.assertNotEquals(null, con.Id);           
            
            
            Profile portalUserID = [SELECT Id, Name FROM Profile WHERE Name = 'MOHCD - Household' LIMIT 1];
            portalUser = CS_TestDataSetup.createTestPortalUser('First Name', 'Last Name', 'email@email.com' , portalUserID.id, con.id);
            insert portalUser;          
        }  
    
        Test.startTest();
        System.RunAs(portalUser){
    
            ApexPages.StandardController thecontroller = new ApexPages.StandardController(portalUser);
            
            UpdateContactController controller = new UpdateContactController(thecontroller);     
            
            controller.updatePhone = '09161445890';
            controller.updateMobilePhone = '09161445787';
            controller.updateWorkPhone = '5082444';
            controller.updateEmail = 'email@email.com';
            controller.updateStreetNumber = 'num';
            controller.updateStreetName = 'name';
            controller.updateStreetType = 'type';
            controller.updateAptUnit = 'unit';
            controller.updateCity = 'sta rosa';
            controller.updateState = 'California';
            controller.updateZipCode = '4012';
            controller.updateInfo();
        }
    
        Test.stopTest();        
    }
    
}