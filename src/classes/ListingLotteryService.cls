global class ListingLotteryService {
    
    
     private static final String LOTTERY_PREFERENCE_QUERY = 'SELECT Id, Name, Description__c FROM Lottery_Preference__c ';
     private static final String LOTTERY_MEMBER_QUERY = 'SELECT Lottery_Number__c, Rank__c, Listing__c, Status__c FROM Lottery_Member__c where Status__c = \'Winner\'';  
     
    
    
    //*************************************
    // Lottery Preference
    //*************************************
    
    global static List<Lottery_Preference__c> getLotteryPreferenceByID(Id lpid){
    	List<Lottery_Preference__c> lps = new List<Lottery_Preference__c>();
    	string lquery = ListingLotteryService.LOTTERY_PREFERENCE_QUERY + ' WHERE Id = \'' + lpid + '\'';
    	try{
    		lps = database.query(lquery);
    	} catch (Exception e){
    		
    	}
    	return lps;
    }
    
    global static List<Lottery_Preference__c> getLotteryPreferenceByIDs(List<string> lpids){
    	List<Lottery_Preference__c> lps = new List<Lottery_Preference__c>();
    	string lquery = ListingLotteryService.LOTTERY_PREFERENCE_QUERY + ' WHERE Id in: lpids';
    	try{
    		lps = database.query(lquery);
    	} catch (Exception e){
    		
    	} 
    	return lps;
    }
    
    global static List<Lottery_Preference__c> getAllLotteryPreference(){
    	List<Lottery_Preference__c> lps = new List<Lottery_Preference__c>();
    	string lquery = ListingLotteryService.LOTTERY_PREFERENCE_QUERY;
    	try{
    		lps = database.query(lquery);
    	} catch (Exception e){
    		
    	}
    	
    	return lps;
    }
    
    //*************************************
    // Lottery Member
    //*************************************
    
    global static List<Lottery_Member__c> getLotteryMembersByListingID(Id lpid){
    	List<Lottery_Member__c> lms = new List<Lottery_Member__c>();
    	string lquery = ListingLotteryService.LOTTERY_MEMBER_QUERY + ' AND Listing__c = \'' + lpid + '\'';
    	try{
    		lms = database.query(lquery);
    	} catch (Exception e){
    		
    	}
    	return lms;
    }
    
    global static List<Lottery_Member__c> getLotteryMembersByListingIDs(List<string> lpids){
    	List<Lottery_Member__c> lms = new List<Lottery_Member__c>();
    	string lquery = ListingLotteryService.LOTTERY_MEMBER_QUERY + ' AND Listing__c in: lpids ';
    	try{
    		lms = database.query(lquery);
    	} catch (Exception e){
    		
    	}
    	return lms;
    }
    
    
}