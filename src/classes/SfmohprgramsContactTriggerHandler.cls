/**
 * @author:      Kingsley Tumaneng
 * @date:        04/09/2015
 * @description: handler for SfmohprgramsContactTrigger.
 * @history:     06/01/2015 - Heidi Tang - Edited
 */
public class SfmohprgramsContactTriggerHandler{

    public void afterUpdate(List<Contact> cont) {
        
        Map<Id,Contact> mapCon = new Map<Id,Contact>();

        for(Contact tmpCont : cont){
            if(tmpCont.Relationship_to_Head_of_Household__c != null && tmpCont.Relationship_to_Head_of_Household__c == 'Self'){
                mapCon.put(tmpCont.AccountId, tmpCont);
            }
        }
                
        List<Account> acctList = new List<Account>([
            SELECT Id,Work_Phone__c,Mobile_Phone__c,
            Phone,Email__c,Street_Name__c,Street_Number__c,Street_Type__c,Apt_Unit__c,
            City__c,Zip_Code__c,State__c FROM Account WHERE Id IN :mapCon.keySet()]);

        for(Account acc : acctList){
            acc.Mobile_Phone__c = mapCon.get(acc.Id).MobilePhone;
            acc.Work_Phone__c = mapCon.get(acc.Id).Work_Phone__c;
            acc.Phone = mapCon.get(acc.Id).HomePhone;
            acc.Email__c = mapCon.get(acc.Id).Email;
            acc.Street_Number__c = mapCon.get(acc.Id).Street_Number__c;
            acc.Street_Name__c = mapCon.get(acc.Id).Street_Name__c;
            acc.Street_Type__c = mapCon.get(acc.Id).Street_Type__c;
            acc.Apt_Unit__c = mapCon.get(acc.Id).Apt_Unit__c;
            acc.City__c = mapCon.get(acc.Id).City__c;
            acc.State__c = mapCon.get(acc.Id).State__c;
            acc.Zip_Code__c = mapCon.get(acc.Id).Zip_Code__c;
        }
        
        if(acctList.size()>0){
            update acctList;
        }
    }

}