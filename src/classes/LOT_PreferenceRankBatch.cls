global class LOT_PreferenceRankBatch implements Database.Batchable<sObject>, Database.Stateful {
	
	String query;
	String preferedField;
	String rankField;
	Integer preferedRank;
    String totalField;
    Id listingId;
	Set<string> completedPreffered;
	public LOT_PreferenceRankBatch nextBatch;

	
	global LOT_PreferenceRankBatch(string prefField, string prefRankField, string prefTotalField, Id listingId) {
		this.preferedRank = 0;
		this.preferedField = prefField;
		this.rankField = prefRankField;
        this.totalField = prefTotalField;
        this.listingId = listingId;
        
		query = 'SELECT Id, Lottery_Rank__c, ' + preferedField + ', ' + rankField + ' FROM Application__c WHERE Listing__c = \'' + listingId + '\' AND Status__c = \'Submitted\' AND (' + preferedField + ' = true OR ' + rankField + ' != null) ORDER BY Lottery_Rank__c asc';
		//query = 'SELECT Id, Lottery_Rank__c, ' + preferedField + ', ' + rankField + ' FROM Application__c WHERE Listing__c = \'' + listingId + '\' AND Status__c = \'Submitted\' ORDER BY Lottery_Rank__c asc';
		system.debug('query:::' + query);
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Application__c> scope) {
		system.debug('scope:::' + scope);
        calculateRank(scope);
	}
	
	global void finish(Database.BatchableContext BC) {
        
        if (nextBatch != null){
        	Database.executeBatch(nextBatch);
        } else {
        	Listing__c listing = new Listing__c(Id=listingId);
	        if(preferedRank > 0){
	            //Listing__c listing = new Listing__c(Id=listingId);
	            listing.put(totalField,preferedRank);
	            //update listing;
	        }
        	listing.Lottery_Status__c = 'Lottery Complete';
	        update listing;
        }
	}

	public void calculateRank(List<Application__c> scope){
		List<Application__c> updatedApplications = new List<Application__c>();

		for(Application__c application : scope){
			if ((boolean)application.get(preferedField) == true) {
				preferedRank++;
				application.put(rankField, preferedRank);
			} else {
				application.put(rankField, null);
			}
		}
		update scope;
	}
	
}