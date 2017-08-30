// *****************************************************************************
// CLASS: API_ShortForm_PostContactDelete
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: API used to delete the primary application contact
//				POST: /services/apexrest/shortForm/contact/delete
//
// *

@RestResource(urlMapping='/shortForm/contact/delete')
global class API_ShortForm_PostContactDelete {
    
    @HttpPost
    global static void doPost(Id contactId) {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        if (contactId == null) {
        	res.statusCode = 400;
            return;
    	}

    	Boolean invalidId = false;
    	try {
    		Id eContactId = Id.valueOf(contactId);
    	} catch (Exception e) {
    		invalidId = true;
    	}
    	if (invalidId) {
    		res.statusCode = 400;
            return;
        }

    	API_Application.Person p = API_ApplicationService.getPersonById(contactId);
    	if (p == null) {
        	res.statusCode = 404;
            return;
        }
        
        API_ApplicationService.deletePerson(p);
        res.statusCode = 200;
    }

}