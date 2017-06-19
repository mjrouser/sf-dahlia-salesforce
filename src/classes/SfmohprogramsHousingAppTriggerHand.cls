public with sharing class SfmohprogramsHousingAppTriggerHand{

    public void consumeCertificate(Set<Id> sId, List<Housing_Application__c> lHouseApp){
        List<Certificate_Program__c> lCert = new List<Certificate_Program__c>();
        Set<String> sCOPRental = new Set<String>();
        Set<String> sCOPOwner = new Set<String>();
        Set<Date> sEAHPNew = new Set<Date>();//
        Set<Date> sEAHPExisting = new Set<Date>(); //
        Map<Id, Date> mEAHPNew = new Map<Id, Date>();
        Map<Id, Date> mEAHPExisting = new Map<Id, Date>(); 
        String HA_RENTAL = 'BMR Rental';
        String HA_OWNER = 'BMR Ownership';
        Boolean isConsumed = FALSE;
        Map<Date, Boolean> mapConsumed = new Map<Date, Boolean>();
        Map<String, Id> mapRecordType = new Map<String, Id>();
        Map<Date, Id> mapDate = new Map<Date, Id>();
        Map<Id, Id> mapAccount = new Map<Id, Id>();
        Map<Id, String> mapPropertyType = new Map<Id, String>();
                                               
        for(RecordType recType: [Select Name, Id from RecordType 
                                    where (((Name =: HA_OWNER) 
                                            OR (Name =: HA_RENTAL) ) 
                                            AND SobjectType =: 'Housing_Application__c')] 
                                        ){
            mapRecordType.put(recType.Name, recType.Id);
        }
        
        //Query the property
        List<Properties__c> lProp = [Select Id, New_or_Existing__c from Properties__c where Id IN: sId];
             
        //Create map for property type
        for(Properties__c prop: lProp){ 
            mapPropertyType.put(prop.Id, prop.New_or_Existing__c);
        }

        for(Housing_Application__c lHA: lHouseApp){ 

            //Check for COP                     
            if((lHA.Certificate_of_Preference_Holder__c == TRUE) 
            && (lHA.Certificate_of_Preference_Number__c != null)){ 
                //Rental
                if(lHA.RecordTypeId == mapRecordType.get(HA_RENTAL)){
                    sCOPRental.add(lHA.Certificate_of_Preference_Number__c);  
                } 
                
                //Ownership
                else if(lHA.RecordTypeId == mapRecordType.get(HA_OWNER)){
                    sCOPOwner.add(lHA.Certificate_of_Preference_Number__c);  
                }          
            } 

            //Check for EAHP
            if((lHA.EAHP_Certificate_Holder__c == TRUE) && (lHA.EAHP_Certificate_Expiration_Date__c != null)){
                System.debug('POI: ' +mapPropertyType.get(lHA.Property_of_Interest__c));
                if(mapPropertyType.get(lHA.Property_of_Interest__c) == 'New'){
                    sEAHPNew.add(lHA.EAHP_Certificate_Expiration_Date__c);//
                    mEAHPNew.put(lHA.Id, lHA.EAHP_Certificate_Expiration_Date__c);                
                }
                if(mapPropertyType.get(lHA.Property_of_Interest__c) == 'Existing'){
                    sEAHPExisting.add(lHA.EAHP_Certificate_Expiration_Date__c);//
                    mEAHPExisting.put(lHA.Id, lHA.EAHP_Certificate_Expiration_Date__c);                  
                }
                mapDate.put(lHA.EAHP_Certificate_Expiration_Date__c, lHA.Id);  
                mapAccount.put(lHA.Id, lHA.Household_Account__c); 
            } 
                
        }
        //System.debug('sEAHPNew: ' +sEAHPNew);
        //System.debug('sEAHPExisting: ' +sEAHPExisting);
        System.debug('mEAHPNew: ' +mEAHPNew);
        System.debug('mEAHPExisting: ' +mEAHPExisting);
        /*
        //Loop through all HA and get accounts
        //Loop  through all the accounts and get corresponding Certificates
        Map<Id, List<Certificate_Program__c>>
        for(Account acc: mAccount.values()){
            if (mTerritory.containsKey('No Territory - ' +acc.Abbott_Country__c)) {
                            mTerritory.get('No Territory - ' +acc.Abbott_Country__c).add(acc);    
        }
        */
        lCert = [Select Id, Name, COPP_Rental_Used__c, COPP_Ownership_Used__c, EAHP_Certificate_Used__c, Expiration_Date_for_Existing_Properties__c, 
                Expiration_Date_for_New_Developments__c, Household_Account__c from Certificate_Program__c 
                where (Name IN: sCOPRental) 
                    OR (Name IN: sCOPOwner) 
                    OR ((Expiration_Date_for_New_Developments__c IN: mEAHPNew.values()) AND (EAHP_Certificate_Used__c = FALSE)) 
                    OR ((Expiration_Date_for_Existing_Properties__c IN: mEAHPExisting.values())  AND (EAHP_Certificate_Used__c = FALSE))];
        System.debug('lCert: ' +lCert);
        
        
        if(lCert.size() > 0){
            for(Certificate_Program__c cert: lCert){
            
            }
            for(Certificate_Program__c cert: lCert){
                //COPP
                if(sCOPRental.contains(cert.Name)){
                    if(cert.COPP_Rental_Used__c == TRUE){
                    //Send notification that certificate is already used.
                    }
                
                    if(cert.COPP_Rental_Used__c == FALSE){
                        cert.COPP_Rental_Used__c = TRUE;
                    }
                } 
                
                if(sCOPOwner.contains(cert.Name)){
                    if(cert.COPP_Ownership_Used__c == TRUE){
                    //Send notification that certificate is already used.
                    }
                
                    if(cert.COPP_Ownership_Used__c == FALSE){
                        cert.COPP_Ownership_Used__c = TRUE;
                    }
                } 

                //EAHP
                if( (sEAHPNew.contains(cert.Expiration_Date_for_New_Developments__c)) 
                        && (cert.Household_Account__c == mapAccount.get(mapDate.get(cert.Expiration_Date_for_New_Developments__c))) ){
                        if(cert.EAHP_Certificate_Used__c == TRUE){
                            //Send notification that certificate is already used.
                        }
                    
                        if( (cert.EAHP_Certificate_Used__c == FALSE) 
                            && (mapConsumed.get(cert.Expiration_Date_for_New_Developments__c) != TRUE) ){
                            cert.EAHP_Certificate_Used__c = TRUE;
                            mapConsumed.put(cert.Expiration_Date_for_New_Developments__c, TRUE);
                        }
                }


                if( (sEAHPExisting.contains(cert.Expiration_Date_for_Existing_Properties__c)) 
                        && (cert.Household_Account__c == mapAccount.get(mapDate.get(cert.Expiration_Date_for_Existing_Properties__c))) ){
                    if(cert.EAHP_Certificate_Used__c == TRUE){
                            //Send notification that certificate is already used.
                    }
                    
                        if( (cert.EAHP_Certificate_Used__c == FALSE) 
                            && (mapConsumed.get(cert.Expiration_Date_for_Existing_Properties__c) != TRUE) ){
                            cert.EAHP_Certificate_Used__c = TRUE;
                            mapConsumed.put(cert.Expiration_Date_for_Existing_Properties__c, TRUE);
                        }
                }
                   
            }
            update lCert;
        }

    }
    /*
    public void shareHousingApplication(List<Housing_Application__c> housingApplications) {
        
        List<Housing_Application__Share> housingAppShareList = new List<Housing_Application__Share>();
        Housing_Application__Share housingAppShare = null;
        List<Housing_Application__c> haList = [SELECT Id, Property_of_Interest__r.OwnerId FROM Housing_Application__c WHERE Id IN: housingApplications];
        
        for (Housing_Application__c housingApplication : haList) {
            housingAppShare = new Housing_Application__Share();
            housingAppShare.AccessLevel = 'Read';
            System.debug('in ~~ ParentId : '+ housingApplication.Id);
            housingAppShare.ParentId = housingApplication.Id;
            System.debug('in ~~ UserOrGroupId : '+ housingApplication.Property_of_Interest__r.OwnerId);
            housingAppShare.UserOrGroupId = housingApplication.Property_of_Interest__r.OwnerId;
            housingAppShareList.add(housingAppShare);
            
        }
        insert housingAppShareList;
        
        Housing_Application__Share has = [SELECT Id, AccessLevel, ParentId, UserOrGroupId FROM Housing_Application__Share WHERE Id =: housingApplications.get(0).Id].get(0);
        System.debug('out ~~ Id : '+ has.Id);
        System.debug('out ~~ AccessLevel : '+ has.AccessLevel);
        System.debug('out ~~ ParentId : '+ has.ParentId);
        System.debug('out ~~ UserOrGroupId : '+ has.UserOrGroupId);
    }*/

}