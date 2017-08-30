public with sharing class SfmohprogramsHousingAppAssetTriggerHand{

    public void beforeInsert(List<Housing_Application_Asset__c> pHappAsset) {

        Housing_Application_Member__c memId = new Housing_Application_Member__c();
        
        for(Housing_Application_Asset__c pha : pHappAsset){
            memId.Id = pha.Housing_Application_Member__c;
        }

        Housing_Application_Member__c hAppId = [SELECT Housing_Application__c FROM Housing_Application_Member__c WHERE Id =:memId.Id];
        
        Housing_Application__c hApp = [SELECT Id, Name FROM Housing_Application__c WHERE Id =: hAppId.Housing_Application__c];


        for(Housing_Application_Asset__c pha : pHappAsset){
            pha.Housing_Application__c = hApp.Id;
        }

    }

}