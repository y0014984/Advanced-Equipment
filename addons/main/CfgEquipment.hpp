class CfgVehicles 
{
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
	class Land_PortableGenerator_01_sand_F;
	class Land_PortableGenerator_01_sand_F_AE3: Land_PortableGenerator_01_sand_F
	{
		// Dragging
        ace_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
        ace_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
        ace_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
		
		// Cargo
        ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
        ace_cargo_size = 4;  // Cargo space the object takes

		// Refuel
        ace_refuel_canReceive = 1; // For vehicles which can't be refueled
        ace_refuel_fuelCapacity = 30; // Fuel tank volume

		// Event Handlers
		class EventHandlers
		{
			init = "params ['_entity']; call compile preprocessFileLineNumbers '\z\ae3\addons\main\init\initGenerator.sqf';";
		};
        class ACE_Actions 
		{
			class ACE_MainActions
			{
				displayName = "Interaktionen";
				condition = "true";
				distance = 2;
				class AE3_Generator_Group
				{
					displayName = "Generator";
					condition = "true";
					class AE3_TurnOn
					{
						displayName = "Turn On";
						condition = "(alive _target) and (_target getVariable 'AE3_powerState' != 1)";
						statement = "params ['_target', '_player', '_params']; _handle = [_target] execVM '\z\ae3\addons\main\scripts\TurnOnGeneratorAction.sqf';";
						//icon = "\z\dance.paa";
						exceptions[] = {};
						//insertChildren
						//modifierFunction
						//runOnHover
						//distance
						//position
						//selection
						priority = -1;
						showDisabled = 0;
					};
					class AE3_TurnOff
					{
						displayName = "Turn Off";
						condition = "(alive _target) and (_target getVariable 'AE3_powerState' != 0)";
						statement = "params ['_target', '_player', '_params']; _handle = [_target, false] execVM '\z\ae3\addons\main\scripts\TurnOffGeneratorAction.sqf';";
						//icon = "\z\dance.paa";
						exceptions[] = {};
						//insertChildren
						//modifierFunction
						//runOnHover
						//distance
						//position
						//selection
						priority = -1;
						showDisabled = 0;
					};
				};
			};
		};
	};
	class Land_Laptop_03_sand_F;
	class Land_Laptop_03_sand_F_AE3: Land_Laptop_03_sand_F
	{
        // Carrying
        ace_dragging_canCarry = 1;  // Can be carried (0-no, 1-yes)
        ace_dragging_carryPosition[] = {0, 1, 1};  // Offset of the model from the body while dragging (same as attachTo)
        ace_dragging_carryDirection = 0;  // Model direction while dragging (same as setDir after attachTo)

		// Cargo
        ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
        ace_cargo_size = 1;  // Cargo space the object takes

		// Event Handlers
		class EventHandlers
		{
			init = "params ['_entity']; call compile preprocessFileLineNumbers '\z\ae3\addons\main\init\initLaptop.sqf';";
		};

		ae3_power_hasBattery = 1;
		ae3_power_batteryCapacity = 100;
		ae3_power_powerConsumptionOn = 10;
		ae3_power_powerConsumptionStandBy = 0.1;
		ae3_power_recharging = 50;
		ae3_power_defaultPowerLevel = 1;

        class ACE_Actions 
		{
			class ACE_MainActions
			{
				displayName = "Interaktionen";
				condition = "true";
				distance = 2;
				class AE3_Laptop_Group
				{
					displayName = "Laptop";
					condition = "true";
					class AE3_UseComputer
					{
						displayName = "Use Computer";
						condition = "(alive _target) and (_target getVariable 'AE3_powerState' == 2)";
						statement = "params ['_target', '_player', '_params']; _handle = [_target] execVM '\z\ae3\addons\main\scripts\UseComputerAction.sqf';";
						//icon = "\z\dance.paa";
						exceptions[] = {};
						//insertChildren
						//modifierFunction
						//runOnHover
						//distance
						//position
						//selection
						priority = -1;
						showDisabled = 0;
					};
					class AE3_CheckBatteryLevel
					{
						displayName = "Check Battery Level";
						condition = "alive _target";
						statement = "params ['_target', '_player', '_params']; _handle = [_target] execVM '\z\ae3\addons\main\scripts\CheckBatteryLevelAction.sqf';";
						//icon = "\z\dance.paa";
						exceptions[] = {};
						//insertChildren
						//modifierFunction
						//runOnHover
						//distance
						//position
						//selection
						priority = -1;
						showDisabled = 0;
					};
					class AE3_ConnectToGenerator
					{
						displayName = "Connect To Generator";
						condition = "(alive _target) and (count (nearestObjects [_target, ['Land_PortableGenerator_01_sand_F'], 10]) > 0)";
						statement = "";
						//icon = "\z\dance.paa";
						exceptions[] = {};
						insertChildren = "params ['_target', '_player', '_params']; _generators = nearestObjects [_target, ['Land_PortableGenerator_01_sand_F'], 10]; private _actions = []; { private _childStatement = { params ['_target', '_player', '_generator']; _handle = [_target, _generator] execVM '\z\ae3\addons\main\scripts\ConnectToGeneratorAction.sqf'; }; private _action = [typeOf _x, typeOf _x, '', _childStatement, {true}, {}, _x] call ace_interact_menu_fnc_createAction; _actions pushBack [_action, [], _target]; } forEach (_generators); _actions";
						//modifierFunction
						//runOnHover
						//distance
						//position
						//selection
						priority = -1;
						showDisabled = 0;
					};
					class AE3_TurnOn
					{
						displayName = "Turn On";
						condition = "(alive _target) and (_target getVariable 'AE3_powerState' != 2)";
						statement = "params ['_target', '_player', '_params']; _handle = [_target] execVM '\z\ae3\addons\main\scripts\TurnOnComputerAction.sqf';";
						//icon = "\z\dance.paa";
						exceptions[] = {};
						//insertChildren
						//modifierFunction
						//runOnHover
						//distance
						//position
						//selection
						priority = -1;
						showDisabled = 0;
					};
					class AE3_TurnOff
					{
						displayName = "Turn Off";
						condition = "(alive _target) and (_target getVariable 'AE3_powerState' != 0)";
						statement = "params ['_target', '_player', '_params']; _handle = [_target, false] execVM '\z\ae3\addons\main\scripts\TurnOffComputerAction.sqf';";
						//icon = "\z\dance.paa";
						exceptions[] = {};
						//insertChildren
						//modifierFunction
						//runOnHover
						//distance
						//position
						//selection
						priority = -1;
						showDisabled = 0;
					};
					class AE3_Standby
					{
						displayName = "Standby";
						condition = "(alive _target) and (_target getVariable 'AE3_powerState' == 2)";
						statement = "params ['_target', '_player', '_params']; _handle = [_target] execVM '\z\ae3\addons\main\scripts\StandbyComputerAction.sqf';";
						//icon = "\z\dance.paa";
						exceptions[] = {};
						//insertChildren
						//modifierFunction
						//runOnHover
						//distance
						//position
						//selection
						priority = -1;
						showDisabled = 0;
					};
				};
			};
		};
	};
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
		
		// Event Handlers
		class EventHandlers
		{
			init = "params ['_entity']; _entity setVariable ['OpenClosedState', 0, true];";
		};

		// Interaction
        class ACE_Actions 
		{
			class ACE_MainActions
			{
				displayName = "Interaktionen";
				condition = "true";
				distance = 2;
				class AE3_Asseble_Group
				{
					displayName = "Tisch";
					condition = "true";
					class AE3_Disassemble 
					{
						displayName = "Einpacken";
						condition = "(alive _target) and (_target getVariable 'OpenClosedState' == 1)";
						statement = "params ['_target', '_player', '_params']; _handle = [_target, 1, 0.5] execVM '\z\ae3\addons\main\scripts\OpenCloseTableAction.sqf';";
						//icon = "\z\dance.paa";
						exceptions[] = {};
						//insertChildren
						//modifierFunction
						//runOnHover
						//distance
						//position
						//selection
						priority = -1;
						showDisabled = 0;
					};
					class AE3_Assemble 
					{
						displayName = "Auspacken";
						condition = "(alive _target) and (_target getVariable 'OpenClosedState' == 0)";
						statement = "params ['_target', '_player', '_params'];_handle = [_target, 0, 0.5] execVM '\z\ae3\addons\main\scripts\OpenCloseTableAction.sqf';";
						//icon = "\z\dance.paa";
						exceptions[] = {};
						//insertChildren
						//modifierFunction
						//runOnHover
						//distance
						//position
						//selection
						priority = -1;
						showDisabled = 0;
					};
				};
			};
		};
	};
};

/* ================================================================================ */