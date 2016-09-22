// *****************************************************************************
// CLASS: ListingLotteryResultBucketAPI
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: API used to return the bucket Lottery results for a given listing
//				GET: /services/apexrest/Listing/LotteryResult/Bucket/{listingID}
// *

@RestResource(urlMapping='/Listing/LotteryResult/Bucket/*')
global class ListingLotteryResultBucketAPI {
	public class InvalidParamsException extends Exception {}
	public class NoRecordMatchException extends Exception {}
	
	@HttpGet
	global static ListingService.ListingResult doGet () {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		
		List<String> tokens =  req.requestURI.split('/');
		//sample uri = /Listing/LotteryResult/Bucket/{listingID}
		String id;
		if (tokens.size() > 4) {
			id = tokens[4]; 
		} 
		if (id == null) {
			throw new InvalidParamsException('"id" parameter is required');
		}
		
		return ListingService.getListingResults(id, null, true);
		
	}
}