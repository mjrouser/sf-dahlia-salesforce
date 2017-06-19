public with sharing class SfmohprogramsApplyButtonCont {

    private final Properties__c mysObject;

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public SfmohprogramsApplyButtonCont(ApexPages.StandardController stdController) {
        this.mysObject = (Properties__c)stdController.getRecord();
    }


    public PageReference applyProperty(){

        try{
        Contact fetchCont = SFMOHCD_DAO.getUserContDet();
        System.debug('***cont'+ fetchCont);

        Account contAccount = SFMOHCD_DAO.getUserAccount();
        System.debug('***account'+ contAccount);


        Housing_Application__c housingApp = SFMOHCD_DAO.createHousingApp(contAccount.Id, mysObject.Id, fetchCont.Id);
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

        PageReference page = new PageReference('/housingprograms/'+ housingApp.Id); 

            page.setRedirect(true);
            return page;

        }
        catch (Exception e) {
        
            System.debug(e);
        }

        return null;

        //return null;
    }

    
}