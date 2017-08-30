global without sharing class SalesforceDataTables {

    //
    // The following classes and functions are common to both versions.
    //

    global class Field {
        @AuraEnabled public String name;
        @AuraEnabled public String dataType;
        @AuraEnabled public Boolean required;
        @AuraEnabled public String relationshipName;
        @AuraEnabled public String keyName;
        @AuraEnabled public Boolean readOnly;
        @AuraEnabled public String label;
        @AuraEnabled public Integer scale;
        @AuraEnabled public List<String> picklistValues;
        @AuraEnabled public String defaultValue;
        @AuraEnabled public String defaultNameValue;
        
        global Field(String name, String dataType, Boolean required, String relationshipName, String keyName,
                     Boolean readOnly, String label, Integer scale, List<String> picklistValues, Object defaultValue, String defaultNameValue) {
            this.name = name;
            this.dataType = dataType;
            this.required = required;
            this.relationshipName = relationshipName;
            this.keyName = keyName;
            this.readOnly = readOnly;
            this.label = label;
            this.scale = scale;
            this.picklistValues = picklistValues;
            this.defaultValue = String.valueOf(defaultValue);
            this.defaultNameValue = defaultNameValue;
        }
    }

    private static Boolean isFieldRequired(Schema.DescribeFieldResult dfr) {
        return (dfr.isCreateable() && !dfr.isNillable() && !dfr.isDefaultedOnCreate());
    }

    private static Field getField(String fullName, Schema.DescribeSObjectResult dor, Schema.DescribeFieldResult dfr, Object defaultValue) {
        String prefix = fullName.contains('.') ? fullName.substringBeforeLast('.') + '.' : '';
        String fieldName = fullName.contains('.') ? fullName.substringAfterLast('.') : fullName;

        String relationshipName = '';
        String keyName = prefix + 'Id';
        Boolean required = isFieldRequired(dfr);
        Boolean readOnly = !dfr.isUpdateable();
        String label = dfr.getLabel();
        Integer scale = dfr.getScale();
        List<String> picklistValues = new List<String>();
        defaultValue = defaultValue == null ? dfr.getDefaultValue() : defaultValue;
        Schema.DisplayType displayType = dfr.getType();

        String dataType = 'String';
        if (displayType == Schema.DisplayType.Date) {
            dataType = 'Date';
        } else if (displayType == Schema.DisplayType.DateTime) {
            dataType = 'DateTime';
        } else if (displayType == Schema.DisplayType.Address) {
            dataType = 'Address';
        } else if (displayType == Schema.DisplayType.Boolean) {
            dataType = 'Boolean';
        } else if (displayType == Schema.DisplayType.Currency) {
            dataType = 'Currency';
        } else if (displayType == Schema.DisplayType.ID) {
            dataType = 'ID';
            relationshipName = prefix + 'Name';
        } else if (displayType == Schema.DisplayType.Reference) {
            dataType = 'Reference';
            relationshipName = prefix + dfr.getRelationshipName() + '.Name';
        } else if (displayType == Schema.DisplayType.Double) {
            dataType = 'Double';
        } else if (displayType == Schema.DisplayType.Integer) {
            dataType = 'Integer';
        } else if (displayType == Schema.DisplayType.Email) {
            dataType = 'Email';
        } else if (displayType == Schema.DisplayType.Percent) {
            dataType = 'Percent';
        } else if (displayType == Schema.DisplayType.Phone) {
            dataType = 'Phone';
        } else if (displayType == Schema.DisplayType.Picklist) {
            dataType = 'Picklist';
            for (Schema.PicklistEntry spe : dfr.getPicklistValues()) {
                picklistValues.add(spe.getLabel());
            }
        } else if (displayType == Schema.DisplayType.MultiPicklist) {
            dataType = 'MultiPicklist';
            for (Schema.PicklistEntry spe : dfr.getPicklistValues()) {
                picklistValues.add(spe.getLabel());
            }
        } else if (displayType == Schema.DisplayType.URL) {
            dataType = 'URL';
        } else if (displayType == Schema.DisplayType.TextArea) {
            dataType = 'TextArea';
        } else if (displayType == Schema.DisplayType.Location) {
            dataType = 'Location';
        }

        String defaultNameValue = null;
        if (defaultValue != null && (dataType == 'ID' || dataType == 'Reference')) {
            String relObjectName = dor.getName();
            if (dataType == 'Reference') {
                relObjectName = dfr.getReferenceTo()[0].getDescribe().getName();
            }

            List<SObject> sos = Database.query('SELECT Name FROM ' + relObjectName + ' WHERE Id = \'' + String.valueOf(defaultValue) + '\'');
            if (sos.size() == 1) {
                defaultNameValue = (String)sos[0].get('Name');
            }
        }

        return new Field(fullName, dataType, required, relationshipName, keyName, readOnly, label, scale, picklistValues, defaultValue, defaultNameValue);
    }



    global class FieldDescribe {
        public String properFullName;
        public Schema.DescribeSObjectResult objectDescribe;
        public Schema.DescribeFieldResult fieldDescribe;
        
        global FieldDescribe(String properFullName, Schema.DescribeSObjectResult objectDescribe, Schema.DescribeFieldResult fieldDescribe) {
            this.properFullName = properFullName;
            this.objectDescribe = objectDescribe;
            this.fieldDescribe = fieldDescribe;
        }
    }

    global static FieldDescribe getFieldDescribe(String objectName, String fullName) {
        String properFullName = '';
        String cObject = objectName;
        Schema.DescribeSObjectResult cObjectDescribe = Schema.describeSObjects(new List<String>{cObject})[0];
        Map<String, Schema.SObjectField> cObjectFieldMap = cObjectDescribe.fields.getMap();
    
        String fieldName = fullName;
        while (fieldName.contains('.')) {
            String cRel = fieldName.substringBefore('.');
            fieldName = fieldName.substringAfter('.');

            Boolean fieldFound = false;
            for (String cFieldName : cObjectFieldMap.keySet()) {
                Schema.DescribeFieldResult cFieldDescribe = cObjectFieldMap.get(cFieldName).getDescribe();
                if (cFieldDescribe.getRelationshipName() == cRel) {
                    properFullName += cFieldDescribe.getRelationshipName() + '.';
                    cObjectDescribe = cFieldDescribe.getReferenceTo()[0].getDescribe();
                    cObjectFieldMap = cObjectDescribe.fields.getMap();
                    fieldFound = true;
                    break;
                }
            }

            if (!fieldFound) {
                return null;
            }
        }

        Schema.SObjectField cObjectField = cObjectFieldMap.get(fieldName);
        if (cObjectField == null) {
            return null;
        }

        properFullName += cObjectField.getDescribe().getName();
        return new FieldDescribe(properFullName, cObjectDescribe, cObjectField.getDescribe());
    }



    global class FieldInfo {
        @AuraEnabled public String objectName;
        @AuraEnabled public String objectLabel;
        @AuraEnabled public Field[] fields;
        @AuraEnabled public Field[] requiredFields;
        @AuraEnabled public String keyField;
        @AuraEnabled public String error;

        global FieldInfo(String objectName, String objectLabel, Field[] fields, Field[] requiredFields) {
            this.objectName = objectName;
            this.objectLabel = objectLabel;
            this.fields = fields;
            this.requiredFields = requiredFields;
            this.keyField = 'Id';
        }

        global FieldInfo(String objectName, String objectLabel, Field[] fields, Field[] requiredFields, String keyField) {
            this.objectName = objectName;
            this.objectLabel = objectLabel;
            this.fields = fields;
            this.requiredFields = requiredFields;
            this.keyField = keyField;
        }

        global FieldInfo(String error) {
            this.error = error;
        }
    }

    @AuraEnabled
    global static FieldInfo queryFieldInfo(String objectName, String fieldList, String defaultsJSON) {
        Map<String, Object> defaults = (Map<String, Object>)System.JSON.deserializeUntyped(defaultsJSON);

        Field[] fields = new List<Field>();
        Field[] requiredFields = new List<Field>();
        String[] fieldNames = fieldList.replaceAll(', ', ',').split(',');
        
        for (String fullName : fieldNames) {
            String fieldName = fullName.contains('.') ? fullName.substringAfterLast('.') : fullName;
            FieldDescribe fd = getFieldDescribe(objectName, fullName);
            if (fd == null) {
                return new FieldInfo('Invalid field or relationship ' + fullName + ' for ' + objectName);
            }

            fields.add(getField(fd.properFullName, fd.objectDescribe, fd.fieldDescribe, defaults.get(fieldName)));
        }

        Schema.DescribeSObjectResult objectDescribe = Schema.describeSObjects(new List<String>{objectName})[0];
        Map<String, Schema.SObjectField> objectFieldMap = objectDescribe.fields.getMap();
        for (String fieldName : objectFieldMap.keySet()) {
            Schema.DescribeFieldResult dfr = objectFieldMap.get(fieldName).getDescribe();
            if (isFieldRequired(dfr)) {
                requiredFields.add(getField(dfr.getName(), objectDescribe, dfr, null));
            }
        }
        
        return new FieldInfo(objectDescribe.getName(), objectDescribe.getLabel(), fields, requiredFields);
    }



    global static SObject[] queryRecords(String objectName, FieldInfo fieldInfo, String whereClause, String orderClause, Set<String> keys) {
        Set<String> fieldList = new Set<String>();
        Boolean keyFieldIncluded = false;

        for (Field field : fieldInfo.fields) {
            if (field.dataType != 'Address' && field.dataType != 'Location') {
                fieldList.add(field.name);
                if (field.name.equalsIgnoreCase(fieldInfo.keyField)) {
                    keyFieldIncluded = true;
                }
            }
            if (field.dataType == 'ID' || field.dataType == 'Reference') {
                fieldList.add(field.relationshipName);
            }
        }

        if (!keyFieldIncluded) {
            fieldList.add(fieldInfo.keyField);
        }



        String soql = 'SELECT ' + String.join(new List<String>(fieldList), ',') + ' FROM ' + objectName;
        if (!String.isBlank(whereClause)) {
            soql += ' WHERE ' + whereClause;
        }
        if (!String.isBlank(orderClause)) {
            soql += ' ORDER BY ' + orderClause;
        }

        return Database.query(soql);
    }



    global class FieldError {
        @AuraEnabled public String name;
        @AuraEnabled public String status;
    }

    global class EditorResponse {
        @AuraEnabled public Object[] data;
        @AuraEnabled public String error;
        @AuraEnabled public List<FieldError> fieldErrors;

        global EditorResponse() {}

        global EditorResponse(Object[] data) {
            this.data = data;
        }

        global EditorResponse(String error) {
            this.error = error;
        }

        global EditorResponse(List<FieldError> fieldErrors) {
            this.fieldErrors = fieldErrors;
        }
    }

    @AuraEnabled
    global static EditorResponse processRows(String action, String rowsJSON, String fieldInfoJSON, String objectName, String apexClass) {
        try {
            SalesforceDataTables.FieldInfo fieldInfo = (SalesforceDataTables.FieldInfo)System.JSON.deserialize(fieldInfoJSON, SalesforceDataTables.FieldInfo.class);

            if (!String.isBlank(apexClass)) {
                Type t = Type.forName(apexClass);
                SalesforceDataTablesInterface impl = (SalesforceDataTablesInterface)(t.newInstance());
                Type ot = Type.forName('Map<String, ' + impl.getObjectName() + '>');
                Map<String, Object> rows = (Map<String, Object>)System.JSON.deserialize(rowsJSON, ot);
                return impl.processRows(fieldInfo, action, rows);
            }

            Type ot = Type.forName('Map<String, ' + objectName + '>');
            Map<String, SObject> rows = (Map<String, SObject>)System.JSON.deserialize(rowsJSON, ot);
            SObject[] records = new List<SObject>();
            for (String key : rows.keySet()) {
                SObject record = (SObject)rows.get(key);
                if (action != 'create') {
                    record.put(fieldInfo.keyField, key);
                }
                records.add(record);
            }

            EditorResponse editorResponse;
            if (action == 'create') {
                insert records;

                Set<String> keys = new Set<String>(String.join(new List<Id>(new Map<Id, SObject>(records).keySet()), ',').split(','));
                records = queryRecords(objectName, fieldInfo, fieldInfo.keyField + ' IN :keys', null, keys);

                editorResponse = new EditorResponse((Object[])records);
            }
            if (action == 'edit') {
                update records;

                Set<String> keys = new Set<String>(String.join(new List<Id>(new Map<Id, SObject>(records).keySet()), ',').split(','));
                records = queryRecords(objectName, fieldInfo, fieldInfo.keyField + ' IN :keys', null, keys);

                editorResponse = new EditorResponse((Object[])records);
            }
            if (action == 'remove') {
                delete records;
                editorResponse = new EditorResponse();
            }

            return editorResponse;
        } catch (Exception e) {
            String error = 'Exception caught on line ' + String.valueOf(e.getLineNumber()) + ': ' + e.getMessage() + '\n' +
                           'Stack:\n' + e.getStackTraceString();
            System.debug(error);
            return new EditorResponse(error);
        }
    }

    global class LookupValuesResponse {
        @AuraEnabled public Object[] records;
        @AuraEnabled public String error;

        global LookupValuesResponse(Object[] records) {
            this.records = records;
        }

        global LookupValuesResponse(String error) {
            this.error = error;
        }
    }
    
    @AuraEnabled
    global static LookupValuesResponse queryLookupValues(String objectName, String fieldJSON, String query, String apexClass) {
        try {
            SalesforceDataTables.Field field = (SalesforceDataTables.Field)System.JSON.deserialize(fieldJSON, SalesforceDataTables.Field.class);
            
            if (!String.isBlank(apexClass)) {
                Type t = Type.forName(apexClass);
                SalesforceDataTablesInterface impl = (SalesforceDataTablesInterface)(t.newInstance());
                return impl.queryLookupValues(field, query);
            }

            FieldDescribe fd = getFieldDescribe(objectName, field.relationshipName);
            String qObjectName = fd.objectDescribe.getName();
            String qNameField = fd.fieldDescribe.getName();

            List<SObject> records = Database.query(
                'SELECT Id, ' + qNameField +
                ' FROM ' + qObjectName +
                ' WHERE ' + qNameField + ' LIKE \'%' + query + '%\'' + 
                ' ORDER BY ' + qNameField
            );

            return new LookupValuesResponse((Object[])records);
        } catch (Exception e) {
            String error = 'Exception caught on line ' + String.valueOf(e.getLineNumber()) + ': ' + e.getMessage() + '\n' +
                           'Stack:\n' + e.getStackTraceString();
            System.debug(error);
            return new LookupValuesResponse(error);
        }
    }
    
        

    //////////////////////////////////////////////////////////////



    //
    // Standard Version
    //

    global class StandardResponse {
        @AuraEnabled public FieldInfo fieldInfo;
        @AuraEnabled public Object[] records;
        @AuraEnabled public String error;
        
        global StandardResponse(FieldInfo fieldInfo, Object[] records) {
            this.fieldInfo = fieldInfo;
            this.records = records;
        }

        global StandardResponse(String error) {
            this.error = error;
        }
    }

    @AuraEnabled
    global static StandardResponse getRecordsStandard(String objectName, String fieldList, String whereClause, String apexClass, String defaultsJSON) {
        try {
            if (!String.isBlank(apexClass)) {
                Type t = Type.forName(apexClass);
                SalesforceDataTablesInterface impl = (SalesforceDataTablesInterface)(t.newInstance());
                return impl.getRecordsStandard(whereClause, defaultsJSON);
            }

            FieldInfo fieldInfo = queryFieldInfo(objectName, fieldList, defaultsJSON);
            if (!String.isBlank(fieldInfo.error)) {
                return new StandardResponse(fieldInfo.error);
            }

            SObject[] records = queryRecords(objectName, fieldInfo, whereClause, null, null);

            return new StandardResponse(fieldInfo, (Object[])records);
        } catch (Exception e) {
            String error = 'Exception caught on line ' + String.valueOf(e.getLineNumber()) + ': ' + e.getMessage() + '\n' +
                           'Stack:\n' + e.getStackTraceString();
            System.debug(error);
            return new StandardResponse(error);
        }
    }



    //////////////////////////////////////////////////////////////



    //
    // Enhanced Version
    //

    // Inner classes for a DataTables server-side request
    global class Search {
        public Boolean regex;
        public String value;
    }

    global class Order {
        public Integer column;
        public String dir;
    }

    global class Column {
        public String data;
        public String name;
        public Boolean orderable;
        public Search search;
        public Boolean searchable;
    }

    // The structure for a DataTables server-side request
    global class ServerSideRequest {
        public Integer draw;
        public Integer start;
        public Integer length;
        public Search search;
        public List<Order> order;
        public List<Column> columns;
    }

    // The structure for an Enhanced response
    global class EnhancedResponse {
        @AuraEnabled public Integer draw;
        @AuraEnabled public Integer recordsTotal;
        @AuraEnabled public Integer recordsFiltered;
        @AuraEnabled public Object[] data;
        @AuraEnabled public List<String> allKeys;
        @AuraEnabled public String error;

        global EnhancedResponse(Integer draw, Integer recordsTotal, Integer recordsFiltered, Object[] data, List<String> allKeys) {
            this.draw = draw;
            this.recordsTotal = recordsTotal;
            this.recordsFiltered = recordsFiltered;
            this.data = data;
            this.allKeys = allKeys;
        }

        global EnhancedResponse(String error) {
            this.error = error;
        }
    }

    // The structure for the getIds function response
    global class KeyInfo {
        public Integer recordsTotal;
        public Integer recordsFiltered;
        public List<String> keys;
        public String error;

        global KeyInfo(Integer recordsTotal, Integer recordsFiltered, List<String> keys) {
            this.recordsTotal = recordsTotal;
            this.recordsFiltered = recordsFiltered;
            this.keys = keys;
        }

        global KeyInfo(String error) {
            this.error = error;
        }
    }

    private static KeyInfo getKeys(String objName, String keyField, String orderClause, String[] searches, String globalSearch, String whereClause) {
        try {
            List<String> wheres = new List<String>();
            if (!String.isBlank(whereClause)) {
                wheres.add(whereClause);
            }
            if (searches.size() > 0) {
                wheres.addAll(searches);
            }
            if (!String.isBlank(globalSearch)) {
                wheres.add(globalSearch);
            }

            String soql = 'SELECT ' + keyField +
                          ' FROM ' + objName +
                          (wheres.size() == 0 ? '' : ' WHERE ' + String.join(wheres, ' AND ')) +
                          (String.isBlank(orderClause) ? '' : ' ORDER BY ' + orderClause);
            List<sObject> sObjects = Database.query(soql);
                  
            List<String> keys = new List<String>();
            for (sObject o : sObjects) {
                keys.add(((String)o.get(keyField)).left(15));
            }

            Integer recordsTotal = Database.countQuery('SELECT COUNT() FROM ' + objName + (!String.isBlank(whereClause) ? ' WHERE ' + whereClause : ''));
            Integer recordsFiltered = keys.size();

            return new KeyInfo(recordsTotal, recordsFiltered, keys);
        } catch (Exception e) {
            String error = 'Exception caught on line ' + String.valueOf(e.getLineNumber()) + ': ' + e.getMessage() + '\n' +
                           'Stack:\n' + e.getStackTraceString();
            System.debug(error);
            return new KeyInfo(error);
        }
    }

    private static String[] orderBys(List<Order> orders, List<String> soqlFields) {
        Map<String, String> soqlDirections = new Map<String, String> {
            'asc' => 'asc nulls last',
            'desc' => 'desc nulls first'
        };

        String[] orderBys = new String[] {};
        for (Order order : orders) {
            orderBys.add(soqlFields[order.column] + ' ' + soqlDirections.get(order.dir));
        }
        return orderBys;
    }
    
    private static String[] searchBys(List<Column> columns, List<String> soqlFields) {
        String[] searchBys = new String[] {};
        
        for (Integer i = 0; i < columns.size(); i++) {
            Column column = columns[i];
            if (column.searchable == true) {
                Search search = column.search;
                if (search != null) {
                    Boolean isRegex = search.regex == true;
                    String searchValue = search.value;
                    //ignore regex for now
                    if (!isRegex) {
                        if (!String.isBlank(searchValue)) {
                            searchBys.add(soqlFields[i] + ' LIKE \'%' + searchValue + '%\'');
                        }
                    }
                }
            }
        }

        return searchBys;
    }

    private static String globalSearch(Search search, List<String> soqlFields, Field[] fields) {
        String globalSearch = '';

        if (search != null) {
            String[] searchBys = new String[] {};
            Boolean isRegex = search.regex == true;
            String searchValue = search.value;
            //ignore regex for now
            if (!isRegex) {
                if (!String.isBlank(searchValue)) {
                    Map<String, Field> fieldsMap = new Map<String, Field>();
                    for (Field field : fields) {
                        fieldsMap.put(field.name, field);
                    }

                    for (Integer i = 0; i < soqlFields.size(); i++) {
                        String dataType = fieldsMap.get(soqlFields[i]).dataType;
                        if (dataType == 'String' || dataType == 'Email' || dataType == 'Phone' || dataType == 'Picklist' ||
                            dataType == 'MultiPicklist' || dataType == 'URL' || dataType == 'TextArea' || dataType == 'Reference') {
                            searchBys.add((dataType == 'Reference' ? fieldsMap.get(soqlFields[i]).relationshipName : soqlFields[i]) + ' LIKE \'%' + searchValue + '%\'');
                        }
                    }

                    if (searchBys.size() > 0) {
                        globalSearch = '(' + String.join(searchBys, ' OR ') + ')';
                    }
                }
            }
        }

        return globalSearch;
    }

    @AuraEnabled
    global static EnhancedResponse getRecordsEnhanced(String fieldInfoJSON, String requestJSON, String objectName,
                                                      String soqlFieldsJSON, String apexClass, String whereClause,
                                                      String keysJSON, Integer recordsTotal, Integer recordsFiltered) {
            
        try {
            SalesforceDataTables.FieldInfo fieldInfo = (SalesforceDataTables.FieldInfo)System.JSON.deserialize(fieldInfoJSON, SalesforceDataTables.FieldInfo.class);
            //FieldInfo fieldInfo = new FieldInfo((Map<String, Object>)JSON.deserializeUntyped(fieldInfoJSON));
            SalesforceDataTables.ServerSideRequest request = (SalesforceDataTables.ServerSideRequest)System.JSON.deserialize(requestJSON, SalesforceDataTables.ServerSideRequest.class);
            //ServerSideRequest request = new ServerSideRequest((Map<String, Object>)JSON.deserializeUntyped(requestJSON));
            
            List<String> soqlFields = (List<String>)JSON.deserialize(soqlFieldsJSON, List<String>.class);
            List<String> keysList = (List<String>)JSON.deserialize(keysJSON, List<String>.class);
            Set<String> keys = new Set<String>(keysList);

            if (!String.isBlank(apexClass)) {
                Type t = Type.forName(apexClass);
                SalesforceDataTablesInterface impl = (SalesforceDataTablesInterface)(t.newInstance());
                return impl.getRecordsEnhanced(fieldInfo, request, keys, recordsTotal, recordsFiltered);
            }

            String orderClause = String.join(orderBys(request.order, soqlFields), ', ');

            List<String> allKeys = null;
            if (keys.size() == 0) {
                KeyInfo keyInfo = getKeys(objectName, fieldInfo.keyField, orderClause, searchBys(request.columns, soqlFields),
                                          globalSearch(request.search, soqlFields, fieldInfo.fields), whereClause);
                if (!String.isBlank(keyInfo.error)) {
                    return new EnhancedResponse(keyInfo.error);
                }

                allKeys = keyInfo.keys;
                keys = new Set<String>();
                for (Integer i = request.start ; i < Math.min(request.start + request.length, allKeys.size()) ; i++) {
                    keys.add(allKeys.get(i));
                }
                recordsTotal = keyInfo.recordsTotal;
                recordsFiltered = keyInfo.recordsFiltered;
            }

            SObject[] records = queryRecords(objectName, fieldInfo, fieldInfo.keyField + ' IN :keys', orderClause, keys);
            Object[] data = (Object[])records;

            return new EnhancedResponse(request.draw, recordsTotal, recordsFiltered, data, allKeys);
        } catch (Exception e) {
            String error = 'Exception caught on line ' + String.valueOf(e.getLineNumber()) + ': ' + e.getMessage() + '\n' +
                           'Stack:\n' + e.getStackTraceString();
            System.debug(error);
            return new EnhancedResponse(error);
        }
    }
     
}