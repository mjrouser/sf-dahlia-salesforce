//services/apexrest/LotteryResult
@RestResource(urlMapping='/Listing/LotteryResult/*')
global class ListingLotteryResultApi {
	public class InvalidParamsException extends Exception {}
	public class NoRecordMatchException extends Exception {}
	
	@HttpGet
	global static ListingService.ListingResult doGet () {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		
		List<String> tokens =  req.requestURI.split('/');
		system.debug('tokens:::' + tokens);
		//sample uri = /Listing/LotteryResult/<sfdcid>
		String id;
		if (tokens.size() > 3) {
			id = tokens[3]; 
		} 
		if (id == null) {
			throw new InvalidParamsException('"id" parameter is required');
		}
		system.debug('id:::' + id);
		
		return ListingService.getListingResultsListingID(id);
		
	}
}