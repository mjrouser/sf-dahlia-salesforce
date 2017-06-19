public class CS_MOHCDSearchLenderCC {
    
    public List<ContactWrapper> lLenderWraps {get; set;}
    private String strMode = '';
    
    public CS_MOHCDSearchLenderCC() {
        
        strMode = System.currentPageReference().getParameters().get('m');
        
        List<Contact> lLenders = [SELECT Id, Name, Work_Phone__c, Email, FirstName, 
            LastName, MailingStreet, MailingCity, MailingState, MailingCountry, 
            MailingPostalCode, AccountId, Account.Name, BMR_Certified__c, 
            DALP_Certified__c, MCC_Certified__c
            FROM Contact 
            WHERE RecordType.Name = 'Lending Agent'
            AND BMR_Certification_Expiration_Date__c >= TODAY
            AND DALP_MCC_Certification_Expiration_Date__c >= TODAY
            AND Account.Lender_Participation_Fee_Status__c = 'Current'
            ORDER BY Name];
        
        lLenderWraps = new List<ContactWrapper>();
        for(Contact con: lLenders) {
            lLenderWraps.add(new ContactWrapper(false, con));
        }       
    }
    
    public class ContactWrapper {
        public Boolean isSelected {get; set;}
        public Contact con {get; set;}
        
        public ContactWrapper(Boolean isSelected , Contact con) {
            this.isSelected = isSelected;
            this.con = con;
        }
    } 
    
    public PageReference goBackToFinRequest() {
        
        List<Contact> lSelectedContacts = new List<Contact>();
        for(ContactWrapper cw : lLenderWraps) {
            if(cw.isSelected) {
                lSelectedContacts.add(cw.con);
            }
        }
        if(lSelectedContacts.size() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Lender'));
        } else if(lSelectedContacts.size() > 1) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select only one Lender'));
        } else if(lSelectedContacts.size() == 1) {            
            if(!String.isBlank(strMode) && strMode == 'dpa') {
                PageReference pref = Page.mohcdDownPayRequest;
                pref.getParameters().put('lid', lSelectedContacts[0].Id);
                pref.setRedirect(true);
                return pref;
            } else if(!String.isBlank(strMode) && strMode == 'cml') {
                PageReference pref = Page.mohcdChangeMyLender;
                pref.getParameters().put('lid', lSelectedContacts[0].Id);
                pref.setRedirect(true);
                return pref;
            }
        }
        return null;    
    }  
}