@RestResource(urlMapping='/shortForm/*')
global class API_ShortForm {
	
	@HttpGet
    global static API_Application.ShortForm doGet() {
        /*  /services/apexrest/shortForm/{shortFormId}  */

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        List<String> tokens = req.requestURI.split('/');
        if (tokens.size() != 3) {
            res.statusCode = 400;
            return null;
        }
        
        String shortFormId = tokens[2];
        API_Application.ShortForm sf = API_ApplicationService.getShortformById(shortFormId);
        if (sf == null) {
            res.statusCode = 400;
            return null;
        }
        
        res.statusCode = 200;
        return sf;
    }

    @HttpPost
    global static API_Application.ShortForm doPost() {
        /*  /services/apexrest/shortForm  */

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        API_Application.ShortForm sf = (API_Application.ShortForm)JSON.deserialize(req.requestBody.toString(), API_Application.ShortForm.class);

        if (sf.id != null) {
        	Boolean invalidId = false;
        	try {
        		Id sfId = Id.valueOf(sf.id);
        	} catch (Exception e) {
        		invalidId = true;
        	}
        	if (invalidId) {
        		res.statusCode = 400;
            	return null;
        	}

        	API_Application.ShortForm esf = API_ApplicationService.getShortformById(sf.id);
        	if (esf == null) {
            	res.statusCode = 404;
            	return null;
            }
        }
        
        res.statusCode = 200;
        return API_ApplicationService.upsertShortform(sf);
    }

}