/*
* @author : Cloud Sherpas Inc.
* @date : 09/17/2014
* @description : Apex class for CS_MOHCDHousingAppCC container
*/ 
public class CS_MOHCDHousingAppCCContainer{
    public Housing_Application_Member__c memberInstance {get; set;}
    public Housing_Application_Income__c memberIncomeInstance {get; set;}
    public Housing_Application_Asset__c memberAssetInstance {get; set;}
    
    public String errorMessage {get; set;}
    public Boolean error {get; set;}

    public CS_MOHCDHousingAppCCContainer(){
        memberIncomeInstance = new Housing_Application_Income__c();
    }
}