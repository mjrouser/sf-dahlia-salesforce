public with sharing class SfmohprogramsFinAppTriggerHelper {
	
	public void populateFields(List<Financial_Application__c> finApp){

        Housing_Application__c hApp = new Housing_Application__c();
        Housing_Application__c hAppVal = new Housing_Application__c();
        Properties__c propVal = new Properties__c();

        for(Financial_Application__c fa : finApp){
            if(fa.Copy_Existing_Info__c){
                hApp.Id = fa.Housing_Application__c;                
            }
        }


        if(happ.Id != null){
             hAppVal = [SELECT Household_Account__c,
                                                     Property_of_Interest__c,
                                                     Property_Address__c,
                                                     Development_Name__c
                                                     FROM Housing_Application__c WHERE id =: hApp.Id];
            propVal = [SELECT of_Bathrooms__c,
                                            of_Bedrooms__c,
                                            Parent_Development_Name__c
                                            FROM Properties__c
                                            WHERE id = :hAppVal.Property_of_Interest__c];

        
                                             


            for(Financial_Application__c fa : finApp){
                fa.Household_Account__c = hAppVal.Household_Account__c;
                //fa.Property_Address__c = hAppVal.Property_Address__c;
                if(hAppVal.Development_Name__c == null){
                    fa.Development_Name__c = propVal.Parent_Development_Name__c;
                }else{                    
                    fa.Development_Name__c = hAppVal.Development_Name__c;
                }
                fa.of_Bathrooms__c = propVal.of_Bathrooms__c;
                fa.of_Bedrooms__c = propVal.of_Bedrooms__c;

            }
        }
    }

    public void createMemAssetIncome(List<Financial_Application__c> finApp){
        Account hHoldAccount = new Account();
        Financial_Application__c finAppId = new Financial_Application__c();

        for(Financial_Application__c fa : finApp){
            if(fa.Copy_Existing_Info__c){
                hHoldAccount.Id = fa.Household_Account__c;
                finAppId.Id = fa.Id;                
            }
        }

        if(hHoldAccount.Id !=null){
            List<Financial_Application_Member__c> finAppMem = SFMOHCD_DAO.createfinAppMem(finAppId.Id, hHoldAccount.Id);

            if(finAppMem.size() > 0 && !finAppMem.isEmpty()){
                insert finAppMem;
            }

            List<Financial_Application_Asset__c> finAppAsset = SFMOHCD_DAO.createfinAppAsset(hHoldAccount.Id, finAppId.Id);

            if(finAppAsset.size() > 0 && !finAppAsset.isEmpty()){
                insert finAppAsset;
            }

            List<Financial_Application_Income__c> finAppIncome = SFMOHCD_DAO.createfinAppIncome(hHoldAccount.Id, finAppId.Id);

            if(finAppIncome.size() > 0 && !finAppIncome.isEmpty()){
                insert finAppIncome;
            }   

        }
    }

}