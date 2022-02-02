class CfgVehicles 
{
	class Land_PortableLight_single_F;

	class Land_PortableLight_single_F_AE3: Land_PortableLight_single_F
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
			init = "params['_entity']; [_entity] call AE3_lamp_fnc_initLamp;";

			displayName = "Lamp";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_lamp_fnc_onAction";
			turnOffAction = "_this call AE3_lamp_fnc_offAction";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.03;
			};
		};
	};

	
	class Land_PortableLight_double_F;

	class Land_PortableLight_double_F_AE3: Land_PortableLight_double_F
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
			init = "params['_entity']; [_entity] call AE3_lamp_fnc_initLamp;";

			displayName = "Lamp";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_lamp_fnc_onAction";
			turnOffAction = "_this call AE3_lamp_fnc_offAction";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.06;
			};
		};

		
	};
};