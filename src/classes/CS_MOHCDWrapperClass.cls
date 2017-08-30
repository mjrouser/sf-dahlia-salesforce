public without sharing class CS_MOHCDWrapperClass {
     //Our collection of the class/wrapper objects 
    public List<wUser> userList {get; set;}
    public List<wContact> contactList {get; set;}
    public List<wContact> contactListwithRegId {get; set;}
    public List<wContact> contactListnoRegId {get; set;}
    //public List<wMember> memberList {get; set;}
    //public List<wIncome> personalIncomeList {get; set;}
    //public List<wAsset> personalAssetList {get; set;}
    //public List<wApprovedCerts> approvedCertificateList {get; set;}
    //public List<wCertsApps> appCertificateList {get; set;}
    
    //***USERS***
    public List<wUser> getExistingUserswithUsername(String userName) {
        if(userList == null) {
            userList = new List<wUser>();
            for(User u: [SELECT Id,
                                Username
                                FROM User 
                                WHERE Username = :userName]) {
                userList.add(new wUser(u));
            }
            }
                    return userList;
        }
/*
    public Boolean insertUser(wUser wusertoInsert) {
        User usertoInsert = new User();
        if(usertoInsert == null) {
            usertoInsert = wusertoInsert.us;
        }
        insert usertoInsert;
        usertoInsert=null;
        return true;
    }
 */
 /*   
    public Boolean insertUser2(User usertoInsert) {
        Boolean result = false;
        if(usertoInsert != null) {
            insert usertoInsert;
            result = true;
        }
        else {
            result = true;
        }
        return result;
    }
*/
    // This is our wrapper/container class. A container class is a class, a data structure, or an abstract data type whose instances are collections of other objects. In this example a wrapper class contains both the standard salesforce object User and a Boolean value
    public class wUser {
        public User us {get; set;}
        public Boolean selected {get; set;}

        //This is the contructor method. When we create a new wUser object we pass a User that is set to the us property. We also set the selected value to false
        public wUser(User u) {
            us = u;
            selected = false;
        }
    }
/*
    //***ACCOUNTS***
    public String setExistingAccounttoPortalEnabled(wContact wcon) {
        String test = '';
        if(wcon == null) {
            test = ' contact was passed to wrapper as a null object...could not even begin processing';
            }
         else {
            Contact c = wcon.con;
            
            if (c.id != null) {
                test = ' wrapped contact unwrapped successfully';
                Account a = new Account();
                a = [SELECT Id,
                                Name,
                                isCustomerPortal
                                FROM Account 
                                WHERE Id = :c.AccountId];
                if (a.id != null) {
                    a.isCustomerPortal = true;
                    update a;
                    if (a.id !=null) {
                        test = ' account updated successfully with isCustomerPortal value set to true';
                        }
                        else {
                            test = ' Account originally retrieved with successfully unwrapped Contact, but could not be updated to set isCustomerPortal to true';
                            }
                    }
                    else {
                        test = ' Contact was unwrapped successfully, but could not even retrieve Account from database';
                        }
                    }
                    else {test = ' wrapped Contact was passed in successfully, but could not be unwrapped successfully';

                }
            }
         return test;
        }
*/

    
    //***CONTACTS***
/*    
    //This method uses a simple SOQL query to return a List of Contacts
    public List<wContact> getContacts() {
        string current_user_id = UserInfo.getUserId();
        User current_contact_id = [select Id, ContactId from User where id = :current_user_id];
        if(contactList == null) {
            contactList = new List<wContact>();
            for(Contact c: [select Id, FirstName, Name, Email, Phone from Contact where Id = :current_contact_id.ContactId]) {
                // As each Contact is processed we create a new wContact object and add it to the contactList
                contactList.add(new wContact(c));
            }
        }
        return contactList;
    }
*/
    
    public List<wContact> getContacts2() {
        string current_user_id = UserInfo.getUserId();
        User current_contact_id = [select Id, ContactId from User where id = :current_user_id];
        Contact current_account_id = [select Id, AccountId from Contact where id = :current_contact_id.ContactId];
        if(contactList == null) {
            contactList = new List<wContact>();
            for(Contact c: [select Id, FirstName, Name, Email, Phone from Contact where AccountId = :current_account_id.AccountId]) {
                // As each Contact is processed we create a new wContact object and add it to the contactList
                contactList.add(new wContact(c));
            }
        }
        return contactList;
    }

    public List<wContact> getexactContactwithRegId(String lastName, Date birthDate, String zipcode, String regId) {
        if(contactListwithRegId == null) {
            contactListwithRegId = new List<wContact>();
            for(Contact c: [SELECT Id,
                                                 AccountId,
                                                 Email, 
                                                 MailingPostalCode,
                                                 FirstName,
                                                 LastName,
                                                 Name,
                                                 Zip_Code__c,
                                                 Birthdate,
                                                 isHousehold__c,
                                                 Registration_Code__c
                                                 FROM Contact 
                                                 WHERE LastName = :lastName
                                                 AND Birthdate = :birthDate
                                                 AND Zip_Code__c = :zipcode
                                                 AND Registration_Code__c = :regId]) {
                contactListwithRegId.add(new wContact(c));
            }
            }
                    return contactListwithRegId;
        }

    public List<wContact> getexactContactnoRegId(String lastName, Date birthDate, String zipcode) {
        // if(contactListnoRegId == null) {
            contactListnoRegId = new List<wContact>();
            for(Contact c: [SELECT Id,
                                                 AccountId,
                                                 Email, 
                                                 MailingPostalCode,
                                                 FirstName,
                                                 LastName,
                                                 Name,
                                                 Zip_Code__c,
                                                 Birthdate,
                                                 isHousehold__c,
                                                 Registration_Code__c
                                                 FROM Contact 
                                                 WHERE LastName = :lastName
                                                 AND Birthdate = :birthDate
                                                 AND Zip_Code__c = :zipcode]) {
                contactListnoRegId.add(new wContact(c));
            }
       //     }
        return contactListnoRegId;
    }
/*    
    public Boolean updateContacts(List<wContact> wcontactstoUpdate) {
        List<Contact> contactstoUpdate = new List<Contact>();
        if(contactstoUpdate == null) {
            for(wContact wcon: wcontactstoUpdate) {
            contactstoUpdate.add(wcon.con);
            }
        update contactstoUpdate;
        contactstoUpdate=null;
        }
        return true;
    }
*/
/*
    public PageReference processContactsSelected() {

        //We create a new list of Contacts to Process 
        List<Contact> selectedContacts = new List<Contact>();
        List<Contact> contactstoUpdate = new List<Contact>();

        //We will cycle through our list of wContact and will check to see if the selected property is set to true; if it is we add the Contact to the selectedContacts list
        for(wContact wCon: getContacts()) {
            if(wCon.selected == true) {
                selectedContacts.add(wCon.con);
            }
        }

        // Now we have our list of selected contacts to process
        System.debug('These are the selected Contacts...');
        for(Contact con: selectedContacts) {
            //PLACE UPDATE CODE HERE
            contactstoUpdate.add(con);
        }
        contactList =null; // we need this line if we performed a write operation  because getContacts gets a fresh list now
        update contactstoUpdate;
        contactstoUpdate=null;
        return null;
    }
*/

    // This is our wrapper/container class. A container class is a class, a data structure, or an abstract data type whose instances are collections of other objects. In this example a wrapper class contains both the standard salesforce object Contact and a Boolean value
    public class wContact {
        public Contact con {get; set;}
        public Boolean selected {get; set;}

        //This is the contructor method. When we create a new wContact object we pass a Contact that is set to the con property. We also set the selected value to false
        public wContact(Contact c) {
            con = c;
            selected = false;
        }
    }

    
    //***MEMBERS***
 /*   
    //This method uses a simple SOQL query to return a List of Household Members
    public List<wMember> getMembers() {
        string current_user_id = UserInfo.getUserId();
        memberList = new List< wMember>(); 
        List<User> current_contact_id = [select Id, ContactId from User where id = :current_user_id];
        if(current_contact_id != null && !current_contact_id.isEmpty()) {
            
            for(Members__c me: [select Id,First_Name__c, Parent_Group__c from Members__c
                                            where Parent_Group__c = :current_contact_id[0].ContactId]) {
                // As each Member is processed we create a new wMember object and add it to thememberList
                wMember tmp = new wMember(me);
                
                memberList.add(tmp);
            }
        }
        return memberList;
    }
*/
/*
    public PageReference processMembersSelected() {

        //We create a new list of Members to process 
        List<Members__c> selectedMembers = new List<Members__c>();
        List<Members__c> memberstoUpdate = new List<Members__c>();

        //We will cycle through our list of wMember and will check to see if the selected property is set to true; if it is we add the Member to the selectedMembers list
        for(wMember wme: getMembers()) {
            if(wme.selected == true) {
                selectedMembers.add(wme.mem);
            }
        }

        // Now we have our list of selected members and can process them
        System.debug('These are the selected Members…');
        for(Members__c me: selectedMembers) {
            //UPDATE LOGIC HERE
            memberstoUpdate.add(me);
        }
        memberList =null; // we need this line if we performed a write operation  because getMembers gets a fresh list now
        update memberstoUpdate;
        memberstoUpdate=null;
        return null;
    }
*/
/*
    // This is our wrapper/container class. A container class is a class, a data structure, or an abstract data type whose instances are collections of other objects. In this example a wrapper class contains both the custom salesforce object Members__c and a Boolean value
    public class wMember {
        public Members__c mem {get; set;}
        public Boolean selected {get; set;}

        //This is the constructor method. When we create a new wMember object we pass a Members__c that is set to the mem property. We also set the selected value to false
        public wMember(Members__c me) {
            mem = me;
            selected = false;
        }
    }
*/    
    //***PERSONAL INCOMES***
 /*   
    //This method uses a simple SOQL query to return a List of Personal Incomes Associated with a Given Member
    public List<wIncome> getIncomes(String member_id) {
        if(personalIncomeList == null) {
            personalIncomeList = new List< wIncome>();
            for(Personal_Income__c inc: [select Id, Household_Member__c from Personal_Income__c
                                            where Household_Member__c = :member_id]) {
                // As each Income is processed we create a new wIncome object and add it to the incomeList
                personalIncomeList.add(new wIncome(inc));
            }
        }
        return personalIncomeList;
    }
*/
/*
    public PageReference processIncomesSelected() {

        //We create a new list of Incomes to process 
        List<Personal_Income__c> selectedIncomes = new List<Personal_Income__c>();
        List<Personal_Income__c> incomestoUpdate = new List<Personal_Income__c>();

        // Now we have our list of selected incomes and can process them
        System.debug('These are the selected Incomes…');
        for(Personal_Income__c inc: selectedIncomes) {
            //UPDATE LOGIC HERE
            incomestoUpdate.add(inc);
        }
        personalIncomeList=null; // we need this line if we performed a write operation  because getIncomes gets a fresh list now
        update incomestoUpdate;
        incomestoUpdate=null;
        return null;
    }
*/
/*
    // This is our wrapper/container class. A container class is a class, a data structure, or an abstract data type whose instances are collections of other objects. In this example a wrapper class contains both the custom salesforce object Personal_Income__c and a Boolean value
    public class wIncome {
        public Personal_Income__c inc {get; set;}
        public Boolean selected {get; set;}

        //This is the constructor method. When we create a new wIncome object we pass a Personal_Income__c that is set to the mem property. We also set the selected value to false
        public wIncome(Personal_Income__c i) {
            inc = i;
            selected = false;
        }
    }
 */   
    //***PERSONAL ASSETS***
 /*   
    //This method uses a simple SOQL query to return a List of Personal Assets Associated with a Given Member
    public List<wAsset> getAssets(String member_id) {
        if(personalAssetList == null) {
            personalAssetList = new List< wAsset>();
            for(Personal_Asset__c ass: [select Id, Household_Member__c from Personal_Asset__c
                                            where Household_Member__c = :member_id]) {
                // As each asset is processed we create a new wAsset object and add it to the assetList
                personalAssetList.add(new wAsset(ass));
            }
        }
        return personalAssetList;
    }
*/
/*
    public PageReference processAssetsSelected() {

        //We create a new list of assets to process 
        List<Personal_Asset__c> selectedAssets = new List<Personal_Asset__c>();
        List<Personal_Asset__c> assetstoUpdate = new List<Personal_Asset__c>();

        // Now we have our list of selected assets and can process them
        System.debug('These are the selected Assets…');
        for(Personal_Asset__c ass: selectedAssets) {
            //UPDATE LOGIC HERE
            assetstoUpdate.add(ass);
        }
        personalAssetList =null; // we need this line if we performed a write operation because getAssets gets a fresh list now
        update assetstoUpdate;
        assetstoUpdate=null;
        return null;
    }
*/
/*
    // This is our wrapper/container class. A container class is a class, a data structure, or an abstract data type whose instances are collections of other objects. In this example a wrapper class contains both the custom salesforce object Personal_Asset__c and a Boolean value
    public class wAsset {
        public Personal_Asset__c ass {get; set;}
        public Boolean selected {get; set;}

        //This is the constructor method. When we create a new wAsset object we pass a Personal_Asset__c that is set to the ass property. We also set the selected value to false
        public wAsset(Personal_Asset__c a) {
            ass = a;
            selected = false;
        }
    }
 */   
    //***APPROVED CERTIFICATES***
/*    
    //This method uses a simple SOQL query to return a List of Approved Certificates Associated with a Given Member
    public List<wApprovedCerts> getApprovedCerts(String member_id) {
        if(approvedCertificateList == null) {
            approvedCertificateList = new List<wApprovedCerts>();
            for(Approved_Certificate__c aprc: [select Id, Certificate_Holder_Name__c from Approved_Certificate__c
                                            where Certificate_Holder_Name__c = :member_id]) {
                // As each approved certificate is processed we create a new wApprovedCerts object and add it to the apprCertList
                approvedCertificateList.add(new wApprovedCerts(aprc));
            }
        }
        return approvedCertificateList;
    }
*/
/*
    public PageReference processApprCertsSelected() {

        //We create a new list of approved certificates to process 
        List<Approved_Certificate__c> selectedApprCerts = new List<Approved_Certificate__c>();
        List<Approved_Certificate__c> apprCertstoUpdate = new List<Approved_Certificate__c>();

        // Now we have our list of selected approved certificates and can process them
        System.debug('These are the selected Approved Certificates…');
        for(Approved_Certificate__c aprc: selectedApprCerts) {
            //UPDATE LOGIC HERE
            apprCertstoUpdate.add(aprc);
        }
        approvedCertificateList =null; // we need this line if we performed a write operation because getApprovedCerts gets a fresh list now
        update apprCertstoUpdate;
        apprCertstoUpdate=null;
        return null;
    }
*/
/*
    // This is our wrapper/container class. A container class is a class, a data structure, or an abstract data type whose instances are collections of other objects. In this example a wrapper class contains both the custom salesforce object Approved_Certificate__c and a Boolean value
    public class wApprovedCerts {
        public Approved_Certificate__c aprc {get; set;}
        public Boolean selected {get; set;}

        //This is the constructor method. When we create a new wApprovedCerts object we pass a Approved_Certificate__c that is set to the aprc property. We also set the selected value to false
        public wApprovedCerts(Approved_Certificate__c a) {
            aprc = a;
            selected = false;
        }
    }
*/
}