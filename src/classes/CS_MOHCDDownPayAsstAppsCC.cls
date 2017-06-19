/**
 * @author:      Sumit Shingavi
 * @date:        07/16/2014
 * @description: Apex class for mohcdDownPayAsstApps VF Page
 * @history:     06/10/2015 - Heidi Tang - Edited
*/ 
public class CS_MOHCDDownPayAsstAppsCC {

    //Public Variables
    public List<Financial_Application__c> financialAppWrapper{get; set;}
    
    public CS_MOHCDDownPayAsstAppsCC() {
        User usr = [SELECT Id,Name, ContactId, Contact.AccountId FROM User WHERE Id =: Userinfo.getUserId()];
        
        financialAppWrapper = new List<Financial_Application__c>();
        
        List<Financial_Application__c> lMyFinancialAppsSetter = new List<Financial_Application__c>([SELECT Id,RecordTypeId, RecordType.Name,Property_Address__c, Name,Lender_Mortgage_Broker_Company_Name__c,Application_Status__c,Loan_Officer__c,Loan_Officer__r.Name FROM Financial_Application__c WHERE Household_Account__c =: usr.Contact.AccountId ]);
            
        for(Financial_Application__c lMyFinancialApp :lMyFinancialAppsSetter){
            financialAppWrapper.add(lMyFinancialApp);
        }
    }
}