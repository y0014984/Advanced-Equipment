class CfgVehicles 
{
	/* ---------------------------------------- */

	// CHAIR
	class Land_DeskChair_01_sand_F;
	class Land_DeskChair_01_sand_F_AE3: Land_DeskChair_01_sand_F
	{
		//Sitting
        acex_sitting_canSit = 1;  // Enable sitting
		acex_sitting_interactPosition[] = {0, 0, 0.3}; 
        acex_sitting_sitDirection = 180;  // Direction relative to object
        acex_sitting_sitPosition[] = {0, -0.18, -0.45};  // Position relative to object (may behave weird with certain objects)
	
        // Carrying
        ace_dragging_canCarry = 1;  // Can be carried (0-no, 1-yes)
        ace_dragging_carryPosition[] = {0, 1, 1};  // Offset of the model from the body while dragging (same as attachTo)
        ace_dragging_carryDirection = 180;  // Model direction while dragging (same as setDir after attachTo)
		
		// Cargo
        ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
        ace_cargo_size = 1;  // Cargo space the object takes
	};

	/* ---------------------------------------- */	
};