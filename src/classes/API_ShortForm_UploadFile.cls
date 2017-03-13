// *****************************************************************************
// CLASS: API_ShortForm_UploadFile
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: API used to upload a file into salesforce
//				POST: /shortForm/file/<applicaitonid> url
//						header  name - ,content type
//						body  -blob/binary
//				https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_sobject_blob_retrieve.htm
//				https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_rest_code_sample_restrequest.htm
//				http://sfdc.arrowpointe.com/2010/02/16/endpoint-for-debugging-http-callouts/
// *

@RestResource(urlMapping='/shortForm/file/*')
global class API_ShortForm_UploadFile {

	@HttpPost
    global static Attachment attachPicture(){
    	RestRequest req = RestContext.request;
    	system.debug('rest context '+req);
    	String name = req.headers.containsKey('Name') ? req.headers.get('Name') : 'unnamed';
    	String contentType = req.headers.containsKey('ContentType') ? req.headers.get('ContentType') : '';
    	
        RestResponse res = RestContext.response;
        Id appID = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Blob blb = req.requestBody;
        Attachment a = new Attachment (ParentId = appID,
                                       Body = blb,
                                       ContentType = contentType,
                                       Name = name);
        insert a;
        return a;
    }
    @HttpGet
    global static Attachment getPicture(){
    	
    	RestRequest req = RestContext.request;
    	Id atID = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    	Attachment a =  [select id, body, name from Attachment where id=:atID];
        RestResponse res = RestContext.response;
	
        return a;
    }
}