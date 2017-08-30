@isTest
global class HttpCalloutMockGeneratorTest implements HttpCalloutMock {
	
	global integer statusCode {get; set;}
	global string status {get; set;}
	global string body {get; set;}
	
	// Implement this interface method
	global HTTPResponse respond(HTTPRequest req) {
		
		// Create a fake response
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		if(statusCode == null)
			res.setStatusCode(200);
		else
			res.setStatusCode(statusCode);
		
		if(status == null)
			res.setStatus('OK');
		else
			res.setStatus(status);
		
		if(body == null)
			res.setBody('');
		else
			res.setBody(body);
		return res;
	}
}