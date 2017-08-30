/**
 * @author:      Sumit Shingavi
 * @date:        07/28/2014
 * @description: Test class for CS_MOHCDBrowseListingCC
 * @history:     06/10/2015 - Heidi Tang - Edited
*/
@isTest
private class CS_MOHCDBrowseListingCCTest {
    
    private static List<Properties__c> lProperties;
    private static List<Properties__c> lUnits;
    
    static {

        lProperties = new List<Properties__c>();
        Id propRtId = Schema.SObjectType.Properties__c.getRecordTypeInfosByName().get(StringConstants.LISTING_PROPERTY).getRecordTypeId();
        lProperties.add(CS_TestDataSetup.createTestProperties(130000, StringConstants.PROP_RENTAL, 4.5, 2, 'New', 'Condo', 'Castro', propRtId));
        lProperties.add(CS_TestDataSetup.createTestProperties(130000, StringConstants.PROP_OWNERSHIP, 4.5, 2, 'New', 'Apartment', 'Castro', propRtId));
        insert lProperties;
        
        lUnits = new List<Properties__c>();
        Id unitRtId = Schema.SObjectType.Properties__c.getRecordTypeInfosByName().get(StringConstants.LISTING_UNIT).getRecordTypeId();
        lUnits.add(CS_TestDataSetup.createTestProperties(130000, StringConstants.PROP_RENTAL, 4.5, 2, 'Existing', 'Condo', 'Castro', unitRtId));
        lUnits.add(CS_TestDataSetup.createTestProperties(130000, StringConstants.PROP_OWNERSHIP, 4.5, 2, 'Existing', 'Apartment', 'Castro', unitRtId));
        insert lUnits;
    }
    
    static testMethod void testBrowseListingCC() {
    
        Test.startTest();
 
            CS_MOHCDBrowseListingCC controller = new CS_MOHCDBrowseListingCC();
            controller.getNeighborhoods();
            controller.getNewOrExisting();
            controller.getPropertyTypes();
            controller.getOccupancyTypes();
            controller.init();
            
            System.assertEquals(0, controller.lProperties.size());
            System.assertEquals(0, controller.lUnits.size());
            
            controller.unitSortExpression = 'New_or_Existing__c';
            controller.propSortExpression = 'New_or_Existing__c';
            controller.init();
                          
            controller.unitSortExpression = 'Neighborhood__c';
            controller.propSortExpression = 'Neighborhood__c';
            controller.init();
            
            controller.unitSortExpression = 'Neighborhood__c';
            controller.propSortExpression = 'Neighborhood__c';
            controller.init();
            
            controller.unitSortExpression = '';
            controller.propSortExpression = '';
            controller.init();
            
            controller.strSelectedOccupancyType = StringConstants.PROP_OWNERSHIP;
            controller.strSelectedPropertyType = 'Apartment';
            controller.strSelectedNewOrExisting = 'New';
            controller.strSelectedNeighborhood = 'Castro';
            controller.intMinPrice = 10;
            controller.intMaxPrice = 15000;
            controller.strMinBedrooms = '1';
            controller.intMaxBedrooms = 4;
            controller.dcMinBathrooms = 1.0;
            controller.dcMaxBathrooms = 3.0;
            controller.dcMinArea = 400.0;
            controller.dcMaxArea = 2400.0;
            controller.strZipCode = '12345';
            controller.init();
            
            controller.getPropSortDirection();
            controller.getUnitSortDirection();
            
            controller.setPropSortDirection(Label.DESCENDING);
            controller.setUnitSortDirection(Label.DESCENDING);
        
        Test.stopTest();            

        System.assertEquals(0, controller.lProperties.size());
        System.assertEquals(0, controller.lUnits.size());
    }

