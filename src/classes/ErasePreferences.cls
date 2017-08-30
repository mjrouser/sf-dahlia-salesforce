public class ErasePreferences {
    public static void erase() {
    List<Application__c> appList = [SELECT Id, Is_Migrated__c, Name, Listing__c, COP_Preference_Manual__c, 
                                    COP_Preference_Member__c, COP_Preference__c, DTHP_Preference_Manual__c,
                                    DTHP_Preference_Member_Name__c, DTHP_Preference_Member__c, DTHP_Preference_Rank__c,
                                    DTHP_Preference__c, Live_Work_Preference_Paper__c, Live_Work_Preference_Rank__c, Live_Work_Preference__c,
                                    Live_in_SF_Preference_Member__c, Live_in_SF_Preference_Proof__c, Neighborhood_Preference_Address__c,
                                    Neighborhood_Preference_Manual__c, Neighborhood_Preference_Member__c, Neighborhood_Preference_Proof__c,
                                    Neighborhood_Preference_Rank__c, Neighborhood_Preference__c, Work_in_SF_Preference_Member__c,
                                    Work_in_SF_Preference_Proof__c, COP_Opt_Out__c, DTHP_Opt_Out__c, Live_Work_Opt_Out__c, NRHP_Opt_Out__c
                                    From Application__c Where Listing__c = 'a0Wg0000004hUz2'];

        for(Application__c app : appList) {
            //COP

                app.COP_Preference_Manual__c = '';  

                    app.COP_Opt_Out__c = false;

                app.COP_Preference_Member__c = null;
            
            //DTHP

                app.DTHP_Preference_Manual__c = ''; 

                    app.DTHP_Opt_Out__c = false;

                app.DTHP_Preference_Member__c = null;
            
            //NRHP

                app.Neighborhood_Preference_Manual__c = '';  

                    app.NRHP_Opt_Out__c = false;

                app.Neighborhood_Preference_Member__c = null;
            
            //Live/Work

                app.Live_Work_Preference_Paper__c =false; 

                    app.Live_Work_Opt_Out__c = false;

                app.Live_in_SF_Preference_Member__c = null;

                app.Work_in_SF_Preference_Member__c = null;
            
        }
        Database.update(appList,false);
    }
}