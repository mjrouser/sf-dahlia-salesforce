global class zMigrationBatch implements Database.Batchable<sObject>, Database.Stateful {
    String query;
	Set<Id> listingIds;
	Date startDate;
	Date endDate;
    List<Application__c> appsToUpdate;
    
    // Count the number of applications processed
    Integer count;
	
    global zMigrationBatch(Set<Id> listingIds, Date startDate, Date endDate) {
    	this.listingIds = listingIds;
    	this.startDate = startDate;
    	this.endDate = endDate;
        
        count = 0;
        appsToUpdate = new List<Application__c>();
        
		
		if (listingIds == null || listingIds.size() == 0) {
			Map<ID,Listing__c> allListingMap = new Map<ID,Listing__c>([SELECT Id FROM Listing__c WHERE Lottery_Status__c = 'Lottery Complete']);
			listingIds = allListingMap.keySet();
		}
		

	
    	
    	query = 'Select id, Listing__c,DTHP_Preference_Member__c,DTHP_Preference_Manual__c,DTHP_Preference_Rank__c, Is_Migrated__c,';
		query += 'DTHP_Opt_Out__c,DTHP_Preference__c,Neighborhood_Preference_Member__c,Neighborhood_Preference_Manual__c,';
		query += 'Neighborhood_Preference_Rank__c,NRHP_Opt_Out__c,Neighborhood_Preference_Proof__c,Neighborhood_Preference__c,';
		query += 'Neighborhood_Preference_Address__c,COP_Preference_Member__c,COP_Preference_Manual__c,COP_Preference_Rank__c,';
		query += 'COP_Opt_Out__c,COP_Preference__c,Live_in_SF_Preference_Member__c,Live_Work_Preference_Paper__c, Work_in_SF_Preference_Proof__c, Work_in_SF_Preference_Member__c, ';
		query += 'Live_Work_Preference_Rank__c,Live_Work_Opt_Out__c,Live_in_SF_Preference_Proof__c,Live_Work_Preference__c ';
		query += 'From Application__c where Listing__c in :listingIds AND Listing__r.Lottery_Status__c = \'Lottery Complete\'';
		if (startDate != null) {
			query += ' AND CreatedDate >= :startDate';
		}
		if (endDate != null) {
			query += ' AND CreatedDate <= :endDate';
		}
		system.debug('query:::' + query);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    	return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Application__c> scope) {
		system.debug('scope:::' + scope);
        List<Application__c> migrationAppList = new List<Application__c>();
        
        for(Application__c app : scope)
            if(app.Is_Migrated__c == false) {
            	migrationAppList.add(app);
                
                app.Is_Migrated__c = true;
                appsToUpdate.add(app);
            }
        
        count += migrationAppList.size();
        zMigrationScript.createApplicationPreference(migrationAppList);
        
        //Update the migrated field on apps
        update appsToUpdate; 
        
	}
	
	global void finish(Database.BatchableContext BC) {
        

        
       // Send a mail after the applications have been processed 
       List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
       Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
       List<String> toAddress = new List<String>();
       toAddress.add('donna.nguyen@vertiba.com');
        toAddress.add('nishchith.hebbar@vertiba.com');
       email.setToAddresses(toAddress);
       email.setSubject('Migration complete');
       email.setHtmlBody('The migration script has run successfully. ' + count + ' Application(s) have been processed.');
       emails.add(email);
       Messaging.sendEmail(emails);
        
	}
}