// *****************************************************************************
// CLASS: RollUpSummaryAction
// *****************************************************************************
//
// Author: Vertiba/Luke - Nish
// Date: 13-06-2017
// Description: Generic class to calculate rollup.
// *****************************************************************************
// MODIFICATIONS:  NOTE MOD#, DATE of mod, who made the change and description
// *****************************************************************************
// 
// *****************************************************************************

public class RollUpSummaryAction extends TriggerAction {
    
    static map<ID,Sobject> shouldIUpdate = new map<ID,Sobject>();
  	static String shouldIUpdateObj; 
    Map<ID,Sobject> currentMap = new map<ID,Sobject>();
    private Set<ID> groupByIDs;
    
         
    /*
    	for rollup - 
    	if "parent id" needs to be recalculated - this is true when counted field is changed / inserted or deleted
    		
    		query all related records by parent id
    		set count on parent record.
    		ex: count number of contacts on account  - set account.contactCount - 
    		
    */     
   	String objToQuery; //this is the sObject type of the child object type i.e. of the object thats being counted
    String objToUpdate; 
    String fieldCounted;
    String fieldToUpdate;
    String groupByID; // in rollup the parentID = groupByID 
    String filterBy;  // Filter query by filterBy field.
    
    String sObjectype;  // this should equal object to query - 
    
 //  String objToQuery;
 
 /*
 AggregateResult[] totalSubmittedAppResults = [SELECT  a.application__c, COUNT(a.id)count FROM Application_Preference__c a where a.application_c in :applicationIDS and Receives_Preference__c =true GROUP BY a.application_c ];  

 
 */
	public class InvalidRollupConfigurationException extends Exception {}
	Set<ID> parentIDs;
	
	public RollUpSummaryAction (List<SObject> triggerList, String objToQuery, String objToUpdate, String fieldCounted, String fieldToUpdate, String groupById, String filterBy) {
 		super(triggerList);

 		this.objToQuery= objToQuery;
 		this.fieldToUpdate = fieldToUpdate;
 		this.objToUpdate = objToUpdate;
 		this.fieldCounted = fieldCounted;
 		this.groupById = groupById;
 		this.filterBy = filterBy;
 	/*
 		sObjectype = String.valueOf(sobj[0].getSObjectType());
		if (sObjectype!=objToQuery ) {
			throw new InvalidRollupConfigurationException(); //put message in  -  blah blah.
		}*/
		 
    }
    
    public RollUpSummaryAction (Map<Id,SObject> triggerNewMap, Map<Id,SObject> triggerOldMap,String objToQuery, String objToUpdate, String fieldCounted, String fieldToUpdate, String groupById, String filterBy) {
 		super(triggerNewMap,triggerOldMap);

 		this.objToQuery= objToQuery;
 		this.fieldToUpdate = fieldToUpdate;
 		this.objToUpdate = objToUpdate;
 		this.fieldCounted = fieldCounted;
 		this.groupById = groupById;
 		this.filterBy = filterBy;
 	/*
 		sObjectype = String.valueOf(sobj[0].getSObjectType());
		if (sObjectype!=objToQuery ) {
			throw new InvalidRollupConfigurationException(); //put message in  -  blah blah.
		}
		*/
    }
     
