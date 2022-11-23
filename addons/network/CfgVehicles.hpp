class CfgVehicles 
{
	// ROUTER
	class Land_Router_01_sand_F;
	class Land_Router_01_sand_F_AE3: Land_Router_01_sand_F
	{
        // Carrying
        ace_dragging_canCarry = 1;  // Can be carried (0-no, 1-yes)
        ace_dragging_carryPosition[] = {0, 1, 1};  // Offset of the model from the body while dragging (same as attachTo)
        ace_dragging_carryDirection = 0;  // Model direction while dragging (same as setDir after attachTo)

		// Cargo
        ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
        ace_cargo_size = 1;  // Cargo space the object takes


		class AE3_Device
		{
			displayName = "$STR_AE3_Network_Config_RouterDisplayName";
			init = "_this call AE3_network_fnc_initRouter;";

			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_network_fnc_dhcp_onTurnOn; true";
			turnOffAction = "true";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.01/3600; // consumes 10 Watts
			};
		};

	};

};