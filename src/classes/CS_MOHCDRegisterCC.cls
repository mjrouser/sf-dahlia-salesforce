/***************************************************************************
 * @author Ronald Martinez
 * @date 30 June 2014
 * @description Used for community user self-registration. Modified version of SfmohprogramsSelfRegController2 
 * @revision(s)
 ***************************************************************************/


public without sharing class CS_MOHCDRegisterCC{
    public String username {get; set;}
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    public String zipcode {get; set;}
    public Boolean isRequired {get; set;}
    public Date birthDate {get; set;}
    public String appType {get; set;}
    public String regId {get; set;}
    public Boolean isNew {get; set;}
    public Integer currentMonth {get;set;}
    public Integer currentDay {get;set;}
    public Integer currentYear {get;set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    /*
    private String currenthost = ApexPages.currentPage().getHeaders().get('Host');
    private Integer subdomain_loc = currenthost.indexof('.',0) + 1;
    private String redirecthost = 'https://' + currenthost.substring(subdomain_loc) + '/';
    private String host_final = redirecthost.replace('force', 'salesforce');
    */
    private String currenthost;
    private Integer subdomain_loc;
    private String redirecthost;
    private String host_final;
    
    private Integer counter = 0; 

    CS_MOHCDWrapperClass wrapit = new CS_MOHCDWrapperClass();
    public List<CS_MOHCDWrapperClass.wUser> wrpUserList {get;set;}
    public List<CS_MOHCDWrapperClass.wContact> wrpContactList {get;set;}
    public List<CS_MOHCDWrapperClass.wContact> wrpContactList2 {get;set;}

    
    public CS_MOHCDRegisterCC() {
        appType = StringConstants.EXISTING_APPLICANT_NO;
        
        isNew = false;

        currentMonth = 0;
        currentYear = 0;
        currentDay = 0; 

        wrpUserList = new List<CS_MOHCDWrapperClass.wUser>(); 
        wrpContactList = new List<CS_MOHCDWrapperClass.wContact>();
        wrpContactList2 = new List<CS_MOHCDWrapperClass.wContact>();
    }
    
    public PageReference checkApptype(){
        if(appType==StringConstants.EXISTING_APPLICANT_YES){
            isNew = true;
        }
        else{
            isNew = false;
            regId = null;
        }
        return null;
    
    }

    private boolean isEmailFormatCorrect(String objEmail) {
       Boolean emailValidate = true;
       String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
       Pattern MyPattern = Pattern.compile(emailRegex);
       Matcher MyMatcher = MyPattern.matcher(objEmail);
       if (!MyMatcher.matches()) {
           emailValidate = false;
       }
       return emailValidate;
   }

    public PageReference registerUser(){
        currenthost = ApexPages.currentPage().getHeaders().get('Host');
        System.debug('CURRENT HOST: ' +currenthost);  

        //modified 01/19/2015 by Heidi Tang
        if(currenthost != null){
            subdomain_loc = currenthost.indexof('.',0) + 1;
            redirecthost = 'https://' + currenthost.substring(subdomain_loc) + '/';
            host_final = redirecthost.replace('force', 'salesforce');
        }
        
        Boolean valuesErr = false;
        
        if(firstName == null || firstName == ''){
            System.debug('Dumaan');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,StringConstants.PROVIDE_FIRST));
            valuesErr = true;
        }
        
        if(lastName == null || lastName == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,StringConstants.PROVIDE_LAST));
            valuesErr = true;
        }
        
        if(currentMonth == 0 || currentDay == 0 || currentYear == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,StringConstants.PROVIDE_BIRTH));
            valuesErr = true;
        }
        
        if(zipcode == null || zipcode == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,StringConstants.PROVIDE_ZIP));
            valuesErr = true;
        }else{
            if(zipcode.length() > 5){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,StringConstants.INVALID_ZIP));
                valuesErr = true;
            }
        }
        
        if(email == null || email == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,StringConstants.PROVIDE_EMAIL));
            valuesErr = true;
        } else if(!isEmailFormatCorrect(email)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,StringConstants.INVALID_EMAIL));
            valuesErr = true;
        } else{
            valuesErr = false;
        }

        if(currentYear != null && currentMonth != null && currentDay != null){
            birthDate = date.newinstance(currentYear, currentMonth, currentDay);            
        }
                
        List<Contact> oldContacts = new List<Contact>([SELECT Id,LastName,FirstName,Birthdate,Zip_Code__c FROM Contact WHERE LastName= :lastName AND FirstName = :firstName AND Birthdate =:birthDate AND Zip_Code__c =:zipcode]);
                                
        if(oldContacts.size()!=0){
            PageReference page = System.Page.mohcdNewUserContactMatch;        
            page.setRedirect(true);
            return page; 
        }
        
        System.debug('valuesErr:' +valuesErr);
        
        if(valuesErr == false) {
            Profile profileId = new Profile();
            
            
            profileId = [SELECT Id
                                FROM Profile
                                WHERE Name = :StringConstants.HOUSEHOLD_PROFILE];
                   
            Account accId = [SELECT Id
                                    FROM Account
                                    WHERE Name = :StringConstants.ACCT_NAME];
            
            String roleEnum = null; // To be filled in by customer.
            String accountId = ''; // To be filled in by customer.
            String userId = null;
            
            
            Blob blobKey = crypto.generateAesKey(128);
            String key = EncodingUtil.convertToHex(blobKey);
            String val = key.substring(0,4);
            String key2 = EncodingUtil.convertToHex(blobKey);
            String val2 = key.substring(0,4);
            //String userName = email;
            userName = email;                                     
            wrpUserList = wrapit.getExistingUserswithUsername(userName);
            wrpContactList = wrapit.getexactContactwithRegId(lastName, birthDate, zipcode, regId);
            wrpContactList2 = wrapit.getexactContactnoRegId(lastName, birthDate, zipcode);
                                     
           List<User> newUserList = new List<User>();
           List<CS_MOHCDWrapperClass.wContact> conToUpdate = new List<CS_MOHCDWrapperClass.wContact>(); 
            System.debug('appType: ' +appType);
            if(appType==StringConstants.EXISTING_APPLICANT_YES){
                //Check for matching user
                System.debug('wrpUserList.size: ' +wrpUserList.size());               
                System.debug('wrpContactList.size: ' +wrpContactList.size());
                System.debug('wrpContactList2.size: ' +wrpContactList2.size());
                if(wrpUserList.size() > 0){
                    //Verify if setup request is needed when there is a matching user.          
                    Registrant_Setup_Request__c multipleMatches = new Registrant_Setup_Request__c();
                    multipleMatches.Link_to_Possible_Contact_or_User_1__c = host_final  + wrpUserList[0].us.id;
                    if (wrpUserList.size() > 1){ 
                        multipleMatches.Link_to_Possible_Contact_or_User_2__c = host_final + wrpUserList[1].us.id;
                    }
                    multipleMatches.Birthdate__c = birthdate;
                    multipleMatches.Current_Zipcode__c =  zipcode;
                    multipleMatches.Email__c = email;
                    multipleMatches.First_Name__c = firstName;
                    multipleMatches.Last_Name__c = lastName;
                    multipleMatches.Registration_Code__c = regId;
                    multipleMatches.NewtoProgram__c = true;
                    multipleMatches.Reason__c = wrpUserList.size() + ' ' + StringConstants.REASON_DUPLICATE_USERNAME_EMAIL;            
                     
                    if(multipleMatches != null){
                       insert multipleMatches;

                       PageReference page = System.Page.mohcdNewUserContactMatch;        
                       
                       page.setRedirect(true);
                       return page;
                    
                    }

                }
                //Check if there is a single contact match with RegId
                if(wrpContactList.size() == 1){  
                    try {
                        accountid = wrpContactList2[0].con.AccountId;
                        String contactId = wrpContactList2[0].con.Id;
                        userId = SFMOHCD_DAO.registerExistingUser(accountId, profileId.Id, firstName, lastName, email, zipcode, val, val2, contactId);
                                    
                        if (userId != null) {
                            PageReference page = System.Page.mohcdRegConfirmation;
                            page.setRedirect(true);
                            return page;
                        }                                                                    
                     } 
                     
                     catch (Exception e) {
                         System.debug(e);
                     }
                    
                    if(userId == null){
                         PageReference page = System.Page.mohcdRegConfirmation;
                         page.setRedirect(true);
                         return page;                                       
                    }
                       
                    if (userId != null) {
                        if (password != null && password.length() > 1) {
                            return Site.login(userName, password, null);
                        }
                    }                    
                }
                
                //Check if there are multiple contact matches with RegId
                else if (wrpContactList.size() > 1){
                    Registrant_Setup_Request__c multipleMatches = new Registrant_Setup_Request__c();
                    
                    if(currenthost != null){
                        multipleMatches.Link_to_Possible_Contact_or_User_1__c = host_final + wrpContactList[0].con.id;
                        multipleMatches.Link_to_Possible_Contact_or_User_2__c = host_final + wrpContactList[1].con.id;
                    }
                    multipleMatches.Birthdate__c = birthdate;
                    multipleMatches.Current_Zipcode__c =  zipcode;
                    multipleMatches.Email__c = email;
                    multipleMatches.First_Name__c = firstName;
                    multipleMatches.Last_Name__c = lastName;
                    multipleMatches.Registration_Code__c = regId;
                    multipleMatches.NewtoProgram__c = true;
                    multipleMatches.Reason__c =  wrpContactList.size() + ' ' + StringConstants.REASON_NOT_ONLY_ONE_MATCHING_CONTACT;            
                         
                    if(multipleMatches != null){
                        insert multipleMatches;
                        PageReference page = System.Page.mohcdMultipleContactMatch;        
                        page.setRedirect(true);
                        return page;
                    }
                }
                
                //No contact matches with RegId
                else if(wrpContactList.size() == 0){
                    if(regId != ''){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,StringConstants.REASON_REGISTRATION_ID));
                    }
                    //No Regid
                    else if(regId == ''){
                        //No contact match no regId
                        if (wrpContactList2.size() == 0){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,StringConstants.REASON_REGISTRATION));
                        }
                        //Single contact match no regid
                        else if(wrpContactList2.size() == 1){                        
                            try {
                                accountid = wrpContactList2[0].con.AccountId;
                                String contactId = wrpContactList2[0].con.Id;                        
                                userId = SFMOHCD_DAO.registerExistingUser(accountId, profileId.Id, firstName, lastName, email, zipcode, val, val2, contactId);
                                    
                                if (userId != null) {
                                    PageReference page = System.Page.mohcdRegConfirmation;
                                    page.setRedirect(true);
                                    return page;
                                }                                   
                            }
                        
                            catch (Exception e) {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,StringConstants.REASON_MAINTENANCE));
                                System.debug(e);
                            }                   
                        }
                        //Multiple contact matches no regid
                        else if (wrpContactList2.size() > 1){
                            Registrant_Setup_Request__c multipleMatches = new Registrant_Setup_Request__c();
                            multipleMatches.Link_to_Possible_Contact_or_User_1__c = host_final + wrpContactList2[0].con.id;
                            multipleMatches.Link_to_Possible_Contact_or_User_2__c = host_final + wrpContactList2[1].con.id;
                            multipleMatches.Birthdate__c = birthdate;
                            multipleMatches.Current_Zipcode__c =  zipcode;
                            multipleMatches.Email__c = email;
                            multipleMatches.First_Name__c = firstName;
                            multipleMatches.Last_Name__c = lastName;
                            multipleMatches.Registration_Code__c = regId;
                            multipleMatches.NewtoProgram__c = true;
                            multipleMatches.Reason__c = wrpContactList2.size() + ' ' + StringConstants.REASON_NOT_ONLY_ONE_MATCHING_CONTACT;            
                         
                            if(multipleMatches != null){
                                insert multipleMatches;
                                PageReference page = System.Page.mohcdNewUserContactMatch;        
                                page.setRedirect(true);
                                return page;
                            }                        
                        }
                                                
                    }   

                }//End No contact matches with RegId

            }
            
            
            else if(appType==StringConstants.EXISTING_APPLICANT_NO){
                System.debug('wrpUserList.size: ' +wrpUserList.size());               
                System.debug('wrpContactList.size: ' +wrpContactList.size());
                System.debug('wrpContactList2.size: ' +wrpContactList2.size());
                //check if there is matching username                                             
                if(wrpUserList.size() > 0){          
                    Registrant_Setup_Request__c multipleMatches = new Registrant_Setup_Request__c();
                    multipleMatches.Link_to_Possible_Contact_or_User_1__c = host_final + wrpUserList[0].us.id;
                    if (wrpUserList.size() > 1){ 
                        multipleMatches.Link_to_Possible_Contact_or_User_2__c = host_final + wrpUserList[1].us.id;
                    }
                    multipleMatches.Birthdate__c = birthdate;
                    multipleMatches.Current_Zipcode__c =  zipcode;
                    multipleMatches.Email__c = email;
                    multipleMatches.First_Name__c = firstName;
                    multipleMatches.Last_Name__c = lastName;
                    multipleMatches.Registration_Code__c = regId;
                    multipleMatches.NewtoProgram__c = true;
                    multipleMatches.Reason__c = wrpUserList.size() + ' ' + StringConstants.REASON_DUPLICATE_USERNAME_EMAIL;            
                     
                    if(multipleMatches != null){
                       insert multipleMatches;

                       PageReference page = System.Page.mohcdNewUserContactMatch;        
                       page.setRedirect(true);
                       return page;                    
                    }
                }
                
                else if(wrpUserList.size() == 0){
                    try {
                        String Acctlastname = firstName+' '+lastName+' Household';                       
                        String ownerid = SFMOHCD_DAO.getPortalUserCreator();
                        System.debug('Owner Id: ' +ownerid);
                        accountid = SFMOHCD_DAO.createNewAccount(Acctlastname, ownerid);
                        User newUser = new User();
                        newUser.FirstName = firstName;
                        newUser.LastName = lastName;
                        newUser.CommunityNickname = email+zipcode+val+val2;
                        newUser.Email = email;
                        newUser.Username = email;
                        System.debug('CREATE PORTAL USER: ' +newUser+ ' Acc: ' +accountId+ ' pw: ' +password);
                        userId = Site.createPortalUser(newUser, accountId, password); 
                        System.debug('NEW USER ID: ' +userId); 
 
                            if (userId != null) {
                                //Copy birthdate and zipcode to the new contact
                                Contact newCon = [Select Id, Birthdate, Zip_Code__c, Registration_Code__c from Contact where AccountId =: accountid and LastName =: lastName and FirstName =: firstName and email =: email];
                                System.debug('newCon: ' +newCon);
                                newCon.Birthdate = birthdate;
                                newCon.Zip_Code__c = zipcode;
                                newCon.Head_of_Household2__c = 'Yes';
                                newCon.Relationship_to_Head_of_Household__c = 'Self';
                                if(regId != null){
                                    newCon.Registration_Code__c = regId; 
                                }
                                update newCon;
                            
                            
                                if (password != null && password.length() > 1) {
                                    return Site.login(userName, password, null);
                                }
                                
                                else {
                                    PageReference page = System.Page.mohcdRegConfirmation;
                                    page.setRedirect(true);
                                    return page;
                                }
                            }
                    } catch (Exception e) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getStackTraceString()));
                        System.debug(e);
                    }                       
                }
              
            } // end bracker for entire set of scenarios covering applicant who is new to program
    
            
       } // end bracket for (valuesErr == false) portion in the code for which user provided qualified values in the page
        
       return null; 
    }  // end bracket for entire registerUser method
    
    
    public List<SelectOption> getType() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption(StringConstants.EXISTING_APPLICANT_YES,StringConstants.EXISTING_APPLICANT_YES)); 
        options.add(new SelectOption(StringConstants.EXISTING_APPLICANT_NO,StringConstants.EXISTING_APPLICANT_NO)); 
        
        return options; 
    }

    public String getAppType() {
        return appType;
    }
                    
    public void setAppType(String appType) { this.appType = appType; }
    
    public List<SelectOption> getmonthsList() {
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption('','--Month--'));
        for(integer i=1;i<=12;i++) {
            options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
     return options;
   }
   
    public List<SelectOption> getdaysList() {
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption('','--Day--'));
       if(currentMonth==2) {
            for(integer i=1;i<=28;i++) {
                options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
            }
       } else if(currentMonth==4 || currentMonth==6 || currentMonth==9 || currentMonth==11) {
            for(integer i=1;i<=30;i++) {
                options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
            }
       } else if(currentMonth==1 || currentMonth==3 || currentMonth==5 || currentMonth==7 || currentMonth==8 || currentMonth==10 || currentMonth==12) {
            for(integer i=1;i<=31;i++) {
                options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
            }
       }
     return options;
   }
   
    public List<SelectOption> getyearsList() {
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption('','--Year--'));
    integer j = system.Today().year();
        for(integer i=1900;i<=j;i++) {
            options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
     return options;
   }
  
}