// *****************************************************************************
// CLASS: API_Person
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: Contains logic for Person API service calls
//				GET: /services/apexrest/Person/{contactId}
//				POST: /services/apexrest/Person/
//
// *

@RestResource(urlMapping='/Person/*')
global class API_Person {
	
	@HttpGet
    global static API_Application.Person doGet() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        API_LoggingService.logRequest(req);
        
        List<String> tokens = req.requestURI.split('/');
        if (tokens.size() != 3) {
            res.statusCode = 400;
            return null;
        }
        
        String contactId = tokens[2];
        API_Application.Person person = API_ApplicationService.getPersonById(contactId);
        if (person == null) {
            res.statusCode = 400;
            return null;
        }
        
        res.statusCode = 200;
        return person;
    }

    @HttpPost
    global static API_Application.Person doPost() {

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        API_Application.Person person = (API_Application.Person)JSON.deserialize(req.requestBody.toString(), API_Application.Person.class);
		
        if (person.contactId != null) {
        	Boolean invalidId = false;
        	try {
        		Id sfId = Id.valueOf(person.contactId);
        	} catch (Exception e) {
        		invalidId = true;
        	}
        	if (invalidId) {
        		res.statusCode = 400;
            	return null;
        	}

        	API_Application.Person ep = API_ApplicationService.getPersonByContactId(person.contactId);
        	if (ep == null) {
            	res.statusCode = 404;
            	return null;
            }
        }
        
        res.statusCode = 200;
        
        //API_Application.Person updatedPerson = API_ApplicationService.upsertContactAndCascadeUpdate(person);
        API_Application.Person updatedPerson = API_ApplicationService.upsertPrimaryPerson(person);
        return updatedPerson;
    }

}