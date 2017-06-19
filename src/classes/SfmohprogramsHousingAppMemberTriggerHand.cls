/*****************************************************
 @author : Kingsley Tumaneng
 @date   : April 28, 2015
 @description : Class for Housing Application Member 
                Trigger
******************************************************/

public class SfmohprogramsHousingAppMemberTriggerHand{
    
    public void afterInsert(List<Housing_Application_Member__c> hoamList){
        List<Housing_Application_Member__c> housingMemList = new List<Housing_Application_Member__c>();
        Set<Id> setId = new Set<Id>();
        String homePhone;
        String cellPhone;
        String workPhone;
        String accEmail;
        String streetNum;
        String streetType;
        String streetName;
        String aptUnit;
        String city;
        String state;
        String zip;
        Id housingMemberId;
        
        for(Housing_Application_Member__c hoam : hoamList){
            setId.add(hoam.Housing_Application__c);
            housingMemberId = hoam.Id;
            
            system.debug('***housingMemberId = ' + hoam.Id);
        }
        
        for(Housing_Application__c housingApp : [SELECT Id, Household_Account__r.Phone, Household_Account__r.Mobile_Phone__c , 
                                                 Household_Account__r.Work_Phone__c, Household_Account__r.Email__c,
                                                 Household_Account__r.Street_Number__c , Household_Account__r.Street_Name__c ,
                                                 Household_Account__r.Street_Type__c , Household_Account__r.Apt_Unit__c ,
                                                 Household_Account__r.City__c, Household_Account__r.State__c ,
                                                 Household_Account__r.Zip_Code__c FROM Housing_Application__c WHERE Id IN : setId]){
                                                 
            homePhone = housingApp.Household_Account__r.Phone;
            cellPhone = housingApp.Household_Account__r.Mobile_Phone__c;
            workPhone = housingApp.Household_Account__r.Work_Phone__c;
            accEmail = housingApp.Household_Account__r.Email__c;
            streetNum = housingApp.Household_Account__r.Street_Number__c;
            streetType = housingApp.Household_Account__r.Street_Type__c;
            streetName = housingApp.Household_Account__r.Street_Name__c;
            aptUnit = housingApp.Household_Account__r.Apt_Unit__c;
            city = housingApp.Household_Account__r.City__c;
            state = housingApp.Household_Account__r.State__c;
            zip = housingApp.Household_Account__r.Zip_Code__c;
                                       
            system.debug('***Email = ' + housingApp.Household_Account__r.Email__c);
            system.debug('***Phone = ' + housingApp.Household_Account__r.Phone);
            system.debug('***Work Phone = ' + housingApp.Household_Account__r.Work_Phone__c);
            system.debug('***Mobile Phone = ' + housingApp.Household_Account__r.Mobile_Phone__c);
        }
        
        for(Housing_Application_Member__c hoam : [SELECT Id, Email_Address__c, Applicant_Role__c, Relationship_to_Head_of_Household__c, Cell_Phone__c, Home_Phone__c, Work_Phone__c,
                                                  Street_Name__c, Street_Number__c, Street_Type__c, Zip_Code__c, Apt_Unit__c, City__c, State__c 
                                                  FROM Housing_Application_Member__c WHERE Id =: housingMemberId]){
            if(hoam.Relationship_to_Head_of_Household__c == 'Self'){
                hoam.Applicant_Role__c = 'Primary Applicant';
                hoam.Home_Phone__c = homePhone;
                hoam.Work_Phone__c = workPhone;
                hoam.Cell_Phone__c = cellPhone;
                hoam.Email_Address__c = accEmail;
                hoam.Street_Name__c = streetName;
                hoam.Street_Number__c = streetNum;
                hoam.Street_Type__c = streetType;
                hoam.Zip_Code__c = zip;
                hoam.Apt_Unit__c = aptUnit;
                hoam.City__c = city;
                hoam.State__c = state;
                housingMemList.add(hoam);
                system.debug('***Home Phone = ' + hoam.Home_Phone__c);
                system.debug('***Cell Phone = ' + hoam.Cell_Phone__c);
                system.debug('***Work Phone = ' + hoam.Work_Phone__c);
            }
        }
        
        if(housingMemList.size() > 0){
            update housingMemList;
        }
    }
}