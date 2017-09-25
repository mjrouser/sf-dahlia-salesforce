// *****************************************************************************
// CLASS: HOP_ListingsControllerTest
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Test class for the HOP_ListingsController class.
//
// *****************************************************************************

@isTest
private class HOP_ListingsControllerTest {
	
	@isTest
	static void HOP_ListingsControllerTest() {
		Test.startTest();
			HOP_ListingsController cnt = new HOP_ListingsController();
			System.assert(cnt.myUser != null);
		Test.stopTest();
	}
	
}