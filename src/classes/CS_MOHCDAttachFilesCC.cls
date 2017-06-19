/**
 * @author:      Sumit Shingavi
 * @date:        07/11/2014
 * @description: Apex class for mohAttachFiles VF Page
 * @history:     06/10/2015 - Heidi Tang - Edited
*/ 
public with sharing class CS_MOHCDAttachFilesCC {
    
    //Public Variables
    public Properties__c propInstance {get; set;} 
    public String haId {get; set;}
    public String pId {get; set;}    
    public transient Blob fileAttachmentBody {get; set;}    
    public transient String fileAttachmentName {get; set;}
    public transient String fileAttachmentContentType {get; set;}
    public transient String fileAttachmentDescription {get; set;}
    public List<String> attachmentFileNames {get; set;}
    
    //Constructor
    public CS_MOHCDAttachfilesCC() {
        haId  = '';
        pId = '';
        
        haId = System.currentPageReference().getParameters().get('haId');
        pId = System.currentPageReference().getParameters().get('pId'); 
        propInstance = new Properties__c(); 
        if(!String.isBlank(pId)) {
            propInstance = [SELECT Id, Name, Development_Name__c, Property_Address_Marketing__c, 
                Marketing_Company_Agent_Name__c, Phone_Number__c, Email__c, Occupancy_Type__c 
                FROM Properties__c WHERE Id =: pId LIMIT 1];
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
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.ERROR_ATTACHMENT_TYPE));
                    return null;
                }
                attachmentFileNames.add(fileAttachmentName);                
                Attachment myAttachment= new Attachment();
                myAttachment.Name = fileAttachmentName +'-'+ fileAttachmentDescription;
                myAttachment.Body = fileAttachmentBody;
                myAttachment.ContentType = fileAttachmentContentType;                         
                myAttachment.ParentId = haId;                
                myAttachment.Description = fileAttachmentDescription;
                insert myAttachment;
                
                Housing_Application_Attachment__c haAttachment = new Housing_Application_Attachment__c();
                haAttachment.Type__c = myAttachment.Id;
                haAttachment.Name = fileAttachmentName;
                haAttachment.Housing_Application__c = haId;
                haAttachment.Document_Type__c = fileAttachmentDescription; 
                 
                insert haAttachment;
                             
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
        PageReference pref = Page.mohcdHousingApp;
        pref.getParameters().put('pid', pid);
        pref.getParameters().put('t', '6');
        pref.setRedirect(true);
        return pref;
    }
    
    public List<SelectOption> getDocumentTypes() {
        List<SelectOption> options = new List<SelectOption>();
        if(propInstance.Occupancy_Type__c == StringConstants.PROP_RENTAL) {
            options.add(new SelectOption('',Label.SELECT_OPTION));
            options.add(new SelectOption(Label.DOC_TYPE_LIVE_PROOF,Label.DOC_TYPE_LIVE_PROOF_VALUE));
        } else
        if(propInstance.Occupancy_Type__c == StringConstants.PROP_OWNERSHIP) {
            options.add(new SelectOption('',Label.SELECT_OPTION));
            options.add(new SelectOption(Label.DOC_TYPE_TAX_RETURN,Label.DOC_TYPE_TAX_RETURN));
            options.add(new SelectOption(Label.DOC_TYPE_INCOME_TAX,Label.DOC_TYPE_INCOME_TAX));
            options.add(new SelectOption(Label.DOC_TYPE_BANK_STATEMENT,Label.DOC_TYPE_BANK_STATEMENT));
            options.add(new SelectOption(Label.DOC_TYPE_RETIREMENT,Label.DOC_TYPE_RETIREMENT));
            options.add(new SelectOption(Label.DOC_TYPE_VERIFICATION,Label.DOC_TYPE_VERIFICATION));
            options.add(new SelectOption(Label.DOC_TYPE_EMPLOYMENT_OFFER,Label.DOC_TYPE_EMPLOYMENT_OFFER));
            options.add(new SelectOption(Label.DOC_TYPE_PAY,Label.DOC_TYPE_PAY));
            options.add(new SelectOption(Label.DOC_TYPE_PROFIT,Label.DOC_TYPE_PROFIT));
            options.add(new SelectOption(Label.DOC_TYPE_SCHEDULE,Label.DOC_TYPE_SCHEDULE));
            options.add(new SelectOption(Label.DOC_TYPE_SELF_EMP,Label.DOC_TYPE_SELF_EMP));
            options.add(new SelectOption(Label.DOC_TYPE_UNEMPLOYED,Label.DOC_TYPE_UNEMPLOYED));
            options.add(new SelectOption(Label.DOC_TYPE_GIFT_LETTER,Label.DOC_TYPE_GIFT_LETTER));
            options.add(new SelectOption(Label.DOC_TYPE_LOAN,Label.DOC_TYPE_LOAN));
            options.add(new SelectOption(Label.DOC_TYPE_HOMEBUYER,Label.DOC_TYPE_HOMEBUYER));
            options.add(new SelectOption(Label.DOC_TYPE_CONSENT,Label.DOC_TYPE_CONSENT));
            options.add(new SelectOption(Label.DOC_TYPE_LENDER,Label.DOC_TYPE_LENDER));
            options.add(new SelectOption(Label.DOC_TYPE_OTHER,Label.DOC_TYPE_OTHER)); 
        }   
        return options;
    }

}