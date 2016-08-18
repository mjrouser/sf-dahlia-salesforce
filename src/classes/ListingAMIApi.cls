// *****************************************************************************
// CLASS: ListingAMIApi
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: API used to return AMI calculation
//				GET: /services/apexrest/ami
//				params: -percent
//						-amount
//						-householdsize
// *

@RestResource(urlMapping='/ami/*')
global class ListingAMIApi {

    public class InvalidParamsException extends Exception {}
    
    public class NoRecordMatchException extends Exception {}
	
	private static final String PERCENT = 'percent';
	private static final String AMOUNT = 'amount';
	private static final String HOUSEHOLD_SIZE = 'householdsize';
	
	@HttpGet
    global static List<ListingService.AMI> doGet () {
        RestRequest req = RestContext.request; 
        RestResponse res = RestContext.response;
        
        List<String> tokens =  req.requestURI.split('/');
   		ListingService.AMI filter = new ListingService.AMI();
        if (req.params.containsKey(PERCENT)) {
        	filter.percent = Decimal.Valueof((req.params.get(PERCENT)));
        }
        if (req.params.containsKey(AMOUNT)) {
            filter.amount = Decimal.Valueof((req.params.get(AMOUNT)));
        }
        
        if (req.params.containsKey(HOUSEHOLD_SIZE)) {
        	filter.numOfHousehold = Decimal.Valueof((req.params.get(HOUSEHOLD_SIZE)));
        }
        if (tokens.size()>2) {
        	
            if (tokens[2] == 'calc' && (filter.amount!=null) && (filter.numOfHousehold!=null) ) {
            	filter.percent= 100;
            	
            	return ListingService.Calc(filter);
            	
            }
            return null;
        }
      	return ListingService.getByFilter(filter);
    }
}