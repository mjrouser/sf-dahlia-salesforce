public class LOT_RandomDrawReq extends LOT_RandomBaseRequest{
  
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
	      "title": "My Grand Prize Draw", --- > should tie to the listing
	      "recordType": "public",
	      "entries": ["foo","bar","baz"],   ---->this should tie to the unique name of the application
	      					
	      "entriesDigest": "a8cd76db952b9803be9163ead5dc4a2d",
	      "winnerCount": 1
	    },
	  
	}
  */
  
     public class Credentials {
	  	 public String login;
	  	 public String password;
	  	 
	 } 
	 public class DrawingParams {
	 	public Credentials credentials {
	  		get{
		  		Credentials credentials=  new Credentials();
		  		credentials.login = 'luke@vertiba.com';
		  		credentials.password = 'asdf1234';
		  		return credentials;
	  		}
	  		
	  	}
	  	public String title;
	  	public String recordType;
	   	public List<String> entries;
	  	public String entriesDigest {
	  	get {
		  		if (this.entries==null){
		  			return null;
		  		}
		  		Blob blobEntries = Blob.valueOf(JSON.serialize(entries));
	  			
	  			Blob bEntriesDigest = Crypto.generateDigest('MD5',blobEntries); 
	  			String entriesDigest = EncodingUtil.convertToHex(bEntriesDigest);
	  			return entriesDigest;
	  		}
	  	}
	  	public Integer winnerCount = 3;
	 }
	 public class Drawing {
	  	public String jsonrpc = '2.0';
	  	public String method = 'holdDraw';
	  	public DrawingParams params;
	  	public Integer id = 12;
	} 
	Drawing drawing;
	public  LOT_RandomDrawReq ( Drawing drawing){
		this.drawing = drawing;
	}
	   
	public override  String getJSON() 
	{
		return JSON.serialize(drawing);
	
	}
	public override  String getEndPoint() 
	{
 		return null;
 	}
 	public DrawingResult drawResult;
	public override void readResponse(String json) {
		drawResult = (DrawingResult) System.JSON.deserialize(json, DrawingResult.class);
		system.debug(drawResult);
	}
	  	
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
	 
  */
  //Container class for drawing response
	  public class DrawingResult {
  		public String jsonrpc;
  		public String error;
  		public Integer id;
  		public Result result;
	  		
	  }
	 //subclass
	  public class Result {
	  	public Integer drawID;
	  	public String status;
	  	public Integer entryCount;
	  	public String[] winners;
	  	public String completionTime;
	  	public String url;
	  	
	  	public DateTime timeCompleted;	
	  	public Integer winnerCount;
	  }
}