// Laptop software toggles exposed as 3DEN object attributes (replacing the old Add Games module).
// Each checkbox installs the game on the laptop at mission start once it has finished initialising.
// Shared by every laptop variant.
#define AE3_LAPTOP_SOFTWARE_ATTRIBUTES \
	class AE3_Game_Snake \
	{ \
		displayName = "Snake (game)"; \
		tooltip = "$STR_AE3_ArmaOS_Config_ModuleAddGamesSnakeTooltip"; \
		property = "AE3_Game_Snake"; \
		control = "Checkbox"; \
		expression = "[_this, _value] call AE3_armaos_fnc_attr_addGames;"; \
		defaultValue = "false"; \
		typeName = "BOOL"; \
		condition = "1"; \
	}; \
	class AE3_LaptopStartOn \
	{ \
		displayName = "Powered On At Start"; \
		tooltip = "Switch the laptop on automatically when the mission starts."; \
		property = "AE3_LaptopStartOn"; \
		control = "Checkbox"; \
		expression = "private _on = _value in [true, 1]; _this setVariable ['AE3_power_startOn', _on, true]; if (_on) then {[{ params ['_computer']; !alive _computer || {(_computer getVariable ['AE3_power_initDone', false]) && {!isNil {_computer getVariable 'AE3_power_fnc_turnOnWrapper'}}} }, { params ['_computer']; if (alive _computer && {(_computer getVariable ['AE3_power_powerState', 0]) != 1}) then {[_computer] call AE3_power_fnc_turnOnDevice;}; }, [_this]] call CBA_fnc_waitUntilAndExecute;};"; \
		defaultValue = "false"; \
		typeName = "BOOL"; \
		condition = "1"; \
	};

// Per-laptop superuser policy exposed as 3DEN object attributes. Each laptop decides on its own
// whether root may log in directly, which password root uses, and who may run sudo.
// Shared by every laptop variant.
#define AE3_LAPTOP_ROOT_ATTRIBUTES \
	class AE3_EdenAttribute_RootLogin \
	{ \
		displayName = "$STR_AE3_ArmaOS_EdenAttributes_RootLoginDisplayName"; \
		tooltip = "$STR_AE3_ArmaOS_EdenAttributes_RootLoginTooltip"; \
		property = "AE3_EdenAttribute_RootLogin"; \
		control = "Combo"; \
		expression = "if (_value != 'default') then { _this setVariable ['AE3_allowRootLogin', _value, true]; };"; \
		defaultValue = """default"""; \
		unique = 0; \
		condition = "1"; \
		typeName = "STRING"; \
		class Values \
		{ \
			class RootDefault { name = "$STR_AE3_ArmaOS_EdenAttributes_RootLoginDefault"; value = "default"; }; \
			class RootAllow   { name = "$STR_AE3_ArmaOS_EdenAttributes_RootLoginAllow"; value = "allow"; }; \
			class RootDeny    { name = "$STR_AE3_ArmaOS_EdenAttributes_RootLoginDeny"; value = "deny"; }; \
		}; \
	}; \
	class AE3_EdenAttribute_RootPassword \
	{ \
		displayName = "$STR_AE3_ArmaOS_EdenAttributes_RootPasswordDisplayName"; \
		tooltip = "$STR_AE3_ArmaOS_EdenAttributes_RootPasswordTooltip"; \
		property = "AE3_EdenAttribute_RootPassword"; \
		control = "Edit"; \
		expression = "[_this, _value] call AE3_armaos_fnc_attr_setRootPassword;"; \
		defaultValue = """"""; \
		unique = 0; \
		condition = "1"; \
		typeName = "STRING"; \
	}; \
	class AE3_EdenAttribute_Sudoers \
	{ \
		displayName = "$STR_AE3_ArmaOS_EdenAttributes_SudoersDisplayName"; \
		tooltip = "$STR_AE3_ArmaOS_EdenAttributes_SudoersTooltip"; \
		property = "AE3_EdenAttribute_Sudoers"; \
		control = "Edit"; \
		expression = "[_this, _value] call AE3_armaos_fnc_attr_addSudoers;"; \
		defaultValue = """"""; \
		unique = 0; \
		condition = "1"; \
		typeName = "STRING"; \
	};

class CfgVehicles
{
	/* ================================================================================ */

	// LAPTOP BLACK
	class Land_Laptop_03_black_F;
	class Land_Laptop_03_black_F_AE3: Land_Laptop_03_black_F
	{
		ae3_item = "Item_Laptop_AE3"; // Maps to inventory item class

		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Laptop";

