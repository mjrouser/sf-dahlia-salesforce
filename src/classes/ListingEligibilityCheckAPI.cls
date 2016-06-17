//services/apexrest/EligibilityCheck
@RestResource(urlMapping='/EligibilityCheck/*')
global class ListingEligibilityCheckAPI {
	public class InvalidParamsException extends Exception {}
	public class NoRecordMatchException extends Exception {}
	
	@HttpGet
	global static ListingService.Eligibility doGet () {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		
		List<String> tokens =  req.requestURI.split('/');
		system.debug('tokens:::' + tokens);
		//sample uri = /EligibilityCheck/<sfdcid>
		String id;
		if (tokens.size() > 2) {
			id = tokens[2]; 
		} 
		if (req.params.containsKey('id')) {
			id = req.params.get('id');
		}
		
		if (id == null) {
			throw new InvalidParamsException('"id" parameter is required');
		}
			
		if (req.params.containsKey('householdsize')) {
			String childrenUnder6 = req.params.get('childrenUnder6');
			String houseHoldSize = req.params.get('householdsize');
			String incomelevel = req.params.get('incomelevel'); 
			if (houseHoldSize == null) {
				throw new InvalidParamsException('"householdsize" parameter is required');
			}
			ListingService.Criteria crit = new ListingService.Criteria();
			try { 
				crit.householdSize = Integer.valueof(houseHoldSize);
				crit.incomelevel = incomelevel != null ? Decimal.valueof(incomelevel) : 0;
				crit.childrenUnder6 = (childrenUnder6 != null) ? Integer.ValueOf(childrenUnder6) : 0;
			}
			catch (Exception e) {
				
				throw new InvalidParamsException('Invalid Parameter input: Integer required for "householdsize", was passed value : ' + houseHoldSize + '  and Decimal required for "incomelevel", was passed value:' +  incomelevel +' Integer required for "childrenUnder6", was passed value : '  + childrenUnder6); // put friendly message here
				
			}
			return ListingService.checkEligibility(crit,id);
		
		}
		
		throw new InvalidParamsException('Invalid or missing parameter');
		
	}
}