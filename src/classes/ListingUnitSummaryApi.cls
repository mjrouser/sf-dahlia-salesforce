//services/apexrest/Listing/UnitStats
@RestResource(urlMapping='/Listing/UnitSummary/*')
global with sharing class ListingUnitSummaryApi {
 

    public class InvalidParamsException extends Exception {}
    
    public class NoRecordMatchException extends Exception {}

    @HttpGet
    global static List<ListingService.UnitSummary> doGet () {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        List<String> tokens =  req.requestURI.split('/');
       
        if (tokens.size()>3) {
            return ListingService.getUnitSummaryByListingID(tokens[3]);
        }	
        if (req.params.containsKey('id')) {
            return ListingService.getUnitSummaryByListingID(req.params.get('id'));
        }
        
         //return getAll(req.params.get('id'));
       
     throw new NoRecordMatchException(); 
       
    } 
   
}