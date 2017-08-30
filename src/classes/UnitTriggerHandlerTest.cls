@isTest
public with sharing class UnitTriggerHandlerTest {
    
    public static testmethod void testInsertUnit() {
    	Development__c dev = new Development__c(Name_of_Development__c = 'Test');
    	dev.Project_ID__c = '123';
        insert dev;
    	
    	Building__c building = new Building__c(Development__c = dev.Id);
    	insert building;
    	
    	test.startTest();
    	Unit__c unit = new Unit__c(Property__c = building.Id);
    	insert unit;
    	Decimal maxAmiYear = [select Year__c from AMI_Chart__mdt order by Year__c desc limit 1].Year__c;
    	
    	unit = [SELECT Id, AMI_chart_type__c, AMI_chart_year__c FROM Unit__c WHERE Id = :unit.Id];
    	system.assert(unit.AMI_chart_year__c == maxAmiYear);
    	system.assert(unit.AMI_chart_type__c == 'HUD Unadjusted');
    	
    	test.stopTest();
    }
}