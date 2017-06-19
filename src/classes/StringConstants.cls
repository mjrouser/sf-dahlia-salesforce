/**
 * @author:      Kimiko Roberto
 * @date:        04/23/2014
 * @description: This is a constants class used to track all fixed field items.
 * @history:     06/10/2015 - Heidi Tang - Edited
*/ 
public with sharing class StringConstants {
    
    //User Types
    public static final String IS_HOUSEHOLD_USER = 'Household';
    public static final String IS_LENDER = 'Lender';
    public static final String IS_PROPERTY_AGENT = 'Property Agent';
    public static final String NEW_APPLICANT_YES = 'YES';
    public static final String NEW_APPLICANT_NO = 'NO';
    public static final String EXISTING_APPLICANT_YES = 'YES';
    public static final String EXISTING_APPLICANT_NO = 'NO';
    
    //property agent sub types
    public static final String IS_DEVELOPER = 'Developer';
    public static final String IS_PROPERTY_MANAGER = 'Property Manager';
    public static final String IS_RENTALSALES_AGENT = 'Rental/Sales Agent';
    public static final String IS_REAL_STATE_AGENT = 'Real State Agent';

    //housing application record types
    public static final String HAPP_RENTAL = 'BMR Rental';
    public static final String HAPP_OWNER = 'BMR Ownership';

    //financial application record types
    public static final String FAPP_DALP = 'DALP';

    //Profile Names
    public static final String HOUSEHOLD_PROFILE = 'MOHCD - Household';
    public static final String LENDER_PROFILE = 'MOHCD - Lender';
    public static final String PROPERTY_AGENT_PROFILE = 'MOHCD - Property Agent';
    public static final String GUEST_PROFILE = 'Guest License User';
    public static final String ADMIN_PROFILE = 'System Administrator';    
    public static final String COMMUNITY_PROFILE = 'Customer Community Login User'; 

    //Roles
    public static final String PORTAL_ROLE = 'PortalAccountCreator';   

    //Account
    public static final String ACCT_NAME = 'SFMOHCD Inclusionary Programs';
    
    //Reasons    
    public static final String REASON_NOT_ONLY_ONE_MATCHING_CONTACT = 'contacts were found in the system';
    public static final String REASON_DUPLICATE_USERNAME_EMAIL = 'username matches were found in the system';
    public static final String REASON_REGISTRATION_ID = 'We apologize, we cannot find a match to the Registration ID you entered. Please check your information for typos, or remove the registration code and try again.';
    public static final String REASON_REGISTRATION = 'We apologize, we cannot find a match to the information you entered. Please check your information for typos, and try again.';
    public static final String REASON_MAINTENANCE = 'We apologize, it seems there is a problem with your registration. Please contact MOHCD at 415-701-5500 for assistance. We are sorry for the inconvenience.';

    //Missing or Invalid fields
    public static final String PROVIDE_FIRST = 'Provide Information: First Name';
    public static final String PROVIDE_LAST = 'Provide Information: Last Name';
    public static final String PROVIDE_BIRTH = 'Provide Information: Birthdate';
    public static final String PROVIDE_ZIP = 'Provide Information: Zipcode';
    public static final String INVALID_ZIP = 'Zipcode length too long';
    public static final String PROVIDE_EMAIL = 'Provide Information: Email';
    public static final String INVALID_EMAIL = 'Email is invalid';

    //Cert record types 
    public static final String CERT_RECTYPE_COP = 'COP';
    
    //Acct Record Types
    public static final String ACCT_HOUSEHOLD = 'Household';
    public static final String ACCT_LENDER = 'Lender';
    
    //Contact 
    public static final String CONTACT_HOUSEHOLD = 'Household';
    public static final String CONTACT_LENDING_AGENT = 'Lending Agent';
    
    //Listing Record Types
    public static final String LISTING_PROPERTY = 'Property';
    public static final String LISTING_UNIT = 'Unit';

    //Parameters
    public static final String PARAM_STARTURL = 'startURL';
    public static final String PARAM_DISPLAY = 'display';
    public static final String PARAM_LENDER = 'lid';
    public static final String PARAM_PID = 'pId';
    public static final String PARAM_ID = 'Id';
    
    //Documents
    public static final String DOC_HEADER_IMAGE = 'SF-MOH Header Image';
    public static final String DOC_TYPE = 'Document';
    
    //Occupancy Type for Properties
    public static final String PROP_RENTAL = 'Rental';
    public static final String PROP_OWNERSHIP = 'Ownership';
    
    //EAHP Errors
    public static final String EAHP_MOVE_IN = 'Date of Move In';
    public static final String EAHP_NOI = 'Date NOI was filed';
    public static final String EAHP_MOVE_OUT = 'Date of Move Out';
    public static final String EAHP_BIRTHDATE = 'Patient\'s Birthdate';
    
}