		curatorInfoTypeEmpty = "AE3_UserInterface_Zeus_Asset_Details";

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

			class AE3_EdenAttribute_InterfaceMode
			{
				displayName = "$STR_AE3_ArmaOS_EdenAttributes_GuiModeDisplayName"; // Name assigned to UI control class Title
				tooltip = "$STR_AE3_ArmaOS_EdenAttributes_GuiModeTooltip"; // Tooltip assigned to UI control class Title
				property = "AE3_EdenAttribute_InterfaceMode"; // Unique config property name saved in SQM
				control = "Combo"; // UI control base class displayed in Edit Attributes window

				// Which interfaces this laptop offers; 'default' keeps the mission-wide
				// CBA setting AE3_Desktop_DefaultMode. Who may use which interface is
				// controlled via AE3_desktop_fnc_setInterfaceAccess (see GUI-Laptop-Guide).
				expression = "if (_value != 'default') then { _this setVariable ['AE3_interfaceMode', _value, true]; };";

				defaultValue = """default""";

				unique = 0;
				condition = "1";
				typeName = "STRING";

				class Values
				{
					class ModeDefault { name = "$STR_AE3_ArmaOS_EdenAttributes_ModeDefault"; value = "default"; };
					class ModeCli     { name = "CLI";  value = "cli"; };
					class ModeGui     { name = "GUI";  value = "gui"; };
					class ModeBoth    { name = "$STR_AE3_ArmaOS_EdenAttributes_ModeBoth"; value = "both"; };
				};
			};

			class AE3_EdenAttribute_StaticIp
			{
				displayName = "$STR_AE3_ArmaOS_EdenAttributes_StaticIpDisplayName";
				tooltip = "$STR_AE3_ArmaOS_EdenAttributes_StaticIpTooltip";
				property = "AE3_EdenAttribute_StaticIp";
				control = "Edit";

				expression = "_this setVariable ['AE3_network_staticIpDefault', _value, true];";

				defaultValue = """""";

				unique = 0;
				condition = "1";
				typeName = "STRING";
			};

			AE3_LAPTOP_SOFTWARE_ATTRIBUTES

			AE3_LAPTOP_ROOT_ATTRIBUTES
		};

		class AE3_Equipment
		{
			displayName = "$STR_AE3_ArmaOS_Config_LaptopDisplayName";

			closeState = 0;

			init = "call AE3_interaction_fnc_initLaptop;";

			openAction = "call AE3_interaction_fnc_laptop_open;";
			openActionCondition = "[_this] call AE3_armaos_fnc_computer_isFree";
			closeAction = "call AE3_interaction_fnc_laptop_close;";
			closeActionCondition = "[_this] call AE3_armaos_fnc_computer_isFree";

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

			init = "(_this + [configFile >> 'AE3_FilesystemObjects']) call AE3_armaos_fnc_device_initComplete;";

			turnOnAction = "call AE3_network_fnc_dhcp_onTurnOn; call AE3_armaos_fnc_computer_turnOn;";
			turnOnActionCondition = "[_this] call AE3_armaos_fnc_computer_isFree";
			turnOffAction = "call AE3_armaos_fnc_computer_turnOff;";
			turnOffActionCondition = "[_this] call AE3_armaos_fnc_computer_isFree";
			standByAction = "call AE3_armaos_fnc_computer_standby;";
			standByActionCondition = "[_this] call AE3_armaos_fnc_computer_isFree";

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
		ae3_item = "Item_Laptop_AE3"; // Maps to inventory item class

		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Laptop";

		curatorInfoTypeEmpty = "AE3_UserInterface_Zeus_Asset_Details";

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

			class AE3_EdenAttribute_InterfaceMode
			{
				displayName = "$STR_AE3_ArmaOS_EdenAttributes_GuiModeDisplayName"; // Name assigned to UI control class Title
				tooltip = "$STR_AE3_ArmaOS_EdenAttributes_GuiModeTooltip"; // Tooltip assigned to UI control class Title
				property = "AE3_EdenAttribute_InterfaceMode"; // Unique config property name saved in SQM
				control = "Combo"; // UI control base class displayed in Edit Attributes window

