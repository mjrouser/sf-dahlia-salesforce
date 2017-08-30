trigger UnitTrigger on Unit__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    UnitTriggerHandler handler = new UnitTriggerHandler();
    
    /*Before Insert*/
    if(Trigger.isInsert && Trigger.isBefore)
    {
    	handler.onBeforeInsert(Trigger.new);
    }
    /*After Insert*/
    if(Trigger.isInsert && Trigger.isAfter)
    {
        //handler.onBeforeInsert(Trigger.newMap, Trigger.oldMap, Trigger.isInsert,Trigger.isUpdate);
    }
    /*Before Update*/
    else if(Trigger.isUpdate && Trigger.isBefore)
    {
    }
    /*After Update*/
    if(Trigger.isUpdate && Trigger.isAfter)
    {
        //handler.handleOnAfterUpdateEvent(Trigger.newMap, Trigger.oldMap, Trigger.isInsert,Trigger.isUpdate);
    }
    /*Before Delete*/
    else if(Trigger.isDelete && Trigger.isBefore)
    {
    }
    /*After Delete*/
    else if(Trigger.isDelete && Trigger.isAfter)
    {
    }
    /*After Undelete*/
    else if(Trigger.isUnDelete)
    {
    }
}