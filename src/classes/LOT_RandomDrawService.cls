global with sharing class LOT_RandomDrawService {
    
    static webservice void testBulk(String listingID) {
        Listing__c listing = [SELECT Id, Name, Lottery_Status__c FROM Listing__c WHERE Id = : listingID];
        if(listing.Lottery_Status__c == null || listing.Lottery_Status__c == 'Not Yet Run'){
            
           //             Map<String,ID> entities = LOT_RandomDrawReqTest.getEntities(listingID) ;
           
            Map<String,ID> entities = getEntities(listingID) ;
            LOT_RandomDrawReq.Drawing drawing = new LOT_RandomDrawReq.Drawing();
            LOT_RandomDrawReq.DrawingParams params = new LOT_RandomDrawReq.DrawingParams();
            params.title = 'drawing 4';
            params.recordType = 'test'; //'public';
            params.entries = new List<String>(entities.keySet()); //our map is reversed-  
            params.winnerCount = (entities.size() < 50000) ? entities.size() : 500000;
            drawing.params = params;
            LOT_RandomDrawReq req = new LOT_RandomDrawReq(drawing);
            system.debug(req.getJSON());
            req.sendRequest();
            system.debug(req.getJSON());
            LOT_RandomDrawReq.DrawingResult drawResult = req.drawResult;
            
            //update listing to in progress
            listing.Lottery_Status__c = 'In Progress';
            listing.Number_of_Applications__c = entities.size();
            update listing;
            
            //system.debug('drawResult.result:::' + drawResult.result);
            
            if (drawResult != null) {
                /*Integer rank = 1;
                List<Application__c> appRankList= new List<Application__c> ();
                for (String winnerName:drawResult.result.winners) {
                    ID theID = entities.get(winnerName);
                    Application__c app = new Application__c();
                    app.id = theID;
                    rank++;
                    app.Lottery_Rank__c = rank; 
                    appRankList.add(app);
                    
                }
                update  appRankList;*/
                system.debug('entities:::1::' + entities);
                system.debug('winners:::1::' + drawResult.result.winners);
                Database.executeBatch(new LOT_RandomDrawBatch(drawResult.result.winners, entities, listingID));
            }
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
}