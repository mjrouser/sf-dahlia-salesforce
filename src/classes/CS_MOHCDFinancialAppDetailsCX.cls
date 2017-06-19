/**
 * @author:      Sumit Shingavi
 * @date:        07/21/2014
 * @description: Apex class for mohcdFinancialAppDetails
 * @history:     06/10/2015 - Heidi Tang - Edited
*/ 
public class CS_MOHCDFinancialAppDetailsCX {
    
    public Financial_Application__c faInstance {get; set;}
    public Financial_Application_Member__c borrower {get; set;}
    
    public CS_MOHCDFinancialAppDetailsCX(ApexPages.StandardController controller) {
        faInstance = (Financial_Application__c) controller.getRecord();
        
        faInstance = [Select Id, Name, Application_Status__c, 
        Lender_Mortgage_Broker_Company_Name__c, Lender_Branch_Address__c,
        Loan_Officer__r.Name, Loan_Officer__r.Title, Loan_Officer__r.Work_Phone__c,
        Loan_Officer__r.Email, Loan_Officer__r.Fax,
        Property_Address__c, of_Bathrooms__c, of_Bedrooms__c, Development_Name__c,
        Has_Borrower_or_co_borrowers_owned_prop__c, Bankrupty_Declaration_Explanation__c,
        Has_anyone_declared_bankruptcy_last_7yr__c, Outstanding_Judgement_Explanation__c,
        Oustanding_judgements_against_borrowers__c, Borrowers_move_in_60_days_post_closing__c,
        
        Purchase_Price__c, Estimated_Closing_Costs__c, Estimated_Prepaid_Escrow__c, 
        Total_Costs__c, Amount_of_First_Mortgage__c, Ratio_First_Mortgage_Purchase_Price__c,
        Loan_Term_of_1st_Mortgage_Years__c, Interest_Rate__c,
        
        (Select Email_Address__c, First_Name__c, Full_Address__c, Home_Phone__c, 
            Last_Name__c, Occupation__c, Race_Ethnicity_optional__c, Work_Phone__c, 
            Borrower_Role__c, Relationship_to_Head_of_Household__c
            From Financial_Application_Members1__r), 
            
        (Select Id, Name, RecordType.Name, Employer_Name__c,  Annual_Income_Amount__c 
            From Financial_Application_Incomes__r), 
        
        (Select Id, Name, Asset_Type__c, RecordType.Name, Current_Cash_Value_of_Gift__c, Name_of_Institution__c, 
            Retirement_Asset_Type__c From Financial_Application_Assets__r),
        
        (Select Id, Title, Body From Notes WHERE isPrivate = false)
         
        From Financial_Application__c
        WHERE Id =: faInstance.Id LIMIT 1];
        
        borrower = new Financial_Application_Member__c();
        
        for(Financial_Application_Member__c fam : faInstance.Financial_Application_Members1__r) {
            if(fam.Borrower_Role__c == 'Primary Borrower') {
                borrower = fam;
                break;
            } 
        }
        System.debug(LoggingLevel.INFO, '==borrower=='+borrower);
    }
}