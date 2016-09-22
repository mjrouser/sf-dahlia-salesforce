// *****************************************************************************
// CLASS: ListingLotteryResultSummaryAPI
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: API used to return the summary Lottery results for a given listing
//				GET: /services/apexrest/LotteryResult/{listingID}
// *


@RestResource(urlMapping='/Listing/LotteryResult/Summary/*')
global class ListingLotteryResultSummaryAPI {
	public class InvalidParamsException extends Exception {}
	public class NoRecordMatchException extends Exception {}
	
	@HttpGet
	global static ListingService.ListingResult doGet () {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		
		List<String> tokens =  req.requestURI.split('/');
		//sample uri = /Listing/LotteryResult/Summary/<sfdcid>
		String id;
		if (tokens.size() > 4) {
			id = tokens[4]; 
		} 
		if (id == null) {
			throw new InvalidParamsException('"id" parameter is required');
		}
		
		return ListingService.getListingResultsByListingID(id);
		
	}
}