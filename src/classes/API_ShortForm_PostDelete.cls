// *****************************************************************************
// CLASS: API_ShortForm_PostDelete
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: API used to delete the shortform based on shortform Id
//				POST: /services/apexrest/shortForm/delete
//
// *

@RestResource(urlMapping='/shortForm/delete/*')
global class API_ShortForm_PostDelete {
        global class InvalidRequestException extends Exception {}
    
    @HttpPost
    global static void doPost(Id shortformId) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        if (shortformId == null) {
        	res.statusCode = 400;
            return;
    	}
    	performDelete(shortformId,res);
/*
    	Boolean invalidId = false;
    	try {
    		Id esfId = Id.valueOf(theID);
    	} catch (Exception e) {
    		invalidId = true;
    	}
    	if (invalidId) {
    		res.statusCode = 400;
            return;
        }

    	API_Application.ShortForm esf = API_ApplicationService.getShortformById(theID);
    	if (esf == null) {
        	res.statusCode = 404;
            return;
        }
        
        res.statusCode = 200;
        API_ApplicationService.deleteShortform(esf);*/
    }
    static void performDelete(String shortFormId, RestResponse res) {
        
      
    	Boolean invalidId = false;
    	try {
    		Id esfId = Id.valueOf(shortformId);
    	} catch (Exception e) {
    		invalidId = true;
    	}
    	if (invalidId) {
    		res.statusCode = 400;
            return;
        }

    	API_Application.ShortForm esf = API_ApplicationService.getShortformById(shortformId);
    	if (esf == null) {
        	res.statusCode = 404;
            return;
        }
        
        res.statusCode = 200;
        API_ApplicationService.deleteShortform(esf);
    }
    
	@HttpDelete
    global static void doDelete() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
     
        
        List<String> tokens = req.requestURI.split('/');
        if (tokens.size() != 4) {
            res.statusCode = 400;
            return ;
        }
        String shortFromID = tokens[3];
         
        performDelete(shortFromID,res);

    }
}