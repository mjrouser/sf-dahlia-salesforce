/*
* @auther : Crissar D. Ibarra
* @date : 08/08/2014
* @description : Apex class for mohcdInitiateSale VF Page
*/ 

public class CS_MOHCDInitialSaleOfMyHomeCC{

    public User currentUser {get;set;}
    public Contact currentUserContact {get;set;}
    public Account owner {get; set;}
    public String realEstateAgentName {get; set;}
    public String realEstateAgentLicenseNo {get; set;}
    public String realEstateAgentCompanyName {get; set;}
    public String realEstateAgentPhoneNo {get; set;}
    public String realEstateAgentEmailAddress {get; set;}
    
    public String pageMessage {get; set;}
    
    public string userID {get;set;}
    
    public CS_MOHCDInitialSaleOfMyHomeCC(ApexPages.StandardController controller){
        userID = UserInfo.getuserId();
        currentUser = [SELECT name, Id, ContactID FROM User WHERE ID =: userID];
        currentUserContact = [SELECT AccountID, OwnerId FROM Contact WHERE ID =: currentUser.ContactID];  
        Account account = [SELECT Id, OwnerId FROM Account WHERE Id =: currentUserContact.AccountID];
        pageMessage = '';
       
    }
    
    public PageReference createTask(){
        pageMessage = '';
        boolean hasError = false;
        Property_Owner_Requests__c oPOR = new Property_Owner_Requests__c();
        
        if (realEstateAgentName == '') {
            hasError = true;
            pageMessage += '<b style=\"color:#cc0000\"> Error: </b>Real Estate Agent Name is a required field.<br/>';
        }
        
        if (realEstateAgentCompanyName == '') {
            hasError = true;
            pageMessage += '<b style=\"color:#cc0000\"> Error: </b>Real Estate Agent Company Name is a required field.<br/>';
        }
        
        if (realEstateAgentPhoneNo == '' || realEstateAgentPhoneNo == null) {
            hasError = true;
            pageMessage += '<b style=\"color:#cc0000\"> Error: </b>Real Estate Agent Phone Number is a required field.<br/>';
        }
        
        if(realEstateAgentPhoneNo!=null && !Pattern.matches('\\(?\\b[0-9]{3}\\)?[-/\\s]?[0-9]{3}[-. ]?[0-9]{4}\\b',realEstateAgentPhoneNo)){
            hasError = true;
            pageMessage += '<b style=\"color:#cc0000\"> Error: </b>Invalid Format for Real Estate Agent Phone Number.<br/>';
        }
        
        if (realEstateAgentEmailAddress == '' || realEstateAgentEmailAddress == null) {
            hasError = true;
            pageMessage += '<b style=\"color:#cc0000\"> Error: </b>Real Estate Agent Email is a required field.<br/>';
        } else {
            if (!validateEmail(realEstateAgentEmailAddress)) {
                hasError = true;
                pageMessage += '<b style=\"color:#cc0000\"> Error: </b>Please enter a valid email address for your Real Estate Agent.<br/>';
            }
        }
        
        if (!hasError) {
            //temporary
            Id uId = UserInfo.getUserId();
            User user = [SELECT Id, Name FROM User WHERE Id = :uId];
            System.debug('Name : ' + user.Name + ' Id : ' + user.Id);
                        
            String description = realEstateAgentName 
                + (realEstateAgentLicenseNo != '' ? (', ' + realEstateAgentLicenseNo) : '')
                + (realEstateAgentCompanyName != '' ? (', ' + realEstateAgentCompanyName) : '')
                + (realEstateAgentPhoneNo != '' ? (', ' + realEstateAgentPhoneNo) : '')
                + (', ' + realEstateAgentEmailAddress);
                
            Task task = new Task(WhatId = currentUserContact.AccountID, Subject = 'Initiate Sale of My House', OwnerId = user.Id);
            task.Description = description;
            
            //Insert property request
            //Format phone number
            if (realEstateAgentPhoneNo.length() == 10){
                realEstateAgentPhoneNo = '(' +realEstateAgentPhoneNo.substring(0,3) + ') ' + 
                realEstateAgentPhoneNo.substring(3,6) + '-' +
                realEstateAgentPhoneNo.substring(6,10);
            } 

            else if(realEstateAgentPhoneNo.length() == 11){
                realEstateAgentPhoneNo = '(' +realEstateAgentPhoneNo.substring(0,4) + ') ' + 
                realEstateAgentPhoneNo.substring(4,7) + '-' +
                realEstateAgentPhoneNo.substring(7,11);
            } 
            
            oPOR = new Property_Owner_Requests__c(Real_Estate_Agent_Name__c = realEstateAgentName ,
                                                                             Real_Estate_Agent_License_Number__c = realEstateAgentLicenseNo,
                                                                             Real_Estate_Company_Name__c = realEstateAgentCompanyName,
                                                                             Real_Estate_Agent_Phone__c = realEstateAgentPhoneNo,  
                                                                             Real_Estate_Agent_Email__c = realEstateAgentEmailAddress,
                                                                             Requested_By__c = currentUserContact.AccountId
                                                                             );
            try {
                insert task;
                insert oPOR;
                
                 PageReference page = new PageReference('/apex/mohcdSuccessInitiateSale?pId='+oPOR.Id); 
                 page.setRedirect(true);
                 return page;

                //pageMessage = '<b style=\"color:#3276b1; font-size:1.5em\">Your Request Has Been Successfully Submitted! Your Real Estate Agent or MOHCD will contact you with next steps.</b> </br>';
                //realEstateAgentName = '';
                //realEstateAgentLicenseNo = '';
                //realEstateAgentCompanyName = '';
                //realEstateAgentPhoneNo = '';
                //realEstateAgentEmailAddress = '';
          
            } catch (Exception e) {
                System.debug(e.getMessage());
                PageReference page = new PageReference('/apex/mohcdSuccessInitiateSale?udu='+e.getMessage()); 
                 page.setRedirect(true);
                 return page;
            }
        }                               
        
        return null;
     }
    
    public static Boolean validateEmail(String email) {
        Boolean valid = false;
        String emailRegEx = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        Pattern p = Pattern.compile(emailRegEx);
        Matcher m = p.matcher(email);        
        if (m.matches()) {
            valid = true;
        }
        return valid;
    }
}