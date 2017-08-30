/**
 * @author:      Heidi Tang
 * @date:        3rd December 2014
 * @description: Test class for CS_MOHCDDalpTrigger.
 * @history:     03.DEC.2014 - Heidi Tang - Created   
 */

@isTest
private class SfmohprgramsDalpTriggerHandler_Test {

    /**
     * @author:      Original:Heidi Tang
     * @date:        Original:3 December 2014
     * @description: Test method to check if the household account is being accessed by the lender before or after insert of trigger on Dalp Request.
     */ 
    static testMethod void testDalpRequestInsertTrigger() {
        //Set data
        List<Account> accounts = CS_MOHCDDALPHandler_TestData.getAccounts();
        List<Contact> contacts = CS_MOHCDDALPHandler_TestData.getContacts();
        List<DALP_Request__c> ldaps = CS_MOHCDDALPHandler_TestData.getDalpRequest();

        //Set lender's account
        contacts.get(0).AccountId = accounts.get(0).Id;
        contacts.get(1).AccountId = accounts.get(1).Id;

        //set household's account
        for(Integer i=2;i<accounts.size();i++){
            contacts.get(i).AccountId = accounts.get(i).Id;
        }

        update contacts;

        //set lender
        ldaps.get(0).Lender__c = contacts.get(0).Id;
        ldaps.get(1).Lender__c = contacts.get(1).Id;
        ldaps.get(2).Lender__c = contacts.get(0).Id;
        ldaps.get(3).Lender__c = contacts.get(1).Id;
        ldaps.get(4).Lender__c = contacts.get(8).Id;

        //set household
        ldaps.get(0).Requested_By__c = contacts.get(2).Id;
        ldaps.get(1).Requested_By__c = contacts.get(2).Id;
        ldaps.get(2).Requested_By__c = contacts.get(3).Id;
        ldaps.get(3).Requested_By__c = contacts.get(8).Id;
        ldaps.get(4).Requested_By__c = contacts.get(4).Id;
        ldaps.get(5).Requested_By__c = contacts.get(5).Id;
        ldaps.get(6).Requested_By__c = contacts.get(6).Id;
        ldaps.get(7).Requested_By__c = contacts.get(7).Id;
        ldaps.get(8).Requested_By__c = contacts.get(8).Id;

        Test.startTest();
            insert ldaps;
        Test.stopTest();

        accounts = new List<Account>([SELECT Id,Lender_Account__c FROM Account WHERE Id IN :accounts]);

        //Check if lender related to household
        System.assertNotEquals(accounts.get(2).Lender_Account__c,null,'Error null in Lenders Account');
    }   

    /**
     * @author:      Original:Heidi Tang
     * @date:        Original:3 December 2014
     * @description: Test method to check if the household account is being accessed by the lender before or after update of trigger on Dalp Request.
     */ 
    static testMethod void testDalpRequestUpdateTrigger() {

        //Set data
        List<Account> accounts = CS_MOHCDDALPHandler_TestData.getAccounts();
        List<Contact> contacts = CS_MOHCDDALPHandler_TestData.getContacts();
        List<DALP_Request__c> ldaps = CS_MOHCDDALPHandler_TestData.getDalpRequest();

        //Set lender's account
        contacts.get(0).AccountId = accounts.get(0).Id;
        contacts.get(1).AccountId = accounts.get(1).Id;

        //set household's account
        for(Integer i=2;i<accounts.size();i++){
            contacts.get(i).AccountId = accounts.get(i).Id;
        }

        update contacts;

        //set lender
        ldaps.get(0).Lender__c = contacts.get(0).Id;
        ldaps.get(1).Lender__c = contacts.get(1).Id;
        ldaps.get(2).Lender__c = contacts.get(0).Id;
        ldaps.get(3).Lender__c = contacts.get(1).Id;
        ldaps.get(4).Lender__c = contacts.get(8).Id;
        
        //set household
        ldaps.get(0).Requested_By__c = contacts.get(2).Id;
        ldaps.get(1).Requested_By__c = contacts.get(2).Id;
        ldaps.get(2).Requested_By__c = contacts.get(3).Id;
        ldaps.get(3).Requested_By__c = contacts.get(3).Id;
        ldaps.get(4).Requested_By__c = contacts.get(4).Id;
        ldaps.get(5).Requested_By__c = contacts.get(5).Id;
        ldaps.get(6).Requested_By__c = contacts.get(6).Id;
        ldaps.get(7).Requested_By__c = contacts.get(7).Id;
        
        insert ldaps;

        ldaps = new List<DALP_Request__c>([SELECT Id,Lender__c,Requested_By__c FROM DALP_Request__c WHERE Id IN :ldaps]);

        //Update Related household account of lender or vice-versa
        ldaps.get(0).Lender__c = contacts.get(1).Id;
        ldaps.get(1).Lender__c = contacts.get(0).Id;
        ldaps.get(2).Requested_By__c = contacts.get(3).Id;
        ldaps.get(3).Requested_By__c = contacts.get(2).Id;
        
        Test.startTest();
            update ldaps;
        Test.stopTest();

        accounts = new List<Account>([SELECT Id,Lender_Account__c FROM Account WHERE Id IN :accounts]);

        //Check if lender related to household
        System.assertNotEquals(accounts.get(3).Lender_Account__c,null,'Error null in Lenders Account');
    }
}