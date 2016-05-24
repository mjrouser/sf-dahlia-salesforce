global  class ListingService {
    
    private static final String LOTTERY_QUERY = 'SELECT Lottery_Number__c, Rank__c FROM Lottery_Members__c where Status__c = \'Winner\'';
    private static final String LISTING_QUERY='Select name, Building_Name__c, Building_Street_Address__c, Building_City__c, Building_State__c, Building_Zip_Code__c, Developer__c, Description__c, Neighborhood__c, Year_Built__c, LastModifiedDate, Application_Due_Date__c, Building_URL__c, Legal_Disclaimers__c, Application_Organization__c, Application_Street_Address__c, Application_City__c, Application_State__c, Application_Postal_Code__c, Application_Phone__c, Lottery_Summary__c, Lottery_Results_Date__c, Lottery_End__c, Lottery_Start_Time__c, Lottery_End_Time__c, Lottery_Venue__c, Lottery_Street_Address__c, Lottery_City__c, Lottery_Date__c, AMI_Percentage__c,  Preference_Detail__c, Credit_Rating__c, Criminal_History__c, Eviction_History__c,  Leasing_Agent_Name__c, Leasing_Agent_Title__c, Leasing_Agent_Email__c, Leasing_Agent_Phone__c, Lottery_Results__c, Lottery_Winners__c, Office_Open__c, Office_Closed__c,  Organization_URL__c, Download_URL__c, Fee__c, Deposit_Min__c, Deposit_Max__c, Costs_Not_Included__c, Lottery_Preferences__c, Rental_Assistance__c, Amenities__c, Accessibility__c, Building_Selection_Criteria__c, Required_Documents__c,Smoking_Policy__c, Pet_Policy__c,(SELECT Date__c, Start_Time__c, End_Time__c, Venue__c, Street_Address__c, City__c FROM Information_Sessions__r), (SELECT Date__c, Start_Time__c, End_Time__c FROM Open_Houses__r), (SELECT Id, Lottery_Preference__r.Id, Lottery_Preference__r.Name FROM Listing_Lottery_Preferences__r), (SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Rental_Minimum_Monthly_Income_Needed__c FROM Units__r ORDER BY Unit_Type__c), (SELECT id, Name, Image_URL__c FROM Listing_Images__r) from Listing__c';
    // 01/25/2016 - 'Select Building_Name__c, Building_Street_Address__c, Building_City__c, Building_State__c, Building_Zip_Code__c, Developer__c, Description__c, Neighborhood__c, Year_Built__c, LastModifiedDate, Application_Due_Date__c, Building_URL__c, Legal_Disclaimers__c, Application_Organization__c, Application_Street_Address__c, Application_City__c, Application_State__c, Application_Postal_Code__c, Application_Phone__c, Lottery_Summary__c, Lottery_Results_Date__c, Lottery_End__c, Lottery_Start_Time__c, Lottery_End_Time__c, Lottery_Venue__c, Lottery_Street_Address__c, Lottery_City__c, Lottery_Date__c, AMI_Percentage__c,  Preference_Detail__c, Credit_Rating__c, Criminal_History__c, Eviction_History__c,  Leasing_Agent_Name__c, Leasing_Agent_Title__c, Leasing_Agent_Email__c, Leasing_Agent_Phone__c, Lottery_Results__c, Lottery_Winners__c, Office_Open__c, Office_Closed__c,  Organization_URL__c, Download_URL__c, Fee__c, Deposit_Min__c, Deposit_Max__c, Costs_Not_Included__c, Lottery_Preferences__c, Rental_Assistance__c, Amenities__c, Accessibility__c, Building_Selection_Criteria__c, Required_Documents__c,Smoking_Policy__c, Pet_Policy__c,(SELECT Date__c, Start_Time__c, End_Time__c, Venue__c, Street_Address__c, City__c FROM Information_Sessions__r), (SELECT Date__c, Start_Time__c, End_Time__c FROM Open_Houses__r),(SELECT Lottery_Number__c, Rank__c FROM Lottery_Members__r where Status__c = \'Winner\'),(SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Rental_Minimum_Monthly_Income_Needed__c, Unit_Square_Footage__c,  Unit_Number__c, Unit_Floor__c, Other_Accessibility_Information__c,Number_of_Bathrooms__c FROM Units__r ORDER BY Unit_Type__c),  (SELECT Id, Lottery_Preference__r.Id, Lottery_Preference__r.Name FROM Listing_Lottery_Preferences__r) from Listing__c';
    // 02/19/2016 - 'Select Building_Name__c, Building_Street_Address__c, Building_City__c, Building_State__c, Building_Zip_Code__c, Developer__c, Application_Due_Date__c, Building_URL__c, Legal_Disclaimers__c, (SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Rental_Minimum_Monthly_Income_Needed__c FROM Units__r ORDER BY Unit_Type__c), Application_Phone__c, Lottery_Summary__c, Lottery_Results_Date__c, Lottery_Date__c, AMI_Percentage__c,  Preference_Detail__c, Credit_Rating__c, Criminal_History__c, Eviction_History__c,  Leasing_Agent_Name__c, Leasing_Agent_Title__c, Leasing_Agent_Email__c, Leasing_Agent_Phone__c, Lottery_Results__c, Lottery_Winners__c, (SELECT Id, Lottery_Preference__r.Id, Lottery_Preference__r.Name FROM Listing_Lottery_Preferences__r) from Listing__c';
    private static final String LISTING_PREFERENCE_QUERY = 'SELECT Id, NAME, Listing__c, Lottery_Preference__c FROM Listing_Lottery_Preference__c ';
    private static final String LISTING_QUERY_ORDER = ' ORDER BY Unit_Type__c';
    private static final String LOTTERY_PREFERENCE_QUERY = 'SELECT Id, Name, Description__c FROM Lottery_Preference__c ';
  	private static final String UNIT_BY_LISTING_QUERY = 'SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Rental_Minimum_Monthly_Income_Needed__c, Unit_Square_Footage__c,  Unit_Number__c, Unit_Floor__c, Other_Accessibility_Information__c,Number_of_Bathrooms__c FROM Unit__c where Listing__c = :listingID  ORDER BY Unit_Type__c ';
    

 //
    
        static String UNIT_QUERY = 'SELECT Listing__c, Unit_Type__c,count(id)Total, MIN(BMR_Rental_Minimum_Monthly_Income_Needed__c) minRentalMinIncome,  MAX(BMR_Rental_Minimum_Monthly_Income_Needed__c) maxRentalMinIncome, MIN(BMR_Rent_Monthly__c) minMonthlyRent ,   MAX(BMR_Rent_Monthly__c) maxMonthlyRent , MIN(Min_Occupancy__c)Min_Occupancy, Max(Maximum_Household_Size__c)Max_Occupancy, MIN(Unit_Square_Footage__c)Sq_Footage_Min, MAX(Unit_Square_Footage__c)Sq_Footage_Max  FROM UNIT__C ';
    
  //  static String UNIT_QUERY = 'SELECT Listing__c, Unit_Type__c,count(id)Total, MIN(Min_Occupancy__c)Min_Occupancy, Max(Maximum_Household_Size__c)Max_Occupancy, MIN(Unit_Square_Footage__c)Sq_Footage_Min, MAX(Unit_Square_Footage__c)Sq_Footage_Max  FROM UNIT__C ';
    static string UNIT_QUERY_GROUP =  ' GROUP BY listing__C, Unit_Type__c ';
    static string UNIT_QUERY_ALL =UNIT_QUERY + UNIT_QUERY_GROUP;
    

    global static List<Listing__c>  getListingByID(String listingID)
    { 
        ID theID = ID.valueof(listingID);
        Set<ID> listingIDs = new Set<ID> {theID};
        return getListingByIDs(listingIDs);
       
    } 
    global static List<Listing__c>  getListingByIDs(List<String> sListingIDS){
        Set<ID> listingIDS = new Set<ID>();
        for (String sID : sListingIDS) {
            ID theID = ID.valueof(sID);
            listingIDS.add(theID);  
        }
        return getListingByIDs(listingIDS);
    }
        
    
    global static List<Listing__c>  getListingByIDs(Set<ID> listingIds)
    { 
        return  getListingByFilter(listingIds,null);
    } 
    
    global static List<Listing__c> getListingByFilter( Set<ID> listingIDs,String filter)
    { 
        String query  = LISTING_QUERY;
        system.debug(listingIDs);
        String queryFilter='';
        if (listingIds!=null && listingIDs.size()>0) {
            queryFilter+= ' id in:listingIDs';
        }
        if (filter!=null) {
            if (queryFilter.length()>0) {
                queryFilter+=' and ';
            } 
            queryFilter += filter; 
        }
        query += (queryFilter.length()>0)? ' where ' + queryFilter: '';
        system.debug('query:::' + query) ;
        List<Listing__c> listings = (List<Listing__c>) Database.Query(query);
  //     Map<ID,Listing__c> listingMap = new Map<ID,Listing__c> (listings);
       system.debug('listings:::' + listings) ;
        return listings;
    } 
    
    global static List<Listing__c> getActiveListingsByPreference(string preferenceName){
        string llpQuery = LISTING_PREFERENCE_QUERY + ' WHERE Lottery_Preference__r.Name = \'' + preferenceName + '\'';
        List<Listing_Lottery_Preference__c> llps = database.query(llpQuery);
        Set<Id> listingIds = new Set<ID>();
        for(Listing_Lottery_Preference__c llp : llps){
            listingIds.add(llp.Listing__c);
        }
        List<Listing__c> listings = new List<Listing__c>();
        if(!listingIds.isEmpty()){
            listings = getListingByFilter(listingIds, ' Status__c = \'Active\'');
        }
        return listings;
    }
    
    global static List<Listing__c>  getAllActiveListings()
    {
        return getListingByFilter(new Set<ID>(), ' Status__c = \'Active\'');
 
    } 
    
   public static LIst<ListingDetail> getListingDetailByCriteria(Criteria crit )
    {
         Set<ID> ids = findMatching(crit);
         List<Listing__c> listings = getAllActiveListings();
         Map<Id,Listing__c> listingMap = new Map<Id,Listing__c>();
         
        for (Listing__c listing: listings){ // can and probably should move this to listing detail
            listingMap.put(listing.Id,listing);
            listing.Does_Match__c = (ids.contains(listing.id))? true:false;
            system.debug('listing.Does_Match__c ::' + listing.Does_Match__c );
            if(crit.PreferenceName != null && crit.PreferenceName != '' && listing.Does_Match__c){
                boolean prefFound = false;
                for(Listing_Lottery_Preference__c llp : listing.Listing_Lottery_Preferences__r){
                    if(llp.Lottery_Preference__r.Name == crit.PreferenceName){
                        prefFound = true;
                        break;
                    }
                }
                system.debug('prefFound: ' + prefFound);
                listing.Does_Match__c = prefFound;
            }
        }
        
        LIst<ListingDetail> listingDetails = getListingDetails(getListingByCriteria(crit));
        for (ListingDetail detail : listingDetails) {
            detail.doesMatch =  (ids.contains(detail.listingID))? true:false;
            //check if preference was met
            if(listingMap.containsKey(detail.listingID)){
                Listing__c chkListing = listingMap.get(detail.listingID);
                boolean prefFound = false;
                for(Listing_Lottery_Preference__c llp : chkListing.Listing_Lottery_Preferences__r){
                    if(llp.Lottery_Preference__r.Name == crit.PreferenceName){
                        prefFound = true;
                        break;
                    }
                }
                system.debug('prefFound: ' + prefFound);
                detail.doesMatch = prefFound;
            }
        }
        return listingDetails;
   
    } 
    global static  List<ListingDetail> getListingDetailByID (String listingID ) {
    //  ID theID = ID.valueof(listingID);
    //  List<ID> listingIDs = new List<ID> ();
        return getListingDetailByIDs(new List<String> {listingID} );
    }
   
    global static  List<ListingDetail> getListingDetailByIDs (List<String> sIDs ) {
        return getListingDetails(getListingByIDs(sIDs));
    }
    
    global static  List<ListingDetail> getAllActiveListingDetails ( ) {
        return getListingDetails(getAllActiveListings());
    }
    
   
 
    public static LIst<Listing__c> getListingByCriteria(Criteria crit )
    {
     
        system.debug ('crit' + crit);
        Set<ID> ids = findMatching(crit);
        system.debug('matched ids: ' + ids);
         List<Listing__c> listings = new List<Listing__c>();
         List<Listing__c> matchedListings = new List<Listing__c>();
         
        listings = getAllActiveListings();
         
        system.debug('listings: ' + listings);
        for (Listing__c listing: listings){ // can and probably should move this to listing detail
            listing.Does_Match__c = (ids.contains(listing.id))? true:false;
            if(crit.PreferenceName != null && crit.PreferenceName != '' && listing.Does_Match__c){
                boolean prefFound = false;
                for(Listing_Lottery_Preference__c llp : listing.Listing_Lottery_Preferences__r){
                    if(llp.Lottery_Preference__r.Name == crit.PreferenceName){
                        prefFound = true;
                        break;
                    }
                }
                system.debug('prefFound: ' + prefFound);
                listing.Does_Match__c = prefFound;
            }
            
        }
        system.debug('listings: ' + listings);
        
        return listings;
    } 
    
 
    private static Set<ID> findMatching(Criteria crit ) {
      //  loadAMIMap();
        Integer houseHoldSize = crit.householdSize;
        Decimal Income = crit.incomelevel;
        List<Unit__c> relevantUnits = new List<Unit__c>();
        Set<ID> listingIDS = new Set<ID>();
        Integer maxHouseHold = houseHoldSize-crit.childrenUnder6;
        Integer minHouseHold = houseHoldSize;
           
        for (Unit__c unit : [select id, BMR_Minimum_Annual_Income_Needed__c, of_AMI_for_Pricing_Unit__c, Listing__c, Maximum_Household_Size__c  from Unit__c  where Maximum_Household_Size__c>= :maxHouseHold and Min_Occupancy__c<=:minHouseHold]) {
           system.debug('unit:::'+ unit + ' ' + houseHoldSize );
            Decimal amiAmount =  getAMI(houseHoldSize, unit.of_AMI_for_Pricing_Unit__c );
           // Decimal amiAmount =  getAMI(unit.Maximum_Household_Size__c, unit.of_AMI_for_Pricing_Unit__c );
           system.debug('unit.BMR_Minimum_Annual_Income_Needed__c::' + unit.BMR_Minimum_Annual_Income_Needed__c + '  ' + Income + '  ' + amiAmount);
            if ((unit.BMR_Minimum_Annual_Income_Needed__c  < Income) && (Income < amiAmount )) {
                system.debug('amiAmount: ' + amiAmount +  ' income: ' + Income + ' unit '  + unit.BMR_Minimum_Annual_Income_Needed__c + ' unit.id ' + unit.id );
                relevantUnits.add(unit);
                listingIDS.add(unit.Listing__c);
            }
       
        }
        return listingIDS;
    }
    public static Decimal getAMI(Decimal household, Decimal precentOfMedian ) {
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
    private static Map<Decimal,  Map<Decimal,Decimal>> AMIMap { // [household, percent]
         get{
            if (AMIMap!=null) {
                return AMIMap;
            } 
        
            AMIMap = new Map<Decimal,  Map<Decimal,Decimal>> (); //household to percent
            for (AMI__c ami : [select id, amount__c, Num_of_HouseHold__c, Percent_of_Median__c from AMI__c]) {
                 Map<Decimal,Decimal> percentMap = AMIMap.get(ami.Num_of_HouseHold__c);
                 if (percentMap == null) { 
                    percentMap = new Map<Decimal,Decimal>();
                    AMIMap.put(ami.Num_of_HouseHold__c, percentMap);
                 }
                 percentMap.put(ami.Percent_of_Median__c,ami.amount__c);
            }
            return AMIMap;
         }}
     
    private static Map<Decimal,  Map<Decimal,Decimal>>  getAMIMap(){
        if (AMIMap!=null) {
            return AMIMap;
        }
        
        AMIMap = new Map<Decimal,  Map<Decimal,Decimal>> (); //household to percent
        for (AMI__c ami : [select id, amount__c, Num_of_HouseHold__c, Percent_of_Median__c from AMI__c]) {
             Map<Decimal,Decimal> percentMap = AMIMap.get(ami.Num_of_HouseHold__c);
             if (percentMap == null) { 
                percentMap = new Map<Decimal,Decimal>();
                AMIMap.put(ami.Num_of_HouseHold__c, percentMap);
             }
             percentMap.put(ami.Percent_of_Median__c,ami.amount__c);
        }
        return AMIMap;
    }
    
    
    /*
    global static List<Unit__c> getByListingID(String listingID)
    { 
       
        return [SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Rental_Minimum_Monthly_Income_Needed__c, Unit_Square_Footage__c,  Unit_Number__c, Unit_Floor__c, Other_Accessibility_Information__c,Number_of_Bathrooms__c FROM Unit__c where Listing__c = :listingID  ORDER BY Unit_Type__c ];
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
    public static List<Listing__c> getMatches(Criteria crit )
    {
     
        system.debug ('crit' + crit);
        Set<ID> ids = findMatching(crit);
        List<Listing__c> listings = getAllActive();
        for (Listing__c listing: listings ){
            listing.Does_Match__c = (ids.contains(listing.id))? true:false;
        }
  //        List< Listing__c> listings = [Select Property_Name__c, Property_Street_Address__c, Property_City__c, Property_State__c, Property_Zip_Code__c, Developer__c, Application_Due_Date__c, Property_URL__c, (SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Minimum_Annual_Income_Needed__c FROM Units__r), Application_Phone__c from Listing__c where Status__c = 'Active' and id in :ids ];
    
        return listings;
    } 
     
   
    private static Set<ID> findMatching(Criteria crit ) {
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
    public static Decimal getAMI(Decimal household, Decimal precentOfMedian ) {
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
    }*/
  /*  -------*/
     
    
    
    
    global static List<Unit__c> getUnitsByListingID(String listingID)
    { 
       String query =  UNIT_BY_LISTING_QUERY;
       return (List<Unit__c>) Database.query(query);
    //    return [SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Rental_Minimum_Monthly_Income_Needed__c, Unit_Square_Footage__c,  Unit_Number__c, Unit_Floor__c, Other_Accessibility_Information__c,Number_of_Bathrooms__c FROM Unit__c where Listing__c = :listingID  ORDER BY Unit_Type__c ];
    } 
    
    
    
    global Class criteria {
       public Integer householdSize;
       public Decimal incomelevel;
       public Integer childrenUnder6;
        //ages of children ;
        //prego
       public string preferenceName;
    } 
    
     global class ListingDetail{
        ID listingID;
        List<UnitSummary> unitSummary;
        boolean doesMatch;
        Listing__c listing;
        public ListingDetail () {
        
            
        } 
        
    }
    
      global class UnitSummary{
        ID listingID;
        String unitType;
        Decimal totalUnits;
        Decimal minOccupancy;
        Decimal maxOccupancy;
        Decimal minSquareFt;
        Decimal maxSquareFt;
        
        Decimal minMonthlyRent;
        Decimal maxMonthlyRent;
        Decimal maxRentalMinIncome;
        Decimal minRentalMinIncome;
       
    
      
        public UnitSummary (AggregateResult result) {
            listingID = (ID)result.get('Listing__c');
            unitType = (String)result.get('Unit_Type__c');
            totalUnits = (Decimal)result.get('Total');
            minOccupancy = (Decimal)result.get('Min_Occupancy');
            maxOccupancy = (Decimal)result.get('Max_Occupancy');
            minSquareFt = (Decimal)result.get('Sq_Footage_Min');
            maxSquareFt = (Decimal)result.get('Sq_Footage_Max');
            
            minMonthlyRent = (Decimal)result.get('minMonthlyRent');
            maxMonthlyRent = (Decimal)result.get('maxMonthlyRent');
            maxRentalMinIncome = (Decimal)result.get('maxRentalMinIncome');
            minRentalMinIncome = (Decimal)result.get('minRentalMinIncome');

            
        } 
        
    }
  //  static String aggregate = 'SELECT Listing__c, Unit_Type__c,count(id)Total, MIN(Min_Occupancy__c)Min_Occupancy, Max(Maximum_Household_Size__c)Max_Occupancy, MIN(Unit_Square_Footage__c)Sq_Footage_Min, MAX(Unit_Square_Footage__c)Sq_Footage_Max  FROM UNIT__C GROUP BY listing__C, Unit_Type__c ';
  
    private static Map<ID,List<UnitSummary>>  processUnitSummaryResults(AggregateResult[] results) {
        Map<ID,List<UnitSummary>> resultMap = new Map<ID,List<UnitSummary>>();
        for (AggregateResult result : results ) {
            UnitSummary unitSummary = new UnitSummary(result);
            List<UnitSummary> summaryList =  (resultMap.containsKey(unitSummary.listingID))?resultMap.get(unitSummary.listingID) : new List<UnitSummary>();
            summaryList.add(unitSummary);
            system.debug (unitSummary);
            resultMap.put(unitSummary.listingID,summaryList);
        }
        return resultMap;
        
    }
     
     
    global static List<UnitSummary> getUnitSummaryByListingID(ID listingID) {
    	Map<ID,List<UnitSummary>> unitSummary =  queryListingDetailByIDs(new Set<ID> {listingID});
    	return unitSummary.get(listingID);
    }
    global static Map<ID,List<UnitSummary>>  getListingDetailAll()
    { 
    //  AggregateResult[] results=  [SELECT Listing__c, Unit_Type__c,count(id)Total, MIN(Min_Occupancy__c)Min_Occupancy, Max(Maximum_Household_Size__c)Max_Occupancy, MIN(Unit_Square_Footage__c)Sq_Footage_Min, MAX(Unit_Square_Footage__c)Sq_Footage_Max  FROM UNIT__C GROUP BY listing__C, Unit_Type__c ];
        AggregateResult[] results =Database.query(UNIT_QUERY_ALL);
        Map<ID,List<UnitSummary>>  unitSummary = processUnitSummaryResults (results);
        
        return unitSummary;
    } 
  
  
   global static Map<ID,List<UnitSummary>>  queryListingDetailByIDs(Set<ID> ids)
    { 
        //AggregateResult[] results=  [SELECT Listing__c, Unit_Type__c,count(id)Total, MIN(Min_Occupancy__c)Min_Occupancy, Max(Maximum_Household_Size__c)Max_Occupancy, MIN(Unit_Square_Footage__c)Sq_Footage_Min, MAX(Unit_Square_Footage__c)Sq_Footage_Max  FROM UNIT__C GROUP BY listing__C, Unit_Type__c ];
        String query = UNIT_QUERY  + ' where Listing__c in : ids ' + UNIT_QUERY_GROUP;
        AggregateResult[] results =Database.query(query);
        system.debug(query);
        Map<ID,List<UnitSummary>>  unitSummary = processUnitSummaryResults (results);
        
        return unitSummary; 
    } 
    
    
    global static List<ListingDetail> getListingDetails(List<Listing__c> listings)
    { 
    //  system.debug('listingdeails');
        Map<ID,Listing__c> listingMap = new Map<ID,Listing__c> (listings);
        Map<ID,List<UnitSummary>> unitSummary = queryListingDetailByIDs(listingMap.keyset());
        List<ListingDetail> details = new List<ListingDetail> ();
    //  system.debug (listingMap);
    //          system.debug (unitSummary);
        
        for (ID listingID:listingMap.keyset()) { 
            ListingDetail detail = new ListingDetail();
            detail.listingID = listingID;
            detail.listing = listingMap.get(listingID);
            detail.unitSummary = unitSummary.get(listingID);
            details.add(detail);
        }
        return details; 
        
    } 
    
    
}