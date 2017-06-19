/**
 * @author:      Ronald Martinez
 * @date:        07/22/2014
 * @description: Apex class for mohAttachFiles VF Page. Modified version of CS_MOHCDAttachFilesCC. Used for EAHP.
 * @history:     06/10/2015 - Heidi Tang - Edited
*/
public with sharing class CS_MOHCDEAHPAttachFilesCC {
    
    //Public Variables
    public Certificate_Program__c oCert {get; set;} 
    public String EAHPId {get; set;}  
    public transient Blob fileAttachmentBody {get; set;}    
    public transient String fileAttachmentName {get; set;}
    public transient String fileAttachmentContentType {get; set;}
    public transient String fileAttachmentDescription {get; set;}
    public List<String> attachmentFileNames {get; set;}
    public Boolean isDetail {get; set;}
    public List<AttachmentWrapper> lAttachmentWraps{get; set;}
    
    //Constructor
    public CS_MOHCDEAHPAttachFilesCC() {
        EAHPId  = '';
        
        lAttachmentWraps = new List<AttachmentWrapper>();        
        EAHPId = System.currentPageReference().getParameters().get(StringConstants.PARAM_PID); 
        oCert = new Certificate_Program__c();
         
        if(!String.isBlank(EAHPId)) {
            oCert = [SELECT Id, Name 
                FROM Certificate_Program__c WHERE Id =: EAHPId LIMIT 1];
            EAHPId = oCert.Id;
            
            List<Attachment> files = new List<Attachment>();
        
            files = new List<Attachment>([SELECT Id, Name, Description,BodyLength FROM Attachment WHERE IsDeleted = false AND ParentId = :oCert.Id]);
           
            for(Attachment file : files){
                   lAttachmentWraps.add(new AttachmentWrapper(CS_MOHCDGetListOfAttachments.convertName(file.Name,file.Description),file.Description,CS_MOHCDGetListOfAttachments.convertedSize(file.BodyLength)));
            }
        }
        
        fileAttachmentBody = null;
        fileAttachmentDescription = '';
        attachmentFileNames = new List<String>();        
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/11/2014
    * @description : Apex method for adding attachments to allAttachments List variable
    * @parameters : Nothing
    * @returns : PageReference 
    */  
    Integer totalSize = 0;
    public PageReference addAttachment() {
    
        try{  
            
            if(!String.isBlank(fileAttachmentName)) {
                
                if(String.isBlank(fileAttachmentDescription)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ERROR_ATTACHMENT_TYPE));
                    return null;
                }
                attachmentFileNames.add(fileAttachmentName);                
                Attachment myAttachment= new Attachment();
                myAttachment.Name = fileAttachmentName +'-'+ fileAttachmentDescription;
                myAttachment.Body = fileAttachmentBody;
                myAttachment.ContentType = fileAttachmentContentType;                         
                myAttachment.ParentId = EAHPId;                
                myAttachment.Description = fileAttachmentDescription;
                insert myAttachment;
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.SUCCESS_ATTACHMENT));
                
                myAttachment = new Attachment();                                
                fileAttachmentBody = null;
                fileAttachmentName = '';
                fileAttachmentContentType = '';                
                fileAttachmentDescription = '';
            }        
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }       
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/11/2014
    * @description : Apex method for adding attachments to Housing Application
    * @parameters : Nothing
    * @returns : PageReference 
    */
    public PageReference done() {
        EAHPId = System.currentPageReference().getParameters().get(StringConstants.PARAM_PID); 
        
        PageReference pref = new PageReference('/housingprograms/mohcdCertificateProgramDetails?id='+EAHPId);
        pref.setRedirect(true);
        return pref;
        
    }
    
    public List<SelectOption> getEAHPTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',Label.SELECT_OPTION));
        options.add(new SelectOption(Label.EAHP_COMPLETE_APP,Label.EAHP_COMPLETE_APP));
        options.add(new SelectOption(Label.EAHP_AFFIDAVIT,Label.EAHP_AFFIDAVIT));
        options.add(new SelectOption(Label.EAHP_LEASE,Label.EAHP_LEASE));
        options.add(new SelectOption(Label.EAHP_PROOF,Label.EAHP_PROOF));
        options.add(new SelectOption(Label.EAHP_DISABILITY,Label.EAHP_DISABILITY));
        options.add(new SelectOption(Label.EAHP_HEALTHCARE,Label.EAHP_HEALTHCARE));

        return options;
    }
    
    /* Heidi */
    public class AttachmentWrapper {
        public String name{get; set;}
        public String description {get; set;}
        public String size{get; set;}
        
        public AttachmentWrapper(String name, String description, String size) {
            this.name = name;
            this.description = description;
            this.size = size;
        }
    }
}