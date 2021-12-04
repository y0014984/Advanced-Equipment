class CfgVehicles 
{
	
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
						statement = "params ['_target', '_player', '_params']; _handle = [_target] spawn AE3_armaos_fnc_useComputerAction;";
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
						statement = "params ['_target', '_player', '_params']; _handle = [_target] spawn AE3_power_fnc_checkBatteryLevelAction;";
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
						insertChildren = "params ['_target', '_player', '_params']; _generators = nearestObjects [_target, ['Land_PortableGenerator_01_sand_F_AE3'], 10]; private _actions = []; { private _childStatement = { params ['_target', '_player', '_generator']; _handle = [_target, _generator] spawn AE3_power_fnc_connectToGeneratorAction; }; private _action = [typeOf _x, typeOf _x, '', _childStatement, {true}, {}, _x] call ace_interact_menu_fnc_createAction; _actions pushBack [_action, [], _target]; } forEach (_generators); _actions";
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
						statement = "params ['_target', '_player', '_params']; _handle = [_target] spawn AE3_power_fnc_disconnectFromGeneratorAction;";
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
						insertChildren = "params ['_target', '_player', '_params']; _routers = nearestObjects [_target, ['Land_Router_01_sand_F_AE3'], 10]; private _actions = []; { private _childStatement = { params ['_target', '_player', '_router']; _handle = [_target, _router] spawn AE3_network_fnc_connectToRouterAction; }; private _action = [typeOf _x, typeOf _x, '', _childStatement, {true}, {}, _x] call ace_interact_menu_fnc_createAction; _actions pushBack [_action, [], _target]; } forEach (_routers); _actions";
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
						statement = "params ['_target', '_player', '_params']; _handle = [_target] spawn AE3_network_fnc_disconnectFromRouterAction;";
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
						statement = "params ['_target', '_player', '_params']; _handle = [_target] spawn AE3_armaos_fnc_turnOnComputerAction;";
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
						statement = "params ['_target', '_player', '_params']; _handle = [_target, false] spawn AE3_armaos_fnc_turnOffComputerAction;";
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
						statement = "params ['_target', '_player', '_params']; _handle = [_target] spawn AE3_armaos_fnc_standbyComputerAction;";
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
						displayName = "Check Power State";
						condition = "alive _target";
						statement = "params ['_target', '_player', '_params']; _handle = [_target] spawn AE3_power_fnc_getPowerStateAction;";
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
		function = "AE3_armaos_fnc_moduleFilesystem";
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
		function = "AE3_armaos_fnc_moduleUserlist";
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