class CfgVehicles 
{
	/* ================================================================================ */
	
	// LAPTOP BLACK
	class Land_Laptop_03_black_F;
	class Land_Laptop_03_black_F_AE3: Land_Laptop_03_black_F
	{
		// Eden Editor Attributes
		class Attributes
		{
			class AE3_EdenAttribute_PowerLevel
			{
				//--- Mandatory properties
				displayName = "$STR_AE3_Main_EdenAttributes_PowerLevelDisplayName"; // Name assigned to UI control class Title
				tooltip = "$STR_AE3_Main_EdenAttributes_PowerLevelTooltip"; // Tooltip assigned to UI control class Title
				property = "AE3_EdenAttribute_PowerLevel"; // Unique config property name saved in SQM
				control = "Slider"; // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

				expression = "_this setVariable ['%s', _value, true];";

				defaultValue = "1";

				//--- Optional properties
				unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for variable names or player control)
				validate = "number"; // Validate the value before saving. If the value is not of given type e.g. "number", the default value will be set. Can be "none", "expression", "condition", "number" or "variable"
				condition = "1"; // Condition for attribute to appear (see the table below)
				typeName = "NUMBER"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
			};

			class AE3_EdenAttribute_PowerState
			{
				//--- Mandatory properties
				displayName = "$STR_AE3_Main_EdenAttributes_PowerStateDisplayName"; // Name assigned to UI control class Title
				tooltip = "$STR_AE3_Main_EdenAttributes_PowerStateTooltip"; // Tooltip assigned to UI control class Title
				property = "AE3_EdenAttribute_PowerState"; // Unique config property name saved in SQM
				control = "CheckBox"; // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

				expression = "_this setVariable ['%s', _value, true];";

				defaultValue = "false";

