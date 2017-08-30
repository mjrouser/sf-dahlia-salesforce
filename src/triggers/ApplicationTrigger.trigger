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
trigger ApplicationTrigger on Application__c (before update, after update, after insert) {
    ListingApplicationStatusChangeAction.runHandler(); 
    ApplicationCreateAppPreferenceAction.runHandler();
    
    rollUpSummaryAction.runHandler('Listing_Lottery_Preference__c', 'Total_Submitted_Apps__c','Application_Preference__c', 'Listing_Preference_ID__c','Id','Application_Is_Submitted__c = true AND Receives_Preference__c = true', 'Application__c', 'Status__c',
                                   new List<String>{'Application_Is_Submitted__c','Receives_Preference__c'});
   
    
 //  ApplicationStatusChangeAction.runHandler(); 

}