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
trigger ApplicationTrigger on Application__c (before update, after update) {
    ListingApplicationStatusChangeAction.runHandler(); 
    
    if(trigger.isAfter) 
		rollUpSummaryAction.runHandler('Listing_Lottery_Preference__c', 'Total_Submitted_Apps__c','Application_Preference__c', 'Listing_Preference_ID__c','Id','Application_Is_Submitted__c', 'Application__c', 'Status__c');
    
    
 //  ApplicationStatusChangeAction.runHandler(); 

}