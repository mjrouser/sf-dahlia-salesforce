//services/apexrest/Listings
@RestResource(urlMapping='/Listings/*')
global with sharing class ListingApi {

    public class InvalidParamsException extends Exception {}
    
    public class NoRecordMatchException extends Exception {}
 
    @HttpGet
    global static List<Listing__c> doGet () {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        List<String> tokens =  req.requestURI.split('/');
        
        //sample uri = /listings/<sfdcid>
        if (tokens.size()>2) {
            return ListingService.getListingByID(tokens[2]); 
        } 
        if (req.params.containsKey('id')) {
            return ListingService.getListingByID(req.params.get('id'));
        }
        
        if (req.params.containsKey('ids')) {
            String ids = req.params.get('ids');
            List<String> idList  = ids.split(','); 
            return ListingService.getListingByIDs(idList); 
        } 
        //householdsize && incomelevel
     
        
        if (req.params.containsKey('householdsize') ||  req.params.containsKey('incomelevel') ) {
            String childrenUnder6 = req.params.get('childrenUnder6') ;
            String houseHoldSize = req.params.get('householdsize');
            String incomelevel = req.params.get('incomelevel'); 
            string preferenceName = req.params.get('preference');
            
            if (incomelevel== null || houseHoldSize == null) {
                throw new InvalidParamsException('Both parameters "householdsize" and "incomelevel" required');
            }
            ListingService.Criteria crit=  new ListingService.Criteria();
            try { 
                crit.householdSize = Integer.valueof(houseHoldSize);
                crit.incomelevel =Decimal.valueof( incomelevel);
                crit.childrenUnder6  = (childrenUnder6!=null) ? Integer.Valueof(childrenUnder6) : 0;
                crit.preferenceName = (preferenceName != null) ? preferenceName : '';
            }
            catch (Exception e) {
                
                throw new InvalidParamsException('Invalid Parameter input: Integer required for "householdsize", was passed value : ' + houseHoldSize + '  and Decimal required for "incomelevel", was passed value:' +  incomelevel +' Integer required for "childrenUnder6", was passed value : '  + childrenUnder6); // put friendly message here
                
            }
            return ListingService.getListingByCriteria(crit);
        
        } else if(req.params.containsKey('preference') ){
        	string preferenceName = req.params.get('preference');
    		if(preferenceName != null && preferenceName != ''){
            	return ListingService.getActiveListingsByPreference(preferenceName);
    		}
        }
        
        
        
        return ListingService.getAllActiveListings();
    }
    /*
    Class criteria {
        Integer householdSize;
        Decimal incomelevel;
        Integer childrenUnder6;
        //ages of children ;
        //prego
    }
    public static boolean doesMatch(Listing__c listing, Criteria crit) {
        
        return true;
    }
  
    
    global static List<Listing__c> getAllActive()
    {
 
        return [Select Building_Name__c, Building_Street_Address__c, Building_City__c, Building_State__c, (SELECT Lottery_Number__c, Rank__c FROM Lottery_Members__r where Status__c = 'Winner'), Building_Zip_Code__c, Developer__c, Application_Due_Date__c, Building_URL__c, (SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Rental_Minimum_Monthly_Income_Needed__c FROM Units__r ORDER BY Unit_Type__c), Application_Phone__c, Lottery_Summary__c, Lottery_Results_Date__c, Lottery_Date__c, AMI_Percentage__c,  Preference_Detail__c, Credit_Rating__c, Criminal_History__c, Eviction_History__c,  Leasing_Agent_Name__c, Leasing_Agent_Title__c, Leasing_Agent_Email__c, Leasing_Agent_Phone__c from Listing__c where Status__c = 'Active'];

    } 
    
    global static List<Listing__c> getByID(String sID)
    { 
       
        return [Select Building_Name__c, Building_Street_Address__c, Building_City__c, Building_State__c, Building_Zip_Code__c, Developer__c, Building_URL__c, Description__c, Neighborhood__c, Year_Built__c, LastModifiedDate, (SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Rental_Minimum_Monthly_Income_Needed__c, Unit_Square_Footage__c,  Unit_Number__c, Unit_Floor__c, Other_Accessibility_Information__c,Number_of_Bathrooms__c FROM Units__r ORDER BY Unit_Type__c),  Application_Organization__c, Application_Street_Address__c, Application_City__c, Application_State__c, Application_Postal_Code__c, Office_Open__c, Office_Closed__c,   Application_Phone__c, Leasing_Agent_Name__c, Leasing_Agent_Title__c, Leasing_Agent_Email__c, Leasing_Agent_Phone__c,  Organization_URL__c, Download_URL__c, Application_Due_Date__c, Fee__c, Deposit_Min__c, Deposit_Max__c, Costs_Not_Included__c, Lottery_Preferences__c, Rental_Assistance__c, (SELECT Date__c, Start_Time__c, End_Time__c, Venue__c, Street_Address__c, City__c FROM Information_Sessions__r), (SELECT Date__c, Start_Time__c, End_Time__c FROM Open_Houses__r), Lottery_Results_Date__c, Lottery_Date__c, Lottery_End__c, Lottery_Start_Time__c, Lottery_End_Time__c, Lottery_Venue__c, Lottery_Street_Address__c, Lottery_City__c, Lottery_Summary__c, (SELECT Lottery_Number__c, Rank__c FROM Lottery_Members__r where Status__c = 'Winner'), Amenities__c, Accessibility__c, Building_Selection_Criteria__c, Required_Documents__c, Legal_Disclaimers__c, Smoking_Policy__c, Pet_Policy__c, AMI_Percentage__c,  Preference_Detail__c, Credit_Rating__c, Criminal_History__c, Eviction_History__c from Listing__c Where Id =:sID ];

    } 
    
    global static List<Listing__c> getByIDs(List<String> sIDs)
    {
        return [Select Building_Name__c, Building_Street_Address__c, Building_City__c, Building_State__c, Building_Zip_Code__c, Developer__c, Application_Due_Date__c, Building_URL__c, (SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Rental_Minimum_Monthly_Income_Needed__c FROM Units__r ORDER BY Unit_Type__c), Leasing_Agent_Name__c, Leasing_Agent_Title__c, Leasing_Agent_Email__c, Leasing_Agent_Phone__c, Application_Phone__c, AMI_Percentage__c,  Preference_Detail__c, Credit_Rating__c, Criminal_History__c, Eviction_History__c, (SELECT Lottery_Number__c, Rank__c FROM Lottery_Members__r where Status__c = 'Winner') from Listing__c  Where id in :sIDs ];

    } 
    private static List<Listing__c> getMatches(Criteria crit )
    {
     
        system.debug ('crit' + crit);
        Set<ID> ids = findMatchingListings(crit);
        List<Listing__c> listings = getAllActive();
        for (Listing__c listing: listings ){
            listing.Does_Match__c = (ids.contains(listing.id))? true:false;
        }
  //        List< Listing__c> listings = [Select Property_Name__c, Property_Street_Address__c, Property_City__c, Property_State__c, Property_Zip_Code__c, Developer__c, Application_Due_Date__c, Property_URL__c, (SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Minimum_Annual_Income_Needed__c FROM Units__r), Application_Phone__c from Listing__c where Status__c = 'Active' and id in :ids ];
    
        return listings;
    } 
     
   
    public static Set<ID> findMatchingListings(Criteria crit ) {
        loadAMIMap();
        Integer houseHoldSize = crit.householdSize;
        Decimal Income = crit.incomelevel;
        List<Unit__c> relevantUnits = new List<Unit__c>();
        Set<ID> listingIDS = new Set<ID>();
        Integer maxHouseHold = houseHoldSize-crit.childrenUnder6;
        Integer minHouseHold = houseHoldSize;
           
        for (Unit__c unit : [select id, BMR_Minimum_Annual_Income_Needed__c, of_AMI_for_Pricing_Unit__c, Listing__c, Maximum_Household_Size__c  from Unit__c  where Maximum_Household_Size__c>= :maxHouseHold and Min_Occupancy__c<=:minHouseHold]) {
           system.debug(unit);
            Decimal amiAmount =  getAMI(houseHoldSize, unit.of_AMI_for_Pricing_Unit__c );
           // Decimal amiAmount =  getAMI(unit.Maximum_Household_Size__c, unit.of_AMI_for_Pricing_Unit__c );
            if ((unit.BMR_Minimum_Annual_Income_Needed__c  < Income) && (Income < amiAmount )) {
            	system.debug('amiAmount: ' + amiAmount +  ' income: ' + Income + ' unit '  + unit.BMR_Minimum_Annual_Income_Needed__c + ' unit.id ' + unit.id );
                relevantUnits.add(unit);
                listingIDS.add(unit.Listing__c);
            }
        
        }
        return listingIDS;
    }
    private static Decimal getAMI(Decimal household, Decimal precentOfMedian ) {
        if (household== null || precentOfMedian == null) {
            return -1;
        }
        Map<Decimal, Decimal> percentMap =AMIMap.get(household);
        if (percentMap==null) {
            system.debug('houldhold not found' +household  + ' ' + AMIMap);
            return -1;
        }
        Decimal amount = percentMap.get(precentOfMedian);
        if (amount==null){
                        system.debug('percent not found' +precentOfMedian  + ' ' + percentMap);
            
            
            amount=-1; 
        }
        return amount;
    }
    private static Map<Decimal,  Map<Decimal,Decimal>> AMIMap ; // [household, percent]
     
    private static void loadAMIMap(){
            AMIMap = new Map<Decimal,  Map<Decimal,Decimal>> (); //household to percent
            for (AMI__c ami : [select id, amount__c, Num_of_HouseHold__c, Percent_of_Median__c from AMI__c]) {
                 Map<Decimal,Decimal> percentMap = AMIMap.get(ami.Num_of_HouseHold__c);
                 if (percentMap == null) { 
                    percentMap = new Map<Decimal,Decimal>();
                    AMIMap.put(ami.Num_of_HouseHold__c, percentMap);
                 }
                 percentMap.put(ami.Percent_of_Median__c,ami.amount__c);
            }
    }
 */
    //Min_Occupancy__c 
    //Maximum_Household_Size__c
    // BMR_Minimum_Annual_Income_Needed__c < users_income <   ami(Num_of_HouseHold__c,Percent_of_Median__c);
    
   // Percent_of_Median__c = unit.of_AMI_for_Pricing_Unit__c
    // 
    //[select id  from ami_chart__c  where ]
    
}