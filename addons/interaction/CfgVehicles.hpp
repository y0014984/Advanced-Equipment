class CfgVehicles 
{
	/* ================================================================================ */

	class Land_PortableLight_single_F;
	class Land_PortableLight_single_F_AE3: Land_PortableLight_single_F
	{
		// Carrying
		ace_dragging_canCarry = 0;  // Can be carried (0-no, 1-yes)

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

			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_turnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_turnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.15/3600; // consumes 150 Watts
			};
		};
	};

	/* ================================================================================ */
	
 	class Land_PortableLight_double_F;
	class Land_PortableLight_double_F_AE3: Land_PortableLight_double_F
	{
        // Carrying
        ace_dragging_canCarry = 0;  // Can be carried (0-no, 1-yes)
		
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

			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_turnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_turnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.3/3600; // consumes 300 Watts
			};
		};
	};

	/* ================================================================================ */

	// RUGGED LAMP SINGLE YELLOW
 	class Land_PortableLight_02_single_yellow_F;
	class Land_PortableLight_02_single_yellow_F_AE3: Land_PortableLight_02_single_yellow_F
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
			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";

			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "$STR_AE3_Interaction_Config_Lamp1";
					selection = "light_1_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp1";
						animation = "Light_1_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp1";
						animation = "Light_1_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp1";
						animation = "Light_1_yaw_source";
						minValue = -180;
						maxValue = 180;
						scrollMultiplier = 10;
					};
				};
			};

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

			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_turnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_turnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.025/3600; // 25 Watts (1x 25 Watts)
			};
		};

		class EventHandlers
		{
			init = "_this call AE3_interaction_fnc_compileEquipment; _this call AE3_power_fnc_compileDevice;";
		};
	};

	/* ================================================================================ */

	// RUGGED LAMP SINGLE OLIVE
 	class Land_PortableLight_02_single_olive_F;
	class Land_PortableLight_02_single_olive_F_AE3: Land_PortableLight_02_single_olive_F
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
			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";

			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "$STR_AE3_Interaction_Config_Lamp1";
					selection = "light_1_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp1";
						animation = "Light_1_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp1";
						animation = "Light_1_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp1";
						animation = "Light_1_yaw_source";
						minValue = -180;
						maxValue = 180;
						scrollMultiplier = 10;
					};
				};
			};

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

			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_turnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_turnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.025/3600; // 25 Watts (1x 25 Watts)
			};
		};

		class EventHandlers
		{
			init = "_this call AE3_interaction_fnc_compileEquipment; _this call AE3_power_fnc_compileDevice;";
		};
	};

	/* ================================================================================ */

	// RUGGED LAMP SINGLE BLACK
 	class Land_PortableLight_02_single_black_F;
	class Land_PortableLight_02_single_black_F_AE3: Land_PortableLight_02_single_black_F
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
			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";

			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "$STR_AE3_Interaction_Config_Lamp1";
					selection = "light_1_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp1";
						animation = "Light_1_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp1";
						animation = "Light_1_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp1";
						animation = "Light_1_yaw_source";
						minValue = -180;
						maxValue = 180;
						scrollMultiplier = 10;
					};
				};
			};

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

			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_turnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_turnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.025/3600; // 25 Watts (1x 25 Watts)
			};
		};

		class EventHandlers
		{
			init = "_this call AE3_interaction_fnc_compileEquipment; _this call AE3_power_fnc_compileDevice;";
		};
	};

	/* ================================================================================ */

	// RUGGED LAMP SINGLE SAND
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
			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";

			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "$STR_AE3_Interaction_Config_Lamp1";
					selection = "light_1_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp1";
						animation = "Light_1_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp1";
						animation = "Light_1_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp1";
						animation = "Light_1_yaw_source";
						minValue = -180;
						maxValue = 180;
						scrollMultiplier = 10;
					};
				};
			};

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

			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_turnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_turnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.025/3600; // 25 Watts (1x 25 Watts)
			};
		};

		class EventHandlers
		{
			init = "_this call AE3_interaction_fnc_compileEquipment; _this call AE3_power_fnc_compileDevice;";
		};
	};

	/* ================================================================================ */

	// RUGGED LAMP DOUBLE YELLOW
	class Land_PortableLight_02_double_yellow_F;
	class Land_PortableLight_02_double_yellow_F_AE3: Land_PortableLight_02_double_yellow_F
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
			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";

			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "$STR_AE3_Interaction_Config_Lamp1";
					selection = "light_1_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp1";
						animation = "Light_1_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp1";
						animation = "Light_1_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp1";
						animation = "Light_1_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_1
				{
					description = "$STR_AE3_Interaction_Config_Lamp2";
					selection = "light_2_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp2";
						animation = "Light_2_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp2";
						animation = "Light_2_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp2";
						animation = "Light_2_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};
			};

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

			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_turnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_turnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.05/3600; // 50 Watts (2x 25 Watts)
			};
		};

		class EventHandlers
		{
			init = "_this call AE3_interaction_fnc_compileEquipment; _this call AE3_power_fnc_compileDevice;";
		};
	};

	/* ================================================================================ */

	// RUGGED LAMP DOUBLE OLIVE
	class Land_PortableLight_02_double_olive_F;
	class Land_PortableLight_02_double_olive_F_AE3: Land_PortableLight_02_double_olive_F
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
			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";

			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "$STR_AE3_Interaction_Config_Lamp1";
					selection = "light_1_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp1";
						animation = "Light_1_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp1";
						animation = "Light_1_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp1";
						animation = "Light_1_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_1
				{
					description = "$STR_AE3_Interaction_Config_Lamp2";
					selection = "light_2_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp2";
						animation = "Light_2_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp2";
						animation = "Light_2_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp2";
						animation = "Light_2_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};
			};

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

			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_turnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_turnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.05/3600; // 50 Watts (2x 25 Watts)
			};
		};

		class EventHandlers
		{
			init = "_this call AE3_interaction_fnc_compileEquipment; _this call AE3_power_fnc_compileDevice;";
		};
	};

	/* ================================================================================ */

	// RUGGED LAMP DOUBLE BLACK
	class Land_PortableLight_02_double_black_F;
	class Land_PortableLight_02_double_black_F_AE3: Land_PortableLight_02_double_black_F
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
			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";

			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "$STR_AE3_Interaction_Config_Lamp1";
					selection = "light_1_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp1";
						animation = "Light_1_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp1";
						animation = "Light_1_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp1";
						animation = "Light_1_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_1
				{
					description = "$STR_AE3_Interaction_Config_Lamp2";
					selection = "light_2_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp2";
						animation = "Light_2_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp2";
						animation = "Light_2_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp2";
						animation = "Light_2_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};
			};

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

			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_turnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_turnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.05/3600; // 50 Watts (2x 25 Watts)
			};
		};

		class EventHandlers
		{
			init = "_this call AE3_interaction_fnc_compileEquipment; _this call AE3_power_fnc_compileDevice;";
		};
	};

	/* ================================================================================ */

	// RUGGED LAMP DOUBLE SAND
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
			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";

			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "$STR_AE3_Interaction_Config_Lamp1";
					selection = "light_1_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp1";
						animation = "Light_1_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp1";
						animation = "Light_1_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp1";
						animation = "Light_1_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_1
				{
					description = "$STR_AE3_Interaction_Config_Lamp2";
					selection = "light_2_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp2";
						animation = "Light_2_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp2";
						animation = "Light_2_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp2";
						animation = "Light_2_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};
			};

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

			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_turnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_turnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.05/3600; // 50 Watts (2x 25 Watts)
			};
		};

		class EventHandlers
		{
			init = "_this call AE3_interaction_fnc_compileEquipment; _this call AE3_power_fnc_compileDevice;";
		};
	};

	/* ================================================================================ */

	// RUGGED LAMP QUAD YELLOW
	class Land_PortableLight_02_quad_yellow_F;
	class Land_PortableLight_02_quad_yellow_F_AE3: Land_PortableLight_02_quad_yellow_F
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
			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			
			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "$STR_AE3_Interaction_Config_Lamp1";
					selection = "light_1_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp1";
						animation = "Light_1_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp1";
						animation = "Light_1_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp1";
						animation = "Light_1_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_1
				{
					description = "$STR_AE3_Interaction_Config_Lamp2";
					selection = "light_2_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp2";
						animation = "Light_2_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp2";
						animation = "Light_2_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp2";
						animation = "Light_2_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_2
				{
					description = "$STR_AE3_Interaction_Config_Lamp3";
					selection = "light_3_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp3";
						animation = "Light_3_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp3";
						animation = "Light_3_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp3";
						animation = "Light_3_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_3
				{
					description = "$STR_AE3_Interaction_Config_Lamp4";
					selection = "light_4_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp4";
						animation = "Light_4_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp4";
						animation = "Light_4_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp4";
						animation = "Light_4_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};
			};

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

			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_turnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_turnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.1/3600; // 100 Watts (4x 25 Watts)
			};
		};

		class EventHandlers
		{
			init = "_this call AE3_interaction_fnc_compileEquipment; _this call AE3_power_fnc_compileDevice;";
		};
	};

	/* ================================================================================ */

	// RUGGED LAMP QUAD OLIVE
	class Land_PortableLight_02_quad_olive_F;
	class Land_PortableLight_02_quad_olive_F_AE3: Land_PortableLight_02_quad_olive_F
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
			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			
			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "$STR_AE3_Interaction_Config_Lamp1";
					selection = "light_1_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp1";
						animation = "Light_1_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp1";
						animation = "Light_1_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp1";
						animation = "Light_1_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_1
				{
					description = "$STR_AE3_Interaction_Config_Lamp2";
					selection = "light_2_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp2";
						animation = "Light_2_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp2";
						animation = "Light_2_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp2";
						animation = "Light_2_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_2
				{
					description = "$STR_AE3_Interaction_Config_Lamp3";
					selection = "light_3_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp3";
						animation = "Light_3_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp3";
						animation = "Light_3_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp3";
						animation = "Light_3_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_3
				{
					description = "$STR_AE3_Interaction_Config_Lamp4";
					selection = "light_4_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp4";
						animation = "Light_4_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp4";
						animation = "Light_4_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp4";
						animation = "Light_4_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};
			};

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

			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_turnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_turnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.1/3600; // 100 Watts (4x 25 Watts)
			};
		};

		class EventHandlers
		{
			init = "_this call AE3_interaction_fnc_compileEquipment; _this call AE3_power_fnc_compileDevice;";
		};
	};

	/* ================================================================================ */

	// RUGGED LAMP QUAD BLACK
	class Land_PortableLight_02_quad_black_F;
	class Land_PortableLight_02_quad_black_F_AE3: Land_PortableLight_02_quad_black_F
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
			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			
			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "$STR_AE3_Interaction_Config_Lamp1";
					selection = "light_1_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp1";
						animation = "Light_1_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp1";
						animation = "Light_1_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp1";
						animation = "Light_1_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_1
				{
					description = "$STR_AE3_Interaction_Config_Lamp2";
					selection = "light_2_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp2";
						animation = "Light_2_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp2";
						animation = "Light_2_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp2";
						animation = "Light_2_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_2
				{
					description = "$STR_AE3_Interaction_Config_Lamp3";
					selection = "light_3_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp3";
						animation = "Light_3_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp3";
						animation = "Light_3_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp3";
						animation = "Light_3_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_3
				{
					description = "$STR_AE3_Interaction_Config_Lamp4";
					selection = "light_4_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp4";
						animation = "Light_4_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp4";
						animation = "Light_4_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp4";
						animation = "Light_4_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};
			};

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

			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_turnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_turnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.1/3600; // 100 Watts (4x 25 Watts)
			};
		};

		class EventHandlers
		{
			init = "_this call AE3_interaction_fnc_compileEquipment; _this call AE3_power_fnc_compileDevice;";
		};
	};

	/* ================================================================================ */

	// RUGGED LAMP QUAD SAND
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
			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			
			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "$STR_AE3_Interaction_Config_Lamp1";
					selection = "light_1_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp1";
						animation = "Light_1_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp1";
						animation = "Light_1_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp1";
						animation = "Light_1_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_1
				{
					description = "$STR_AE3_Interaction_Config_Lamp2";
					selection = "light_2_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp2";
						animation = "Light_2_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp2";
						animation = "Light_2_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp2";
						animation = "Light_2_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_2
				{
					description = "$STR_AE3_Interaction_Config_Lamp3";
					selection = "light_3_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp3";
						animation = "Light_3_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp3";
						animation = "Light_3_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp3";
						animation = "Light_3_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_3
				{
					description = "$STR_AE3_Interaction_Config_Lamp4";
					selection = "light_4_pitch";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Interaction_Config_ExtendLamp4";
						animation = "Light_4_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "$STR_AE3_Interaction_Config_PitchLamp4";
						animation = "Light_4_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "$STR_AE3_Interaction_Config_YawLamp4";
						animation = "Light_4_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};
			};

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

			displayName = "$STR_AE3_Interaction_Config_LampDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_interaction_fnc_lamp_turnOn";
			turnOffAction = "_this call AE3_interaction_fnc_lamp_turnOff";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.1/3600; // 100 Watts (4x 25 Watts)
			};
		};

		class EventHandlers
		{
			init = "_this call AE3_interaction_fnc_compileEquipment; _this call AE3_power_fnc_compileDevice;";
		};
	};

	/* ================================================================================ */

	// RUGGED DESK OLIVE
	class Land_PortableDesk_01_olive_F;
	class Land_PortableDesk_01_olive_F_AE3: Land_PortableDesk_01_olive_F
	{
		// Dragging
		ace_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
		ace_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
		ace_dragging_dragDirection = 90;  // Model direction while dragging (same as setDir after attachTo)
		
		// Cargo
		ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
		ace_cargo_size = 4;  // Cargo space the object takes

		class AE3_Equipment
		{
			displayName = "$STR_AE3_Interaction_Config_DeskDisplayName";

			closeState = 0;

			init = "_this call AE3_interaction_fnc_initDesk;";

			openAction = "_this call AE3_interaction_fnc_start_desk_open;";
			closeAction = "_this call AE3_interaction_fnc_start_desk_close;";

			class AE3_Animations
			{
				/*
				class AE3_Animation_Point_0
				{
					description = "drawer 1";
					selection = "drawer_1";

					class AE3_Animation_Main
					{
						description = "open/close drawer 1";
						animation = "Drawer_1_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				class AE3_Animation_Point_1
				{
					description = "drawer 2";
					selection = "drawer_2";

					class AE3_Animation_Main
					{
						description = "open/close drawer 2";
						animation = "Drawer_2_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				class AE3_Animation_Point_2
				{
					description = "drawer 3";
					selection = "drawer_3";

					class AE3_Animation_Main
					{
						description = "open/close drawer 3";
						animation = "Drawer_3_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				class AE3_Animation_Point_3
				{
					description = "drawer 4";
					selection = "drawer_4";

					class AE3_Animation_Main
					{
						description = "open/close drawer 4";
						animation = "Drawer_4_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				class AE3_Animation_Point_4
				{
					description = "drawer 5";
					selection = "drawer_5";

					class AE3_Animation_Main
					{
						description = "open/close drawer 5";
						animation = "Drawer_5_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				class AE3_Animation_Point_5
				{
					description = "drawer 6";
					selection = "drawer_6";

					class AE3_Animation_Main
					{
						description = "open/close drawer 6";
						animation = "Drawer_6_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				*/
			};
		};
	};

	/* ================================================================================ */

	// RUGGED DESK BLACK
	class Land_PortableDesk_01_black_F;
	class Land_PortableDesk_01_black_F_AE3: Land_PortableDesk_01_black_F
	{
		// Dragging
		ace_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
		ace_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
		ace_dragging_dragDirection = 90;  // Model direction while dragging (same as setDir after attachTo)
		
		// Cargo
		ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
		ace_cargo_size = 4;  // Cargo space the object takes

		class AE3_Equipment
		{
			displayName = "$STR_AE3_Interaction_Config_DeskDisplayName";

			closeState = 0;

			init = "_this call AE3_interaction_fnc_initDesk;";

			openAction = "_this call AE3_interaction_fnc_start_desk_open;";
			closeAction = "_this call AE3_interaction_fnc_start_desk_close;";

			class AE3_Animations
			{
				/*
				class AE3_Animation_Point_0
				{
					description = "drawer 1";
					selection = "drawer_1";

					class AE3_Animation_Main
					{
						description = "open/close drawer 1";
						animation = "Drawer_1_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				class AE3_Animation_Point_1
				{
					description = "drawer 2";
					selection = "drawer_2";

					class AE3_Animation_Main
					{
						description = "open/close drawer 2";
						animation = "Drawer_2_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				class AE3_Animation_Point_2
				{
					description = "drawer 3";
					selection = "drawer_3";

					class AE3_Animation_Main
					{
						description = "open/close drawer 3";
						animation = "Drawer_3_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				class AE3_Animation_Point_3
				{
					description = "drawer 4";
					selection = "drawer_4";

					class AE3_Animation_Main
					{
						description = "open/close drawer 4";
						animation = "Drawer_4_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				class AE3_Animation_Point_4
				{
					description = "drawer 5";
					selection = "drawer_5";

					class AE3_Animation_Main
					{
						description = "open/close drawer 5";
						animation = "Drawer_5_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				class AE3_Animation_Point_5
				{
					description = "drawer 6";
					selection = "drawer_6";

					class AE3_Animation_Main
					{
						description = "open/close drawer 6";
						animation = "Drawer_6_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				*/
			};
		};
	};

	/* ================================================================================ */

	// RUGGED DESK SAND
	class Land_PortableDesk_01_sand_F;
	class Land_PortableDesk_01_sand_F_AE3: Land_PortableDesk_01_sand_F
	{
		// Dragging
		ace_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
		ace_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
		ace_dragging_dragDirection = 90;  // Model direction while dragging (same as setDir after attachTo)
		
		// Cargo
		ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
		ace_cargo_size = 4;  // Cargo space the object takes

		class AE3_Equipment
		{
			displayName = "$STR_AE3_Interaction_Config_DeskDisplayName";

			closeState = 0;

			init = "_this call AE3_interaction_fnc_initDesk;";

			openAction = "_this call AE3_interaction_fnc_start_desk_open;";
			closeAction = "_this call AE3_interaction_fnc_start_desk_close;";

			class AE3_Animations
			{
				/*
				class AE3_Animation_Point_0
				{
					description = "drawer 1";
					selection = "drawer_1";

					class AE3_Animation_Main
					{
						description = "open/close drawer 1";
						animation = "Drawer_1_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				class AE3_Animation_Point_1
				{
					description = "drawer 2";
					selection = "drawer_2";

					class AE3_Animation_Main
					{
						description = "open/close drawer 2";
						animation = "Drawer_2_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				class AE3_Animation_Point_2
				{
					description = "drawer 3";
					selection = "drawer_3";

					class AE3_Animation_Main
					{
						description = "open/close drawer 3";
						animation = "Drawer_3_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				class AE3_Animation_Point_3
				{
					description = "drawer 4";
					selection = "drawer_4";

					class AE3_Animation_Main
					{
						description = "open/close drawer 4";
						animation = "Drawer_4_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				class AE3_Animation_Point_4
				{
					description = "drawer 5";
					selection = "drawer_5";

					class AE3_Animation_Main
					{
						description = "open/close drawer 5";
						animation = "Drawer_5_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				class AE3_Animation_Point_5
				{
					description = "drawer 6";
					selection = "drawer_6";

					class AE3_Animation_Main
					{
						description = "open/close drawer 6";
						animation = "Drawer_6_move_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};
				};
				*/
			};
		};
	};

	/* ================================================================================ */

	// RUGGED CHAIR OLIVE
	class Land_DeskChair_01_olive_F;
	class Land_DeskChair_01_olive_F_AE3: Land_DeskChair_01_olive_F
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

	/* ================================================================================ */

	// RUGGED CHAIR BLACK
	class Land_DeskChair_01_black_F;
	class Land_DeskChair_01_black_F_AE3: Land_DeskChair_01_black_F
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

	/* ================================================================================ */

	// RUGGED CHAIR SAND
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

	/* ================================================================================ */
};