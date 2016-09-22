// *****************************************************************************
// CLASS: HOP_ControllerBaseTest
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 07/16
// Description: Test class for the HOP_ControllerBase class.
//
// *****************************************************************************

@isTest
private class HOP_ControllerBaseTest {
	
	@isTest
	static void HOP_ControllerBaseTest() {
		Test.startTest();
			HOP_ControllerBase cb = new HOP_ControllerBase();
			System.assert(cb.myUser != null);
		Test.stopTest();
	}
	
}