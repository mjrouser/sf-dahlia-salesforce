// *****************************************************************************
// CLASS: ListingLotteryService
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/08/16
// Description: class that stores all logic for APIs service calls - classes starting with "ListingLottery"
// *

global class ListingLotteryService {
    
    
     private static final String LOTTERY_PREFERENCE_QUERY = 'SELECT Id, Name, Description__c FROM Lottery_Preference__c ';
     private static final String LOTTERY_MEMBER_QUERY = 'SELECT Lottery_Number__c, Rank__c, Listing__c, Status__c FROM Lottery_Member__c where Status__c = \'Winner\'';  
     
    
    
    //*************************************
    // Lottery Preference
    //*************************************
     
    /*
    original preference design - 
    
    global static List<Lottery_Preference__c> getLotteryPreferenceByID(Id lotteryPrefId){
    	List<Lottery_Preference__c> lps = new List<Lottery_Preference__c>();
    	string lquery = ListingLotteryService.LOTTERY_PREFERENCE_QUERY + ' WHERE Id = \'' + lotteryPrefId + '\'';
    	try{
    		lps = database.query(lquery);
    	} catch (Exception e){
    		
    	}
    	return lps;
    }
    
    global static List<Lottery_Preference__c> getLotteryPreferenceByIDs(List<string> lotteryPrefIds){
    	List<Lottery_Preference__c> lps = new List<Lottery_Preference__c>();
    	string lquery = ListingLotteryService.LOTTERY_PREFERENCE_QUERY + ' WHERE Id in: lotteryPrefIds';
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
    */
    //*************************************
    // Lottery Member
    //*************************************
    
    global static List<Lottery_Member__c> getLotteryMembersByListingID(Id lotteryPrefId){
    	List<Lottery_Member__c> lms = new List<Lottery_Member__c>();
    	string lquery = ListingLotteryService.LOTTERY_MEMBER_QUERY + ' AND Listing__c = \'' + lotteryPrefId + '\'';
    	try{
    		lms = database.query(lquery);
    	} catch (Exception e){
    		
    	}
    	return lms;
    }
    
    global static List<Lottery_Member__c> getLotteryMembersByListingIDs(List<string> lotteryPrefIds){
    	List<Lottery_Member__c> lms = new List<Lottery_Member__c>();
    	string lquery = ListingLotteryService.LOTTERY_MEMBER_QUERY + ' AND Listing__c in: lotteryPrefIds ';
    	try{
    		lms = database.query(lquery);
    	} catch (Exception e){
    		
    	}
    	return lms;
    }
    
    
}