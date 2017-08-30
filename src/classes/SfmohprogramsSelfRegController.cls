/***************************************************************************
 * @author Kimiko Roberto
 * @date 25 April 2014
 * @description An apex page controller that supports self registration of 
 users in communities that allow self registration
 * @revision(s)
 ***************************************************************************/
public with sharing class SfmohprogramsSelfRegController {
/*
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
   
    private Integer counter = 0;
    private String foundContactIds {get; set;}
    
    public SfmohprogramsSelfRegController() {
        appType = StringConstants.NEW_APPLICANT_NO;
        
        isNew = false;
        
    }
    
    public PageReference checkApptype(){
        if(appType==StringConstants.NEW_APPLICANT_YES){
            isNew = true;
        
        
        }
        else{
            isNew = false;
            regId = null;
        }
        return null;
    
    }
    
    public PageReference registerUser(){
        Boolean valuesErr = false;
        
        if(firstName == null || firstName == ''){
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Provide Information: First Name'));
            valuesErr = true;
        }
        
        if(lastName == null || lastName == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Provide Information: Last Name'));
            valuesErr = true;
        }
        if(lastName == null || lastName == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Provide Information: Last Name'));
            valuesErr = true;
        }
        
        if(currentMonth == null || currentDay == null || currentYear == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Provide Information: Birthdate'));
            valuesErr = true;
        }
        
        if(zipcode == null || zipcode == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Provide Information: Zipcode'));
            valuesErr = true;
        }
        
        if(email == null || email == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Provide Information: Email'));
            valuesErr = true;
        }
        
        
        if(valuesErr == false){
            
            Profile profileId = new Profile();
            
            birthDate = date.newinstance(currentYear, currentMonth, currentDay);
            profileId = [SELECT Id
                                FROM Profile
                                WHERE Name = :StringConstants.HOUSEHOLD_PROFILE];
    
            
                   
            Account accId = [SELECT Id
                                    FROM Account
                                    WHERE Name = :StringConstants.ACCT_NAME];
            
            String roleEnum = null; // To be filled in by customer.
            String accountId = accId.Id; // To be filled in by customer.
            String userId = null;
            
            

            String userName = email;
    
             
            List<Contact> contactMatch = [SELECT Id,
                                                 Email, 
                                                 MailingPostalCode,
                                                 FirstName,
                                                 LastName,
                                                 Name,
                                                 Zip_Code__c,
                                                 Birthdate,
                                                 isHousehold__c,
                                                 Registration_Code__c
                                                 FROM Contact 
                                                 WHERE LastName = :lastName
                                                 AND Birthdate = :birthDate
                                                 AND Zip_Code__c = :zipcode
                                                 AND Registration_Code__c = :regId];
                                               
                                                 
         //  ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO,'contactMatch list = '+contactMatch +',lastName = '+lastName+',birthdate = '+birthDate+',zipcode = '+zipcode+',regId = '+regId));
           // System.debug('************contactMatch '+contactMatch );
            List<User> emailMatch = [Select Id,
                                            Username
                                            FROM User
                                            WHERE Username = :userName];

            List<User> newUserList = new List<User>();
            List<Contact> conToUpdate = new List<Contact>(); 
            
            if(appType==StringConstants.NEW_APPLICANT_YES){
                if(emailMatch.size() > 0){          //check if there is a matching username
                    Registrant_Setup_Request__c multipleMatches = new Registrant_Setup_Request__c();
                    multipleMatches.Link_to_Possible_Contact_or_User_1__c = 'https://cs18.salesforce.com/' + emailMatch[0].id;
                    if (emailMatch.size() > 1){ 
                        multipleMatches.Link_to_Possible_Contact_or_User_2__c = 'https://cs18.salesforce.com/' + emailMatch[1].id;
                    }
                    multipleMatches.Birthdate__c = birthdate;
                    multipleMatches.Current_Zipcode__c =  zipcode;
                    multipleMatches.Email__c = email;
                    multipleMatches.First_Name__c = firstName;
                    multipleMatches.Last_Name__c = lastName;
                    multipleMatches.Registration_Code__c = regId;
                    multipleMatches.NewtoProgram__c = true;
                    multipleMatches.Reason__c = emailMatch.size() + ' ' + StringConstants.REASON_DUPLICATE_USERNAME_EMAIL;            
                     
                    if(multipleMatches != null){
                       insert multipleMatches;

                       PageReference page = System.Page.SfmohprogramsNewtoMOHCDButContactMatch;        
                       page.setRedirect(true);
                       return page;
                    
                    }

                }


                if(contactMatch.size() == 1){  
                    
                    for(Contact con : contactMatch){
                        
                        User newUser = new User();
                        newUser.FirstName = firstName;
                        newUser.LastName = lastName;
                        newUser.CommunityNickname = email+zipcode;
                        newUser.Email = email;
                        newUser.EmailEncodingKey = 'ISO-8859-1';            //create user
                        newUser.Username = email;
                        newUser.ProfileId = profileId.Id;
                        newUser.ContactId = con.Id;
                        String alias = firstName.substring(0); + lastName.substring(0, 3);
                        newUser.Alias = alias;
                        newUser.LanguageLocaleKey = 'en_US';
                        newUser.LocaleSidKey = 'en_US';
                        newUser.TimeZoneSidKey = 'America/Los_Angeles';
                        newUserList.add(newUser);
                        
                        con.FirstName = firstName;    
                        con.LastName = lastName;
                        con.Zip_Code__c = zipcode;          //update related contact
                        con.Birthdate = birthDate;
                        con.isHousehold__c = true;
                        con.Primary_Household_Member__c = true;
                        conToUpdate.add(con);
                        
                    }

                    try {

                                insert newUserList;
                                update conToUpdate;

                   //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+newUserList));
                        
                    // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+conToUpdate));
                        
                        
                    } catch (Exception e) {
                  //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'KEMBOT NA DITEY'+e));
                        System.debug(e);
                      }
                    
                    
                    if (newUserList != null && !newUserList.isEmpty()) { 
                        PageReference page = System.Page.CommunitiesSelfRegConfirm;
                        page.setRedirect(true);
                        return page;
                        
                    }
                    
    
                }
                else if (contactMatch.size() > 1){
                    
                    if(counter==2){                       
                                   
                            Registrant_Setup_Request__c multipleMatches = new Registrant_Setup_Request__c();
                            multipleMatches.Link_to_Possible_Contact_or_User_1__c = 'https://cs18.salesforce.com/' + contactMatch[0].id;
                            multipleMatches.Link_to_Possible_Contact_or_User_2__c = 'https://cs18.salesforce.com/' + contactMatch[1].id;
                            multipleMatches.Birthdate__c = birthdate;
                            multipleMatches.Current_Zipcode__c =  zipcode;
                            multipleMatches.Email__c = email;
                            multipleMatches.First_Name__c = firstName;
                            multipleMatches.Last_Name__c = lastName;
                            multipleMatches.Registration_Code__c = regId;
                            multipleMatches.NewtoProgram__c = true;
                            multipleMatches.Reason__c = contactMatch.size() + ' ' + StringConstants.REASON_NOT_ONLY_ONE_MATCHING_CONTACT;            
                         
                            if(multipleMatches != null){
                               insert multipleMatches;

                               PageReference page = System.Page.SfmohprogramsMultipleContMatch;        
                               page.setRedirect(true);
                               return page;
                        
                            }
                    }
                    else{
                        counter = counter + 1;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Multiple matches found.  Please check your inputs for typos, or add an SFMOHCD registration code and try again.'));
                    }
                    
                    
                }
                else if(contactMatch.size() == 0){
                        if(counter==2){

                            Registrant_Setup_Request__c multipleMatches = new Registrant_Setup_Request__c();
                            multipleMatches.Birthdate__c = birthdate;
                            multipleMatches.Current_Zipcode__c =  zipcode;
                            multipleMatches.Email__c = email;
                            multipleMatches.First_Name__c = firstName;
                            multipleMatches.Last_Name__c = lastName;
                            multipleMatches.Registration_Code__c = regId;
                            multipleMatches.NewtoProgram__c = true;
                            multipleMatches.Reason__c = contactMatch.size() + ' ' + StringConstants.REASON_NOT_ONLY_ONE_MATCHING_CONTACT;            
                         
                            if(multipleMatches != null){
                               insert multipleMatches;

                               PageReference page = System.Page.SfmohprogramsMultipleContMatch;        
                               page.setRedirect(true);
                               return page;
                        
                            }
                    }
                    else if(regId != ''){
                        counter = counter + 1;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No match found.  Please check your inputs for typos, or remove the registration code and try again.'));
                        
                    }
                    else if(regId == ''){
                        List<Contact> contactMatchnoregId = [SELECT Id,
                                                                    Email, 
                                                                    MailingPostalCode,
                                                                    FirstName,
                                                                    LastName,
                                                                    Name,
                                                                    Zip_Code__c,
                                                                    Birthdate,
                                                                    isHousehold__c,
                                                                    Registration_Code__c
                                                                    FROM Contact 
                                                                    WHERE Birthdate = :birthDate
                                                                    AND MailingPostalCode = :zipcode
                                                                    AND LastName = :lastName];
    
                        if (contactMatchnoregId.size() == 0){
                            counter = counter + 1;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No match found.  Please check your inputs for typos, or remove the registration code and try again.'));
                        }
                        else if(contactMatchnoregId.size() == 1){
                            for(Contact con : contactMatchnoregId){
                        
                                //Create new user record
                                User newUser = new User();
                                newUser.FirstName = firstName;
                                newUser.LastName = lastName;
                                newUser.CommunityNickname = email+zipcode;
                                newUser.Email = email;
                                newUser.EmailEncodingKey = 'ISO-8859-1';
                                newUser.Username = email;
                                newUser.ProfileId = profileId.Id;
                                newUser.ContactId = con.Id;
                                String alias = firstName.substring(0); + lastName.substring(0, 3);
                                newUser.Alias = alias;
                                newUser.LanguageLocaleKey = 'en_US';
                                newUser.LocaleSidKey = 'en_US';
                                newUser.TimeZoneSidKey = 'America/Los_Angeles';
                                newUserList.add(newUser);
                        
                                con.FirstName = firstName;    
                                con.LastName = lastName;
                                con.Zip_Code__c = zipcode;
                                con.Birthdate = birthDate;
                                con.isHousehold__c = true;
                                con.Primary_Household_Member__c = true;
                                conToUpdate.add(con);
                        
                            }
                            try {
                        
                                    insert newUserList;
                                    update conToUpdate;
                                    
                            }
                        
                      
                                catch (Exception e) {
                                  
                                  System.debug(e);
                                }
                    
                    
                            if (newUserList != null && !newUserList.isEmpty()) { 
                                PageReference page = System.Page.CommunitiesSelfRegConfirm;
                                page.setRedirect(true);
                                return page;
                        
                            }
                        }
                        else if (contactMatchnoregId.size() > 1){
                            counter = counter + 1;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Multiple matches found.  Please check your inputs for typos, or add an SFMOHCD registration code and try again.'));
                        }
                                                
                    }   

                }

            }
            else if(appType==StringConstants.NEW_APPLICANT_NO){
                List<Contact> contactMatchnoregId = [SELECT Id,
                                                            Email, 
                                                            MailingPostalCode,
                                                            FirstName,
                                                            LastName,
                                                            Name,
                                                            Zip_Code__c,
                                                            Birthdate,
                                                            isHousehold__c,
                                                            Registration_Code__c
                                                            FROM Contact 
                                                            WHERE Birthdate = :birthDate
                                                            AND MailingPostalCode = :zipcode
                                                            AND LastName = :lastName];
                if(emailMatch.size() > 0){          //check if there is matching username
                    Registrant_Setup_Request__c multipleMatches = new Registrant_Setup_Request__c();
                    multipleMatches.Link_to_Possible_Contact_or_User_1__c = 'https://cs18.salesforce.com/' + emailMatch[0].id;
                    if (emailMatch.size() > 1){ 
                        multipleMatches.Link_to_Possible_Contact_or_User_2__c = 'https://cs18.salesforce.com/' + emailMatch[1].id;
                    }
                    multipleMatches.Birthdate__c = birthdate;
                    multipleMatches.Current_Zipcode__c =  zipcode;
                    multipleMatches.Email__c = email;
                    multipleMatches.First_Name__c = firstName;
                    multipleMatches.Last_Name__c = lastName;
                    multipleMatches.Registration_Code__c = regId;
                    multipleMatches.NewtoProgram__c = true;
                    multipleMatches.Reason__c = emailMatch.size() + ' ' + StringConstants.REASON_DUPLICATE_USERNAME_EMAIL;            
                     
                    if(multipleMatches != null){
                       insert multipleMatches;

                       PageReference page = System.Page.SfmohprogramsNewtoMOHCDButContactMatch;        
                       page.setRedirect(true);
                       return page;
                    
                    }

                }                                            
                if (contactMatchnoregId.size() > 0){
                        
                        Registrant_Setup_Request__c multipleMatches = new Registrant_Setup_Request__c();
                        multipleMatches.Link_to_Possible_Contact_or_User_1__c = 'https://cs18.salesforce.com/' + contactMatchnoregId[0].id;
                        if (contactMatchnoregId.size() > 1){ 
                            multipleMatches.Link_to_Possible_Contact_or_User_2__c = 'https://cs18.salesforce.com/' + contactMatchnoregId[1].id;
                        }
                        multipleMatches.Birthdate__c = birthdate;
                        multipleMatches.Current_Zipcode__c =  zipcode;
                        multipleMatches.Email__c = email;
                        multipleMatches.First_Name__c = firstName;
                        multipleMatches.Last_Name__c = lastName;
                        multipleMatches.Registration_Code__c = regId;
                        multipleMatches.NewtoProgram__c = true;
                        multipleMatches.Reason__c = contactMatchnoregId.size() + ' ' + StringConstants.REASON_NOT_ONLY_ONE_MATCHING_CONTACT;            
                         
                        if(multipleMatches != null){
                           insert multipleMatches;

                           PageReference page = System.Page.SfmohprogramsNewtoMOHCDButContactMatch;        
                           page.setRedirect(true);
                           return page;
                        
                        }
                }
                else if(contactMatchnoregId.size() == 0){
                    try {
                    
                        List<Contact> newContactList = new List<Contact>();
                        Contact newCon = new Contact();
                        newCon.FirstName = firstName;
                        newCon.LastName = lastName;
                        newCon.AccountId = accId.Id;
                        newCon.Email = email;
                        newCon.Zip_Code__c = zipcode;
                        newCon.Birthdate = birthDate;
                        newCon.isHousehold__c = true;
                        newContactList.add(newCon);
                        
                        if(!newContactList.isEmpty()){
                            insert newContactList;
                        }
                        
                        for(Contact con : newContactList){
                            if(con.Id != null){
                                User newUser = new User();
                                newUser.FirstName = firstName;
                                newUser.LastName = lastName;
                                newUser.CommunityNickname = email+zipcode;
                                newUser.Email = email;
                                newUser.EmailEncodingKey = 'ISO-8859-1';
                                newUser.Username = email;
                                newUser.ProfileId = profileId.Id;
                                newUser.ContactId = con.Id;
                                String alias = firstName.substring(0); + lastName.substring(0, 3);
                                newUser.Alias = alias;
                                newUser.LanguageLocaleKey = 'en_US';
                                newUser.LocaleSidKey = 'en_US';
                                newUser.TimeZoneSidKey = 'America/Los_Angeles';
                                newUserList.add(newUser);
                            }
                        }
    
                        if(!newUserList.isEmpty()){
                            insert newUserList;
                        }
                    }
                    catch (Exception e) {
                    System.debug(e);
                    }
                    
                    if (newUserList != null) { 
                    PageReference page = System.Page.CommunitiesSelfRegConfirm;
                    page.setRedirect(true);
                    return page;
                    
                    }    
                    
                        
                }
                
          
                
            }
    
            
       }
        
       return null; 
    }   
    
    
    
    
    public List<SelectOption> getType() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption(StringConstants.NEW_APPLICANT_YES,StringConstants.NEW_APPLICANT_YES)); 
        options.add(new SelectOption(StringConstants.NEW_APPLICANT_NO,StringConstants.NEW_APPLICANT_NO)); 
        
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
   */
}