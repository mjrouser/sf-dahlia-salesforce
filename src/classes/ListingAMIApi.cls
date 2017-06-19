// *****************************************************************************
// CLASS: ListingAMIApi
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: API used to return AMI calculation
//				GET: /services/apexrest/ami
//				params: -chartType (required)
//						-year (required)
//						-percent
//						-amount
//						-householdsize
//
//				GET: /services/apexrest/ami/calc
//				params: -chartType (required)
//						-year (required)
//						-amount (required)
//						-householdsize (required)
//
//				GET: /services/apexrest/ami/charts
// *

@RestResource(urlMapping='/ami/*')
global class ListingAMIApi {

	public class InvalidParamsException extends Exception {}
	public class NoRecordMatchException extends Exception {}
	
	private static final String CHART_TYPE = 'chartType';
	private static final String YEAR = 'year';
	private static final String PERCENT = 'percent';
	private static final String AMOUNT = 'amount';
	private static final String HOUSEHOLD_SIZE = 'householdsize';
	
	@HttpGet
	global static List<ListingService.AMI> doGet () {
		RestRequest req = RestContext.request; 
		RestResponse res = RestContext.response;
		
		List<String> tokens =  req.requestURI.split('/');
		if (tokens.size() > 2) {
			
			if (tokens[2] == 'charts') {
				
				return ListingService.getCharts();
				
			}
			return null;
		}
		
		ListingService.AMI filter = new ListingService.AMI();
		if (req.params.containsKey(CHART_TYPE)) {
			filter.chartType = req.params.get(CHART_TYPE);
		} else {
			throw new InvalidParamsException('Both parameters "' + CHART_TYPE + '" and "' + YEAR + '" required');
		}
		if (req.params.containsKey(YEAR)) {
			filter.year = Decimal.Valueof((req.params.get(YEAR)));
		} else {
			throw new InvalidParamsException('Both parameters "' + CHART_TYPE + '" and "' + YEAR + '" required');
		}
		if (req.params.containsKey(PERCENT)) {
			filter.percent = Decimal.Valueof((req.params.get(PERCENT)));
		}
		if (req.params.containsKey(AMOUNT)) {
			filter.amount = Decimal.Valueof((req.params.get(AMOUNT)));
		}
		
		if (req.params.containsKey(HOUSEHOLD_SIZE)) {
			filter.numOfHousehold = Decimal.Valueof((req.params.get(HOUSEHOLD_SIZE)));
		}
		if (tokens.size() > 2) {
			
			if (tokens[2] == 'calc' && (filter.amount != null) && (filter.numOfHousehold != null)) {
				filter.percent = 100;
				
				return ListingService.Calc(filter);
				
			}
			return null;
		}
		
		return ListingService.getByFilter(filter);
	}
}