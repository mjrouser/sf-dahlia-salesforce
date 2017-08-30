public with sharing class UnitTriggerHandler {
    /*
	 * Handle on before insert events
	 */
	public void onBeforeInsert(List<Unit__c> newUnits) {
		handleOnBeforeInsertEvent(newUnits);
	}
	
	public void handleOnBeforeInsertEvent(List<Unit__c> newUnits) {
		Decimal maxAmiYear = [select Year__c from AMI_Chart__mdt order by Year__c desc limit 1].Year__c;
		for (Unit__c unit : newUnits) {
			unit.AMI_chart_type__c = 'HUD Unadjusted';
			unit.AMI_chart_year__c = maxAmiYear;
		}
	}
}