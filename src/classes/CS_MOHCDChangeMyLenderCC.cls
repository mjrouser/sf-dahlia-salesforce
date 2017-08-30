/**
 * @author:      Sumit Shingavi
 * @date:        07/18/2014
 * @description: Apex class for mohcdChangeMyLender VF Page
 * @history:     06/10/2015 - Heidi Tang - Edited
*/
public class CS_MOHCDChangeMyLenderCC {
    
    //Public Variables    
    public List<FinancialApplicationWrapper> lFinancialAppWraps {get; set;}
    public Contact conLender {get; set;}
    public Boolean bIsSubmitted {get; set;}
    public User usr {get;set;}
    public User loanUser {get;set;}
    
    //Constructor   
    public CS_MOHCDChangeMyLenderCC() {
        conLender = new Contact();
        usr = new User();
        loanUser = new User();
        
        bIsSubmitted = false;
        init();        
    }
    
    private void init() {
        
        lFinancialAppWraps = new List<FinancialApplicationWrapper>();
        
        String lenderId = System.currentPageReference().getParameters().get(StringConstants.PARAM_LENDER);
        if(!String.isBlank(lenderId)) {
            conLender = [SELECT Id, Name, Work_Phone__c, Email, FirstName, 
                LastName, MailingStreet, MailingCity, MailingState, MailingCountry, 
                MailingPostalCode, AccountId, Account.Name, BMR_Certified__c, 
                DALP_Certified__c, MCC_Certified__c
                FROM Contact WHERE Id =: lenderId LIMIT 1];
                
            loanUser = [SELECT Id FROM User WHERE ContactId = :conLender.Id];
            
            usr = [SELECT ID, Name, ContactId, Contact.AccountId FROM User WHERE Id =: Userinfo.getUserId() LIMIT 1];
            
            List<Financial_Application__c> lMyFinancialApps = [SELECT RecordTypeId, RecordType.Name, Property_Address__c,OwnerId, 
            Name, Loan_Officer__r.FirstName, Loan_Officer__r.LastName, 
            Loan_Officer__c, Lender_Mortgage_Broker_Company_Name__c, Id,
            Application_Status__c,Housing_Application__c 
            FROM Financial_Application__c 
            WHERE Household_Account__c =: usr.Contact.AccountId
            AND (Loan_Officer__c!= :lenderId)];   
          
            
            for(Financial_Application__c fa : lMyFinancialApps) {
                lFinancialAppWraps.add(new FinancialApplicationWrapper(false, fa));
            }
        }          
    }
    
     public PageReference ChangeMyLender() {
        
        try {
            //Configure object to be inserted
            if(conLender == null || conLender.Id == null) {                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ' Please select a lender'));
                return null;
            }

            List<Financial_Application__c> lUpdatedFinancialApp = new List<Financial_Application__c>();
            
            for(FinancialApplicationWrapper faWrap : lFinancialAppWraps) {
                if(faWrap.isSelected) {
                    lUpdatedFinancialApp.add(faWrap.fa);
                }
            }
            
            List<Note> lNotes = new List<Note>();
                 
            for(Financial_Application__c fa : lUpdatedFinancialApp) {
                fa.Loan_Officer__c = conLender.Id;
                fa.OwnerId = loanUser.Id;
                
                lNotes.add(new Note(ParentId = fa.Id, 
                    Body = Label.NOTE_CHANGE_LENDER_DESC,
                    Title = Label.NOTE_CHANGE_LENDER_TITLE));
                    changeDalpLender(fa);                
            }
            
            //update object
            if(lUpdatedFinancialApp.size() > 0) {
                update lUpdatedFinancialApp;
                insert lNotes;                       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.SUCCESS_CHANGE_LENDER));
                changeBMRLender();
                            
                bIsSubmitted = true;            
                //reinitialize or set all previous choices after insert         
                init();
            } else {
                if(lFinancialAppWraps.size()!=0){
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ERROR_CHANGE_LENDER));
                }else{
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.SUCCESS_CHANGE_LENDER));                    
                   changeBMRLender();
                }
            }
        
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        
         PageReference pref = Page.mohcdChangeMyLender;
         pref.getParameters().put(StringConstants.PARAM_LENDER, conLender.Id);
         return pref;
    }
    
    public void changeBMRLender(){
        User householdUser = [SELECT ContactId FROM User WHERE Id = : Userinfo.getuserid()];
        Contact householdContact = [SELECT Id FROM Contact WHERE Id = :householdUser.ContactId];
        
            List<DALP_Request__c> bmrRequests = new List<DALP_Request__c>([SELECT Id,OwnerId,Lender__c,Owner.Id FROM DALP_Request__c WHERE
                                                                                HousingApp__c = null AND Requested_By__c = :householdContact.Id]);
        
            for(DALP_Request__c bmrRequest : bmrRequests){
                bmrRequest .Lender__c = conLender.Id;
                bmrRequest .OwnerId = loanUser.Id;
            }
            
            update bmrRequests;
    }
    
    public void changeDalpLender(Financial_Application__c  finApp){
        if(finApp.Housing_Application__c!=null){            
            List<DALP_Request__c> dalpRequests = new List<DALP_Request__c>([SELECT Id,OwnerId,Lender__c,Owner.Id FROM DALP_Request__c WHERE HousingApp__c = :finApp.Housing_Application__c]);
                        
            for(DALP_Request__c dalpRequest : dalpRequests){
                dalpRequest.Lender__c = conLender.Id;
                dalpRequest.OwnerId = loanUser.Id;
            }
            
            update dalpRequests;
        }
    }
        
    public class FinancialApplicationWrapper {
        public Boolean isSelected {get; set;}
        public Financial_Application__c fa {get; set;}
        
        public FinancialApplicationWrapper(Boolean isSelected , Financial_Application__c fa) {
            this.isSelected = isSelected;
            this.fa = fa;    
        }
    }
}