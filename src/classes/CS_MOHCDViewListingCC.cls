/*
* @auther : Cloud Sherpas Inc.
* @date : 09/23/2014
* @description : An apex page controller for mohcdViewListing VF Page.
*/  
public class CS_MOHCDViewListingCC {
    
    String radio = '0';        //for radiobuttons
    public List<Properties__c> lUnits {get; set;}         //For List of Units
    public Properties__c prop {get;set;}
    public Boolean isSubmitted {get;set;}

    public CS_MOHCDViewListingCC(ApexPages.StandardController controller) {
        prop = (Properties__c)controller.getRecord();
        isSubmitted = false;
        prop = [SELECT Id, Property_Name__c FROM Properties__c WHERE Id = : prop.Id];
        System.debug(' ~~ id : ' + prop.Id);
        System.debug(' ~~ parentPropName : ' + prop.Property_Name__c);
        
        lUnits = [SELECT Id, Name, Unit_Number__c, of_Bedrooms__c, of_Bathrooms__c, Unit_Square_Footage__c, Price_With_Parking__c,
            Price_Without_Parking__c, Maximum_AMI__c, Final_Monthly_HOA_Amount_Without_Parking__c, Final_Monthly_HOA_Amount_With_Parking__c,
            MLS__c, MLS_Listing_Link__c, Monthly_Rent__c, Minimum_Monthly_Household_Income_Needed__c, Required_Deposit_Amount__c, Parking_Price_for_Rental_Units__c,
            Monthly_HOA_Dues__c, Parking_Space_Price_Inclusion_Sales__c, Number_of_Parking_Spaces__c, Parent_Property_Name__c, Price__c
            FROM Properties__c WHERE RecordType.Name = : 'Unit' AND Parent_Property_Name__c = : prop.Property_Name__c];
        
        System.debug(' ~~ list size : ' + lUnits.size());
    }
    
    public PageReference checkPoint(){
        if(Userinfo.getUserType().equals('Guest')){
           PageReference pref = new PageReference('/housingprograms/mohcdLoginDirect?propid='+prop.Id);
           pref.setRedirect(true);
           return pref;
        }else{
           List<User> users = new List<User>([SELECT ContactId FROM User WHERE Id =:Userinfo.getUserId()]);
           List<Contact> contacts = [Select AccountId FROM Contact WHERE Id = :users[0].ContactId];            
           List<Housing_Application__c> hApps = new List<Housing_Application__c>([SELECT Id FROM Housing_Application__c WHERE Household_Account__c =: contacts[0].AccountId AND Application_Status__c = 'Submitted']);
            
           if(hApps.size()!=0){
               isSubmitted = true;
           }else{
               PageReference pref = new PageReference('/housingprograms/mohcdHousingApp?pid='+prop.Id);
               pref.setRedirect(true);
               return pref;       
           }  
           //PageReference pref = new PageReference('/housingprograms/mohcdHousingApp?pid='+prop.Id);
               //pref.setRedirect(true);
               //return pref;           
           return null;
        }
    }
    //for radiobuttons in popup window
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('0','Pre-fill my household information'));  
        options.add(new SelectOption('1','Start over with a blank Housing Application')); return options; 
    }
    
    public void closePopUp(){
        isSubmitted = false;
    }
    
    public String getRadio() {
        return radio;
    }
                    
    public void setRadio(String radio) { this.radio = radio; }
    
    public PageReference onNext(){
        try{
            if(radio=='0'){
                prefillHousingApp();
                PageReference pref = new PageReference('/housingprograms/mohcdHousingApp?pid='+prop.Id+'&copy=1');
                pref.setRedirect(true);
                return pref; 
            }else{
                clearHousingApp();
                PageReference pref = new PageReference('/housingprograms/mohcdHousingApp?pid='+prop.Id);
                pref.setRedirect(true);
                return pref; 
            }        
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }
    
    public void prefillHousingApp(){
        Contact fetchCont = SFMOHCD_DAO.getUserContDet();
        System.debug('***cont'+ fetchCont);

        Account contAccount = SFMOHCD_DAO.getUserAccount();
        System.debug('***account'+ contAccount);


        Housing_Application__c housingApp = SFMOHCD_DAO.createHousingApp(contAccount.Id, prop.Id, fetchCont.Id);
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


        Housing_Application__c housingApp = SFMOHCD_DAO.createHousingApp(contAccount.Id, prop.Id, fetchCont.Id);
        System.debug('****housingapp'+ housingApp);
        insert housingApp;    
    }
  }