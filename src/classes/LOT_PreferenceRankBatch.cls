global class LOT_PreferenceRankBatch implements Database.Batchable<sObject>, Database.Stateful {
	
	String query;
	String preferedField;
	String rankField;
	Integer preferedRank;
    String totalField;
    Id listingId;
	Set<string> completedPreffered;
	

	
	global LOT_PreferenceRankBatch(string prefField, string prefRankField, string prefTotalField, Id listingId) {
		this.preferedRank = 0;
		this.preferedField = prefField;
		this.rankField = prefRankField;
        this.totalField = prefTotalField;
        this.listingId = listingId;
        
		query = 'SELECT Id, Lottery_Rank__c, ' + preferedField + ', ' + rankField + ' FROM Application__c WHERE Listing__c = \'' + listingId + '\' AND Status__c = \'Submitted\' AND ' + preferedField + ' = true ORDER BY Lottery_Rank__c asc';
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Application__c> scope) {
		system.debug('scope:::' + scope);
        calculateRank(scope);
	}
	
	global void finish(Database.BatchableContext BC) {
        
        if(preferedRank > 0){
            Listing__c listing = new Listing__c(Id=listingId);
            listing.put(totalField,preferedRank);
            update listing;
        }
	}

	public void calculateRank(List<Application__c> scope){
		List<Application__c> updatedApplications = new List<Application__c>();

		for(Application__c application : scope){
			preferedRank++;
			
			application.put(rankField, preferedRank);

		}
		update scope;
	}
	
}