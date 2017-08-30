/**
 * @author:      Sumit Shingavi
 * @date:        07/03/2014
 * @description: An apex page controller for mohcdBrowseListings VF Page.
 * @history:     06/10/2015 - Heidi Tang - Edited
*/
public class CS_MOHCDBrowseListingCC {
    
    //Public Variables
    public List<Properties__c> lProperties {get; set;}    //For List of Properties        
    public List<Properties__c> lUnits {get; set;}         //For List of Units
    public String strSelectedOccupancyType {get; set;}    //For Filter of Occupancy Type
    public String strSelectedPropertyType {get; set;}     //For Filter of Property Type
    public String strSelectedNewOrExisting {get; set;}    //For Filter of New Or Existing
    public String strSelectedNeighborhood {get; set;}     //For Filter of Neighborhood   
    public Integer intMinPrice {get; set;}                //For Filter of Min Price
    public Integer intMaxPrice {get; set;}                //For Filter of Max Price    
    public String strMinBedrooms {get; set;}             //For Filter of Min Bedrooms
    public Integer intMaxBedrooms {get; set;}             //For Filter of Max Bedrooms    
    public Decimal dcMinBathrooms {get; set;}            //For Filter of Min Bathrooms
    public Decimal dcMaxBathrooms {get; set;}            //For Filter of Max Bathrooms    
    public Decimal dcMinArea {get; set;}                  //For Filter of Min Area
    public Decimal dcMaxArea {get; set;}                  //For Filter of Max Area
    public String strZipCode {get; set;}                  //For Filter of Zip code
    
    //Private variables
    private String unitSortDirection = Label.ASCENDING;
    private String unitSortExp = 'Name';
    
    private String propSortDirection = Label.ASCENDING;
    private String propSortExp = 'Name';
    
    //Constructor
    public CS_MOHCDBrowseListingCC() {
        lProperties = new List<Properties__c>();
        lUnits = new List<Properties__c>();
        strSelectedOccupancyType = Label.ALL;
        strSelectedPropertyType = Label.ALL;
        strSelectedNewOrExisting = Label.ALL;
        strSelectedNeighborhood = Label.ALL;
        strZipCode = '';
    }    
    
    public PageReference init() {
        //prepareUnitsList();
        preparePropertiesList();
        return null;
    }
    
