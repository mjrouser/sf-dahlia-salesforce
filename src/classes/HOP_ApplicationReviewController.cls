// *****************************************************************************
// CLASS: HOP_ApplicationReviewController
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Controller class for the HOP_ApplicationReview page.
//
// *****************************************************************************

public without sharing class HOP_ApplicationReviewController extends HOP_ControllerBase {

	// The Flagged Record Set record that will be used on the page
	public Flagged_Record_Set__c flaggedRecordSet {get; set;}

	// Variable that indicates whether any ApexPages Messages (errors) have been generated.
    public Boolean hasErrors {get; set;}

    // Most HOP pages support a retUrl parameter that enables "Back" navigation to the previous page.
	public String retUrl {get; set;}

    // Helper method that queries a Flagged_Record_Set__c record by its Id
	private static Flagged_Record_Set__c getFlaggedRecordSetById(String paramFlaggedRecordSetId) {
		List<Flagged_Record_Set__c> flaggedRecordSets = [
			SELECT Id, Listing__r.Name, Listing__r.Account__c, Listing__r.Lottery_Status__c, Rule_Name__c
			FROM Flagged_Record_Set__c
			WHERE Id = :paramFlaggedRecordSetId
		];

		if (flaggedRecordSets.size() == 0) {
			return null;
		} else {
			return flaggedRecordSets[0];
		}
	}

	public HOP_ApplicationReviewController() {
		super();
		hasErrors = false;
		retUrl = ApexPages.currentPage().getParameters().get('retUrl');

		// The page expects a Flagged Record Set Id parameter. If not provided, display an error.
        String paramFlaggedRecordSetId = ApexPages.currentPage().getParameters().get('id');
		if (String.isBlank(paramFlaggedRecordSetId)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_ID_NOT_PROVIDED));
            hasErrors = true;
            return;
		}

		// Check to see if a Flagged Record Set with the provided Id exists. If not, display an error.
		flaggedRecordSet = getFlaggedRecordSetById(paramFlaggedRecordSetId);
		if (flaggedRecordSet == null) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_FLAGGED_RECORD_SET_NOT_FOUND));
			hasErrors = true;
			return;
		}

		// Community users cannot access Flagged Record Sets associated with an Account other than their own.
        if (myUser.Profile.UserLicense.Name == HOP_Constants.COMMUNITY_LICENSE_NAME &&
        	flaggedRecordSet.Listing__r.Account__c != myUser.Contact.AccountId) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, HOP_Constants.ERROR_NO_ACCESS));
            hasErrors = true;
            return;
        }
	}

}