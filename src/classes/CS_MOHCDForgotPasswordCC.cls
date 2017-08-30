/**
 * @author:      Sumit Shingavi
 * @date:        07/01/2014
 * @description: Apex class for mohForgotPassword VF Page
 * @history:     06/11/2015 - Heidi Tang - Edited
*/ 
public with sharing class CS_MOHCDForgotPasswordCC {
    
    //Public Variables
    public String email {get; set;}   
    
    //Constructor   
    public CS_MOHCDForgotPasswordCC () {}
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 01/07/2014
    * @description : Apex method for resetting the password for user based on email entered
    * @parameters : Nothing
    * @returns : PageReference
    */    
    public PageReference forgotPassword() {
        
        //Check if entered email is NOT blank
        if(!String.isBlank(email)) {
            
            //Check if there is any User matching to entered Email
            List<User> lUsers = [SELECT Id, Name FROM User WHERE Email =: email LIMIT 1];
            
            //Reset Password
            if(!lUsers.isEmpty()) {
                Boolean isSuccessful = Site.forgotPassword(email);        
                System.debug(LoggingLevel.INFO, '==isSuccessful=='+isSuccessful);
                email = '';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.SUCCESS_CONFIRM_PASSWORD));
            }else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.ERROR_PASSWORD_MATCH));
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.ERROR_NO_EMAIL));
        }
        return null;
    }
}