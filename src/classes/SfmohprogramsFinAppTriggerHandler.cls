public with sharing class SfmohprogramsFinAppTriggerHandler {

    SfmohprogramsFinAppTriggerHelper helper = new SfmohprogramsFinAppTriggerHelper();  

    public void beforeInsert(List<Financial_Application__c> finApp) {
        helper.populateFields(finApp);
    }

    public void afterInsert(List<Financial_Application__c> finApp) {
        helper.createMemAssetIncome(finApp);
    }

}