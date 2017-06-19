/**
 * @author:      Kingsley Tumaneng
 * @date:        04/09/2015
 * @description: Trigger for Contacts.
 * @history:     06/09/2015 - Heidi Tang - Edited
 */
 trigger SfmohprgramsContactTrigger on Contact (after update) {

    SfmohprgramsContactTriggerHandler handler = new SfmohprgramsContactTriggerHandler();

    if(trigger.isAfter && trigger.isUpdate){
        handler.afterUpdate(Trigger.new);
    }
}