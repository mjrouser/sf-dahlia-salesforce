// *****************************************************************************
// CLASS: ListingApplicationMemberDuplicateAction
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 2016-11-01
// Description: Marks Application Members as duplicates if they match a certain condition
//            
// *****************************************************************************
// MODIFICATIONS:  NOTE MOD#, DATE of mod, who made the change and description
// *****************************************************************************
// MOD1, 2016-11-16, Andu Andrei - replacing isDuplicateChecked__c with isFiltered__c
// *****************************************************************************
public without sharing class ListingApplicationMemberDuplicateAction extends TriggerAction {

    Boolean shouldRun;
    public List<Application_Member__c> isFilteredTrue { get; set; }
    public List<Application_Member__c> isFilteredFalse { get; set; }

    public ListingApplicationMemberDuplicateAction(List<SObject> triggerList) {
        super(triggerList);
        isFilteredTrue = new List<Application_Member__c>();
        isFilteredFalse = new List<Application_Member__c>();

        for (SObject sObj : triggerList) {
            Application_Member__c am = (Application_Member__c)sObj;
            if (am.Type__c == API_Application.ALTERNATE_CONTACT || am.Is_Application_Draft__c == true) {
                isFilteredTrue.add(am);
            }
            else isFilteredFalse.add(am);
        }
            
        shouldRun = true;
    }

    public override Boolean shouldRunOnInsert() { return shouldRun; }
    public override Boolean shouldRunOnDelete() { return false; } 
    public override Boolean shouldRunOnUpdate() { return shouldRun; }

    public override void doAction() {
        for (Application_Member__c am : isFilteredTrue) {
            am.isFiltered__c = 'TRUE';
        }
         for (Application_Member__c am : isFilteredFalse) {
            am.isFiltered__c = 'FALSE';
        }
    }

    public static void runHandler() {
        if (trigger.isBefore && trigger.isInsert) {
            ListingApplicationMemberDuplicateAction action = new ListingApplicationMemberDuplicateAction(Trigger.new);

            if (action.shouldRunOnInsert()) {
                action.doAction(); 
            }
        }
         if (trigger.isBefore && trigger.isUpdate) {
            ListingApplicationMemberDuplicateAction action = new ListingApplicationMemberDuplicateAction(Trigger.new);

            if (action.shouldRunOnUpdate()) {
                action.doAction(); 
            }
        }
    }

}