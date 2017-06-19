/**
 * @author:      Heidi
 * @date:        12/10/2014
 * @description: Controller class for mohcdEAHPDetails
 * @history:     06/10/2015 - Heidi Tang - Edited
*/ 
public with sharing class CS_MOHCDEAHPDetailsCC {
    
    public List<AttachmentWrapper> lAttachmentWraps{get; set;}
    
    public CS_MOHCDEAHPDetailsCC(ApexPages.StandardController controller) {
        Certificate_Program__c certificate = (Certificate_Program__c) controller.getRecord();
        
        List<Attachment> files = new List<Attachment>();
        lAttachmentWraps = new List<AttachmentWrapper>();
        
        if(certificate !=null){
           files = new List<Attachment>([SELECT Id, Name, Description,BodyLength FROM Attachment WHERE IsDeleted = false AND ParentId = :certificate.Id]);
           
           for(Attachment file : files){
               lAttachmentWraps.add(new AttachmentWrapper(CS_MOHCDGetListOfAttachments.convertName(file.Name,file.Description),file.Description,CS_MOHCDGetListOfAttachments.convertedSize(file.BodyLength)));
           }
        }                   
    }
    
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