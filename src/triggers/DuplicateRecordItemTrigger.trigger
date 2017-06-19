// *****************************************************************************
// CLASS: DuplicateRecordItemTrigger
// *****************************************************************************
//
// Author: Vertiba/Jason Christman
// Date: 2016-07-13
// Description: Takes DuplicateRecordItems and gets processes them through the
//			  : ListingFlaggedApplicationAction class
// *****************************************************************************
// MODIFICATIONS:  NOTE MOD#, DATE of mod, who made the change and description
// *****************************************************************************
// 
// *****************************************************************************
trigger DuplicateRecordItemTrigger on DuplicateRecordItem (After insert, Before delete) {

    ListingFlaggedApplicationAction.runHandler();       
    
}