    static testMethod void testBrowseListingCCWithZeroMaxValues() {
    
        Test.startTest();
 
            CS_MOHCDBrowseListingCC controller = new CS_MOHCDBrowseListingCC();
            controller.getNeighborhoods();
            controller.getNewOrExisting();
            controller.getPropertyTypes();
            controller.getOccupancyTypes();
            controller.init();
            
            controller.unitSortExpression = 'New_or_Existing__c';
            controller.propSortExpression = 'New_or_Existing__c';
            controller.init();
                          
            controller.unitSortExpression = 'Neighborhood__c';
            controller.propSortExpression = 'Neighborhood__c';
            controller.init();
            
            controller.unitSortExpression = 'Neighborhood__c';
            controller.propSortExpression = 'Neighborhood__c';
            controller.init();
            
            controller.unitSortExpression = '';
            controller.propSortExpression = '';
            controller.init();
            
            controller.strSelectedOccupancyType = StringConstants.PROP_OWNERSHIP;
            controller.strSelectedPropertyType = 'Apartment';
            controller.strSelectedNewOrExisting = 'New';
            controller.strSelectedNeighborhood = 'Castro';
            controller.intMinPrice = 10;
            controller.intMaxPrice = 0;
            controller.strMinBedrooms = '1';
            controller.intMaxBedrooms = 0;
            controller.dcMinBathrooms = 1.0;
            controller.dcMaxBathrooms = 0;
            controller.dcMinArea = 400.0;
            controller.dcMaxArea = 0;
            controller.strZipCode = '12345';
            controller.init();

            controller.propSortExpression = Label.ASCENDING;
            controller.unitSortExpression = Label.ASCENDING;
            
            
            controller.getPropSortDirection();
            controller.getUnitSortDirection();
            
            controller.setPropSortDirection(Label.DESCENDING);
            controller.setUnitSortDirection(Label.DESCENDING);
        
        Test.stopTest();    

        System.assertEquals(0, controller.lProperties.size());
        System.assertEquals(0, controller.lUnits.size());
    }

    static testMethod void testBrowseListingCCWithZeroMinValues() {
    
        Test.startTest();
 
            CS_MOHCDBrowseListingCC controller = new CS_MOHCDBrowseListingCC();
            controller.getNeighborhoods();
            controller.getNewOrExisting();
            controller.getPropertyTypes();
            controller.getOccupancyTypes();
            controller.init();
            
            System.assertEquals(0, controller.lProperties.size());
            System.assertEquals(0, controller.lUnits.size());
            
            controller.unitSortExpression = 'New_or_Existing__c';
            controller.propSortExpression = 'New_or_Existing__c';
            controller.init();
                          
            controller.unitSortExpression = 'Neighborhood__c';
            controller.propSortExpression = 'Neighborhood__c';
            controller.init();
            
            controller.unitSortExpression = 'Neighborhood__c';
            controller.propSortExpression = 'Neighborhood__c';
            controller.init();
            
            controller.unitSortExpression = '';
            controller.propSortExpression = '';
            controller.init();
            
            controller.strSelectedOccupancyType = StringConstants.PROP_OWNERSHIP;
            controller.strSelectedPropertyType = 'Apartment';
            controller.strSelectedNewOrExisting = 'New';
            controller.strSelectedNeighborhood = 'Castro';
            controller.intMinPrice = 0;
            controller.intMaxPrice = 15000;
            controller.strMinBedrooms = '1';
            controller.intMaxBedrooms = 4;
            controller.dcMinBathrooms = 1.0;
            controller.dcMaxBathrooms = 3.0;
            controller.dcMinArea = 0;
            controller.dcMaxArea = 2400.0;
            controller.strZipCode = '12345';
            controller.init();
            
            controller.getPropSortDirection();
            controller.getUnitSortDirection();
            
            controller.setPropSortDirection(Label.DESCENDING);
            controller.setUnitSortDirection(Label.DESCENDING);
        
        Test.stopTest();    

        System.assertEquals(0, controller.lProperties.size());
        System.assertEquals(0, controller.lUnits.size());
    }

