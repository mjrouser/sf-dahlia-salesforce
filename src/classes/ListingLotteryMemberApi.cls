// *****************************************************************************
// CLASS: ListingLotteryMemberApi
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: API used to return the list of Lottery Members
//				GET: /services/apexrest/LotteryMember
// *

@RestResource(urlMapping='/LotteryMember/*')
global class ListingLotteryMemberApi {
    public class InvalidParamsException extends Exception {}
	public class NoRecordMatchException extends Exception {}
	
    @HttpGet
    global static List<Lottery_Member__c> doGet () {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        List<String> tokens =  req.requestURI.split('/');
        List<String> idList = new List<String>();
         
        //sample uri = /LotteryMember/<sfdcid>
        if (tokens.size()>2) {
            return ListingLotteryService.getLotteryMembersByListingID(tokens[2]); 
        } 
        if (req.params.containsKey('id')) {
            return ListingLotteryService.getLotteryMembersByListingID(req.params.get('id')); 
        }
        if (req.params.containsKey('ids')) {
            String ids = req.params.get('ids');
            idList = ids.split(',');
            return ListingLotteryService.getLotteryMembersByListingIDs(idList);
        }
        
        throw new InvalidParamsException('Invalid or missing parameter');
        
    }
}