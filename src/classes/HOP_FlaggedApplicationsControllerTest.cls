// *****************************************************************************
// CLASS: HOP_FlaggedApplicationsControllerTest
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Test class for the HOP_FlaggedApplicationsController class.
//
// *****************************************************************************

@isTest
private class HOP_FlaggedApplicationsControllerTest {
	
	@isTest
	static void HOP_FlaggedApplicationsControllerTest() {
		Test.startTest();
			HOP_FlaggedApplicationsController cnt = new HOP_FlaggedApplicationsController();
			System.assert(cnt.myUser != null);
		Test.stopTest();
	}
	
}