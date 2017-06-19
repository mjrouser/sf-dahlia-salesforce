@isTest
private class SfmohprogramsHousingAppTriggerTest {
	
	public static String ACC_HOUSEHOLD = 'Lender';
    public static String HA_RENTAL = 'BMR Rental';
    public static String HA_OWNER = 'BMR Ownership';
    public static String PROP_DEV = 'Development';
    public static String CP_COP = 'COP';
    public static String CP_EAHP = 'EAHP';
    public static String CON_HA = 'Household';
           
    static testmethod void testCOPPRental(){ 
        Map<String, Id> mapRecordType = new Map<String, Id>();       
        for(RecordType recType: [Select Name, Id from RecordType 
                                    where (
                                            (Name =: HA_OWNER 
                                            OR Name =: HA_RENTAL) 
                                            AND SobjectType =: 'Housing_Application__c')
                                            OR (Name =: ACC_HOUSEHOLD 
                                            AND SobjectType =: 'Account')
                                            OR (Name =: PROP_DEV
                                            AND SobjectType =: 'Properties__c')
                                            OR (Name =: CON_HA
                                            AND SobjectType =: 'Contact')
                                            OR ((Name =: CP_COP
                                            OR Name =: CP_EAHP) 
                                            AND SobjectType =: 'Certificate_Program__c')
                                            ] 
        ){
            mapRecordType.put(recType.Name, recType.Id);
        }
        User thisUser = [Select Id from User where Id =: UserInfo.getUserId()];
        System.RunAs(thisUser){
        Account oAcc = CS_TestDataSetup.createTestAccount('Test Household', '1111111', '',mapRecordType.get(ACC_HOUSEHOLD));
        insert oAcc;
        Properties__c oProp = CS_TestDataSetup.createTestProperties(800, 'Studio', 1, 2, 'New', 'Type', 'Neighborhood', mapRecordType.get(PROP_DEV)); 
        insert oProp;
        Contact oCon = CS_TestDataSetup.CreateTestContact(oAcc.Id, 'Last Name', 'First Name', 'test@email.com', mapRecordType.get(CON_HA)); 
        insert oCon;
        Certificate_Program__c oCP = new Certificate_Program__c(Household_Contact__c = oCon.Id, Household_Account__c = oAcc.Id, RecordTypeId = mapRecordType.get(CP_COP)); 
        insert oCP;
        update oCP;
        Certificate_Program__c oCP2 = [Select Id, Name, COPP_Rental_Used__c, EAHP_Certificate_Used__c from Certificate_Program__c where Id =: oCP.Id LIMIT 1];
        Test.startTest();
        //insert COP Rental
        Housing_Application__c oHARent = new Housing_Application__c(RecordTypeId = mapRecordType.get(HA_RENTAL), Property_of_Interest__c = oProp.Id, Certificate_of_Preference_Holder__c = TRUE, Certificate_of_Preference_Number__c = oCP2.Name);  
        insert oHARent;

        Certificate_Program__c oCP3 = [Select Id, Name, COPP_Rental_Used__c, COPP_Ownership_Used__c, EAHP_Certificate_Used__c from Certificate_Program__c where Id =: oCP.Id LIMIT 1];
        System.AssertEquals(oCP3.COPP_Rental_Used__c, TRUE);
        
        Test.stopTest();
        }
    }

