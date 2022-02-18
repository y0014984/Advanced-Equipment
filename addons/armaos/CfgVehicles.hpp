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
			//init = "params ['_entity']; call compile preprocessFileLineNumbers '\z\ae3\addons\main\init\initLaptop.sqf';";
		};

		class AE3_Device
		{
			displayName = "Laptop";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_armaos_fnc_computer_addActionTurnOn;";
			turnOffAction = "_this call AE3_armaos_fnc_computer_addActionTurnOff;";
			standByAction = "_this call AE3_armaos_fnc_computer_addActionStandby;";

			class AE3_Consumer
			{
				powerConsumption = 0.01/3600;
				standbyConsumption = 0.0001/3600;
			};
		};

		class AE3_InternalDevice
		{
			displayName = "Battery";
			defaultPowerLevel = 1;

			turnOnAction = "_this + [true] call AE3_power_fnc_turnOnBatteryAction";
			turnOffAction = "";

			class AE3_PowerInterface
			{
				internal = 1;
			};

			class AE3_Battery
			{
				capacity = 0.1;
				recharging = 0.05/3600;
				level = 0.1;
				internal = 1;
			};
		};

		
        class ACE_Actions 
		{
			class ACE_MainActions
			{
				displayName = "Interaktionen";
				condition = "true";
				distance = 2;
				class AE3_Laptop_Group
				{
					displayName = "ArmaOS";
					condition = "true";
					class AE3_UseComputer
					{
						displayName = "Use";
						condition = "(alive _target) and (_target getVariable 'AE3_power_powerState' == 1)";
						statement = "params ['_target', '_player', '_params']; _handle = [_target] call AE3_armaos_fnc_terminal_init;";
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