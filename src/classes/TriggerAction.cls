public abstract class TriggerAction {

	protected String className;
    protected List<Sobject> triggerList;
    protected Map<ID,SObject> triggerMap;
    
    protected Map<ID,SObject> triggerNewMap;
    protected Map<ID,SObject> triggerOldMap;
 
 /*
    protected TriggerAction() {
    	this.className = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    	setDisabled();
    }
    
    public Boolean disabled;
    
    private void setDisabled() {
    	Trigger_Settings__c ts = Trigger_Settings__c.getInstance(this.className);
    	if (ts == null) {
    		disabled = false;
    	} else {
    		disabled = ts.Disabled__c;
    	}
    }*/
 
    /**
    Before Trigger insert uses this
    **/
    //could be trigger new or old
    protected TriggerAction(List<Sobject> Triggerlist) {
    //	this();
        this.triggerList = triggerList;
    }
    /**
        After trigger insert uses this
    **/
    protected TriggerAction(Map<ID,SObject> triggerMap) {
    	//this();
        this.triggerMap = triggerMap;
    }
    /**
    Update triggers use this
    **/
    protected TriggerAction(Map<ID,SObject> triggerNewMap,Map<ID,SObject> triggerOldMap) {
    //	this();
        this.triggerNewMap = triggerNewMap;
        this.triggerOldMap = triggerOldMap;
    }
    
    public abstract boolean shouldRunOnInsert() ;
        
    public abstract boolean shouldRunOnDelete() ;
    
    public abstract boolean shouldRunOnUpdate();
    
    public abstract void doAction();
    
    
}