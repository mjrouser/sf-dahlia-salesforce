/**
 * @author:      Kimiko Roberto
 * @date:        06/05/2014
 * @description: Trigger for Housing Application Assets.
 * @history:     06/09/2015 - Heidi Tang - Edited
 */
trigger SfmohprogramsHousingAppAssetTrigger on Housing_Application_Asset__c (before insert) {

	SfmohprogramsHousingAppAssetTriggerHand handler = new SfmohprogramsHousingAppAssetTriggerHand();

    if(trigger.isBefore && trigger.isInsert){
        handler.beforeInsert(Trigger.new);
    }
}