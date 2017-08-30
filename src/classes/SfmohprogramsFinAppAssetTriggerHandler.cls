public with sharing class SfmohprogramsFinAppAssetTriggerHandler{

    public void beforeInsert(List<Financial_Application_Asset__c> finAppAsset) {

        Financial_Application_Member__c memId = new Financial_Application_Member__c();
        
        for(Financial_Application_Asset__c finAsset : finAppAsset){
            memId.Id = finAsset.Financial_Application_Member__c;
        }

        Financial_Application_Member__c fAppId = [SELECT Financial_Application__c FROM Financial_Application_Member__c WHERE Id =:memId.Id];
        
        Financial_Application__c fApp = [SELECT Id, Name FROM Financial_Application__c WHERE Id =: fAppId.Financial_Application__c];


        for(Financial_Application_Asset__c finAsset : finAppAsset){
            finAsset.Financial_Application__c = fApp.Id;
        }

    }

}