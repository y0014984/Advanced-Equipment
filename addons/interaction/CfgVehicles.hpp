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

			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "lamp 1";
					selection = "light_1_pitch";

					class AE3_Animation_Main
					{
						description = "extend lamp 1";
						animation = "Light_1_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "pitch lamp 1";
						animation = "Light_1_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "yaw lamp 1";
						animation = "Light_1_yaw_source";
						minValue = -90;
						maxValue = 90;
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

			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "lamp 1";
					selection = "light_1_pitch";

					class AE3_Animation_Main
					{
						description = "extend lamp 1";
						animation = "Light_1_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "pitch lamp 1";
						animation = "Light_1_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "yaw lamp 1";
						animation = "Light_1_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_1
				{
					description = "lamp 2";
					selection = "light_2_pitch";

					class AE3_Animation_Main
					{
						description = "extend lamp 2";
						animation = "Light_2_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "pitch lamp 2";
						animation = "Light_2_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "yaw lamp 2";
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
			
			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "lamp 1";
					selection = "light_1_pitch";

					class AE3_Animation_Main
					{
						description = "extend lamp 1";
						animation = "Light_1_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "pitch lamp 1";
						animation = "Light_1_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "yaw lamp 1";
						animation = "Light_1_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_1
				{
					description = "lamp 2";
					selection = "light_2_pitch";

					class AE3_Animation_Main
					{
						description = "extend lamp 2";
						animation = "Light_2_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "pitch lamp 2";
						animation = "Light_2_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "yaw lamp 2";
						animation = "Light_2_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_2
				{
					description = "lamp 3";
					selection = "light_3_pitch";

					class AE3_Animation_Main
					{
						description = "extend lamp 3";
						animation = "Light_3_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "pitch lamp 3";
						animation = "Light_3_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "yaw lamp 3";
						animation = "Light_3_yaw_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_3
				{
					description = "lamp 4";
					selection = "light_4_pitch";

					class AE3_Animation_Main
					{
						description = "extend lamp 4";
						animation = "Light_4_extend_source";
						minValue = 0;
						maxValue = 1;
						scrollMultiplier = 0.1;
					};

					class AE3_Animation_Modified_Ctrl
					{
						description = "pitch lamp 4";
						animation = "Light_4_pitch_source";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};

					class AE3_Animation_Modified_Alt
					{
						description = "yaw lamp 4";
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

	// Desk
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
			displayName = "Desk";

			closeState = 1;

			init = "_this call AE3_interaction_fnc_initDesk;";

			openAction = "_this call AE3_interaction_fnc_desk_addActionOpen;";
			closeAction = "_this call AE3_interaction_fnc_desk_addActionClose;";

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
};