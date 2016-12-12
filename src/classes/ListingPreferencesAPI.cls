// *****************************************************************************
// CLASS: ListingPreferencesAPI
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: API used to return the list of Listing Preferences
//				GET: /services/apexrest/Listing/Preferences/{listingID}
// *

@RestResource(urlMapping='/Listing/Preferences/*')
global class ListingPreferencesAPI {
    public class InvalidParamsException extends Exception {}
	public class NoRecordMatchException extends Exception {}
	
    @HttpGet
    global static List<ListingService.ListingPreference> doGet () {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        List<String> tokens =  req.requestURI.split('/');
        List<String> idList = new List<String>();
         
        //sample uri = /Listing/Preferences/<sfdcid>
        if (tokens.size() > 3) {
            return ListingService.getListingPreferenceByListingID(tokens[3]); 
        } 
        if (req.params.containsKey('id')) {
            return ListingService.getListingPreferenceByListingID(req.params.get('id')); 
        }
        throw new InvalidParamsException('Invalid or missing parameter');
        
    }
}