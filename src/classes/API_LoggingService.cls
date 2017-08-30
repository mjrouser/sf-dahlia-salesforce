public with sharing class API_LoggingService {
      public static void logRequest (RestRequest req) {
    	String jsonRequest= Json.serialize (req);
    	API_Service_Log__c log = new API_Service_Log__c();
    	try {
    		log.Body__c = req.requestBody.tostring();
    	}
    	catch (System.Exception e){
    		
    	}
    	log.URL__c=req.requestURI;
    	log.Method__c = req.httpMethod;
    	log.Serialized_Request__c = jsonRequest;
    	insert log;
    }
}