    static testMethod void searchProperty(){
        Test.startTest();
            SfmohPropertySearchController controller = new SfmohPropertySearchController();
            controller.closePopup();
            String soqlQuery = controller.debugSoql;
            System.assert(soqlQuery =='select Id, Name, Price__c, Occupancy_Type__c, Zip_Code__c, of_bathrooms__c, of_Bedrooms__c, Area_Sq_Ft__c, New_or_Existing__c, Neighborhood__c, Property_Type__c, Property_Photo_1__c, Photo_1_Caption__c from Properties__c where Active__c = true order by of_bathrooms__c asc limit 20',soqlQuery);


            PageReference pref = Page.SfmohprogramsSearchProperties; 
                pref.getParameters().put('rowLink',lProperties[0].Name);
                pref.getParameters().put('price_min','100000');
                pref.getParameters().put('price_max','200000');
                pref.getParameters().put('occupancyType','All');
                pref.getParameters().put('zipCode','12345');
                pref.getParameters().put('numBedroomsmin','1');
                pref.getParameters().put('numBedroomsmax','4');
                pref.getParameters().put('numBathroomsmin','1.0');
                pref.getParameters().put('numBathroomsmax','3.0');
                pref.getParameters().put('areaSqFtmin','0');
                pref.getParameters().put('areaSqFtmax','2400.0');
                pref.getParameters().put('buildingType','All');
                pref.getParameters().put('neighborhood','All');
                pref.getParameters().put('proptype','All');
            Test.setCurrentPage(pref);
            controller.showPopup();
            controller.sortDir = 'asc';
            controller.toggleSort();
            controller.leftSelected.add('String 1');
            controller.rightSelected.add('String 1');
            controller.rightSelected.add('String 2');
            controller.selectClick();
            controller.getSelectedValues();
            controller.rightSelected.add('String 1');
            controller.rightSelected.add('String 2');
            controller.unselectClick();
            controller.getunSelectedValues();
            controller.prop_detail = new Properties__c();

            List<SelectOption> occupancyTypeList = controller.OccupancyTypeList;
            System.assert(occupancyTypeList.size()==3,occupancyTypeList.size());

            List<SelectOption> propertyTypeList = controller.PropertyTypeList;
            System.assert(propertyTypeList.size()==6,propertyTypeList.size());

            List<SelectOption> neworExistingList = controller.NeworExistingList;
            System.assert(neworExistingList.size()==3,neworExistingList.size());

            List<SelectOption> neighborhoodList = controller.NeighborhoodList;
            System.assert(neighborhoodList.size()==39,neighborhoodList.size());

            controller.runSearch();

            pref = Page.SfmohprogramsSearchProperties; 
                pref.getParameters().put('rowLink',lProperties[0].Name);
                pref.getParameters().put('price_min','');
                pref.getParameters().put('price_max','');
                pref.getParameters().put('occupancyType','Onwership');
                pref.getParameters().put('zipCode','12345');
                pref.getParameters().put('numBedroomsmin','');
                pref.getParameters().put('numBedroomsmax','');
                pref.getParameters().put('numBathroomsmin','');
                pref.getParameters().put('numBathroomsmax','');
                pref.getParameters().put('areaSqFtmin','');
                pref.getParameters().put('areaSqFtmax','');
                pref.getParameters().put('buildingType','Not All');
                pref.getParameters().put('neighborhood','Castro');
                pref.getParameters().put('proptype','Apartment');
            Test.setCurrentPage(pref);

            controller.runSearch();
        Test.stopTest();
    }

    static testMethod void secondSearchProperty(){
        Test.startTest();
            PropertySearchController2 controller = new PropertySearchController2();
            controller.closePopup();
            String soqlQuery = controller.debugSoql;
            System.assert(soqlQuery =='select Id, Name, Price__c, Occupancy_Type__c, Zip_Code__c, of_bathrooms__c, of_Bedrooms__c, Area_Sq_Ft__c, New_or_Existing__c, Neighborhood__c, Property_Type__c, Property_Photo_1__c, Photo_1_Caption__c from Properties__c where Active__c = true order by of_bathrooms__c asc limit 20',soqlQuery);



            PageReference pref = Page.SfmohprogramsSearchProperties; 
                pref.getParameters().put('rowLink',lProperties[0].Name);
                pref.getParameters().put('price_min','100000');
                pref.getParameters().put('price_max','200000');
                pref.getParameters().put('occupancyType','All');
                pref.getParameters().put('zipCode','12345');
                pref.getParameters().put('numBedroomsmin','1');
                pref.getParameters().put('numBedroomsmax','4');
                pref.getParameters().put('numBathroomsmin','1.0');
                pref.getParameters().put('numBathroomsmax','3.0');
                pref.getParameters().put('areaSqFtmin','0');
                pref.getParameters().put('areaSqFtmax','2400.0');
                pref.getParameters().put('buildingType','All');
                pref.getParameters().put('neighborhood','All');
                pref.getParameters().put('proptype','All');
            Test.setCurrentPage(pref);
            controller.showPopup();
            controller.sortDir = 'asc';
            controller.toggleSort();
            controller.prop_detail = new Properties__c();

            controller.runSearch();

            pref = Page.SfmohprogramsSearchProperties; 
                pref.getParameters().put('rowLink',lProperties[0].Name);
                pref.getParameters().put('price_min','');
                pref.getParameters().put('price_max','');
                pref.getParameters().put('occupancyType','Onwership');
                pref.getParameters().put('zipCode','12345');
                pref.getParameters().put('numBedroomsmin','');
                pref.getParameters().put('numBedroomsmax','');
                pref.getParameters().put('numBathroomsmin','');
                pref.getParameters().put('numBathroomsmax','');
                pref.getParameters().put('areaSqFtmin','');
                pref.getParameters().put('areaSqFtmax','');
                pref.getParameters().put('buildingType','Not All');
                pref.getParameters().put('neighborhood','Castro');
                pref.getParameters().put('proptype','Apartment');
            Test.setCurrentPage(pref);

            controller.runSearch();
        Test.stopTest();
    }
}