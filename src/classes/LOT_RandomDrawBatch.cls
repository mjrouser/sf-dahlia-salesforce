global class LOT_RandomDrawBatch implements Database.Batchable<String>, Database.Stateful {
    
    List<String> winnerList;
    Map<String,ID> entities;
    global Integer rank;
    Id listingId;
    
    global LOT_RandomDrawBatch(List<String> winnerList, Map<String,ID> entities, Id listingId) {
        this.winnerList = winnerList;
        this.entities = entities;
        this.listingId = listingId;
        this.rank = 0;
    }
    
    global Iterable<String> start(Database.BatchableContext BC){
        return winnerList;
    }
    
    global void execute(Database.BatchableContext BC, List<String> winnerList){
        calculateRank(winnerList);
    }
    
    global void finish(Database.BatchableContext BC){
        Map<string,string> applicationPreference = new Map<string,string>();
        
        applicationPreference.put('DTHP_Preference__c','DTHP_Preference_Rank__c');
        applicationPreference.put('COP_Preference__c','COP_Preference_Rank__c');
        applicationPreference.put('Live_Work_Preference__c','Live_Work_Preference_Rank__c');
        applicationPreference.put('Neighborhood_Preference__c','Neighborhood_Preference_Rank__c');
        applicationPreference.put('General_Lottery__c','General_Lottery_Rank__c');
        
        Map<string,string> listingTotalFields = new Map<string,string>();
        listingTotalFields.put('DTHP_Preference__c','DTHP_App_Total__c');
        listingTotalFields.put('COP_Preference__c','COP_App_Total__c');
        listingTotalFields.put('Live_Work_Preference__c','Live_Work_App_Total__c');
        listingTotalFields.put('Neighborhood_Preference__c','Neighborhood_App_Total__c');
       	listingTotalFields.put('General_Lottery__c','General_App_Total__c');
        
        
        for(string pref : applicationPreference.keySet()){
            LOT_PreferenceRankBatch prefBatch = new LOT_PreferenceRankBatch(pref, applicationPreference.get(pref), listingTotalFields.get(pref), listingId);
            Database.executeBatch(prefBatch);
        }
        Listing__c listing = new Listing__c(Id=listingId);
        listing.Lottery_Status__c = 'Lottery Complete';
        update listing;
		
    }
    
    public void calculateRank(List<String> winnerList){
		List<Application__c> appRankList= new List<Application__c> ();
		system.debug('entities:::2::' + entities);
		system.debug('winnerList:::2::' + winnerList);
		for (String winnerName : winnerList) {
			ID theID = entities.get(winnerName);
			Application__c app = new Application__c();
			app.id = theID;
			rank++;
			app.Lottery_Rank__c = rank; 
        

			appRankList.add(app);
			
		}
		system.debug('appRankList:::2::' + appRankList);
		update  appRankList;
    }
}