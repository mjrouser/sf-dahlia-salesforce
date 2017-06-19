/*
* @auther : Cloud Sherpas Inc.
* @date : 30/06/2014
* @description : Apex class for mohTemplate VF Page
*/ 
public with sharing class CS_MOHCDTemplateCC {

    //Constructor
    public CS_MOHCDTemplateCC () {}
    private User usr = [SELECT Id, Name, Profile.Name FROM User WHERE Id =: Userinfo.getUserId() LIMIT 1];
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 30/06/2014
    * @description : Apex method that takes the user to the right start page based on credentials or lack thereof.
    * @parameters : Nothing
    * @returns : PageReference
    */    
    public PageReference forwardToCustomAuthPage() {
        if(UserInfo.getUserType() == 'Guest'){
            return new PageReference('/mohcdLogin');
        } else if(usr.Profile.Name == 'MOHCD - Lender' || usr.Profile.Name == 'MOHCD - Property Agent') {
            return new PageReference('/home/home.jsp');
        } else {
            return null;
        }      
    }    
}