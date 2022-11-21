class CfgVehicles 
{
	
	// LAPTOP
	class Land_Laptop_03_sand_F;
	class Land_Laptop_03_sand_F_AE3: Land_Laptop_03_sand_F
	{
		class TextureSources
		{
			class Black
			{
				author = "Bohemia Interactive";
				displayName = "Black";
				factions[] = {};
				textures[] = {"a3\Props_F_Enoch\Military\Equipment\data\Laptop_03_black_CO.paa"};
			};
			class Olive
			{
				author = "Bohemia Interactive";
				displayName = "Olive";
				factions[] = {};
				textures[] = {"a3\Props_F_Enoch\Military\Equipment\data\Laptop_03_olive_CO.paa"};
			};
			class Sand
			{
				displayName = "Sand";
				author = "Bohemia Interactive";
				factions[] = {};
				textures[] = {"a3\Props_F_Enoch\Military\Equipment\data\Laptop_03_sand_CO.paa"};
			};
		};

		simulation = "tankX";
		preciseGetInOut = 0;
		cargoPreciseGetInOut[] = {};
		cargoProxyIndexes[] = {};
		alphaTracks = 0;
		class MFD {};
		class Sounds {};
		canFloat = 0;
		leftDustEffect = "";
		rightDustEffect = "";
		leftWaterEffect = "";
		rightWaterEffect = "";
		tracksSpeed = 0;
		class CargoLight
		{
			ambient[] = {0.6,0,0.15,1};
			brightness = 0.007;
			color[] = {0,0,0,0};
		};
		fireDustEffect = "";
		turnCoef = 0;
		class SquadTitles
		{
			color[] = {0,0,0,0};
			name = "clan_sign";
		};
		class Exhausts {};
		class RenderTargets {};
		driverDoor = "";
		cargoDoors[] = {};
		selectionLeftOffset = "";
		selectionRightOffset = "";
		selectionBrakeLights = "";
		memoryPointMissile = "";
		memoryPointMissileDir = "";
		textureTrackWheel = "";
		memoryPointTrack1L = "";
		memoryPointTrack2L = "";
		gearBox[] = {};
		memoryPointDriverOptics = "";
		memoryPointsGetInDriver = "";
		memoryPointsGetInDriverDir = "";
		memoryPointsGetInCoDriver = "";
		memoryPointsGetInCoDriverDir = "";
		memoryPointsGetInCargo = "";
		memoryPointsGetInCargoDir = "";
		driverLeftHandAnimName = "";
		driverRightHandAnimName = "";
		driverLeftLegAnimName = "";
		driverRightLegAnimName = "";
		soundGear[] = {"",0.316228,1};
		memoryPointsLeftWaterEffect = "";
		memoryPointsRightWaterEffect = "";
		memoryPointCargoLight = "";

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

		class AE3_Equipment
		{
			displayName = "Laptop";

			closeState = 0;

			init = "_this call AE3_interaction_fnc_initLaptop;";

			openAction = "_this call AE3_interaction_fnc_laptop_open;";
			openActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";
			closeAction = "_this call AE3_interaction_fnc_laptop_close;";
			closeActionCondition = "isNull (_this getVariable ['AE3_computer_mutex', objNull])";
		};

		class AE3_Device
		{
			displayName = "Laptop";
			defaultPowerLevel = 0;

			init = "_this call AE3_filesystem_fnc_initFilesystem; _this call AE3_armaos_fnc_link_init; _this call AE3_network_fnc_initNetworkDevice;";

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
				capacity = 0.1; // 100 Watts/hour max. capacity
				recharging = 0.05/3600; // 50 Watts power consumption while recharging
				level = 0.1; // 100 Watts/hour capacity at the beginning
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
						condition = "(alive _target) && (_target getVariable 'AE3_power_powerState' == 1) && (isNull (_target getVariable ['AE3_computer_mutex', objNull]))";
						statement = "params ['_target', '_player', '_params']; _target setVariable ['AE3_computer_mutex', _player, true]; _handle = [_target] spawn AE3_armaos_fnc_terminal_init;";
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
	class AE3_AddUser: Module_F
	{
		// Standard object definitions
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "AE3 Add User"; // Name displayed in the menu
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
				displayName = "Username";
				tooltip = "Name of authorized user, for example 'admin', 'guest' or 'stavros'";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """admin""";
			};
			class AE3_ModuleUserlist_Password: Edit
			{
				property = "AE3_ModuleUserlist_Password1";
				displayName = "Password";
				tooltip = "Password of authorized user, for example '123456', 'password' or 'Qf5&xxR12#fTG'";
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
			description = "This module defines users for an armaOS computer. Simply sync one or more of these modules to a supported computer."; // Short description, will be formatted as structured text
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