    static testmethod void testCOPPOwner(){ 
        Map<String, Id> mapRecordType = new Map<String, Id>();       
        for(RecordType recType: [Select Name, Id from RecordType 
                                    where (
                                            (Name =: HA_OWNER 
                                            OR Name =: HA_RENTAL) 
                                            AND SobjectType =: 'Housing_Application__c')
                                            OR (Name =: ACC_HOUSEHOLD 
                                            AND SobjectType =: 'Account')
                                            OR (Name =: PROP_DEV
                                            AND SobjectType =: 'Properties__c')
                                            OR (Name =: CON_HA
                                            AND SobjectType =: 'Contact')
                                            OR ((Name =: CP_COP
                                            OR Name =: CP_EAHP) 
                                            AND SobjectType =: 'Certificate_Program__c')
                                            ] 
        ){
            mapRecordType.put(recType.Name, recType.Id);
        }
        User thisUser = [Select Id from User where Id =: UserInfo.getUserId()];
        System.RunAs(thisUser){
        Account oAcc = CS_TestDataSetup.createTestAccount('Test Household', '1111111', '',mapRecordType.get(ACC_HOUSEHOLD));
        insert oAcc;
        Properties__c oProp = CS_TestDataSetup.createTestProperties(800, 'Studio', 1, 2, 'New', 'Type', 'Neighborhood', mapRecordType.get(PROP_DEV)); 
        insert oProp;
        Contact oCon = CS_TestDataSetup.CreateTestContact(oAcc.Id, 'Last Name', 'First Name', 'test@email.com', mapRecordType.get(CON_HA)); 
        insert oCon;
        Certificate_Program__c oCP = new Certificate_Program__c(Household_Contact__c = oCon.Id, Household_Account__c = oAcc.Id, RecordTypeId = mapRecordType.get(CP_COP)); 
        insert oCP;
        Certificate_Program__c oCP2 = [Select Id, Name, COPP_Rental_Used__c, EAHP_Certificate_Used__c from Certificate_Program__c where Id =: oCP.Id LIMIT 1];
        Test.startTest();
        //insert COP Rental
        Housing_Application__c oHARent = new Housing_Application__c(RecordTypeId = mapRecordType.get(HA_OWNER), Property_of_Interest__c = oProp.Id, Certificate_of_Preference_Holder__c = TRUE, Certificate_of_Preference_Number__c = oCP2.Name);  
        insert oHARent;

        Certificate_Program__c oCP3 = [Select Id, Name, COPP_Ownership_Used__c from Certificate_Program__c where Id =: oCP.Id LIMIT 1];
        System.AssertEquals(oCP3.COPP_Ownership_Used__c , TRUE);
        
        Test.stopTest();
        }
    }

