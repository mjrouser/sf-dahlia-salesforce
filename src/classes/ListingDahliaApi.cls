//services/apexrest/Listings
@RestResource(urlMapping='/DAHLIA/*')

global with sharing class ListingDahliaApi {
    
    @HttpPost
    global static string doPost (String name) {
    	return 'your name is ' + name;
    }
    
}