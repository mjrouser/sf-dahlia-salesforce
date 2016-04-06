global with sharing class API_Application {
    
    global class ShortForm {
    	global String id;
    	global ID listingID;
        global Person primaryApplicant;
        global Person secondaryContact;
        global List<Person> householdMembers;
        global Boolean worksInSanFrancisco;
        global String currentStatus;
        global Integer yearsHomeless;
        global Boolean isResident;

        global ShortForm() {} 

        global ShortForm(Application__c app, List<Contact> hms) {
            this.id = app.Id;
            this.primaryApplicant = app.Primary_Applicant__r == null ? null : new Person(app.Primary_Applicant__r);
            this.secondaryContact = app.Secondary_Contact__r == null ? null : new Person(app.Secondary_Contact__r);
            this.householdMembers = new List<Person>();
            for (Contact c : hms) {
                this.householdMembers.add(new Person(c));
            }
            
            this.listingID =  app.Listing__c; 
            this.worksInSanFrancisco = app.Works_In_SF__c;
            this.currentStatus = app.Status__c;
            this.yearsHomeless = Integer.valueOf(app.Years_Homeless__c);
            this.isResident = app.Is_Resident__c;
       }

        global Application__c toApplication() {
            Application__c app = new Application__c();
            app.Id = this.id;
            app.Listing__c = listingID; 
            app.Primary_Applicant__c = this.primaryApplicant == null ? null : this.primaryApplicant.id;
            app.Secondary_Contact__c = this.secondaryContact == null ? null : this.secondaryContact.id;
            app.Works_In_SF__c = this.worksInSanFrancisco;
            app.Status__c = this.currentStatus;
            app.Years_Homeless__c = this.yearsHomeless;
            app.Is_Resident__c = this.isResident;

            return app;
        }
    }

    global class Person {
        global String id;
        global String firstName;
        global String lastName;
        global String dob;
        global String email;
        global String phone;
        global String address;
        global String city;
        global String state;
        global String zip;
        global String mailingAddress;
        global String mailingCity;
        global String mailingState;
        global String mailingZip;
        global String workAddress;
        global String workCity;
        global String workState;
        global String workZip;
        global String gender;
        global Boolean holdsCOP;
        global Boolean holdsDTP;
        global String relationship;
        global Decimal annualIncome;
        global String incomeType;

        global Person() {}

        global Person(Contact c) {
            this.id = c.Id;
            this.firstName = c.FirstName;
            this.lastName = c.LastName;
            this.dob = c.Birthdate == null ? '' : c.Birthdate.format();
            this.email = c.Email;
            this.phone = c.Phone;
            this.address = c.Street_Name__c;
            this.city = c.City__c;
            this.state = c.State__c;
            this.zip = c.Zip_Code__c;
            this.mailingAddress = c.MailingStreet;
            this.mailingCity = c.MailingCity;
            this.mailingState = c.MailingState;
            this.mailingZip = c.MailingPostalCode;
            this.workAddress = c.Work_Street__c;
            this.workCity = c.Work_City__c;
            this.workState = c.Work_State__c;
            this.workZip = c.Work_Postal_Code__c;
            this.gender = c.Gender__c;
            this.holdsCOP = c.Certificate_of_Preference_Holder__c;
            this.holdsDTP = c.Displaced_Tenant_Preference__c;
            this.relationship = c.Relationship_to_Head_of_Household__c;
            this.annualIncome = c.Prior_Tax_Year_Total_Income_Amount__c;
            //this.incomeType = ;
        }

        global Contact toContact() {
            Contact c = new Contact();
            c.Id = this.id;
            c.FirstName = this.firstName;
            c.LastName = this.lastName;
            c.Birthdate = String.isBlank(this.dob) ? null : Date.parse(this.dob);
            c.Email = this.email;
            c.Phone = this.phone;
            c.Street_Name__c = this.address;
            c.City__c = this.city;
            c.State__c = this.state;
            c.Zip_Code__c = this.zip;
            c.MailingStreet = this.mailingAddress;
            c.MailingCity = this.mailingCity;
            c.MailingState = this.mailingState;
            c.MailingPostalCode = this.mailingZip;
            c.Work_Street__c = this.workAddress;
            c.Work_City__c = this.workCity;
            c.Work_State__c = this.workState;
            c.Work_Postal_Code__c = this.workZip;
            c.Gender__c = this.gender;
            c.Certificate_of_Preference_Holder__c = this.holdsCOP == null ? false : this.holdsCOP;
            c.Displaced_Tenant_Preference__c = this.holdsDTP == null ? false : this.holdsDTP;
            c.Relationship_to_Head_of_Household__c = this.relationship;
            c.Prior_Tax_Year_Total_Income_Amount__c = this.annualIncome;
            //this.incomeType = ;

            return c;
        }
    }
    
}