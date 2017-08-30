public with sharing class SfmohPropertySearchController {
 
  // the soql without the order and limit
  private String soql {get;set;}
  // the collection of properties to display
  public List<Properties__c> properties {get;set;}
  public Properties__c prop_detail {get;set;}
  public List<Properties__c> selectedProperty{get; set;}
  
  

  Public List<string> leftselected{get;set;}

  Public List<string> rightselected{get;set;}

  Set<string> leftvalues = new Set<string>();

  Set<string> rightvalues = new Set<string>();
  
  // the current sort direction. defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }
  
  public boolean displayPopup {get; set;}
 
    public void closePopup() {
        displayPopup = false;
    }
 
    public void showPopup() {
        displayPopup = true;
        String rowLink = Apexpages.currentPage().getParameters().get('rowLink');
        selectedProperty = [Select Name, Price__c, Occupancy_Type__c from Properties__c where Name = :rowLink];
        System.debug('*************selectedProperty' + selectedProperty);
        System.debug('*************rowLink' + rowLink);
        //String selected = System.currentPageReference().getParameters().get('Name');
        //prop_detail = [Select Name, Price__c, Occupancy_Type__c from Properties__c where Name = :selected];
        //return prop_detail;
    }
 
  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'of_bathrooms__c'; } return sortField;  }
    set;
  }
 
  // format the soql for display on the visualforce page
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
    set;
  }
 
  // init the controller and display some sample data when the page loads
  public SfmohPropertySearchController() {
    leftselected = new List<String>();

    rightselected = new List<String>();
        
    for(Properties__c p : [SELECT Neighborhood__c FROM Properties__c]){
          leftvalues.add(p.Neighborhood__c);
    }
    soql = 'select Id, Name, Price__c, Occupancy_Type__c, Zip_Code__c, of_bathrooms__c, of_Bedrooms__c, Area_Sq_Ft__c, New_or_Existing__c, Neighborhood__c, Property_Type__c, Property_Photo_1__c, Photo_1_Caption__c from Properties__c where Active__c = true';
    runQuery();
    

        
        
        

    
  }
 
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }
 
  // runs the actual query
  public void runQuery() {
 
    try {
      properties = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20');
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }
 
  }
 
  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
    //get the value of entered for minimum price
    String price_min = Apexpages.currentPage().getParameters().get('price_min');
    //get the value of entered for maximum price
    String price_max = Apexpages.currentPage().getParameters().get('price_max');
    //holds the variable to hold the prices entered
    Decimal price_decmin = 0.00;
    Decimal price_decmax = 0.00;

    //initialize the value of price_decmin to zero
    if (!price_min.equals('')) {
      price_decmin = Decimal.valueof(price_min);
      }
      else {
        price_decmin = 0.00;
      }
    //initialize the value of price_decmax to zero
    if (!price_max.equals('')) {
      price_decmax = Decimal.valueof(price_max);
      
      }
      else {
        price_decmax = 0.00;
      }
    
    String occupancyType = Apexpages.currentPage().getParameters().get('occupancyType');
    if (occupancyType == 'All') {
        occupancyType = '';
        }
    String zipCode = Apexpages.currentPage().getParameters().get('zipCode');
    String numBedroomsmin = Apexpages.currentPage().getParameters().get('numBedroomsmin');
    String numBedroomsmax = Apexpages.currentPage().getParameters().get('numBedroomsmax');
    Integer numBedrooms_intmin = 0;
    Integer numBedrooms_intmax = 0;
    Integer numBathrooms_intmin = 0;
    Integer numBathrooms_intmax = 0;
    //initializes the value entered for number of rooms to zero
    if (!numBedroomsmin.equals('')) {
      numBedrooms_intmin = integer.valueof(numBedroomsmin);
      }
      else {
        numBedrooms_intmin = 0;
      }
    if (!numBedroomsmax.equals('')) {
      numBedrooms_intmax = integer.valueof(numBedroomsmax);
      }
      else {
        numBedrooms_intmax = 0;
      }  
    String numBathroomsmin = Apexpages.currentPage().getParameters().get('numBathroomsmin');
    String numBathroomsmax = Apexpages.currentPage().getParameters().get('numBathroomsmax');
    //initializes the value entered for number of bathroom to zero
    if (!numBathroomsmin.equals('')) {
      numBathrooms_intmin = integer.valueof(numBathroomsmin);
      }
      else {
        numBathrooms_intmin = 0;
      }

    if (!numBathroomsmax.equals('')) {
      numBathrooms_intmax = integer.valueof(numBathroomsmax);
      }
      else {
        numBathrooms_intmax = 0;
      }
    String areaSqFtmin = Apexpages.currentPage().getParameters().get('areaSqFtmin');
    String areaSqFtmax = Apexpages.currentPage().getParameters().get('areaSqFtmax');
    String buildingType = Apexpages.currentPage().getParameters().get('buildingType');
    if (buildingType == 'All') {
        buildingType = '';
        }
    String neighborhood = Apexpages.currentPage().getParameters().get('neighborhood');
    if (neighborhood == 'All') {
        neighborhood = '';
        }
    String propType = Apexpages.currentPage().getParameters().get('proptype');
    if (propType == 'All') {
        propType = '';
        }
    Decimal areaSqFt_decmin = 0.00;
    Decimal areaSqFt_decmax = 0.00;
    //initializes the value entered for areas per square feet to zero
    if (!areaSqFtmin.equals('')) {
      areaSqFt_decmin = Decimal.valueof(areaSqFtmin);
      }
    else {
        areaSqFt_decmin = 0.00;
    }

    if (!areaSqFtmax.equals('')) {
    areaSqFt_decmax = Decimal.valueof(areaSqFtmax);
    }
    else {
      areaSqFt_decmax = 0.00;
    }

   
    //start of query
    soql = 'select Id, Name, Price__c, Occupancy_Type__c, Zip_Code__c, of_bathrooms__c, of_Bedrooms__c, Area_Sq_Ft__c, New_or_Existing__c, Neighborhood__c, Property_Type__c, Property_Photo_1__c, Photo_1_Caption__c from Properties__c where Active__c = true';
     system.debug('*************SOQL BEFORE'+soql);
    if (price_decmin != 0)
      soql += ' and Price__c >= ' + price_decmin;
    if (price_decmax != 0)
      soql += ' and Price__c  <= ' + price_decmax;
    if (!occupancyType.equals(''))
      soql += ' and Occupancy_Type__c LIKE \''+String.escapeSingleQuotes(occupancyType)+'%\'';
    if (!zipCode.equals(''))
      soql += ' and Zip_Code__c LIKE \''+String.escapeSingleQuotes(zipCode)+'%\'';
    if (numBedrooms_intmin != 0) {
      soql += ' and of_Bedrooms__c >= ' + numBedrooms_intmin;
      }
    if (numBedrooms_intmax != 0) {
      soql += ' and of_Bedrooms__c <= ' + numBedrooms_intmax;
      }  
    if (numBathrooms_intmin != 0) {
      soql += ' and of_bathrooms__c >= ' + numBathrooms_intmin;
      }
     if (numBathrooms_intmax != 0) {
      soql += ' and of_bathrooms__c <= ' + numBathrooms_intmax;
      }  
    if (!areaSqFtmin.equals(''))
      soql += ' and Area_Sq_Ft__c >= ' + areaSqFt_decmin;
    if (!areaSqFtmax.equals(''))
      soql += ' and Area_Sq_Ft__c <= ' + areaSqFt_decmax;   
    if (!buildingType.equals(''))
      soql += ' and New_or_Existing__c LIKE \''+String.escapeSingleQuotes(buildingType)+'%\'';
    if (!neighborhood.equals(''))
      soql += ' and Neighborhood__c LIKE \''+String.escapeSingleQuotes(neighborhood)+'%\'';
    /*if (rightvalues.size() > 0){

        String tempStr = ' and  (Neighborhood__c = ';
        String tempStr2 = '';
        String tempStr3 = '';
        
        for(String s : rightvalues){
            
            tempStr2 += '\''+String.escapeSingleQuotes(s)+'\' ' + ' or Neighborhood__c =';
        
        }
        
        soql += tempStr + tempStr2 +'\'' + String.escapeSingleQuotes(tempStr3) + '\''+ +')';
         //soql += ' and Neighborhood__c LIKE \''+String.escapeSingleQuotes(neighborhood)+'%\'';*/
    
     
    if (!proptype.equals(''))
      soql += ' and Property_Type__c LIKE \''+String.escapeSingleQuotes(propType)+'%\'';
 
    // run the query again
    runQuery();
    System.debug('*************Price__c' + soql);
    System.debug('*************rightvalues' + rightvalues);
    return null;
  }
   

     

    public PageReference selectclick(){

        rightselected.clear();

        for(String s : leftselected){

            //leftvalues.remove(s);

            rightvalues.add(s);

        }

        return null;

    }

     

    public PageReference unselectclick(){

        leftselected.clear();

        for(String s : rightselected){

            rightvalues.remove(s);

            //leftvalues.add(s);

        }

        return null;

    }


    public List<SelectOption> getunSelectedValues(){

        List<SelectOption> options = new List<SelectOption>();

        List<string> tempList = new List<String>();

        tempList.addAll(leftvalues);

        tempList.sort();

        for(string s : tempList)

            options.add(new SelectOption(s,s));

        return options;

    }


    public List<SelectOption> getSelectedValues(){

        List<SelectOption> options1 = new List<SelectOption>();

        List<string> tempList = new List<String>();

        tempList.addAll(rightvalues);

        tempList.sort();

        for(String s : tempList)

            options1.add(new SelectOption(s,s));

        return options1;

    }

    public List<SelectOption> OccupancyTypeList
        {
            get
                {
                    List<SelectOption> options = new List<SelectOption>();
                    Schema.DescribeFieldResult fieldResult = Properties__c.Occupancy_Type__c.getDescribe();
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    options.add(new SelectOption('All', 'All'));
                    for(Schema.PicklistEntry f : ple)
                    {
                        options.add(new SelectOption(f.getLabel(), f.getValue()));
                    }
                    return options;
                }
            set;
        }

    public List<SelectOption> PropertyTypeList
        {
            get
                {
                    List<SelectOption> options = new List<SelectOption>();
                    Schema.DescribeFieldResult fieldResult = Properties__c.Property_Type__c.getDescribe();
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    options.add(new SelectOption('All', 'All'));
                    for(Schema.PicklistEntry f : ple)
                    {
                        options.add(new SelectOption(f.getLabel(), f.getValue()));
                    }
                    return options;
                }
            set;
        }

    public List<SelectOption> NeworExistingList
        {
            get
                {
                    List<SelectOption> options = new List<SelectOption>();
                    Schema.DescribeFieldResult fieldResult = Properties__c.New_or_Existing__c.getDescribe();
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    options.add(new SelectOption('All', 'All'));
                    for(Schema.PicklistEntry f : ple)
                    {
                        options.add(new SelectOption(f.getLabel(), f.getValue()));
                    }
                    return options;
                }
            set;
        }

    public List<SelectOption> NeighborhoodList
        {
            get
                {
                    List<SelectOption> options = new List<SelectOption>();
                    Schema.DescribeFieldResult fieldResult = Properties__c.Neighborhood__c.getDescribe();
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    options.add(new SelectOption('All', 'All'));
                    for(Schema.PicklistEntry f : ple)
                    {
                        options.add(new SelectOption(f.getLabel(), f.getValue()));
                    }
                    return options;
                }
            set;
        }

}