    /*
    * @auther : Cloud Sherpas Inc.
    * @date : 03/07/2014
    * @description : Apex method for preparing Property List
    * @parameters : Nothing
    * @returns : Nothing
    */  
    public PageReference preparePropertiesList() {
    
        try {            
            String strSOQL = 'SELECT Id, Name, Price__c, Occupancy_Type__c, Zip_Code__c, of_Bathrooms__c, of_Bedrooms__c, '; 
            strSOQL += 'Photo_1_Caption__c, Property_Photo_1__c, Area_Sq_Ft__c, New_or_Existing__c, Street_Name__c, RecordType.Name, ';
            strSOQL += 'Search_Bedrooms__c, Search_Bathrooms__c, Search_Price_Max__c, Search_Price_Min__c, ';
            strSOQL += 'Search_Sq_Ft_Max__c, Search_Sq_Ft_Min__c, ';
            strSOQL += 'Neighborhood__c, Property_Type__c, Property_Name__c FROM Properties__c ';
            strSOQL += 'WHERE RecordType.Name = \'Property\' AND Posting_Date__c <= TODAY AND Posting_End_Date__c >= TODAY ';
            strSOQL += 'AND Marketing_Plan_Approval_Status__c = \'Approved\' AND Pricing_Request_Approval_Status__c = \'Approved\' ';
            
            if((!String.isBlank(strSelectedOccupancyType)) && strSelectedOccupancyType != Label.ALL) {                
                strSOQL += ' AND (Occupancy_Type__c =: strSelectedOccupancyType)';                
            }
            if((!String.isBlank(strSelectedPropertyType)) && strSelectedPropertyType != Label.ALL) {                
                strSOQL += ' AND (Property_Type__c =: strSelectedPropertyType)';                
            }
            
            if((!String.isBlank(strSelectedNewOrExisting)) && strSelectedNewOrExisting != Label.ALL) {                
                strSOQL += ' AND (New_or_Existing__c =: strSelectedNewOrExisting)';                
            }
                        
            if((!String.isBlank(strSelectedNeighborhood)) && strSelectedNeighborhood != Label.ALL) {                
                strSOQL += ' AND (Neighborhood__c =: strSelectedNeighborhood)';                
            }
            
            if((intMinPrice != null) && (intMinPrice != 0)) {
                 if((intMaxPrice == null) || (intMaxPrice == 0)) {
                     strSOQL += ' AND (Search_Price_Min__c >=: intMinPrice OR Search_Price_Max__c >=: intMinPrice)';
                 }                 
            }  
            if((intMaxPrice != null) && (intMaxPrice != 0)) {
                 if((intMinPrice != null) && (intMinPrice != 0)) {
                     //strSOQL += ' AND ((Search_Price_Min__c >=: intMinPrice OR (Search_Price_Min__c <=: intMinPrice AND Search_Price_Max__c >=: intMinPrice )) AND ((intMaxPrice >=: Search_Price_Min__c AND intMaxPrice <=: Search_Price_Max__c) OR (Search_Price_Max__c = null AND Search_Price_Min__c <=: intMaxPrice )))';
                     strSOQL += ' AND ((Search_Price_Min__c >=: intMinPrice OR (Search_Price_Min__c <=: intMinPrice AND Search_Price_Max__c >=: intMinPrice )) AND (Search_Price_Max__c <=: intMaxPrice OR (Search_Price_Max__c >=: intMaxPrice AND Search_Price_Min__c <=: intMaxPrice) OR (Search_Price_Max__c = null AND Search_Price_Min__c <=: intMaxPrice )))';
                 } else {
                     strSOQL += ' AND (Search_Price_Max__c <=: intMaxPrice OR  (Search_Price_Max__c = null AND Search_Price_Min__c <=: intMaxPrice ))';
                 }
                 
            }                        
            
            if((strMinBedrooms != null) && (!String.isBlank(strMinBedrooms))) {
                 if((intMaxBedrooms == null) || (intMaxBedrooms == 0)) {
                     strSOQL += ' AND (Search_Bedrooms__c includes(\'' + strMinBedrooms + '\'))';
                 }                     
            }  
            if((intMaxBedrooms != null) && (intMaxBedrooms != 0)) {
            
                 Integer maxBedrooms = intMaxBedrooms;
                 String maxBedroomsStr = 'Search_Bedrooms__c includes(\''+ maxBedrooms + '\')';
                 Integer minBedrooms = (strMinBedrooms != null) ? Integer.valueOf(strMinBedrooms) : 0;
                 
                 //include in query, counts between min and max
                 for (Integer i = maxBedrooms; i >= minBedrooms ; i--) {
                     maxBedroomsStr += ' OR Search_Bedrooms__c includes(\''+ i + '\')';
                 }
                                                                                     
                 strSOQL += ' AND (' + maxBedroomsStr + ')';
                 
            }
            
            if((dcMinBathrooms != null) && (dcMinBathrooms != 0)) {
                 if((dcMaxBathrooms == null) || (dcMaxBathrooms == 0)) {                     
                     strSOQL += ' AND (Search_Bathrooms__c includes(\'' + dcMinBathrooms + '\'))';
                 }

            }  
            if((dcMaxBathrooms != null) && (dcMaxBathrooms != 0)) {
            
                 Integer maxBathrooms = Integer.valueOf(dcMaxBathrooms);
                 String maxBathroomsStr = 'Search_Bathrooms__c includes(\''+ String.valueOf(maxBathrooms) + '\')';
                 //String maxBathroomsStr = '\''+ String.valueOf(maxBathrooms) + '\'';
                 Integer minBathrooms = dcMinBathrooms != null ? Integer.valueOf(dcMinBathrooms) : 0;
                 
                 //include in query, counts between min and max
                 for (Integer i = maxBathrooms; i >= minBathrooms ; i--) {
                     maxBathroomsStr += ' OR Search_Bathrooms__c includes(\''+ i + '\')';
                 }
                 if (dcMaxBathrooms >= 2 && (dcMinBathrooms != null && dcMinBathrooms < 2)) {
                     maxBathroomsStr += ' OR Search_Bathrooms__c includes(\''+ 1.5 + '\')';                     
                 }
                                                  
                 strSOQL += ' AND (' + maxBathroomsStr  + ')';
            }
            
            if((dcMinArea != null) && (dcMinArea != 0)) {
                 if ((dcMaxArea == null) || (dcMaxArea == 0)) {
                     strSOQL += ' AND (Search_Sq_Ft_Min__c >=: dcMinArea OR Search_Sq_Ft_Max__c >=: dcMinArea)';
                 }
            }
            
            if((dcMaxArea != null) && (dcMaxArea != 0)) {
                 if((dcMinArea != null) && (dcMinArea != 0)) {
                     strSOQL += ' AND ((Search_Sq_Ft_Min__c >=: dcMinArea OR (Search_Sq_Ft_Min__c <=: dcMinArea AND Search_Sq_Ft_Max__c >=: dcMinArea)) AND (Search_Sq_Ft_Max__c <=: dcMaxArea OR (Search_Sq_Ft_Max__c >=: dcMaxArea AND Search_Sq_Ft_Min__c <= : dcMaxArea) OR (Search_Sq_Ft_Max__c = null AND Search_Sq_Ft_Min__c <=: dcMaxArea )))';
                 } else {
                     strSOQL += ' AND (Search_Sq_Ft_Max__c <=: dcMaxArea OR (Search_Sq_Ft_Max__c = null AND Search_Sq_Ft_Min__c <=: dcMaxArea ))';
                 }                 
            }
            
            if(!String.isBlank(strZipCode)) {
                strSOQL += ' AND Property_Address_Zip_Code__c LIKE \''+String.escapeSingleQuotes(strZipCode)+'%\'';
            }
            
            string sortFullExp = ' ORDER BY '+ propSortExpression  + ' ' + propSortDirection;    
            strSOQL += sortFullExp + ' LIMIT 999';
            
            System.debug(LoggingLevel.INFO, '==strSOQL for Properties==' + strSOQL);
            
            lProperties = new List<Properties__c>();
            lProperties = Database.query(strSOQL);
                      
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+e.getMessage()));             
        }  
        return null;      
    }    
    
    public String propSortExpression {    
        get{ return propSortExp; }
        set{    
            if(value == propSortExp) {
                propSortDirection = (propSortDirection == 'ASC')? 'DESC' : 'ASC';
            } else {
                propSortDirection = 'ASC';
            }
            propSortExp = value;
        }
    }
    
    public String getPropSortDirection() {        
        if(propSortExpression == null || propSortExpression == '') {
            return 'ASC';
        } else {
            return propSortDirection;
        }    
    }
    
    public void setPropSortDirection(String value) {  
        propSortDirection = value;
    }
    
    public String unitSortExpression {    
        get{ return unitSortExp; }
        set{    
            if(value == unitSortExp) {
                unitSortDirection = (unitSortDirection == 'ASC')? 'DESC' : 'ASC';
            } else {
                unitSortDirection = 'ASC';
            }
            unitSortExp = value;
        }
    }
    
    public String getUnitSortDirection() {        
        if(unitSortExpression == null || unitSortExpression == '') {
            return 'ASC';
        } else {
            return unitSortDirection;
        }    
    }
    
    public void setUnitSortDirection(String value) {  
        unitSortDirection = value;
    }
    
    //Returns Property Types
    public List<SelectOption> getPropertyTypes() {                
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Properties__c.Property_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption(Label.ALL,Label.ALL));
        for(Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;               
    }
    
    //Returns New OR Existing Picklist values
    public List<SelectOption> getNewOrExisting() {       
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Properties__c.New_or_Existing__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption(Label.ALL,Label.ALL));
        for(Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }            
    
    //Returns Neighborhood picklist values
    public List<SelectOption> getNeighborhoods() {       
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Properties__c.Neighborhood__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption(Label.ALL,Label.ALL));
        for(Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    
    //Returns Occupancy Types
    public List<SelectOption> getOccupancyTypes() {   
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Properties__c.Occupancy_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption(Label.ALL,Label.ALL));
        for(Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;       
    }               
}