    static testmethod void testEAHP(){ 
        Map<String, Id> mapRecordType = new Map<String, Id>();       
        for(RecordType recType: [Select Name, Id from RecordType 
                                    where (
                                            (Name =: HA_OWNER 
                                            OR Name =: HA_RENTAL) 
                                            AND SobjectType =: 'Housing_Application__c')
                                            OR (Name =: ACC_HOUSEHOLD 
                                            AND SobjectType =: 'Account')
                                            OR (Name =: PROP_DEV
                                            AND SobjectType =: 'Properties__c')
                                            OR (Name =: CON_HA
                                            AND SobjectType =: 'Contact')
                                            OR ((Name =: CP_COP
                                            OR Name =: CP_EAHP) 
                                            AND SobjectType =: 'Certificate_Program__c')
                                            ] 
        ){
            mapRecordType.put(recType.Name, recType.Id);
        }
        User thisUser = [Select Id from User where Id =: UserInfo.getUserId()];
        System.RunAs(thisUser){
        Account oAcc = CS_TestDataSetup.createTestAccount('Test Household', '1111111', '',mapRecordType.get(ACC_HOUSEHOLD));
        insert oAcc;
        Properties__c oProp = CS_TestDataSetup.createTestProperties(800, 'Studio', 1, 2, 'New', 'Type', 'Neighborhood', mapRecordType.get(PROP_DEV)); 
        insert oProp;

        Properties__c oProp2 = CS_TestDataSetup.createTestProperties(800, 'Studio', 1, 2, 'Existing', 'Type', 'Neighborhood', mapRecordType.get(PROP_DEV)); 
        insert oProp2;

        Contact oCon = CS_TestDataSetup.CreateTestContact(oAcc.Id, 'Last Name', 'First Name', 'test@email.com', mapRecordType.get(CON_HA)); 
        insert oCon;
        Certificate_Program__c oCP = new Certificate_Program__c(Household_Contact__c = oCon.Id, Household_Account__c = oAcc.Id, RecordTypeId = mapRecordType.get(CP_EAHP), Expiration_Date_for_Existing_Properties__c = System.Today()); 
        insert oCP;
        Certificate_Program__c oCP2 = [Select Id, Name, COPP_Rental_Used__c, EAHP_Certificate_Used__c from Certificate_Program__c where Id =: oCP.Id LIMIT 1];
        List<Housing_Application__c> lEAHP = new List<Housing_Application__c>();
        Test.startTest();
        //insert EAHP
        Housing_Application__c oHAEAHP01 = new Housing_Application__c(RecordTypeId = mapRecordType.get(HA_OWNER), Property_of_Interest__c = oProp.Id, EAHP_Certificate_Holder__c = TRUE, EAHP_Certificate_Expiration_Date__c = System.Today(), Household_Account__c = oAcc.Id);  
        Housing_Application__c oHAEAHP02 = new Housing_Application__c(RecordTypeId = mapRecordType.get(HA_OWNER), Property_of_Interest__c = oProp.Id, EAHP_Certificate_Holder__c = FALSE, EAHP_Certificate_Expiration_Date__c = System.Today(), Household_Account__c = oAcc.Id);  
        lEAHP.add(oHAEAHP01);
        lEAHP.add(oHAEAHP02);
        insert lEAHP;

        Certificate_Program__c oCP3 = [Select Id, Name, EAHP_Certificate_Used__c, Expiration_Date_for_Existing_Properties__c from Certificate_Program__c where Expiration_Date_for_Existing_Properties__c =: oHAEAHP01.EAHP_Certificate_Expiration_Date__c LIMIT 1];
        System.AssertEquals(oCP3.EAHP_Certificate_Used__c , FALSE);
        
        Certificate_Program__c oCPNew = new Certificate_Program__c(Household_Contact__c = oCon.Id, Household_Account__c = oAcc.Id, RecordTypeId = mapRecordType.get(CP_EAHP), Expiration_Date_for_Existing_Properties__c = System.Today(),Expiration_Date_for_New_Developments__c = System.Today()); 
        insert oCPNew;
        Certificate_Program__c oCP2New = [Select Id, Name, COPP_Rental_Used__c, EAHP_Certificate_Used__c,Expiration_Date_for_New_Developments__c from Certificate_Program__c where Id =: oCPNew.Id LIMIT 1];
        oHAEAHP02.EAHP_Certificate_Holder__c = TRUE;
        update oHAEAHP02;
        
        Certificate_Program__c oCP3New = [Select Id, Name, EAHP_Certificate_Used__c, Expiration_Date_for_Existing_Properties__c from Certificate_Program__c where Expiration_Date_for_Existing_Properties__c =: oHAEAHP02.EAHP_Certificate_Expiration_Date__c LIMIT 1];
        System.AssertEquals(oCP3New.EAHP_Certificate_Used__c , FALSE);
        
        oHAEAHP02.Property_of_Interest__c = oProp2.Id;
        update oHAEAHP02;

        Test.stopTest();
        }
    }
    

