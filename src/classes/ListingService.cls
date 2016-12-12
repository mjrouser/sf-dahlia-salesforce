// *****************************************************************************
// CLASS: ListingService
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: class that stores all logic for APIs service calls - classes starting with "Listing"
// *

global  class ListingService {
	
	private static final String LOTTERY_QUERY = 'SELECT Lottery_Number__c, Rank__c FROM Lottery_Members__c where Status__c = \'Winner\'';
	private static final String APPLICATION_QUERY = 'SELECT id, Lottery_Number__c, Live_Work_Preference_Rank__c, Lottery_Rank__c, Lottery_Status__c, General_Lottery__c, General_Lottery_Rank__c, Live_Work_Preference__c, Live_in_SF_Preference_Member__c, Work_in_SF_Preference_Member__c, DTHP_Preference__c, DTHP_Preference_Member__c, DTHP_Preference_Rank__c, COP_Preference__c, COP_Preference_Member__c, COP_Preference_Rank__c, Neighborhood_Preference__c, Neighborhood_Preference_Member__c, Neighborhood_Preference_Rank__c FROM Application__c';
	private static final String LISTING_QUERY ='SELECT Name, Office_Hours__c, Lottery_Status__c, Building_Name__c, Project_ID__c, Building_Street_Address__c, Building_City__c, Building_State__c, Building_Zip_Code__c, Developer__c, Description__c, Neighborhood__c, Year_Built__c, LastModifiedDate, Application_Due_Date__c, Building_URL__c, Legal_Disclaimers__c, Application_Organization__c, Application_Street_Address__c, Application_City__c, Application_State__c, Application_Postal_Code__c, Application_Phone__c, Lottery_Summary__c, Lottery_Results_Date__c, Lottery_End__c, Lottery_Start_Time__c, Lottery_End_Time__c, Lottery_Venue__c, Lottery_Street_Address__c, Lottery_City__c, Lottery_Date__c, Lottery_Preferences__c, Lottery_Results__c, Lottery_URL__c, LotteryResultsURL__c, Accepting_Online_Applications__c, COP_App_Total__c, COPUnitsAvailable__c, DTHP_App_Total__c, DTHPUnitsAvailable__c, Live_Work_App_Total__c, LiveWorkUnitsAvailable__c, Neighborhood_App_Total__c, NeighborhoodUnitsAvailable__c, General_App_Total__c, Lottery_Winners__c, AMI_Percentage__c,  Preference_Detail__c, Credit_Rating__c, Criminal_History__c, Eviction_History__c,  Leasing_Agent_Name__c, Leasing_Agent_Title__c, Leasing_Agent_Email__c, Leasing_Agent_Phone__c, Leasing_Agent_Street__c, Leasing_Agent_City__c, Leasing_Agent_State__c, Leasing_Agent_Zip__c, Office_Open__c, Office_Closed__c,  Organization_URL__c, Download_URL__c, Fee__c, Deposit_Min__c, Deposit_Max__c, Costs_Not_Included__c, Rental_Assistance__c, Amenities__c, Accessibility__c, Building_Selection_Criteria__c, Required_Documents__c,Smoking_Policy__c, Pet_Policy__c, NeighborHoodPreferenceUrl__c, (SELECT Date__c, Start_Time__c, End_Time__c, Venue__c, Street_Address__c, City__c FROM Information_Sessions__r), (SELECT Date__c, Start_Time__c, End_Time__c FROM Open_Houses__r), (SELECT Id, Lottery_Preference__r.Id, Lottery_Preference__r.Name FROM Listing_Lottery_Preferences__r), (SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Rental_Minimum_Monthly_Income_Needed__c FROM Units__r ORDER BY Unit_Type__c), (SELECT id, Name, Image_URL__c FROM Listing_Images__r) from Listing__c';
	private static final String LISTING_PREFERENCE_QUERY ='SELECT Name, Available_Units__c, Description__c, Listing__c, NRHP_District__c, Order__c, Lottery_Preference__c, Lottery_Preference__r.Name, Preference_Name__c, Read_More_URL__c from Listing_Lottery_Preference__c';
	// 01/25/2016 - 'Select Building_Name__c, Building_Street_Address__c, Building_City__c, Building_State__c, Building_Zip_Code__c, Developer__c, Description__c, Neighborhood__c, Year_Built__c, LastModifiedDate, Application_Due_Date__c, Building_URL__c, Legal_Disclaimers__c, Application_Organization__c, Application_Street_Address__c, Application_City__c, Application_State__c, Application_Postal_Code__c, Application_Phone__c, Lottery_Summary__c, Lottery_Results_Date__c, Lottery_End__c, Lottery_Start_Time__c, Lottery_End_Time__c, Lottery_Venue__c, Lottery_Street_Address__c, Lottery_City__c, Lottery_Date__c, AMI_Percentage__c,  Preference_Detail__c, Credit_Rating__c, Criminal_History__c, Eviction_History__c,  Leasing_Agent_Name__c, Leasing_Agent_Title__c, Leasing_Agent_Email__c, Leasing_Agent_Phone__c, Lottery_Results__c, Lottery_Winners__c, Office_Open__c, Office_Closed__c,  Organization_URL__c, Download_URL__c, Fee__c, Deposit_Min__c, Deposit_Max__c, Costs_Not_Included__c, Lottery_Preferences__c, Rental_Assistance__c, Amenities__c, Accessibility__c, Building_Selection_Criteria__c, Required_Documents__c,Smoking_Policy__c, Pet_Policy__c,(SELECT Date__c, Start_Time__c, End_Time__c, Venue__c, Street_Address__c, City__c FROM Information_Sessions__r), (SELECT Date__c, Start_Time__c, End_Time__c FROM Open_Houses__r),(SELECT Lottery_Number__c, Rank__c FROM Lottery_Members__r where Status__c = \'Winner\'),(SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Rental_Minimum_Monthly_Income_Needed__c, Unit_Square_Footage__c,  Unit_Number__c, Unit_Floor__c, Other_Accessibility_Information__c,Number_of_Bathrooms__c FROM Units__r ORDER BY Unit_Type__c),  (SELECT Id, Lottery_Preference__r.Id, Lottery_Preference__r.Name FROM Listing_Lottery_Preferences__r) from Listing__c';
	// 02/19/2016 - 'Select Building_Name__c, Building_Street_Address__c, Building_City__c, Building_State__c, Building_Zip_Code__c, Developer__c, Application_Due_Date__c, Building_URL__c, Legal_Disclaimers__c, (SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Rental_Minimum_Monthly_Income_Needed__c FROM Units__r ORDER BY Unit_Type__c), Application_Phone__c, Lottery_Summary__c, Lottery_Results_Date__c, Lottery_Date__c, AMI_Percentage__c,  Preference_Detail__c, Credit_Rating__c, Criminal_History__c, Eviction_History__c,  Leasing_Agent_Name__c, Leasing_Agent_Title__c, Leasing_Agent_Email__c, Leasing_Agent_Phone__c, Lottery_Results__c, Lottery_Winners__c, (SELECT Id, Lottery_Preference__r.Id, Lottery_Preference__r.Name FROM Listing_Lottery_Preferences__r) from Listing__c';
	private static final String LISTING_QUERY_ORDER = ' ORDER BY Unit_Type__c';
	
	
	//private static final String LISTING_PREFERENCE_QUERY = 'SELECT Id, NAME, Listing__c, Lottery_Preference__c FROM Listing_Lottery_Preference__c ';
	//private static final String LOTTERY_PREFERENCE_QUERY = 'SELECT Id, Name, Description__c FROM Lottery_Preference__c ';
  	
  	
  	private static final String UNIT_BY_LISTING_QUERY = 'SELECT Unit_Type__c, BMR_Rent_Monthly__c, BMR_Rental_Minimum_Monthly_Income_Needed__c, Unit_Square_Footage__c,  Unit_Number__c, Unit_Floor__c, Other_Accessibility_Information__c,Number_of_Bathrooms__c FROM Unit__c where Listing__c = :listingID  ORDER BY Unit_Type__c ';
	
	
	private static final String LIVE_WORK_PREFERENCE = 'liveWorkPreference';
	private static final String COP_PREFERENCE = 'certOfPreference';
	private static final String DTHP_PREFERENCE = 'displacedPreference';
	private static final String NEIGHBORHOOD_PREFERENCE = 'neighborhoodPreference';
	private static final String GENERAL_PREFERENCE = 'generalLottery';
	private static final Map<String, String> APP_FIELD_TO_PREFERENCE_NAME_MAP = new Map<String,String> {
																			'Live_Work_Preference__c' => LIVE_WORK_PREFERENCE,
																			'COP_Preference__c' => COP_PREFERENCE,
																			'DTHP_Preference__c' => DTHP_PREFERENCE,
																			'Neighborhood_Preference__c' => NEIGHBORHOOD_PREFERENCE,
																			'General_Lottery__c' => GENERAL_PREFERENCE
																		};
	private static final Map<String, String> APP_FIELD_TO_APP_FIELD_RANK_MAP = new Map<String,String> {
																			'Live_Work_Preference__c' => 'Live_Work_Preference_Rank__c',
																			'COP_Preference__c' => 'COP_Preference_Rank__c',
																			'DTHP_Preference__c' =>'DTHP_Preference_Rank__c',
																			'Neighborhood_Preference__c' => 'Neighborhood_Preference_Rank__c',
																			'General_Lottery__c' => 'General_Lottery_Rank__c'
																		};
				
	static String UNIT_QUERY = 'SELECT Listing__c, Unit_Type__c,count(id)Total, MIN(BMR_Rental_Minimum_Monthly_Income_Needed__c) minRentalMinIncome,  MAX(BMR_Rental_Minimum_Monthly_Income_Needed__c) maxRentalMinIncome, MIN(BMR_Rent_Monthly__c) minMonthlyRent ,   MAX(BMR_Rent_Monthly__c) maxMonthlyRent , MIN(Min_Occupancy__c)Min_Occupancy, Max(Maximum_Household_Size__c)Max_Occupancy, MIN(Unit_Square_Footage__c)Sq_Footage_Min, MAX(Unit_Square_Footage__c)Sq_Footage_Max  FROM UNIT__C ';
	
	static string UNIT_QUERY_GROUP =  ' GROUP BY listing__c, Unit_Type__c ';
	static string UNIT_QUERY_ALL =UNIT_QUERY + UNIT_QUERY_GROUP;
	
	
	global class Eligibility {
		public Id listingId;
		public String householdEligibilityResult;
		public String incomeEligibilityResult;
		public boolean householdMatch;
		public boolean incomeMatch;
		
		public Eligibility() {}
	}
	
	global class criteria {
		public Integer householdSize;
		public Decimal incomelevel;
		public Integer childrenUnder6;
		public string preferenceName;
	} 
	
	global class ListingDetail implements Comparable {
		public ID listingID;
		public List<UnitSummary> unitSummary;
		public boolean doesMatch;
		public Listing__c listing;
		
		public ListingDetail () {}
		
		public Integer compareTo(Object compareTo) {
			ListingDetail listDetail = (ListingDetail) compareTo;
			
			if(this.listing.Application_Due_Date__c == null) {
				return 1;
			}
			if(this.listing.Application_Due_Date__c > listDetail.listing.Application_Due_Date__c) {
				return -1;
			}
			if(this.listing.Application_Due_Date__c < listDetail.listing.Application_Due_Date__c) {
				return 1;
			}
			return 0;
		}
		
	}
	
	global class ListingResult {
		public Id listingId;
		public List<PreferenceBucket> bucketResults;
		public List<ApplicationResult> applicationResults;
		public String URL;
		public String lotteryResultsURL;
		public Decimal liveWorkPreferenceAppTotal;
		public Decimal liveWorkPreferenceUnitsAvailable;
		public Decimal certOfPreferenceAppTotal;
		public Decimal certOfPreferenceUnitsAvailable;
		public Decimal displacedPreferenceAppTotal;
		public Decimal displacedPreferenceUnitsAvailable;
		public Decimal neighborhoodPreferenceAppTotal;
		public Decimal neighborhoodPreferenceUnitsAvailable;
		public Decimal generalLotteryAppTotal;
		public String lotteryCity;
		public Datetime lotteryDate;
		public String lotteryEndTime;
		public String lotteryPreferences;
		public boolean lotteryResults;
		public String officeHours;
		
		public ListingResult() {}
	}
	
	global class ApplicationResult {
		public Id applicationId;
		public boolean liveWorkPreference;
		public decimal liveWorkPreferenceRank;
		
		public boolean displacedPreference;
		public decimal displacedPreferenceRank;
		
		public boolean certOfPreference;
		public decimal certOfPreferenceRank;
		
		public boolean neighborhoodPreference;
		public decimal neighborhoodPreferenceRank;
		
		public decimal generalLotteryRank;
		
		public String lotteryNumber;
		public decimal lotteryRank;
		
		public ApplicationResult() {}
	}
	
	global class PreferenceBucket {
		public String preferenceName;
		public List<BucketResult> bucketResults;
	}
	
	global class BucketResult implements comparable {
		public String applicationID;
		public string lotteryNumber;
		public Decimal preferenceRank;
		public Decimal lotteryRank;
		
		public Integer compareTo(Object compareTo) {
			BucketResult br = (BucketResult) compareTo;
			
			if(this.preferenceRank == null) {
				return 1;
			}
			if(this.preferenceRank < br.preferenceRank) {
				return -1;
			}
			if(this.preferenceRank > br.preferenceRank) {
				return 1;
			}
			return 0;
		}
	}
	
	global class ListingPreference {
		public String listingPreferenceID;
		public String listingId;
		public String name;
		public String preferenceName;
		public Decimal order;
		public String description;
		public String readMoreUrl;
		public String NRHPDistrict;
		public Decimal appTotal;
		public Decimal unitsAvailable;
	}
	
	global class UnitSummary{
		public ID listingID;
		public String unitType;
		public Decimal totalUnits;
		public Decimal minOccupancy;
		public Decimal maxOccupancy;
		public Decimal minSquareFt;
		public Decimal maxSquareFt;
		
		public Decimal minMonthlyRent;
		public Decimal maxMonthlyRent;
		public Decimal maxRentalMinIncome;
		public Decimal minRentalMinIncome;
	
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
	
	global class AMI {
		public Decimal percent;
		public Decimal numOfHousehold;
		public Decimal amount;
	
		global AMI() {
			
		}
		global AMI(AMI__c ami) {
			percent = ami.Percent_of_Median__c;
			numOfHousehold = ami.Num_of_HouseHold__c;
			amount = ami.Amount__c;
		}
		
		public String getFilterString() {
			String filter = '';
			if  (percent > 0)  {
				filter = ' Percent_of_Median__c=' + String.valueof(percent);
			}
			if  (numOfHousehold>0)  {
				filter += (filter.length() > 0 ) ? ' and ' : ''; 
				
				filter += ' Num_of_HouseHold__c=' + String.valueof(numOfHousehold);
			}
			if (amount > 0) {
				filter += (filter.length() > 0) ? ' and ' : '';
				filter += ' Amount__c>=' + String.valueof(amount) + ' order by Amount__c asc limit 1';
			} 
			return filter;
		}
		public String getCalcFilter() {
			String filter = '';
			if (percent > 0) {
				filter=  ' Percent_of_Median__c=100';
			}
			if (numOfHousehold > 0) {
				filter += (filter.length() > 0 ) ? ' and ' : '';
				filter += ' Num_of_HouseHold__c=' + String.valueof(numOfHousehold);
			}
			
			return filter;
		}
	}
	
	global class UnitStat{
        ID listingID;
        String unitType;
        Decimal totalUnits;
        Decimal minOccupancy;
        Decimal maxOccupancy;
        Decimal minSquareFt;
        Decimal maxSquareFt;
        public UnitStat (AggregateResult result) {
            listingID = (ID)result.get('Listing__c');
            unitType = (String)result.get('Unit_Type__c');
            totalUnits = (Decimal)result.get('Total');
            minOccupancy = (Decimal)result.get('Min_Occupancy');
            maxOccupancy = (Decimal)result.get('Max_Occupancy');
            minSquareFt = (Decimal)result.get('Sq_Footage_Min');
            maxSquareFt = (Decimal)result.get('Sq_Footage_Max');
        }
        
    }
	
	global static List<ListingPreference>  getListingPreferenceByListingID(String listingID)
	{ 
		ID theID = ID.valueof(listingID);
		String query = LISTING_PREFERENCE_QUERY;
		String queryFilter='';
		if (theID != null) {
			queryFilter += ' Listing__c = \'' + theID + '\' order by Order__c asc nulls last';
		}
		query += (queryFilter.length() > 0) ? ' where ' + queryFilter: '';
		List<Listing_Lottery_Preference__c> listingPreferenceList = (List<Listing_Lottery_Preference__c>) Database.Query(query);
		
		List<ListingPreference> listingPreferences = new List<ListingPreference>();
		ListingPreference listingPref;
		for (Listing_Lottery_Preference__c listPref : listingPreferenceList) {
			listingPref = new ListingPreference();
			listingPref.listingPreferenceID = listPref.Id;
			listingPref.listingId = listPref.Listing__c;
			listingPref.name = listPref.Name;
			listingPref.order = listPref.Order__c;
			listingPref.description = listPref.Description__c;
			listingPref.readMoreUrl = listPref.Read_More_URL__c;
			listingPref.NRHPDistrict = listPref.NRHP_District__c;
			//listingPref.appTotal = listPref.Id;
			listingPref.unitsAvailable = listPref.Available_Units__c;
			listingPref.preferenceName = listPref.Lottery_Preference__r.Name;
			listingPreferences.add(listingPref);
		}
		return listingPreferences;
	}
	
	global static List<Listing__c>  getListingByID(String listingID)
	{ 
		system.debug('listingID:::' + listingID);
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
	
	global static List<Listing__c> getListingByFilter(Set<ID> listingIDs,String filter)
	{ 
		String query = LISTING_QUERY;
		String queryFilter='';
		if (listingIds!=null && listingIDs.size()>0) {
			queryFilter+= ' id in :listingIDs';
		}
		if (filter!=null) {
			if (queryFilter.length()>0) {
				queryFilter+=' and ';
			} 
			queryFilter += filter; 
		}
		query += (queryFilter.length()>0)? ' where ' + queryFilter: '';
		//system.debug('query:::' + query) ;
		List<Listing__c> listings = (List<Listing__c>) Database.Query(query);
		return listings;
	} 
	/* old style preferences LL 
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
	*/
	global static List<Listing__c>  getAllActiveListings()
	{
		return getListingByFilter(new Set<ID>(), ' Status__c = \'Active\'');
 
	} 
	
	public static List<ListingDetail> getListingDetailByCriteria(Criteria crit)
	{
		Set<ID> ids = findMatching(crit);
		List<Listing__c> listings = getAllActiveListings();
		Map<Id,Listing__c> listingMap = new Map<Id,Listing__c>();
		
		for (Listing__c listing: listings){ // can and probably should move this to listing detail
			listingMap.put(listing.Id,listing);
			listing.Does_Match__c = (ids.contains(listing.id))? true:false;
			if(crit.PreferenceName != null && crit.PreferenceName != '' && listing.Does_Match__c){
				boolean prefFound = false;
				for(Listing_Lottery_Preference__c llp : listing.Listing_Lottery_Preferences__r){
					if(llp.Lottery_Preference__r.Name == crit.PreferenceName){
						prefFound = true;
						break;
					}
				}
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
				detail.doesMatch = prefFound;
			}
		}
		listingDetails.sort();
		return listingDetails;
	
	}
	
	global static  List<ListingDetail> getListingDetailByID (String listingID ) {
		List<ListingDetail> listingDetailList = getListingDetailByIDs(new List<String> {listingID} );
		listingDetailList.sort();
		return listingDetailList;
	}
	
	global static  List<ListingDetail> getListingDetailByIDs (List<String> sIDs ) {
		return getListingDetails(getListingByIDs(sIDs));
	}
	
	global static  List<ListingDetail> getAllActiveListingDetails ( ) {
		return getListingDetails(getAllActiveListings());
	}
	
	public static List<Listing__c> getListingByCriteria(Criteria crit )
	{
	 
		Set<ID> ids = findMatching(crit);
		List<Listing__c> listings = new List<Listing__c>();
		List<Listing__c> matchedListings = new List<Listing__c>();
		
		listings = getAllActiveListings();
		
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
		Integer houseHoldSize = crit.householdSize;
		Decimal Income = crit.incomelevel;
		List<Unit__c> relevantUnits = new List<Unit__c>();
		Set<ID> listingIDS = new Set<ID>();
		Integer maxHouseHold = houseHoldSize-crit.childrenUnder6;
		Integer minHouseHold = houseHoldSize;
		
		for (Unit__c unit : [select id, BMR_Minimum_Annual_Income_Needed__c, of_AMI_for_Pricing_Unit__c, Listing__c, Maximum_Household_Size__c  from Unit__c  where Maximum_Household_Size__c>= :maxHouseHold and Min_Occupancy__c<=:minHouseHold]) {
			Decimal amiAmount =  getAMI(houseHoldSize, unit.of_AMI_for_Pricing_Unit__c );
			if ((unit.BMR_Minimum_Annual_Income_Needed__c  < Income) && (Income < amiAmount )) {
				relevantUnits.add(unit);
				listingIDS.add(unit.Listing__c);
			}
		}
		return listingIDS;
	}
	
	//check if the Listing is matching passed criteria
	public static Eligibility checkEligibility(Criteria crit, Id ListingId) {
		Integer houseHoldSize = crit.householdSize;
		Decimal Income = crit.incomelevel;
		List<Unit__c> relevantUnits = new List<Unit__c>();
		Set<ID> listingIDS = new Set<ID>();
		Integer maxHouseHold = houseHoldSize-crit.childrenUnder6;
		Integer minHouseHold = houseHoldSize;
		Eligibility eg = new Eligibility();
		eg.ListingId = ListingId;
		
		//retrieve all units related to the listing
		List<Unit__c> units = [select id, BMR_Minimum_Annual_Income_Needed__c, of_AMI_for_Pricing_Unit__c, Listing__c, Max_Occupancy__c, Min_Occupancy__c  
								from Unit__c 
								where Listing__c = :ListingId];
		String notHouseholdEligible = '';
		String notIncomeEligible = '';
		
		//go through all units and check if do we have a match
		for (Unit__c unit : units) {
			//check household size
			if (unit.Max_Occupancy__c >= maxHouseHold && unit.Min_Occupancy__c <= minHouseHold) {
				eg.householdEligibilityResult = 'Match';
				eg.householdMatch = true;
			} else if (unit.Max_Occupancy__c < maxHouseHold) {
				notHouseholdEligible = 'Too Big';
			} else if (unit.Min_Occupancy__c > minHouseHold) {
				notHouseholdEligible = 'Too Small';
			}
			
			//check income
			if (Income > 0) {
				Decimal amiAmount =  getAMI(houseHoldSize, unit.of_AMI_for_Pricing_Unit__c );
				system.debug('amiAmount:::' + amiAmount);
				system.debug('Income:::' + Income);
				if (unit.BMR_Minimum_Annual_Income_Needed__c <= Income && Income <= amiAmount) {
					eg.incomeEligibilityResult = 'Match';
					eg.incomeMatch = true;
				} else if (unit.BMR_Minimum_Annual_Income_Needed__c < Income) {
					notIncomeEligible = 'Too High';
				} else {
					notIncomeEligible = 'Too Low';
				}
			}
		}
		
		//if we don't have a match mark this as false
		if (eg.householdEligibilityResult != 'Match') {
			eg.householdEligibilityResult = notHouseholdEligible;
			eg.householdMatch = false;
		}
		
		if (eg.incomeEligibilityResult != 'Match') {
			eg.incomeEligibilityResult = notIncomeEligible;
			eg.incomeMatch = false;
		}
		
		return eg;
	}
	
	public static Decimal getAMI(Decimal household, Decimal precentOfMedian ) {
		if (household== null || precentOfMedian == null) {
			return -1;
		}
		Map<Decimal, Decimal> percentMap = AMIMap.get(household);
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
	
	global static List<Unit__c> getUnitsByListingID(String listingID)
	{
		String query =  UNIT_BY_LISTING_QUERY;
		return (List<Unit__c>) Database.query(query);
	} 
	
	global static ListingResult getListingResultsByListingID(String listingID)
	{
		return getListingResults(listingID, null, false);
	}
	
	global static ListingResult getListingResultsByListingIDAndLotteryNumber(String listingID, String lotteryNumber)
	{
		return getListingResults(listingID, lotteryNumber, false);
	}
	
	global static ListingResult getListingResults(String listingID, String lotteryNumber, Boolean isBucket)
	{ 
		List<Listing__c> currentListing = getListingByID(listingID);
		
		ListingResult listingResult = new ListingResult();
		if (currentListing != null && currentListing.size() == 1) {
			
			//retrieve all application related to listing
			string appQuery = APPLICATION_QUERY + ' WHERE Listing__c = \'' + currentListing[0].Id + '\'';
			if (lotteryNumber != null) {
				appQuery += ' AND Lottery_Number__c = \'' + lotteryNumber + '\'';
			}
			system.debug('appQuery:::' + appQuery);
			List<Application__c> appResultList = database.query(appQuery);
			
			system.debug('appResultList:::' + appResultList);
			//get listing results on each bucket
			if (isBucket) {
				Map<String,List<BucketResult>> bucketResultMap = new Map<String,List<BucketResult>>();
				//intialize bucketResultMap with all preferences
				for (String fieldAPI : APP_FIELD_TO_PREFERENCE_NAME_MAP.keySet()) {
					if (!bucketResultMap.containsKey(APP_FIELD_TO_PREFERENCE_NAME_MAP.get(fieldAPI))) {
						bucketResultMap.put(APP_FIELD_TO_PREFERENCE_NAME_MAP.get(fieldAPI), new List<BucketResult>());
					}
				}
				
				BucketResult bucketRes;
				for (Application__c app : appResultList) {
					
					//return only opplication with Lottery Rank filled in
					if (app.Lottery_Rank__c == null) continue;
					
					for (String fieldAPI : APP_FIELD_TO_PREFERENCE_NAME_MAP.keySet()) {
						//if preference it is checked then add it to the bucket
						if ((Boolean)app.get(fieldAPI)) {
							bucketRes = new BucketResult();
							bucketRes.applicationID = app.Id;
							bucketRes.lotteryNumber = app.Lottery_Number__c;
							bucketRes.preferenceRank = (Decimal)app.get(APP_FIELD_TO_APP_FIELD_RANK_MAP.get(fieldAPI));
							bucketRes.lotteryRank = (Decimal)app.Lottery_Rank__c;
							bucketResultMap.get(APP_FIELD_TO_PREFERENCE_NAME_MAP.get(fieldAPI)).add(bucketRes);
						}
					}
				}
				
				List<PreferenceBucket> prefBucketList = new List<PreferenceBucket>();
				PreferenceBucket prefBucket;
				for (String preferenceNameKey : bucketResultMap.keySet()) {
					prefBucket = new PreferenceBucket();
					prefBucket.preferenceName = preferenceNameKey;
					List<BucketResult> bucketResList = bucketResultMap.get(preferenceNameKey);
					bucketResList.sort();
					prefBucket.bucketResults = bucketResList;
					prefBucketList.add(prefBucket);
				}
				listingResult.bucketResults = prefBucketList;
			
			//get listing results on each application
			} else {
				List<ApplicationResult> appList = new List<ApplicationResult>();
				ApplicationResult appRes;
				for (Application__c app : appResultList) {
					
					if (app.Lottery_Rank__c == null) continue;
					
					appRes = new ApplicationResult();
					appRes.applicationId = app.Id;
					appRes.lotteryNumber = app.Lottery_Number__c;
					appRes.lotteryRank = app.Lottery_Rank__c;
					
					appRes.liveWorkPreference = app.Live_Work_Preference__c;
					appRes.liveWorkPreferenceRank = app.Live_Work_Preference_Rank__c;
					
					appRes.displacedPreference = app.DTHP_Preference__c;
					appRes.displacedPreferenceRank = app.DTHP_Preference_Rank__c;
					
					appRes.certOfPreference = app.COP_Preference__c;
					appRes.certOfPreferenceRank = app.COP_Preference_Rank__c;
					
					appRes.neighborhoodPreference = app.Neighborhood_Preference__c;
					appRes.neighborhoodPreferenceRank = app.Neighborhood_Preference_Rank__c;
					
					appRes.generalLotteryRank = app.General_Lottery_Rank__c;
					
					appList.add(appRes);
				}
				
				listingResult.applicationResults = appList;
			}
			
			listingResult.listingId = currentListing[0].Id;
			listingResult.URL = currentListing[0].Lottery_URL__c;
			listingResult.lotteryResultsURL = currentListing[0].LotteryResultsURL__c;
			listingResult.liveWorkPreferenceAppTotal = currentListing[0].Live_Work_App_Total__c;
			listingResult.liveWorkPreferenceUnitsAvailable = currentListing[0].LiveWorkUnitsAvailable__c;
			listingResult.certOfPreferenceAppTotal = currentListing[0].COP_App_Total__c;
			listingResult.certOfPreferenceUnitsAvailable = currentListing[0].COPUnitsAvailable__c;
			listingResult.displacedPreferenceAppTotal = currentListing[0].DTHP_App_Total__c;
			listingResult.displacedPreferenceUnitsAvailable = currentListing[0].DTHPUnitsAvailable__c;
			listingResult.neighborhoodPreferenceAppTotal = currentListing[0].Neighborhood_App_Total__c ;
			listingResult.neighborhoodPreferenceUnitsAvailable = currentListing[0].NeighborhoodUnitsAvailable__c;
			listingResult.generalLotteryAppTotal = currentListing[0].General_App_Total__c;
			listingResult.lotteryCity = currentListing[0].Lottery_City__c;
			listingResult.lotteryDate = currentListing[0].Lottery_Date__c;
			listingResult.lotteryEndTime = currentListing[0].Lottery_End_Time__c;
			listingResult.lotteryPreferences = currentListing[0].Lottery_Preferences__c;
			listingResult.lotteryResults = currentListing[0].Lottery_Results__c;
			listingResult.officeHours = currentListing[0].Office_Hours__c;
		}
		return listingResult;
	} 
	
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
		AggregateResult[] results =Database.query(UNIT_QUERY_ALL);
		Map<ID,List<UnitSummary>>  unitSummary = processUnitSummaryResults (results);
		
		return unitSummary;
	}
	global static Map<ID,List<UnitSummary>>  queryListingDetailByIDs(Set<ID> ids)
	{
		String query = UNIT_QUERY  + ' where Listing__c in : ids ' + UNIT_QUERY_GROUP;
		AggregateResult[] results =Database.query(query);
		system.debug(query);
		Map<ID,List<UnitSummary>>  unitSummary = processUnitSummaryResults (results);
		
		return unitSummary; 
	}
	
	
	global static List<ListingDetail> getListingDetails(List<Listing__c> listings)
	{
		Map<ID,Listing__c> listingMap = new Map<ID,Listing__c> (listings);
		Map<ID,List<UnitSummary>> unitSummary = queryListingDetailByIDs(listingMap.keyset());
		List<ListingDetail> details = new List<ListingDetail> ();
		
		for (ID listingID:listingMap.keyset()) { 
			ListingDetail detail = new ListingDetail();
			detail.listingID = listingID;
			detail.listing = listingMap.get(listingID);
			detail.unitSummary = unitSummary.get(listingID);
			details.add(detail);
		}
		details.sort();
		return details; 
	}
	
	global static List<AMI> Calc(AMI filter)
    {
    	String filterString = filter.getCalcFilter();
    	
        String query = 'select id, amount__c, Num_of_HouseHold__c, Percent_of_Median__c from AMI__c ' ;
		if (filterstring.length() > 0 ) {
			query += ' where ' + filterString;
		}
		AMI returnAMI = new AMI();
		AMI__c ami = Database.query(query);
		
		returnAMI.percent = Math.round(filter.amount / ami.amount__c*100);
		returnAMI.numOfHousehold=filter.numOfHousehold; 
		returnAMI.amount=filter.amount;
		List<AMI> amiList = new List<AMI> {returnAMI};
		
      	return amiList;
    } 
    
    global static List<AMI> getByFilter(AMI filter)
    {
    	String filterString = filter.getFilterString();
    	
        String query = 'select id, amount__c, Num_of_HouseHold__c, Percent_of_Median__c from AMI__c ' ;
		if (filterstring.length() > 0 ) {
			query += ' where ' + filterString;
		}
		system.debug('query::' + query);
		List<AMI__c> amis = Database.query(query);
		List<AMI> amiList = new List<AMI> ();
		for (AMI__c ami : amis) {
			amiList.add(new AMI(ami));
		}
		system.debug('query::' + query);
		return amiList;
	}
	
	    
    global static List<UnitStat> getUnitByListingId(string listingID){
    	AggregateResult[] results=  [SELECT Listing__c, Unit_Type__c,count(id)Total, MIN(Min_Occupancy__c)Min_Occupancy, Max(Maximum_Household_Size__c)Max_Occupancy, MIN(Unit_Square_Footage__c)Sq_Footage_Min, MAX(Unit_Square_Footage__c)Sq_Footage_Max  FROM UNIT__C WHERE Listing__c =: listingID GROUP BY listing__C, Unit_Type__c ];
        List<UnitStat> stats = new List<UnitStat>();
        for (AggregateResult result : results ) {
            stats.add(new UnitStat(result));
        }
        return stats;
    }
    
    global static List<UnitStat> getAll(String listingID)
    { 
        AggregateResult[] results=  [SELECT Listing__c, Unit_Type__c,count(id)Total, MIN(Min_Occupancy__c)Min_Occupancy, Max(Maximum_Household_Size__c)Max_Occupancy, MIN(Unit_Square_Footage__c)Sq_Footage_Min, MAX(Unit_Square_Footage__c)Sq_Footage_Max  FROM UNIT__C GROUP BY listing__C, Unit_Type__c ];
        List<UnitStat> stats = new List<UnitStat>();
        for (AggregateResult result : results ) {
            stats.add(new UnitStat(result));
        }
        return stats;
    } 
	
}