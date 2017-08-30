//services/apexrest/Listing/UnitStats
@RestResource(urlMapping='/Listing/UnitStats/*')
global with sharing class ListUnitSummaryApi {


    public class InvalidParamsException extends Exception {}
    
    public class NoRecordMatchException extends Exception {}

    @HttpGet
    global static List<UnitStat> doGet () {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        List<String> tokens =  req.requestURI.split('/');
       
        if (tokens.size()>3) {
            return getUnitByListingId(tokens[3]);
        }
        if (req.params.containsKey('id')) {
            return getUnitByListingId(req.params.get('id'));
        }
        
         //return getAll(req.params.get('id'));
       
     throw new NoRecordMatchException(); 
       
    }
   
    
   global class UnitStat{
        ID listingID;
        String unitType;
        Decimal totalUnits;
        Decimal minOccupancy;
        Decimal maxOccupancy;
        Decimal minSquareFt;
        Decimal maxSquareFt;
        public UnitStat (AggregateResult result) {
            listingID = (ID)result.get('Listing__c');
            unitType = (String)result.get('Unit_Type__c');
            totalUnits = (Decimal)result.get('Total');
            minOccupancy = (Decimal)result.get('Min_Occupancy');
            maxOccupancy = (Decimal)result.get('Max_Occupancy');
            minSquareFt = (Decimal)result.get('Sq_Footage_Min');
            maxSquareFt = (Decimal)result.get('Sq_Footage_Max');
        
                        
            
        }
        
    }
    
    global static List<UnitStat> getUnitByListingId(string listingID){
    	AggregateResult[] results=  [SELECT Listing__c, Unit_Type__c,count(id)Total, MIN(Min_Occupancy__c)Min_Occupancy, Max(Max_Occupancy__c)Max_Occupancy, MIN(Unit_Square_Footage__c)Sq_Footage_Min, MAX(Unit_Square_Footage__c)Sq_Footage_Max  FROM UNIT__C WHERE Listing__c =: listingID GROUP BY listing__C, Unit_Type__c ];
        List<UnitStat> stats = new List<UnitStat>();
        for (AggregateResult result : results ) {
            stats.add(new UnitStat(result));
        }
        return stats;
    }
    
    global static List<UnitStat> getAll(String listingID)
    { 
        AggregateResult[] results=  [SELECT Listing__c, Unit_Type__c,count(id)Total, MIN(Min_Occupancy__c)Min_Occupancy, Max(Max_Occupancy__c)Max_Occupancy, MIN(Unit_Square_Footage__c)Sq_Footage_Min, MAX(Unit_Square_Footage__c)Sq_Footage_Max  FROM UNIT__C GROUP BY listing__C, Unit_Type__c ];
        List<UnitStat> stats = new List<UnitStat>();
        for (AggregateResult result : results ) {
            stats.add(new UnitStat(result));
        }
        return stats;
    } 
    
  
   
}