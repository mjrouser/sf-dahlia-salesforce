// *****************************************************************************
// CLASS: ListingUnitApi
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: API used to return the list of Units for a given listing
//				GET: /services/apexrest/Listing/Units/{listingId}
// *

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
}