				// Which interfaces this laptop offers; 'default' keeps the mission-wide
				// CBA setting AE3_Desktop_DefaultMode. Who may use which interface is
				// controlled via AE3_desktop_fnc_setInterfaceAccess (see GUI-Laptop-Guide).
				expression = "if (_value != 'default') then { _this setVariable ['AE3_interfaceMode', _value, true]; };";

				defaultValue = """default""";

				unique = 0;
				condition = "1";
				typeName = "STRING";

				class Values
				{
					class ModeDefault { name = "$STR_AE3_ArmaOS_EdenAttributes_ModeDefault"; value = "default"; };
					class ModeCli     { name = "CLI";  value = "cli"; };
					class ModeGui     { name = "GUI";  value = "gui"; };
					class ModeBoth    { name = "$STR_AE3_ArmaOS_EdenAttributes_ModeBoth"; value = "both"; };
				};
			};

			class AE3_EdenAttribute_StaticIp
			{
				displayName = "$STR_AE3_ArmaOS_EdenAttributes_StaticIpDisplayName";
				tooltip = "$STR_AE3_ArmaOS_EdenAttributes_StaticIpTooltip";
				property = "AE3_EdenAttribute_StaticIp";
				control = "Edit";

				expression = "_this setVariable ['AE3_network_staticIpDefault', _value, true];";

				defaultValue = """""";

				unique = 0;
				condition = "1";
				typeName = "STRING";
			};

			AE3_LAPTOP_SOFTWARE_ATTRIBUTES

			AE3_LAPTOP_ROOT_ATTRIBUTES
		};

		class AE3_Equipment
		{
			displayName = "$STR_AE3_ArmaOS_Config_LaptopDisplayName";

			closeState = 0;

			init = "call AE3_interaction_fnc_initLaptop;";

			openAction = "call AE3_interaction_fnc_laptop_open;";
			openActionCondition = "[_this] call AE3_armaos_fnc_computer_isFree";
			closeAction = "call AE3_interaction_fnc_laptop_close;";
			closeActionCondition = "[_this] call AE3_armaos_fnc_computer_isFree";

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

			init = "(_this + [configFile >> 'AE3_FilesystemObjects']) call AE3_armaos_fnc_device_initComplete;";

			turnOnAction = "call AE3_network_fnc_dhcp_onTurnOn; call AE3_armaos_fnc_computer_turnOn;";
			turnOnActionCondition = "[_this] call AE3_armaos_fnc_computer_isFree";
			turnOffAction = "call AE3_armaos_fnc_computer_turnOff;";
			turnOffActionCondition = "[_this] call AE3_armaos_fnc_computer_isFree";
			standByAction = "call AE3_armaos_fnc_computer_standby;";
			standByActionCondition = "[_this] call AE3_armaos_fnc_computer_isFree";

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
		ae3_item = "Item_Laptop_AE3"; // Maps to inventory item class

		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Laptop";

		curatorInfoTypeEmpty = "AE3_UserInterface_Zeus_Asset_Details";

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

			class AE3_EdenAttribute_InterfaceMode
			{
				displayName = "$STR_AE3_ArmaOS_EdenAttributes_GuiModeDisplayName"; // Name assigned to UI control class Title
				tooltip = "$STR_AE3_ArmaOS_EdenAttributes_GuiModeTooltip"; // Tooltip assigned to UI control class Title
				property = "AE3_EdenAttribute_InterfaceMode"; // Unique config property name saved in SQM
				control = "Combo"; // UI control base class displayed in Edit Attributes window

				// Which interfaces this laptop offers; 'default' keeps the mission-wide
				// CBA setting AE3_Desktop_DefaultMode. Who may use which interface is
				// controlled via AE3_desktop_fnc_setInterfaceAccess (see GUI-Laptop-Guide).
				expression = "if (_value != 'default') then { _this setVariable ['AE3_interfaceMode', _value, true]; };";

				defaultValue = """default""";

				unique = 0;
				condition = "1";
				typeName = "STRING";

				class Values
				{
					class ModeDefault { name = "$STR_AE3_ArmaOS_EdenAttributes_ModeDefault"; value = "default"; };
					class ModeCli     { name = "CLI";  value = "cli"; };
					class ModeGui     { name = "GUI";  value = "gui"; };
					class ModeBoth    { name = "$STR_AE3_ArmaOS_EdenAttributes_ModeBoth"; value = "both"; };
				};
			};

