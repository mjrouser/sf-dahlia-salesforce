global with sharing class LOT_RandomDrawService {
    public class ErrorException extends Exception {}
    
    static webservice void runLottery(String listingID, Boolean isPreferenceLottery) {
        Listing__c listing = [SELECT Id, Name, Lottery_Status__c FROM Listing__c WHERE Id = : listingID];
        if(!isPreferenceLottery) {
            if(listing.Lottery_Status__c == null || listing.Lottery_Status__c == 'Not Yet Run'){
                
                Map<String,ID> entities = getEntities(listingID) ;
                LOT_RandomDrawReq.Drawing drawing = new LOT_RandomDrawReq.Drawing();
                LOT_RandomDrawReq.DrawingParams params = new LOT_RandomDrawReq.DrawingParams();
                params.title = 'Drawing for listing - ' + listingID;
                //params.recordType = 'test'; //'public';
                params.entries = new List<String>(entities.keySet()); //our map is reversed-  
                params.winnerCount = (entities.size() < 50000) ? entities.size() : 50000;
                drawing.params = params;
                LOT_RandomDrawReq req = new LOT_RandomDrawReq(drawing);
                req.sendRequest();
                system.debug('error::::' + req);
                LOT_RandomDrawReq.DrawingResult drawResult = req.drawResult;
                
                //system.debug('drawResult.result:::' + drawResult.result);
                if (drawResult == null) {
                    throw new ErrorException('There are no drawing results returned from Random.org.');
                    return;
                } else if (drawResult.error != null) {
                    throw new ErrorException(drawResult.error.message);
                    return;
                }
                
                if (drawResult != null && drawResult.result.winners.size() > 0) {
                    //update listing to in progress
                    listing.Lottery_Status__c = 'In Progress';
                    listing.Number_of_Applications__c = entities.size();
                    listing.Draw_ID__c = '' + drawResult.result.drawID;
                    //listing.LotteryResultsURL__c = drawResult.result.url;
                    //listing.Lottery_End_Time__c = drawResult.result.completionTime;
                    update listing;
                    
                    Database.executeBatch(new LOT_RandomDrawBatch(drawResult.result.winners, entities, listingID));
                } else {
                    listing.Lottery_Status__c = 'Lottery Complete';
                    update listing;
                }
            }
        } else {
            listing.Lottery_Status__c = 'In Progress';
            system.debug('listing:::' + listing);
            update listing;
            system.debug('listing::2:' + listing);
            preferenceLottery(listingID);
        }
    }
    
    private static Map<String,ID>  getEntities(String listingID) {
        
        Map<String,ID> entities = new Map<String,ID>();
        List<Application__c> theApps = [select id, name from Application__c where status__c = 'Submitted' AND listing__c = :listingID ];
        
        for( Application__c app  :theApps){
            entities.put(app.name, app.id);
        }
        
        return entities;
    }
    
    public static void preferenceLottery(Id listingId) {
        //System.enqueueJob(new LOT_QueueUpPreferenceBatches(null, null, null, listingId));
        
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
        
        
        LOT_PreferenceRankBatch prevBatch = null;
        LOT_PreferenceRankBatch prefBatch = null;
        
        for(string pref : applicationPreference.keySet()){
            prefBatch = new LOT_PreferenceRankBatch(pref, applicationPreference.get(pref), listingTotalFields.get(pref), listingId);
            prefBatch.nextBatch = prevBatch;
            prevBatch = prefBatch;
            //Database.executeBatch(prefBatch);
        }
        
        Database.executeBatch(prefBatch);
    }
}