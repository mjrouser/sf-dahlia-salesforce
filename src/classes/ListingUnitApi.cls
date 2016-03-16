//services/apexrest/Listing/Units
@RestResource(urlMapping='/Listing/Units/*')
global with sharing class ListingUnitApi {


    public class InvalidParamsException extends Exception {}
    
    public class NoRecordMatchException extends Exception {}

    @HttpGet
    global static List<Unit__C> doGet () {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        List<String> tokens =  req.requestURI.split('/');
       
        if (tokens.size()>3) {
        	return ListingService.getUnitsByListingID(tokens[3]);
        }
        if (req.params.containsKey('id')) {
            return ListingService.getUnitsByListingID(req.params.get('id'));
        }
       
     	throw new NoRecordMatchException();
       
    }
   
    
    /*
    global static List<Unit__c> getByListingID(String listingID)
    { 
       
        return [SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Rental_Minimum_Monthly_Income_Needed__c, Unit_Square_Footage__c,  Unit_Number__c, Unit_Floor__c, Other_Accessibility_Information__c,Number_of_Bathrooms__c FROM Unit__c where Listing__c = :listingID  ORDER BY Unit_Type__c ];
    } 
    */
  
   
}