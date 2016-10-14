// *****************************************************************************
// CLASS: API_ApplicationService
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Contains all logic for API service calls - classes starting with "API".
//
// *****************************************************************************

public without sharing class API_ApplicationService {
	
	private static final String CONTACT_APPLICANT_RT_DEVELOPER_NAME = 'Applicant';
	private static final String ACCOUNT_HOUSEHOLD_RT_DEVELOPER_NAME = 'Household';
	private static final String PRIMARY_APPLICANT = 'Primary Applicant';
	private static final String ALTERNATE_CONTACT = 'Alternate Contact';
	private static final String HOUSEHOLD_MEMBER = 'Household Member';
	private static final String PRIMARY_TYPE = 'Primary';
	private static final String ALTERNATE_TYPE = 'Alternate';
	private static final String HOUSEHOLD_MEMBER_TYPE = 'Household Member';
	
	
	private static final String HOUSEHOLD_FIELDLIST = 
		'Id, Name, RecordTypeId';

	private static final String CONTACT_FIELDLIST =
		'Id, AccountId, RecordTypeId, FirstName, Middle_Name__c, LastName, Birthdate, Email, Phone, Street_Name__c, City__c, State__c, Zip_Code__c,' +
		' MailingStreet, MailingCity, MailingState, MailingPostalCode, Work_Street__c, Work_City__c, Work_State__c, Work_Postal_Code__c,' +
		' Gender__c, Certificate_of_Preference_Holder__c, Displaced_Tenant_Preference__c, Relationship_to_Head_of_Household__c,' +
		' Phone_Type__c, Work_Phone__c, Second_Phone_Type__c, Ethnicity__c, Race__c, Primary_Language__c, Work_in_SF__c,Webapp_Id__c,' + 
		' Prior_Tax_Year_Total_Income_Amount__c, Living_with_disabling_HIVAIDS__c, Sexual_Orientation__c, Sexual_Orientation_Other__c'; //, incomeType

	private static final String APPLICATION_MEMBER_FIELDLIST =
		'Id, Contact__c, First_Name__c, Middle_Name__c, Last_Name__c, Date_of_Birth__c, Email__c,' +
		' Phone__c, Phone_Type__c, Second_Phone__c, Second_Phone_Type__c,' +
		' Street__c, City__c, State__c, Zip_Code__c, Application__c, Application__r.Status__c, Contact_WebappID__c,' +
		' Mailing_Street__c, Mailing_City__c, Mailing_State__c, Mailing_Zip_Code__c,' +
		' Work_in_SF__c, Relationship_to_Applicant__c, Living_with_HIV_AIDS__c, Sexual_Orientation__c, Sexual_Orientation_Other__c,' + 
		' Gender__c, Gender_Other__c, Ethnicity__c, Race__c, Type__c, Primary_Language__c, Other_Language__c,' + 
		' No_Phone__c, No_Email__c, No_Address__c, Has_Alt_Mailing_Address__c,' + 
		' Alternate_Contact_Type__c, Alternate_Contact_Type_Other__c, Agency_Name__c, Same_Address_as_Applicant__c, Neighborhood_Preference_Match__c';

	private static final String SHORTFORM_FIELDLIST =
		'Id, Applicant_Household__c, Listing__c,' +
		prefixQuery('Applicant__r.', APPLICATION_MEMBER_FIELDLIST) +
		', ' +
		prefixQuery('Alternate_Contact__r.', APPLICATION_MEMBER_FIELDLIST) +
		', Work_in_SF_Preference__c, Status__c, Is_Resident__c, Referral_Source__c, Housing_Voucher_or_Subsidy__c ' +
		', Terms_Acknowledged__c, Name, Application_Submission_Type__c, Primary_Applicant__c, Live_Work_Preference_Paper__c ' + 
		', COP_Preference_Member__c, DTHP_Preference_Member__c, Neighborhood_Preference_Member__c, Lottery_Number__c, Form_Metadata__c' +
		', Work_in_SF_Preference_Member__c, Live_in_SF_Preference_Member__c, Total_Household_Gross_Income__c, Application_Language__c, Application_Submitted_Date__c ' + 
		', Live_in_SF_Preference_Proof__c, Neighborhood_Preference_Proof__c, Work_in_SF_Preference_Proof__c, Annual_Income__c, Monthly_Income__c';

	private static final String APPLICATION_FIELDLIST =
		'Id, Applicant_Household__c, Listing__c, Name,' +
		prefixQuery('Applicant__r.Contact__r.', CONTACT_FIELDLIST) +
		', ' +
		prefixQuery('Alternate_Contact__r.Contact__r.', CONTACT_FIELDLIST) +
		', Work_in_SF_Preference__c, Status__c, Is_Resident__c, Referral_Source__c, Housing_Voucher_or_Subsidy__c , Application_Submitted_Date__c' +
		', Terms_Acknowledged__c, Total_Household_Gross_Income__c, Application_Language__c, Application_Submission_Type__c, Lottery_Number__c, Form_Metadata__c' +
		', Annual_Income__c, Monthly_Income__c, Primary_Applicant__c, Live_Work_Preference_Paper__c';

	private static String prefixQuery(String prefix, String query) {
		return prefix + query.replaceAll(', ', ', ' + prefix);
	}
	
	private static Id contactApplicantRtId {
		get {
			if (contactApplicantRtId == null) {
				contactApplicantRtId = [SELECT Id FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = :CONTACT_APPLICANT_RT_DEVELOPER_NAME limit 1].Id;
			}
			return contactApplicantRtId;
		}
	}
	
	private static Id accountHouseholdRtId {
		get {
			if (accountHouseholdRtId == null) {
				accountHouseholdRtId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = :ACCOUNT_HOUSEHOLD_RT_DEVELOPER_NAME limit 1].Id;
			}
			return accountHouseholdRtId;
		}
	}


