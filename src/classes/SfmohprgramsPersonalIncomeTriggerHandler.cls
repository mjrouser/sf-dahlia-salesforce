public with sharing class SfmohprgramsPersonalIncomeTriggerHandler {
    
    public void beforeInsert(List<Personal_Income__c> pIncome) {

        Contact contId = new Contact();
        
        for(Personal_Income__c pi : pIncome){
            contId.Id = pi.Household_Member__c;
        }

        List<Contact> accId = new List<Contact>([SELECT AccountId FROM Contact WHERE Id =:contId.Id LIMIT 1]);
        
        for(Personal_Income__c pi : pIncome){
            if(accId.size()>0){
                pi.Household_Account__c = accId[0].AccountId;
            }
        }

    }
}