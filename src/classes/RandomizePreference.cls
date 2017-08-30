public class RandomizePreference {
    
    public static Integer getRand(Integer x, Integer y) {
        return (Integer)Math.floor(Math.random() * ((y-x)+1) + x);
        
    }
    
    public static List<Application_Member__c> getAppMember(Id appId, List<Application_Member__c> appMemberList) {
        List<Application_Member__c> appMemList = new List<Application_Member__c>();
        for(Application_Member__c appMem : appMemberList) {
            if(appId == appMem.Application__c)
                appMemList.add(appMem);
        }
        return appMemList;
    }
    public static void randomize(){
        String[] prefManual = new String[]{'Valid','Valid - Added','Unconfirmed','Invalid'};
        String[] NRHPManual = new String[]{'Valid Address','Valid Address - Added','Unconfirmed','Invalid Address'};
		Map<Id,Application__c> appMap = new Map<Id,Application__c>();
        Map<id,List<Application_Member__c>> appMemberMap =new Map<id,List<Application_Member__c>>();
        
        List<Application__c> appList = [SELECT Id, Is_Migrated__c, Name, Listing__c, COP_Preference_Manual__c, COP_Preference_Member__c, COP_Preference__c, DTHP_Preference_Manual__c, DTHP_Preference_Member_Name__c, DTHP_Preference_Member__c, DTHP_Preference_Rank__c, DTHP_Preference__c, Live_Work_Preference_Paper__c, Live_Work_Preference_Rank__c, Live_Work_Preference__c, Live_in_SF_Preference_Member__c, Live_in_SF_Preference_Proof__c, Neighborhood_Preference_Address__c, Neighborhood_Preference_Manual__c, Neighborhood_Preference_Member__c, Neighborhood_Preference_Proof__c, Neighborhood_Preference_Rank__c, Neighborhood_Preference__c, Work_in_SF_Preference_Member__c, Work_in_SF_Preference_Proof__c, COP_Opt_Out__c, DTHP_Opt_Out__c, Live_Work_Opt_Out__c, NRHP_Opt_Out__c From Application__c Where Listing__c = 'a0Wg0000004hUz2' AND Is_Migrated__c = false LIMIT 300];
        for(Application__c app : appList) {
            appMap.put(app.Id, app);
        }
        List<Application_Member__c> appMemberList = [SELECT Id, Application__c FROM Application_Member__c Where Application__c In :appMap.keySet()];
        for(Id appid : appMap.keySet()) {
            appMemberMap.put(appid , getAppMember(appid, appMemberList));
        }

        
        for(Application__c app : appList) {
            //COP
            if(getRand(0,10) > 3) {
                app.COP_Preference_Manual__c = prefManual[getRand(0,3)];  
                if(getRand(0,3) == 0)
                    app.COP_Opt_Out__c = true;
                if(getRand(0,2) != 0)
                app.COP_Preference_Member__c = appMemberMap.get(app.Id)[getRand(0,appMemberMap.get(app.Id).size() - 1)].Id;
            }
            //DTHP
            if(getRand(0,10) > 3) {
                app.DTHP_Preference_Manual__c = prefManual[getRand(0,3)]; 
                if(getRand(0,3) == 0)
                    app.DTHP_Opt_Out__c = true;
                if(getRand(0,2) != 0)
                app.DTHP_Preference_Member__c = appMemberMap.get(app.Id)[getRand(0,appMemberMap.get(app.Id).size() - 1)].Id;
            }
            //NRHP
            if(getRand(0,10) > 6) {
                app.Neighborhood_Preference_Manual__c = NRHPManual[getRand(0,3)];  
                if(getRand(0,3) == 0)
                    app.NRHP_Opt_Out__c = true;
                if(getRand(0,2) != 0)
                app.Neighborhood_Preference_Member__c = appMemberMap.get(app.Id)[getRand(0,appMemberMap.get(app.Id).size() - 1)].Id;
            }
            //Live/Work
            if(getRand(0,10) > 6) {
                app.Live_Work_Preference_Paper__c = (getRand(0,10) > 8) ? true : false; 
                if(getRand(0,4) == 0)
                    app.Live_Work_Opt_Out__c = true;
                if(getRand(0,1) == 0)
                app.Live_in_SF_Preference_Member__c = appMemberMap.get(app.Id)[getRand(0,appMemberMap.get(app.Id).size() - 1)].Id;
                if(getRand(0,1) == 0)
                app.Work_in_SF_Preference_Member__c = appMemberMap.get(app.Id)[getRand(0,appMemberMap.get(app.Id).size() - 1)].Id;
            }
            app.Is_Migrated__c = true;
        }
        Database.update(appList,false);
    }

}