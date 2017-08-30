// *****************************************************************************
// CLASS: ApplicationTrigger
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 2016-11-02
// Description: Trigger file for Application__c.
// *****************************************************************************
// MODIFICATIONS:  NOTE MOD#, DATE of mod, who made the change and description
// *****************************************************************************
// 
// *****************************************************************************
trigger ApplicationTrigger on Application__c (before update) {
	ListingApplicationStatusChangeAction.runHandler(); 
	
	//ApplicationStatusChangeAction.runHandler(); 
}