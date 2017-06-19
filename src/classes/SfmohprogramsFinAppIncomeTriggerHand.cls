public with sharing class SfmohprogramsFinAppIncomeTriggerHand {
	public SfmohprogramsFinAppIncomeTriggerHand() {
		
	}

	public static void PrePopulateFinancialApp(List<Financial_Application_Income__c> finAppIncome){
        Financial_Application_Member__c memId = new Financial_Application_Member__c();
        
        for(Financial_Application_Income__c finIncome : finAppIncome){
            memId.Id = finIncome.Financial_Application_Member__c;
        }

        Financial_Application_Member__c fAppId = [SELECT Financial_Application__c FROM Financial_Application_Member__c WHERE Id =:memId.Id];
        
        Financial_Application__c fApp = [SELECT Id, Name FROM Financial_Application__c WHERE Id =: fAppId.Financial_Application__c];


        for(Financial_Application_Income__c finIncome : finAppIncome){
            finIncome.Financial_Application__c = fApp.Id;
        }
        
    }
}