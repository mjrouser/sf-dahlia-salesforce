public with sharing class SfmohprogramsSelectedPropCont {

    private final Properties__c mysObject;
    public Properties__c selectedProperty {get; set;}
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public SfmohprogramsSelectedPropCont(ApexPages.StandardController stdController) {
        this.mysObject = (Properties__c)stdController.getRecord();
    }

    public PageReference applyProperty(){
        /*System.debug('***user**'+UserInfo.getName());

        Contact fetchCont = SFMOHCD_DAO.getUserContDet();
        Account contAccount = SFMOHCD_DAO.getUserAccount();

        Housing_Application__c housingApp = SFMOHCD_DAO.createHousingApp(contAccount.Id, mysObject.Id, fetchCont.Id);
        
        insert housingApp;

        List<Housing_Application_Member__c> housingAppMem = SFMOHCD_DAO.createhAppMem(housingApp.Id, contAccount.Id);
        
        insert housingAppMem;

        List<> housingAppAsset = SFMOHCD_DAO.createhAppAsset(String hAppMemId, String accId)
        
        if(UserInfo.getName() != 'Housing Programs Site Guest User'){
            PageReference page = new PageReference('/housingprograms/home/home.jsp?id='+ mysObject.id); 

            page.setRedirect(true);
            return page;
        }
       
        */
        


        return new PageReference('/housingprograms/login?id='+ mysObject.id);
    }
    

}