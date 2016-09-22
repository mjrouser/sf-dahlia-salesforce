// *****************************************************************************
// CLASS: HOP_ControllerBase
// *****************************************************************************
//
// Author: Vertiba/Andu Andrei
// Date: 03/08/16
// Description: Base virtual class for all HOP controller classes.
//
// *****************************************************************************

public without sharing virtual class HOP_ControllerBase {

	// Current User's record is queried for the licence name and Account Id.
	// Available to all the controllers that implement this base class.
	public User myUser {get; set;}
	
	// Grants access to the following constants on all the controllers that implement this base class
	// The constants are used on several of the HOP pages
	public String COMMUNITY_LICENSE_NAME {get { return HOP_Constants.COMMUNITY_LICENSE_NAME; }}
	public String DRAFT_APPLICATION {get { return HOP_Constants.DRAFT_APPLICATION; }}
	public String PAPER_APPLICATION {get { return HOP_Constants.PAPER_APPLICATION; }}
	
	public HOP_ControllerBase() {
		// Queries the current User's licence name and Account Id
		myUser = [SELECT Id, Contact.AccountId, Profile.UserLicense.Name FROM User WHERE Id = :UserInfo.getUserId()];
	}
}