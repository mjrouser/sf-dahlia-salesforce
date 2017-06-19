/***************************************************************************
 * @author Kimiko Roberto
 * @date 16 May 2014
 * @description An apex page controller that supports creation of New Certificate Application
    for users
 * @revision(s)
 ***************************************************************************/
public with sharing class SfmohprogramsNewCertAppCont {


    public String firstName {get; set;}
    public String lastName {get; set;}
    public String address {get; set;}
    public String phone {get; set;}
    public String email {get; set;}
    public String conId {get; set;}
    public Contact con_detail {get; set;}
    public String relToHH {get;set;}
    public String dpAdd1 {get; set;}
    public String dpAdd2 {get; set;}
    public String yrOfDp {get; set;}
    public String yrOfDp2 {get; set;}
    public String nameOfHHDp {get; set;}
    List<Contact> fetchCon = new List<Contact>();
    public Boolean isWestern {get; set;}
    public Boolean isHunters {get; set;}
    public Boolean isDisplaced {get; set;}
    public List<SfmohprogramsWrapperClass.wContact> wrpContact {get;set;}
    SfmohprogramsWrapperClass conwrap = new SfmohprogramsWrapperClass();
    public SfmohprogramsNewCertAppCont() {
        wrpContact = conwrap.getContacts2();
        
    }



    public PageReference selectContact(){
        if(conId == '' || conId == null){
            firstName = '';
            lastName = '';
            address = '';
            phone = '';
            email = '';
        }
        else if(conId != '' || conId != null){
            fetchCon = [SELECT Id,
                               AccountId,
                               FirstName,
                               LastName,
                               Phone,
                               Email,
                               Current_Address__c
                               FROM Contact
                               WHERE Id =: conId];
            for (Contact c : fetchCon) {
                firstName = c.FirstName;
                lastName = c.LastName;
                address = c.Current_Address__c.replace('<br>','   ');
                phone = c.Phone;
                email = c.Email;
            }
        }
        
        return null;
    }

    public PageReference submitRequest(){
    
        if (fetchCon != null && ! fetchCon.isEmpty()) {
            List<Certificate_Program__c> certAppList = new List<Certificate_Program__c>();
            Certificate_Program__c certApp = new Certificate_Program__c();
            Recordtype recTypeId = [SELECT Id from Recordtype where Name=:StringConstants.CERT_RECTYPE_COP ];

                 
                
            certApp.RecordTypeId = recTypeId.Id;
            certApp.Household_Contact__c = fetchCon[0].Id;
            certApp.Household_Account__c = fetchCon[0].AccountId;
            certApp.Application_Status__c = 'Received';
            certApp.Submit_Date__c = Date.today();
            certApp.Western_Addition_between_1966_and_1975__c = isWestern;
            certApp.Hunters_Point_between_1966_and_1975__c = isHunters;
            certApp.Telephone_Number__c = phone;
            certApp.Email_Address__c = email;
            //certApp.Requester_s_Mailing_Address__c = fetchCon[0].Current_Address__c.replace('<br>',' ');
            certApp.Displacement_Address_1__c = dpAdd1;
            certApp.Displacement_Address_2__c = dpAdd2;
            certApp.Name_of_Head_of_Household_when_Displaced__c = nameOfHHDp;
            certApp.Relationship_to_Head_of_Household__c = relToHH;
            certApp.In_what_year_were_you_displaced__c = yrOfDp;
            certApp.In_what_year_were_you_displaced_2__c = yrOfDp2;
            certAppList.add(certApp);

            System.debug('********************' + certAppList);

            if (certAppList != null && !certAppList.isEmpty()) {
                insert certAppList;
            }
            //PageReference page = new PageReference('/housingprograms/'+ certApp.Id);
            //Change redirection page Ronald Martinez 07/17/2014 
            PageReference page = new PageReference('/housingprograms/mohcdViewMyCerts'); 
            page.setRedirect(true);
            return page;

        }

        

        return null;
    }


    public List<SelectOption> getPicklist() {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
            for(SfmohprogramsWrapperClass.wContact cn: wrpContact){
                options.add(new SelectOption(cn.con.Id,cn.con.FirstName));
            }
        return options;
    }





}