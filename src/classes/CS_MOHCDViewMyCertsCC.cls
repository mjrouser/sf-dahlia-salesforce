/*
* @auther : Cloud Sherpas Inc.
* @date : 07/15/2014
* @description : Apex class for mohcdViewMyCerts VF Page
*/ 
public with sharing class CS_MOHCDViewMyCertsCC {
    
    //Public Variables
    public List<Certificate_Program__c> lMyCertificatePrograms {get; set;}   
    
    //Constructor   
    public CS_MOHCDViewMyCertsCC() {
        lMyCertificatePrograms = new List<Certificate_Program__c>();
        
        User usr = [SELECT ID, Name, ContactId, Contact.AccountId FROM USer WHERE Id =: Userinfo.getUserId() LIMIT 1];
        
        lMyCertificatePrograms = [SELECT RecordTypeId, RecordType.Name, Household_Account__c,         
            Submit_Date__c, Name, Id, Application_Status__c, Household_Contact__c 
            FROM Certificate_Program__c 
            WHERE Household_Account__c =: usr.Contact.AccountId 
            AND Household_Contact__c =: usr.ContactId];
    }
}