class CfgVehicles 
{
	/* ================================================================================ */

	class Land_PortableLight_single_F;

	class Land_PortableLight_single_F_AE3: Land_PortableLight_single_F
	{
		// Dragging
        ace_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
        ace_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
        ace_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)

		// Cargo
        ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
        ace_cargo_size = 2;  // Cargo space the object takes

		class AE3_Device
		{
			init = "params['_entity']; [_entity] call AE3_interaction_fnc_initLamp;";

			displayName = "Lamp";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_addActionTurnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_addActionTurnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.03/3600;
			};
		};
	};

	/* ================================================================================ */
	
	class Land_PortableLight_double_F;

	class Land_PortableLight_double_F_AE3: Land_PortableLight_double_F
	{
		// Dragging
        ace_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
        ace_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
        ace_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)

		// Cargo
        ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
        ace_cargo_size = 2;  // Cargo space the object takes

		class AE3_Device
		{
			init = "params['_entity']; [_entity] call AE3_interaction_fnc_initLamp;";

			displayName = "Lamp";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_addActionTurnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_addActionTurnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.06/3600;
			};
		};
	};

	/* ================================================================================ */

	class Land_PortableLight_02_single_sand_F;

	class Land_PortableLight_02_single_sand_F_AE3: Land_PortableLight_02_single_sand_F
	{
		// Carrying
		ace_dragging_canCarry = 1;  // Can be carried (0-no, 1-yes)
        ace_dragging_carryPosition[] = {0, 1, 1};  // Offset of the model from the body while dragging (same as attachTo)
        ace_dragging_carryDirection = 0;  // Model direction while dragging (same as setDir after attachTo)

		// Cargo
        ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
        ace_cargo_size = 1;  // Cargo space the object takes

		class AE3_Equipment
		{
			displayName = "Lamp";

			animatableLampsCount = 1;

			class AE3_aceWorkaround
			{
				class AE3_aceCarrying
				{
					// Carrying
					ae3_dragging_canCarry = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_carryPosition[] = {0, 1, 1};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_carryDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
			};
		};

		class AE3_Device
		{
			init = "params['_entity']; [_entity] call AE3_interaction_fnc_initLamp;";

			displayName = "Lamp";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_addActionTurnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_addActionTurnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.025/3600;
			};
		};

		class EventHandlers
		{
			init = "_this call AE3_interaction_fnc_compileEquipment; _this call AE3_power_fnc_compileDevice;";
		};
	};

	/* ================================================================================ */

	class Land_PortableLight_02_double_sand_F;

	class Land_PortableLight_02_double_sand_F_AE3: Land_PortableLight_02_double_sand_F
	{
		// Dragging
        ace_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
        ace_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
        ace_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)

		// Cargo
        ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
        ace_cargo_size = 2;  // Cargo space the object takes

		class AE3_Equipment
		{
			displayName = "Lamp";

			animatableLampsCount = 2;

			class AE3_aceWorkaround
			{
				class AE3_aceDragging
				{
					// Dragging
					ae3_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
			};
		};

		class AE3_Device
		{
			init = "params['_entity']; [_entity] call AE3_interaction_fnc_initLamp;";

			displayName = "Lamp";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_addActionTurnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_addActionTurnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.05/3600;
			};
		};

		class EventHandlers
		{
			init = "_this call AE3_interaction_fnc_compileEquipment; _this call AE3_power_fnc_compileDevice;";
		};
	};

	/* ================================================================================ */

	class Land_PortableLight_02_quad_sand_F;

	class Land_PortableLight_02_quad_sand_F_AE3: Land_PortableLight_02_quad_sand_F
	{
		// Dragging
        ace_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
        ace_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
        ace_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)

		// Cargo
        ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
        ace_cargo_size = 2;  // Cargo space the object takes

		class AE3_Equipment
		{
			displayName = "Lamp";
			
			animatableLampsCount = 4;

			class AE3_aceWorkaround
			{
				class AE3_aceDragging
				{
					// Dragging
					ae3_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
			};
		};

		class AE3_Device
		{
			init = "params['_entity']; [_entity] call AE3_interaction_fnc_initLamp;";

			displayName = "Lamp";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_addActionTurnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_addActionTurnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.1/3600;
			};
		};

		class EventHandlers
		{
			init = "_this call AE3_interaction_fnc_compileEquipment; _this call AE3_power_fnc_compileDevice;";
		};
	};

	/* ================================================================================ */
};