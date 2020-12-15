class CfgVehicles 
{
	/* ---------------------------------------- */

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

	class Land_PortableGenerator_01_sand_F;
	class Land_PortableGenerator_01_sand_F_AE3: Land_PortableGenerator_01_sand_F
	{
		fuelCapacity = 3;

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

		ae3_power_fuelConsumption = 1.5;
		ae3_power_fuelCapacity = 5;
		ae3_power_defaultFuelLevel = 1;

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
					class AE3_CheckFuelLevel
					{
						displayName = "Check Fuel Level";
						condition = "alive _target";
						statement = "params ['_target', '_player', '_params']; _handle = [_target] execVM '\z\ae3\addons\main\scripts\CheckFuelLevelAction.sqf';";
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

	/* ---------------------------------------- */

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
						condition = "(alive _target) and (count (nearestObjects [_target, ['Land_PortableGenerator_01_sand_F'], 10]) > 0) and (_target getVariable 'AE3_powerConsumptionState' == 0)";
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
					class AE3_DisconnectFromGenerator
					{
						displayName = "Disconnect From Generator";
						condition = "(alive _target) and (_target getVariable 'AE3_powerConsumptionState' == 1)";
						statement = "params ['_target', '_player', '_params']; _handle = [_target] execVM '\z\ae3\addons\main\scripts\DisconnectFromGeneratorAction.sqf';";
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

	/* ---------------------------------------- */

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

	/* ---------------------------------------- */
	class Logic;
	class Module_F: Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit;					// Default edit box (i.e., text input field)
			class Combo;				// Default combo box (i.e., drop-down menu)
			class Checkbox;				// Default checkbox (returned value is Boolean)
			class CheckboxNumber;		// Default checkbox (returned value is Number)
			class ModuleDescription;	// Module description
			class Units;				// Selection of units on which the module is applied
		};
		// Description base classes, for more information see below
		class ModuleDescription
		{
			class AnyBrain;
		};
	};
	class AE3_Filesystem: Module_F
	{
		// Standard object definitions
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "AE3 Filesystem"; // Name displayed in the menu
		//icon = "\myTag_addonName\data\iconNuke_ca.paa"; // Map icon. Delete this entry to use the default icon
		category = "ObjectModifiers";

		// Name of function triggered once conditions are met
		function = "AE3_fnc_moduleFilesystem";
		// Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
		functionPriority = 1;
		// 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isGlobal = 1;
		// 1 for module waiting until all synced triggers are activated
		isTriggerActivated = 1;
		// 1 if modules is to be disabled once it is activated (i.e., repeated trigger activation won't work)
		isDisposable = 1;
		// 1 to run init function in Eden Editor as well
		is3DEN = 1;

		// Menu displayed when the module is placed or double-clicked on by Zeus
		curatorInfoType = "RscDisplayAttributeModuleNuke";

		// Module attributes, uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific
		class Attributes: AttributesBase
		{
			// Arguments shared by specific module type (have to be mentioned in order to be present)
			class Units: Units
			{
				property = "AE3_ModuleFilesystem_Units";
			};
			// Module specific arguments
			class Yield: Combo
			{
				// Unique property, use "<moduleClass>_<attributeClass>" format to make sure the name is unique in the world
				property = "AE3_ModuleFilesystem_Yield";
				displayName = "Nuclear weapon yield"; // Argument label
				tooltip = "How strong will the explosion be"; // Tooltip description
				typeName = "NUMBER"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				defaultValue = "50"; // Default attribute value. WARNING: This is an expression, and its returned value will be used (50 in this case)
				class Values
				{
					class 50Mt	{name = "50 megatons";	value = 50;}; // Listbox item
					class 100Mt	{name = "100 megatons"; value = 100;};
				};
			};
			class Name: Edit
			{
				property = "AE3_ModuleFilesysten_Yield";
				displayName = "Name";
				tooltip = "Name of the nuclear device";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """Tsar Bomba""";
			};
			class ModuleDescription: ModuleDescription{}; // Module description should be shown last
		};

		// Module description. Must inherit from base class, otherwise pre-defined entities won't be available
		class ModuleDescription: ModuleDescription
		{
			description = "This Module defines Filesystem Objects for a synced Laptop. You can sync multiple Modules with one Laptop."; // Short description, will be formatted as structured text
			sync[] = { "Land_Laptop_03_sand_F_AE3" }; // LocationArea_F // Array of synced entities (can contain base classes)

			class Land_Laptop_03_sand_F_AE3
			{
				description[] = { // Multi-line descriptions are supported
					"First line",
					"Second line"
				};
				position = 1; // Position is taken into effect
				direction = 1; // Direction is taken into effect
				optional = 0; // Synced entity is optional
				duplicate = 0; // Multiple entities of this type can be synced
			};
		};
	};
};