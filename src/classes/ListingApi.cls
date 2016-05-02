//services/apexrest/Listings
@RestResource(urlMapping='/Listing/*')
global with sharing class ListingApi {

    public class InvalidParamsException extends Exception {}
    
    public class NoRecordMatchException extends Exception {}
 
    @HttpGet
    global static List<Listing__c> doGet () {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        List<String> tokens =  req.requestURI.split('/');
        
        //sample uri = /listings/<sfdcid>
        if (tokens.size()>2) {
            return ListingService.getListingByID(tokens[2]); 
        } 
        if (req.params.containsKey('id')) {
            return ListingService.getListingByID(req.params.get('id'));
        }
        
        if (req.params.containsKey('ids')) {
            String ids = req.params.get('ids');
            List<String> idList  = ids.split(','); 
            return ListingService.getListingByIDs(idList); 
        } 
        //householdsize && incomelevel
     
        
        if (req.params.containsKey('householdsize') ||  req.params.containsKey('incomelevel') ) {
            String childrenUnder6 = req.params.get('childrenUnder6') ;
            String houseHoldSize = req.params.get('householdsize');
            String incomelevel = req.params.get('incomelevel'); 
            string preferenceName = req.params.get('preference');
            
            if (incomelevel== null || houseHoldSize == null) {
                throw new InvalidParamsException('Both parameters "householdsize" and "incomelevel" required');
            }
            ListingService.Criteria crit=  new ListingService.Criteria();
            try { 
                crit.householdSize = Integer.valueof(houseHoldSize);
                crit.incomelevel =Decimal.valueof( incomelevel);
                crit.childrenUnder6  = (childrenUnder6!=null) ? Integer.Valueof(childrenUnder6) : 0;
                crit.preferenceName = (preferenceName != null) ? preferenceName : '';
            }
            catch (Exception e) {
                
                throw new InvalidParamsException('Invalid Parameter input: Integer required for "householdsize", was passed value : ' + houseHoldSize + '  and Decimal required for "incomelevel", was passed value:' +  incomelevel +' Integer required for "childrenUnder6", was passed value : '  + childrenUnder6); // put friendly message here
                
            }
            return ListingService.getListingByCriteria(crit);
        
        } else if(req.params.containsKey('preference') ){
        	string preferenceName = req.params.get('preference');
    		if(preferenceName != null && preferenceName != ''){
            	return ListingService.getActiveListingsByPreference(preferenceName);
    		}
        }
        
        
        
        return ListingService.getAllActiveListings();
    }
   
}