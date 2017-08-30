global class deleteFlaggedRecordSet implements Database.Batchable<sObject>{
    String query;
    List<Id> idList;
	
    global deleteFlaggedRecordSet(List<Id> idList) {
    	System.debug(idList);
        this.idList = idList;
    	query = 'Select id from Flagged_Application__c Where DuplicateRecordItem__c IN :idList';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    	return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Flagged_Record_Set__c> scope) { 
       Database.delete(scope);
		System.debug(scope); 

		
	}
	
	global void finish(Database.BatchableContext BC) {
        System.debug('Completed');
	}
}