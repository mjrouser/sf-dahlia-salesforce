/**
 * @author:      Sumit Shingavi
 * @date:        07/17/2014
 * @description: Controller class for mohcdDownPayRequest
 * @history:     06/10/2015 - Heidi Tang - Edited
*/ 
public class CS_MOHCDDownPayRequestCC {
        
    public List<HousingApplicationWrapper> lHousingAppWraps {get; set;}
    public Contact conLender {get; set;}
    public DALP_Request__c dalpRequest {get; set;}
    public Boolean bIsSubmitted {get; set;}
    
    public CS_MOHCDDownPayRequestCC() {
        conLender = new Contact();
        bIsSubmitted = false;
        init();
    }
    
    private void init() {
        
        dalpRequest = new DALP_Request__c();
        
        String lenderId = System.currentPageReference().getParameters().get(StringConstants.PARAM_LENDER);
        if(!String.isBlank(lenderId)) {
            conLender = [SELECT Id, Name, Work_Phone__c, Email, FirstName, 
                LastName, MailingStreet, MailingCity, MailingState, MailingCountry, 
                MailingPostalCode, AccountId, Account.Name, BMR_Certified__c, 
                DALP_Certified__c, MCC_Certified__c
                FROM Contact WHERE Id =: lenderId LIMIT 1];
        }
        
        List<Housing_Application__c> lHousingApps = [Select Id, Name, Application_Status__c, 
            Property_of_Interest__c, Property_of_Interest__r.Property_Address_Marketing__c
            FROM Housing_Application__c 
            WHERE OwnerId =: Userinfo.getUserId()
            ORDER BY CreatedDate DESC];
            
        lHousingAppWraps = new List<HousingApplicationWrapper>();
        for(Housing_Application__c ha : lHousingApps) {
            lHousingAppWraps.add(new HousingApplicationWrapper(false, ha));
        }
    }
        
    public List<SelectOption> getRequestTypes() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption(Label.REQUEST_BMR,Label.REQUEST_BMR)); 
        options.add(new SelectOption(Label.REQUEST_MCC_BMR,Label.REQUEST_MCC_BMR));
        options.add(new SelectOption(Label.REQUEST_MCC_NONMOHCD,Label.REQUEST_MCC_NONMOHCD));
        return options;
    }
        
    public class HousingApplicationWrapper {
        public Boolean isSelected {get; set;}
        public Housing_Application__c ha {get; set;}
        
        public HousingApplicationWrapper(Boolean isSelected , Housing_Application__c ha) {
            this.isSelected = isSelected;
            this.ha = ha;    
        }
    }
    
    public PageReference submitFinancialProgramRequest() {
        
        try {        
            //Configure object to be inserted
            if(conLender != null && conLender.Id != null) {
                dalpRequest.Lender__c = conLender.Id;
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ERROR_SELECT_LENDER));
                return null;
            }
            
            dalpRequest.Requested_By__c = [SELECT ContactId FROM User WHERE Id =: Userinfo.getUserId() LIMIT 1].ContactId;
            
            List<Housing_Application__c> lSelectedHousingApps = new List<Housing_Application__c>();
            
            for(HousingApplicationWrapper haWrap : lHousingAppWraps) {
                if(haWrap.isSelected) {
                    lSelectedHousingApps.add(haWrap.ha);
                }
            }
            if(lSelectedHousingApps.size() > 1) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ERROR_ONE_APP));
                return null;
            } else if(lSelectedHousingApps.size() == 1) {
                dalpRequest.HousingApp__c = lSelectedHousingApps[0].Id;            
            }
            
            try {
                //insert object           
                insert dalpRequest;
                
                dalpRequest = [SELECT Id, Name, Housing_Type__c FROM DALP_Request__c WHERe Id =: dalpRequest.Id];
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.SUCCESS_DOWN_PAY_REQUEST +' '+ '<b>' + dalpRequest.Name + '</b>'));
                
                //temporary
                User userLender = [SELECT Id, Name FROM User WHERE Id = '005110000023Vhz'];
                
                //User userLender = [SELECT Id, Name FROM User WHERE User.ContactId =: conLender.Id];
                
                User currentUser = [SELECT name, Id, ContactID FROM User WHERE ID =: UserInfo.getUserId()];
                Contact currentUserContact = [SELECT AccountID, OwnerId FROM Contact WHERE ID =: currentUser.ContactID];
                
                Task task = new Task(WhatId = lSelectedHousingApps[0].Id, 
                    Subject = dalpRequest.Housing_Type__c, OwnerId = userLender.Id, 
                    Status = 'Not Started', Priority = 'High', Type = 'Other', WhoId = currentUserContact.Id);
                    
                insert task;
                
            } catch (Exception e) {
                System.debug(e.getMessage());
            }
            
            //reinitialize or set all previous choices after insert
            dalpRequest = new DALP_Request__c();            
            bIsSubmitted = true;
            
            init();
        
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }
}