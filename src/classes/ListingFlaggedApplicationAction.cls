// *****************************************************************************
// CLASS: ListingFlaggedApplicationAction
// *****************************************************************************
//
// Author: Vertiba/Jason Christman
// Date: 2016-07-13
// Description: Takes DuplicateRecordItems and gets the parent DuplicateRecordSet records 
// 			  : then locates if the parent Flagged_Record_Set exists and if not creates
// 			  : then inserts child records for Flagged_Application__c based on DuplicateRecordItem
// 			  :
// *****************************************************************************
// MODIFICATIONS:  NOTE MOD#, DATE of mod, who made the change and description
// *****************************************************************************
// 
// *****************************************************************************
public without sharing class ListingFlaggedApplicationAction extends TriggerAction{
    boolean shouldRun;
    public static boolean hasRun = true;
    public List<DuplicateRecordItem> relaventDupItems { get; set; }
    public Map<Id, Application_Member__c> applicationMap { get; set; }
    
    // trigger controller that accepts trigger data
    public ListingFlaggedApplicationAction (Map<Id,SObject> newMap, Map<Id,SObject> oldMap) {
        super(newMap, oldMap);
        Map<ID,sobject> changedMap = new Map<Id,SObject> ();
        
        for (ID objID: newMap.keyset()) {
            SObject newObj = newMap.get(objID);
            SObject oldObj = oldMap.get(objID);
        }
        
    }
    
    // trigger controller that accepts trigger data
    public ListingFlaggedApplicationAction (Map<Id,SObject> newMap) {
        
        super(newMap);
        DuplicateRecordItem duplicateRecordItem = new DuplicateRecordItem();
        Set<Id> appIds = new Set<Id>();
        relaventDupItems = new List<DuplicateRecordItem>();
        
        for(Id driId : newMap.keySet()){
            duplicateRecordItem = (DuplicateRecordItem)newMap.get(driId);
            if(duplicateRecordItem.RecordId .getSObjectType().getDescribe().getName() == 'Application_Member__c' && !appIds.contains(duplicateRecordItem.RecordId))	{
                
                relaventDupItems.add(duplicateRecordItem);
                appIds.add(duplicateRecordItem.RecordId);
            }
        }
        
        if(appIds != null && !appIds.isEmpty()){
            applicationMap = new Map<Id,Application_Member__c>([SELECT Id, Application__c, Application__r.Listing__c FROM Application_Member__c WHERE Id in : appIds]);
        }
        
        
    }
    
    // check if action should run on insert if there are relavent duplicate items
    public override Boolean shouldRunOnInsert() { 
        shouldRun = false;
        if(relaventDupItems != null && !relaventDupItems.isEmpty()){
            shouldRun = true;
        }
        
        return shouldRun; 
    }
    
    public override Boolean shouldRunOnDelete() { return shouldRun; } 
    public override Boolean shouldRunOnUpdate() { return shouldRun; } 
    
    // action method if should run true to process duplicate record items and create flagged application items
    public override void doAction() {
        Set<Id> duplicateRecordSetIds = new Set<Id>();
        Set<Id> createFromDrSetIds = new Set<Id>();
        List<DuplicateRecordItem> createFromDRI = new List<DuplicateRecordItem>();
        List<DuplicateRecordSet> duplicateRecordSets = new List<DuplicateRecordSet>();
        List<Flagged_Record_Set__c> flaggedRecordSets = new List<Flagged_Record_Set__c>();
        
        Map<Id,Id> duplicateRecordSetListingMap = new Map<Id,Id>();
        Map<Id,Id> duplicateItemFlagRecordSetMap = new Map<Id,Id>();
        Map<Id,Id> duplicateFlaggedRecordSetMap = new Map<Id,Id>();
        if(relaventDupItems != null && !relaventDupItems.isEmpty()){
        	
            // do parent ( exist or create )
            for(DuplicateRecordItem dri : relaventDupItems){
                duplicateRecordSetIds.add(dri.DuplicateRecordSetId);
                createFromDrSetIds.add(dri.DuplicateRecordSetId);
                duplicateRecordSetListingMap.put(dri.DuplicateRecordSetId, applicationMap.get(dri.RecordId).Application__r.Listing__c);
            }
            
            // Check if parent exists if so remove set id from list that needs created
            if(duplicateRecordSetIds != null && !duplicateRecordSetIds.isEmpty()){
                flaggedRecordSets = getFlagRecordSetsByDuplicateRecordSetId(duplicateRecordSetIds);
                
                for(Flagged_Record_Set__c frs : flaggedRecordSets){
                    if(createFromDrSetIds.contains(frs.DuplicateRecordSetID__c)){
                        createFromDrSetIds.remove(frs.DuplicateRecordSetID__c); // remove existing ids from list
                    }
                }
            }
            
            // Get DuplicateRecordSets that need created 
            if(createFromDrSetIds != null && !createFromDrSetIds.isEmpty()){
                duplicateRecordSets = getDuplicateRecordSets(createFromDrSetIds);
            }
            
            // Create parent Flag_Record_Set items
            if(duplicateRecordSets != null && !duplicateRecordSets.isEmpty()){
                Map<Id, Id> listingDprsMap = new Map<Id,Id>();
                for(DuplicateRecordSet drs : duplicateRecordSets){
                    listingDprsMap.put(drs.Id, duplicateRecordSetListingMap.get(drs.Id));
                }
                //Create new records
                flaggedRecordSets = createFlaggedRecordSet(duplicateRecordSets,listingDprsMap);
                
            }
            //Get All FlagRecordSets
            flaggedRecordSets = getFlagRecordSetsByDuplicateRecordSetId(duplicateRecordSetIds);
            
            if(flaggedRecordSets != null && !flaggedRecordSets.isEmpty()){
                for(Flagged_Record_Set__c frs : flaggedRecordSets){
                    duplicateFlaggedRecordSetMap.put(frs.DuplicateRecordSetID__c,frs.Id);
                }
            }
            
            
            for(DuplicateRecordItem dri : relaventDupItems){
                if(duplicateFlaggedRecordSetMap.containsKey(dri.DuplicateRecordSetId)){
                    
                    duplicateItemFlagRecordSetMap.put(dri.Id, duplicateFlaggedRecordSetMap.get(dri.DuplicateRecordSetId));
                }
            }
            
            // do child ( exist or create )
            
            List<Flagged_application__c> flaggedApplications = createFlaggedApplication(relaventDupItems,duplicateItemFlagRecordSetMap);
            
        }
    } 
    
    // method called from trigger that checks to know if it should run
    public static void runHandler() {
        
        if (!trigger.isAfter && (!trigger.isInsert )) return;
        
        System.debug('Running ListingFlaggedApplicationAction');
        
        if (trigger.isInsert && ListingFlaggedApplicationAction.hasRun) {
            ListingFlaggedApplicationAction action = new ListingFlaggedApplicationAction(Trigger.newMap);
            
            if (action.shouldRunOnInsert()) {
                action.doAction(); 
                ListingFlaggedApplicationAction.hasRun = false;
            }
        }
    }
    
    // Converts duplicate record items to flagged applications
    private List<Flagged_Application__c> createFlaggedApplication(List<DuplicateRecordItem> duplicateRecordItems, Map<Id,Id> duplicateRecordFlaggedSet) {
        List<Flagged_Application__c> flaggedApps = new List<Flagged_Application__c>();
        Flagged_Application__c flaggedApp = new Flagged_Application__c();
        for(DuplicateRecordItem dri : duplicateRecordItems){
            flaggedApp = new Flagged_Application__c();
            flaggedApp.Application__c = applicationMap.get(dri.RecordId).Application__c;
            flaggedApp.DuplicateRecordItem__c = dri.Id;
            if(duplicateRecordFlaggedSet.containsKey(dri.Id)){
                flaggedApp.Flagged_Record_Set__c = duplicateRecordFlaggedSet.get(dri.Id);
            }
            flaggedApp.Listing__c = applicationMap.get(dri.RecordId).Application__r.Listing__c;
            flaggedApp.System_Flagged__c = true;
            
            flaggedApps.add(flaggedApp);
        }
        if(flaggedApps != null && !flaggedApps.isEmpty()){
            insert flaggedApps;
        }
        return flaggedApps;
    }
    
    // get flagged recrod set records from duplicate recordset ids
    private  Map<ID,Flagged_Record_Set__c> getFlaggeredRecordSet(Set<String> duplicateRecordSetIDs) {
        Map<ID,Flagged_Record_Set__c>  flaggedRecordMap =  new Map<ID,Flagged_Record_Set__c> ([select id, DuplicateRecordSetID__c from Flagged_Record_Set__c  where DuplicateRecordSetID__c in : duplicateRecordSetIDs ]);
        return flaggedRecordMap;
        
    }
    
    // get duplicate record set records from ids
    private List<DuplicateRecordSet> getDuplicateRecordSets(Set<ID> ids) {
        List<DuplicateRecordSet> duplicateRecordSets = new List<DuplicateRecordSet >();
        try{
            duplicateRecordSets = [select id, rule_name__c, duplicateRuleID from DuplicateRecordSet where id in  :ids] ;
        } catch(Exception e){
            system.debug(e);
        }
        return duplicateRecordSets;
    }
    
    // get flagged record sets from duplicate record set ids
    private List<Flagged_Record_Set__c> getFlagRecordSetsByDuplicateRecordSetId(Set<ID> ids) {
        List<Flagged_Record_Set__c > flaggedRecordSets = new List<Flagged_Record_Set__c >();
        try{
            flaggedRecordSets = [select id, DuplicateRecordSetID__c from Flagged_Record_Set__c where DuplicateRecordSetID__c in  :ids] ;
        } catch(Exception e){
            system.debug(e);
        }
        
        return flaggedRecordSets;
    }
    
    // convert duplicate record sets to flagged record sets
    private List<Flagged_Record_Set__c> createFlaggedRecordSet (List<DuplicateRecordSet> duplicateRecordSets, Map<Id, Id> duplicateRecordSetListingMap)  {
        List<Flagged_Record_Set__c> flaggedRecordSets = new List<Flagged_Record_Set__c>();
        Flagged_Record_Set__c flaggedRecordSet = new Flagged_Record_Set__c();
        for(DuplicateRecordSet dprs : duplicateRecordSets){
            flaggedRecordSet = new Flagged_Record_Set__c();
            flaggedRecordSet.DuplicateRecordSetID__c= dprs.Id;
            flaggedRecordSet.Listing__c = duplicateRecordSetListingMap.get(dprs.Id);
            flaggedRecordSet.Rule_Name__c = dprs.Rule_Name__c;
            flaggedRecordSets.add(flaggedRecordSet);
        }
        
        if(flaggedRecordSets != null && !flaggedRecordSets.isEmpty()){
            insert flaggedRecordSets;
        }
        
        return flaggedRecordSets;
        
    } 
    
}