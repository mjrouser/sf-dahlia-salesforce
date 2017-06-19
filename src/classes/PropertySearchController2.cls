public with sharing class PropertySearchController2 {
 
  // the soql without the order and limit
  private String soql {get;set;}
  // the collection of properties to display
  public List<Properties__c> properties {get;set;}
  public Properties__c prop_detail {get;set;}
  public List<Properties__c> selectedProperty{get; set;}
 
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
  public PropertySearchController2() {
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
    
    String price_min = Apexpages.currentPage().getParameters().get('price_min');
    String price_max = Apexpages.currentPage().getParameters().get('price_max');
    Decimal price_decmin = 0;
    Decimal price_decmax = 0;

    
    if (!price_min.equals('')) {
      price_decmin = Decimal.valueof(price_min);
      }
      else {
        price_decmin = 0;
      }

    if (!price_max.equals('')) {
      price_decmax = Decimal.valueof(price_max);
      }
      else {
        price_decmax = 0;
      }
    
    String occupancyType = Apexpages.currentPage().getParameters().get('occupancyType');
    String zipCode = Apexpages.currentPage().getParameters().get('zipCode');
    String numBedroomsmin = Apexpages.currentPage().getParameters().get('numBedroomsmin');
    String numBedroomsmax = Apexpages.currentPage().getParameters().get('numBedroomsmax');
    Integer numBedrooms_intmin = 0;
    Integer numBedrooms_intmax = 0;
    Integer numBathrooms_intmin = 0;
    Integer numBathrooms_intmax = 0;
    
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
    String neighborhood = Apexpages.currentPage().getParameters().get('neighborhood');
    String propType = Apexpages.currentPage().getParameters().get('proptype');
    Decimal areaSqFt_decmin = 0;
    Decimal areaSqFt_decmax = 0;
    if (!areaSqFtmin.equals('')) {
      areaSqFt_decmin = Decimal.valueof(areaSqFtmin);
      }
    else {
        areaSqFt_decmin = 0;
    }

    if (!areaSqFtmax.equals('')) {
    areaSqFt_decmax = Decimal.valueof(areaSqFtmax);
    }
    else {
      areaSqFt_decmax = 0;
    }

 
    soql = 'select Id, Name, Price__c, Occupancy_Type__c, Zip_Code__c, of_bathrooms__c, of_Bedrooms__c, Area_Sq_Ft__c, New_or_Existing__c, Neighborhood__c, Property_Type__c, Property_Photo_1__c, Photo_1_Caption__c from Properties__c where Active__c = true';
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
    if (!proptype.equals(''))
      soql += ' and Property_Type__c LIKE \''+String.escapeSingleQuotes(propType)+'%\'';
 
    // run the query again
    runQuery();
 
    return null;
  }
 
 
}