public class CS_TestDataSetup {
 
    public static Account createTestAccount(String Name, String Phone, String Industry, Id RecordTypeId) {
        Account accAccount = new Account(Name = Name,
            Phone = Phone,
            Industry = Industry, 
            BillingStreet = 'Green Street', 
            BillingCity = 'NY',
            BillingState = 'California', 
            BillingPostalCode = '95123', 
            BillingCountry = 'United States', 
            Type = 'Vendor',
            RecordTypeId = RecordTypeId,
            Lender_Participation_Fee_Status__c = 'Current', 
            Website = 'www.xyz.com');
        return accAccount;        
    }

    public static User createGuestUser() {
        List<Profile> profiles = new List<Profile>([SELECT Id FROM Profile where Name = :StringConstants.GUEST_PROFILE LIMIT 1]);
        
        User guestUser = new User( Username = 'testUserDataUnique@email.com', FirstName='testUserData userFirstName', LastName = 'testUserData userLName', Alias = 'testA',
                                    CommunityNickname = 'testUserData',TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',EmailEncodingKey = 'ISO-8859-1',
                                    LanguageLocaleKey = 'en_US', Email = 'test@email.com', IsActive = true, ProfileId = profiles[0].Id);                        
        return guestUser;
    }
    
    public static Contact CreateTestContact(Id AccountId, String LastName, String FirstName, String Email, Id RecordTypeId) {
        Contact conContact = new Contact(AccountId = AccountId,
            LastName = LastName, BMR_Certification_Expiration_Date__c = System.today()+10,
            FirstName = FirstName, DALP_MCC_Certification_Expiration_Date__c = System.today()+10,
            Email = Email, 
            Phone = '1234567890',
            RecordTypeId = RecordTypeId,
            MobilePhone = '1234567890');
        return conContact;
    }
    
    public static Properties__c createTestProperties(Integer Price, String Occupancy_Type, Decimal of_Bathrooms, Integer of_Bedrooms, String New_or_Existing, String Property_Type, String Neighborhood, Id RecordTypeId) {
        
        Properties__c propInstance = new Properties__c(Price__c = Price, 
            Occupancy_Type__c = Occupancy_Type, of_Bathrooms__c = of_Bathrooms, 
            of_Bedrooms__c = of_Bedrooms, New_or_Existing__c = New_or_Existing, 
            Property_Type__c = Property_Type, Neighborhood__c = Neighborhood,
            Property_Photo_1__c = 'This is test image1',
            Property_Photo_2__c = 'This is test image2',
            Property_Photo_3__c = 'This is test image3',
            Property_Photo_4__c = 'This is test image4',
            RecordTypeId = RecordTypeId,            
            Area_Sq_Ft__c = 100,
            Search_Bedrooms__c = 'Studio;1;2', Search_Bathrooms__c = '1;2;3', 
            Search_Price_Max__c = 10000, Search_Price_Min__c = 1000, 
            Search_Sq_Ft_Max__c = 2500, Search_Sq_Ft_Min__c = 500,
            Street_Name__c = 'WaterStreet',
            Street_Type__c = 'Street',
            City__c = 'San Diago',
            State__c = 'CA',            
            Zip_Code__c = '12345',
            Active__c = true);
        
        return propInstance;
    }
    
    public static Financial_Application__c createFinancialApplication(Id HousingAppId, String Application_Status, Id AccountId, Id RecordTypeId, Id LoanOfficerId) {
        Financial_Application__c financialAppInstance = new Financial_Application__c(
            Housing_Application__c = HousingAppId, Household_Account__c = AccountId, 
            Application_Status__c = Application_Status, RecordTypeId = RecordTypeId,
            Loan_Officer__c = LoanOfficerId,Copy_Existing_Info__c = true);
        return financialAppInstance;
    }
    
    public static Financial_Application_Member__c createFinancialApplicationMember(Id FinancialAppId, String Borrower_Role, String First_Name, String Last_Name, Date Date_of_Birth, String RelationshipWithHH) {
        Financial_Application_Member__c financialMemberInstance = new Financial_Application_Member__c(
            Financial_Application__c = FinancialAppId, 
            Relationship_to_Head_of_Household__c = RelationshipWithHH, Borrower_Role__c = Borrower_Role,
            First_Name__c = First_Name, Last_Name__c = Last_Name, Date_of_Birth__c = Date_of_Birth);
        return financialMemberInstance;        
    }
    
    public static Financial_Application_Income__c createFinancialApplicationMemberIncome(Id FinancialAppId, Id FinancialAppMemberId, Id RecordTypeId) {
        Financial_Application_Income__c financialMemberIncomeInstance = new Financial_Application_Income__c(
            Financial_Application__c = FinancialAppId, Financial_Application_Member__c = FinancialAppMemberId,
            RecordTypeId = RecordTypeId);
        return financialMemberIncomeInstance;        
    }
    
    public static Financial_Application_Asset__c createFinancialApplicationMemberAsset(Id FinancialAppId, Id FinancialAppMemberId, Id RecordTypeId) {
        Financial_Application_Asset__c financialMemberAssetInstance = new Financial_Application_Asset__c(
            Financial_Application__c = FinancialAppId, Financial_Application_Member__c = FinancialAppMemberId,
            RecordTypeId = RecordTypeId);
        return financialMemberAssetInstance;        
    }
    
    public static Housing_Application__c createHousingApplication(Id Property_of_Interest, String Application_Status) {
        Housing_Application__c housingAppInstance = new Housing_Application__c(
            Property_of_Interest__c = Property_of_Interest, Application_Status__c = Application_Status,
            Lottery_Number__c = '1', Lottery_Number_re_enter__c = '1', Lottery_Rank__c = 123,
            OwnerId = Userinfo.getUserId());
        return housingAppInstance;        
    }
    
    public static Certificate_Program__c createCertificateProgram(String Application_Status, Id HouseholdContactId, Id HouseholdAccountId, Date Submit_Date, Id RecordTypeId) {
        Certificate_Program__c cpInstance = new Certificate_Program__c(
            Application_Status__c = Application_Status, Household_Contact__c = HouseholdContactId, 
            Household_Account__c = HouseholdAccountId, Submit_Date__c = Submit_Date,
            Email_Address__c = 'test@fakemail.com', RecordTypeId = RecordTypeId);        
        return cpInstance;
    }
    
    public static User createTestPortalUser(String FName, String LName, String Email, Id ProfileId, Id ContactId) {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        User usr = new User( Email = Email, Contactid = ContactId, Profileid = ProfileId, 
                             UserName = Email, alias=uniqueName.substring(18, 23), CommunityNickName = FName, 
                             TimeZoneSidKey = 'America/New_York', LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', 
                             LanguageLocaleKey = 'en_US', FirstName = FName, LastName = LName);
        return usr;
    }
    
    public static User createTestUser(String FistName, String LastName, Id ProfileId) {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User usr = new User(Email = uniqueName + '@test' + orgId + '.org',
            Username = uniqueName + '@test' + orgId + '.org',            
            Alias = uniqueName.substring(18, 23),
            EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = ProfileId, isActive = true, 
            TimeZoneSidKey='America/Los_Angeles');
        return usr;
    }
}