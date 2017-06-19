/*
* @auther : Cloud Sherpas Inc.
* @date : 07/09/2014
* @description : Apex class for mohcdMyHouseApps VF Page
*/ 
public with sharing class CS_MOHCDMyHouseAppsCC {
    
    //Public Variables
    public List<Housing_Application__c> lMyHousingApps {get; set;}   
    
    //Constructor   
    public CS_MOHCDMyHouseAppsCC() {
        lMyHousingApps = new List<Housing_Application__c>();
        lMyHousingApps = [SELECT Id, Name, Property_of_Interest__c, Property_of_Interest__r.Name, Application_Status__c,
            Lottery_Number__c, Lottery_Rank__c, Property_Address__c
            FROM Housing_Application__c WHERE OwnerId =: Userinfo.getUserId()];
    }
}