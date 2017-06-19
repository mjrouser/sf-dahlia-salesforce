// *****************************************************************************
// CLASS: HOP_ApplicationFormController
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Controller class for the HOP_ApplicationForm page.
//
// *****************************************************************************

public without sharing class HOP_ApplicationFormController extends HOP_ControllerBase {

    // Variable that indicates whether any ApexPages Messages (errors) have been generated.
    public Boolean hasErrors {get; set;}

    // This will hold the current Application currently being edited (new or existing).
    public Application__c app {get; set;}
	
	// This will hold the current Listing tied to the Application currently being edited (new or existing).
	public Listing__c listing {get; set;}
	
	// True if "Reserve type" on any units attached to the listing = "developmental disabilities"
	public Boolean hasDevelopmentalDisabilitiesUnits { get; set; }
	
	// True if "Reserve type" on any units attached to the listing = "veterans"
	public Boolean hasVeteransUnits { get; set; }
	
    // Certain fields (read-only or cross-object) need to be queried separately
    // because the Application API can't set those on an Application__c object created from scratch
    public Application__c appName {get; set;}

    // The Primary Applicant on the Application
    public Application_Member__c primaryApplicant {get; set;}

    // The Alternate Contact on the Application
    public Application_Member__c alternateContact {get; set;}

    // A list of all the Household Members (without the Primary Applicant or the Alternate Contact!)
    // on the current Application.
    public List<Application_Member__c> householdMembers {get; set;}

	// A list of all Preferences on the current Application.
    public List<ShortFormPreferenceWrapper> shortFormPreferences {get; set;}

    // Because the adding/editing of Household Members must also work for brand new Applications,
    // in which case the Household Member records don't have an Id yet - we use their index in the
    // householdMembers list (0, 1 etc.) to uniquely identify them
    public List<Integer> householdMembersIndexes {
        get {
            householdMembersIndexes = new List<Integer>();
            if (householdMembers == null) return householdMembersIndexes;
            if (householdMembers.size() == 0) return householdMembersIndexes;
            for (Integer i = 0; i < householdMembers.size(); i++) {
                householdMembersIndexes.add(i);
            }
            return householdMembersIndexes;
        }
        set;
    }
    
    // Because the adding/editing of Shortform Preference must also work for brand new Applications,
    // in which case the Shortform Preference records don't have an Id yet - we use their index in the
    // shortformPreferences list (0, 1 etc.) to uniquely identify them
    public List<Integer> shortFormPreferencesIndexes {
        get {
            shortFormPreferencesIndexes = new List<Integer>();
            if (shortFormPreferences == null) return shortFormPreferencesIndexes;
            if (shortFormPreferences.size() == 0) return shortFormPreferencesIndexes;
            for (Integer i = 0; i < shortFormPreferences.size(); i++) {
                shortFormPreferencesIndexes.add(i);
            }
            return shortFormPreferencesIndexes;
        }
        set;
    }
    

    // List of dropdown options for the three preference picklists - Neighborhood, DTHP and COP.
    // The list is made up of all the Household Members, plus the Primary Applicant and the --None-- option.
    // The household member index (0, 1 etc.) is used as the key for the SelectOption.
    // For the other two special options we use -1 for the --None-- option and -2 for the Primay Applicant.
    public List<SelectOption> householdMembersSO {
        get {
            householdMembersSO = new List<SelectOption>();
            householdMembersSO.add(new SelectOption('-1', '-- None --'));
            String primaryApplicantName = properName(primaryApplicant);
            if (!String.isBlank(primaryApplicantName)) {
                householdMembersSO.add(new SelectOption('-2', primaryApplicantName));
            }
            if (householdMembers == null) return householdMembersSO;
            if (householdMembers.size() == 0) return householdMembersSO;
            for (Integer i = 0; i < householdMembers.size(); i++) {
                householdMembersSO.add(new SelectOption(String.valueOf(i), properName(householdMembers[i])));
            }
            return householdMembersSO;
        }
        set;
    }
    
    // List of dropdown options including all preferences related to listing
    public List<SelectOption> listingPreferenceSO {
    	get {
    		system.debug('selectedListingPreference:::so::' + selectedListingPreference);
    		Set<Id> selectedPrefs = new Set<Id>();
    		for (ShortFormPreferenceWrapper sfPrefW : shortFormPreferences) {
    			selectedPrefs.add(sfPrefW.shortFormPreference.Listing_Preference_ID__c);
    		}
    		listingPreferenceSO = new List<SelectOption>();
            listingPreferenceSO.add(new SelectOption('-1', '-- None --'));
            List<Listing_Lottery_Preference__c> listingPrefs = [SELECT Id, Preference_Name__c FROM Listing_Lottery_Preference__c WHERE Listing__c = :listingId];
            for (Listing_Lottery_Preference__c lp : listingPrefs) {
            	if (!selectedPrefs.contains(lp.Id) || lp.Id == selectedListingPreference) {//on edit selectedListingPreference should be displayed into the list
            		listingPreferenceSO.add(new SelectOption(lp.Id, lp.Preference_Name__c));
            	}
            }
            return listingPreferenceSO;
    	}
    	set;
    }
    
    //selected listing preference
    public String selectedListingPreference {
    	get;
        set {
        	selectedListingPreference = value;
        	currentShortFormPreference.shortFormPreference.Listing_Preference_ID__c = selectedListingPreference;
        	for (SelectOption so : listingPreferenceSO) {
        		if (so.getValue() == selectedListingPreference) {
        			currentShortFormPreference.listingPrefName = so.getLabel();
        		}
        	}
        	
        }
    }

    // When editing a household member, this will hold that Household Member currently being edited.
    // If no household member is currently being edited, this will be null.
    public Application_Member__c currentHouseholdMember {get; set;}

	// When editing a shortform preference, this will hold that Shortform Preference currently being edited.
    // If no shortform preference is currently being edited, this will be null.
    public ShortFormPreferenceWrapper currentShortFormPreference {get; set;}
	
    // Most HOP pages support a retUrl parameter that enables "Back" navigation to the previous page.
    public String retUrl {get; set;}

    // The index of the currently selected Household Member that's being edited (-1 if none)
    public Integer selectedHouseholdMemberIdx {get; set;}

	// The index of the currently selected Preference that's being edited (-1 if none)
    public Integer selectedShortFormPreferenceIdx {get; set;}
    
    public boolean isTotalMonthlyRentEditable {
    	get {
    		return Schema.SObjectType.Application__c.fields.getMap().get('Total_Monthly_Rent__c').getDescribe().isUpdateable();
		}
    	set;
    }

    // The neighborhoodPreference variable is linked to the corresponding picklist, therefore its value
    // will be a number (0, 1 etc.) which is the index of the selected Household Member.
    // When setting this, also get the corresponding Household Member Id (if it exists)
    // and set it automatically on the Application variable.
    public String selectedApplicationMember {
        get;
        set {
        	selectedApplicationMember = value;
        	currentShortFormPreference.shortFormPreference.Application_Member__c = householdMemberIdFromPreference(selectedApplicationMember);
        	currentShortFormPreference.personWhoClaimed = selectedApplicationMember != '-1' || currentShortFormPreference.shortFormPreference.Application_Member__c != null ? properName(householdMemberFromPreference(selectedApplicationMember)) : '';
        	currentShortFormPreference.selectedAppMember = selectedApplicationMember;
        }
    }
    
    /*public String neighborhoodPreference {
        get;
        set {
            neighborhoodPreference = value;
            app.Neighborhood_Preference_Member__c = householdMemberIdFromPreference(neighborhoodPreference);
        }
    }

    // Same thing for the DTHP preference
    public String dthpPreference {
        get;
        set {
            dthpPreference = value;
            app.DTHP_Preference_Member__c = householdMemberIdFromPreference(dthpPreference);
        }
    }

    // Same thing for the COP preference
    public String copPreference {
        get;
        set {
            copPreference = value;
            app.COP_Preference_Member__c = householdMemberIdFromPreference(copPreference);
        }
    }

    // Same thing for the Live in SF preference
    public String liveInSfPreference {
        get;
        set {
            liveInSfPreference = value;
            app.Live_in_SF_Preference_Member__c = householdMemberIdFromPreference(liveInSfPreference);
        }
    }

    // Same thing for the Work in SF preference
    public String workInSfPreference {
        get;
        set {
            workInSfPreference = value;
            app.Work_in_SF_Preference_Member__c = householdMemberIdFromPreference(workInSfPreference);
        }
    }*/

    // Listing Id & Name
    public Id listingId {get; set;}
    public String listingName {get; set;}



    // Looks up a Household Member (using its Id) in the list of existing Household Members
    // on the Application and returns its index in the list (0, 1 etc.)
    // Returns -2 if it's the Primary Applicant and -1 if not found at all.
    private String preferenceFromHouseholdMemberId(Id householdMemberId) {
        String preference = '-1';
        if (householdMemberId == null) return preference;
        if (householdMemberId == primaryApplicant.Id) return '-2';
        for (Integer i = 0; i < householdMembers.size(); i++) {
            if (householdMembers[i].Id == householdMemberId) {
                preference = String.valueOf(i);
                break;
            }
        }
        return preference;
    }

    // The reverse operation, uses a preference key (-2, -1, 0, 1 etc.) to target an existing
    // Household Member (Primary Applicant for -2) and return its Id (or null for -1)
    private Id householdMemberIdFromPreference(String preference) {
        Application_Member__c am = householdMemberFromPreference(preference);
        return am == null ? null : am.Id;
    }

    // Uses a preference key (-2, -1, 0, 1 etc.) to target an existing Household Member (Primary Applicant for -2)
    // and returns the corresponding Application_Member__c record (or null for -1)
    private Application_Member__c householdMemberFromPreference(String preference) {
        return preference == '-1' ? null : preference == '-2' ? primaryApplicant : householdMembers[Integer.valueOf(preference)];
    }

    // Transforms a null String into an empty string, returns the original string otherwise
    private static String nvl(String s) {
        return s == null ? '' : s;
    }

    // Builds the Application Member's full and proper name from the First, Middle and Last Name.
    // Uses protection against null Text fields.
    private static String properName(Application_Member__c appMember) {
        return (nvl(appMember.First_Name__c) + ' ' + nvl(appMember.Middle_Name__c) + ' ' + nvl(appMember.Last_Name__c)).normalizeSpace();
    }
    
    //store additional info for existing application preference
    public static Map<Id,Application_Preference__c> existingAppPrefMap { get; set; }

    private void init() {
        app = new Application__c(Application_Language__c = 'English', Application_Submission_Type__c = HOP_Constants.PAPER_APPLICATION);
        primaryApplicant = new Application_Member__c();
        //alternateContact = new Application_Member__c();
        alternateContact = null;
        householdMembers = new List<Application_Member__c>();
        selectedHouseholdMemberIdx = -1;
        selectedShortFormPreferenceIdx = -1;
        shortFormPreferences = new List<ShortFormPreferenceWrapper>();
    }
    
    // Helper method that queries a Listing record by its Id
	private static Listing__c getListingById(String paramListingId) {
		List<Listing__c> listings = [
			SELECT
				Id, Name, Reserved_community_type__c,
				(SELECT Id, Unit__r.Reserved_Type__c FROM Listing_Units__r)
			FROM Listing__c
			WHERE Id = :paramListingId
		];

		if (listings.size() == 0) {
			return null;
		} else {
			return listings[0];
		}
	}
    
    public HOP_ApplicationFormController() {
        super();
        hasErrors = false;
        
        init();
        
        retUrl = ApexPages.currentPage().getParameters().get('retUrl');

        // The page expects either an Application Id parameter (to edit) or a Listing Id parameter (to add a new Application to)
        String paramApplicationId = ApexPages.currentPage().getParameters().get('id');
        String paramListingId = ApexPages.currentPage().getParameters().get('listingId');

        // If neither are provided, an error is triggered
        if (String.isBlank(paramApplicationId) && String.isBlank(paramListingId)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_ID_OR_LISTINGID));
            hasErrors = true;
            return;
        }
        
        if (!String.isBlank(paramApplicationId)) {
            // If an Application Id parameter is provided:
            // Check to see if an Application with the provided Id exists. If not, display an error.
            API_Application.ShortForm sf = API_ApplicationService.getShortformById(paramApplicationId);
            if (sf == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_APPLICATION_NOT_FOUND));
                hasErrors = true;
                return;
            }

            // Query additionally needed info. Check to see that the Lottery is not yet Complete (if it is, do not allow the Application to be edited.)
            appName = [ SELECT Name, Listing__c, Listing__r.Account__c, Listing__r.Name, Status__c, Is_Lottery_Complete__c,
            			(SELECT Id, Preference_Name__c, Person_who_claimed_Name__c,Lottery_Status__c FROM Application_Preferences__r)  //////// Added Lottery_Status__c by Nish to get status of AppPref //////////////
                        FROM Application__c
                        WHERE Id = :paramApplicationId];
            if (appName.Is_Lottery_Complete__c == true) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_LISTING_COMPLETE));
                hasErrors = true;
                return;
            }

            // Community users cannot edit Draft Applications, or Applications associated with an Account other than their own.
            if (myUser.Profile.UserLicense.Name == HOP_Constants.COMMUNITY_LICENSE_NAME &&
                (appName.Listing__r.Account__c != myUser.Contact.AccountId || appName.Status__c == HOP_Constants.DRAFT_APPLICATION)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_NO_ACCESS));
                hasErrors = true;
                return;
            }

            // Load the Application, Primary Applicant, Alternate Contact and Household Members into their corresponding variables.
            app = sf.toApplication();
            if (sf.primaryApplicant != null) {
                primaryApplicant = sf.primaryApplicant.toApplicationMember();
            }
            if (sf.alternateContact != null) {
                alternateContact = sf.alternateContact.toApplicationMember();
            }
            for (API_Application.Person p : sf.householdMembers) {
                householdMembers.add(p.toApplicationMember());
            }
            existingAppPrefMap = new Map<Id,Application_Preference__c>();
            for (Application_Preference__c appPref : appName.Application_Preferences__r) {
            	existingAppPrefMap.put(appPref.Id,appPref);
            }
            for (API_Application.ShortFormPreference sfPref : sf.shortFormPreferences) {
                shortFormPreferences.add(new ShortFormPreferenceWrapper(sfPref.toApplicationPreference()));
            }

            // For the five preferences, load the corresponding Household Member's index (-1 if not set) into five corresponding variables.
            /*neighborhoodPreference = preferenceFromHouseholdMemberId(app.Neighborhood_Preference_Member__c);
            dthpPreference = preferenceFromHouseholdMemberId(app.DTHP_Preference_Member__c);
            copPreference = preferenceFromHouseholdMemberId(app.COP_Preference_Member__c);
            liveInSfPreference = preferenceFromHouseholdMemberId(app.Live_in_SF_Preference_Member__c);
            workInSfPreference = preferenceFromHouseholdMemberId(app.Work_in_SF_Preference_Member__c);*/

            listingId = appName.Listing__c;
            listingName = appName.Listing__r.Name;
        	listing = getListingById(listingId);
        
        } else {
            // If a Listing Id parameter is provided:
            // Check to see if a Listing with the provided Id exists. If not, display an error.
            //List<Listing__c> listings = [SELECT Id, Name FROM Listing__c WHERE Id = :paramListingId];
            listing = getListingById(paramListingId);
            if (listing == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_LISTING_NOT_FOUND));
                hasErrors = true;
                return;
            }
            // The new Application is linked to the requested Listing and its Type is automatically set to Paper.
            app.Listing__c = listing.Id;
            app.Application_Submission_Type__c = HOP_Constants.PAPER_APPLICATION;

            listingId = listing.Id;
            listingName = listing.Name;
        }
        
        hasDevelopmentalDisabilitiesUnits = false;
		hasVeteransUnits = false;
		
		for (Listing_Unit__c listingUnit : listing.Listing_Units__r) {
			if (listingUnit.Unit__r.Reserved_Type__c == HOP_Constants.UNIT_DEVELOPMENTAL_DISABILITIES) {
				hasDevelopmentalDisabilitiesUnits = true;
			}
			if (listingUnit.Unit__r.Reserved_Type__c == HOP_Constants.UNIT_VETERAN) {
				hasVeteransUnits = true;
			}
		}
    }


    // Saves the entire Application form at once (including Primary Applicant, Alternate Contact, Household Members and preferences)
    // using the ApplicationService API.
    public PageReference saveApplicationForm() {
        app.Applicant__r = primaryApplicant;
        app.Alternate_Contact__r = alternateContact;
        API_Application.ShortForm sf = new API_Application.ShortForm(app, householdMembers);
        
        system.debug('shortFormPreferences:::' + shortFormPreferences);
        sf.shortFormPreferences = new List<API_Application.ShortFormPreference>();
		if (shortFormPreferences != null) {
			for (ShortFormPreferenceWrapper sfPrefW : shortFormPreferences) {
				system.debug('sfPrefW:::' + sfPrefW);
				system.debug('sfPrefW:::' + sfPrefW.shortFormPreference);
				API_Application.ShortFormPreference sfPref = new API_Application.ShortFormPreference(sfPrefW.shortFormPreference);
				system.debug('sfPref:::' + sfPref);
				if (/*app.Neighborhood_Preference_Member__c == null && */sfPrefW.selectedAppMember != null && sfPrefW.selectedAppMember != '-1') {
					sfPref.naturalKey = new API_Application.Person(householdMemberFromPreference(sfPrefW.selectedAppMember)).getKey();
				}
				sf.shortFormPreferences.add(sfPref);
				
			}
		}
        
       
        
        /*if (app.Neighborhood_Preference_Member__c == null && neighborhoodPreference != '-1') {
            sf.neighborhoodResidencePreferenceNatKey = new API_Application.Person(householdMemberFromPreference(neighborhoodPreference)).getKey();
        }
        if (app.DTHP_Preference_Member__c == null && dthpPreference != '-1') {
            sf.displacedPreferenceNatKey = new API_Application.Person(householdMemberFromPreference(dthpPreference)).getKey();
        }
        if (app.COP_Preference_Member__c == null && copPreference != '-1') {
            sf.certOfPreferenceNatKey = new API_Application.Person(householdMemberFromPreference(copPreference)).getKey();
        }
        if (app.Live_in_SF_Preference_Member__c == null && liveInSfPreference != '-1') {
            sf.liveInSfPreferenceNatKey = new API_Application.Person(householdMemberFromPreference(liveInSfPreference)).getKey();
        }
        if (app.Work_in_SF_Preference_Member__c == null && workInSfPreference != '-1') {
            sf.workInSfPreferenceNatKey = new API_Application.Person(householdMemberFromPreference(workInSfPreference)).getKey();
        }*/
        sf = API_ApplicationService.upsertShortform(sf);

        PageReference viewPage = new PageReference('/apex/HOP_ApplicationView?id=' + sf.id);
        viewPage.setRedirect(true);
        return viewPage;
    }

    // Save and New convenience button. Saves the current form and refreshes the page.
    public PageReference saveApplicationFormAndNew() {
        saveApplicationForm();
        init();
        app.Listing__c = listingId;
        return ApexPages.currentPage();
    }

    // Creates a new Household Member
    public void newHouseholdMember() {
        currentHouseholdMember = new Application_Member__c();
    }

    // Adds the new Household Member to the list. The currentHouseholdMember is now null.
    public void addHouseholdMember() {
        householdMembers.add(currentHouseholdMember);
        cancelHouseholdMember();
    }

    // Add and New convenience button. Adds the new Household Member to the list and prepares another new (empty) one
    public void addHouseholdMemberAndNew() {
        addHouseholdMember();
        newHouseholdMember();
    }

    // Saves the Household Member currently being edited
    public void saveHouseholdMember() {
        cancelHouseholdMember();
    }

    // Cancels the current Household Member edit
    public void cancelHouseholdMember() {
        currentHouseholdMember = null;
    }

    // Edits the selected existing Household Member
    public void editHouseholdMember() {
        if (selectedHouseholdMemberIdx != -1) {
            currentHouseholdMember = householdMembers[selectedHouseholdMemberIdx];
        }
    }

    // Delete the selected existing Household Member
    public void deleteHouseholdMember() {
        if (selectedHouseholdMemberIdx != -1) {
            householdMembers.remove(selectedHouseholdMemberIdx);
        }
    }
    
    //Shortform Preference
    // Creates a new Shortform Preference
    public void newShortFormPreference() {
        system.debug('currentShortFormPreference::' + currentShortFormPreference);
        currentShortFormPreference = new ShortFormPreferenceWrapper(new Application_Preference__c());
        currentShortFormPreference.shortFormPreference.Application__c = app.Id;
        system.debug('currentShortFormPreference::' + currentShortFormPreference);
        selectedListingPreference = null;
        system.debug('selectedListingPreference::' + selectedListingPreference);
        selectedApplicationMember = '-1';
        selectedShortFormPreferenceIdx = -1;
    }

    // Adds the new Shortform Preference to the list. The currentShortformPreference is now null.
    public void addShortFormPreference() {
        system.debug('currentShortFormPreference::' + currentShortFormPreference);
        system.debug('selectedListingPreference::' + selectedListingPreference);
        shortFormPreferences.add(currentShortFormPreference);
        cancelShortFormPreference();
        system.debug('shortFormPreferences::' + shortFormPreferences);
    }

    // Add and New convenience button. Adds the new Shortform Preference to the list and prepares another new (empty) one
    public void addShortFormPreferenceAndNew() {
        addShortFormPreference();
        newShortFormPreference();
    }

    // Saves the Shortform Preference currently being edited
    public void saveShortFormPreference() {
        system.debug('currentShortFormPreference::' + currentShortFormPreference);
        system.debug('selectedListingPreference::' + selectedListingPreference);
        cancelShortFormPreference();
    }

    // Cancels the current Shortform Preference edit
    public void cancelShortFormPreference() {
        currentShortFormPreference = null;
    }

    // Edits the selected existing Shortform Preference
    public void editShortFormPreference() {
    	if (selectedShortFormPreferenceIdx != -1) {
            currentShortFormPreference = shortFormPreferences[selectedShortFormPreferenceIdx];
            system.debug('currentShortFormPreference:::' + currentShortFormPreference);
            selectedListingPreference = currentShortFormPreference.shortFormPreference.Listing_Preference_ID__c;
            system.debug('selectedListingPreference:::' + selectedListingPreference);
            selectedApplicationMember = preferenceFromHouseholdMemberId(currentShortFormPreference.shortFormPreference.Application_Member__c);
        }
    }

    // Delete the selected existing Shortform Preference
    public void deleteShortFormPreference() {
        if (selectedShortFormPreferenceIdx != -1) {
            shortFormPreferences.remove(selectedShortFormPreferenceIdx);
        }
    }
    
    // created this wrapper as some fields are formula fields and their values are available only after insert
    public class ShortFormPreferenceWrapper {
    	public Application_Preference__c shortFormPreference { get; set; }
    	public String listingPrefName { get; set; }
    	public String selectedAppMember { get; set; }
    	public String personWhoClaimed { get; set; }
        public String LotteryStatus { get; set; }
    	
    	public ShortFormPreferenceWrapper(Application_Preference__c shortFormPreference) {
    		this.shortFormPreference = shortFormPreference;
    		listingPrefName = shortFormPreference.Id != null && existingAppPrefMap != null && existingAppPrefMap.containsKey(shortFormPreference.Id) ? existingAppPrefMap.get(shortFormPreference.Id).Preference_Name__c : '';
    		personWhoClaimed = shortFormPreference.Id != null && existingAppPrefMap != null && existingAppPrefMap.containsKey(shortFormPreference.Id) ? existingAppPrefMap.get(shortFormPreference.Id).Person_who_claimed_Name__c : '';
            
            ///////////////// Nish Added LotteryStatus to be displayed in edit page //////////////////////////
            LotteryStatus = shortFormPreference.Id != null && existingAppPrefMap != null && existingAppPrefMap.containsKey(shortFormPreference.Id) ? existingAppPrefMap.get(shortFormPreference.Id).Lottery_Status__c : '';

        }
    }

}