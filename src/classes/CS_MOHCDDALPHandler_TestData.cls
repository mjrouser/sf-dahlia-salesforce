/**
 * @author:      Heidi Tang
 * @date:        12/03/2014
 * @description: Test data builder class for SfmohprogramsDalpTrigger.
 * @history:     06/10/2015 - Heidi Tang - Edited
*/  
public class CS_MOHCDDALPHandler_TestData {
    
    /**
     * @author:      Original:Heidi Tang
     * @date:        Original:3rd December 2014
     * @description: Method to insert accounts.
     * @return:      List<Account>: returns the list of accounts inserted.
     */ 
    public static List<Account> getAccounts() {
        List<Account> accounts = new List<Account>();

        accounts.add(new Account(Name='Electric Lender'));
        accounts.add(new Account(Name='One Direction Lender'));
        accounts.add(new Account(Name='Mercury Drug'));
        accounts.add(new Account(Name='Fujitsu'));
        accounts.add(new Account(Name='Lenovo'));
        accounts.add(new Account(Name='Mercury'));
        accounts.add(new Account(Name='Fujit'));

        //Save Accounts
        insert accounts;

        return accounts;
    }   

    /**
     * @author:      Original:Heidi Tang
     * @date:        Original:3rd December 2014
     * @description: Method to insert contacts.
     * @return:      List<Contact>: returns the list of contacts inserted.
     */ 
    public static List<Contact> getContacts() {
        List<Contact> contacts = new List<Contact>();

        contacts.add(new Contact(LastName='1D Lender'));
        contacts.add(new Contact(LastName='2D Lender'));
        contacts.add(new Contact(LastName='3D Household'));
        contacts.add(new Contact(LastName='4D Household'));
        contacts.add(new Contact(LastName='5D Household'));
        contacts.add(new Contact(LastName='6D Household'));
        contacts.add(new Contact(LastName='7D Household'));
        contacts.add(new Contact(LastName='8D Household'));
        contacts.add(new Contact(LastName='9D Lender'));

        //Save contacts
        insert contacts;
    
        return contacts;
    }   

    /**
     * @author:      Original:Heidi Tang
     * @date:        Original:3rd December 2014
     * @description: Method to define the list of dalp request.
     * @return:      List<DALP_Request__c>: returns the list of Dalp request.
     */ 
    public static List<DALP_Request__c> getDalpRequest(){
        List<DALP_Request__c> ldaps = new List<DALP_Request__c>();

        ldaps.add(new DALP_Request__c());
        ldaps.add(new DALP_Request__c());
        ldaps.add(new DALP_Request__c());
        ldaps.add(new DALP_Request__c());
        ldaps.add(new DALP_Request__c());
        ldaps.add(new DALP_Request__c());
        ldaps.add(new DALP_Request__c());
        ldaps.add(new DALP_Request__c());
        ldaps.add(new DALP_Request__c());
        ldaps.add(new DALP_Request__c());
    
        return ldaps;       
    }
}