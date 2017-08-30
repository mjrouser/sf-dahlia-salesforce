public class CS_MOHCDHousingAttachments {
    public Blob fileBody { get; set; }
    public String fileName { get; set; }
    public String financialId {get;set;}
    public Housing_Application_Attachment__c finAttachment {get;set;}
    public Housing_Application__c finApp {get;set;}
    
    public CS_MOHCDHousingAttachments(ApexPages.StandardController controller) {
        finApp = new Housing_Application__c();
        
        Housing_Application_Attachment__c attachedFinApp = (Housing_Application_Attachment__c) controller.getRecord();
        
        financialId = attachedFinApp.Housing_Application__c;
         
        if(financialId != null){
            finApp  = [SELECT Id, Name FROM Housing_Application__c WHERE Id = :financialId];
        }   
            
        finAttachment = new Housing_Application_Attachment__c();
    }
    
    public PageReference doCancel(){
        PageReference pageRef = new PageReference('/'+finApp.Id);
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    public PageReference doSave(){
        if(fileBody == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide a File.'));
            return null;            
        }else if(finAttachment.Document_Type__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide a document type.'));
            return null;
        }else{
            finAttachment.Name = this.fileName;
            finAttachment.Housing_Application__c = finApp.Id;
            
            Database.SaveResult result = Database.insert(finAttachment);
            
            if(result == null || !result.isSuccess()){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Could not save attachment.'));
                return null;
            }else{
                Attachment attachment = new Attachment();
                attachment.Body = this.fileBody;
                attachment.Name = this.fileName;
                attachment.ParentId = finApp.Id;
                attachment.Description = finAttachment.Document_Type__c;
                
                Database.SaveResult attachResult = Database.insert(attachment);
                
                if(result == null || !result.isSuccess()){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Could not save attachment.'));
                    return null;
                }else{
                    fileBody = Blob.valueOf('');
                    
                    finAttachment = [SELECT Id FROM Housing_Application_Attachment__c WHERE Id = :result.getId()];
                    finAttachment.Type__c = attachResult.getId();
                    
                    update finAttachment;
                    
                    PageReference pageRef = new PageReference('/'+finApp.Id);
                    pageRef.setRedirect(true);
                    return pageRef;
                }
            }
        }    
    }
}