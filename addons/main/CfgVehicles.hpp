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

	// GENERATOR
	class B_Quadbike_01_F;
	//class Land_PortableGenerator_01_sand_F;
	class Land_PortableGenerator_01_sand_F_AE3: B_Quadbike_01_F
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
        ace_refuel_fuelCapacity = 5; // Fuel tank volume
        ace_refuel_flowRate = 1; // Speed?

		// Event Handlers
		class EventHandlers
		{
			init = "params ['_entity']; call compile preprocessFileLineNumbers '\z\ae3\addons\main\init\initGenerator.sqf';";
		};

		ae3_power_fuelConsumption = 1.5;
		ae3_power_fuelCapacity = 5;
		ae3_power_defaultFuelLevel = 1;

		/* -------------------- */

		//Quad Bike Override
		faction = "Default";
		editorCategory = "EdCat_Things";
		editorSubcategory = "EdSubcat_Electronics";
		editorPreview = "\A3\EditorPreviews_F_Enoch\Data\CfgVehicles\Land_PortableGenerator_01_sand_F.jpg";
		model = "\A3\Props_F_Exp\Military\Camps\PortableGenerator_01_F.p3d";
		hiddenSelections[] = {"Camo_1", "Camo_2", "Camo_3"};
		hiddenSelectionsTextures[] = {"a3\Props_F_Enoch\Military\Camps\data\PortableGenerator_01_sand_CO.paa", "a3\props_f_exp\military\camps\data\portablegenerator_01_co.paa", "a3\Props_F_Enoch\Military\Camps\data\PortableGenerator_01_black_CO.paa"};
		icon = "iconObject_1x1"; // Object gets invisible, except the shadow
		picture = "pictureThing";
		displayName = "Generator";
		hasDriver = 0;
		getInAction = "";
		maximumLoad = 0;
		//transportSoldier = 0; // Removes the asset from list
		cargoAction[] = {};
		driverAction = "";
		//typicalCargo[] = {};
		//crew = "B_Soldier_F";
		fuelCapacity = "5 * 0.165";
		fuelConsumptionRate = 0.01;
		textureList[] = {"Sand",1};

		class TextureSources
		{
			class Black
			{
				author = "Bohemia Interactive";
				displayName = "Black";
				factions[] = {"BLU_F", "Default"};
				textures[] = {"a3\Props_F_Enoch\Military\Camps\data\PortableGenerator_01_black_CO.paa"};
			};
			class Bluefor
			{
				author = "Bohemia Interactive";
				displayName = "Green";
				factions[] = {"BLU_F", "Default"};
				textures[] = {"a3\props_f_exp\military\camps\data\portablegenerator_01_co.paa"};
			};
			class ParkRanger
			{
				displayName = "Sand";
				author = "Bohemia Interactive";
				factions[] = {"BLU_F", "Default"};
				textures[] = {"a3\Props_F_Enoch\Military\Camps\data\PortableGenerator_01_sand_CO.paa"};
			};
		};

		/* -------------------- */

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
					class AE3_PowerState
					{
						displayName = "Power State";
						condition = "alive _target";
						statement = "params ['_target', '_player', '_params']; _handle = [_target] execVM '\z\ae3\addons\main\scripts\GetPowerStateAction.sqf';";
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

		// Event Handlers
		class EventHandlers
		{
			init = "params ['_entity']; call compile preprocessFileLineNumbers '\z\ae3\addons\main\init\initRouter.sqf';";
		};


		ae3_power_hasBattery = 0;
		ae3_power_powerConsumptionOn = 5;

		ae3_network_internet_ipaddress = "42.24.11.78";
		ae3_network_local_ipaddress = "10.42.42.1";
		ae3_network_local_subnetmask = "255.255.255.0";
		ae3_network_local_dhcpBase = "10.42.42.";
		ae3_network_local_dhcpStart = 100;
		ae3_network_local_dhcpCount = 50;

        class ACE_Actions 
		{
			class ACE_MainActions
			{
				displayName = "Interaktionen";
				condition = "true";
				distance = 2;
				class AE3_Router_Group
				{
					displayName = "Router";
					condition = "true";
					class AE3_ConnectToGenerator
					{
						displayName = "Connect To Generator";
						condition = "(alive _target) and (count (nearestObjects [_target, ['Land_PortableGenerator_01_sand_F_AE3'], 10]) > 0) and (_target getVariable 'AE3_powerConsumptionState' == 0)";
						statement = "";
						//icon = "\z\dance.paa";
						exceptions[] = {};
						insertChildren = "params ['_target', '_player', '_params']; _generators = nearestObjects [_target, ['Land_PortableGenerator_01_sand_F_AE3'], 10]; private _actions = []; { private _childStatement = { params ['_target', '_player', '_generator']; _handle = [_target, _generator] execVM '\z\ae3\addons\main\scripts\ConnectToGeneratorAction.sqf'; }; private _action = [typeOf _x, typeOf _x, '', _childStatement, {true}, {}, _x] call ace_interact_menu_fnc_createAction; _actions pushBack [_action, [], _target]; } forEach (_generators); _actions";
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
					class AE3_PowerState
					{
						displayName = "Power State";
						condition = "alive _target";
						statement = "params ['_target', '_player', '_params']; _handle = [_target] execVM '\z\ae3\addons\main\scripts\GetPowerStateAction.sqf';";
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

	// LAPTOP
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
						condition = "(alive _target) and (_target getVariable 'AE3_powerState' == 1)";
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
						condition = "(alive _target) and (count (nearestObjects [_target, ['Land_PortableGenerator_01_sand_F_AE3'], 10]) > 0) and (_target getVariable 'AE3_powerConsumptionState' == 0)";
						statement = "";
						//icon = "\z\dance.paa";
						exceptions[] = {};
						insertChildren = "params ['_target', '_player', '_params']; _generators = nearestObjects [_target, ['Land_PortableGenerator_01_sand_F_AE3'], 10]; private _actions = []; { private _childStatement = { params ['_target', '_player', '_generator']; _handle = [_target, _generator] execVM '\z\ae3\addons\main\scripts\ConnectToGeneratorAction.sqf'; }; private _action = [typeOf _x, typeOf _x, '', _childStatement, {true}, {}, _x] call ace_interact_menu_fnc_createAction; _actions pushBack [_action, [], _target]; } forEach (_generators); _actions";
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
					class AE3_ConnectToRouter
					{
						displayName = "Connect To Router";
						condition = "(alive _target) and (count (nearestObjects [_target, ['Land_Router_01_sand_F_AE3'], 10]) > 0) and (_target getVariable 'AE3_networkConnectionState' == 0)";
						statement = "";
						//icon = "\z\dance.paa";
						exceptions[] = {};
						insertChildren = "params ['_target', '_player', '_params']; _routers = nearestObjects [_target, ['Land_Router_01_sand_F_AE3'], 10]; private _actions = []; { private _childStatement = { params ['_target', '_player', '_router']; _handle = [_target, _router] execVM '\z\ae3\addons\main\scripts\ConnectToRouterAction.sqf'; }; private _action = [typeOf _x, typeOf _x, '', _childStatement, {true}, {}, _x] call ace_interact_menu_fnc_createAction; _actions pushBack [_action, [], _target]; } forEach (_routers); _actions";
						//modifierFunction
						//runOnHover
						//distance
						//position
						//selection
						priority = -1;
						showDisabled = 0;
					};
					class AE3_DisconnectFromRouter
					{
						displayName = "Disconnect From Router";
						condition = "(alive _target) and (_target getVariable 'AE3_networkConnectionState' == 1)";
						statement = "params ['_target', '_player', '_params']; _handle = [_target] execVM '\z\ae3\addons\main\scripts\DisconnectFromRouterAction.sqf';";
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
						condition = "(alive _target) and (_target getVariable 'AE3_powerState' == 1)";
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
					class AE3_PowerState
					{
						displayName = "Power State";
						condition = "alive _target";
						statement = "params ['_target', '_player', '_params']; _handle = [_target] execVM '\z\ae3\addons\main\scripts\GetPowerStateAction.sqf';";
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

	// DESK
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

	// MODULE FILESYSTEM
	class Logic;
	class Module_F: Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit;					// Default edit box (i.e., text input field)
			class ModuleDescription;	// Module description
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
		is3DEN = 0;

		// Menu displayed when the module is placed or double-clicked on by Zeus
		curatorInfoType = "RscDisplayAttributeModuleFilesystem";

		// Module attributes, uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific
		class Attributes: AttributesBase
		{
			// Arguments shared by specific module type (have to be mentioned in order to be present)
			class AE3_ModuleFilesystem_FilesystemObject1: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemObject1";
				displayName = "Filesystem Object 1";
				tooltip = "Path and Name of Filesystem Object, for example /users/y0014984/Desktop/passwords.txt";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """/users/y0014984/Desktop/passwords1.txt""";
			};
			class AE3_ModuleFilesystem_FilesystemContent1: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemContent1";
				displayName = "Filesystem Content 1";
				tooltip = "Content of Filesystem Object, like text note oder path to image";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """Hidden Note 1""";
			};
			class AE3_ModuleFilesystem_FilesystemObject2: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemObject2";
				displayName = "Filesystem Object 2";
				tooltip = "Path and Name of Filesystem Object, for example /users/y0014984/Desktop/passwords.txt";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """/users/y0014984/Desktop/passwords2.txt""";
			};
			class AE3_ModuleFilesystem_FilesystemContent2: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemContent2";
				displayName = "Filesystem Content 2";
				tooltip = "Content of Filesystem Object, like text note oder path to image";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """Hidden Note 2""";
			};
			class AE3_ModuleFilesystem_FilesystemObject3: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemObject3";
				displayName = "Filesystem Object 3";
				tooltip = "Path and Name of Filesystem Object, for example /users/y0014984/Desktop/passwords.txt";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """/users/y0014984/Desktop/passwords3.txt""";
			};
			class AE3_ModuleFilesystem_FilesystemContent3: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemContent3";
				displayName = "Filesystem Content 3";
				tooltip = "Content of Filesystem Object, like text note oder path to image";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """Hidden Note 3""";
			};
			class AE3_ModuleFilesystem_FilesystemObject4: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemObject4";
				displayName = "Filesystem Object 4";
				tooltip = "Path and Name of Filesystem Object, for example /users/y0014984/Desktop/passwords.txt";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """/users/y0014984/Desktop/passwords4.txt""";
			};
			class AE3_ModuleFilesystem_FilesystemContent4: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemContent4";
				displayName = "Filesystem Content 4";
				tooltip = "Content of Filesystem Object, like text note oder path to image";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """Hidden Note 4""";
			};
			class AE3_ModuleFilesystem_FilesystemObject5: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemObject5";
				displayName = "Filesystem Object 5";
				tooltip = "Path and Name of Filesystem Object, for example /users/y0014984/Desktop/passwords.txt";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """/users/y0014984/Desktop/passwords5.txt""";
			};
			class AE3_ModuleFilesystem_FilesystemContent5: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemContent5";
				displayName = "Filesystem Content 5";
				tooltip = "Content of Filesystem Object, like text note oder path to image";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """Hidden Note 5""";
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

	/* ---------------------------------------- */

	// MODULE USERLIST
	class Logic;
	class Module_F: Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit;					// Default edit box (i.e., text input field)
			class ModuleDescription;	// Module description
		};
		// Description base classes, for more information see below
		class ModuleDescription
		{
			class AnyBrain;
		};
	};
	class AE3_Userlist: Module_F
	{
		// Standard object definitions
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "AE3 Userlist"; // Name displayed in the menu
		//icon = "\myTag_addonName\data\iconNuke_ca.paa"; // Map icon. Delete this entry to use the default icon
		category = "ObjectModifiers";

		// Name of function triggered once conditions are met
		function = "AE3_fnc_moduleUserlist";
		// Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
		functionPriority = 1;
		// 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isGlobal = 1;
		// 1 for module waiting until all synced triggers are activated
		isTriggerActivated = 1;
		// 1 if modules is to be disabled once it is activated (i.e., repeated trigger activation won't work)
		isDisposable = 1;
		// 1 to run init function in Eden Editor as well
		is3DEN = 0;

		// Menu displayed when the module is placed or double-clicked on by Zeus
		curatorInfoType = "RscDisplayAttributeModuleUserlist";

		// Module attributes, uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific
		class Attributes: AttributesBase
		{
			// Arguments shared by specific module type (have to be mentioned in order to be present)
			class AE3_ModuleUserlist_User1: Edit
			{
				property = "AE3_ModuleUserlist_User1";
				displayName = "User 1";
				tooltip = "Name of authorized user, for example 'admin', 'guest' or 'stavros'";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """admin""";
			};
			class AE3_ModuleUserlist_Password1: Edit
			{
				property = "AE3_ModuleUserlist_Password1";
				displayName = "Password 1";
				tooltip = "Password of authorized user, for example '123456', 'password' or 'Qf5&xxR12#fTG'";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """admin123""";
			};
			class AE3_ModuleUserlist_User2: Edit
			{
				property = "AE3_ModuleUserlist_User2";
				displayName = "User 2";
				tooltip = "Name of authorized user, for example 'admin', 'guest' or 'stavros'";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """guest""";
			};
			class AE3_ModuleUserlist_Password2: Edit
			{
				property = "AE3_ModuleUserlist_Password2";
				displayName = "Password 2";
				tooltip = "Password of authorized user, for example '123456', 'password' or 'Qf5&xxR12#fTG'";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """guest123""";
			};
			class AE3_ModuleUserlist_User3: Edit
			{
				property = "AE3_ModuleUserlist_User3";
				displayName = "User 3";
				tooltip = "Name of authorized user, for example 'admin', 'guest' or 'stavros'";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """root""";
			};
			class AE3_ModuleUserlist_Password3: Edit
			{
				property = "AE3_ModuleUserlist_Password3";
				displayName = "Password 3";
				tooltip = "Password of authorized user, for example '123456', 'password' or 'Qf5&xxR12#fTG'";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """root123""";
			};
			class AE3_ModuleUserlist_User4: Edit
			{
				property = "AE3_ModuleUserlist_User4";
				displayName = "User 4";
				tooltip = "Name of authorized user, for example 'admin', 'guest' or 'stavros'";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """security""";
			};
			class AE3_ModuleUserlist_Password4: Edit
			{
				property = "AE3_ModuleUserlist_Password4";
				displayName = "Password 4";
				tooltip = "Password of authorized user, for example '123456', 'password' or 'Qf5&xxR12#fTG'";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """security123""";
			};
			class AE3_ModuleUserlist_User5: Edit
			{
				property = "AE3_ModuleUserlist_User5";
				displayName = "User 5";
				tooltip = "Name of authorized user, for example 'admin', 'guest' or 'stavros'";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """jesus""";
			};
			class AE3_ModuleUserlist_Password5: Edit
			{
				property = "AE3_ModuleUserlist_Password5";
				displayName = "Password 5";
				tooltip = "Password of authorized user, for example '123456', 'password' or 'Qf5&xxR12#fTG'";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """holyshit""";
			};

			class ModuleDescription: ModuleDescription{}; // Module description should be shown last
		};

		// Module description. Must inherit from base class, otherwise pre-defined entities won't be available
		class ModuleDescription: ModuleDescription
		{
			description = "This Module defines Users for a synced Laptop. You can sync multiple Modules with one Laptop."; // Short description, will be formatted as structured text
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