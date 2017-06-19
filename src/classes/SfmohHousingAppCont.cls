public with sharing class SfmohHousingAppCont {

    private final Housing_Application__c mysObject;
    public List<Housing_Application__c> housingApp {get; set;}

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public SfmohHousingAppCont(ApexPages.StandardController stdController) {
        this.mysObject = (Housing_Application__c)stdController.getRecord();
    }

    public String getRecordName() {
        return 'Hello ' + (String)mysObject.get('name') + ' (' + (Id)mysObject.get('Id') + ')';
    }

    public PageReference addRow(){

        return null;

    }
}