/**
 * @author:      Sumit Shingavi
 * @date:        07/25/2014
 * @description: Apex class for mohcdChangePassword VF Page
 * @history:     06/10/2015 - Heidi Tang - Edited
*/
public with sharing class CS_MOHCDChangePasswordCC {

    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}        
    
    public CS_MOHCDChangePasswordCC() {
        oldPassword = '';
        newPassword = '';
        verifyNewPassword = '';
    }
    
    public PageReference changePassword() {
        PageReference pref = Site.changePassword(newPassword, verifyNewPassword, oldpassword);
        if(pref != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.SUCCESS_CHANGE_PASSWORD));
        }   
        return null;     
    }
}