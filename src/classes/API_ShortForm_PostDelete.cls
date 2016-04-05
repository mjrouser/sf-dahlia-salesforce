@RestResource(urlMapping='/shortForm/delete')
global class API_ShortForm_PostDelete {
    
    @HttpPost
    global static void doPost(Id shortformId) {
        /*  /services/apexrest/shortForm/delete  */

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        if (shortformId == null) {
        	res.statusCode = 400;
            return;
    	}

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

}