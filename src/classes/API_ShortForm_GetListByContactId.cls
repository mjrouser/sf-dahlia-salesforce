@RestResource(urlMapping='/shortForm/list/*')
global class API_ShortForm_GetListByContactId {
    
    @HttpGet
    global static List<API_Application.ShortForm> doGet() {
        /*  /services/apexrest/shortForm/list/{ContactID}  */

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        List<String> tokens = req.requestURI.split('/');
        if (tokens.size() != 4) {
            res.statusCode = 400;
            return null;
        }
        
        String contactId = tokens[3];
        Contact c = API_ApplicationService.getContactById(contactId);
        if (c == null) {
            res.statusCode = 400;
            return null;
        }
        
        res.statusCode = 200;
        return API_ApplicationService.getShortformsByContactId(contactId);
    }

}