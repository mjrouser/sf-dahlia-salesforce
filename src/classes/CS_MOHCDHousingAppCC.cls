/**
 * @author:      Sumit Shingavi
 * @date:        07/04/2014
 * @description: Apex class for mohcdHousingApp VF Page
 * @history:     06/11/2015 - Heidi Tang - Edited
*/
public class CS_MOHCDHousingAppCC {
    
    public Housing_Application_Member__c editMemberInstance{get;set;}
    public Housing_Application_Income__c editMemberIncomeInstance{get;set;}
    public Housing_Application_Asset__c editMemberAssetInstance{get;set;}
    
    //Different Object instance variables
    public Properties__c propInstance {get; set;}    
    public Housing_Application__c haInstance {get; set;}    
    public Housing_Application_Member__c memberInstance {get; set;}
   
    public Housing_Application_Income__c memberIncomeInstance {get; set;}
    public Housing_Application_Asset__c memberAssetInstance {get; set;}
    
    //Variable for instruction text on housing app
    public String strInstructionText {get; set;}
    public  String incomeSetRecordType{get;set;}
    
    //For Edit and Delete functionality of Ajax implemented on "Step 1: Household Composition" mockup
    public String strMemberId {get; set;}
    public String strEditMemberId {get; set;}    
    
    //For Edit and Delete functionality of Ajax implemented on "Step 2: Income Information" mockup
    public String strIncomeId {get; set;}
    public String strEditIncomeId {get; set;}
    
    //For Edit and Delete functionality of Ajax implemented on "Step 3: Asset Information" mockup
    public String strAssetId {get; set;}
    public String strEditAssetId {get; set;}
    
    //For Delete functionality of Ajax implemented on "Step 4: Attach"
    public String strDeleteAttachmentId {get; set;}
    
    //Variables used in traversal of mockups to maintain state of mockup during ajax
    public Integer intSelectedTabNumber {get; set;}
        
    //Is Mailing Hard Copyies Flag on Attachment Tab
    public Boolean isSubmittingHardCopy {get; set;}
    
    private String pId {get; set;}
    
    //Current User record
    private User usr = [SELECT Id, Name, ContactId, Contact.AccountId FROM User WHERE Id =: Userinfo.getUserId() LIMIT 1];

    //For error messages
    public Boolean errorMember {get; set;}
    public Boolean erroreditMember {get; set;}
    public String ErrorMessagesMember {get; set;}
    public String ErrorMessagesEditMember {get; set;}
    
    public Boolean errorIncome {get; set;}
    public Boolean errorEditIncome {get; set;}
    public String ErrorMessagesIncome {get; set;}
    public String ErrorMessagesEditIncome {get; set;}
    public Id IncomeRecordType {get; set;}
    
    public Boolean errorAssets {get; set;}
    public Boolean errorEditAssets {get; set;}
    public String ErrorMessagesAssets {get; set;}
    public String ErrorMessagesEditAssets {get; set;}
    
    public String IncomeRecordTypeSelected {get; set;}
    public String AssetRecordTypeSelected {get; set;}
    
    public Boolean isOpenMember {get;set;}
    
    //kingsley
    //public String repId{get; set;}
    
