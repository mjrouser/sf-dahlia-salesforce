public class LOT_Lottery {
	 
	
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
  
  
	  public class Credentials {
	  	 public String login;
	  	 public String password;
	  	 
	  }
	  public class Drawing {
	  	public String jsonrpc;
	  	public Credentials credentials;
	  	public String title;
	  	public String recordType;
	   	public List<String> entries;
	  	public String entriesDigest;
	  	public Integer winnerCount;
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