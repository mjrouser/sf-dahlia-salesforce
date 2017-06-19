/**
 * @author:      Heidi Tang
 * @date:        01/05/2015
 * @description: Apex class for mohcdAttachments VF Page
 * @history:     06/10/2015 - Heidi Tang - Edited
*/
public class CS_MOHCDAttachments {

    public Blob fileBody { get; set; }
    public String fileName { get; set; }
    public String financialId {get;set;}
    public Custom_Attachment__c finAttachment {get;set;}
    public Financial_Application__c finApp {get;set;}
    
    public CS_MOHCDAttachments(ApexPages.StandardController controller) {
        finApp = new Financial_Application__c();
    
        Custom_Attachment__c attachedFinApp = (Custom_Attachment__c) controller.getRecord();
        
        financialId = attachedFinApp.Financial_Application__c;
         
        if(financialId != null){
            finApp  = [SELECT Id, Name FROM Financial_Application__c WHERE Id = :financialId];
        }   
            
        finAttachment = new Custom_Attachment__c();
    }
    
    public PageReference doCancel(){
        PageReference pageRef = new PageReference('/'+finApp.Id);
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    public PageReference doSave(){
        if(fileBody == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ERROR_ATTACHMENT_PROVIDE_FILE));
            return null;            
        }else if(finAttachment.Document_Type__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ERROR_ATTACHMENT_PROVIDE_DOCTYPE));
            return null;
        }else{
            finAttachment.Name = this.fileName;
            finAttachment.Financial_Application__c = finApp.Id;
            
            Database.SaveResult result = Database.insert(finAttachment);
            
            if(result == null || !result.isSuccess()){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ERROR_ATTACHMENT_SAVE));
                return null;
            }else{
                Attachment attachment = new Attachment();
                attachment.Body = this.fileBody;
                attachment.Name = this.fileName;
                attachment.ParentId = finApp.Id;
                
                Database.SaveResult attachResult = Database.insert(attachment);
                
                if(result == null || !result.isSuccess()){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ERROR_ATTACHMENT_SAVE));
                    return null;
                }else{
                    fileBody = Blob.valueOf('');
                    
                    finAttachment = [SELECT Id FROM Custom_Attachment__c WHERE Id = :result.getId()];
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