    //Constructor
    public CS_MOHCDHousingAppCC() {
                
        //Intialize variables and object instances
        if(!String.isBlank(System.currentPageReference().getParameters().get('t'))) {
            intSelectedTabNumber = Integer.valueOf(System.currentPageReference().getParameters().get('t'));
        } else {
            intSelectedTabNumber = 1;
        }
        strMemberId = '';
        strEditMemberId = '';
        strIncomeId = '';
        strEditIncomeId = '';
        strAssetId = '';
        strEditAssetId = '';
        strDeleteAttachmentId = '';
        errorMember = FALSE;
        erroreditMember = FALSE;
        ErrorMessagesMember = '';
        ErrorMessagesEditMember = '';
        memberInstance = new Housing_Application_Member__c();        
        memberIncomeInstance = new Housing_Application_Income__c();
        memberAssetInstance = new Housing_Application_Asset__c();
        isSubmittingHardCopy = false;
        IncomeRecordTypeSelected = '';
        AssetRecordTypeSelected = '';
        
        
        isOpenMember = false;
        //Heidi
        editMemberInstance = new Housing_Application_Member__c();
        editMemberIncomeInstance = new Housing_Application_Income__c();
        editMemberAssetInstance = new Housing_Application_Asset__c();
        
        //Fetch Property details
        propInstance = new Properties__c();        
        pid = ApexPages.currentPage().getParameters().get('pid');
        System.debug(LoggingLevel.INFO, '==pid=='+pid);
        if(!String.isBlank(pId)) {
            propInstance = [SELECT Id, Name, Development_Name__c, Property_Address_Marketing__c,Parent_Development_Name__c,Contact_Person_Name__c,Contact_Phone__c,Contact_Email__c, 
                Marketing_Company_Agent_Name__c, Phone_Number__c, Email__c, Property_Program__c,
                Occupancy_Type__c, Total_of_Units_in_Building__c, New_or_Existing__c
                FROM Properties__c WHERE Id =: pId LIMIT 1];
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ERROR_INVALID_ID));            
            return;
        }
        
        //Fetch Housing application details if it exist for logged in user for selected property
        fetchHousingApplication();
        
        assignInstructionText();
        
        //kingsley
       // Report reportList : 
            //if(reportList.Name == 'MOHCD Conga Members List'){
                //for(Report repList : [SELECT Id, Name FROM Report WHERE Id =: '00O11000000ObbMEAS']){
                //repId = repList.Id;
                //system.debug('***repId = ' + repId);
                //}
            //}
        
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 08/07/2014
    * @description : Apex method that 
    s Housing App after Declarations are populated
    * @parameters : Nothing
    * @returns : PageReference
    */
    public PageReference updateHousingApp() {   
        Savepoint sp = Database.setSavepoint();    
        try {
            update haInstance; 
            fetchHousingApplication();   
        } catch(Exception e) { Database.rollback(sp); }
        return null;
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/11/2014
    * @description : Apex method that deletes the attachment from Housing Application
    * @parameters : Nothing
    * @returns : PageReference
    */
    public PageReference deleteAttachment() {   
        Savepoint sp = Database.setSavepoint();    
        try {
            Attachment haAttachment = new Attachment (Id = strDeleteAttachmentId);
            delete haAttachment;    
            fetchHousingApplication();   
        } catch(Exception e) {
            Database.rollback(sp);
        }
        return null;
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/09/2014
    * @description : Apex method that updates the asset details
    * @parameters : Nothing
    * @returns : PageReference
    */    
    public PageReference updateAsset() {       
        try {        
                if(editMemberAssetInstance.Id != null) {
                
                    String recordType = [SELECT Name FROM RecordType WHERE Id =: editMemberAssetInstance.RecordTypeId].get(0).Name;

                    CS_MOHCDHousingAppCCContainer container = validateMemberAssetFields(editMemberAssetInstance, recordType);
        
                    ErrorMessagesEditAssets = container.errorMessage;
                    errorEditAssets = container.error;            
                    AssetRecordTypeSelected = recordType;
                    
                    if (!errorEditAssets) {
                        update editMemberAssetInstance;
                        fetchHousingApplication();  
                        strEditAssetId = ''; 
                    }
                }   
        } catch(Exception e) { System.debug(LoggingLevel.Error, '==Error=='+e.getMessage()); }
        return null;
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/09/2014
    * @description : Apex method that deletes the asset from Housing Application
    * @parameters : Nothing
    * @returns : PageReference
    */
    public PageReference deleteAsset() {   
        Savepoint sp = Database.setSavepoint();    
        try {
            Housing_Application_Asset__c haAsset = new Housing_Application_Asset__c(Id = strAssetId);
            delete haAsset;    
            fetchHousingApplication();   
        } catch(Exception e) {
            Database.rollback(sp);
        }
        return null;
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/09/2014
    * @description : Apex method that adds the member's assets to Housing Application
    * @parameters : Nothing
    * @returns : PageReference
    */
    public PageReference addMemberAsset() {
        if(propInstance != null && haInstance != null) {
            List<RecordType> recordTypes = new List<RecordType>([SELECT Name FROM RecordType WHERE Id =: memberAssetInstance.RecordTypeId]);
            
            if(recordTypes.size()>0){
            
                String recordType = recordTypes.get(0).Name;

                CS_MOHCDHousingAppCCContainer container = validateMemberAssetFields(memberAssetInstance, recordType);
            
                ErrorMessagesAssets = container.errorMessage;
                errorAssets = container.error;
                AssetRecordTypeSelected = recordType;           
                
                if (!errorAssets) {
                    memberAssetInstance.Housing_Application__c = haInstance.Id;                        
                    insert memberAssetInstance;            
                    fetchHousingApplication();
                    memberAssetInstance= new Housing_Application_Asset__c();
                }
            }else{
                ErrorMessagesAssets = '<b style=\"color:#cc0000\"> Error : </b> Income Record Type is a required field.<br/>';
            }
        }
        return null;
    }
    
    
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/09/2014
    * @description : Apex method that updates the income details
    * @parameters : Nothing
    * @returns : PageReference
    */    
    public PageReference updateIncome() {       
        try {        
                if(editMemberIncomeInstance.Id != null) {
                    
                    String recordType = [SELECT Name FROM RecordType WHERE Id =: editMemberIncomeInstance.RecordTypeId].get(0).Name;

                    CS_MOHCDHousingAppCCContainer container = validateMemberIncomeFields(editMemberIncomeInstance, recordType);
        
                    ErrorMessagesEditIncome = container.errorMessage;
                    errorEditIncome = container.error;
                    IncomeRecordTypeSelected = recordType;
                    
                    if (!errorEditIncome) {
                        update editMemberIncomeInstance;
                        fetchHousingApplication();   
                        strEditIncomeId = '';
                    }                   
                }   
        } catch(Exception e) { System.debug(LoggingLevel.Error, '==Error=='+e.getMessage()); }
        return null;
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/09/2014
    * @description : Apex method that deletes the income from Housing Application
    * @parameters : Nothing
    * @returns : PageReference
    */
    public PageReference deleteIncome() {   
        Savepoint sp = Database.setSavepoint();    
        try {
            Housing_Application_Income__c haIncome = new Housing_Application_Income__c(Id = strIncomeId);
            delete haIncome;    
            fetchHousingApplication();   
        } catch(Exception e) {
            Database.rollback(sp);
        }
        return null;
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/08/2014
    * @description : Apex method that adds the member's income to Housing Application
    * @parameters : Nothing
    * @returns : PageReference
    */
    public PageReference addMemberIncome() {
        if(propInstance != null && haInstance != null) {                    
            
            List<RecordType> recordTypes = new List<RecordType>([SELECT Name FROM RecordType WHERE Id =: memberIncomeInstance.RecordTypeId]);
            
            if(recordTypes.size()>0){
            
                String recordType = recordTypes.get(0).Name;
                incomeSetRecordType = recordTypes.get(0).Name;
                
                System.debug('memberIncomeInstance::'+memberIncomeInstance);
                
                CS_MOHCDHousingAppCCContainer container = validateMemberIncomeFields(memberIncomeInstance, recordType);
        
                ErrorMessagesIncome = container.errorMessage;
                errorIncome = container.error;
                //memberIncomeInstance = container.memberIncomeInstance;
                IncomeRecordTypeSelected = recordType;
                
                if (!errorIncome) {
                    memberIncomeInstance.Housing_Application__c = haInstance.Id;            
                    insert memberIncomeInstance;
                    fetchHousingApplication();
                    memberIncomeInstance = new Housing_Application_Income__c();
                }
                
                System.debug('ErrorMessagesIncome!!!'+this.ErrorMessagesIncome);
                
            }else{
                ErrorMessagesIncome = '<b style=\"color:#cc0000\"> Error : </b> Income Record Type is a required field.<br/>';
            }
        }
        return null;
    }
               
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/08/2014
    * @description : Apex method that updates the member details
    * @parameters : Nothing
    * @returns : PageReference
    */    
    public PageReference updateMember() {
        Boolean hasError = false;       
        try {                
                if(editMemberInstance.Id != null) {
                        //List<Housing_Application_Members1__c> oldMemberRecord = new List<Housing_Application_Members1__c>([SELECT Id FROM]);
                        
                        //For error message
                        CS_MOHCDHousingAppCCContainer container = validateMemberFields(editMemberInstance);         
                        ErrorMessagesEditMember = container.errorMessage;
                        erroreditMember = container.error;
                
                        if(ErrorMessagesEditMember == ''){
                            
                            update editMemberInstance;                            
                            fetchHousingApplication();   
                            strEditMemberId = '';
                            isOpenMember = false;
                        }
                }
        } catch(Exception e) { System.debug(LoggingLevel.Error, '==Error=='+e.getMessage()); }

        return null;
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/08/2014
    * @description : Apex method that deletes the member from Housing Application
    * @parameters : Nothing
    * @returns : PageReference
    */
    public PageReference deleteMember() {   
        Savepoint sp = Database.setSavepoint();    
        try {
            Housing_Application_Member__c haMember = new Housing_Application_Member__c(Id = strMemberId);
            delete haMember;    
            fetchHousingApplication();   
        } catch(Exception e) {
            Database.rollback(sp);
        }
        return null;
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/09/2014
    * @description : Apex method that updates the status on Housing Application to "Submitted"
    * @parameters : Nothing
    * @returns : PageReference
    */
    public PageReference submitApplication() {
        try { 
            String haBusiness = 'Business Ownership';
            String haLand = 'Land Ownership';
            String haNoAsset = 'No Assets';
            
            Map<String, Id> mAssetType = new Map<String, Id>();
            for(RecordType recType: [Select Id, Name from RecordType
                                        Where (Name =: haBusiness
                                            OR Name =: haLand
                                            OR Name =: haNoAsset)
                                            AND SobjectType =: 'Housing_Application_Asset__c']){
                mAssetType.put(recType.Name, recType.Id);                                
            }
            if(!String.isBlank(haInstance.Id)) {
    
                
                //Start: Check Rule 1: None of the Income / Asset AMOUNTS cannot be equal to zero 
                Boolean isHavingZeroAmount = false;
                if(haInstance.Housing_Application_Incomes__r.size() > 0) {                
                    //Check all income records
                    for(Housing_Application_Income__c incom : haInstance.Housing_Application_Incomes__r) {
                        if(incom.Annual_Income_Amount__c == null || incom.Annual_Income_Amount__c == 0) {
                            isHavingZeroAmount = true;
                            break;
                        }
                    }
                }
                
                if(haInstance.Housing_Application_Assets__r.size() > 0) {    
                    //Check all asset records except business and land ownerships
                    for(Housing_Application_Asset__c asset : haInstance.Housing_Application_Assets__r) {
                       if(asset.Asset_Value__c == null || asset.Asset_Value__c == 0){
                                if(asset.RecordTypeId == mAssetType.get(haBusiness)){
                                    isHavingZeroAmount = false;                            
                                }else if(asset.RecordTypeId == mAssetType.get(haLand)){
                                    isHavingZeroAmount = false;
                                }else if(asset.RecordTypeId == mAssetType.get(haNoAsset)){
                                    isHavingZeroAmount = false;
                                }else{
                                    isHavingZeroAmount = true;
                                    break;
                                }
                        }
                    }
                }    
                /*if(haInstance.Housing_Application_Assets__r.size() > 0) {    
                    //Check all asset records except business and land ownerships
                    for(Housing_Application_Asset__c asset : haInstance.Housing_Application_Assets__r) {
                        if((asset.Asset_Value__c == null || asset.Asset_Value__c == 0) && 
                        (asset.RecordTypeId != mAssetType.get(haBusiness)) && (asset.RecordTypeId != mAssetType.get(haLand)) && (asset.RecordTypeId != mAssetType.get(haNoAsset))) {
                            isHavingZeroAmount = true;
                            break;
                        }
                    }
                    }    */
                System.debug(LoggingLevel.INFO, '==isHavingZeroAmount==' + isHavingZeroAmount);
                
                //Show message
                if(isHavingZeroAmount) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ERROR_HAPP_ZEROES));
                    return null;
                }
                //End: Check Rule 1
                
                //Start: Check Rule 2: 
                Boolean doesEvery18HaveAsset = true;
                
                for(Housing_Application_Member__c mem : haInstance.Housing_Application_Members1__r) {                    
                    if(mem.Member_Age__c >= 18) {
                        Boolean does18HaveAsset = false;
                        for(Housing_Application_Asset__c asset : haInstance.Housing_Application_Assets__r) {
                            if(asset.Housing_Application_Member__c == mem.Id) {
                                does18HaveAsset = true;                            
                            }
                        }
                        if(!does18HaveAsset) {
                            doesEvery18HaveAsset = false;
                            break;
                        }
                    }
                }
                
                if(!doesEvery18HaveAsset) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Your housing application can not be submitted at this moment as there should be at least one asset per 18+ member.'));
                    return null;
                }
                //End: Check Rule 2
                
                
                //Start: Check Rule 3: 
                Boolean doesEvery18HaveIncome = true;
                
                for(Housing_Application_Member__c mem : haInstance.Housing_Application_Members1__r) {                    
                    if(mem.Member_Age__c >= 18) {
                        Boolean does18HaveIncome = false;
                        for(Housing_Application_Income__c incom : haInstance.Housing_Application_Incomes__r) {
                            if(incom.Housing_Application_Member__c == mem.Id) {
                                does18HaveIncome = true;                            
                            }
                        }
                        if(!does18HaveIncome) {
                            doesEvery18HaveIncome = false;
                            break;
                        }
                    }
                }
                
                if(!doesEvery18HaveIncome) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Your housing application can not be submitted at this moment as there should be at least one income per 18+ member.'));
                    return null;
                }
                
                //End: Check Rule 3
                
                
                //Start: Check Rule 4
                Boolean doesHavePrimaryApplicant = false;
                
                for(Housing_Application_Member__c mem : haInstance.Housing_Application_Members1__r) {
                    if(mem.Relationship_to_Head_of_Household__c == 'Self') {
                        doesHavePrimaryApplicant = true;
                        break;
                    }
                }            
                if(!doesHavePrimaryApplicant ) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Your housing application can not be submitted at this moment as there should be at least one primary applicant.'));
                    return null;
                }            
                //End: Check Rule 4
                            //Start: Check Rule 5 Check if certificates are not yet consumed.
                Boolean bCOPUsed = FALSE;
                Boolean bEAHPUsed = FALSE;
                String HA_RENTAL = 'BMR Rental';
                String HA_OWNER = 'BMR Ownership';
                Map<String, Id> mapRecordType = new Map<String, Id>();
                
                //COP            
                if((haInstance.Certificate_of_Preference_Holder__c == TRUE) && (haInstance.Certificate_of_Preference_Number__c != null)){
    
                    
                    for(RecordType recType: [Select Name, Id from RecordType 
                                            where (((Name =: HA_OWNER) 
                                                    OR (Name =: HA_RENTAL) ) 
                                                    AND SobjectType =: 'Housing_Application__c')] 
                                                ){
                    mapRecordType.put(recType.Name, recType.Id);
                    }
                    String sCOPNumber = haInstance.Certificate_of_Preference_Number__c;
    
                    List<Certificate_Program__c> lCPCOP = [Select Id, RecordTypeId, Name, COPP_Rental_Used__c, 
                                                    COPP_Ownership_Used__c from Certificate_Program__c 
                                                    where Name =: sCOPNumber LIMIT 1];
                                                               
                    if(lCPCOP.size() > 0){
                        //Rental
                        if((haInstance.RecordTypeId == mapRecordType.get(HA_RENTAL)) 
                            && (lCPCOP[0].COPP_Rental_Used__c == TRUE) ){
                            bCOPUsed = TRUE;
                        }                   
                    
                        //Ownership
                        if((haInstance.RecordTypeId == mapRecordType.get(HA_OWNER)) 
                            && (lCPCOP[0].COPP_Ownership_Used__c == TRUE) ){
                            bCOPUsed = TRUE;
                        }  
                    }                                
                }
                
                if((haInstance.EAHP_Certificate_Holder__c == TRUE) && (haInstance.EAHP_Certificate_Expiration_Date__c != null)){
    
                    Date EAHPDate = haInstance.EAHP_Certificate_Expiration_Date__c;
                    List<Certificate_Program__c> lCPEAHP = [Select Id, Household_Account__c, EAHP_Certificate_Used__c, Expiration_Date_for_Existing_Properties__c from Certificate_Program__c 
                                                    where Expiration_Date_for_Existing_Properties__c =: EAHPDate];
                    
                    Integer count = 1;                                
                    for(Certificate_Program__c cp: lCPEAHP){
                        System.debug(count+ 'HA: ' +haInstance.Household_Account__c+ ' HACP: ' +cp.Household_Account__c+ 'Date: ' +cp.Expiration_Date_for_Existing_Properties__c+ ' Type: ' +cp.RecordTypeId+  ' EAHP ' +cp.EAHP_Certificate_Used__c);
                        count++;
                    } 
                                                    
                    if(lCPEAHP.size() > 0){
                        for(Certificate_Program__c eahp: lCPEAHP){
                            if((eahp.Household_Account__c == haInstance.Household_Account__c) && (eahp.EAHP_Certificate_Used__c == TRUE)){
                            bEAHPUsed = TRUE;
                            } 
                        }            
                    }
                }  
                
                System.debug('EAHP Used ' +bEAHPUsed);   
                if(bCOPUsed == TRUE) {
                    String COPType;
                    if(haInstance.RecordTypeId == mapRecordType.get(HA_RENTAL)){
                        COPType = 'rental.';
                    }
                    
                    if(haInstance.RecordTypeId == mapRecordType.get(HA_OWNER)){
                        COPType = 'ownership.';
                    }
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Certificate of Preference has already been used for ' +COPType));
                    return null;
                }  
                
                if(bEAHPUsed == TRUE) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Ellis Act Housing Preference Certificate has already been used.'));
                    return null;
                }            
                //End: Check Rule 5
                
                haInstance.Application_Status__c = 'Submitted';
                update haInstance;  
                fetchHousingApplication();
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Your housing application submitted successfully!'));
                                    
                //Clean old Data i.e. Delete all old contacts which will delete associated Person Asset and Income records            
                List<Contact> lContacts = [SELECT Id, Name, AccountId FROM Contact 
                    WHERE AccountId =: usr.Contact.AccountId AND Id !=: usr.ContactId];
                if(!lContacts.isEmpty()) Database.delete(lContacts, false);
                //Copy all Members
                
                Map<String, Contact> mNewContacts = prepareContactList(haInstance.Housing_Application_Members1__r);
                
                
                if(!mNewContacts.isEmpty()) {
                    prepareIncomeList(haInstance.Housing_Application_Incomes__r, mNewContacts);
                    
                    //Copy all Assets
                    prepareAssetList(haInstance.Housing_Application_Assets__r, mNewContacts);
                }
            }

            return null;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
        }
        return null;
    }
    
    private void prepareAssetList(List<Housing_Application_Asset__c> lAssets, Map<String, Contact> mContacts) {
    
        List<Personal_Asset__c> lPersonalAssets = new List<Personal_Asset__c>();
        
        for(Housing_Application_Asset__c asset : lAssets) {
            
            Personal_Asset__c paInstance = new Personal_Asset__c();
            paInstance.Account_Number__c = asset.Account_Number__c; 
            paInstance.Amount_of_Gift_Deposited_into_Rec_Acct__c = asset.Amount_of_Gift_Deposited_into_Rec_Acct__c; 
            paInstance.Asset_Type__c = asset.Asset_Type__c; 
            paInstance.Cash_or_Market_Value__c = asset.Cash_or_Market_Value__c; 
            paInstance.Current_Cash_Value_of_Gift__c = asset.Current_Cash_Value_of_Gift__c; 
            paInstance.Date_of_Gift_Letter__c = asset.Date_of_Gift_Letter__c; 
            paInstance.Date_of_Most_Recent_Statement__c = asset.Date_of_Most_Recent_Statement__c; 
            paInstance.Escrow_Account_Number__c = asset.Escrow_Account_Number__c; 
            paInstance.Escrow_Acct_Institution_Address__c = asset.Escrow_Acct_Institution_Address__c; 
            paInstance.Escrow_Acct_Institution_Name__c = asset.Escrow_Acct_Institution_Name__c; 
            paInstance.Escrow_Acct_Institution_Phone_Number__c = asset.Escrow_Acct_Institution_Phone_Number__c; 
            paInstance.Escrow_Amount_Deposited__c = asset.Escrow_Amount_Deposited__c; 
            paInstance.Escrow_Date_of_Deposit__c = asset.Escrow_Date_of_Deposit__c; 
            paInstance.Escrow_Type_of_Account__c = asset.Escrow_Type_of_Account__c; 
            paInstance.GR_Acct_Inst_Date_of_Last_Statement__c = asset.GR_Acct_Inst_Date_of_Last_Statement__c; 
            paInstance.GR_Acct_Inst_Phone__c = asset.GR_Acct_Inst_Phone__c; 
            paInstance.GR_Acct_Most_Recent_Balance__c = asset.GR_Acct_Most_Recent_Balance__c; 
            paInstance.Gift_Funds_Bank_Depository_Account__c = asset.Gift_Funds_Bank_Depository_Account__c; 
            paInstance.Gift_Funds_Location_Address__c = asset.Gift_Funds_Location_Address__c; 
            paInstance.Gift_Funds_Location_Bank_Depository_Name__c = asset.Gift_Funds_Location_Bank_Depository_Name__c; 
            paInstance.Gift_Funds_Location_Phone__c = asset.Gift_Funds_Location_Phone__c; 
            paInstance.Gift_Funds_Type_Other_description__c = asset.Gift_Funds_Type_Other_description__c; 
            paInstance.Gift_Funds_Type_of_Account__c = asset.Gift_Funds_Type_of_Account__c; 
            paInstance.Gift_Recipient_Account_Address__c = asset.Gift_Recipient_Account_Address__c; 
            paInstance.Gift_Recipient_Account_Institution_Name__c = asset.Gift_Recipient_Account_Institution_Name__c; 
            paInstance.Gift_Recipient_s_Account_Number__c = asset.Gift_Recipient_s_Account_Number__c; 
            paInstance.Gifter_Donor_Address__c = asset.Gifter_Donor_Address__c; 
            paInstance.Gifter_Donor_Name__c = asset.Gifter_Donor_Name__c; 
            paInstance.Gifter_Donor_Phone_Number__c = asset.Gifter_Donor_Phone_Number__c; 
            paInstance.Gifter_Donor_Relationship_to_Recipient__c = asset.Gifter_Donor_Relationship_to_Recipient__c; 
            
            if(mContacts.containsKey(asset.Housing_Application_Member__r.First_Name__c + '-' + asset.Housing_Application_Member__r.Last_Name__c + '-' + asset.Housing_Application_Member__r.Date_of_Birth__c)) {
                Contact con = mContacts.get(asset.Housing_Application_Member__r.First_Name__c + '-' + asset.Housing_Application_Member__r.Last_Name__c + '-' + asset.Housing_Application_Member__r.Date_of_Birth__c);
                paInstance.Household_Member__c = con.Id; 
                paInstance.Household_Account__c =  con.AccountId;
            }            
            paInstance.Is_this_a_joint_account__c = asset.Is_this_a_joint_account__c; 
            paInstance.Most_Recent_Balance__c = asset.Most_Recent_Balance__c; 
            paInstance.Name_of_Institution__c = asset.Name_of_Institution__c; 
            paInstance.Name_of_joint_account_holders__c = asset.Name_of_joint_account_holders__c; 
            paInstance.Relationship_if_Other__c = asset.Relationship_if_Other__c;
            paInstance.Settlement_or_Other_Description__c = asset.Settlement_or_Other_Description__c; 
            paInstance.Stock_Bond_Description__c = asset.Stock_Bond_Description__c; 
            paInstance.Total_Cash_Not_Deposited_in_Any_Account__c = asset.Total_Cash_Not_Deposited_in_Any_Account__c; 
            paInstance.Withdrawn_From_Acct_Inst_Account_Number__c = asset.Withdrawn_From_Acct_Inst_Account_Number__c; 
            paInstance.Withdrawn_From_Acct_Inst_Address__c = asset.Withdrawn_From_Acct_Inst_Address__c; 
            paInstance.Withdrawn_From_Acct_Inst_Name__c = asset.Withdrawn_From_Acct_Inst_Name__c; 
            paInstance.Withdrawn_From_Acct_Inst_Phone__c = asset.Withdrawn_From_Acct_Inst_Phone__c; 
            
            //VIMP: Assign RecordType using RecordType.Name
            paInstance.RecordTypeId = Schema.SObjectType.Personal_Asset__c.getRecordTypeInfosByName().get(asset.RecordType.Name).getRecordTypeId(); 
            
            lPersonalAssets.add(paInstance);
        }
        if(!lPersonalAssets.isEmpty()) Database.insert(lPersonalAssets);
    }
    
    private void prepareIncomeList(List<Housing_Application_Income__c> lIncomes, Map<String, Contact> mContacts) {
    
        List<Personal_Income__c> lPersonalIncomes = new List<Personal_Income__c>();
        
        for(Housing_Application_Income__c income : lIncomes) {
            
           Personal_Income__c piInstance = new Personal_Income__c();
           piInstance.Year_Unemployed__c = income.Year_Unemployed__c;           
           piInstance.Total_Number_of_Pay_Periods_Annually__c = income.Total_Number_of_Pay_Periods_Annually__c;
           piInstance.Tax_Year_2_Taxable_Annual_Income__c = income.Tax_Year_2_Taxable_Annual_Income__c;
           piInstance.Tax_Year_1_Taxable_Annual_Income__c = income.Tax_Year_1_Taxable_Annual_Income__c;
           piInstance.Social_Security_Pensions_Rec_d_Annually__c = income.Social_Security_Pensions_Rec_d_Annually__c;
           piInstance.Self_Employment_Starting_Year__c = income.Self_Employment_Starting_Year__c;
           piInstance.Self_Employment_Starting_Month__c = income.Self_Employment_Starting_Month__c;
           piInstance.Self_Employment_Income_Declaration_Type__c = income.Self_Employment_Income_Declaration_Type__c;
           piInstance.Public_Assistance_Received_Annually__c = income.Public_Assistance_Received_Annually__c;
           piInstance.Paycheck_3_Year_To_Date_Gross_Amount__c = income.Paycheck_3_Year_To_Date_Gross_Amount__c;
           piInstance.Paycheck_3_Total_Gross_Amount__c = income.Paycheck_3_Total_Gross_Amount__c;
           piInstance.Paycheck_3_Period__c = income.Paycheck_3_Period__c;
           piInstance.Paycheck_3_Pay_Date__c = income.Paycheck_3_Pay_Date__c;
           piInstance.Paycheck_2_Year_To_Date_Gross_Amount__c = income.Paycheck_2_Year_To_Date_Gross_Amount__c;
           piInstance.Paycheck_2_Total_Gross_Amount__c = income.Paycheck_2_Total_Gross_Amount__c;
           piInstance.Paycheck_2_Period__c = income.Paycheck_2_Period__c;
           piInstance.Paycheck_2_Pay_Date__c = income.Paycheck_2_Pay_Date__c;
           piInstance.Paycheck_1_Year_To_Date_Gross_Amount__c = income.Paycheck_1_Year_To_Date_Gross_Amount__c;
           piInstance.Paycheck_1_Total_Gross_Amount__c = income.Paycheck_1_Total_Gross_Amount__c;
           piInstance.Paycheck_1_Period__c = income.Paycheck_1_Period__c;
           piInstance.Paycheck_1_Pay_Date__c = income.Paycheck_1_Pay_Date__c;
           piInstance.Pay_Period_Frequency__c = income.Pay_Period_Frequency__c;
           piInstance.Pay_Date__c = income.Pay_Date__c;
           piInstance.Pay_Amount__c = income.Pay_Amount__c;
           piInstance.Other_Incomes_Received_Annually__c = income.Other_Incomes_Received_Annually__c;
           piInstance.Most_Recent_Tax_Year_2__c = income.Most_Recent_Tax_Year_2__c;
           piInstance.Most_Recent_Tax_Year_1__c = income.Most_Recent_Tax_Year_1__c;
           piInstance.Most_Recent_Profit_or_Loss_Status__c = income.Most_Recent_Profit_or_Loss_Status__c;
           piInstance.Most_Recent_Profit_or_Loss_Amount__c = income.Most_Recent_Profit_or_Loss_Amount__c;
           piInstance.Month_Unemployed__c = income.Month_Unemployed__c;
           piInstance.Interest_Dividends_Received_Annually__c = income.Interest_Dividends_Received_Annually__c;
           piInstance.Income_from_Land_or_Business_Annually__c = income.Income_from_Land_or_Business_Annually__c;
           piInstance.How_many_times_year_get_P_L_Statement__c = income.How_many_times_year_get_P_L_Statement__c;
           
           //VIMP: Contact and Account Mappings
           if(mContacts.containsKey(income.Housing_Application_Member__r.First_Name__c + '-' + income.Housing_Application_Member__r.Last_Name__c + '-' + income.Housing_Application_Member__r.Date_of_Birth__c)) {
                Contact con = mContacts.get(income.Housing_Application_Member__r.First_Name__c + '-' + income.Housing_Application_Member__r.Last_Name__c + '-' + income.Housing_Application_Member__r.Date_of_Birth__c);
                piInstance.Household_Member__c = con.Id; 
                piInstance.Household_Account__c =  con.AccountId;
           }
           
           piInstance.First_Date_of_Employment__c = income.First_Date_of_Employment__c;
           piInstance.Employment_Status__c = income.Employment_Status__c;
           piInstance.Employer_Name__c = income.Employer_Name__c;
           piInstance.Employer_Address__c = income.Employer_Address__c;
           piInstance.Date_of_Most_Recent_P_L_Stmt__c = income.Date_of_Most_Recent_P_L_Stmt__c;
           piInstance.Child_Support_Alimony_Received_Annually__c = income.Child_Support_Alimony_Received_Annually__c;
           piInstance.Base_Annual_Employment_Income__c = income.Base_Annual_Employment_Income__c;
           piInstance.Applicant_Unemployed__c = income.Applicant_Unemployed__c;
           piInstance.Applicant_Self_employed__c = income.Applicant_Self_employed__c;
           piInstance.Annualized_Income__c = income.Annualized_Income__c;
           piInstance.Annual_Unemployment_Benefits_Amount__c = income.Annual_Unemployment_Benefits_Amount__c;
           piInstance.Annual_Overtime__c = income.Annual_Overtime__c;
           piInstance.Annual_Commissions_Bonuses_Tips__c = income.Annual_Commissions_Bonuses_Tips__c;
           
           //Assign RecordType using RecordType.Name
           piInstance.RecordTypeId = Schema.SObjectType.Personal_Income__c.getRecordTypeInfosByName().get(income.RecordType.Name).getRecordTypeId(); 
           
           lPersonalIncomes.add(piInstance);
        }
        if(!lPersonalIncomes.isEmpty()) Database.insert(lPersonalIncomes);
    }
    
    private Map<String, Contact> prepareContactList(List<Housing_Application_Member__c> lMembers) {
       
        List<Contact> lContacts = new List<Contact>();
        Map<String, Contact> mContacts = new Map<String, Contact>();
        User usr = [SELECT Id, Name, ContactId, Contact.AccountId FROM User WHERE Id =: Userinfo.getUserId() LIMIT 1];
        Id houseHoldRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        Housing_Application_Member__c selfMember = new Housing_Application_Member__c();
        Contact selfContact = new Contact();
        
        for(Housing_Application_Member__c mem : lMembers) {
            if(mem.Relationship_to_Head_of_Household__c == 'Self'){
                selfMember = mem;
            }else{
                Contact conInstance = new Contact();
                
                //Assign all fields from member to Contact
                conInstance.Zip_Code__c = mem.Zip_Code__c;
                conInstance.Work_Phone__c = mem.Work_Phone__c;
                conInstance.Name_Suffix__c = mem.Suffix__c; 
                conInstance.Street_Type__c = mem.Street_Type__c; 
                conInstance.Street_Number__c = mem.Street_Number__c; 
                conInstance.Street_Name__c = mem.Street_Name__c; 
                conInstance.State__c = mem.State__c; 
                conInstance.Salutation = mem.Salutation__c; 
                conInstance.Contact_Mailing_Address__c = mem.Mailing_Address__c;
                conInstance.Relationship_to_Head_of_Household__c = mem.Relationship_to_Head_of_Household__c; 
                conInstance.Relationship_to_Head_of_HH_if_Other__c = mem.Relationship_to_Head_of_HH_if_Other__c; 
                conInstance.Race_Ethnicity_optional__c = mem.Race_Ethnicity_optional__c; 
                conInstance.Race_Ethnicity_Other_details__c = mem.Race_Ethnicity_Other_details__c;
                conInstance.Occupation__c = mem.Occupation__c; 
                conInstance.Middle_Name__c = mem.Middle_Name__c;           
                conInstance.Married_or_Domestic_Partnered__c = mem.Married_or_Domestic_Partnered__c;
                conInstance.Live_Or_Work_in_San_Francisco__c = mem.Live_Or_Work_in_San_Francisco__c; 
                conInstance.LastName = mem.Last_Name__c;
                conInstance.In_School__c = mem.In_School__c; 
                conInstance.HomePhone = mem.Home_Phone__c; 
                conInstance.Relationship_to_Head_of_Household__c = mem.Relationship_to_Head_of_Household__c; 
                conInstance.Gender__c = mem.Gender__c; 
                conInstance.Full_Time_Student__c = mem.Full_Time_Student__c;             
                conInstance.FirstName = mem.First_Name__c; 
                conInstance.Email = mem.Email_Address__c; 
                conInstance.Birthdate = mem.Date_of_Birth__c; 
                conInstance.City__c = mem.City__c; 
                conInstance.MobilePhone = mem.Cell_Phone__c; 
                conInstance.Apt_Unit__c = mem.Apt_Unit__c; 
                conInstance.Address_Line_2__c = mem.Address_Line_2__c; 
                conInstance.AccountId = usr.Contact.AccountId;
                conInstance.RecordTypeId = houseHoldRTId;
                lContacts.add(conInstance);
            }
        }    
        
        if(selfMember.Id != null){
            List<Contact> contacts = new List<Contact>([SELECT Id,FirstName,LastName,Gender__c,Occupation__c,Birthdate,Relationship_to_Head_of_Household__c,
                                                        In_School__c,Full_Time_Student__c,Married_or_Domestic_Partnered__c,Live_Or_Work_in_San_Francisco__c,
                                                        Certificate_of_Preference_Holder__c,Certificate_of_Preference__c,EAHP_Certificate_Holder__c,EAHP_Cert_Exp_Date_New_Dev__c,
                                                        Has_owned_a_unit_last_3_yrs__c,Does_this_appear_on_another_title__c,RecordTypeId FROM Contact WHERE Id=: usr.ContactId LIMIT 1]);
            if(contacts.size() > 0){
                contacts[0].FirstName = selfMember.First_Name__c; 
                contacts[0].LastName = selfMember.Last_Name__c;
                contacts[0].Gender__c = selfMember.Gender__c; 
                contacts[0].Occupation__c = selfMember.Occupation__c; 
                contacts[0].Birthdate = selfMember.Date_of_Birth__c; 
                contacts[0].Relationship_to_Head_of_Household__c = selfMember.Relationship_to_Head_of_Household__c; 
                contacts[0].In_School__c = selfMember.In_School__c; 
                contacts[0].Full_Time_Student__c = selfMember.Full_Time_Student__c;             
                contacts[0].Married_or_Domestic_Partnered__c = selfMember.Married_or_Domestic_Partnered__c;
                contacts[0].Live_Or_Work_in_San_Francisco__c = selfMember.Live_Or_Work_in_San_Francisco__c; 
                contacts[0].Certificate_of_Preference_Holder__c = selfMember.Certificate_of_Preference_Holder__c;
                contacts[0].Certificate_of_Preference__c = selfMember.Certificate_of_Preference__c; 
                contacts[0].EAHP_Certificate_Holder__c = selfMember.EAHP_Certificate_Holder__c;
                contacts[0].EAHP_Cert_Exp_Date_New_Dev__c = selfMember.EAHP_Cert_Exp_Date_New_Dev__c;
                contacts[0].Has_owned_a_unit_last_3_yrs__c = selfMember.Has_owned_a_unit_last_3_yrs__c; 
                contacts[0].Does_this_appear_on_another_title__c = selfMember.Does_this_appear_on_another_title__c; 
                contacts[0].RecordTypeId = houseHoldRTId;
                
                List<Personal_Income__c> pIncomes = new List<Personal_Income__c>([SELECT Id FROM Personal_Income__c WHERE Household_Member__c =:usr.ContactId]);
                
                if(pIncomes.size()>0){
                    Database.delete(pIncomes);
                }
                
                List<Personal_Asset__c> pAssets = new List<Personal_Asset__c>([SELECT Id FROM Personal_Asset__c WHERE Household_Member__c =:usr.ContactId]);
                
                if(pAssets.size()>0){
                    Database.delete(pAssets);
                }
                                
                update contacts;
                selfContact = contacts[0];
                mContacts.put(selfContact.FirstName + '-' + selfContact.LastName + '-' + selfContact.Birthdate, selfContact);
            }        
        }
        
        System.debug(LoggingLevel.INFO, '==prepareContactList lContacts==' + lContacts);
        if(lContacts.size()>0) {
            //insert new contacts
            Database.insert(lContacts,false);        
            
            //create map of contacts and return them
            
            for(Contact con : lContacts) {
                mContacts.put(con.FirstName + '-' + con.LastName + '-' + con.Birthdate, con);
            }
            
            System.debug(LoggingLevel.INFO, '==prepareContactList mContacts==' + mContacts);
            return mContacts;
        }

        return mContacts;
    }

    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/08/2014
    * @description : Apex method that adds the member to Housing Application
    * @parameters : Nothing
    * @returns : PageReference
    */
    public PageReference addMember() {
        /*if(String.isBlank(haInstance.Id)) {
            createHousingApp();
        }*/        
        memberInstance.Housing_Application__c = haInstance.Id;

        //For error message
        CS_MOHCDHousingAppCCContainer container = validateMemberFields(memberInstance);         
        ErrorMessagesMember = container.errorMessage;
        errorMember = container.error;
        
        if(ErrorMessagesMember == ''){
            insert memberInstance;
            fetchHousingApplication();
            memberInstance = new Housing_Application_Member__c(); 
        }
        
        System.debug('ErrorMessagesMember: ' +ErrorMessagesMember); 
        System.debug('errorMember: ' +errorMember);           
        return null;
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/08/2014
    * @description : Apex method that fetches whole Housing Application with child records for selected property and user
    * @parameters : Nothing
    * @returns : Nothing
    */
    private void fetchHousingApplication() {
        haInstance = new Housing_Application__c();
        if(!String.isBlank(propInstance.Id)) {
            List<Housing_Application__c> lHousingApps = [Select Id, Name, Application_Status__c, Property_of_Interest__c,
                Property_of_Interest__r.Name, CreatedById, OwnerId, Lottery_Number__c, Lottery_Rank__c, 
                Household_Account__c, 
                
                Housing_Application_E_Signed__c,
                Name_of_Agency_Helping_Applicant_If_Any__c,
                How_Applicant_Learned_About_This_Listing__c,
                If_Flyer_Where_Was_the_Flyer_Posted__c, If_Newspaper_Which_Newspaper__c,
                If_Social_Media_Which_Social_Media__c, If_Other_Please_Describe__c,
                Live_Or_Work_in_San_Francisco__c, Certificate_of_Preference_Holder__c,
                Certificate_of_Preference_Number__c, EAHP_Certificate_Expiration_Date__c,
                EAHP_Certificate_Holder__c, Does_any_member_appear_on_unit_s_title__c,
                Does_any_household_member_own_land__c, Does_any_member_own_a_business__c,

                (Select Id, Name, Zip_Code__c, Work_Phone__c, Suffix__c, Street_Type__c, 
                Street_Number__c, Street_Name__c, State__c, Salutation__c, Applicant_Role__c,
                Relationship_to_Head_of_Household__c, Relationship_to_Head_of_HH_if_Other__c, 
                Race_Ethnicity_optional__c, Race_Ethnicity_Other_details__c, Occupation__c, 
                Middle_Name__c, Member_Full_Name__c, Member_Age__c, Married_or_Domestic_Partnered__c, 
                Mailing_Address__c, Live_Or_Work_in_San_Francisco__c, Last_Name__c, In_School__c, 
                Home_Phone__c, Head_of_Household__c, Gender__c, Full_Time_Student__c, Full_Address__c, 
                First_Name__c, Email_Address__c, Date_of_Birth__c, City__c, Cell_Phone__c, Apt_Unit__c, 
                Address_Line_2__c, EAHP_Cert_Exp_Date_New_Dev__c, EAHP_Certificate_Holder__c, Certificate_of_Preference__c,
                Certificate_of_Preference_Holder__c, Does_this_appear_on_another_title__c, Has_owned_a_unit_last_3_yrs__c, 
                Does_this_member_own_land__c                
                From Housing_Application_Members1__r),
                 
                (Select Id, Name, Annualized_Income__c, Employer_Name__c, Housing_Application_Member_Name__c,
                Housing_Application_Member__r.Member_Age__c, Housing_Application_Member__r.Date_of_Birth__c,
                Housing_Application_Member__r.Last_Name__c, Housing_Application_Member__r.First_Name__c,
                RecordTypeId, RecordType.Name,  Pay_Period_Frequency__c, Employer_Address__c, 
                Total_Number_of_Pay_Periods_Annually__c, Employment_Status__c, Annual_Overtime__c,
                Base_Annual_Employment_Income__c, First_Date_of_Employment__c, Paycheck_1_Pay_Date__c, 
                Annual_Commissions_Bonuses_Tips__c, Paycheck_1_Year_To_Date_Gross_Amount__c,
                Paycheck_1_Period__c, Paycheck_2_Pay_Date__c, Paycheck_2_Year_To_Date_Gross_Amount__c,
                Paycheck_2_Period__c, Paycheck_3_Pay_Date__c, Paycheck_3_Year_To_Date_Gross_Amount__c,
                Paycheck_3_Period__c, Interest_Dividends_Received_Annually__c,
                Public_Assistance_Received_Annually__c, Child_Support_Alimony_Received_Annually__c,
                Income_from_Land_or_Business_Annually__c, Social_Security_Pensions_Rec_d_Annually__c,
                Other_Incomes_Received_Annually__c, Applicant_Self_employed__c, 
                Date_of_Most_Recent_P_L_Stmt__c, Self_Employment_Starting_Year__c, 
                Self_Employment_Starting_Month__c, Most_Recent_Profit_or_Loss_Status__c,
                Most_Recent_Profit_or_Loss_Amount__c, Applicant_Unemployed__c, 
                Annual_Unemployment_Benefits_Amount__c, Year_Unemployed__c, Month_Unemployed__c,
                Tax_Year_2_Taxable_Annual_Income__c, Tax_Year_1_Taxable_Annual_Income__c,
                Self_Employment_Income_Declaration_Type__c, Paycheck_3_Total_Gross_Amount__c,
                Paycheck_2_Total_Gross_Amount__c, Paycheck_1_Total_Gross_Amount__c, 
                Pay_Date__c, Pay_Amount__c, Most_Recent_Tax_Year_2__c, Most_Recent_Tax_Year_1__c,
                How_many_times_year_get_P_L_Statement__c, Annual_Income_Amount__c
                From Housing_Application_Incomes__r), 
                
                (Select Id, Name, Current_Cash_Value_of_Gift__c, Name_of_Institution__c, RecordType.Name, 
                GR_Acct_Most_Recent_Balance__c, Amount_of_Gift_Deposited_into_Rec_Acct__c,
                Housing_Application_Member__r.Member_Age__c, Housing_Application_Member__r.Date_of_Birth__c,
                GR_Acct_Inst_Date_of_Last_Statement__c, GR_Acct_Inst_Phone__c, Settlement_or_Other_Description__c, 
                Gift_Recipient_s_Account_Number__c, Gift_Recipient_Account_Address__c, Stock_Bond_Description__c,
                Gift_Recipient_Account_Institution_Name__c, Gift_Funds_Bank_Depository_Account__c,
                Gift_Funds_Type_Other_description__c, Gift_Funds_Type_of_Account__c, Asset_Value__c,               
                Gift_Funds_Location_Address__c, Gift_Funds_Location_Phone__c, Is_this_a_joint_account__c, 
                Gift_Funds_Location_Bank_Depository_Name__c, Gifter_Donor_Phone_Number__c,
                Relationship_if_Other__c, Gifter_Donor_Address__c, Gifter_Donor_Name__c,
                Gifter_Donor_Relationship_to_Recipient__c, Date_of_Gift_Letter__c, Date_of_Most_Recent_Statement__c,
                Total_Cash_Not_Deposited_in_Any_Account__c, Name_of_joint_account_holders__c,
                Housing_Application_Member__r.Last_Name__c, Housing_Application_Member__r.First_Name__c, 
                Account_Number__c, Asset_Type__c, Most_Recent_Balance__c, Housing_Application_Member__c, Cash_or_Market_Value__c, 
                Housing_Application_Member_Name__c, Retirement_Asset_Type__c, Escrow_Account_Number__c,
                Escrow_Acct_Institution_Address__c, Escrow_Acct_Institution_Name__c, Escrow_Acct_Institution_Phone_Number__c,
                Escrow_Amount_Deposited__c, Escrow_Date_of_Deposit__c, Escrow_Type_of_Account__c, 
                Withdrawn_From_Acct_Inst_Account_Number__c, Withdrawn_From_Acct_Inst_Address__c, 
                Withdrawn_From_Acct_Inst_Name__c, Withdrawn_From_Acct_Inst_Phone__c, RecordTypeId, Name_of_Business__c, Address_of_Business__c,
                Amount_Earned_Per_Year_from_Business__c, Land_Address_or_Parcel_Desc__c, Current_Value_of_Land__c, Landowner_Earns_Income_from_Land__c,
                Land_Earned_Income_Per_Year__c
                From Housing_Application_Assets__r),
                
                (Select Id, ParentId, Name, BodyLength, ContentType, Description From Attachments),
                
                (Select Id, Title FROM Notes WHERE Title='MOHCD Document Submission')
                
                FROM Housing_Application__c 
                WHERE Property_of_Interest__c =: propInstance.Id 
                    AND OwnerId =: Userinfo.getUserId()
                ORDER BY CreatedDate DESC
                LIMIT 1];
                
                if(!lHousingApps.isEmpty()) {
                    haInstance = lHousingApps[0];
                    
                    if(haInstance.Notes.size() > 0) {
                        isSubmittingHardCopy = true;
                    }
                }
        }
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/08/2014
    * @description : Apex method that takes the user to next tab
    * @parameters : Nothing
    * @returns : PageReference
    */    
    public PageReference nextTab() {
        
        /*if(intSelectedTabNumber == 1) {
            //Create Housing App Record
            createHousingApp();
        }*/
        intSelectedTabNumber ++;  
        assignInstructionText();
        return null;
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/08/2014
    * @description : Apex method that takes the user to previous tab
    * @parameters : Nothing
    * @returns : PageReference
    */    
    public PageReference prevTab() {          
        intSelectedTabNumber --;  
        assignInstructionText();
        return null;
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/08/2014
    * @description : Apex method that takes the user to previous tab
    * @parameters : Nothing
    * @returns : PageReference
    */    
    public PageReference refreshTab() {
        erroreditMember = FALSE;
        ErrorMessagesEditMember = '';
        assignInstructionText();
        fetchHousingApplication();
        return null;
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 07/08/2014
    * @description : Apex method that creates Housing App Instance for logged in User under property
    * @parameters : Nothing
    * @returns : Nothing
    */    
    public void createHousingApp() {          
        
        try {
            if((propInstance != null && propInstance.Id != null) && (haInstance == null || haInstance.Id ==  null)) {
                
                Housing_Application__c oldHousingApp = checkIfOldAppExist();
                                       
                haInstance = new Housing_Application__c(Property_of_Interest__c = propInstance.Id, 
                    OwnerId = Userinfo.getUserId(), Application_Status__c = 'Not Yet Submitted',
                    Household_Account__c = usr.Contact.AccountId);
                
                if(propInstance.Occupancy_Type__c == 'Ownership') {
                    haInstance.RecordTypeId = Schema.SObjectType.Housing_Application__c.getRecordTypeInfosByName().get('BMR Ownership').getRecordTypeId();
                } else if(propInstance.Occupancy_Type__c == 'Rental') {
                    haInstance.RecordTypeId = Schema.SObjectType.Housing_Application__c.getRecordTypeInfosByName().get('BMR Rental').getRecordTypeId();
                }
                insert haInstance;
                System.debug(LoggingLevel.INFO, '==haInstance=='+haInstance);
                
                //If there is an existing application exist for user 
                if(haInstance.Id != null && oldHousingApp != null) {
                    
                    System.debug(LoggingLevel.INFO, '==oldHousingApp=='+oldHousingApp);
                    
                    List<Housing_Application_Member__c> lMembers = new List<Housing_Application_Member__c>();
                    List<Housing_Application_Income__c> lIncomes = new List<Housing_Application_Income__c>();
                    List<Housing_Application_Asset__c> lAssets = new List<Housing_Application_Asset__c>();
                    
                    //Create Members
                    for(Housing_Application_Member__c mem : oldHousingApp.Housing_Application_Members1__r) {
                        Housing_Application_Member__c tMember = new Housing_Application_Member__c();
                        tMember = mem.clone(false,true);
                        tMember.Housing_Application__c = haInstance.Id; 
                        lMembers.add(tMember);
                    }
                    insert lMembers;
                    System.debug(LoggingLevel.INFO, '==creatHousingApplication lMembers=='+lMembers);
                    
                    Map<String, Housing_Application_Member__c> mMemberMap = new Map<String, Housing_Application_Member__c>();
                    for(Housing_Application_Member__c mem : lMembers) {
                        mMemberMap.put(mem.First_Name__c + '-' + mem.Last_Name__c + '-' + mem.Date_of_Birth__c, mem);
                    }
                      
                    //Create Incomes                 
                    for(Housing_Application_Income__c incom : oldHousingApp.Housing_Application_Incomes__r) {
                        Housing_Application_Income__c tIncome = new Housing_Application_Income__c();
                        tIncome = incom.clone(false,true);
                        tIncome.Housing_Application__c = haInstance.Id;                       
                        tIncome.Housing_Application_Member__c = mMemberMap.get(incom.Housing_Application_Member__r.First_Name__c + '-' + incom.Housing_Application_Member__r.Last_Name__c + '-' + incom.Housing_Application_Member__r.Date_of_Birth__c).Id;
                        tIncome.Annual_Commissions_Bonuses_Tips__c = 0;
                        tIncome.Annualized_Income__c = 0;
                        tIncome.Annual_Overtime__c = 0;
                        tIncome.Annual_Unemployment_Benefits_Amount__c = 0;
                        tIncome.Base_Annual_Employment_Income__c = 0;
                        tIncome.Child_Support_Alimony_Received_Annually__c = 0;
                        tIncome.Income_from_Land_or_Business_Annually__c = 0;
                        tIncome.Interest_Dividends_Received_Annually__c = 0;
                        tIncome.Most_Recent_Profit_or_Loss_Amount__c = 0;
                        tIncome.Other_Incomes_Received_Annually__c = 0;
                        tIncome.Pay_Amount__c = 0;
                        tIncome.Paycheck_1_Total_Gross_Amount__c = 0;
                        tIncome.Paycheck_1_Year_To_Date_Gross_Amount__c = 0;
                        tIncome.Paycheck_2_Total_Gross_Amount__c = 0;
                        tIncome.Paycheck_2_Year_To_Date_Gross_Amount__c = 0;
                        tIncome.Paycheck_3_Total_Gross_Amount__c = 0;
                        tIncome.Paycheck_3_Year_To_Date_Gross_Amount__c = 0;
                        tIncome.Public_Assistance_Received_Annually__c = 0;
                        tIncome.Social_Security_Pensions_Rec_d_Annually__c = 0;
                        tIncome.Total_Other_Income_Rec_d_Annually_RS__c = 0;
                        lIncomes.add(tIncome);
                    }
                    insert lIncomes;
                    System.debug(LoggingLevel.INFO, '==lIncomes=='+lIncomes);
                    
                    //Create Assets
                    for(Housing_Application_Asset__c asset : oldHousingApp.Housing_Application_Assets__r) {
                        Housing_Application_Asset__c tAsset = new Housing_Application_Asset__c();
                        tAsset = asset.clone(false,true);
                        tAsset.Housing_Application__c = haInstance.Id;                       
                        tAsset.Housing_Application_Member__c = mMemberMap.get(asset.Housing_Application_Member__r.First_Name__c + '-' + asset.Housing_Application_Member__r.Last_Name__c + '-' + asset.Housing_Application_Member__r.Date_of_Birth__c).Id;
                        tAsset.Amount_of_Gift_Deposited_into_Rec_Acct__c = 0;
                        tAsset.Cash_or_Market_Value__c = 0;
                        tAsset.Current_Cash_Value_of_Gift__c = 0;
                        tAsset.Escrow_Amount_Deposited__c = 0;
                        tAsset.GR_Acct_Most_Recent_Balance__c = 0;
                        tAsset.Most_Recent_Balance__c = 0;
                        tAsset.Total_Cash_Not_Deposited_in_Any_Account__c = 0;                        
                        lAssets.add(tAsset);
                    }
                    insert lAssets;
                    System.debug(LoggingLevel.INFO, '==lAssets=='+lAssets);    
                }                
                fetchHousingApplication();
            }        
        }
        catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }
    
    //Selected Option List for Income Record Types
    public List<SelectOption> getMembersList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--Select--'));        
        if(haInstance != null && haInstance.Id != null) {
            for(Housing_Application_Member__c mem : [SELECT Id, First_Name__c, Last_Name__c FROM Housing_Application_Member__c WHERE Housing_Application__c =: haInstance.Id ORDER BY First_Name__c LIMIT 999]) {
                options.add(new SelectOption(mem.Id, mem.First_Name__c + ' ' + mem.Last_Name__c));
            }
        }    
        return options;
    }
    
    public Boolean getErrorsPresent(){
        return ApexPages.hasMessages(ApexPages.Severity.ERROR);
    }
    
    public Boolean getSuccessPresent(){
        return ApexPages.hasMessages(ApexPages.Severity.CONFIRM);
    }
    
    public Housing_Application__c checkIfOldAppExist() {
    
        List<Housing_Application__c> lHousingApps = [Select Id, Name, Application_Status__c, Property_of_Interest__c,
        Property_of_Interest__r.Name, CreatedById, OwnerId, Lottery_Number__c, Lottery_Rank__c, 
        Household_Account__c, 
        
        Housing_Application_E_Signed__c,
        Name_of_Agency_Helping_Applicant_If_Any__c,
        How_Applicant_Learned_About_This_Listing__c,
        If_Flyer_Where_Was_the_Flyer_Posted__c, If_Newspaper_Which_Newspaper__c,
        If_Social_Media_Which_Social_Media__c, If_Other_Please_Describe__c,
        Live_Or_Work_in_San_Francisco__c, Certificate_of_Preference_Holder__c,
        Certificate_of_Preference_Number__c, EAHP_Certificate_Expiration_Date__c,
        EAHP_Certificate_Holder__c, Does_any_member_appear_on_unit_s_title__c,
        Does_any_household_member_own_land__c, Does_any_member_own_a_business__c,
        
        (Select Id, Name, Zip_Code__c, Work_Phone__c, Suffix__c, Street_Type__c, 
        Street_Number__c, Street_Name__c, State__c, Salutation__c, Applicant_Role__c,
        Relationship_to_Head_of_Household__c, Relationship_to_Head_of_HH_if_Other__c, 
        Race_Ethnicity_optional__c, Race_Ethnicity_Other_details__c, Occupation__c, 
        Middle_Name__c, Member_Full_Name__c, Member_Age__c, Married_or_Domestic_Partnered__c, 
        Mailing_Address__c, Live_Or_Work_in_San_Francisco__c, Last_Name__c, In_School__c, 
        Home_Phone__c, Head_of_Household__c, Gender__c, Full_Time_Student__c, Full_Address__c, 
        First_Name__c, Email_Address__c, Date_of_Birth__c, City__c, Cell_Phone__c, Apt_Unit__c, 
        Address_Line_2__c, EAHP_Cert_Exp_Date_New_Dev__c, EAHP_Certificate_Holder__c, Certificate_of_Preference__c,
        Certificate_of_Preference_Holder__c
        From Housing_Application_Members1__r),
         
        (Select Id, Name, Annualized_Income__c, Employer_Name__c, Housing_Application_Member_Name__c,
        Housing_Application_Member__r.Member_Age__c, Housing_Application_Member__r.Date_of_Birth__c,
        Housing_Application_Member__r.Last_Name__c, Housing_Application_Member__r.First_Name__c,
        RecordTypeId, RecordType.Name,  Pay_Period_Frequency__c, Employer_Address__c, 
        Total_Number_of_Pay_Periods_Annually__c, Employment_Status__c, Annual_Overtime__c,
        Base_Annual_Employment_Income__c, First_Date_of_Employment__c, Paycheck_1_Pay_Date__c, 
        Annual_Commissions_Bonuses_Tips__c, Paycheck_1_Year_To_Date_Gross_Amount__c,
        Paycheck_1_Period__c, Paycheck_2_Pay_Date__c, Paycheck_2_Year_To_Date_Gross_Amount__c,
        Paycheck_2_Period__c, Paycheck_3_Pay_Date__c, Paycheck_3_Year_To_Date_Gross_Amount__c,
        Paycheck_3_Period__c, Interest_Dividends_Received_Annually__c,
        Public_Assistance_Received_Annually__c, Child_Support_Alimony_Received_Annually__c,
        Income_from_Land_or_Business_Annually__c, Social_Security_Pensions_Rec_d_Annually__c,
        Other_Incomes_Received_Annually__c, Applicant_Self_employed__c, 
        Date_of_Most_Recent_P_L_Stmt__c, Self_Employment_Starting_Year__c, 
        Self_Employment_Starting_Month__c, Most_Recent_Profit_or_Loss_Status__c,
        Most_Recent_Profit_or_Loss_Amount__c, Applicant_Unemployed__c, 
        Annual_Unemployment_Benefits_Amount__c, Year_Unemployed__c, Month_Unemployed__c,
        Tax_Year_2_Taxable_Annual_Income__c, Tax_Year_1_Taxable_Annual_Income__c,
        Self_Employment_Income_Declaration_Type__c, Paycheck_3_Total_Gross_Amount__c,
        Paycheck_2_Total_Gross_Amount__c, Paycheck_1_Total_Gross_Amount__c, Pay_Date__c,
        Pay_Amount__c, Most_Recent_Tax_Year_2__c, Most_Recent_Tax_Year_1__c,
        How_many_times_year_get_P_L_Statement__c, Annual_Income_Amount__c
        From Housing_Application_Incomes__r), 
        
        (Select Id, Name, Current_Cash_Value_of_Gift__c, Name_of_Institution__c, RecordType.Name, 
        GR_Acct_Most_Recent_Balance__c, Amount_of_Gift_Deposited_into_Rec_Acct__c,
        Housing_Application_Member__r.Member_Age__c, Housing_Application_Member__r.Date_of_Birth__c,
        GR_Acct_Inst_Date_of_Last_Statement__c, GR_Acct_Inst_Phone__c, Settlement_or_Other_Description__c, 
        Gift_Recipient_s_Account_Number__c, Gift_Recipient_Account_Address__c, Stock_Bond_Description__c,
        Gift_Recipient_Account_Institution_Name__c, Gift_Funds_Bank_Depository_Account__c,
        Gift_Funds_Type_Other_description__c, Gift_Funds_Type_of_Account__c, Asset_Value__c,            
        Gift_Funds_Location_Address__c, Gift_Funds_Location_Phone__c, Is_this_a_joint_account__c, 
        Gift_Funds_Location_Bank_Depository_Name__c, Gifter_Donor_Phone_Number__c,
        Relationship_if_Other__c, Gifter_Donor_Address__c, Gifter_Donor_Name__c,
        Gifter_Donor_Relationship_to_Recipient__c, Date_of_Gift_Letter__c, Date_of_Most_Recent_Statement__c,
        Total_Cash_Not_Deposited_in_Any_Account__c, Name_of_joint_account_holders__c,
        Housing_Application_Member__r.Last_Name__c, Housing_Application_Member__r.First_Name__c, 
        Account_Number__c, Asset_Type__c, Most_Recent_Balance__c, Housing_Application_Member__c, Cash_or_Market_Value__c, 
        Housing_Application_Member_Name__c, Retirement_Asset_Type__c, Escrow_Account_Number__c,
        Escrow_Acct_Institution_Address__c, Escrow_Acct_Institution_Name__c, Escrow_Acct_Institution_Phone_Number__c,
        Escrow_Amount_Deposited__c, Escrow_Date_of_Deposit__c, Escrow_Type_of_Account__c, 
        Withdrawn_From_Acct_Inst_Account_Number__c, Withdrawn_From_Acct_Inst_Address__c, 
        Withdrawn_From_Acct_Inst_Name__c, Withdrawn_From_Acct_Inst_Phone__c, RecordTypeId, Name_of_Business__c, Address_of_Business__c,
        Amount_Earned_Per_Year_from_Business__c, Land_Address_or_Parcel_Desc__c, Current_Value_of_Land__c, Landowner_Earns_Income_from_Land__c,
        Land_Earned_Income_Per_Year__c
        From Housing_Application_Assets__r),
        
        (Select Id, ParentId, Name, BodyLength, ContentType, Description From Attachments)
        
        FROM Housing_Application__c 
        WHERE OwnerId =: Userinfo.getUserId()
        ORDER BY CreatedDate DESC
        LIMIT 1];
        
        if(!lHousingApps.isEmpty()) {
            return lHousingApps[0];
        }
        return null;
    }
    
    public void createNote() {
        if(haInstance != null && haInstance.Id != null) {
            Note nt = new Note(ParentId = haInstance.Id, 
                Body = 'I will deliver some or all of my documents instead of uploading',
                Title = 'MOHCD Document Submission');
            insert nt;
            
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'The user selection has been confirmed. All documents will be delivered.');
            ApexPages.addMessage(message);
        }
        
    }
    
    private void assignInstructionText() {
        strInstructionText = '';
        if(intSelectedTabNumber == 1 && propInstance.Property_Program__c != 'City 2nd') {
            strInstructionText = 'Before you begin, make sure your Household Contact Information is up to date buy clicking the "Update My Household Contact Information" link on the left side of this screen.';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'Navigate through each tab by clicking the "Next" and "Previous" buttons below. Each tab contains a topic of required information you must complete for each application:';
            strInstructionText += '<br/>';
            strInstructionText += '<b>Household Composition</b> (information about each member of your household who will live in the property for which you are applying)';
            strInstructionText += '<br/>';
            strInstructionText += '<b>Incomes</b> (income information for each member of your household)';
            strInstructionText += '<br/>';
            strInstructionText += '<b>Assets</b> (asset information for each member of your household)';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'Tab-specific instructions will appear when you navigate to that tab.';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'When you are finished entering all information, click the "Submit" button on the Print & Sign tab. Afterwards, click the "Print & Sign" button. Once printed, review all pages for accuracy read further detailed instructions, including required supporting documents.';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'After signing your application and collecting all supporting documents, you may scan and upload your packet by using the "Add Attachments" button on the Attachments tab. If you cannot scan and upload your entire packet, and will, therefore, be delivering some or all of your documents, click the checkbox that says " I will deliver some or all of my documents instead of uploading" and then click the "Confirm" button.';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'YOUR APPLICATION PACKET IS NOT COMPLETE UNTIL THE COMPLETE SIGNED APPLICATION AND SUPPORTING DOCUMENTS ARE DELIVERED PER THE APPLICATION INSTRUCTIONS FOR THE PROPERTY.';
            
        } else if(intSelectedTabNumber == 1 && propInstance.Property_Program__c == 'City 2nd') {
            strInstructionText = 'Instrux for City 2nd properties.';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'Line 2 of City 2nd instrux.';
        
        } else if(intSelectedTabNumber == 2){
            strInstructionText = 'Enter information for each and every member of the household who will live in the property for which you are applying.';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'To add a new member, click the "Add Member" button.';
            strInstructionText += '<br/>';
            strInstructionText += 'To edit a member\'s information, click the Edit link next to that member\'s name.';
            strInstructionText += '<br/>';
            strInstructionText += 'To delete a member, click the Delete link next to that member\'s name.';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'When adding or editing a member, complete the fields in the window that appears, then click the "Save Member Info" button at the bottom (click the "Cancel" button to ignore your changes).';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'When done adding members, click the "Next" button.';
            
        } else if(intSelectedTabNumber == 3){
            strInstructionText = 'Enter income information for each and every member of the household who will live in the property for which you are applying.';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'To add a new income, click the "Add Income" button.';            
            strInstructionText += '<br/>';
            strInstructionText += 'To edit a member\'s income information, click the Edit link next to that member\'s name.';
            strInstructionText += '<br/>';
            strInstructionText += 'To delete a member\'s income information, click the Delete link next to that member\'s name.';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'When adding or editing a member\'s income information, complete the fields in the window that appears, then click the "Save Income Details" button at the bottom (click the "Cancel" button to ignore your changes).';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'When done adding member income information, click the "Next" button.';
        } else if(intSelectedTabNumber == 4){
            strInstructionText = 'Enter asset information for each and every member of the household who will live in the property for which you are applying.';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'To add a new asset, click the "Add Asset" button.';            
            strInstructionText += '<br/>';
            strInstructionText += 'To edit a member\'s asset information, click the Edit link next to that member\'s name.';
            strInstructionText += '<br/>';
            strInstructionText += 'To delete a member\'s asset information, click the Delete link next to that member\'s name.';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'When adding or editing a member\'s asset information, complete the fields in the window that appears, then click the "Save Asset Details" button at the bottom (click the "Cancel" button to ignore your changes).';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'When done adding member asset information, click the "Next" button.';
            
        } else if(intSelectedTabNumber == 5){
            strInstructionText = 'Now that you have entered your household information, there are 3 steps to completing the application process:';
            strInstructionText += '<br/><br/>';
            strInstructionText += '1. Review your application (click the "Review" button below)';
            strInstructionText += '<br/>';
            strInstructionText += '2. E-sign and submit your application (check the agreement box and then click the "Submit" button below)';
            strInstructionText += '<br/>';
            strInstructionText += '3. Upload your supporting documents (click the "Next" button below)';
        
        } else if(intSelectedTabNumber == 6){        
            strInstructionText = 'Your printed document includes a list of required supporting documents you must submit with your signed application.';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'You may scan and upload your entire packet (including your signed application and all supporting documents) by clicking the "Add Attachments" button below. In the window that appears, you will select the file you want to attach, then choose the document type from the drop down (the drop down includes a list of all possible required document types - use only the ones you need).';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'Once you select your file and document type, click the "Attach File" button.';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'If you have more files to upload, repeat the process. Once you are done uploading all files, click the "Done" button.';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'You may delete a file by clicking the Delete link next to any file name.';
            strInstructionText += '<br/><br/>';
            strInstructionText += 'If you cannot scan and upload some or all of your files, then click the checkbox that says " I will deliver some or all of my documents instead of uploading" and then click the "Confirm" button.';
        } 
    }
    
    /*
    * @author : Cloud Sherpas Inc.
    * @date : 09/18/2014
    * @description : Apex method that validates Member Income Fields
    * @parameters : Housing_Application_Income__c 
    * @returns : CS_MOHCDHousingAppCCContainer 
    */
    public static CS_MOHCDHousingAppCCContainer validateMemberIncomeFields(Housing_Application_Income__c memberIncomeInstance, String recordType) {
        
        CS_MOHCDHousingAppCCContainer container = new CS_MOHCDHousingAppCCContainer();
                
        container.errorMessage = '';
        container.error = FALSE;
        
        if (memberIncomeInstance.Housing_Application_Member__c == null) {
            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Household Member is a required field.<br/>';
            container.error = TRUE;
        }                
                                             
            System.debug('Income Record Type : ' + recordType);
                
            if (recordType == 'Employment Income') {
                if (memberIncomeInstance.Pay_Period_Frequency__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Pay Period Frequency is a required field.<br/>';
                    container.error = TRUE;
                }
                    
                if (memberIncomeInstance.Employer_Address__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Employer Address is a required field.<br/>';
                    container.error = TRUE;
                }
                    
                if (memberIncomeInstance.Total_Number_of_Pay_Periods_Annually__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Total Number of Pay Periods Annually is a required field.<br/>';
                    container.error = TRUE;
                }
                    
                if (memberIncomeInstance.Employment_Status__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Employment Status is a required field.<br/>';
                    container.error = TRUE;
                }
                    
                if (memberIncomeInstance.Base_Annual_Employment_Income__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Base Annual Employment Income is a required field.<br/>';
                    container.error = TRUE;
                }
                    
                if (memberIncomeInstance.First_Date_of_Employment__c == null) {
                   container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> First Date of Employment is a required field.<br/>';
                   container.error = TRUE;
                }
                    
                if (memberIncomeInstance.Annual_Commissions_Bonuses_Tips__c == null) {
                   container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Annual Commissions/Bonuses/Tips is a required field.<br/>';
                   container.error = TRUE;
                }
                    
                if (memberIncomeInstance.Annual_Overtime__c == null) {
                   container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Annual Overtime is a required field.<br/>';
                   container.error = TRUE;
                }
                    
                if (memberIncomeInstance.Paycheck_1_Pay_Date__c == null) {
                   container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Paycheck 1 Pay Date is a required field.<br/>';
                   container.error = TRUE;
                }
                    
                if (memberIncomeInstance.Paycheck_1_Year_To_Date_Gross_Amount__c == null) {
                   container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Paycheck 1 Year-To-Date Gross Amount is a required field.<br/>';
                   container.error = TRUE;
                }
                    
                if (memberIncomeInstance.Paycheck_1_Period__c == null) {
                   container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Paycheck 1 Period # is a required field.<br/>';
                   container.error = TRUE;
                }
            } else if (recordType == 'Other Income') {
                if (memberIncomeInstance.Interest_Dividends_Received_Annually__c == null) {
                   container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Interest/Dividends Received Annually is a required field.<br/>';
                   container.error = TRUE;
                 }
                    
                 if (memberIncomeInstance.Public_Assistance_Received_Annually__c == null) {
                     container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Public Assistance Received Annually is a required field.<br/>';
                     container.error = TRUE;
                 }
                    
                 if (memberIncomeInstance.Child_Support_Alimony_Received_Annually__c == null) {
                     container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Child Support/Alimony Received Annually is a required field.<br/>';
                     container.error = TRUE;
                 }
                    
                 if (memberIncomeInstance.Income_from_Land_or_Business_Annually__c == null) {
                     container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Income from Land or Business Annually is a required field.<br/>';
                     container.error = TRUE;
                 }
                    
                 if (memberIncomeInstance.Social_Security_Pensions_Rec_d_Annually__c == null) {
                     container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Social Security/Pensions Rec\'d Annually is a required field.<br/>';
                     container.error = TRUE;
                 }                                        
                    
                 if (memberIncomeInstance.Other_Incomes_Received_Annually__c == null) {
                     container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Other Incomes Received Annually is a required field.<br/>';
                     container.error = TRUE;
                 }
            } else if (recordType == 'Self-Employment Income') {
                container.memberIncomeInstance.Applicant_Self_employed__c = 'Yes';
                                        
                if (memberIncomeInstance.Self_Employment_Income_Declaration_Type__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Self-Employment Income Declaration Type is a required field.<br/>';
                    container.error = TRUE;
                }
                    
                if (memberIncomeInstance.How_many_times_year_get_P_L_Statement__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> How many times/year get P/L Statement is a required field.<br/>';
                    container.error = TRUE;
                }
                    
                if (memberIncomeInstance.Date_of_Most_Recent_P_L_Stmt__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Date of Most Recent P & L Stmt is a required field.<br/>';
                    container.error = TRUE;
                }
                   
                if (memberIncomeInstance.Self_Employment_Starting_Year__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Self Employment Starting Year is a required field.<br/>';
                    container.error = TRUE;
                }                                        
                    
                if (memberIncomeInstance.Self_Employment_Starting_Month__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Self Employment Starting Month is a required field.<br/>';
                    container.error = TRUE;
                }
                    
                if (memberIncomeInstance.Most_Recent_Profit_or_Loss_Status__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Most Recent Profit or Loss Status is a required field.<br/>';
                    container.error = TRUE;
                }
                    
                if (memberIncomeInstance.Most_Recent_Profit_or_Loss_Amount__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Most Recent Profit or Loss Amount is a required field.<br/>';
                    container.error = TRUE;
                }
                    
                if (memberIncomeInstance.Most_Recent_Tax_Year_1__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Most Recent Tax Year 1 is a required field.<br/>';
                    container.error = TRUE;
                }
                    
                if (memberIncomeInstance.Tax_Year_1_Taxable_Annual_Income__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Tax Year 1 Taxable Annual Income is a required field.<br/>';
                    container.error = TRUE;
                }
                                        
            } else if (recordType == 'Unemployed') {
                container.memberIncomeInstance.Applicant_Unemployed__c = 'Yes';
                                        
                if (memberIncomeInstance.Annual_Unemployment_Benefits_Amount__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Annual Unemployment Benefits Amount is a required field.<br/>';
                    container.error = TRUE;
                }
                    
                if (memberIncomeInstance.Year_Unemployed__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Year Unamployed is a required field.<br/>';
                    container.error = TRUE;
                }
                    
                if (memberIncomeInstance.Month_Unemployed__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Month Unemployed is a required field.<br/>';
                    container.error = TRUE;
                }                                        
        }
        return container;
    }
    
    /*
    * @author : Cloud Sherpas Inc.
    * @date : 09/18/2014
    * @description : Apex method that validates Member Assets Fields
    * @parameters : Housing_Application_Asset__c 
    * @returns : CS_MOHCDHousingAppCCContainer 
    */
    public static CS_MOHCDHousingAppCCContainer validateMemberAssetFields(Housing_Application_Asset__c memberAssetInstance, String recordType) {
        
        CS_MOHCDHousingAppCCContainer container = new CS_MOHCDHousingAppCCContainer();
        container.errorMessage = '';
        container.error = FALSE;
        
        if (memberAssetInstance.Housing_Application_Member__c == null) {
            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Household Member is a required field.<br/>';
            container.error = TRUE;
        }
     
            if (recordType == 'Assets with an Account') {
            
                if (memberAssetInstance.Cash_or_Market_Value__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Cash or Market Value is a required field.<br/>';
                    container.error = TRUE;
                }
                
                if (memberAssetInstance.Name_of_Institution__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Name of Institution is a required field.<br/>';
                    container.error = TRUE;
                }
                
                if (memberAssetInstance.Account_Number__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Account Number is a required field.<br/>';
                    container.error = TRUE;
                }
                
                if (memberAssetInstance.Date_of_Most_Recent_Statement__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Date of Most Recent Statement is a required field.<br/>';
                    container.error = TRUE;
                }
                
                if (memberAssetInstance.Asset_Type__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Asset Type is a required field.<br/>';
                    container.error = TRUE;
                } else {
                    if (memberAssetInstance.Asset_Type__c == 'Settlement' || memberAssetInstance.Asset_Type__c == 'Other') {
                        if (memberAssetInstance.Settlement_or_Other_Description__c == null) {
                            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Settlement or Other Description is a required field.<br/>';
                            container.error = TRUE;
                        }
                    } else if (memberAssetInstance.Asset_Type__c == 'Stocks' || memberAssetInstance.Asset_Type__c == 'Bonds') {
                        if (memberAssetInstance.Stock_Bond_Description__c == null) {
                            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Stock/Bond Description is a required field.<br/>';
                            container.error = TRUE;
                        }
                    }
                }
                
                if (memberAssetInstance.Is_this_a_joint_account__c == true) {
                    if (memberAssetInstance.Name_of_joint_account_holders__c == null) {
                        container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Name of joint account holders is a required field.<br/>';
                        container.error = TRUE;
                    }                    
                }                 
            } else if (recordType == 'Business Ownership') {
                if (memberAssetInstance.Asset_Type__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Asset Type is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Name_of_Business__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Name of Business is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Address_of_Business__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Address of Business is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Amount_Earned_Per_Year_from_Business__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Amount Earned Per Year is a required field.<br/>';
                    container.error = TRUE;
                }               
            } else if (recordType == 'Cash without an Account') {
                if (memberAssetInstance.Asset_Type__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Asset Type is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Total_Cash_Not_Deposited_in_Any_Account__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Total Cash Not Deposited in Any Account is a required field.<br/>';
                    container.error = TRUE;
                }
            } else if (recordType == 'Gifts') {
                if (memberAssetInstance.Asset_Type__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Asset Type is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Date_of_Gift_Letter__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Date of Gift Letter is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Gifter_Donor_Relationship_to_Recipient__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gifter/Donor Relationship to Recipient is a required field.<br/>';
                    container.error = TRUE;
                } else {
                    if (memberAssetInstance.Gifter_Donor_Relationship_to_Recipient__c == 'Other') {
                        if (memberAssetInstance.Relationship_if_Other__c == null) {
                            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Relationship, if Other is a required field.<br/>';
                            container.error = TRUE;
                        }                        
                    }
                }
                if (memberAssetInstance.Gifter_Donor_Name__c== null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gifter/Donor Name is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Gifter_Donor_Address__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gifter/Donor Address is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Gifter_Donor_Phone_Number__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gifter/Donor Phone Number is a required field.<br/>';
                    container.error = TRUE;
                }
                if(memberAssetInstance.Gifter_Donor_Phone_Number__c !=null && !Pattern.matches('\\(?\\b[0-9]{3}\\)?[-/\\s]?[0-9]{3}[-. ]?[0-9]{4}\\b',memberAssetInstance.Gifter_Donor_Phone_Number__c )){
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Invalid Format for Gifter/Donor Phone Number.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Gift_Funds_Location_Bank_Depository_Name__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gift Funds Location-Bank/Depository Name is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Gift_Funds_Location_Phone__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gift Funds Location: Phone# is a required field.<br/>';
                    container.error = TRUE;
                }
                if(memberAssetInstance.Gift_Funds_Location_Phone__c !=null && !Pattern.matches('\\(?\\b[0-9]{3}\\)?[-/\\s]?[0-9]{3}[-. ]?[0-9]{4}\\b',memberAssetInstance.Gift_Funds_Location_Phone__c )){
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gift Funds Location: Phone# is invalid.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Gift_Funds_Location_Address__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gift Funds Location: Address is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Gift_Funds_Type_of_Account__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gift Funds Type of Account is a required field.<br/>';
                    container.error = TRUE;
                } else {
                    if (memberAssetInstance.Gift_Funds_Type_of_Account__c == 'Other') {
                        if (memberAssetInstance.Gift_Funds_Type_Other_description__c == null) {
                            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gift Funds Type - Other description is a required field.<br/>';
                            container.error = TRUE;
                        }
                    }
                }                
                if (memberAssetInstance.Current_Cash_Value_of_Gift__c== null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Current Cash or Market Value of Gift is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Gift_Funds_Bank_Depository_Account__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gift Funds Bank/Depository Account# is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Gift_Recipient_Account_Institution_Name__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gift Recipient Account Institution Name is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Gift_Recipient_Account_Address__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gift Recipient Account Address is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Gift_Recipient_s_Account_Number__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gift Recipient\'s Account Number is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.GR_Acct_Inst_Phone__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gift Recipient Acct. Inst. Phone # is a required field.<br/>';
                    container.error = TRUE;
                }
                if(memberAssetInstance.GR_Acct_Inst_Phone__c !=null && !Pattern.matches('\\(?\\b[0-9]{3}\\)?[-/\\s]?[0-9]{3}[-. ]?[0-9]{4}\\b',memberAssetInstance.GR_Acct_Inst_Phone__c )){
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gift Recipient Acct. Inst. Phone# is invalid.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.GR_Acct_Inst_Date_of_Last_Statement__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gift Recipient Acct. Inst. - Date of Last Statement is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Amount_of_Gift_Deposited_into_Rec_Acct__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Amount of Gift Deposited into Rec. Acct is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.GR_Acct_Most_Recent_Balance__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gift Recipient Acct. - Most Recent Balance is a required field.<br/>';
                    container.error = TRUE;
                }
                
            } else if (recordType == 'Land Ownership') {
                if (memberAssetInstance.Asset_Type__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Asset Type is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Land_Address_or_Parcel_Desc__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Land Address or Parcel Desc. is a required field.<br/>';
                    container.error = TRUE;
                }
                if (memberAssetInstance.Current_Value_of_Land__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Current Value of Land is a required field.<br/>';
                    container.error = TRUE;
                } 
                if (memberAssetInstance.Landowner_Earns_Income_from_Land__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Landowner Earns Income from Land is a required field.<br/>';
                    container.error = TRUE;
                } else {
                    if (memberAssetInstance.Landowner_Earns_Income_from_Land__c == 'Yes') {
                        if (memberAssetInstance.Land_Earned_Income_Per_Year__c == null) {
                            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Income per year is a required field.<br/>';
                            container.error = TRUE;
                        }                        
                    }
                }
            }else if (recordType == 'No Assets') {
                if (memberAssetInstance.Asset_Type__c == null) {
                    container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Asset Type is a required field.<br/>';
                    container.error = TRUE;
                }
            }
        return container;
    }

    public static CS_MOHCDHousingAppCCContainer validateMemberFields(Housing_Application_Member__c memberInstance) {
        CS_MOHCDHousingAppCCContainer container = new CS_MOHCDHousingAppCCContainer();                   
        container.errorMessage = '';
        container.error = FALSE;

        if(memberInstance.First_Name__c == null){
            container.error = TRUE;
            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> First Name is a required field.<br/>';
        }
                         
        if(memberInstance.Last_Name__c == null){
            container.error = TRUE;
            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Last Name is a required field.<br/>';
        }
                 
        if(memberInstance.Gender__c == null){
            container.error = TRUE;
            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Gender is a required field.<br/>';
        }
                         
        if(memberInstance.Occupation__c == null){
            container.error = TRUE;
            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Occupation is a required field.<br/>';
        }
                 
        if(memberInstance.Date_of_Birth__c== null){
            container.error = TRUE;
            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Date of Birth is a required field.<br/>';
        }  
        
        if(memberInstance.Applicant_Role__c == null){
            container.error = TRUE;
            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Applicant Role is a required field.<br/>';
        }      
                 
        if(memberInstance.Relationship_to_Head_of_Household__c == null){
            container.error = TRUE;
            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Relationship to Head of Household is a required field.<br/>';
        }  
                         
        if(memberInstance.In_School__c == null){
            container.error = TRUE;
            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Student? is a required field.<br/>';
        }  
                 
        if( (memberInstance.Full_Time_Student__c== null) && (memberInstance.In_School__c == 'Yes') ) {
            container.error = TRUE;
            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> If Student, Full-Time? is a required field.<br/>';
        } 
                 
        if(memberInstance.Married_or_Domestic_Partnered__c == null){
            container.error = TRUE;
            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Married or Domestic Partnered? is a required field.<br/>';
        }  
                         
        if(memberInstance.Live_Or_Work_in_San_Francisco__c == null){
            container.error = TRUE;
            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Do you live or work in San Francisco? is a required field.<br/>';
        } 
 
        if(memberInstance.Does_this_appear_on_another_title__c == null){
            container.error = TRUE;
            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Has this member owned a housing unit in the past 3 years? is a required field.<br/>';
        } 
   
        if(memberInstance.Has_owned_a_unit_last_3_yrs__c == null){
           container.error = TRUE;
           container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> Does this member appear on title for a housing unit (whether living in it or renting it out)? is a required field.<br/>';
        } 
 
        if(memberInstance.Has_owned_a_unit_last_3_yrs__c == 'Yes'){
            container.error = TRUE;
            container.errorMessage += '<b style=\"color:#cc0000\"> Error : </b> The household is not eligible to apply for the property.<br/>';
        }

        return container;
    }
    
    public void clearIncomeErrorsCtrl() {
        clearErrors();
        this.memberIncomeInstance = new Housing_Application_Income__c();
    }
    
    public void clearMemberErrorsCtrl() {
        clearErrors();
        this.memberInstance = new Housing_Application_Member__c();
    }
    
    public void clearAssetErrorsCtrl() {
        clearErrors();
        this.memberAssetInstance = new Housing_Application_Asset__c();
    }
   
    public void clearIncomeErrorsCtrl2() {
        clearErrors();
    }
    
    public void clearAssetErrorsCtrl2() {
        clearErrors();
    }

    public void editMemberCtrl() {
        clearErrors();
        List<Housing_Application_Member__c> members = new List<Housing_Application_Member__c>([Select Id, Name, Zip_Code__c, Work_Phone__c, Suffix__c, Street_Type__c, 
                Street_Number__c, Street_Name__c, State__c, Salutation__c, Applicant_Role__c,
                Relationship_to_Head_of_Household__c, Relationship_to_Head_of_HH_if_Other__c, 
                Race_Ethnicity_optional__c, Race_Ethnicity_Other_details__c, Occupation__c, 
                Middle_Name__c, Member_Full_Name__c, Member_Age__c, Married_or_Domestic_Partnered__c, 
                Mailing_Address__c, Live_Or_Work_in_San_Francisco__c, Last_Name__c, In_School__c, 
                Home_Phone__c, Head_of_Household__c, Gender__c, Full_Time_Student__c, Full_Address__c, 
                First_Name__c, Email_Address__c, Date_of_Birth__c, City__c, Cell_Phone__c, Apt_Unit__c, 
                Address_Line_2__c, EAHP_Cert_Exp_Date_New_Dev__c, EAHP_Certificate_Holder__c, Certificate_of_Preference__c,
                Certificate_of_Preference_Holder__c, Does_this_appear_on_another_title__c, Has_owned_a_unit_last_3_yrs__c, 
                Does_this_member_own_land__c                
                From Housing_Application_Member__c WHERE Id = :strEditMemberId]);
          
          if(members.size()>0){
              this.editMemberInstance = members[0];
          }
          isOpenMember = true;
    }
    
    public void editIncomeCtrl() {
        clearErrors();
        List<Housing_Application_Income__c> incomes = new List<Housing_Application_Income__c>([Select Id, Name, Annualized_Income__c, Employer_Name__c, Housing_Application_Member_Name__c,
                Housing_Application_Member__r.Member_Age__c, Housing_Application_Member__r.Date_of_Birth__c,
                Housing_Application_Member__r.Last_Name__c, Housing_Application_Member__r.First_Name__c,
                RecordTypeId, RecordType.Name,  Pay_Period_Frequency__c, Employer_Address__c, 
                Total_Number_of_Pay_Periods_Annually__c, Employment_Status__c, Annual_Overtime__c,
                Base_Annual_Employment_Income__c, First_Date_of_Employment__c, Paycheck_1_Pay_Date__c, 
                Annual_Commissions_Bonuses_Tips__c, Paycheck_1_Year_To_Date_Gross_Amount__c,
                Paycheck_1_Period__c, Paycheck_2_Pay_Date__c, Paycheck_2_Year_To_Date_Gross_Amount__c,
                Paycheck_2_Period__c, Paycheck_3_Pay_Date__c, Paycheck_3_Year_To_Date_Gross_Amount__c,
                Paycheck_3_Period__c, Interest_Dividends_Received_Annually__c,
                Public_Assistance_Received_Annually__c, Child_Support_Alimony_Received_Annually__c,
                Income_from_Land_or_Business_Annually__c, Social_Security_Pensions_Rec_d_Annually__c,
                Other_Incomes_Received_Annually__c, Applicant_Self_employed__c, 
                Date_of_Most_Recent_P_L_Stmt__c, Self_Employment_Starting_Year__c, 
                Self_Employment_Starting_Month__c, Most_Recent_Profit_or_Loss_Status__c,
                Most_Recent_Profit_or_Loss_Amount__c, Applicant_Unemployed__c, 
                Annual_Unemployment_Benefits_Amount__c, Year_Unemployed__c, Month_Unemployed__c,
                Tax_Year_2_Taxable_Annual_Income__c, Tax_Year_1_Taxable_Annual_Income__c,
                Self_Employment_Income_Declaration_Type__c, Paycheck_3_Total_Gross_Amount__c,
                Paycheck_2_Total_Gross_Amount__c, Paycheck_1_Total_Gross_Amount__c, 
                Pay_Date__c, Pay_Amount__c, Most_Recent_Tax_Year_2__c, Most_Recent_Tax_Year_1__c,
                How_many_times_year_get_P_L_Statement__c, Annual_Income_Amount__c
                From Housing_Application_Income__c WHERE Id = :strEditIncomeId]);
                
         if(incomes.size()>0){
              this.editMemberIncomeInstance = incomes[0];
          }
    }
    
    public void editAssetCtrl() {
        clearErrors();
        List<Housing_Application_Asset__c> assets = new List<Housing_Application_Asset__c>([Select Id, Name, Current_Cash_Value_of_Gift__c, Name_of_Institution__c, RecordType.Name, 
                GR_Acct_Most_Recent_Balance__c, Amount_of_Gift_Deposited_into_Rec_Acct__c,
                Housing_Application_Member__r.Member_Age__c, Housing_Application_Member__r.Date_of_Birth__c,
                GR_Acct_Inst_Date_of_Last_Statement__c, GR_Acct_Inst_Phone__c, Settlement_or_Other_Description__c, 
                Gift_Recipient_s_Account_Number__c, Gift_Recipient_Account_Address__c, Stock_Bond_Description__c,
                Gift_Recipient_Account_Institution_Name__c, Gift_Funds_Bank_Depository_Account__c,
                Gift_Funds_Type_Other_description__c, Gift_Funds_Type_of_Account__c, Asset_Value__c,               
                Gift_Funds_Location_Address__c, Gift_Funds_Location_Phone__c, Is_this_a_joint_account__c, 
                Gift_Funds_Location_Bank_Depository_Name__c, Gifter_Donor_Phone_Number__c,
                Relationship_if_Other__c, Gifter_Donor_Address__c, Gifter_Donor_Name__c,
                Gifter_Donor_Relationship_to_Recipient__c, Date_of_Gift_Letter__c, Date_of_Most_Recent_Statement__c,
                Total_Cash_Not_Deposited_in_Any_Account__c, Name_of_joint_account_holders__c,
                Housing_Application_Member__r.Last_Name__c, Housing_Application_Member__r.First_Name__c, 
                Account_Number__c, Asset_Type__c, Most_Recent_Balance__c, Housing_Application_Member__c, Cash_or_Market_Value__c, 
                Housing_Application_Member_Name__c, Retirement_Asset_Type__c, Escrow_Account_Number__c,
                Escrow_Acct_Institution_Address__c, Escrow_Acct_Institution_Name__c, Escrow_Acct_Institution_Phone_Number__c,
                Escrow_Amount_Deposited__c, Escrow_Date_of_Deposit__c, Escrow_Type_of_Account__c, 
                Withdrawn_From_Acct_Inst_Account_Number__c, Withdrawn_From_Acct_Inst_Address__c, 
                Withdrawn_From_Acct_Inst_Name__c, Withdrawn_From_Acct_Inst_Phone__c, RecordTypeId, Name_of_Business__c, Address_of_Business__c,
                Amount_Earned_Per_Year_from_Business__c, Land_Address_or_Parcel_Desc__c, Current_Value_of_Land__c, Landowner_Earns_Income_from_Land__c,
                Land_Earned_Income_Per_Year__c
                From Housing_Application_Asset__c WHERE Id = :strEditAssetId]);
        if(assets.size()>0){
              this.editMemberAssetInstance = assets[0];
          }
    }

    public void clearErrors(){
        errorMember = false;
        errorIncome = false;
        errorAssets = false;

        erroreditMember = false;
        errorEditIncome = false;
        errorEditAssets = false;

        ErrorMessagesMember='';
        ErrorMessagesIncome='';
        ErrorMessagesAssets='';
        
        ErrorMessagesEditMember ='';
        ErrorMessagesEditIncome ='';
        ErrorMessagesEditAssets ='';            
    }
    
    /*public void getReportId(){
        String rep;
        for(Report reportList : [SELECT Id, Name FROM Report WHERE Name =: 'MOHCD Conga Members List']){
            //if(reportList.Name == 'MOHCD Conga Members List'){
                rep = reportList.Id;
            //}
        }
        return rep;
    }*/
}