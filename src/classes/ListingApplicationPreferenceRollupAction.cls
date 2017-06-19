public class ListingApplicationPreferenceRollupAction extends TriggerAction{
    
    private Set<ID> listingPrefIds;
 	public ListingApplicationPreferenceRollupAction (List<SObject> appPrefs) {
		
		super(appPrefs);
		listingPrefIds = new Set<ID> ();
		for (Sobject sobj: appPrefs) {
			Application_Preference__c appPref = (Application_Preference__c) sobj;
			listingPrefIds.add(appPref.Listing_Preference_ID__c);	
		}
	 
	}
	
	public override boolean shouldRunOnInsert() {
		if (listingPrefIds.size()>0) {
			return true;		
		}
		else return false;
		
	}
	public override boolean shouldRunOnDelete() { 
		if (listingPrefIds.size()>0) {
			return true;		
		}
		else return false;
	
	} 
	public override boolean shouldRunOnUpdate() {
		if (listingPrefIds.size()>0) {
			return true;		
		}
		else return false;
	
		
	} 
	
	private class total {
		ID listingPrefID;
		Integer appSubmittedTotal;
		Integer appTotal;
		
	}
	public override void doAction() {
		
	
	//	AggregateResult[] totalAppResults = [SELECT  i.Listing_Preference_ID__c, COUNT(i.id)appCount FROM Application_Preference__c i where i.Listing_Preference_ID__c in :listingPrefIds GROUP BY i.Listing_Preference_ID__c];
		
	 	AggregateResult[] totalSubmittedAppResults = [SELECT  a.Listing_Preference_ID__c, COUNT(a.id)appCount FROM Application_Preference__c a where a.Listing_Preference_ID__c in :listingPrefIds and Application_Is_Submitted__c =true GROUP BY a.Listing_Preference_ID__c];
	 
	 	Map<ID,Listing_Lottery_Preference__c> listingPrefMap = new Map<ID,Listing_Lottery_Preference__c>();
		for (AggregateResult result: totalSubmittedAppResults) {
			Id listingPrefID = (Id)result.get('Listing_Preference_ID__c');
			Integer appCount = (Integer)result.get('appCount');
			Listing_Lottery_Preference__c listingPref =  (!listingPrefMap.containsKey(listingPrefID)) ? new Listing_Lottery_Preference__c(ID = listingPrefID): listingPrefMap.get(listingPrefID);
			listingPref.Total_Submitted_Apps__c = appCount;
			listingPrefMap.put(listingPrefID,listingPref);
		}
        
        //when deleting last appPref previous for is never executed and listingPrefs are not updated correctly
        for (Id listingPrefId : listingPrefIds) {
            if (!listingPrefMap.containsKey(listingPrefId)) {
                listingPrefMap.put(listingPrefID,new Listing_Lottery_Preference__c(ID = listingPrefID, Total_Submitted_Apps__c = 0));
            }
        }
		/*
		for (AggregateResult result: totalAppResults) {
			Id listingPrefID = (Id)result.get('Listing_Preference_ID__c');
			Integer appCount = (Integer)result.get('appCount');
			Listing_Lottery_Preference__c listingPref =  (!listingPrefMap.containsKey(listingPrefID)) ? new Listing_Lottery_Preference__c(ID = listingPrefID): listingPrefMap.get(listingPrefID);
			listingPref.Total_Apps__c = appCount;
			listingPrefMap.put(listingPrefID,listingPref);
			
		}*/
		if (listingPrefMap.keyset().size()>0) {
			update listingPrefMap.values();
		}
	
	}
  	public static void runHandler() {
        if (trigger.isAfter && (trigger.isUpdate || trigger.isInsert)){
        	ListingApplicationPreferenceRollupAction action = new ListingApplicationPreferenceRollupAction(Trigger.new);
            action.doAction(); 
            return;
        }
        if (trigger.isAfter && (trigger.isDelete)){
        	ListingApplicationPreferenceRollupAction action = new ListingApplicationPreferenceRollupAction(Trigger.old);
	        action.doAction(); 
	        return;
        	
        }
        
       
    }
}