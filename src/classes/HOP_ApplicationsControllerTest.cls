// *****************************************************************************
// CLASS: HOP_ApplicationsControllerTest
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Test class for the HOP_ApplicationsController class.
//
// *****************************************************************************

@isTest
private class HOP_ApplicationsControllerTest {
	
	@isTest
	static void HOP_ApplicationsControllerTest() {
		Test.startTest();
			HOP_ApplicationsController cnt = new HOP_ApplicationsController();
			System.assert(cnt.myUser != null);
		Test.stopTest();
	}
	
}