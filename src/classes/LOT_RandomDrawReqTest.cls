public class LOT_RandomDrawReqTest {
    
    static Listing__c theListing = new Listing__c();
    static List<Application__c> apps;
    
    
    
    public static Map<String,ID>  getEntities(String listingID) {
        
        Map<String,ID> entities = new Map<String,ID>();
        List<Application__c> theApps = [select id, name from Application__c where status__c = 'Submitted' AND listing__c = :listingID ];
        
        for( Application__c app  :theApps){
            entities.put(app.name, app.id);
        }
        
        return entities;
    }
    
    public static void testBulk(String listingID) {
        
            Map<String,ID> entities=  getEntities(listingID) ;
            LOT_RandomDrawReq.Drawing drawing = new LOT_RandomDrawReq.Drawing();
            LOT_RandomDrawReq.DrawingParams params = new LOT_RandomDrawReq.DrawingParams();
            params.title= 'drawing 4';
            params.recordType= 'test'; //'public';
            params.entries= new List<String>(entities.keySet()); //our map is reversed-  
            params.winnerCount=(entities.size() < 50000) ? entities.size() : 500000;
            drawing.params= params;
            LOT_RandomDrawReq req = new LOT_RandomDrawReq(drawing);
            system.debug(req.getJSON());
            req.sendRequest();
            LOT_RandomDrawReq.DrawingResult drawResult = req.drawResult;
            
            Integer rank = 1;
            List<Application__c> appRankList= new List<Application__c> ();
            for (String winnerName:drawResult.result.winners) {
                ID theID = entities.get(winnerName);
                Application__c app = new Application__c();
                app.id = theID;
                rank++;
                app.Lottery_Rank__c = rank; 
                appRankList.add(app);
                
            }
            update  appRankList;
        
    }
}