// *****************************************************************************
// CLASS: HOP_DuplicateApplicationsControllerTest
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Test class for the HOP_DuplicateApplicationsController class.
//
// *****************************************************************************

@isTest
private class HOP_DuplicateApplicationsControllerTest {
	
	@isTest
	static void HOP_DuplicateApplicationsControllerTest() {
		Test.startTest();
			HOP_DuplicateApplicationsController cnt = new HOP_DuplicateApplicationsController();
			System.assert(cnt.myUser != null);
		Test.stopTest();
	}
	
}