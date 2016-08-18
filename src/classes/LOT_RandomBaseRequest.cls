public abstract class LOT_RandomBaseRequest {
	public HttpResponse httpResp;
  	public External_Connections__c extConnection { get; set; }
 
  /*
  sample request
  {
    "jsonrpc": "2.0",
    "method": "holdDraw",
    "params": {
      "credentials": {
        "login": "test",
        "password": "secret"
      },
      "title": "My Grand Prize Draw",
      "recordType": "public",
      "entries": ["foo","bar","baz"],
      "entriesDigest": "a8cd76db952b9803be9163ead5dc4a2d",
      "winnerCount": 1
    },
  
}
  */
  
   /*
  sample response
 {
    "jsonrpc": "2.0",
    "result": {
        "drawId": 22993,
        "status": "completed",
        "entryCount": 3,
        "winners": ["bar"],
        "completionTime": "2011-10-10 13:19:12Z",
        "recordUrl": "https://draws.random.org/records/draw=22993"
    },
    "error": null,
    "id": 42
}
}
  */
  	
  
    protected LOT_RandomBaseRequest () {
     
        method = 'POST'; //default is a post but can be overriden

        extConnection = External_Connections__c.getValues('random.org');

        getConfiguration();
        
    }

    
    //public quoteProcessFieldName {currency_pref,bs_id,buyer_company_name,currency_pref,data_type,document_name
    protected void getConfiguration() {
	     
      
    } 

    public boolean bypass=true;
   	protected abstract String getEndpoint();
   	public String method {get;set;} 
   	public boolean createLog{get;set;}
   	protected String actionName{get;set;}
   	
    public abstract String getJSON();

    public virtual boolean sendRequest() {
    	
    	HttpRequest request = new System.HttpRequest();
    	String json =  getJSON();
    	String jsonRequest = json.replaceAll('(\\r|\\n)', '');
    	System.debug('json Request- '  + jsonRequest);
        request.setBody(json);
        request.setMethod('POST');
        String endpoint = extConnection.End_Point__c; //'https://draws.random.org/api/json-rpc/2/invoke';
        request.setEndpoint(endpoint); 
     
        Http http = new Http();
        httpResp= http.send(request);
       
        boolean success = false;
      
        try {
      		readResponse(httpResp.getBody());
      		
      	} 
      	catch(Exception e){
      		success = false;
      		system.debug('exception hit' + e);
      		
      	}
      	return success;
    }
    //potentially move this to a helper if we get bigger then just the paydiant api
   
   
 
    protected abstract Void readResponse(String json);
}