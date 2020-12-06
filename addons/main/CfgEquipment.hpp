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

		class Attributes
		{
			// Attribute class, can be anything
			class AE3_ComputerPowerLevelPercent
			{
				//--- Mandatory properties
				displayName = "Computer Power Level"; // Name assigned to UI control class Title
				tooltip = "1 is full and 0 is empty"; // Tooltip assigned to UI control class Title
				property = "AE3ComputerPowerLevel"; // Unique config property name saved in SQM
				control = "Edit"; // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

				// Expression called when applying the attribute in Eden and at the scenario start
				// The expression is called twice - first for data validation, and second for actual saving
				// Entity is passed as _this, value is passed as _value
				// %s is replaced by attribute config name. It can be used only once in the expression
				// In MP scenario, the expression is called only on server.
				expression = "_this setVariable ['%s', _value, true];";

				// Expression called when custom property is undefined yet (i.e., when setting the attribute for the first time)
				// Entity (unit, group, marker, comment etc.) is passed as _this
				// Returned value is the default value
				// Used when no value is returned, or when it is of other type than NUMBER, STRING or ARRAY
				// Custom attributes of logic entities (e.g., modules) are saved always, even when they have default value
				defaultValue = "1";

				//--- Optional properties
				unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for variable names or player control)
				validate = "number"; // Validate the value before saving. If the value is not of given type e.g. "number", the default value will be set. Can be "none", "expression", "condition", "number" or "variable"
				condition = "object"; // Condition for attribute to appear (see the table below)
				typeName = "NUMBER"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
			};
		};

        class ACE_Actions 
		{
			class ACE_MainActions
			{
				displayName = "Interaktionen";
				condition = "true";
				distance = 2;
				class AE3_Asseble_Group
				{
					displayName = "Laptop";
					condition = "true";
					class AE3_UseComputer
					{
						displayName = "Use Computer";
						condition = "(alive _target) and (_target getVariable 'AE3_powerState' == 2)";
						statement = "params ['_target', '_player', '_params']; _handle = [_entity] execVM '\z\ae3\addons\main\scripts\UseComputerAction.sqf';";
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
					class AE3_TurnOn
					{
						displayName = "Einschalten";
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
						displayName = "Ausschalten";
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
        ace_cargo_size = 1;  // Cargo space the object takes
		
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