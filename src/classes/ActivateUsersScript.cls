global class ActivateUsersScript  implements SandboxPostCopy{
    /*
   email =  aissia.ashoori=sfgov.org@example.com
    aissia.ashoori@sfgov.org.full
    */
    //username to email
    global static Map<String,String> updateUserList = new Map<String,String>{
    	//'luke.lim@vertiba.com',
    	'mohcd+prod@vertiba.com' => 'mohcd@vertiba.com',		
    	'dave@exygy.com' => 'dahlia@exygy.com',	  
    	'ashley.meyers@sfgov.org' => 'ashley.meyers@sfgov.org',
    	'kmoran@vertiba.com.sf' => 'kmoran@vertiba.com',
    	'michael.solomon@sfgov.org' =>'michael.solomon@sfgov.org' 
    	
    };
    
    global void runApexClass(SandboxContext context) {
		context.sandboxName();
		updateUsernames(context.sandboxName());
    }
    global static void updateUsernames(String sandBoxName) {
		
		Map<String,String> newUserList  = new Map<String,String>();
		for (String userName: updateUserList.keySet() ) { 
			newUserList.put( userName+'.'+sandBoxName.toLowerCase(),updateUserList.get(userName) );
		}
		system.debug ('new users' + newUserList);
				system.debug ('new users' + newUserList);
		
		List<User> userstoUpdate= [select username, email from user where username in :newUserList.keyset() ];
				system.debug ('userlist users' + userstoUpdate);
		
		for (User user: userstoUpdate) {
			user.email = newUserList.get(user.username);
			user.isActive=true;
		}
		system.debug ('userlist users' + userstoUpdate);
		
		update userstoUpdate;
    } 
    
}