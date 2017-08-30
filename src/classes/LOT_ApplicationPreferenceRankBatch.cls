global class LOT_ApplicationPreferenceRankBatch implements Database.Batchable<sObject>, Database.Stateful {

    String query;
	Integer preferedRank;
    Id listingId;
	public LOT_PreferenceRankBatch nextBatch;

	
	global LOT_ApplicationPreferenceRankBatch(Id listingId) {
		this.preferedRank = 1;
		this.listingId = listingId;
        
		query = 'select id ,Listing_Preference_ID__c, Application__c, Receives_Preference__c, Application__r.Lottery_Rank__c from Application_Preference__c where Application__r.listing__c = \'' + listingId + '\' AND Application__r.Status__c = \'Submitted\' order by Listing_Preference_ID__c, Application__r.Lottery_Rank__c';
		system.debug('query:::' + query);
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Application_Preference__c> scope) {
		system.debug('scope:::' + scope);
        calculateRank(scope);
	}
	
	global void finish(Database.BatchableContext BC) {
        system.debug('nextBatch:::' + nextBatch);
        if (nextBatch != null){
        	Database.executeBatch(nextBatch);
        } else {
        	Listing__c listing = new Listing__c(Id=listingId);
	        /*if(preferedRank > 0){
	            //Listing__c listing = new Listing__c(Id=listingId);
	            listing.put(totalField,preferedRank);
	            //update listing;
	        }*/
        	listing.Lottery_Status__c = 'Lottery Complete';
	        update listing;
        }
	}

	public void calculateRank(List<Application_Preference__c> scope){
		ID currentListingPreferenceID = scope[0].Listing_Preference_ID__c;
		system.debug('scope:::' + scope.size());
   		for (Application_Preference__c appPref : scope) {
   			if (appPref.Listing_Preference_ID__c != currentListingPreferenceID) {
   				currentListingPreferenceID = appPref.Listing_Preference_ID__c;
   				preferedRank = 1;
   			}
   			if (appPref.Receives_Preference__c == true) {
   				appPref.Preference_Lottery_Rank__c = preferedRank++;
   			} else {
   				appPref.Preference_Lottery_Rank__c = null;
   			}
            system.debug('appPref:::' + appPref);
   		}
   		update scope;
	}
}