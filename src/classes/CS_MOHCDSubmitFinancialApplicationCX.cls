public class CS_MOHCDSubmitFinancialApplicationCX {
    
    public Financial_Application__c faInstance {get; set;}
     
    public CS_MOHCDSubmitFinancialApplicationCX(ApexPages.StandardController controller) {        
        faInstance = (Financial_Application__c) controller.getRecord();
        
        System.debug(LoggingLevel.INFO, '==faInstance=='+faInstance);
        
        if(faInstance == null || faInstance.Id == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Id in URL. Try Again.'));
            return;
        }
    }
    
    public PageReference init() {
    
        try {
            
            fetchFinancialApplication();
            System.debug(LoggingLevel.INFO, '==init faInstance.Id=='+faInstance.Id);
            
            if(faInstance.Application_Status__c == 'Submitted') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This DALP application is already Submitted.'));
                return null;
            }
            
            faInstance.Application_Status__c = 'Submitted';
            update faInstance;  
            System.debug(LoggingLevel.INFO, '==init updated faInstance=='+faInstance); 
             
            //Clean old Data i.e. Delete all old contacts which will delete associated Person Asset and Income records            
            List<Contact> lContacts = new List<Contact>([SELECT Id, Name, AccountId FROM Contact 
                WHERE AccountId =: faInstance.Household_Account__c]);

            if(lContacts.size()!=0){
                Database.delete(lContacts, false);
                //delete lContacts;
            }

            //if(!lContacts.isEmpty()) Database.delete(lContacts, false);
            //System.debug(LoggingLevel.INFO, '==init possible deleted lContacts=='+lContacts); 
            
            //Copy all Members
            Map<String, Contact> mNewContacts = prepareContactList(faInstance.Financial_Application_Members1__r);
            
            if(!mNewContacts.isEmpty()) {
                //Copy all Incomes
                prepareIncomeList(faInstance.Financial_Application_Incomes__r, mNewContacts);
                
                //Copy all Assets
                prepareAssetList(faInstance.Financial_Application_Assets__r, mNewContacts);
            }
            
            PageReference pref = new PageReference('/' + faInstance.Id);
            pref.setRedirect(true);
            return pref;
        }
        catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
    }
    
    private void fetchFinancialApplication() {       
        
        if(!String.isBlank(faInstance.Id)) {
            List<Financial_Application__c> lFinancialApps = [Select Id, Name, Application_Status__c, 
            CreatedById, OwnerId, Household_Account__c, 
            
            (Select Id, Name, Zip_Code__c, Work_Phone__c, Suffix__c, Street_Type__c, 
            Street_Number__c, Street_Name__c,  Salutation__c, State__c,
            Relationship_to_Head_of_Household__c, Relationship_to_Head_of_HH_if_Other__c, 
            Race_Ethnicity_optional__c, Race_Ethnicity_Other_details__c, Occupation__c, 
            Middle_Name__c, Member_Full_Name__c, Member_Age__c, Married_or_Domestic_Partnered__c, 
            Mailing_Address__c, Live_Or_Work_in_San_Francisco__c, Last_Name__c, In_School__c, 
            Home_Phone__c, Head_of_Household__c, Gender__c, Full_Time_Student__c, Full_Address__c, 
            First_Name__c, Email_Address__c, Date_of_Birth__c, City__c, Cell_Phone__c, Apt_Unit__c, 
            Address_Line_2__c 
            From Financial_Application_Members1__r),
             
            (Select Id, Name, Annualized_Income__c, Employer_Name__c, Financial_Application_Member_Name__c,
            Financial_Application_Member__r.Member_Age__c, Financial_Application_Member__r.Date_of_Birth__c,
            Financial_Application_Member__r.Last_Name__c, Financial_Application_Member__r.First_Name__c,
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
            How_many_times_year_get_P_L_Statement__c
            From Financial_Application_Incomes__r), 
            
            (Select Id, Name, Current_Cash_Value_of_Gift__c, Name_of_Institution__c, RecordType.Name, 
            GR_Acct_Most_Recent_Balance__c, Amount_of_Gift_Deposited_into_Rec_Acct__c,
            Financial_Application_Member__r.Member_Age__c, Financial_Application_Member__r.Date_of_Birth__c,
            GR_Acct_Inst_Date_of_Last_Statement__c, GR_Acct_Inst_Phone__c, Settlement_or_Other_Description__c, 
            Gift_Recipient_s_Account_Number__c, Gift_Recipient_Account_Address__c, Stock_Bond_Description__c,
            Gift_Recipient_Account_Institution_Name__c, Gift_Funds_Bank_Depository_Account__c,
            Gift_Funds_Type_Other_description__c, Gift_Funds_Type_of_Account__c,                
            Gift_Funds_Location_Address__c, Gift_Funds_Location_Phone__c, Is_this_a_joint_account__c, 
            Gift_Funds_Location_Bank_Depository_Name__c, Gifter_Donor_Phone_Number__c,
            Relationship_if_Other__c, Gifter_Donor_Address__c, Gifter_Donor_Name__c,
            Gifter_Donor_Relationship_to_Recipient__c, Date_of_Gift_Letter__c, Date_of_Most_Recent_Statement__c,
            Total_Cash_Not_Deposited_in_Any_Account__c, Name_of_joint_account_holders__c,
            Financial_Application_Member__r.Last_Name__c, Financial_Application_Member__r.First_Name__c, 
            Account_Number__c, Asset_Type__c, Most_Recent_Balance__c, Financial_Application_Member__c, Cash_or_Market_Value__c, 
            Financial_Application_Member_Name__c, Retirement_Asset_Type__c, Escrow_Account_Number__c,
            Escrow_Acct_Institution_Address__c, Escrow_Acct_Institution_Name__c, Escrow_Acct_Institution_Phone_Number__c,
            Escrow_Amount_Deposited__c, Escrow_Date_of_Deposit__c, Escrow_Type_of_Account__c, 
            Withdrawn_From_Acct_Inst_Account_Number__c, Withdrawn_From_Acct_Inst_Address__c, 
            Withdrawn_From_Acct_Inst_Name__c, Withdrawn_From_Acct_Inst_Phone__c, RecordTypeId
            From Financial_Application_Assets__r),
            
            (Select Id, ParentId, Name, BodyLength, ContentType, Description From Attachments),
            
            (Select Id, Title FROM Notes WHERE Title='MOHCD Document Submission')
            
            FROM Financial_Application__c 
            WHERE Id =: faInstance.Id
            ORDER BY CreatedDate DESC
            LIMIT 1];
            
            if(!lFinancialApps.isEmpty()) {
                faInstance = lFinancialApps[0];          
            }
        }
    }
    
    private void prepareAssetList(List<Financial_Application_Asset__c> lAssets, Map<String, Contact> mContacts) {
    
        List<Personal_Asset__c> lPersonalAssets = new List<Personal_Asset__c>();
        
        for(Financial_Application_Asset__c asset : lAssets) {
            
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
            
            if(mContacts.containsKey(asset.Financial_Application_Member__r.First_Name__c + '-' + asset.Financial_Application_Member__r.Last_Name__c + '-' + asset.Financial_Application_Member__r.Date_of_Birth__c)) {
                Contact con = mContacts.get(asset.Financial_Application_Member__r.First_Name__c + '-' + asset.Financial_Application_Member__r.Last_Name__c + '-' + asset.Financial_Application_Member__r.Date_of_Birth__c);
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
    
    private void prepareIncomeList(List<Financial_Application_Income__c> lIncomes, Map<String, Contact> mContacts) {
    
        List<Personal_Income__c> lPersonalIncomes = new List<Personal_Income__c>();
        
        for(Financial_Application_Income__c income : lIncomes) {
            
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
           if(mContacts.containsKey(income.Financial_Application_Member__r.First_Name__c + '-' + income.Financial_Application_Member__r.Last_Name__c + '-' + income.Financial_Application_Member__r.Date_of_Birth__c)) {
                Contact con = mContacts.get(income.Financial_Application_Member__r.First_Name__c + '-' + income.Financial_Application_Member__r.Last_Name__c + '-' + income.Financial_Application_Member__r.Date_of_Birth__c);
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
    
    public Map<String, Contact> prepareContactList(List<Financial_Application_Member__c> lMembers) {
    
        List<Contact> lContacts = new List<Contact>();
        Id houseHoldRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        
        for(Financial_Application_Member__c mem : lMembers) {
            
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
            conInstance.AccountId = faInstance.Household_Account__c;
            conInstance.RecordTypeId = houseHoldRTId;
            lContacts.add(conInstance);
        }    
        System.debug(LoggingLevel.INFO, '==prepareContactList lContacts==' + lContacts);
        if(!lContacts.isEmpty()) {
            //insert new contacts
            Database.insert(lContacts);        
            
            //create map of contacts and return them
            Map<String, Contact> mContacts = new Map<String, Contact>();
            for(Contact con : lContacts) {
                mContacts.put(con.FirstName + '-' + con.LastName + '-' + con.Birthdate, con);
            }
            System.debug(LoggingLevel.INFO, '==prepareContactList mContacts==' + mContacts);
            return mContacts;
        }
        return null;
    }

}