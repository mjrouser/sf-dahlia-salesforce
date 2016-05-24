public with sharing class API_ApplicationService {
    
    private static final String HOUSEHOLD_FIELDLIST = 
        'Id, Name';

    private static final String CONTACT_FIELDLIST =
        'Id, AccountId, FirstName, LastName, Birthdate, Email, Phone, Street_Name__c, City__c, State__c, Zip_Code__c,' +
        ' MailingStreet, MailingCity, MailingState, MailingPostalCode, Work_Street__c, Work_City__c, Work_State__c, Work_Postal_Code__c,' +
        ' Gender__c, Certificate_of_Preference_Holder__c, Displaced_Tenant_Preference__c, Relationship_to_Head_of_Household__c,' +
        ' Prior_Tax_Year_Total_Income_Amount__c'; //, incomeType

    private static final String SHORTFORM_FIELDLIST =
        'Id, Applicant_Household__c, Listing__c,' +
        prefixQuery('Primary_Applicant__r.', CONTACT_FIELDLIST) +
        ', ' +
        prefixQuery('Secondary_Contact__r.', CONTACT_FIELDLIST) +
        ', Works_In_SF__c, Status__c, Years_Homeless__c, Is_Resident__c';

    private static String prefixQuery(String prefix, String query) {
        return prefix + query.replaceAll(', ', ', ' + prefix);
    }



    public static Account getHouseholdById(Id householdId) {
        List<Account> accs = Database.query(
            'SELECT ' +
            HOUSEHOLD_FIELDLIST +
            ' FROM Account' +
            ' WHERE Id = :householdId'
        );

        if (accs.size() != 1) {
            return null;
        } else {
            return accs[0];
        }
    }

    public static List<Contact> getContactsByHouseholdIds(Set<Id> householdIds) {
        return Database.query(
            'SELECT ' +
            CONTACT_FIELDLIST +
            ' FROM Contact' +
            ' WHERE AccountId IN :householdIds'
        );
    }

    public static List<Contact> getContactsByHouseholdId(Id householdId) {
        return getContactsByHouseholdIds(new Set<Id>{householdId});
    }

    public static Contact getContactById(Id contactId) {
        List<Contact> cs = Database.query(
            'SELECT ' +
            CONTACT_FIELDLIST +
            ' FROM Contact' +
            ' WHERE Id = :contactId'
        );

        if (cs.size() != 1) {
            return null;
        } else {
            return cs[0];
        }
    }

    public static API_Application.Person getPersonById(Id contactId) {
        Contact c = getContactById(contactId);

        if (c == null) {
            return null;
        } else {
            return new API_Application.Person(c);
        }
    }

    public static Application__c getApplicationById(Id shortformId) {
        List<Application__c> apps = Database.query(
            'SELECT ' +
            SHORTFORM_FIELDLIST +
            ' FROM Application__c' +
            ' WHERE Id = :shortformId'
        );

        if (apps != null && apps.size() != 1) {
            return null;
        } else {
            return apps[0];
        }
    }

    public static List<Application__c> getApplicationsByPrimaryApplicantId(Id contactId) {
        return Database.query(
            'SELECT ' +
            SHORTFORM_FIELDLIST +
            ' FROM Application__c' +
            ' WHERE Primary_Applicant__c = :contactId'
        );
    }

    public static API_Application.ShortForm getShortformById(Id shortformId) {
        Application__c app = getApplicationById(shortformId);

        if (app == null) {
            return null;
        } else {
            List<Contact> hms = getContactsByHouseholdId(app.Applicant_Household__c);
            return new API_Application.ShortForm(app, hms);
        }
    }

    public static List<API_Application.ShortForm> getShortformsByContactId(Id contactId) {
        List<Application__c> apps = getApplicationsByPrimaryApplicantId(contactId);

        Set<Id> householdIds = new Set<Id>();
        Map<Id, List<Contact>> householdToMembersMap = new Map<Id, List<Contact>>();

        for (Application__c app : apps) {
            householdIds.add(app.Applicant_Household__c);
            householdToMembersMap.put(app.Applicant_Household__c, new List<Contact>());
        }

        List<Contact> allHouseholdMembers = getContactsByHouseholdIds(householdIds);
        for (Contact hm : allHouseholdMembers) {
            householdToMembersMap.get(hm.AccountId).add(hm);
        }

        List<API_Application.ShortForm> sfs = new List<API_Application.ShortForm>();
        for (Application__c app : apps) {
            sfs.add(new API_Application.ShortForm(app, householdToMembersMap.get(app.Applicant_Household__c)));
        }

        return sfs;
    }



    public static API_Application.Person upsertPerson(API_Application.Person p) {
        if (p == null) return null;

        Contact c = p.toContact();
        upsert c;
        return new API_Application.Person(c);
    }

    public static API_Application.ShortForm upsertShortform(API_Application.ShortForm sf) {
        if (sf == null) return null;

        Application__c app;
        Account household;

        if (sf.id == null) {
            // new application
            app = new Application__c();
        } else {
            // existing application
            app = sf.toApplication();
        }

        API_Application.Person primaryApplicant = sf.primaryApplicant;
        Contact primaryApplicantContact;

        // household
        Id householdId = null;
        Boolean newPrimaryApplicant = primaryApplicant.id == null;

        if (primaryApplicant.id != null) {
            primaryApplicantContact = getContactById(primaryApplicant.id);
            householdId = primaryApplicantContact.AccountId;
        }

        if (householdId == null) {
            household = new Account(Name = sf.primaryApplicant.firstName + ' ' + sf.primaryApplicant.lastName + '\'s Household');
            insert household;
        } else {
            household = getHouseholdById(householdId);
        }
        if (sf.id == null) {
            app.Applicant_Household__c = household.Id;
        }

        if (primaryApplicant.id == null) {
            // new primary applicant
            primaryApplicantContact = primaryApplicant.toContact();
            primaryApplicantContact.AccountId = household.Id;
            upsert primaryApplicantContact;
            primaryApplicant = new API_Application.Person(primaryApplicantContact);
        } else {
            // existing primary applicant
            primaryApplicant = upsertPerson(sf.primaryApplicant);
        }

        // secondary contact
        API_Application.Person secondaryContact = upsertPerson(sf.secondaryContact);

        // household members
        Set<Id> householdMemberIds = new Set<Id>();
        for (API_Application.Person householdMember : sf.householdMembers) {
            // for a new shortform, skip duplicate primary applicant as household member
            if (householdMember.id == null && newPrimaryApplicant &&
                householdMember.firstName == primaryApplicant.firstName &&
                householdMember.lastName == primaryApplicant.lastName &&
                householdMember.email == primaryApplicant.email) continue;

            Contact householdMemberContact = householdMember.toContact();
            householdMemberContact.AccountId = household.Id;
            upsert householdMemberContact;
            householdMemberIds.add(householdMemberContact.Id);
        }

        // finalize application
        if (sf.id == null) {
            app.Primary_Applicant__c = primaryApplicant == null ? null : primaryApplicant.id;
            app.Secondary_Contact__c = secondaryContact == null ? null : secondaryContact.id;
        }
        upsert app;

        // old application members
        /*List<Application_Member__c> applicationMembers =
            [
                SELECT Id, Application__c, Household_Member__c
                FROM Application_Member__c
                WHERE Application__c = :app.Id
                AND Household_Member__c IN :householdMemberIds
            ];

        Set<Id> existingHouseholdMembers = new Set<Id>();
        for (Application_Member__c applicationMember : applicationMembers) {
            existingHouseholdMembers.add(applicationMember.Household_Member__c);
        }

        List<Application_Member__c> newApplicationMembers = new List<Application_Member__c>();
        for (Id householdMemberId : householdMemberIds) {
            if (!existingHouseholdMembers.contains(householdMemberId)) {
                newApplicationMembers.add(new Application_Member__c(Application__c = app.Id, Household_Member__c = householdMemberId));
            }
        }
        if (newApplicationMembers.size() > 0) {
            insert newApplicationMembers;
        }*/
        
        // new application members
        List<Application_Household__c> applicationMembers =
            [
                SELECT Id, Application__c, Contact__c
                FROM Application_Household__c
                WHERE Application__c = :app.Id
                AND Contact__c IN :householdMemberIds
            ];

        Set<Id> existingHouseholdMembers = new Set<Id>();
        for (Application_Household__c applicationMember : applicationMembers) {
            existingHouseholdMembers.add(applicationMember.Contact__c);
        }

        List<Application_Household__c> newApplicationMembers = new List<Application_Household__c>();
        for (Id householdMemberId : householdMemberIds) {
            if (!existingHouseholdMembers.contains(householdMemberId)) {
                newApplicationMembers.add(new Application_Household__c(Application__c = app.Id, Contact__c = householdMemberId));
            }
        }
        if (newApplicationMembers.size() > 0) {
            insert newApplicationMembers;
        }

        return getShortformById(app.Id);
    }

    public static void deleteShortform(API_Application.ShortForm sf) {
        if (sf.id == null) return;
        delete [SELECT Id FROM Application__c WHERE Id = :sf.id];
    }

    public static void deletePerson(API_Application.Person p) {
        if (p.id == null) return;
        delete [SELECT Id FROM Contact WHERE Id = :p.id];
    }

}