    public override boolean shouldRunOnInsert() {
    	parentIDs = new Set<ID>();
		
 		for (Sobject sobj: triggerList) {
			ID parentID = (ID)sobj.get(groupByID);
			if (parentID!=null) {
				parentIDs.add(parentID);
			}
 		}
        if (parentIDs.size()>0) {
        	
            return true;        
        }
        else return false;
        
    }
    public override boolean shouldRunOnDelete() { 
        parentIDs = new Set<ID>();
 		for (Sobject sobj: triggerList) {
			ID parentID = (ID)sobj.get(groupByID);
			if (parentID!=null) {
				parentIDs.add(parentID);
			}
 		}
 		
 		
        if (parentIDs.size()>0) {
            return true;        
        }
        else return false;
    
    } 
    public override boolean shouldRunOnUpdate() {
        parentIDs = new Set<ID>();

	    for (ID theID: triggerNewMap.keyset()) {
	    	SObject newObj = triggerNewMap.get(theID);
	    	SObject oldObj = triggerOldMap.get(theID);
			ID newParentID = (ID)newObj.get(groupByID);
			ID oldParentID = (ID)oldobj.get(groupByID);
			if (newParentID!=oldParentID) {
				if (newParentID!=null) {
					parentIDs.add(newParentID);
				}
				if (oldParentID!=null) {
					parentIDs.add(oldParentID);
				} 
				// its far more likely that a relationship was added or removed 
				//rather then reparented but we take both scenarios into conideration
				continue;
			}
			//if the calculating clause changes then recalculate - this needs to be improved upon
			if (newObj.get(filterBy)!=oldObj.get(filterBy)){
				if (newParentID!=null) {
					parentIDs.add(newParentID);
				}
			}
	 
	    }
    
    	
        if (parentIDs.size()>0) {
            return true;        
        }
        else return false;
        
    } 
    
    
    public static List<Sobject> obtainChildList(Map<Id,SObject> triggNewMap, Map<Id,SObject> triggOldMap, String objectToQuery, String groupById, String filterByParentObject, String filterByParentField) {
        List<Id> objList = new List<Id>();
        List<Sobject> childList = new List<Sobject>();
        for(Id objId : triggNewMap.keySet()) {
            if( triggNewMap.get(objId).get(filterByParentField) != triggOldMap.get(objId).get(filterByParentField))
                objList.add(objId);
                }
        if(objList.size()>0) {
        String query = 'SELECT ID, ' + groupById + ' FROM ' + objectToQuery + ' WHERE ' + filterByParentObject + ' IN :objList';
        System.debug('query-------------- ' + query);
        childList = Database.query(query);
        System.debug('ChildList-------------- ' + ChildList);
        }
        return childList;
       
    }
    
    
    /*
    	for rollup - 
    	if "parent id" needs to be recalculated - this is true when counted field is changed / inserted or deleted
    		
    		query all related records by parent id
    		set count on parent record.
    		ex: count number of contacts on account  - set account.contactCount - 
    		
    */
    
    
    public Map<ID,SObject> getCurrentRecordState() {
    	List<ID> parentIDList = new List<ID>(parentIDs); 
    	Schema.SObjectType parentType = parentIDList[0].getSobjectType();
    	Schema.DescribeSObjectResult r = parentType.getDescribe();
    	STring objName  = r.getName();
    	String query = 'SELECT id,' + fieldToUpdate +'  FROM ' + objName + ' WHERE id IN :parentIDS';
       
        System.debug(query);
        
        List<SObject> objects = Database.query(query);
       return new  Map<ID,SObject>(objects);
        
    }
    public override void doAction() {
    	
    	system.debug(parentIDS);
    	
        String query = 'SELECT ' + groupById + ', Count(' + fieldCounted + ')genCount FROM ' + objToQuery + ' WHERE ' + groupById + ' IN :parentIDS';
        query+=(filterBy!=null) ? ' and '  + filterBy + ' = true' : ''; // filterBy = ('submitted = true or = false')
        query+=  ' GROUP BY '+ groupById +' '; 
        
     	Map<ID,SObject> updateMap = new  Map<ID,SObject>();
        AggregateResult[] aggregateResults = Database.query(query);
   		Map<ID,SObject> currentStateMap  = getCurrentRecordState();
   		system.debug ('currentStateMap'  + currentStateMap);
        for (AggregateResult result: aggregateResults) {  
        	system.debug('result ' + result)  ;
            ID parentID = (ID)result.get(groupById);
            Integer count = (Integer)result.get('genCount');
       		Schema.SObjectType parentType = parentID.getSobjectType();
          /*
            Sobject obj = parentType.newSObject(parentID);
            obj.put(fieldToUpdate, count);
           */
            Sobject obj  = currentStateMap.get(parentID);
            obj.put(fieldToUpdate, count);
            currentStateMap.remove(parentID);
            updateMap.put(obj.id,obj);
        }
         // apparantely aggregrate queries do not return a row if the count is zero so we reset the current state value to zero
        for ( ID id:currentStateMap.keyset()) {
        
            Sobject obj  = currentStateMap.get(id);
            obj.put(fieldToUpdate, 0);
        	 updateMap.put(obj.id,obj);
        	
        }
        
        if (updateMap.keyset().size()>0) {
			update updateMap.values();
		}
		
		
   
    }
    
    public static void runHandler(String objToUpdate, String fieldToUpdate, String objectToQuery, String groupById, String fieldCounted, String filterBy) {
        if (trigger.isAfter && trigger.isInsert) {

            RollUpSummaryAction action = new RollUpSummaryAction(trigger.new, objectToQuery,objToUpdate,fieldCounted,fieldToUpdate,groupById,filterBy);
            if (action.shouldRunOnInsert())  
            	action.doAction(); 
            return;
        }
        if (trigger.isAfter && trigger.isUpdate) {
            RollUpSummaryAction action = new RollUpSummaryAction(trigger.newMap, trigger.oldMap, objectToQuery,objToUpdate,fieldCounted,fieldToUpdate,groupById,filterBy);
            if (action.shouldRunOnUpdate())  
            	action.doAction(); 
            return;
        }
        
        if (trigger.isAfter && (trigger.isDelete)){ 
            RollUpSummaryAction action = new RollUpSummaryAction(Trigger.old, objectToQuery, objToUpdate,fieldCounted, fieldToUpdate,groupById,filterBy);
			if (action.shouldRunOnDelete())  
			     action.doAction(); 
            return;
            
        }
        
       
    }
    
    /////////////////// Called from Application Trigger to change Listing Preference submitted apps ////////////////////////////
    public static void runHandler(String objToUpdate, String fieldToUpdate, String objectToQuery, String groupById, String fieldCounted, String filterBy, String filterByParentObject, String filterByParentField) {
       // filterByParentObject - Formula fielded parent.
       // filterByParentField - The formula field.
       
        List<Sobject> triggerList = obtainChildList(trigger.newMap, trigger.oldMap, objectToQuery, groupById, filterByParentObject, filterByParentField);
        if(triggerList.size()>0) {
        RollUpSummaryAction action = new RollUpSummaryAction(triggerList, objectToQuery,objToUpdate,fieldCounted,fieldToUpdate,groupById,filterBy);
            
        if (action.shouldRunOnInsert())  
            	action.doAction(); 
        }
            return; 
        
    }
    
}