@isTest
private without sharing class ActivateUsersScriptTest {
	
    @isTest
	static void testSandboxPostCopyScript() {
		
		ActivateUsersScript script = new ActivateUsersScript();
		
		Test.testSandboxPostCopyScript(script,  UserInfo.getOrganizationId(),  UserInfo.getOrganizationId(), 'full');
		
	}
}