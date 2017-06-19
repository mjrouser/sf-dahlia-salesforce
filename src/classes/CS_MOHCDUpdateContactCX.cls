/**
 * An apex page controller that updates the information of User, Contact, and Account
 * Author: Crissar D. Ibarra
 * History: 
 *          7/14/14 - created - crissar ibarra
 */
 
public with sharing class CS_MOHCDUpdateContactCX{
    
    public String userFirstName{get; set;}
    public String userLastName{get; set;}
    public String updatePhone{get; set;}
    public String updateMobilePhone {get; set;}
    public String updateWorkPhone {get; set;}
    public String updateEmail {get; set;}
    public String updateStreetNumber{get; set;}
    public String updateStreetName{get; set;}
    public String updateStreetType{get; set;}
    public String updateAptUnit{get; set;}
    public String updateCity{get; set;}
    public String updateState{get; set;}
    public String updateZipCode{get; set;}
    public String contactID{get; set;}
    
    public User currentUser{get;set;}
    public Contact currentUserContact{get; set;}
    public Account currentUserContactAccount{get; set;}
    
    public string userID = UserInfo.getuserId();
        
    // Code we will invoke on page load
    public CS_MOHCDUpdateContactCX(){ 
        userID = UserInfo.getuserId();      
        userInfo();
    }
      
    // Code we will invoke on page load
    public CS_MOHCDUpdateContactCX(ApexPages.StandardController controller){ 
        
        currentUser = (User)controller.getRecord();      
        userInfo();
    }    
    
    // Method for getting the informations of the User (constructor)
    public void userInfo(){
        
        currentUser = [SELECT firstName,
                              lastName,                                                      
                              ContactID FROM User WHERE ID =: userID];
               
        this.userFirstName = currentUser.firstName;
        this.userLastName = currentUser.lastName;
        
        currentUserContact = [SELECT Work_Phone__c,
                                     Phone,
                                     MobilePhone,
                                     Email,
                                     Street_Number__c,
                                     Street_Name__c,
                                     Street_Type__c,
                                     Apt_Unit__c,
                                     City__c,
                                     State__c,
                                     Zip_Code__c,
                                     MailingCountry,
                                     HomePhone,
                                     AccountID FROM Contact WHERE ID =: currentUser.ContactID];
        
        this.updateWorkPhone = currentUserContact.Work_Phone__c;
        this.updatePhone = currentUserContact.HomePhone;
        this.updateMobilePhone = currentUserContact.MobilePhone;
        this.updateEmail = currentUserContact.Email;
        this.updateStreetNumber = currentUserContact.Street_Number__c;
        this.updateStreetName = currentUserContact.Street_Name__c;
        this.updateStreetType = currentUserContact.Street_Type__c;
        this.updateAptUnit = currentUserContact.Apt_Unit__c;
        this.updateCity = currentUserContact.City__c;
        this.updateZipCode = currentUserContact.Zip_Code__c;
        currentUserContact.MailingCountry = 'United States';
        
        currentUserContactAccount = [SELECT Work_Phone__c,
                                            Mobile_Phone__c,
                                            Phone,
                                            Zip_Code__c,
                                            City__c,                                            
                                            Street_Name__c,
                                            Street_Number__c,
                                            Street_Type__c,
                                            Apt_Unit__c,
                                            State__c,
                                            Email__c,
                                            BillingCountry FROM Account WHERE ID =: currentUserContact.AccountID];
        this.updateState = currentUserContactAccount.State__c;
        currentUserContactAccount.BillingCountry = 'United States';
    }    
    
    
    /*
    * @author : Cloud Sherpas Inc.
    * @date : 03/07/2014
    * @description : Apex method for updating the information of the contact
    * @parameters : Nothing
    * @returns : Nothing
    */  
    // Method for getting the informations of the Account
    public void accountInfo(){
        
        currentUserContactAccount.Work_Phone__c = currentUserContact.Work_Phone__c;                                   
        currentUserContactAccount.Mobile_Phone__c = currentUserContact.MobilePhone;
        currentUserContactAccount.Phone = currentUserContact.Phone;
        currentUserContactAccount.Email__c = currentUserContact.Email;
        currentUserContactAccount.Street_Name__c = currentUserContact.Street_Name__c;
        currentUserContactAccount.Street_Number__c = currentUserContact.Street_Number__c; 
        currentUserContactAccount.Street_Type__c = currentUserContact.Street_Type__c;
        currentUserContactAccount.Apt_Unit__c = currentUserContact.Apt_Unit__c ; 
        currentUserContactAccount.City__c = currentUserContact.City__c;       
        currentUserContactAccount.Zip_Code__c = currentUserContact.Zip_Code__c;
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 03/07/2014
    * @description : Apex method that will update the informations upon being called
    * @parameters : Nothing
    * @returns : the pageReference for '/housingprograms/mohcdHome'
    */  

    public PageReference updateInfo(){   
        accountInfo();
        //currentUserContact.State__c = currentUserContactAccount.State__c;
          
        try {
            Boolean isError = false;
            ApexPages.Message msg;
            
            if(currentUserContact.Phone!=null && !Pattern.matches('\\(?\\b[0-9]{3}\\)?[-/\\s]?[0-9]{3}[-. ]?[0-9]{4}\\b',currentUserContact.Phone)){
                msg = new ApexPages.Message(ApexPages.severity.ERROR,'Invalid Format for Home Phone');                    
                isError = true;  
            }
            
            if(currentUserContact.Work_Phone__c!=null && !Pattern.matches('\\(?\\b[0-9]{3}\\)?[-/\\s]?[0-9]{3}[-. ]?[0-9]{4}\\b',currentUserContact.Work_Phone__c)){
                msg = new ApexPages.Message(ApexPages.severity.ERROR,'Invalid Format for Work Phone');                                  
                isError = true;  
            }
            
            if(currentUserContact.MobilePhone!=null && !Pattern.matches('\\(?\\b[0-9]{3}\\)?[-/\\s]?[0-9]{3}[-. ]?[0-9]{4}\\b',currentUserContact.MobilePhone)){
                msg = new ApexPages.Message(ApexPages.severity.ERROR,'Invalid Format for Mobile Phone');                      
                isError = true;  
            }
            
            if(isError){
                ApexPages.AddMessage(msg);                                
            }else{
                update currentUserContact;
                
                PageReference newPage = new PageReference('/housingprograms/mohcdHome');
                newPage.setRedirect(true);
                return newPage;
            }
        } catch (Exception e) {
            System.debug('error encountered contact ::: ' + e.getMessage());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage());
            ApexPages.AddMessage(msg);
        }
        /*
        try {
            update currentUserContactAccount;
        } catch (Exception e) {
            System.debug('error encountered account ::: ' + e.getMessage());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage());
            ApexPages.AddMessage(msg);
        }
        */
        
        return null;
    }
}