			class AE3_EdenAttribute_StaticIp
			{
				displayName = "$STR_AE3_ArmaOS_EdenAttributes_StaticIpDisplayName";
				tooltip = "$STR_AE3_ArmaOS_EdenAttributes_StaticIpTooltip";
				property = "AE3_EdenAttribute_StaticIp";
				control = "Edit";

				expression = "_this setVariable ['AE3_network_staticIpDefault', _value, true];";

				defaultValue = """""";

				unique = 0;
				condition = "1";
				typeName = "STRING";
			};

			AE3_LAPTOP_SOFTWARE_ATTRIBUTES

			AE3_LAPTOP_ROOT_ATTRIBUTES
		};

		class AE3_Equipment
		{
			displayName = "$STR_AE3_ArmaOS_Config_LaptopDisplayName";

			closeState = 0;

			init = "call AE3_interaction_fnc_initLaptop;";

			openAction = "call AE3_interaction_fnc_laptop_open;";
			openActionCondition = "[_this] call AE3_armaos_fnc_computer_isFree";
			closeAction = "call AE3_interaction_fnc_laptop_close;";
			closeActionCondition = "[_this] call AE3_armaos_fnc_computer_isFree";

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

			init = "(_this + [configFile >> 'AE3_FilesystemObjects']) call AE3_armaos_fnc_device_initComplete;";

