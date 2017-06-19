public with sharing class CS_MOHCDSuccessInitialSaleOfMyHomeCC {

    public Property_Owner_Requests__c property {get;set;}
    public PropertyWrapper propWrap{get; set;}

    public CS_MOHCDSuccessInitialSaleOfMyHomeCC() {
        String pId = System.currentPageReference().getParameters().get('pId');
        
        if(pId != null){
            property = [SELECT Real_Estate_Agent_License_Number__c,Real_Estate_Agent_Email__c,Real_Estate_Agent_Name__c,Real_Estate_Agent_Phone__c,Real_Estate_Company_Name__c FROM Property_Owner_Requests__c WHERE Id = :pId];
            propWrap = new PropertyWrapper(property.Real_Estate_Agent_License_Number__c,property.Real_Estate_Agent_Email__c,property.Real_Estate_Agent_Name__c,property.Real_Estate_Agent_Phone__c,property.Real_Estate_Company_Name__c);
        }
    }
    
    /* Heidi */
    public class PropertyWrapper {
        public String license{get; set;}
        public String email {get; set;}
        public String name{get; set;}
        public String phone{get; set;}
        public String company {get; set;}
        
        public PropertyWrapper(String license, String email, String name, String phone, String company) {
            this.license= license;
            this.email= email;
            this.name= name;
            this.phone= phone;
            this.company= company;
        }
    }
}