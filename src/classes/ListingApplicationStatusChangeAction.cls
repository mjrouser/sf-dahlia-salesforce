// *****************************************************************************
// CLASS: ListingApplicationStatusChangeAction
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 2016-11-02
// Description: Reviews if child Application Members need to be marked as duplicates
//              when the status of an Application changes to Submitted
//            
// *****************************************************************************
// MODIFICATIONS:  NOTE MOD#, DATE of mod, who made the change and description
// *****************************************************************************
// MOD1, 2016-11-16, Andu Andrei
// - replacing isDuplicateChecked__c with isFiltered__c
// - adding logic for when the Application Status changes back to Draft
// *****************************************************************************
public without sharing class ListingApplicationStatusChangeAction extends TriggerAction {

    Boolean shouldRun;
    public List<Application_Member__c> filteredApplicationMembers { get; set; }
    public List<Application_Member__c> unfilteredApplicationMembers { get; set; }
	private static string APPLICATION_SUBMITTED = 'Submitted';
    public ListingApplicationStatusChangeAction(Map<Id, SObject> triggerNewMap, Map<Id, SObject> triggerOldMap) {
        super(triggerNewMap, triggerOldMap);
        String ALTERNATE_CONTACT = API_Application.ALTERNATE_CONTACT;
        
        filteredApplicationMembers = new List<Application_Member__c>();
        unfilteredApplicationMembers = new List<Application_Member__c>();

        Set<Id> nonSubmittedApplicationIDS = new Set<Id>();
        Set<Id> submittedApplicationIDS = new Set<Id>();
        Set<Id> applicationIds = new Set<Id>();
        
        for (Id sObjId : triggerNewMap.keySet()) {
            Application__c oldApp = (Application__c)triggerOldMap.get(sObjId);
            Application__c newApp = (Application__c)triggerNewMap.get(sObjId);
			if (oldApp.Status__c == newApp.Status__c) {
				continue;
			}
            if (oldApp.Status__c == APPLICATION_SUBMITTED && newApp.Status__c != APPLICATION_SUBMITTED) {
                nonSubmittedApplicationIDS.add(sObjId);
                applicationIds.add(sObjId);
            }
            if (oldApp.Status__c != APPLICATION_SUBMITTED && newApp.Status__c == APPLICATION_SUBMITTED) {
                submittedApplicationIDS.add(sObjId);
                applicationIds.add(sObjId);
            }
        }
        
        if (applicationIds.size() > 0) {
            for (Application_Member__c am : [SELECT isFiltered__c, Type__c, Application__c FROM Application_Member__c WHERE Application__c IN :applicationIds AND Type__c != :ALTERNATE_CONTACT]) {
                if (submittedApplicationIDS.contains(am.Application__c)) {
               		unfilteredApplicationMembers.add(am);
                	
                }
                if (nonSubmittedApplicationIDS.contains(am.Application__c)) {
                 	filteredApplicationMembers.add(am);
                    
                }
            }
        }

        shouldRun = filteredApplicationMembers.size() > 0 || unfilteredApplicationMembers.size() > 0;
    }

    public override Boolean shouldRunOnInsert() { return false; }
    public override Boolean shouldRunOnDelete() { return false; } 
    public override Boolean shouldRunOnUpdate() { return shouldRun; }

    public override void doAction() {
        List<Application_Member__c> applicationMembersToUpdate = new List<Application_Member__c>();

        for (Application_Member__c am : filteredApplicationMembers) {
            am.isFiltered__c = 'TRUE';
            applicationMembersToUpdate.add(am);
        }
        for (Application_Member__c am : unfilteredApplicationMembers) {
            am.isFiltered__c = 'FALSE';
            applicationMembersToUpdate.add(am);
        }
        
        update applicationMembersToUpdate;
    }

    public static void runHandler() {
        if (trigger.isBefore && trigger.isUpdate) {
            ListingApplicationStatusChangeAction action = new ListingApplicationStatusChangeAction(Trigger.newMap, Trigger.oldMap);

            if (action.shouldRunOnUpdate()) {
                action.doAction(); 
            }
        }
    }

}