			turnOnAction = "call AE3_network_fnc_dhcp_onTurnOn; call AE3_armaos_fnc_computer_turnOn;";
			turnOnActionCondition = "[_this] call AE3_armaos_fnc_computer_isFree";
			turnOffAction = "call AE3_armaos_fnc_computer_turnOff;";
			turnOffActionCondition = "[_this] call AE3_armaos_fnc_computer_isFree";
			standByAction = "call AE3_armaos_fnc_computer_standby;";
			standByActionCondition = "[_this] call AE3_armaos_fnc_computer_isFree";

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
			class Edit;					// Default edit box (i.e., text input field)
			class ModuleDescription;	// Module description
		};
		// Description base classes, for more information see below
		class ModuleDescription {};
	};

	/* ================================================================================ */

	// MODULE ADDUSER
	class AE3_AddUser: Module_F
	{
		// Standard object definitions
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.
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
		curatorInfoType = "AE3_UserInterface_Zeus_Module_AddUser";

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

	// MODULE ADDSUDOER
	class AE3_AddSudoer: Module_F
	{
		scope = 2;
		scopeCurator = 2;
		displayName = "$STR_AE3_ArmaOS_Config_AddSudoerDisplayName";
		icon = "\z\ae3\addons\armaos\ui\AE3_Module_Icons_addUser.paa";
		category = "AE3_armaosModules";

		function = "AE3_armaos_fnc_module_addSudoer";
		functionPriority = 1;
		isGlobal = 1;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		curatorInfoType = "AE3_UserInterface_Zeus_Module_AddSudoer";

		class Attributes: AttributesBase
		{
			class AE3_ModuleSudoers_User: Edit
			{
				property = "AE3_ModuleSudoers_User";
				displayName = "$STR_AE3_ArmaOS_Config_UsernameDisplayName";
				tooltip = "$STR_AE3_ArmaOS_Config_SudoerUsernameTooltip";
				typeName = "STRING";
				defaultValue = """admin""";
			};
			class ModuleDescription: ModuleDescription{}; // Module description should be shown last
		};

		class ModuleDescription: ModuleDescription
		{
			description = "$STR_AE3_ArmaOS_Config_ModuleAddSudoerDescription";
			sync[] = { "Land_Laptop_03_sand_F_AE3" };

			class Land_Laptop_03_sand_F_AE3
			{
				description[] = {
					"First line",
					"Second line"
				};
				position = 1;
				direction = 1;
				optional = 0;
				duplicate = 0;
			};
		};
	};

	/* ================================================================================ */

	// MODULE SAVE LAPTOP
	class AE3_SaveLaptop: Module_F
	{
		scope = 2;
		scopeCurator = 2;
		displayName = "$STR_AE3_ArmaOS_Config_SaveLaptopDisplayName";
		icon = "\z\ae3\addons\armaos\ui\AE3_Module_Icons_addUser.paa";
		category = "AE3_armaosModules";

		function = "AE3_armaos_fnc_module_saveLaptop";
		functionPriority = 1;
		isGlobal = 0; // server-only execution; the snapshot lives in the server-side buffer
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		class Attributes: AttributesBase
		{
			class AE3_ModuleSaveSlot: Edit
			{
				property = "AE3_ModuleSaveSlot";
				displayName = "$STR_AE3_ArmaOS_Config_SaveSlotDisplayName";
				tooltip = "$STR_AE3_ArmaOS_Config_SaveSlotTooltip";
				typeName = "STRING";
				defaultValue = """slot1""";
			};
			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "$STR_AE3_ArmaOS_Config_ModuleSaveLaptopDescription";
			sync[] = { "Land_Laptop_03_sand_F_AE3" };

			class Land_Laptop_03_sand_F_AE3
			{
				description[] = {
					"Captures this laptop's files, users, calendar, emails and network settings",
					"into the named save slot."
				};
				position = 1;
				direction = 0;
				optional = 0;
				duplicate = 0;
			};
		};
	};

	/* ================================================================================ */

	// MODULE RESTORE LAPTOP
	class AE3_RestoreLaptop: Module_F
	{
		scope = 2;
		scopeCurator = 2;
		displayName = "$STR_AE3_ArmaOS_Config_RestoreLaptopDisplayName";
		icon = "\z\ae3\addons\armaos\ui\AE3_Module_Icons_addUser.paa";
		category = "AE3_armaosModules";

		function = "AE3_armaos_fnc_module_restoreLaptop";
		functionPriority = 1;
		isGlobal = 0; // server-only execution; reads the server-side snapshot buffer
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		class Attributes: AttributesBase
		{
			class AE3_ModuleSaveSlot: Edit
			{
				property = "AE3_ModuleSaveSlot";
				displayName = "$STR_AE3_ArmaOS_Config_SaveSlotDisplayName";
				tooltip = "$STR_AE3_ArmaOS_Config_SaveSlotTooltip";
				typeName = "STRING";
				defaultValue = """slot1""";
			};
			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "$STR_AE3_ArmaOS_Config_ModuleRestoreLaptopDescription";
			sync[] = { "Land_Laptop_03_sand_F_AE3" };

			class Land_Laptop_03_sand_F_AE3
			{
				description[] = {
					"Overwrites this fresh laptop with the contents saved under the named slot,",
					"replacing a laptop that was lost or disabled."
				};
				position = 1;
				direction = 0;
				optional = 0;
				duplicate = 0;
			};
		};
	};

	/* ================================================================================ */

	// MODULE ADD CALENDAR EVENT
	class AE3_AddCalendarEvent: Module_F
	{
		scope = 2;
		scopeCurator = 2;
		displayName = "AE3: Add Calendar Event";
		icon = "\z\ae3\addons\armaos\ui\AE3_Module_Icons_addUser.paa";
		category = "AE3_armaosModules";

		function = "AE3_armaos_fnc_module_addCalendarEvent";
		functionPriority = 1;
		isGlobal = 1;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		curatorInfoType = "AE3_UserInterface_Zeus_Module_AddCalendarEvent";

		class Attributes: AttributesBase
		{
			// property names match exactly what AE3_armaos_fnc_module_addCalendarEvent reads.
			class AE3_ModuleCalendar_Date: Edit
			{
				property = "AE3_ModuleCalendar_Date";
				displayName = "Date (YYYY-MM-DD)";
				tooltip = "ISO date the event is shown on, e.g. 2026-06-24";
				typeName = "STRING";
				defaultValue = """2026-06-24""";
			};
			class AE3_ModuleCalendar_Title: Edit
			{
				property = "AE3_ModuleCalendar_Title";
				displayName = "Title";
				tooltip = "Short event title";
				typeName = "STRING";
				defaultValue = """Meeting""";
			};
			class AE3_ModuleCalendar_Location: Edit
			{
				property = "AE3_ModuleCalendar_Location";
				displayName = "Location";
				tooltip = "Optional location text";
				typeName = "STRING";
				defaultValue = """""";
			};
			class AE3_ModuleCalendar_Body: Edit
			{
				property = "AE3_ModuleCalendar_Body";
				displayName = "Details";
				tooltip = "Optional longer description / intel body";
				typeName = "STRING";
				defaultValue = """""";
			};
			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "Adds a calendar/intel event (date, title, location, details) to every synced computer. Shown in the laptop Calendar app.";
			sync[] = { "Land_Laptop_03_sand_F_AE3" };

			class Land_Laptop_03_sand_F_AE3
			{
				description[] = { "Target computer" };
				position = 1;
				direction = 1;
				optional = 0;
				duplicate = 0;
			};
		};
	};

	/* ================================================================================ */
};
