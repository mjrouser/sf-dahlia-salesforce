/**
 * @author:      Ronald Martinez
 * @date:        07/21/2014
 * @description: Apex class for mohcdEAHP
 * @history:     06/10/2015 - Heidi Tang - Edited
*/ 
public with sharing class CS_MOHCDEAHPCC{
    public String strCurrAddress {get; set;}
    public String strEmailAddress {get; set;}
    public String strReqMailAddress {get; set;}
    public String strPhone {get; set;}
    public String strEvictionAddress {get; set;}
    public String strEveningPhone {get; set;}
    public String strLived10Years {get; set;}
    public String strDateNOI {get; set;}
    public String strLived5Years {get; set;}
    public String strDisabled {get; set;}
    public String strLanguage {get; set;}
    public String strIllness {get; set;}
    public String strGender {get; set;}
    public Decimal dcGAI {get; set;}
    public Integer iAge {get; set;}
    public Integer iHouseholdSize {get; set;}
    public String strEthnicity {get; set;}
    public String selValue {get; set;}
    public String strPhysicianName {get; set;}
    public String strPhysicianPhone {get; set;}
    public String strPhysicianOffice {get; set;}
    public String strHealthProvider {get; set;}
    public String strHealthInsuranceId {get; set;}    
    public Id EAHPId {get; set;}
    public Date dtMoveIn {get; set;}
    public Integer moveInMonth {get;set;}
    public Integer moveInDay {get;set;}
    public Integer moveInYear {get;set;}
    public Date dtNOI {get; set;}
    public Integer NOIMonth {get;set;}
    public Integer NOIDay {get;set;}
    public Integer NOIYear {get;set;}
    public Date dtMoveOut {get; set;}
    public Integer moveOutMonth {get;set;}
    public Integer moveOutDay {get;set;}
    public Integer moveOutYear {get;set;}
    public Date dtPatientBirth {get; set;}
    public Integer birthMonth {get;set;}
    public Integer birthDay {get;set;}
    public Integer birthYear {get;set;}    
    public Integer currentMonth {get;set;}
    public Integer currentDay {get;set;}
    public Integer currentYear {get;set;}
    public String strSexualOrientation {get; set;}
    public Boolean question3Visibility {get; set;}
    
    //Constructor
    public CS_MOHCDEAHPCC() {
        EAHPId = System.currentPageReference().getParameters().get(StringConstants.PARAM_ID);    
    }
    
    public List<SelectOption> getPicklist() {        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.SELECT_OPTION,Label.SELECT_OPTION));
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        
        return options;
    }  

    public List<SelectOption> getHouseholdSize() {        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','0'));
        options.add(new SelectOption('1','1'));
        options.add(new SelectOption('2','2'));
        options.add(new SelectOption('3','3'));
        options.add(new SelectOption('4','4'));
        options.add(new SelectOption('5','5'));
        options.add(new SelectOption('6','6'));
        options.add(new SelectOption('7','7'));
        options.add(new SelectOption('8','8'));
        options.add(new SelectOption('9','9'));
        options.add(new SelectOption('10','10'));
        return options;
    }  
    
    public List<SelectOption> getGender() {        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.SELECT_OPTION,Label.SELECT_OPTION));
        options.add(new SelectOption('Male','Male'));
        options.add(new SelectOption('Female','Female'));
        options.add(new SelectOption('Transgender','Transgender'));
        options.add(new SelectOption('Do Not Identify as Male, Female, or Transgender','Do Not Identify as Male, Female, or Transgender'));
        return options;
    }
    
    public List<SelectOption> getEthnicity() {        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.SELECT_OPTION,Label.SELECT_OPTION));
        options.add(new SelectOption('American Indian or Alaskan Native','American Indian or Alaskan Native'));
        options.add(new SelectOption('American Indian or Alaskan Native - Hispanic','American Indian or Alaskan Native - Hispanic'));
        options.add(new SelectOption('American Indian or Alaskan Native AND Black','American Indian or Alaskan Native AND Black'));
        options.add(new SelectOption('American Indian or Alaskan Native AND Black-Hispanic','American Indian or Alaskan Native AND Black-Hispanic'));
        options.add(new SelectOption('American Indian or Alaskan Native AND White','American Indian or Alaskan Native AND White'));
        options.add(new SelectOption('American Indian or Alaskan Native AND White-Hispanic','American Indian or Alaskan Native AND White-Hispanic'));
        options.add(new SelectOption('Asian','Asian'));
        options.add(new SelectOption('Asian-Hispanic','Asian-Hispanic'));
        options.add(new SelectOption('Asian AND White','Asian AND White'));
        options.add(new SelectOption('Asian AND White-Hispanic','Asian AND White-Hispanic'));
        options.add(new SelectOption('Black or African American','Black or African American'));
        options.add(new SelectOption('Black or African American-Hispanic','Black or African American-Hispanic'));
        options.add(new SelectOption('Black or African American AND White','Black or African American AND White'));
        options.add(new SelectOption('Black or African American AND White-Hispanic','Black or African American AND White-Hispanic'));
        options.add(new SelectOption('Native Hawaiian or Pacific Islander','Native Hawaiian or Pacific Islander'));
        options.add(new SelectOption('Native Hawaiian or Pacific Islander-Hispanic','Native Hawaiian or Pacific Islander-Hispanic'));
        options.add(new SelectOption('Other','Other'));
        options.add(new SelectOption('Other-Hispanic','Other-Hispanic'));
        options.add(new SelectOption('White','White'));
        options.add(new SelectOption('White-Hispanic','White-Hispanic'));
        return options;
    }
    
    public List<SelectOption> getLanguage() {        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.SELECT_OPTION,Label.SELECT_OPTION));
        options.add(new SelectOption('English','English'));
        options.add(new SelectOption('Alabama','Alabama'));
        options.add(new SelectOption('Albanian','Albanian'));
        options.add(new SelectOption('Algonquian','Algonquian'));
        options.add(new SelectOption('Amharic','Amharic'));
        options.add(new SelectOption('Apache','Apache'));
        options.add(new SelectOption('Arabic','Arabic'));
        options.add(new SelectOption('Arawakan','Arawakan'));
        options.add(new SelectOption('Armenian','Armenian'));
        options.add(new SelectOption('Athapaskan','Athapaskan'));
        options.add(new SelectOption('Aymara','Aymara'));
        options.add(new SelectOption('Azerbaijani','Azerbaijani'));
        options.add(new SelectOption('Baltic','Baltic'));
        options.add(new SelectOption('Barea','Barea'));
        options.add(new SelectOption('Bengali','Bengali'));
        options.add(new SelectOption('Blackfoot','Blackfoot'));
        options.add(new SelectOption('Bontoc','Bontoc'));
        options.add(new SelectOption('Bulgarian','Bulgarian'));
        options.add(new SelectOption('Buryat','Buryat'));
        options.add(new SelectOption('Cambodian','Cambodian'));
        options.add(new SelectOption('Canadian','Canadian'));
        options.add(new SelectOption('Cariban','Cariban'));
        options.add(new SelectOption('Celtic','Celtic'));
        options.add(new SelectOption('Chamorro','Chamorro'));
        options.add(new SelectOption('Cheremis','Cheremis'));
        options.add(new SelectOption('Cherokee','Cherokee'));
        options.add(new SelectOption('Cheyenne','Cheyenne'));
        options.add(new SelectOption('Chinese-Cantonese','Chinese-Cantonese'));
        options.add(new SelectOption('Chinese-Hakka','Chinese-Hakka'));
        options.add(new SelectOption('Chinese-Mandarin','Chinese-Mandarin'));
        options.add(new SelectOption('Chinese-Mandarin','Chinese-Mandarin'));
        options.add(new SelectOption('Chinese-Min','Chinese-Min'));
        options.add(new SelectOption('Chinese-Tsou','Chinese-Tsou'));
        options.add(new SelectOption('Chinese-Wu','Chinese-Wu'));
        options.add(new SelectOption('Chinese-Xiang','Chinese-Xiang'));
        options.add(new SelectOption('Chinese-Yue','Chinese-Yue'));
        options.add(new SelectOption('Comanche','Comanche'));
        options.add(new SelectOption('Cree','Cree'));
        options.add(new SelectOption('Creek','Creek'));
        options.add(new SelectOption('Czech','Czech'));
        options.add(new SelectOption('Dagur','Dagur'));
        options.add(new SelectOption('Dinka','Dinka'));
        options.add(new SelectOption('Dutch','Dutch'));
        options.add(new SelectOption('East','East'));
        options.add(new SelectOption('Estonian','Estonian'));
        options.add(new SelectOption('Finnish','Finnish'));
        options.add(new SelectOption('French','French'));
        options.add(new SelectOption('German','German'));
        options.add(new SelectOption('Greek','Greek'));
        options.add(new SelectOption('Gujarati','Gujarati'));
        options.add(new SelectOption('Hawaiian','Hawaiian'));
        options.add(new SelectOption('Hebrew','Hebrew'));
        options.add(new SelectOption('Hindi','Hindi'));
        options.add(new SelectOption('Hokan','Hokan'));
        options.add(new SelectOption('Hopi','Hopi'));
        options.add(new SelectOption('Hungarian','Hungarian'));
        options.add(new SelectOption('Ilocano','Ilocano'));
        options.add(new SelectOption('Inupiaq','Inupiaq'));
        options.add(new SelectOption('Iroquoian','Iroquoian'));
        options.add(new SelectOption('Italian','Italian'));
        options.add(new SelectOption('Javanese','Javanese'));
        options.add(new SelectOption('Kalmuck','Kalmuck'));
        options.add(new SelectOption('Kalmyk','Kalmyk'));
        options.add(new SelectOption('Kannada','Kannada'));
        options.add(new SelectOption('Karelian','Karelian'));
        options.add(new SelectOption('Kazakh','Kazakh'));
        options.add(new SelectOption('Kirghiz','Kirghiz'));
        options.add(new SelectOption('Koman','Koman'));
        options.add(new SelectOption('Kongo','Kongo'));
        options.add(new SelectOption('Korean','Korean'));
        options.add(new SelectOption('Kunema','Kunema'));
        options.add(new SelectOption('Lakhota','Lakhota'));
        options.add(new SelectOption('Latin','Latin'));
        options.add(new SelectOption('Livonian','Livonian'));
        options.add(new SelectOption('Lulubo','Lulubo'));
        options.add(new SelectOption('Mabaan','Mabaan'));
        options.add(new SelectOption('Madi','Madi'));
        options.add(new SelectOption('Makua','Makua'));
        options.add(new SelectOption('Malagasy','Malagasy'));
        options.add(new SelectOption('Malayalam','Malayalam'));
        options.add(new SelectOption('Maltese','Maltese'));
        options.add(new SelectOption('Maori','Maori'));
        options.add(new SelectOption('Marathi','Marathi'));
        options.add(new SelectOption('Melanesian','Melanesian'));
        options.add(new SelectOption('Mikasuki','Mikasuki'));
        options.add(new SelectOption('Mogol','Mogol'));
        options.add(new SelectOption('Mohawk','Mohawk'));
        options.add(new SelectOption('Mon','Mon'));
        options.add(new SelectOption('Mongolian','Mongolian'));
        options.add(new SelectOption('Monguor','Monguor'));
        options.add(new SelectOption('Mordvin','Mordvin'));
        options.add(new SelectOption('Moru','Moru'));
        options.add(new SelectOption('Munda','Munda'));
        options.add(new SelectOption('Muskogean','Muskogean'));
        options.add(new SelectOption('Nahuatl','Nahuatl'));
        options.add(new SelectOption('Navajo','Navajo'));
        options.add(new SelectOption('Nicobarese','Nicobarese'));
        options.add(new SelectOption('Ojibwa','Ojibwa'));
        options.add(new SelectOption('Onodaga','Onodaga'));
        options.add(new SelectOption('Ostyak','Ostyak'));
        options.add(new SelectOption('Paiute','Paiute'));
        options.add(new SelectOption('Pari','Pari'));
        options.add(new SelectOption('Penitian','Penitian'));
        options.add(new SelectOption('Persian','Persian'));
        options.add(new SelectOption('Polish','Polish'));
        options.add(new SelectOption('Portuguese','Portuguese'));
        options.add(new SelectOption('Punjabi','Punjabi'));
        options.add(new SelectOption('Quechua','Quechua'));
        options.add(new SelectOption('Russian','Russian'));
        options.add(new SelectOption('Rwanda','Rwanda'));
        options.add(new SelectOption('Salish','Salish'));
        options.add(new SelectOption('Sami','Sami'));
        options.add(new SelectOption('Samoan','Samoan'));
        options.add(new SelectOption('Santa','Santa'));
        options.add(new SelectOption('Scandinavian','Scandinavian'));
        options.add(new SelectOption('Seminole','Seminole'));
        options.add(new SelectOption('Serbo','Serbo'));
        options.add(new SelectOption('Slovak','Slovak'));
        options.add(new SelectOption('Spanish','Spanish'));
        options.add(new SelectOption('Sudanic','Sudanic'));
        options.add(new SelectOption('Swahili','Swahili'));
        options.add(new SelectOption('Swedish','Swedish'));
        options.add(new SelectOption('Tagalog','Tagalog'));
        options.add(new SelectOption('Tahitian','Tahitian'));
        options.add(new SelectOption('Tamil','Tamil'));
        options.add(new SelectOption('Tatar','Tatar'));
        options.add(new SelectOption('Telugu','Telugu'));
        options.add(new SelectOption('Thai','Thai'));
        options.add(new SelectOption('Tibetan','Tibetan'));
        options.add(new SelectOption('Tongan','Tongan'));
        options.add(new SelectOption('Truk','Truk'));
        options.add(new SelectOption('Tucanoan','Tucanoan'));
        options.add(new SelectOption('Tupi','Tupi'));
        options.add(new SelectOption('Turkish','Turkish'));
        options.add(new SelectOption('Turkoman','Turkoman'));
        options.add(new SelectOption('Uighur','Uighur'));
        options.add(new SelectOption('Ukrainian','Ukrainian'));
        options.add(new SelectOption('Urdu','Urdu'));
        options.add(new SelectOption('Uto','Uto'));
        options.add(new SelectOption('Uzbek','Uzbek'));
        options.add(new SelectOption('Veps','Veps'));
        options.add(new SelectOption('Vietnamese','Vietnamese'));
        options.add(new SelectOption('Vogul','Vogul'));
        options.add(new SelectOption('Votyak','Votyak'));
        options.add(new SelectOption('Xhosa','Xhosa'));
        options.add(new SelectOption('Yap','Yap'));
        options.add(new SelectOption('Yup','Yup'));
        options.add(new SelectOption('Zulu','Zulu'));
        options.add(new SelectOption('Zyrian','Zyrian'));
        return options;
    }
    
    public List<SelectOption> getSexualOrientation() {        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.SELECT_OPTION,Label.SELECT_OPTION));
        options.add(new SelectOption('Lesbian','Lesbian'));
        options.add(new SelectOption('Gay','Gay'));
        options.add(new SelectOption('Bisexual','Bisexual'));
        options.add(new SelectOption('Heterosexual','Heterosexual'));
        options.add(new SelectOption('Do Not Identify as Lesbian, Gay, Bisexual or Heterosexual','Do Not Identify as Lesbian, Gay, Bisexual or Heterosexual'));
        options.add(new SelectOption('Decline to State','Decline to State'));
        return options;
    }
    
    public PageReference submitRequest(){
        RecordType oRecType = [Select Id from RecordType where SobjectType =: 'Certificate_Program__c' AND Name =: 'EAHP'];
        User oUser = [Select Id, ContactId from User where Id =: UserInfo.getUserId()];
        Contact oCon = [Select Id, AccountId from Contact where Id =: oUser.ContactId];
        Boolean dateError = FALSE;
        
        //Move In
        if((moveInMonth != null && (moveInDay == null || moveInYear== null)) || (moveInYear != null && (moveInDay == null || moveInMonth == null))  ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ERROR_PROVIDE_INFO+' '+StringConstants.EAHP_MOVE_IN));
            dateError = TRUE;
        }
        
        //NOI
        if((NOIMonth != null && (NOIDay == null || NOIYear== null)) || (NOIYear != null && (NOIDay == null || NOIMonth == null))  ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ERROR_PROVIDE_INFO+' '+StringConstants.EAHP_NOI));
            dateError = TRUE;
        }
        
        //Move Out
        if((moveOutMonth != null && (moveOutDay == null || moveOutYear== null)) || (moveOutYear != null && (moveOutDay == null || moveOutMonth == null))  ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ERROR_PROVIDE_INFO+' '+StringConstants.EAHP_MOVE_OUT));
            dateError = TRUE;
        }
        
        //Patient Birth
        if((birthMonth != null && (birthDay == null || birthYear== null)) || (birthYear != null && (birthDay == null || birthMonth == null))  ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ERROR_PROVIDE_INFO+' '+StringConstants.EAHP_BIRTHDATE));
            dateError = TRUE;
        }
        if(dateError == FALSE){
            if(moveInMonth != null && moveInDay != null && moveInYear != null){
                dtMoveIn = date.newinstance(moveInYear, moveInMonth, moveInDay);
            }
            else{
                dtMoveIn = null;
            }
            
            if(NOIMonth != null && NOIDay != null && NOIYear != null){
                dtNOI = date.newinstance(NOIYear, NOIMonth, NOIDay);
            }
            else{
                dtNOI = null;
            }
            
            if(moveOutMonth != null && moveOutDay != null && moveOutYear != null){
                dtMoveOut = date.newinstance(moveOutYear, moveOutMonth, moveOutDay);
            }
            else{
                dtMoveOut = null;
            }
            
            if(birthMonth != null && birthDay != null && birthYear != null){
                dtPatientBirth= date.newinstance(birthYear, birthMonth, birthDay);
            }
            else{
                dtPatientBirth= null;
            }
            
            Certificate_Program__c oEAHP = new Certificate_Program__c(RecordTypeId = oRecType.Id, 
                                            Household_Account__c = oCon.AccountId,
                                            Household_Contact__c = oCon.Id,
                                            Application_Status__c = 'Submitted',
                                            Submit_Date__c = System.Today(),                                        
                                            Current_Address__c = strCurrAddress,
                                            Email_Address__c = strEmailAddress,
                                            //Requester_s_Mailing_Address__c = strReqMailAddress,
                                            Telephone_Number__c = strPhone,
                                            Address_that_Ellis_Act_Eviction_Occurred__c = strEvictionAddress,
                                            Evening_Phone__c = strEveningPhone,
                                            Date_of_Move_In__c = dtMoveIn,
                                            Lived_at_displaced_address_for_10_years__c = strLived10Years,
                                            Date_NOI_was_Filed__c = dtNOI,
                                            Is_the_date_of_tenancy_commenced_on_NOI__c = strDateNOI,
                                            Date_of_Move_Out__c = dtMoveOut,
                                            Lived_at_displaced_address_for_5_years__c = strLived5Years,
                                            Are_you_Disabled__c = strDisabled,
                                            Primary_Language__c = strLanguage,
                                            Do_you_have_a_life_threatening_illness__c = strIllness,
                                            Gender__c = strGender,
                                            Gross_Annual_Income__c = dcGAI,
                                            Age__c = iAge,
                                            Household_Size__c = iHouseholdSize,
                                            Race_Ethnicity__c = strEthnicity,
                                            Name_of_Physician_Releasing_Information__c = strPhysicianName,
                                            Physician_s_Phone_Number__c = strPhysicianPhone,
                                            Physician_s_Office_Address__c = strPhysicianOffice,
                                            Patient_Birthdate__c = dtPatientBirth,
                                            Name_of_Health_Insurance_Provider__c = strHealthProvider,
                                            Health_Insurance_ID__c = strHealthInsuranceId,
                                            Sexual_Orientation__c = strSexualOrientation
                                            );
                                            
           insert oEAHP;
           EAHPId = oEAHP.Id;
           PageReference pageRef = new PageReference('/housingprograms/mohcdEAHPPrintandSign'); 
           pageRef.getParameters().put(StringConstants.PARAM_ID,EAHPId);
           pageRef.setRedirect(true);
           return pageRef;
       }
       return null;
    }
    
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
            //Move In
           if(moveInMonth==2) {
                for(integer i=1;i<=28;i++) {
                    options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
                }
           } else if(moveInMonth==4 || moveInMonth==6 || moveInMonth==9 || moveInMonth==11) {
                for(integer i=1;i<=30;i++) {
                    options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
                }
           } else if(moveInMonth==1 || moveInMonth==3 || moveInMonth==5 || moveInMonth==7 || moveInMonth==8 || moveInMonth==10 || moveInMonth==12) {
                for(integer i=1;i<=31;i++) {
                    options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
                }
           }
           
           //NOI
           if(NOIMonth==2) {
                for(integer i=1;i<=28;i++) {
                    options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
                }
           } else if(NOIMonth==4 || NOIMonth==6 || NOIMonth==9 || NOIMonth==11) {
                for(integer i=1;i<=30;i++) {
                    options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
                }
           } else if(NOIMonth==1 || NOIMonth==3 || NOIMonth==5 || NOIMonth==7 || NOIMonth==8 || NOIMonth==10 || NOIMonth==12) {
                for(integer i=1;i<=31;i++) {
                    options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
                }
           }
           
           //Move Out
           if(moveOutMonth==2) {
                for(integer i=1;i<=28;i++) {
                    options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
                }
           } else if(moveOutMonth==4 || moveOutMonth==6 || moveOutMonth==9 || moveOutMonth==11) {
                for(integer i=1;i<=30;i++) {
                    options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
                }
           } else if(moveOutMonth==1 || moveOutMonth==3 || moveOutMonth==5 || moveOutMonth==7 || moveOutMonth==8 || moveOutMonth==10 || moveOutMonth==12) {
                for(integer i=1;i<=31;i++) {
                    options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
                }
           }           
           
           //Patient's birthdate
           if(birthMonth==2) {
                for(integer i=1;i<=28;i++) {
                    options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
                }
           } else if(birthMonth==4 || birthMonth==6 || birthMonth==9 || birthMonth==11) {
                for(integer i=1;i<=30;i++) {
                    options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
                }
           } else if(birthMonth==1 || birthMonth==3 || birthMonth==5 || birthMonth==7 || birthMonth==8 || birthMonth==10 || birthMonth==12) {
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
            for(integer i=1950;i<=j;i++) {
                options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
            }
         return options;
   }
   
   public List<SelectOption> getyearsNOIList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--Year--'));
        integer j = system.Today().year();
            for(integer i=2012;i<=j;i++) {
                options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
            }
         return options;
   }
}