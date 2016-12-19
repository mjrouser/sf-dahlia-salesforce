// *****************************************************************************
// CLASS: ListingEligibilityCheckAPI
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: API used to return the eligibility info for a given listing that matches criteria
//				GET: /services/apexrest/Listing/EligibilityCheck/<sfdcid>
//				params: -householdsize
//						-incomelevel
//						-childrenUnder6
// *

@RestResource(urlMapping='/Listing/EligibilityCheck/*')
global class ListingEligibilityCheckAPI {
	public class InvalidParamsException extends Exception {}
	public class NoRecordMatchException extends Exception {}
	
	private static final String HOUSEHOLD_SIZE = 'householdsize';
	private static final String INCOME_LEVEL = 'incomelevel';
	private static final String CHILDREN_UNDER_6 = 'childrenUnder6';
	
	@HttpGet
	global static ListingService.Eligibility doGet () {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		API_LoggingService.logRequest(req);
		List<String> tokens =  req.requestURI.split('/');
		//sample uri = /Listing/EligibilityCheck/<sfdcid>
		String id;
		if (tokens.size() > 3) {
			id = tokens[3]; 
		} 
		if (req.params.containsKey('id')) {
			id = req.params.get('id');
		}
		
		if (id == null) {
			throw new InvalidParamsException('"id" parameter is required');
		}
			
		if (req.params.containsKey(HOUSEHOLD_SIZE)) {
			String childrenUnder6 = req.params.get(CHILDREN_UNDER_6);
			String houseHoldSize = req.params.get(HOUSEHOLD_SIZE);
			String incomelevel = req.params.get(INCOME_LEVEL); 
			if (houseHoldSize == null) {
				throw new InvalidParamsException('"' + HOUSEHOLD_SIZE + '" parameter is required');
			}
			ListingService.Criteria crit = new ListingService.Criteria();
			try { 
				crit.householdSize = Integer.valueof(houseHoldSize);
				crit.incomelevel = incomelevel != null ? Decimal.valueof(incomelevel) : 0;
				crit.childrenUnder6 = (childrenUnder6 != null) ? Integer.ValueOf(childrenUnder6) : 0;
			}
			catch (Exception e) {
				
			    throw new InvalidParamsException('Invalid Parameter input: Integer required for "' + HOUSEHOLD_SIZE + '", was passed value : ' + houseHoldSize + '  and Decimal required for "'+ INCOME_LEVEL + '", was passed value:' +  incomelevel +' Integer required for "' + CHILDREN_UNDER_6 + '", was passed value : '  + childrenUnder6);
            	
			}
			return ListingService.checkEligibility(crit,id);
		
		}
		
		throw new InvalidParamsException('Invalid or missing parameter');
		
	}
}