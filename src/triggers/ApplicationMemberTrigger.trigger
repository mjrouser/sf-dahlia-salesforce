// *****************************************************************************
// CLASS: ApplicationMemberTrigger
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 2016-11-01
// Description: Trigger file for Application_Member__c.
// *****************************************************************************
// MODIFICATIONS:  NOTE MOD#, DATE of mod, who made the change and description
// *****************************************************************************
// 
// *****************************************************************************
trigger ApplicationMemberTrigger on Application_Member__c (before insert, before update) {
	ListingApplicationMemberDuplicateAction.runHandler();
	//ApplicationMemberDuplicateAction.runHandler(); 
}