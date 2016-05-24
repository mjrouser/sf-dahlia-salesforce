//services/apexrest/ami
@RestResource(urlMapping='/ami/*')
global class ListingAMIApi {

    public class InvalidParamsException extends Exception {}
    
    public class NoRecordMatchException extends Exception {}

	global class AMI {
		Decimal percent;
		Decimal numOfHousehold;
		Decimal amount;
	
		global AMI() {
			 
		}
		global AMI(AMI__c ami) {
			percent = ami.Percent_of_Median__c;
			numOfHousehold = ami.Num_of_HouseHold__c;
			amount= ami.Amount__c;
		}
		public String getFilterString() {
			String filter ='';
			if  (percent>0)  {
				filter=  ' Percent_of_Median__c=' + String.valueof(percent);
			}
			if  (numOfHousehold>0)  {
				filter+=(filter.length() > 0 ) ? ' and ' : ''; 
				
				filter+=  ' Num_of_HouseHold__c=' + String.valueof(numOfHousehold) ;
			}
			if (amount>0 ) {
				filter+=(filter.length() > 0 ) ? ' and ' : '';  
				filter+= ' Amount__c>='+ String.valueof(amount) + ' order by Amount__c asc limit 1';
			} 
			return filter;
		}  
		public String getCalcFilter() {
			String filter ='';
			if  (percent>0)  {
				filter=  ' Percent_of_Median__c=100';
			}
			if  (numOfHousehold>0)  {
				filter+=(filter.length() > 0 ) ? ' and ' : ''; 
				
				filter+=  ' Num_of_HouseHold__c=' + String.valueof(numOfHousehold) ;
			}
			
			return filter;
		}  
	}
	 
    @HttpGet
    global static List<AMI> doGet () {
        RestRequest req = RestContext.request; 
        RestResponse res = RestContext.response;
        
        List<String> tokens =  req.requestURI.split('/');
   		system.debug('tokens:::' + tokens);
        system.debug('req.params:::' + req.params);
       	AMI filter = new AMI();
        if (req.params.containsKey('percent')) {
        	filter.percent=  Decimal.Valueof((req.params.get('percent')));
        }
        if (req.params.containsKey('amount')) {
            filter.amount =Decimal.Valueof((req.params.get('amount')));
        }
        
        if (req.params.containsKey('householdsize')) {
       		filter.numOfHousehold = Decimal.Valueof((req.params.get('householdsize')));
        }
        if (tokens.size()>2) {
        	
            if (tokens[2] == 'calc' && (filter.amount!=null) && (filter.numOfHousehold!=null) ) {
            	filter.percent= 100;
            	
            	return Calc(filter);
            	
            }
            return null;
        }
      	return getByFilter(filter);
    }
    
    global static List<AMI> Calc(AMI filter)
    {
    	String filterString = filter.getCalcFilter();
    	
        //Read the Request from the URL
       
		String query = 'select id, amount__c, Num_of_HouseHold__c, Percent_of_Median__c from AMI__c ' ;
		if (filterstring.length() > 0 ) {
			query += ' where ' + filterString;
		}
		AMI returnAMI = new AMI();
						system.debug(query);
		system.debug('filterString::' + filterString);
		AMI__c ami = Database.query(query);
		
			system.debug(ami);
		returnAMI.percent = Math.round(filter.amount / ami.amount__c*100);
		//returnAMI.percent  = returnAMI.percent /100;
		returnAMI.numOfHousehold=filter.numOfHousehold; 
		returnAMI.amount=filter.amount;
		List<AMI> amiList = new List<AMI> {returnAMI};
		
      	return amiList;
    } 
    
    global static List<AMI> getByFilter(AMI filter)
    {
    	String filterString = filter.getFilterString();
    	
        //Read the Request from the URL
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
		String query = 'select id, amount__c, Num_of_HouseHold__c, Percent_of_Median__c from AMI__c ' ;
		if (filterstring.length() > 0 ) {
			query += ' where ' + filterString;
		}
		system.debug(query);
		List<AMI__c> amis = Database.query(query);
		List<AMI> amiList = new List<AMI> ();
		for (AMI__c ami : amis) {
			amiList.add(new AMI(ami));
		}
      	return amiList;
    } 
   
 
    
}