    static testmethod void testEAHPProperties(){ 
        Map<String, Id> mapRecordType = new Map<String, Id>();       
        for(RecordType recType: [Select Name, Id from RecordType 
                                    where (
                                            (Name =: HA_OWNER 
                                            OR Name =: HA_RENTAL) 
                                            AND SobjectType =: 'Housing_Application__c')
                                            OR (Name =: ACC_HOUSEHOLD 
                                            AND SobjectType =: 'Account')
                                            OR (Name =: PROP_DEV
                                            AND SobjectType =: 'Properties__c')
                                            OR (Name =: CON_HA
                                            AND SobjectType =: 'Contact')
                                            OR ((Name =: CP_COP
                                            OR Name =: CP_EAHP) 
                                            AND SobjectType =: 'Certificate_Program__c')
                                            ] 
        ){
            mapRecordType.put(recType.Name, recType.Id);
        }
        User thisUser = [Select Id from User where Id =: UserInfo.getUserId()];
        System.RunAs(thisUser){
        Account oAcc = CS_TestDataSetup.createTestAccount('Test Household', '1111111', '',mapRecordType.get(ACC_HOUSEHOLD));
        insert oAcc;
        Properties__c oProp = CS_TestDataSetup.createTestProperties(800, 'Studio', 1, 2, 'Existing', 'Type', 'Neighborhood', mapRecordType.get(PROP_DEV)); 
        insert oProp;
        Contact oCon = CS_TestDataSetup.CreateTestContact(oAcc.Id, 'Last Name', 'First Name', 'test@email.com', mapRecordType.get(CON_HA)); 
        insert oCon;
        Certificate_Program__c oCP = new Certificate_Program__c(Household_Contact__c = oCon.Id, Household_Account__c = oAcc.Id, RecordTypeId = mapRecordType.get(CP_EAHP), Expiration_Date_for_Existing_Properties__c = System.Today()); 
        insert oCP;
        Certificate_Program__c oCP2 = [Select Id, Name, COPP_Rental_Used__c, EAHP_Certificate_Used__c from Certificate_Program__c where Id =: oCP.Id LIMIT 1];
        List<Housing_Application__c> lEAHP = new List<Housing_Application__c>();
        Test.startTest();
        //insert EAHP
        Housing_Application__c oHAEAHP01 = new Housing_Application__c(RecordTypeId = mapRecordType.get(HA_OWNER), Property_of_Interest__c = oProp.Id, EAHP_Certificate_Holder__c = TRUE, EAHP_Certificate_Expiration_Date__c = System.Today(), Household_Account__c = oAcc.Id);  
        Housing_Application__c oHAEAHP02 = new Housing_Application__c(RecordTypeId = mapRecordType.get(HA_OWNER), Property_of_Interest__c = oProp.Id, EAHP_Certificate_Holder__c = FALSE, EAHP_Certificate_Expiration_Date__c = System.Today(), Household_Account__c = oAcc.Id);  
        lEAHP.add(oHAEAHP01);
        lEAHP.add(oHAEAHP02);
        insert lEAHP;

        Certificate_Program__c oCP3 = [Select Id, Name, EAHP_Certificate_Used__c, Expiration_Date_for_Existing_Properties__c from Certificate_Program__c where Expiration_Date_for_Existing_Properties__c =: oHAEAHP01.EAHP_Certificate_Expiration_Date__c LIMIT 1];
        System.AssertEquals(oCP3.EAHP_Certificate_Used__c , TRUE);
        
        Certificate_Program__c oCPNew = new Certificate_Program__c(Household_Contact__c = oCon.Id, Household_Account__c = oAcc.Id, RecordTypeId = mapRecordType.get(CP_EAHP), Expiration_Date_for_Existing_Properties__c = System.Today()); 
        insert oCPNew;
        Certificate_Program__c oCP2New = [Select Id, Name, COPP_Rental_Used__c, EAHP_Certificate_Used__c from Certificate_Program__c where Id =: oCPNew.Id LIMIT 1];
        oHAEAHP02.EAHP_Certificate_Holder__c = TRUE;
        update oHAEAHP02;
        
        Certificate_Program__c oCP3New = [Select Id, Name, EAHP_Certificate_Used__c, Expiration_Date_for_Existing_Properties__c from Certificate_Program__c where Expiration_Date_for_Existing_Properties__c =: oHAEAHP02.EAHP_Certificate_Expiration_Date__c LIMIT 1];
        System.AssertEquals(oCP3New.EAHP_Certificate_Used__c , TRUE);
        
        Test.stopTest();
        }
    }
}