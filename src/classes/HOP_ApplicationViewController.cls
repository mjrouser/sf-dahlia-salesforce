// *****************************************************************************
// CLASS: HOP_ApplicationViewController
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Controller class for the HOP_ApplicationView page.
//
// *****************************************************************************

public without sharing class HOP_ApplicationViewController extends HOP_ControllerBase {

    // This will hold the current Application currently being viewed
    public Application__c app {get; set;}

    // The Primary Applicant on the Application
    public Application_Member__c primaryApplicant {get; set;}

    // The Alternate Contact on the Application
    public Application_Member__c alternateContact {get; set;}

    // Variable that indicates whether any ApexPages Messages (errors) have been generated.
    public Boolean hasErrors {get; set;}
    
    // The List of Attachments on the Application record
    public List<Attachment> attachments {get; set;}

    // A String beginning and ending in quotes and containing a comma separated list
    // of all the Flagged Record Sets this Application is a Flagged Application on 
    public String flaggedRecordSetString {get; set;}

    // Most HOP pages support a retUrl parameter that enables "Back" navigation to the previous page.
    public String retUrl {get; set;}

    // Helper method that queries a List of Attachments by their parent record Id
    private static List<Attachment> getAttachmentsByParent(String parentId) {
        return [
            SELECT Id, Name, BodyLength
            FROM Attachment
            WHERE ParentId = :parentId
        ];
    }

    // Helper method that queries an Application__c record by its Id
    private static Application__c getApplicationById(String paramApplicationId) {
        List<Application__c> applications = [
            SELECT
                Id, Name, Applicant__c, Alternate_Contact__c, Listing__c, Listing__r.Name, Listing__r.Account__c, Status__c,
                Total_Household_Size__c, Application_Submission_Type__c, Application_Submitted_Date__c, CreatedBy.Name,
                DTHP_Preference__c, DTHP_Preference_Member__r.Name__c, COP_Preference__c, COP_Preference_Member__r.Name__c,
                Neighborhood_Preference__c, Neighborhood_Preference_Member__r.Name__c, Neighborhood_Preference_Address__c,
                Live_Work_Preference__c, Live_in_SF_Preference_Member__r.Name__c, Work_in_SF_Preference_Member__r.Name__c,
                Annual_Income__c, Monthly_Income__c, Is_Lottery_Complete__c, Housing_Voucher_or_Subsidy__c, Referral_Source__c,
                Application_Language__c, DTHP_Preference_Manual__c, COP_Preference_Manual__c, Neighborhood_Preference_Manual__c,
            	Live_in_SF_Preference_Proof__c, Work_in_SF_Preference_Proof__c, Neighborhood_Preference_Proof__c,
            	Lottery_Number_Manual__c, Lottery_Number__c
            FROM Application__c
            WHERE Id = :paramApplicationId
        ];

        if (applications.size() == 0) {
        	return null;
        } else {
            return applications[0];
        }
    }

    // Helper method that queries an Application_Member__c record by its Id
    private static Application_Member__c getApplicantById(String applicantId) {
        List<Application_Member__c> applicants = [
            SELECT
                Name__c, Date_of_Birth__c, Phone_Type__c, Phone__c, Second_Phone_Type__c, Second_Phone__c, Email__c,
                Primary_Language__c, Residence_Address__c, Mailing_Address__c, Agency_Name__c,
                Alternate_Contact_Type__c, Alternate_Contact_Type_Other__c
            FROM Application_Member__c
            WHERE Id = :applicantId
        ];

        if (applicants.size() == 0) {
        	return null;
        } else {
            return applicants[0];
        }
    }


    public HOP_ApplicationViewController() {
        super();
        hasErrors = false;
        attachments = new List<Attachment>();
        retUrl = ApexPages.currentPage().getParameters().get('retUrl');
        
        // The page expects an Application Id parameter. If not provided, display an error.
        String paramApplicationId = ApexPages.currentPage().getParameters().get('id');
        if (String.isBlank(paramApplicationId)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_ID_NOT_PROVIDED));
            hasErrors = true;
            return;
        }

        // Check to see if an Application record with the provided Id exists. If not, display an error.
        app = getApplicationById(paramApplicationId);
        if (app == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_APPLICATION_NOT_FOUND));
            hasErrors = true;
            return;
        }

        // Community users cannot edit Draft Applications, or Applications associated with an Account other than their own.
        if (myUser.Profile.UserLicense.Name == HOP_Constants.COMMUNITY_LICENSE_NAME &&
            (app.Listing__r.Account__c != myUser.Contact.AccountId || app.Status__c == HOP_Constants.DRAFT_APPLICATION)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_NO_ACCESS));
            hasErrors = true;
            return;
        }

        // Load the Primary Applicant and Alternate Contact into their corresponding variables.
        if (app.Applicant__c != null) {
        	primaryApplicant = getApplicantById(app.Applicant__c);
        }
        if (app.Alternate_Contact__c != null) {
        	alternateContact = getApplicantById(app.Alternate_Contact__c);
        }

        // Load the Attachments on the Application record
        attachments = getAttachmentsByParent(app.Id);

        // Check to see if there are any Flagged Record Sets this Application is a Flagged Application on 
        List<String> flaggedRecordSetList = new List<String>();
        for (Flagged_Application__c flaggedApplication : [SELECT Flagged_Record_Set__c FROM Flagged_Application__c WHERE Application__c = :app.Id]) {
        	flaggedRecordSetList.add('\'' + flaggedApplication.Flagged_Record_Set__c + '\'');
        }
        
        // Builds a comma separated string with all the Flagged Record Sets' Ids (or a pair of single quotes if none exist.)
    	flaggedRecordSetString = flaggedRecordSetList.size() > 0 ? String.join(flaggedRecordSetList, ',') : '\'\'';
    }

}