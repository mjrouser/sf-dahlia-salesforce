// *****************************************************************************
// CLASS: ListingLotteryPrefApi
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: API used to return the list of Lottery Preference
//				GET: /services/apexrest/LotteryPreference
// *deprecated api


@RestResource(urlMapping='/LotteryPreference/*')
global with sharing class ListingLotteryPrefApi {
	
	public class InvalidParamsException extends Exception {}
	public class NoRecordMatchException extends Exception {}
	
    @HttpGet
    global static List<Lottery_Preference__c> doGet () {
    	/*
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        List<String> tokens =  req.requestURI.split('/');
        List<String> idList = new List<String>();
        
        //sample uri = /LotteryPreference/<sfdcid>
        if (tokens.size()>2) {
            return ListingLotteryService.getLotteryPreferenceByID(tokens[2]); 
        } 
        
        if (req.params.containsKey('id')) {
            return ListingLotteryService.getLotteryPreferenceByID(req.params.get('id')); 
        }
        if (req.params.containsKey('ids')) {
            String ids = req.params.get('ids');
            idList  = ids.split(',');
            return ListingLotteryService.getLotteryPreferenceByIDs(idList);
        }
        
        return ListingLotteryService.getAllLotteryPreference();
        */
        return null;
    }
}