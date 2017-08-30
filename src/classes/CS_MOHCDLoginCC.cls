/*
* @auther : Cloud Sherpas Inc.
* @date : 30/06/2014
* @description : An apex page controller that exposes the site login functionality
*/ 
public with sharing class CS_MOHCDLoginCC {
    
    //Public Variables
    public String username {get; set;}
    public String password {get; set;}
    public Boolean isSubmitted {get;set;}
    String radio = '0'; 
    /*
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String newpassword {get; set {newpassword = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    */
    public Boolean isLoginFailed {get; set;}
    public String strErrorMessages {get; set;}
    
    private Integer intSigninHit = 0;
    String propertyId {get;set;}
    
    //Constructor
    public CS_MOHCDLoginCC () {
        isLoginFailed = false;
        strErrorMessages = '';
        isSubmitted = false;
        propertyId = System.currentPageReference().getParameters().get('propid');
    }    
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 30/06/2014
    * @description : Apex method for login
    * @parameters : Nothing
    * @returns : PageReference
    */
    public PageReference login() {
        String startUrl = '';
        
        if(!String.isBlank(propertyId)) {
            isSubmitted = true;
            return null;
            //startUrl = Site.getPathPrefix() + '/mohcdHousingApp?pid='+propertyId;
        } else {
            startUrl = Site.getPathPrefix() + '/mohcdHome';
       
            System.debug(LoggingLevel.INFO, '===username===' + username);
            System.debug(LoggingLevel.INFO, '===password===' + password);
            
            PageReference landingPage = Site.login(username, password, startUrl); 
            System.debug(LoggingLevel.INFO, '===landingPage===' + landingPage);
            
            intSigninHit++;
            if(landingPage == null) { 
                String pageName = getVFPageName();
                System.debug(LoggingLevel.INFO, '===pageName===' + pageName);
                
                if(pageName != 'mohcdLoginDirect') isLoginFailed = true;       
                
                if(intSigninHit >= 5) {
                    strErrorMessages = '<b style=\"color:#cc0000\"> Error : </b> <br/> It looks like you are having trouble signing in. If you forgot your password, click the <b>\'Forgot Your Password?\'</b> link below. If you have not yet registered for an account, click the <b>\'Not yet registered?\'</b> link below. If you need more assistance, you may contact MOHCD at (415) 701-5613. Thank you. <br/>';    
                } else {
                    strErrorMessages = '<b style=\"color:#cc0000\"> Error : </b> <br/> The Email address and/or Password you entered are not recognized. Please try again.<br/>';
                }
                return null;
            }
            
            return landingPage;
       }            
    }
    
    private String getVFPageName()  {
        String pageName = ApexPages.CurrentPage().getUrl();
        System.debug(LoggingLevel.INFO, '===original pageName===' + pageName);
        pageName = EncodingUtil.urlEncode(pageName, 'UTF-8');
        System.debug(LoggingLevel.INFO, '===after encode pageName===' + pageName);
        pageName = pageName.replaceFirst('/housingprograms/apex/','');        
        System.debug(LoggingLevel.INFO, '===after replace pageName===' + pageName);
        string[] pageNameExtra = pageName.split('%3F',0);
        pageName = pageNameExtra[0];    
        pageName = pageName.replace('%2Fapex%2F', '');
        System.debug(LoggingLevel.INFO, '===final pageName===' + pageName);
        return pageName;
    }
    
    //for radiobuttons in popup window
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('0','Pre-fill my household information'));  
        options.add(new SelectOption('1','Start over with a blank Housing Application')); return options; 
    }
    
    public String getRadio() {
        return radio;
    }
                    
    public void setRadio(String radio) { this.radio = radio; }
    
    public PageReference onNext(){
        String startUrl = '';
        if(radio=='0'){
            prefillHousingApp();
            startUrl = Site.getPathPrefix() + '/mohcdHousingApp?pid='+propertyId+'&copy=1';
        }else{
            clearHousingApp();
            startUrl = Site.getPathPrefix() + '/mohcdHousingApp?pid='+propertyId;
        }        
        
         System.debug(LoggingLevel.INFO, '===username===' + username);
         System.debug(LoggingLevel.INFO, '===password===' + password);
            
         PageReference landingPage = Site.login(username, password, startUrl); 
         System.debug(LoggingLevel.INFO, '===landingPage===' + landingPage);
            
         intSigninHit++;
         if(landingPage == null) { 
             String pageName = getVFPageName();
             System.debug(LoggingLevel.INFO, '===pageName===' + pageName);
                
             if(pageName != 'mohcdLoginDirect') isLoginFailed = true;       
                
             if(intSigninHit >= 5) {
                 strErrorMessages = '<b style=\"color:#cc0000\"> Error : </b> <br/> It looks like you are having trouble signing in. If you forgot your password, click the <b>\'Forgot Your Password?\'</b> link below. If you have not yet registered for an account, click the <b>\'Not yet registered?\'</b> link below. If you need more assistance, you may contact MOHCD at (415) 701-5613. Thank you. <br/>';    
             } else {
                 strErrorMessages = '<b style=\"color:#cc0000\"> Error : </b> <br/> The Email address and/or Password you entered are not recognized. Please try again.<br/>';
             }
             return null;
         }
            
         return landingPage;
    }
    
    public void prefillHousingApp(){
        Contact fetchCont = SFMOHCD_DAO.getUserContDet();
        System.debug('***cont'+ fetchCont);

        Account contAccount = SFMOHCD_DAO.getUserAccount();
        System.debug('***account'+ contAccount);


        Housing_Application__c housingApp = SFMOHCD_DAO.createHousingApp(contAccount.Id, propertyId, fetchCont.Id);
        System.debug('****housingapp'+ housingApp);
        insert housingApp;

        List<Housing_Application_Member__c> housingAppMem = SFMOHCD_DAO.createhAppMem(housingApp.Id, contAccount.Id);
        System.debug('****housingAppMem'+ housingAppMem);
        
        insert housingAppMem;

        List<Housing_Application_Asset__c> houseAppAsset = SFMOHCD_DAO.createhAppAsset(contAccount.Id, housingApp.Id);
        System.debug('****houseAppAsset'+ houseAppAsset);
        insert houseAppAsset;
        

        List<Housing_Application_Income__c> houseAppIncome = SFMOHCD_DAO.createhAppIncome(contAccount.Id, housingApp.Id);

        insert houseAppIncome;

    }
    
    public void clearHousingApp(){
        Contact fetchCont = SFMOHCD_DAO.getUserContDet();
        System.debug('***cont'+ fetchCont);

        Account contAccount = SFMOHCD_DAO.getUserAccount();
        System.debug('***account'+ contAccount);


        Housing_Application__c housingApp = SFMOHCD_DAO.createHousingApp(contAccount.Id, propertyId, fetchCont.Id);
        System.debug('****housingapp'+ housingApp);
        insert housingApp;    
    }
    
    public PageReference closePopUp(){
        isSubmitted = false;
        PageReference pref = new PageReference('/housingprograms/mohcdViewListing?id='+propertyId);
        pref.setRedirect(true);
        return pref;          
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 01/07/2014
    * @description : Apex method to check if password and confirmPassword matches
    * @parameters : Nothing
    * @returns : Boolean
    */    
    /*private Boolean isValidPassword() {
        return newpassword == confirmPassword;
    }*/
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 01/07/2014
    * @description : Apex method to register a new User
    * @parameters : Nothing
    * @returns : PageReference 
    */   
    /*public PageReference registerUser() {
        
        //it's okay if password is null - we'll send the user a random password in that case
        if(!isValidPassword()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match));            
            return null;
        }
        
        System.debug(LoggingLevel.INFO, '==MOHCD_User_Creation_Profile==' + Label.MOHCD_User_Creation_Profile);
        String profileId = [SELECT Id FROM Profile WHERE Name =: Label.MOHCD_User_Creation_Profile LIMIT 1].Id;
        
        System.debug(LoggingLevel.INFO, '==MOHCD_User_Creation_Account_Id==' + Label.MOHCD_User_Creation_Account_Id);
        String accountId = Label.MOHCD_User_Creation_Account_Id;
        //String accountId = [SELECT Id FROM Account WHERE Name =: Label.MOHCD_User_Creation_Account_Name LIMIT 1].Id;
        
        String userName = email;
        communityNickname = firstName + ' ' + LastName;
        
        User usr = new User(Username = userName, Email = email, FirstName = firstName, LastName = lastName, 
            CommunityNickname = communityNickname, ProfileId = profileId);
        
        String userId = Site.createPortalUser(usr, accountId, newpassword);
      
        if(userId != null) { 
            if(newpassword != null && newpassword.length() > 1) {
                return Site.login(userName, newpassword, null);
            } else {
                PageReference page = System.Page.CommunitiesSelfRegConfirm;
                page.setRedirect(true);
                return page;
            }
        }
        return null;
    }*/
}