				//--- Optional properties
				unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for variable names or player control)
			};
		};

		// Event Handlers
		class EventHandlers
		{
			//init = "params ['_entity']; call compile preprocessFileLineNumbers '\z\ae3\addons\main\init\initLaptop.sqf';";
		};

		class AE3_Equipment
		{
			displayName = "$STR_AE3_ArmaOS_Config_LaptopDisplayName";

			closeState = 0;

			init = "_this call AE3_interaction_fnc_initLaptop;";

			openAction = "_this call AE3_interaction_fnc_laptop_open;";
			openActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";
			closeAction = "_this call AE3_interaction_fnc_laptop_close;";
			closeActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";
      
      class AE3_ace3Interactions
			{
				class AE3_aceCarrying
				{
					// Carrying
					ae3_dragging_canCarry = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_carryPosition[] = {0, 1, 1};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_carryDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
				class AE3_aceCargo
				{
					ae3_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
					ae3_cargo_size = 1;  // Cargo space the object takes
				};
			};
		};

		class AE3_Device
		{
			displayName = "$STR_AE3_ArmaOS_Config_LaptopDisplayName";
			defaultPowerLevel = 0;

			init = "(_this + [configFile >> 'AE3_FilesystemObjects']) call AE3_filesystem_fnc_initFilesystem; _this call AE3_armaos_fnc_link_init; _this call AE3_network_fnc_initNetworkDevice;";

			turnOnAction = "_this call AE3_network_fnc_dhcp_onTurnOn; _this call AE3_armaos_fnc_computer_turnOn;";
			turnOnActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";
			turnOffAction = "_this call AE3_armaos_fnc_computer_turnOff;";
			turnOffActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";
			standByAction = "_this call AE3_armaos_fnc_computer_standby;";
			standByActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";

			class AE3_Consumer
			{
				powerConsumption = 0.01/3600; // 10 Watts
				standbyConsumption = 0.0001/3600; // 0.1 Watts
			};
		};

		class AE3_InternalDevice
		{
			displayName = "$STR_AE3_ArmaOS_Config_BatteryDisplayName";
			defaultPowerLevel = 1;

			turnOnAction = "_this + [true] call AE3_power_fnc_turnOnBatteryAction";
			turnOffAction = "";

			class AE3_PowerInterface
			{
				internal = 1;
			};

			class AE3_Battery
			{
				capacity = 0.1; // 100 Watts/hour max. capacity
				recharging = 0.05/3600; // 50 Watts power consumption while recharging
				level = 0.1; // 100 Watts/hour capacity at the beginning
				internal = 1;
			};
		};

		class AE3_USB_Interface
		{
			class USB0
			{
				rel_pos[] = {-0.19, 0.042, -0.145};
				rot_yaw = 90;
				rot_pitch = 0;
				rot_roll = 0;
			};

			class USB1
			{
				rel_pos[] = {-0.19, -0.028, -0.145};
				rot_yaw = 90;
				rot_pitch = 0;
				rot_roll = 180;
			};
		};
	};

	/* ================================================================================ */

	// LAPTOP OLIVE
	class Land_Laptop_03_olive_F;
	class Land_Laptop_03_olive_F_AE3: Land_Laptop_03_olive_F
	{
  	// Eden Editor Attributes
		class Attributes
		{
			class AE3_EdenAttribute_PowerLevel
			{
				//--- Mandatory properties
				displayName = "$STR_AE3_Main_EdenAttributes_PowerLevelDisplayName"; // Name assigned to UI control class Title
				tooltip = "$STR_AE3_Main_EdenAttributes_PowerLevelTooltip"; // Tooltip assigned to UI control class Title
				property = "AE3_EdenAttribute_PowerLevel"; // Unique config property name saved in SQM
				control = "Slider"; // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

				expression = "_this setVariable ['%s', _value, true];";

				defaultValue = "1";

				//--- Optional properties
				unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for variable names or player control)
				validate = "number"; // Validate the value before saving. If the value is not of given type e.g. "number", the default value will be set. Can be "none", "expression", "condition", "number" or "variable"
				condition = "1"; // Condition for attribute to appear (see the table below)
				typeName = "NUMBER"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
			};

			class AE3_EdenAttribute_PowerState
			{
				//--- Mandatory properties
				displayName = "$STR_AE3_Main_EdenAttributes_PowerStateDisplayName"; // Name assigned to UI control class Title
				tooltip = "$STR_AE3_Main_EdenAttributes_PowerStateTooltip"; // Tooltip assigned to UI control class Title
				property = "AE3_EdenAttribute_PowerState"; // Unique config property name saved in SQM
				control = "CheckBox"; // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

				expression = "_this setVariable ['%s', _value, true];";

				defaultValue = "false";

				//--- Optional properties
				unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for variable names or player control)
			};
		};

		// Event Handlers
		class EventHandlers
		{
			//init = "params ['_entity']; call compile preprocessFileLineNumbers '\z\ae3\addons\main\init\initLaptop.sqf';";
		};

		class AE3_Equipment
		{
			displayName = "$STR_AE3_ArmaOS_Config_LaptopDisplayName";

			closeState = 0;

			init = "_this call AE3_interaction_fnc_initLaptop;";

			openAction = "_this call AE3_interaction_fnc_laptop_open;";
			openActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";
			closeAction = "_this call AE3_interaction_fnc_laptop_close;";
			closeActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";
      
      class AE3_ace3Interactions
			{
				class AE3_aceCarrying
				{
					// Carrying
					ae3_dragging_canCarry = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_carryPosition[] = {0, 1, 1};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_carryDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
				class AE3_aceCargo
				{
					ae3_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
					ae3_cargo_size = 1;  // Cargo space the object takes
				};
			};
		};

		class AE3_Device
		{
			displayName = "$STR_AE3_ArmaOS_Config_LaptopDisplayName";
			defaultPowerLevel = 0;

			init = "(_this + [configFile >> 'AE3_FilesystemObjects']) call AE3_filesystem_fnc_initFilesystem; _this call AE3_armaos_fnc_link_init; _this call AE3_network_fnc_initNetworkDevice;";

			turnOnAction = "_this call AE3_network_fnc_dhcp_onTurnOn; _this call AE3_armaos_fnc_computer_turnOn;";
			turnOnActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";
			turnOffAction = "_this call AE3_armaos_fnc_computer_turnOff;";
			turnOffActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";
			standByAction = "_this call AE3_armaos_fnc_computer_standby;";
			standByActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";

			class AE3_Consumer
			{
				powerConsumption = 0.01/3600; // 10 Watts
				standbyConsumption = 0.0001/3600; // 0.1 Watts
			};
		};

		class AE3_InternalDevice
		{
			displayName = "$STR_AE3_ArmaOS_Config_BatteryDisplayName";
			defaultPowerLevel = 1;

			turnOnAction = "_this + [true] call AE3_power_fnc_turnOnBatteryAction";
			turnOffAction = "";

			class AE3_PowerInterface
			{
				internal = 1;
			};

			class AE3_Battery
			{
				capacity = 0.1; // 100 Watts/hour max. capacity
				recharging = 0.05/3600; // 50 Watts power consumption while recharging
				level = 0.1; // 100 Watts/hour capacity at the beginning
				internal = 1;
			};
		};

		class AE3_USB_Interface
		{
			class USB0
			{
				rel_pos[] = {-0.19, 0.042, -0.145};
				rot_yaw = 90;
				rot_pitch = 0;
				rot_roll = 0;
			};

			class USB1
			{
				rel_pos[] = {-0.19, -0.028, -0.145};
				rot_yaw = 90;
				rot_pitch = 0;
				rot_roll = 180;
			};
		};
	};

	/* ================================================================================ */
	
	// LAPTOP SAND
	class Land_Laptop_03_sand_F;
	class Land_Laptop_03_sand_F_AE3: Land_Laptop_03_sand_F
	{
  	// Eden Editor Attributes
		class Attributes
		{
			class AE3_EdenAttribute_PowerLevel
			{
				//--- Mandatory properties
				displayName = "$STR_AE3_Main_EdenAttributes_PowerLevelDisplayName"; // Name assigned to UI control class Title
				tooltip = "$STR_AE3_Main_EdenAttributes_PowerLevelTooltip"; // Tooltip assigned to UI control class Title
				property = "AE3_EdenAttribute_PowerLevel"; // Unique config property name saved in SQM
				control = "Slider"; // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

				expression = "_this setVariable ['%s', _value, true];";

				defaultValue = "1";

				//--- Optional properties
				unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for variable names or player control)
				validate = "number"; // Validate the value before saving. If the value is not of given type e.g. "number", the default value will be set. Can be "none", "expression", "condition", "number" or "variable"
				condition = "1"; // Condition for attribute to appear (see the table below)
				typeName = "NUMBER"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
			};

			class AE3_EdenAttribute_PowerState
			{
				//--- Mandatory properties
				displayName = "$STR_AE3_Main_EdenAttributes_PowerStateDisplayName"; // Name assigned to UI control class Title
				tooltip = "$STR_AE3_Main_EdenAttributes_PowerStateTooltip"; // Tooltip assigned to UI control class Title
				property = "AE3_EdenAttribute_PowerState"; // Unique config property name saved in SQM
				control = "CheckBox"; // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

				expression = "_this setVariable ['%s', _value, true];";

				defaultValue = "false";

				//--- Optional properties
				unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for variable names or player control)
			};
		};

		// Event Handlers
		class EventHandlers
		{
			//init = "params ['_entity']; call compile preprocessFileLineNumbers '\z\ae3\addons\main\init\initLaptop.sqf';";
		};

		class AE3_Equipment
		{
			displayName = "$STR_AE3_ArmaOS_Config_LaptopDisplayName";

			closeState = 0;

			init = "_this call AE3_interaction_fnc_initLaptop;";

			openAction = "_this call AE3_interaction_fnc_laptop_open;";
			openActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";
			closeAction = "_this call AE3_interaction_fnc_laptop_close;";
			closeActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";

			class AE3_ace3Interactions
			{
				class AE3_aceCarrying
				{
					// Carrying
					ae3_dragging_canCarry = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_carryPosition[] = {0, 1, 1};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_carryDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
				class AE3_aceCargo
				{
					ae3_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
					ae3_cargo_size = 1;  // Cargo space the object takes
				};
			};
		};

		class AE3_Device
		{
			displayName = "$STR_AE3_ArmaOS_Config_LaptopDisplayName";
			defaultPowerLevel = 0;

			init = "(_this + [configFile >> 'AE3_FilesystemObjects']) call AE3_filesystem_fnc_initFilesystem; _this call AE3_armaos_fnc_link_init; _this call AE3_network_fnc_initNetworkDevice;";

			turnOnAction = "_this call AE3_network_fnc_dhcp_onTurnOn; _this call AE3_armaos_fnc_computer_turnOn;";
			turnOnActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";
			turnOffAction = "_this call AE3_armaos_fnc_computer_turnOff;";
			turnOffActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";
			standByAction = "_this call AE3_armaos_fnc_computer_standby;";
			standByActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";

			class AE3_Consumer
			{
				powerConsumption = 0.01/3600; // 10 Watts
				standbyConsumption = 0.0001/3600; // 0.1 Watts
			};
		};

		class AE3_InternalDevice
		{
			displayName = "$STR_AE3_ArmaOS_Config_BatteryDisplayName";
			defaultPowerLevel = 1;

			turnOnAction = "_this + [true] call AE3_power_fnc_turnOnBatteryAction";
			turnOffAction = "";

			class AE3_PowerInterface
			{
				internal = 1;
			};

			class AE3_Battery
			{
				capacity = 0.1; // 100 Watts/hour max. capacity
				recharging = 0.05/3600; // 50 Watts power consumption while recharging
				level = 0.1; // 100 Watts/hour capacity at the beginning
				internal = 1;
			};
		};

		class AE3_USB_Interface
		{
			class USB0
			{
				rel_pos[] = {-0.19, 0.042, -0.145};
				rot_yaw = 90;
				rot_pitch = 0;
				rot_roll = 0;
			};

			class USB1
			{
				rel_pos[] = {-0.19, -0.028, -0.145};
				rot_yaw = 90;
				rot_pitch = 0;
				rot_roll = 180;
			};
		};
	};

	/* ================================================================================ */

	class Logic;
	class Module_F: Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit;					// Default edit box (i.e., text input field)
			class Checkbox;
			class ModuleDescription;	// Module description
		};
		// Description base classes, for more information see below
		class ModuleDescription
		{
			class AnyBrain;
		};
	};

	/* ================================================================================ */

	// MODULE ADDUSER
	class AE3_AddUser: Module_F
	{
		// Standard object definitions
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "$STR_AE3_ArmaOS_Config_AddUserDisplayName"; // Name displayed in the menu
		icon = "\z\ae3\addons\armaos\ui\AE3_Module_Icons_addUser.paa"; // Map icon. Delete this entry to use the default icon
		category = "AE3_armaosModules";

		// Name of function triggered once conditions are met
		function = "AE3_armaos_fnc_module_addUser";
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
			class AE3_ModuleUserlist_User: Edit
			{
				property = "AE3_ModuleUserlist_User1";
				displayName = "$STR_AE3_ArmaOS_Config_UsernameDisplayName";
				tooltip = "$STR_AE3_ArmaOS_Config_UsernameTooltip";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """admin""";
			};
			class AE3_ModuleUserlist_Password: Edit
			{
				property = "AE3_ModuleUserlist_Password1";
				displayName = "$STR_AE3_ArmaOS_Config_PasswordDisplayName";
				tooltip = "$STR_AE3_ArmaOS_Config_PasswordTooltip";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """admin123""";
			};
			class ModuleDescription: ModuleDescription{}; // Module description should be shown last
		};

		// Module description. Must inherit from base class, otherwise pre-defined entities won't be available
		class ModuleDescription: ModuleDescription
		{
			description = "$STR_AE3_ArmaOS_Config_ModuleAddUserDescription"; // Short description, will be formatted as structured text
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

	/* ================================================================================ */

	// MODULE ADD SECURITY COMMANDS
	class AE3_AddSecurityCommands: Module_F
	{
		// Standard object definitions
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "$STR_AE3_ArmaOS_Config_AddSecurityCommandsDisplayName"; // Name displayed in the menu
		icon = "\z\ae3\addons\armaos\ui\AE3_Module_Icon_addSecurityCommands_v2.paa"; // Map icon. Delete this entry to use the default icon
		category = "AE3_armaosModules";

		// Name of function triggered once conditions are met
		function = "AE3_armaos_fnc_module_addSecurityCommands";
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
		curatorInfoType = "RscDisplayAttributeModuleAddSecurityCommands";

		// Module attributes, uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific
		class Attributes: AttributesBase
		{

			// Arguments shared by specific module type (have to be mentioned in order to be present)
			class AE3_ModuleAddSecurityCommands_IsCrypto: Checkbox
			{
				property = "AE3_Module_AddSecurityCommands_Crypto";
				displayName = "crypto";
				tooltip = "$STR_AE3_ArmaOS_Config_ModuleAddSecurityCommandsCryptoTooltip";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = true;
			};

			// Arguments shared by specific module type (have to be mentioned in order to be present)
			class AE3_ModuleAddSecurityCommands_IsCrack: Checkbox
			{
				property = "AE3_Module_AddSecurityCommands_Crack";
				displayName = "crack";
				tooltip = "$STR_AE3_ArmaOS_Config_ModuleAddSecurityCommandsCrackTooltip";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = true;
			};

			class ModuleDescription: ModuleDescription{}; // Module description should be shown last
		};

		// Module description. Must inherit from base class, otherwise pre-defined entities won't be available
		class ModuleDescription: ModuleDescription
		{
			description = "$STR_AE3_ArmaOS_Config_ModuleAddSecurityCommandsDescription"; // Short description, will be formatted as structured text

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

	/* ================================================================================ */

	// MODULE ADD GAMES
	class AE3_AddGames: Module_F
	{
		// Standard object definitions
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "$STR_AE3_ArmaOS_Config_AddGamesDisplayName"; // Name displayed in the menu
		icon = "\z\ae3\addons\armaos\ui\AE3_Module_Icons_addGames.paa"; // Map icon. Delete this entry to use the default icon
		category = "AE3_armaosModules";

		// Name of function triggered once conditions are met
		function = "AE3_armaos_fnc_module_addGames";
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
		curatorInfoType = "RscDisplayAttributeModuleAddGames";

		// Module attributes, uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific
		class Attributes: AttributesBase
		{
			class ModuleDescription: ModuleDescription{}; // Module description should be shown last
		};

		// Module description. Must inherit from base class, otherwise pre-defined entities won't be available
		class ModuleDescription: ModuleDescription
		{
			description = "$STR_AE3_ArmaOS_Config_ModuleAddGamesDescription"; // Short description, will be formatted as structured text
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

	/* ================================================================================ */
};