//for Communities High volume users cannot own accounts as such we are setting a default owner for the account.

	public static ID getDefaultAccoutOwner() {
		Id currentUserProfileId = UserInfo.getProfileId();
		Leasing_Settings__c leasingSettings = Leasing_Settings__c.getInstance(currentUserProfileId);
		return leasingSettings.Default_Owner__c;
	}
	
	public static Boolean isCommunityUser(Id currentUserProfileId) {
        boolean isCommunityUser = false;
        UserLicense customerCommunity = [SELECT Id, LicenseDefinitionKey FROM UserLicense WHERE LicenseDefinitionKey = 'PID_Customer_Community_Login'];
        List<Profile> customerCommunityProfiles = [SELECT Id, Name FROM Profile WHERE UserLicenseId = :customerCommunity.Id];
        Map<Id, Profile> profilesMap = new Map<Id,Profile>();
        for (Profile p : customerCommunityProfiles) {
            profilesMap.put(p.id, p);
        }
        System.debug('profilesMap:::' + profilesMap);
        if (profilesMap.containsKey(currentUserProfileId)) {
            isCommunityUser = true;
        }
        return isCommunityUser;
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
	
	public static Application_Member__c getApplicationMembersById(Id amId) {
		List<Application_Member__c> am = Database.query(
			'SELECT ' +
			APPLICATION_MEMBER_FIELDLIST +
			' FROM Application_Member__c' +
			' WHERE Id = :amId'
		);

		if (am.size() != 1) {
			return null;
		} else {
			return am[0];
		}
	}

	public static List<Application_Member__c> getApplicationMembersByApplicationIds(Set<Id> appIds) {
		return Database.query(
			'SELECT ' +
			APPLICATION_MEMBER_FIELDLIST +
			' FROM Application_Member__c' +
			' WHERE Application__c IN :appIds'
		);
	}
	
	public static List<Application_Member__c> getApplicationMembersByContactIds(Set<Id> cntIds) {
		return Database.query(
			'SELECT ' +
			APPLICATION_MEMBER_FIELDLIST +
			' FROM Application_Member__c' +
			' WHERE Contact__c IN :cntIds'
		);
	}
	
	public static List<Application_Member__c> getApplicationMemberByContactId(Id cntId) {
		return getApplicationMembersByContactIds(new Set<Id>{cntId});
	}

	public static List<Application_Member__c> getApplicationMembersByApplicationId(Id appId) {
		return getApplicationMembersByApplicationIds(new Set<Id>{appId});
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
	
	public static API_Application.Person getPersonByContactId(Id contactId) {
		Contact c = getContactById(contactId);

		if (c == null) {
			return null;
		} else {
			return new API_Application.Person(c);
		}
	}
	
	public static API_Application.Person getPersonByApplicationMemberId(Id amId) {
        Application_Member__c am = getApplicationMembersById(amId);
		
		if (am == null) {
			return null;
		} else {
			return new API_Application.Person(am);
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
		system.debug('SELECT ' +
			SHORTFORM_FIELDLIST +
			' FROM Application__c' +
			' WHERE Primary_Applicant__c = :contactId');
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
			List<Application_Member__c> hms = getApplicationMembersByApplicationId(app.Id);
			return new API_Application.ShortForm(app, hms);
		}
	}

	public static List<API_Application.ShortForm> getShortformsByContactId(Id contactId) {
		List<Application__c> apps = getApplicationsByPrimaryApplicantId(contactId);
		Set<Id> appIds = new Set<Id>();
		for (Application__c app : apps) {
			appIds.add(app.Id);
		}
		//select all household members related to selected apps
		List<Application_Member__c> hms = getApplicationMembersByApplicationIds(appIds);
		
		//group hosehold members on Application
		Map<Id, List<Application_Member__c>> appMemberToAppMap = new Map<Id, List<Application_Member__c>>();
		for (Application_Member__c hm : hms) {
			if (!appMemberToAppMap.containsKey(hm.Application__c)) {
				appMemberToAppMap.put(hm.Application__c, new List<Application_Member__c>());
			}
			appMemberToAppMap.get(hm.Application__c).add(hm);
		}
		
		//create shortform for each app
		List<API_Application.ShortForm> sfs = new List<API_Application.ShortForm>();
		for (Application__c app : apps) {
			sfs.add(new API_Application.ShortForm(app, appMemberToAppMap.get(app.Id)));
		}
		return sfs;
	}
	
	public static API_Application.Person upsertContactAndCascadeUpdate(API_Application.Person person) {
		//update existing contact
        API_Application.Person updatedPerson = API_ApplicationService.upsertPrimaryContactInfo(person);
        
        //select all household members related to selected apps
        List<Application_Member__c> hms = API_ApplicationService.getApplicationMembersByContactIds(new Set<Id>{(Id)updatedPerson.contactId});
        
        //update application members for all 'Draft' Application related to this Contact
        for (Application_Member__c hm : hms) {
        	if (hm.Application__r.Status__c == 'Draft') {
				hm.First_Name__c = person.firstName;
				hm.Middle_Name__c = person.middleName;
				hm.Last_Name__c = person.lastName;
				hm.Email__c = person.email;
				hm.Date_of_Birth__c = person.dob;
        	}
        }
        
        if (hms.size() > 0) {
        	update hms;
        }
        
        return updatedPerson;
	}
	
	//upsert Contact
	public static API_Application.Person upsertPrimaryContactInfo(API_Application.Person p) {
		if (p == null) return null;
		
		Contact c = p.toContact();
		
		if (c.Id != null) {
			Contact cnt = getContactById(c.Id);
			if (cnt.RecordTypeId == null) {
				c.RecordTypeId = contactApplicantRtId;
			}
		} else {
			c.RecordTypeId = contactApplicantRtId;
		}
		
		upsert c;
		return new API_Application.Person(c);
	}
	
	public static API_Application.Person insertApplicationMemberPerson(API_Application.Person p, Id appId, String appMemberType) {
		if (p == null || appId == null) return null;

		Application_Member__c am = getApplicationMember(p, appId, appMemberType);
		upsert am;
		return new API_Application.Person(am);
	}
	
	public static API_Application.Person upsertApplicationMemberPerson(API_Application.Person p) {
		if (p == null) return null;

		Application_Member__c am = p.toApplicationMember();
		upsert am;
		return new API_Application.Person(am);
	}
	
	public static Application_Member__c getApplicationMember(API_Application.Person p, Id appId, String appMemberType) {
		Application_Member__c am = p.toApplicationMember();
		//set Application__c and Type__c field only for new records
		if (p.appMemberId == null) {
			am.Application__c = appId;
			
			if (appMemberType == PRIMARY_TYPE) {
				am.Type__c = PRIMARY_APPLICANT;
			} else if (appMemberType == ALTERNATE_TYPE) {
				am.Type__c = ALTERNATE_CONTACT;
			} else {
				am.Type__c = HOUSEHOLD_MEMBER;
			}
		}
		return am;
	}
	
	public static String getApplicationMemberIdByShortformId(API_Application.ShortForm sf, String applicationMemberType, String appMemberKey) {
		//return Application Member Id for Primary applicant
		if (applicationMemberType == PRIMARY_TYPE) {
			if (sf.primaryApplicant != null && sf.primaryApplicant.appMemberId != null) {
				return sf.primaryApplicant.appMemberId;
			}
		//return Application Member Id for Alternate contact
		} else if (applicationMemberType == ALTERNATE_TYPE) {
			if (sf.alternateContact != null && sf.alternateContact.appMemberId != null) {
				return sf.alternateContact.appMemberId;
			}
		//return Application Member Id for household members
		} else {
			Map<String,Id> appMemberKeyMap = new Map<String,Id>();
			if (sf.householdMembers != null) {
				String householdMemberKey = '';
				for (API_Application.Person householdMember : sf.householdMembers) {
					if (householdMember.firstName != null && householdMember.lastName != null && householdMember.dob != null) {
						householdMemberKey = householdMember.getKey();
						if (!appMemberKeyMap.containsKey(householdMemberKey)) {
							appMemberKeyMap.put(householdMemberKey, householdMember.appMemberId);
						}
					}
				}
				
				if (appMemberKeyMap.containsKey(appMemberKey)) {
					return appMemberKeyMap.get(appMemberKey);
				}
			}
		}
		return null;
	}
	
	public static String getContactIdByShortformId(API_Application.ShortForm sf) {
		if (sf.primaryApplicant != null && sf.primaryApplicant.contactId != null) {
			return sf.primaryApplicant.contactId;
		}
		return null;
	}
	
	private static void deleteExtraApplicationMembers(Set<Id> currentAppMemberIds, Set<Id> existingAppMemberIds) {
		List<Application_Member__c> toBeDeletedApplicationMembers = new List<Application_Member__c>();
		for (Id existingAppMemberId : existingAppMemberIds) {
			if (!currentAppMemberIds.contains(existingAppMemberId)) {
				toBeDeletedApplicationMembers.add(new Application_Member__c(Id = existingAppMemberId));
			}
		}
		if (toBeDeletedApplicationMembers.size() > 0) {
			delete toBeDeletedApplicationMembers;
		}
	}

	public static API_Application.ShortForm upsertShortform(API_Application.ShortForm sf) {
		if (sf == null) return null;
		if (sf.status != 'Draft') {
			sf.validate();
		}
		
		API_Application.ShortForm existingSf;
		//set with existing Application Member Ids used to compare them with Application Members from current JSON
		//existing application members that not exist in current JSON will be deleted
		Set<Id> existingAppMemberIds = new Set<Id>();
		Set<Id> currentAppMemberIds = new Set<Id>();
		//if sf exist make sure to populate AM with ids
		if (sf.id != null) {
			existingSf = getShortformById(sf.Id);
			if (existingSf.status != 'Submitted' && sf.status == 'Submitted') {
				sf.validateLotteryRun();
			}
			
			//add alternate contact Id
			if (existingSf.alternateContact != null && existingSf.alternateContact.appMemberId != null) {
				existingAppMemberIds.add(existingSf.alternateContact.appMemberId);
			}
			if (existingSf.householdMembers != null) {
				//add application members Ids
				for (API_Application.Person householdMember : existingSf.householdMembers) {
					if (householdMember.appMemberId != null) {
						existingAppMemberIds.add(householdMember.appMemberId);
					}
				}
			}
			
			
			if (sf.primaryApplicant != null) {
				sf.primaryApplicant.contactId = String.isEmpty(sf.primaryApplicant.contactId) ? getContactIdByShortformId(existingSf) : sf.primaryApplicant.contactId;
				sf.primaryApplicant.appMemberId = String.isEmpty(sf.primaryApplicant.appMemberId) ? getApplicationMemberIdByShortformId(existingSf,'Primary',null) : sf.primaryApplicant.appMemberId;
			}
			if (sf.alternateContact != null) {
				sf.alternateContact.appMemberId = String.isEmpty(sf.alternateContact.appMemberId) ? getApplicationMemberIdByShortformId(existingSf,'Alternate',null) : sf.alternateContact.appMemberId;
				if (sf.alternateContact.appMemberId != null) {
					currentAppMemberIds.add(sf.alternateContact.appMemberId);
				}
			}
			if (sf.householdMembers != null) {
				String householdMemberKey = '';
				for (API_Application.Person householdMember : sf.householdMembers) {
					if(String.isEmpty(householdMember.appMemberId)) {
						if (householdMember.firstName != null && householdMember.lastName != null && householdMember.dob != null) {
							householdMemberKey = householdMember.getKey();
							householdMember.appMemberId = getApplicationMemberIdByShortformId(existingSf,null,householdMemberKey);
						}
					}
					if (householdMember.appMemberId != null) {
						currentAppMemberIds.add(householdMember.appMemberId);
					}
				}
			}
			
		}
		Application__c app;
		Account household;

		app = sf.toApplication();
		
		API_Application.Person primaryApplicant = sf.primaryApplicant;
		Contact primaryApplicantContact;
		API_Application.Person primaryApplicantAppMember;

		// household
		Id householdId = null;
		Boolean newPrimaryApplicant = primaryApplicant != null ? primaryApplicant.contactId == null : false;

		if (primaryApplicant != null) {
			if (primaryApplicant.contactId != null) {
				primaryApplicantContact = getContactById(primaryApplicant.contactId);
				householdId = primaryApplicantContact.AccountId;
			}
			
			if (householdId == null) {
				household = new Account(RecordTypeId = accountHouseholdRtId, Name = sf.primaryApplicant.firstName + ' ' + sf.primaryApplicant.lastName + '\'s Household');
				//for community users set default owner
				if (isCommunityUser(UserInfo.getProfileId())) {
					household.ownerid = getDefaultAccoutOwner();
				}
				insert household;
			} else {
				household = getHouseholdById(householdId);
			}
			if (sf.id == null) {
				app.Applicant_Household__c = household.Id;
                system.debug('app;;;;;;' + app);
				upsert app;
			}
			//create contact for primary applicant if it's not created
			if (primaryApplicant.contactId == null) {
				// new primary applicant
				primaryApplicantContact = primaryApplicant.toContact();
				primaryApplicantContact.AccountId = household.Id;
				primaryApplicantContact.RecordTypeId = contactApplicantRtId;
				//new Contact
				upsert primaryApplicantContact;
				
				//new Application_Member__c
				API_Application.Person sfPrimaryPerson = primaryApplicant;
				
				//populate ContactId
				sfPrimaryPerson.contactId = primaryApplicantContact.id;
				
				primaryApplicant = insertApplicationMemberPerson(sfPrimaryPerson, app.Id, PRIMARY_TYPE);
				
			//update contact if already exist
			} else {
				// existing primary applicant
				primaryApplicant = upsertPrimaryContactInfo(sf.primaryApplicant);
				 if (sf.primaryApplicant.appMemberId == null) {
					primaryApplicant = insertApplicationMemberPerson(sf.primaryApplicant, app.Id, PRIMARY_TYPE);
				} else {
					primaryApplicant = upsertApplicationMemberPerson(sf.primaryApplicant);
				}
			}
		}
		Map<String, Application_Member__c> keyToAppMember = new Map<String, Application_Member__c>();
		if (primaryApplicant != null) {
			if (primaryApplicant.firstName != null && primaryApplicant.lastName != null && primaryApplicant.dob != null) {
				keyToAppMember.put(primaryApplicant.getKey(), primaryApplicant.toApplicationMember());
			}
		}

		// secondary contact
		API_Application.Person alternateContact;
		if (sf.alternateContact != null) {
			alternateContact = (sf.alternateContact.appMemberId == null ? insertApplicationMemberPerson(sf.alternateContact, app.Id, ALTERNATE_TYPE) : upsertApplicationMemberPerson(sf.alternateContact));
		}
		if (alternateContact != null) {
			if (alternateContact.firstName != null && alternateContact.lastName != null && alternateContact.dob != null) {
				keyToAppMember.put(alternateContact.getKey(), alternateContact.toApplicationMember());
			}
		}
		// household members
		if (sf.householdMembers != null) {
			for (API_Application.Person householdMember : sf.householdMembers) {
				// for a new shortform, skip duplicate primary & alternate applicant as household member
				if (householdMember.appMemberId == null && primaryApplicant != null &&
					householdMember.firstName == primaryApplicant.firstName &&
					householdMember.lastName == primaryApplicant.lastName &&
					householdMember.email == primaryApplicant.email)  continue;
				if (householdMember.appMemberId == null && alternateContact != null &&
					householdMember.firstName == alternateContact.firstName &&
					householdMember.lastName == alternateContact.lastName &&
					householdMember.email == alternateContact.email) continue;
					
				Application_Member__c householdMemberAppMember = householdMember.toApplicationMember();
				if (householdMember.appMemberId == null) {
					householdMemberAppMember.Application__c = app.Id;
					householdMemberAppMember.Type__c = HOUSEHOLD_MEMBER_TYPE;
				}
				
				String key;
				if (householdMember.firstName != null && householdMember.lastName != null && householdMember.dob != null) {
					key = householdMember.getKey();
					if (!keyToAppMember.containsKey(key)) {
						keyToAppMember.put(key, householdMemberAppMember);
					}
				}
				
				upsert householdMemberAppMember;
			}
		}
		
		// finalize application
		
		//set primary applicant - contact
		app.Primary_Applicant__c = app.Primary_Applicant__c == null && primaryApplicant != null ? primaryApplicant.contactId : app.Primary_Applicant__c;
		//set primary applicant - application member
		app.Applicant__c = primaryApplicant == null ? null : primaryApplicant.appMemberId;
		//set aternate application - application member
		app.Alternate_Contact__c = alternateContact == null ? null : alternateContact.appMemberId;
		
		//set natural keys
		if (sf.certOfPreferenceNatKey != null && keyToAppMember.containsKey(sf.certOfPreferenceNatKey.toLowerCase())) {
			app.COP_Preference_Member__c = keyToAppMember.get(sf.certOfPreferenceNatKey.toLowerCase()).Id;
		}
		if (sf.displacedPreferenceNatKey != null && keyToAppMember.containsKey(sf.displacedPreferenceNatKey.toLowerCase())) {
			app.DTHP_Preference_Member__c = keyToAppMember.get(sf.displacedPreferenceNatKey.toLowerCase()).Id;
		}
		if (sf.workInSfPreferenceNatKey != null && keyToAppMember.containsKey(sf.workInSfPreferenceNatKey.toLowerCase())) {
			app.Work_in_SF_Preference_Member__c = keyToAppMember.get(sf.workInSfPreferenceNatKey.toLowerCase()).Id;
		}
		if (sf.liveInSfPreferenceNatKey != null && keyToAppMember.containsKey(sf.liveInSfPreferenceNatKey.toLowerCase())) {
			app.Live_in_SF_Preference_Member__c = keyToAppMember.get(sf.liveInSfPreferenceNatKey.toLowerCase()).Id;
		}
		if (sf.neighborhoodResidencePreferenceNatKey != null && keyToAppMember.containsKey(sf.neighborhoodResidencePreferenceNatKey.toLowerCase())) {
			app.Neighborhood_Preference_Member__c = keyToAppMember.get(sf.neighborhoodResidencePreferenceNatKey.toLowerCase()).Id;
		}
		upsert app;
		
		deleteExtraApplicationMembers(currentAppMemberIds, existingAppMemberIds);
		
		
		return getShortformById(app.Id);
	}

	public static void deleteShortform(API_Application.ShortForm sf) {
		if (sf.id == null) return;
		delete new Application__c(Id = sf.Id);
	}

	public static void deletePerson(API_Application.Person p) {
		if (p.contactId == null) return;
		delete new Contact(Id = p.contactId);
	}
	
}