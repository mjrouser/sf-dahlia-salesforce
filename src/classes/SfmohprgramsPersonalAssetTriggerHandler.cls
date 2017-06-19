public with sharing class SfmohprgramsPersonalAssetTriggerHandler {

    public void beforeInsert(List<Personal_Asset__c> pAsset) {

        Contact contId = new Contact();
        
        for(Personal_Asset__c pa : pAsset){
            contId.Id = pa.Household_Member__c;
        }

        Contact accId = [SELECT AccountId FROM Contact WHERE Id =:contId.Id];
        
        for(Personal_Asset__c pa : pAsset){
            pa.Household_Account__c = accId.AccountId;
        }

    }
}