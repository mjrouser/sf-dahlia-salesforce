public with sharing class SfmohprogramsHousingAppIncomeTriggerHand {
	
    public void beforeInsert(List<Housing_Application_Income__c> pHappIncome){
        Housing_Application_Member__c memId = new Housing_Application_Member__c();
        
        for(Housing_Application_Income__c phi : pHappIncome){
            memId.Id = phi.Housing_Application_Member__c;
        }

        Housing_Application_Member__c hAppId = [SELECT Housing_Application__c FROM Housing_Application_Member__c WHERE Id =:memId.Id];
        
        Housing_Application__c hApp = [SELECT Id, Name FROM Housing_Application__c WHERE Id =: hAppId.Housing_Application__c];


        for(Housing_Application_Income__c phi : pHappIncome){
            phi.Housing_Application__c = hApp.Id;
        }
        
    }
    
}