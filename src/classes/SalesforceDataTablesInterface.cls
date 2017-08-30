public interface SalesforceDataTablesInterface {

	//=============================================================================================================================================//

	/*
		queryFieldInfo
		--------------

		queryFieldInfo returns the metadata for each column in the resultset.
		It is used both in the Standard and the Enhanced version of the Salesforce DataTables.

		The FieldInfo class has three properties:
		- Field[] fields - an array of metadata for each column in the resultset. See details about the Field class below.
		- Field[] requiredFields - an array of metadata for each REQUIRED column in the resultset.
								   Used when creating a new Object, no matter what fields have been queried.
        - String keyField - the name of the "key"; for SF records it should be "Id".
        					If using a model class then it should be the property used as a primary unique key.
        					
		The Field class has seven properties that must be specified for each column:
		- String name - the CASE SENSITIVE name of the column, whether it's a field on a SF object, or a property of the model class
        - String dataType - corresponds to the SF Schema.DisplayType Enum. See complete list of possible values below.
        - String relationshipName - for columns with a dataType of 'ID' or 'Reference', contains the path to the "name" column, for display purposes.
        							For example, "Name", or "Account.Name"
        - Boolean readOnly - whether the column should be treated as read-only i.e. non-editable
        - String label - the column's display label i.e. the table header value
        - Integer scale - for columns with a dataType of 'Currency', 'Double' or 'Percent', contains the number of decimals
        - List<String> picklistValues - for columns with a dataType of 'Picklist' or 'MultiPicklist', contains the list of picklist values

		This is the complete list of possible values for the dataType:
		- String
		- Date
		- DateTime
		- Address
		- Boolean
		- Currency
		- ID
		- Reference
		- Double
		- Integer
		- Email
		- Percent
		- Phone
		- Picklist
		- MultiPicklist
		- URL
		- TextArea
		- Location

		Most should be pretty self-explanatory. When in doubt, use String.
		Address and Location are currently not supported.
		If your numeric column has decimals, use Double.

		ID and Reference are (for implementation purposes) identical.
		The former means "the current record's ID" and the latter represents a reference/lookup to another record.
	*/

	SalesforceDataTables.FieldInfo queryFieldInfo();

	//=============================================================================================================================================//

	/*
		getRecordsStandard
		------------------

		getRecordsStandard implements the response for a Standard version of the Salesforce DataTables.
		This approach (Standard) means returning the entire resultset at once, alongside the metadata, with no further communication with the server.

		The StandardResponse class has three properties:
		- FieldInfo fieldInfo - should contain exactly what queryFieldInfo returns - see above section
		- Object[] records - contains the resultset; any class list or sObject list works here
		- String error - should ONLY be set when trapping an error and returning it client-side; in this case, DO NOT SET the other two properties
	*/

	SalesforceDataTables.StandardResponse getRecordsStandard(String whereClause, String defaultsJSON);

	//=============================================================================================================================================//

	/*
		getRecordsEnhanced
		------------------

		getRecordsEnhanced implements the response for an Enhanced version of the Salesforce DataTables.
		This approach (Enhanced) means returning a very small portion of the entire resultset.
		This is meant to be used when the full resultset would have hundreds of thousands of rows or more.

		Because of this, there are two types of "calls" / use cases for this method. Either:
		- the "keys" are supplied, i.e. keys.size() > 0
		  In this case, recordsTotal and recordsFiltered will also be supplied and they only need to be echoed back in the response.
		  The only thing that needs to be returned is the (partial) resultset, i.e. the rows that correspond to those "keys".
		  allKeys should be returned as null.
		- no "keys" are supplied, i.e. keys.size() == 0.
		  This is the case for an initial call, or whenever an ordering or filtering option changes.
		  In this case, the full list of "keys" (allKeys) needs to be requeried, the "total" and "filtered" number of records recalculated,
		  and all of these need to be returned alongside the (partial) resultset which corresponds to the first page.


		A "key" means a unique primary key. Normally it would be a SF record ID, but it can be any String.

		"Total" number of rows means without any filtering. Used for display purposes. 57 in example below.
		"Filtered" number of rows means including global or column-level filtering. Used for display purposes. 26 in example below.

		(e.g. Showing 1 to 10 of 26 entries (filtered from 57 total entries))


		The getRecordsEnhanced method will receive five parameters:
		- FieldInfo[] fields - should contain exactly what queryFieldInfo returns - see above section
		- ServerSideRequest request - this is the DataTables request structure for a server-side call. See details below.
		- List<String> keys - the list of "keys" for which the corresponding list of rows needs to be returned
							  If supplied (size > 0), then recordsTotal and recordsFiltered are also supplied
		- Integer recordsTotal - if keys.size() > 0, will contain the cached total number of rows and needs to be returned in the response
								 Otherwise, needs to be recalculated (and returned in the response)
		- Integer recordsFiltered - if keys.size() > 0, will contain the cached "filtered" number of rows and needs to be returned in the response
								 Otherwise, needs to be recalculated (and returned in the response)

		The ServerSideRequest class contains the DataTables request structure for server-side calls. It has the following six properties:
		- Integer draw - draw counter, an integer that must be echoed back in the response for consistency purposes
        - Integer start - paging first record indicator. 0 index based - i.e. 0 is the first record.
        - Integer length - the number of rows that need to be returned, starting from start. This is the page length (10 in above example)
        - Search search - global search value. Currently not implemented.
        - List<Order> order - a list of orders which should be applied. See Order class below.
        - List<Column> columns - the list of columns in the resultset. Contains metadata and search-related info. See Column class below.

        The Order class defines the ordering on a column (which has an order applied to it). It has two properties:
        - Integer column - the index of the column in the column list
        - String dir - 'asc' or 'desc'

        The Column class defines a column in the resultset. It has the following five properties:
        - String data - the name of the SF field name or APEX class property name that powers the column
        - String name - will be an empty string
        - Boolean orderable - metadata, whether ordering can be applied to the column
        - Search search - used when filtering is applied to the column. See Search class below.
        - Boolean searchable - metadata, whether filtering can be applied to the column

        The Search class defines the filtering on a column (which has a filter applied to it). It has two properties:
        - Boolean regex - whether the value should be interpreted as a regular expression or not.
        				  Normally false; regular expressions currently not implemented.
        - String value - the search value to apply to this specific column. Normally an empty string.


		The EnhancedResponse class has six properties:
		- Integer draw - must be set to request.draw (request is one of the parameters)
        - Integer recordsTotal - when the keys parameter has size>0, must be set to the recordsTotal parameter
        						 otherwise, it must be recalculated and returned
        - Integer recordsFiltered - when the keys parameter has size>0, must be set to the recordsFiltered parameter
        						 otherwise, it must be recalculated and returned
        - Object[] data - contains the resultset; any class list or sObject list works here
        - List<String> allKeys - should only be set if the keys parameter has size=0. Otherwise, should be null.
		- String error - should ONLY be set when trapping an error and returning it client-side; in this case, DO NOT SET any of the other properties
	*/

	SalesforceDataTables.EnhancedResponse getRecordsEnhanced(
		SalesforceDataTables.FieldInfo fieldInfo, SalesforceDataTables.ServerSideRequest request,
		Set<String> keys, Integer recordsTotal, Integer recordsFiltered
	);

	//=============================================================================================================================================//

	/*
		processRows
		-----------

		processRows is used when editable is set to true and editing capabilities are enabled on the Salesforce DataTables.
		It takes care of processing the rows received from SFDT when adding new rows, editing or deleting.

		It has three parameters:
		- FieldInfo fieldInfo - should contain exactly what queryFieldInfo returns - see above section
		- String action - either 'create', 'edit' or 'remove'; determines whether the rows will be inserted / updated / deleted
		- Map<String, Object> rows - a map where the keys are the "keys" of the rows (ignore when creating)
									 and the values are the Objects (SObject / model class) to process

		The EditorResponse class contains the DataTables Editor response structure for server-side calls. It has the following three properties:
		- Object[] data - the "new" data i.e. newly inserted rows or updated rows (with the updated values). Should be Null when deleting.
        - String error - should ONLY be set when trapping an error and returning it client-side; in this case, DO NOT SET any of the other properties
        - List<FieldError> fieldErrors - should ONLY be set when trapping field-level errors and returning them client-side;
                                         in this case, DO NOT SET any of the other properties
	*/

	SalesforceDataTables.EditorResponse processRows(SalesforceDataTables.FieldInfo fieldInfo, String action, Map<String, Object> rows);

	//=============================================================================================================================================//

    /*
		getObjectName
		-----------

		getObjectName returns the name of the Object that powers the data behind the SFDT.
		It can be an SObject like Contact / Custom_Object__c or any model APEX class.
	*/

    String getObjectName();

    SalesforceDataTables.LookupValuesResponse queryLookupValues(SalesforceDataTables.Field field, String query);
}