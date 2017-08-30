// *****************************************************************************
// CLASS: API_Application
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Class that holds ShortForm and Person data models.
//
// *****************************************************************************

global without sharing class API_Application {
	//appmember types
	public static final String PRIMARY_APPLICANT = 'Primary Applicant';
	public static final String ALTERNATE_CONTACT = 'Alternate Contact';
	private static final String HOUSEHOLD_MEMBER = 'Household Member';
	
	private static final String CONTACT_APPLICANT_RT_DEVELOPER_NAME = 'Applicant';
	private static final String ACCOUNT_HOUSEHOLD_RT_DEVELOPER_NAME = 'Household';
	private static final ID CONTACT_APPLICANT_RT_ID = RecordTypeUtil.getRecordTypeIDByDevName('Contact',CONTACT_APPLICANT_RT_DEVELOPER_NAME);
	private static final ID ACCOUNT_HOUSEHOLD_RT_ID =  RecordTypeUtil.getRecordTypeIDByDevName('Account',ACCOUNT_HOUSEHOLD_RT_DEVELOPER_NAME);
	
	private static boolean isNullorBlank(String value) {
		return (value == null || value.length() == 0) ? true: false;
	}
	
	global class ShortForm {
		global String id;
		global String name;
		global ID listingID;
		global Person primaryApplicant;
		global Person alternateContact;
		global List<Person> householdMembers;
		//global Boolean worksInSanFrancisco;
		global String referral;
		global Boolean agreeToTerms;
		global String householdVouchersSubsidies;
		global Decimal annualIncome;
		global Decimal monthlyIncome;
		global Boolean liveInSfPreferencePaper;
		global String liveInSfPreferenceNatKey;
		global String liveInSfPreferenceID;
		global String workInSfPreferenceNatKey;
		global String worksInSfPreferenceID;
		global String displacedPreferenceNatKey;
		global Boolean displacedPreferenceOptOut;
		global String displacedPreferenceID;
		global String certOfPreferenceNatKey;
		global Boolean certOfPreferenceOptOut;
		global String certOfPreferenceID;
		global String neighborhoodResidencePreferenceNatKey;
		global Boolean neighborhoodPreferenceOptOut;
		global String neighborhoodPreferenceID;
		global String liveInSfPreferenceProof;
		global String workInSfPreferenceProof;
		global Boolean liveWorkOptOut;
		global String neighborhoodPreferenceProof;
		global String status;
		global String applicationLanguage;
		global String applicationSubmissionType;
		global Date applicationSubmittedDate;
		global String lotteryNumber;
		global String lotteryNumberManual;
		global String formMetadata;
		
		global ShortForm() {} 
	
		global ShortForm(Application__c app, List<Application_Member__c> hms) {
			this.id = app.Id;
			this.name = app.Name;
			this.listingID =  app.Listing__c; 
			this.primaryApplicant = app.Applicant__r == null ? null : new Person(app.Applicant__r);
			this.alternateContact = app.Alternate_Contact__r == null ? null : new Person(app.Alternate_Contact__r);
			this.householdMembers = new List<Person>();
			for (Application_Member__c am : hms) {
				if (am.Type__c != PRIMARY_APPLICANT && am.Type__c != ALTERNATE_CONTACT) {
					this.householdMembers.add(new Person(am));
				}
			}
			
			//this.worksInSanFrancisco = app.Work_in_SF_Preference__c;
			this.referral = app.Referral_Source__c;
			this.agreeToTerms = app.Terms_Acknowledged__c;
			this.householdVouchersSubsidies = app.Housing_Voucher_or_Subsidy__c;
			this.annualIncome = app.Annual_Income__c;
			this.monthlyIncome = app.Monthly_Income__c;
			this.liveInSfPreferencePaper = app.Live_Work_Preference_Paper__c;
			this.liveInSfPreferenceID = app.Live_in_SF_Preference_Member__c;
			this.worksInSfPreferenceID = app.Work_in_SF_Preference_Member__c;
			this.displacedPreferenceID = app.DTHP_Preference_Member__c;
			this.certOfPreferenceID = app.COP_Preference_Member__c;
			this.neighborhoodPreferenceID = app.Neighborhood_Preference_Member__c;
			this.liveWorkOptOut = app.Live_Work_Opt_Out__c;
			this.displacedPreferenceOptOut = app.DTHP_Opt_Out__c;
			this.certOfPreferenceOptOut = app.COP_Opt_Out__c;
			this.neighborhoodPreferenceOptOut = app.NRHP_Opt_Out__c;
			this.liveInSfPreferenceProof = app.Live_in_SF_Preference_Proof__c;
			this.workInSfPreferenceProof = app.Work_in_SF_Preference_Proof__c;
			this.neighborhoodPreferenceProof = app.Neighborhood_Preference_Proof__c;
			this.status = app.Status__c;
			this.applicationLanguage = app.Application_Language__c;
			this.applicationSubmissionType = app.Application_Submission_Type__c;
			this.applicationSubmittedDate = app.Application_Submitted_Date__c;
			this.lotteryNumber = app.Lottery_Number__c;
			this.lotteryNumberManual = app.Lottery_Number_Manual__c;
			this.formMetadata = app.Form_Metadata__c;
		}

		global Application__c toApplication() {
			Application__c app = new Application__c(Listing__c = this.listingID);
			app.Id = this.id;
			app.Applicant__c = this.primaryApplicant == null ? null : this.primaryApplicant.appMemberId;
			app.Alternate_Contact__c = this.alternateContact == null ? null : this.alternateContact.appMemberId;
			app.Referral_Source__c = this.referral;
			app.Terms_Acknowledged__c = (this.agreeToTerms == null ? false : this.agreeToTerms);
			app.Housing_Voucher_or_Subsidy__c = this.householdVouchersSubsidies;// == null ? false : this.householdVouchersSubsidies);
			app.Annual_Income__c = this.annualIncome;
			app.Monthly_Income__c = this.monthlyIncome;
			app.Live_Work_Preference_Paper__c = (this.liveInSfPreferencePaper == null ? false : this.liveInSfPreferencePaper);
			app.Live_in_SF_Preference_Member__c = String.isBlank(this.liveInSfPreferenceID) ? null : this.liveInSfPreferenceID;
			app.Work_in_SF_Preference_Member__c = String.isBlank(this.worksInSfPreferenceID) ? null : this.worksInSfPreferenceID;
			app.DTHP_Preference_Member__c = String.isBlank(this.displacedPreferenceID) ? null : this.displacedPreferenceID;
			app.COP_Preference_Member__c = String.isBlank(this.certOfPreferenceID) ? null : this.certOfPreferenceID;
			app.Neighborhood_Preference_Member__c = String.isBlank(this.neighborhoodPreferenceID) ? null : this.neighborhoodPreferenceID;
			app.Live_Work_Opt_Out__c = this.liveWorkOptOut == null ? false : this.liveWorkOptOut;
			app.DTHP_Opt_Out__c = this.displacedPreferenceOptOut == null ? false : this.displacedPreferenceOptOut;
			app.COP_Opt_Out__c = this.certOfPreferenceOptOut == null ? false : this.certOfPreferenceOptOut;
			app.NRHP_Opt_Out__c = this.neighborhoodPreferenceOptOut == null ? false : this.neighborhoodPreferenceOptOut;
			app.Live_in_SF_Preference_Proof__c = this.liveInSfPreferenceProof;
			app.Work_in_SF_Preference_Proof__c = this.workInSfPreferenceProof;
			app.Neighborhood_Preference_Proof__c = this.neighborhoodPreferenceProof;
			app.Status__c = this.status;
			app.Application_Language__c = this.applicationLanguage;
			app.Application_Submission_Type__c = this.applicationSubmissionType;
			app.Application_Submitted_Date__c = this.applicationSubmittedDate;
			app.Form_Metadata__c = this.formMetadata;
            app.Lottery_Number_Manual__c = this.lotteryNumberManual;
			return app;
		}
		
		global void validate() {
			if (this.id == null) {
				validateLotteryRun();
			}
			
			if (primaryApplicant == null) {
				throw new IncompleteApplicationException ();
			}
			this.primaryApplicant.validate();
			if (householdMembers != null) {
				for (Person householdMember : householdMembers) {
					householdMember.validate();
				}
			}
		}
		
		global void validateLotteryRun() {
			List<Listing__c> currentListing = ListingService.getListingByID(this.listingID);
			if (currentListing[0].Lottery_Status__c == 'In Progress' || currentListing[0].Lottery_Status__c == 'Lottery Complete') {
				throw new LotteryAlreadyRunException ();
			}
		}
	}
	
	global class IncompleteApplicationException extends Exception {}
	global class LotteryAlreadyRunException extends Exception {}
	
	

	global class Person {
		global String webAppID;
		//global String webAppIDSource;
		global String appMemberId;
		global String contactId;
		global String firstName;
		global String lastName;
		global String middleName;
		global Date DOB;
		global String email;
		global String phone;
		global String phoneType;
		global String alternatePhone;
		global String alternatePhoneType;
		global String address;
		global String city;
		global String state;
		global String zip;
		global String mailingAddress;
		global String mailingCity;
		global String mailingState;
		global String mailingZip;
		global String workInSf;
		global String gender;
		global String genderOther;
		global String sexualOrientation;
		global String sexualOrientationOther;
		global Boolean hiv;
		global String ethnicity;
		global String race;
        global String sexAtBirth;
		global String language;
		global String languageOther;
		global String relationship;
		global String alternateContactType;
		global String agency;
		global String appMemberType; //maps to household member type
		global String alternateContactTypeOther;
		global String hasSameAddressAsApplicant;
		global String neighborhoodPreferenceMatch;
		global Boolean noPhone;
		global Boolean noEmail;
		global Boolean noAddress;
		global Boolean hasAltMailingAddress;
		global String xCoordinate;
		global String yCoordinate;
		global String whichComponentOfLocatorWasUsed;
		global Decimal candidateScore;
        
		private String parseDate(Date inputDate) {
			if (inputDate != null) {
				Time myTime = Time.newInstance(0, 0, 0, 0);
				Date today =inputDate; 
				Datetime tempDateTime = datetime.newInstance(today, myTime);
				String prettyDate = tempDateTime.format('yyyy-MM-dd');
				system.debug(prettyDate);
				return prettyDate;
				/*Integer m = inputDate.month();
				Integer d = inputDate.day();
				Integer y = inputDate.year();
				return y + '-' + m + '-' + d;*/
			}
			return '';
		}

		global void validate() {
			if (isNullorBlank(this.firstName) || isNullorBlank(this.lastName) || (DOB == null) ) {
				throw new IncompleteApplicationException();
			}
		}
		
		global String getKey() {
			if (this.firstName != null && this.lastName != null && this.DOB!=null) {
				return this.firstName.toLowerCase() + ',' + this.lastName.toLowerCase() + ',' + this.parseDate(this.dob);
			}
			else return null;
		}

		global Person() {}
		
		
		global Person(Contact c) {
			this.contactId = c.Id;
			this.firstName = c.FirstName;
			this.lastName = c.LastName;
			this.middleName = c.Middle_Name__c;
			this.DOB = c.Birthdate;
			this.email = c.Email;
			this.webAppID = c.Webapp_Id__c;
			
			this.appMemberType = (c.recordtypeid == CONTACT_APPLICANT_RT_ID)?  PRIMARY_APPLICANT : '';
			//we keep those fields blank because we forseeing using in the future
			/*this.phone = c.Phone;
			this.phoneType = c.Phone_Type__c;
			this.alternatePhone = c.Work_Phone__c;
			this.alternatePhoneType = c.Second_Phone_Type__c;
			this.address = c.Street_Name__c;
			this.city = c.City__c;
			this.state = c.State__c;
			this.zip = c.Zip_Code__c;
			this.mailingAddress = c.MailingStreet;
			this.mailingCity = c.MailingCity;
			this.mailingState = c.MailingState;
			this.mailingZip = c.MailingPostalCode;
			this.workInSf = c.Work_in_SF__c;
			this.gender = c.Gender__c;
			this.sexualOrientation = c.Sexual_Orientation__c;
			this.sexualOrientationOther = c.Sexual_Orientation_Other__c;
			this.hiv = c.Living_with_disabling_HIVAIDS__c;
			this.ethnicity = c.Ethnicity__c;
			this.race = c.Race__c;
			this.language = c.Primary_Language__c;
			this.hasSameAddressAsApplicant = false;*/
		}
		
		global Person(Application_Member__c am) {
			this.appMemberId = am.Id;
			this.contactId = am.Contact__c;
			this.firstName = am.First_Name__c;
			this.lastName = am.Last_Name__c;
			this.middleName = am.Middle_Name__c;
			this.DOB = am.Date_of_Birth__c;
			this.email = am.Email__c;
			this.phone = am.Phone__c;
			this.phoneType = am.Phone_Type__c;
			this.alternatePhone = am.Second_Phone__c;
			this.alternatePhoneType = am.Second_Phone_Type__c;
			this.address = am.Street__c;
			this.city = am.City__c;
			this.state = am.State__c;
			this.zip = am.Zip_Code__c;
			this.mailingAddress = am.Mailing_Street__c;
			this.mailingCity = am.Mailing_City__c;
			this.mailingState = am.Mailing_State__c;
			this.mailingZip = am.Mailing_Zip_Code__c;
			this.workInSf = am.Work_in_SF__c;
			this.gender = am.Gender__c;
			this.genderOther = am.Gender_Other__c;
			this.sexualOrientation = am.Sexual_Orientation__c;
			this.sexualOrientationOther = am.Sexual_Orientation_Other__c;
			this.hiv = am.Living_with_HIV_AIDS__c;
			this.ethnicity = am.Ethnicity__c;
			this.race = am.Race__c;
            this.sexAtBirth = am.Sex_at_birth__c;
			this.language = am.Primary_Language__c;
			this.languageOther = am.Other_Language__c;
			this.relationship = am.Relationship_to_Applicant__c;
			this.alternateContactType = am.Alternate_Contact_Type__c;
			this.agency = am.Agency_Name__c;
			this.alternateContactTypeOther = am.Alternate_Contact_Type_Other__c;
			this.hasSameAddressAsApplicant = am.Same_Address_as_Applicant__c;
			this.neighborhoodPreferenceMatch = am.Neighborhood_Preference_Match__c;
			this.webappID = am.Contact_WebappID__c;
			this.noPhone = am.No_Phone__c;
			this.noEmail = am.No_Email__c;
			this.noAddress = am.No_Address__c;
			this.hasAltMailingAddress = am.Has_Alt_Mailing_Address__c;
			this.appMemberType = am.type__c;
			this.xCoordinate = am.X_Coordinate__c;
			this.yCoordinate = am.Y_Coordinate__c;
			this.whichComponentOfLocatorWasUsed = am.Which_component_of_locator_was_used__c;
			this.candidateScore = am.Candidate_Score__c;
		}

		global Contact toContact() {
			Contact c = new Contact();
			c.Id = this.contactId;
			c.FirstName = this.firstName;
			c.LastName = this.lastName;
			c.Middle_Name__c = this.middleName;
			c.Birthdate = this.DOB;
			c.Email = this.email;
			c.Webapp_Id__c = this.webAppID;
			c.recordtypeid = CONTACT_APPLICANT_RT_ID;//(this.appMemberType== PRIMARY_APPLICANT ) ? CONTACT_APPLICANT_RT_ID:'';
			//we keep those fields blank because we forseeing using in the future
			/*c.Phone = this.phone;
			c.Phone_Type__c = this.phoneType;
			c.Work_Phone__c = this.alternatePhone;
			c.Second_Phone_Type__c = this.alternatePhoneType;
			c.Street_Name__c = this.address;
			c.City__c = this.city;
			c.State__c = this.state;
			c.Zip_Code__c = this.zip;
			c.MailingStreet = this.mailingAddress;
			c.MailingCity = this.mailingCity;
			c.MailingState = this.mailingState;
			c.MailingPostalCode = this.mailingZip;
			c.Work_in_SF__c = this.workInSf == null ? false : this.workInSf;
			c.Gender__c = this.gender;
			c.Sexual_Orientation__c = this.sexualOrientation;
			c.Sexual_Orientation_Other__c = this.sexualOrientationOther;
			c.Living_with_disabling_HIVAIDS__c = (this.hiv == null ? false : this.hiv);
			c.Ethnicity__c = this.ethnicity;
			c.Race__c = this.race;
			c.Primary_Language__c = this.language;*/
			return c;
		}
		
		global Application_Member__c toApplicationMember() {
			Application_Member__c am = new Application_Member__c();
			am.Id = this.appMemberId;
			am.Contact__c = this.contactId;
			am.First_Name__c = this.firstName;
			am.Last_Name__c = this.lastName;
			am.Middle_Name__c = this.middleName;
			am.Date_of_Birth__c = this.DOB;
			am.Email__c = this.email;
			am.Phone__c = this.phone;
			am.Phone_Type__c = this.phoneType;
			am.Second_Phone__c = this.alternatePhone;
			am.Second_Phone_Type__c = this.alternatePhoneType;
			am.Street__c = this.address;
			am.City__c = this.city;
			am.State__c = this.state;
			am.Zip_Code__c = this.zip;
			am.Mailing_Street__c = this.mailingAddress;
			am.Mailing_City__c = this.mailingCity;
			am.Mailing_State__c = this.mailingState;
			am.Mailing_Zip_Code__c   = this.mailingZip;
			am.Work_in_SF__c = this.workInSf;// == null ? false : this.workInSf);
			am.Gender__c = this.gender;
			am.Gender_Other__c = this.genderOther;
			am.Sexual_Orientation__c = this.sexualOrientation;
			am.Sexual_Orientation_Other__c = this.sexualOrientationOther;
			am.Living_with_HIV_AIDS__c = (this.hiv == null ? false : this.hiv);
			am.Ethnicity__c = this.ethnicity;
			am.Race__c = this.race;
            am.Sex_at_birth__c = this.sexAtBirth;
			am.Primary_Language__c = this.language;
			am.Other_Language__c = this.languageOther;
			am.Relationship_to_Applicant__c = this.relationship;
			am.Alternate_Contact_Type__c = this.alternateContactType;
			am.Agency_Name__c = this.agency;
			am.Alternate_Contact_Type_Other__c = this.alternateContactTypeOther;
			am.Same_Address_as_Applicant__c = this.hasSameAddressAsApplicant;// == null ? false : this.hasSameAddressAsApplicant);
			am.Neighborhood_Preference_Match__c = this.neighborhoodPreferenceMatch;
			am.No_Phone__c = this.noPhone == null ? false : this.noPhone;
			am.No_Email__c = this.noEmail == null ? false : this.noEmail;
			am.No_Address__c = this.noAddress == null ? false : this.noAddress;
			am.Has_Alt_Mailing_Address__c = this.hasAltMailingAddress == null ? false : this.hasAltMailingAddress;
			am.type__c = this.appMemberType;
			am.X_Coordinate__c = this.xCoordinate;
			am.Y_Coordinate__c = this.yCoordinate;
			am.Which_component_of_locator_was_used__c = this.whichComponentOfLocatorWasUsed;
			am.Candidate_Score__c = this.candidateScore;
            
			return am;
		}
		
	}
	
}