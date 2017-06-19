/**
 * @author:      Ronald Martinez
 * @date:        12/03/2014
 * @description: handler for SfmohprgramsContactTrigger.
 * @history:     06/01/2015 - Heidi Tang - Edited
*/
public class SfmohprgramsDalpTriggerHandler{

    public void afterInsert(List<DALP_Request__c> ldalps){

        Map<Id,DALP_Request__c> mapLdalps = new Map<Id,DALP_Request__c>();

        for(DALP_Request__c ldalp : ldalps){ 
            //Check if lender and household is not null
            if(ldalp.Lender__c!=null && ldalp.Requested_By__c!=null){
              mapLdalps.put(ldalp.Id,ldalp);  
            }
        }

        List<Account> accounts = shareAccounts(mapLdalps);

        //Check if there is at least 1 account to be updated
        if(accounts.size()!=0){
            update accounts;
        }   
    }

    public void afterUpdate(Map<Id,DALP_Request__c> oldLdalpsMap,List<DALP_Request__c> ldalps) {

        Map<Id,DALP_Request__c> mapLdalps = new Map<Id,DALP_Request__c>();
        DALP_Request__c oldLdalp;

        for(DALP_Request__c ldalp : ldalps){ 
            oldLdalp = oldLdalpsMap.get(ldalp.Id);

            //Check if lender and household is not null
            if(ldalp.Lender__c!=null && ldalp.Requested_By__c!=null){
                //Check if the household account or loan office is changed.
                if(ldalp.Lender__c != oldLdalp.Lender__c || ldalp.Requested_By__c != oldLdalp.Requested_By__c){
                    mapLdalps.put(ldalp.Id,ldalp);  
                }
            }
        }

        List<Account> accounts = shareAccounts(mapLdalps);

        //Check if there is at least 1 account to be updated
        if(accounts.size()!=0){
            update accounts;
        }   
    }

    /**
     * @author:      Heidi Tang
     * @date:        06/01/2015
     * @description: Method called from the trigger to set the request.
     * @param:       ldalpsMap: Map of DALP Request to be changed.
    */
    public List<Account> shareAccounts(Map<Id,DALP_Request__c> ldalpsMap){
        List<Account> accounts = new List<Account>();

        Set<Id> contactIds = new Set<Id>();
        Map<Id,Contact> contacts = new Map<Id,Contact>();
        Map<Id,Contact> hLendersMap = new Map<Id,Contact>();


        for(DALP_Request__c ldalp : ldalpsMap.values()){
            contactIds.add(ldalp.Requested_By__c);   
            contactIds.add(ldalp.Lender__c);   
        }

        for(Contact contact : new List<Contact>([SELECT AccountId FROM Contact WHERE Id IN :contactIds])) {
            if(contact.AccountId != null){
                contacts.put(contact.Id,contact);              
            }
        }

        for(DALP_Request__c ldalp : ldalpsMap.values()){
            if(contacts.get(ldalp.Requested_By__c) != null){
                if(contacts.get(ldalp.Lender__c) != null) {
                    hLendersMap.put(contacts.get(ldalp.Requested_By__c).AccountId,contacts.get(ldalp.Lender__c));
                }
            }
        }        

        for(Account account : new List<Account>([SELECT Id,Lender_Account__c FROM Account WHERE Id IN : hLendersMap.keySet()])){
            account.Lender_Account__c = hLendersMap.get(account.Id).AccountId;
            accounts.add(account);
        }

        return accounts;
    }
}