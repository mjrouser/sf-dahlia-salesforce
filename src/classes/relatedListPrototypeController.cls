public without sharing class relatedListPrototypeController 
{
    public List<Housing_Application_Member__c> housingAppMember;
    private Housing_Application__c housingApp;
    
    public relatedListPrototypeController(ApexPages.StandardController controller)
    {
    	this.housingApp = (Housing_Application__c)controller.getRecord();    	    
    }

    public List<Housing_Application_Member__c> gethousingAppMember()
    {    	
    	housingAppMember = [SELECT id, Housing_Application__c, Name, Member_Full_Name__c, Head_of_Household__c, Occupation__c FROM Housing_Application_Member__c WHERE Housing_Application__c = :housingApp.id];    	
system.debug('===MEMBER = ' + housingAppMember);    	
    	if(housingAppMember.size() != 0 )
    	{
    		return housingAppMember;
    	}else{
    		return null;
    	}    	    
    }
}