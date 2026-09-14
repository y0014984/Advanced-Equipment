// Powered-on-at-start toggle exposed as a 3DEN object attribute, shared by every power device that can
// be switched on and off. AE3_power_fnc_initDevice already switches a device on when AE3_power_startOn
// is set, but an attribute expression can run either side of that initialization, so the expression also
// waits for the device to finish initializing and switches it on itself if the init pass has been and
// gone. Without the attribute the only way to start a device on is an ACE interaction after mission
// start, which a mission maker cannot reach while building the scene.
#define AE3_POWER_STARTON_ATTRIBUTE \
	class AE3_EdenAttribute_PowerStartOn \
	{ \
		displayName = "$STR_AE3_Power_EdenAttributes_StartOnDisplayName"; \
		tooltip = "$STR_AE3_Power_EdenAttributes_StartOnTooltip"; \
		property = "AE3_EdenAttribute_PowerStartOn"; \
		control = "Checkbox"; \
		expression = "private _on = _value in [true, 1]; _this setVariable ['AE3_power_startOn', _on, true]; if (_on) then {[{ params ['_device']; !alive _device || {(_device getVariable ['AE3_power_initDone', false]) && {!isNil {_device getVariable 'AE3_power_fnc_turnOnWrapper'}}} }, { params ['_device']; if (alive _device && {(_device getVariable ['AE3_power_powerState', 0]) != 1}) then {[_device] call AE3_power_fnc_turnOnDevice;}; }, [_this]] call CBA_fnc_waitUntilAndExecute;};"; \
		defaultValue = "false"; \
		validate = "none"; \
		condition = "1"; \
		typeName = "BOOL"; \
	};

class CfgVehicles
{
	/* ================================================================================ */

	// Generator
	class B_Radar_System_01_F;
	class GeneratorMaster_01_F_AE3: B_Radar_System_01_F
	{
		scope = 0; // Dummy Class
		scopeCurator = 0; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		curatorInfoType = "AE3_UserInterface_Zeus_Asset_Details"; // when placing with AI
		curatorInfoTypeEmpty = "AE3_UserInterface_Zeus_Asset_Details"; // when placing without AI

		// Override inherited countermeasure properties to prevent config warnings
		incomingMissileDetectionSystem = 0;
		weaponLockSystem = 0;
		magazines[] = {};
		weapons[] = {};

		// Completely remove countermeasure flare/chaff launchers inherited from radar system
		class Turrets {};

		// Explicitly disable countermeasure classes inherited from radar system
		class EventHandlers {};
		class Components
		{
			class SensorsManagerComponent
			{
				class Components {};
			};
		};

		// Eden Editor Attributes
		class Attributes
		{
			class AE3_EdenAttribute_FuelLevel
			{
				//--- Mandatory properties
				displayName = "$STR_AE3_Main_EdenAttributes_FuelLevelDisplayName"; // Name assigned to UI control class Title
				tooltip = "$STR_AE3_Main_EdenAttributes_FuelLevelTooltip"; // Tooltip assigned to UI control class Title
				property = "AE3_EdenAttribute_FuelLevel"; // Unique config property name saved in SQM
				control = "Slider"; // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

				expression = "_this setVariable ['%s', _value, true];";

				defaultValue = "1";

				//--- Optional properties
				unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for variable names or player control)
				validate = "number"; // Validate the value before saving. If the value is not of given type e.g. "number", the default value will be set. Can be "none", "expression", "condition", "number" or "variable"
				condition = "1"; // Condition for attribute to appear (see the table below)
				typeName = "NUMBER"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
			};
			AE3_POWER_STARTON_ATTRIBUTE
		};

		// scope = 1; //Hide class in 3DEN asset browser

		// Refuel
		ace_refuel_canReceive = 1; // For vehicles which can't be refueled
		ace_refuel_flowRate = 1; // Speed?

		/* -------------------- */

		// Override
		// The generators are the only AE3 assets built on a vehicle base rather than a prop one, and
		// B_Radar_System_01_F is a BLUFOR static. That side is what files an asset under a side in the
		// 3DEN asset browser, so the generators landed under BLUFOR while every other AE3 asset sat in
		// Props - and once faction was overridden to Default, which is not a BLUFOR faction, they had
		// no branch left to appear under at all. Declaring no side puts them in Props beside the rest.
		// Zeus was never affected: the curator browser groups purely by editorCategory.
		side = 4;
		faction = "Default";
		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Power";
		icon = "iconObject_1x1"; // Object gets invisible, except the shadow
		picture = "pictureThing";
		hasDriver = 0;
		getInAction = "";
		maximumLoad = 0;

		cargoCompartments[] = {};
		cargoAction[] = {};
		driverAction = "";
		typicalCargo[] = {};

		fuelConsumptionRate = 0.0;
	};

	/* ================================================================================ */

	class Land_PortableGenerator_01_F_AE3: GeneratorMaster_01_F_AE3
	{
		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Power";

		scope = 2; // Dummy Class
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		model = "\A3\Props_F_Exp\Military\Camps\PortableGenerator_01_F.p3d";
		editorPreview = "\A3\EditorPreviews_F_Exp\Data\CfgVehicles\Land_PortableGenerator_01_F.jpg"; // modified for texture variants
		hiddenSelections[] = {"Camo_1"};
		hiddenSelectionsTextures[] = {"a3\props_f_exp\military\camps\data\portablegenerator_01_co.paa"}; // modified for texture variants
		displayName = "$STR_A3_CfgVehicles_Land_PortableGenerator_01_F0"; // modified for texture variants

		fuelCapacity = "5";
		ace_refuel_fuelCapacity = 5; // Fuel tank volume

		soundStartEngine[] = {"z\ae3\addons\power\sounds\GeneratorStartSound.ogg", 5, 1};
		soundStopEngine[] = {"z\ae3\addons\power\sounds\GeneratorStopSound.ogg", 5, 1};

		// https://www.realitymod.com/forum/showthread.php?t=100826
		class Sounds
		{
			class Engine 
			{
				frequency = "( randomizer*0.05 + 0.95 )";
				volume = "engineOn * camPos";
				sound[] = {"z\ae3\addons\power\sounds\GeneratorRunningSound.ogg", 2, 1, 100};
			};
		};

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_RuggedPortableGeneratorDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "call AE3_power_fnc_turnOnGeneratorAction";
			turnOffAction = "call AE3_power_fnc_turnOffGeneratorAction";

			class AE3_Generator
			{
				fuelConsumption = 1.5; // 1.5 litres per hour consumption
				fuelCapacity = 5; // 5 litres max. tank volume
				fuelLevel = 1; // 100 % full tank; Doesn't work here because this is set via vanilla fuel

				power = 5/3600; // provides max. 5.000 Watts
			};
		};

		class AE3_Equipment
		{
			displayName = "$STR_AE3_Power_Config_RuggedPortableGeneratorDisplayName";

			class AE3_ace3Interactions
			{
				class AE3_aceDragging
				{
					// Dragging
					ae3_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
				class AE3_aceCargo
				{
					ae3_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
					ae3_cargo_size = 4;  // Cargo space the object takes
				};
			};
		};
	};

	/* ================================================================================ */

	class Land_PortableGenerator_01_black_F_AE3: Land_PortableGenerator_01_F_AE3
	{
		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Power";

		editorPreview = "\A3\EditorPreviews_F_Enoch\Data\CfgVehicles\Land_PortableGenerator_01_black_F.jpg"; // modified for texture variants
		hiddenSelectionsTextures[] = {"a3\Props_F_Enoch\Military\Camps\data\PortableGenerator_01_black_CO.paa"}; // modified for texture variants
		displayName = "$STR_A3_C_CfgVehicles_Land_PortableGenerator_01_black_F0"; // modified for texture variants
	};

	/* ================================================================================ */

	class Land_PortableGenerator_01_sand_F_AE3: Land_PortableGenerator_01_F_AE3
	{
		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Power";

		editorPreview = "\A3\EditorPreviews_F_Enoch\Data\CfgVehicles\Land_PortableGenerator_01_sand_F.jpg"; // modified for texture variants
		hiddenSelectionsTextures[] = {"a3\Props_F_Enoch\Military\Camps\data\PortableGenerator_01_sand_CO.paa"}; // modified for texture variants
		displayName = "$STR_A3_C_CfgVehicles_Land_PortableGenerator_01_sand_F0"; // modified for texture variants
	};

	/* ================================================================================ */

	class Land_MobileRadar_01_generator_F_AE3: GeneratorMaster_01_F_AE3
	{
		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Power";

		scope = 2; // Dummy Class
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		model = "\A3\Structures_F_Enoch\Military\Radar\MobileRadar_01_generator_F.p3d";
		editorPreview = "\A3\EditorPreviews_F_Enoch\Data\CfgVehicles\Land_MobileRadar_01_generator_F.jpg"; // modified for texture variants
		hiddenSelections[] = {};
		hiddenSelectionsTextures[] = {}; // modified for texture variants
		displayName = "$STR_A3_C_CfgVehicles_Land_MobileRadar_01_generator_F0"; // modified for texture variants

		fuelCapacity = "470";
		ace_refuel_fuelCapacity = 470; // Fuel tank volume
		
		soundStartEngine[] = {"z\ae3\addons\power\sounds\GeneratorLargeStartSound.ogg", 5, 1};
		soundStopEngine[] = {"z\ae3\addons\power\sounds\GeneratorLargeStopSound.ogg", 5, 1};
		
		// https://www.realitymod.com/forum/showthread.php?t=100826
		class Sounds
		{
			class Engine 
			{
				frequency = "( randomizer*0.05 + 0.95 )";
				volume = "engineOn * camPos";
				sound[] = {"z\ae3\addons\power\sounds\GeneratorLargeRunningSound.ogg", 2, 1, 100};
			};
		};

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_RadarGeneratorDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "call AE3_power_fnc_turnOnGeneratorAction";
			turnOffAction = "call AE3_power_fnc_turnOffGeneratorAction";

			class AE3_Generator
			{
				fuelConsumption = 48.0; // 48 litres per hour consumption
				fuelCapacity = 470; // 400 litres max. tank volume
				fuelLevel = 1; // 100 % full tank; Doesn't work here because this is set via vanilla fuel

				power = 400/3600; // provides max. 400kW
			};
		};
	};

	/* ================================================================================ */

	class Land_DieselGroundPowerUnit_01_F_AE3: GeneratorMaster_01_F_AE3
	{
		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Power";

		scope = 2; // Dummy Class
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		model = "\A3\Structures_F_Heli\Ind\Machines\DieselGroundPowerUnit_01_F.p3d";
		editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\Land_DieselGroundPowerUnit_01_F.jpg"; // modified for texture variants
		hiddenSelections[] = {};
		hiddenSelectionsTextures[] = {}; // modified for texture variants
		displayName = "$STR_AE3_Power_Config_AirportGeneratorDisplayName"; // modified for texture variants

		fuelCapacity = "300";
		ace_refuel_fuelCapacity = 300; // Fuel tank volume
		
		soundStartEngine[] = {"z\ae3\addons\power\sounds\GeneratorAirportStartSound.ogg", 5, 1};
		soundStopEngine[] = {"z\ae3\addons\power\sounds\GeneratorAirportStopSound.ogg", 5, 1};
		
		// https://www.realitymod.com/forum/showthread.php?t=100826
		class Sounds
		{
			class Engine 
			{
				frequency = "( randomizer*0.05 + 0.95 )";
				volume = "engineOn * camPos";
				sound[] = {"z\ae3\addons\power\sounds\GeneratorAirportRunningSound.ogg", 2, 1, 100};
			};
		};

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_AirportGeneratorDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "call AE3_power_fnc_turnOnGeneratorAction";
			turnOffAction = "call AE3_power_fnc_turnOffGeneratorAction";

			class AE3_Generator
			{
				fuelConsumption = 30; // 48 litres per hour consumption
				fuelCapacity = 300; // 400 litres max. tank volume
				fuelLevel = 1; // 100 % full tank; Doesn't work here because this is set via vanilla fuel

				power = 100/3600; // provides max. 100 kW
			};
		};
	};

	/* ================================================================================ */

	class Land_PowerGenerator_F_AE3: GeneratorMaster_01_F_AE3
	{
		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Power";

		scope = 2; // Dummy Class
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		model = "\A3\Structures_F\Ind\WindPowerPlant\PowerGenerator_F.p3d";
		editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\Land_PowerGenerator_F.jpg"; // modified for texture variants
		hiddenSelections[] = {};
		hiddenSelectionsTextures[] = {}; // modified for texture variants
		displayName = "$STR_A3_CfgVehicles_Land_PowerGenerator_F0"; // modified for texture variants

		fuelCapacity = "300";
		ace_refuel_fuelCapacity = 300; // Fuel tank volume
		
		soundStartEngine[] = {"z\ae3\addons\power\sounds\GeneratorAirportStartSound.ogg", 5, 1};
		soundStopEngine[] = {"z\ae3\addons\power\sounds\GeneratorAirportStopSound.ogg", 5, 1};
		
		// https://www.realitymod.com/forum/showthread.php?t=100826
		class Sounds
		{
			class Engine 
			{
				frequency = "( randomizer*0.05 + 0.95 )";
				volume = "engineOn * camPos";
				sound[] = {"z\ae3\addons\power\sounds\GeneratorAirportRunningSound.ogg", 2, 1, 100};
			};
		};

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_PowerGeneratorDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "call AE3_power_fnc_turnOnGeneratorAction";
			turnOffAction = "call AE3_power_fnc_turnOffGeneratorAction";

			class AE3_Generator
			{
				fuelConsumption = 30; // 48 litres per hour consumption
				fuelCapacity = 300; // 400 litres max. tank volume
				fuelLevel = 1; // 100 % full tank; Doesn't work here because this is set via vanilla fuel

				power = 100/3600; // provides max. 100 kW
			};
		};
	};

	/* ================================================================================ */

	class Land_Portable_generator_F_AE3: GeneratorMaster_01_F_AE3
	{
		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Power";

		scope = 2; // Dummy Class
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.
		
		model = "\A3\Structures_F\Items\Electronics\Portable_generator_F.p3d";
		editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\Land_Portable_generator_F.jpg"; // modified for texture variants
		hiddenSelections[] = {};
		hiddenSelectionsTextures[] = {}; // modified for texture variants
		displayName = "$STR_A3_cfgVehicles_Land_Portable_generator_F0"; // modified for texture variants

		fuelCapacity = "5";
		ace_refuel_fuelCapacity = 5; // Fuel tank volume
		
		soundStartEngine[] = {"z\ae3\addons\power\sounds\GeneratorStartSound.ogg", 5, 1};
		soundStopEngine[] = {"z\ae3\addons\power\sounds\GeneratorStopSound.ogg", 5, 1};
		
		// https://www.realitymod.com/forum/showthread.php?t=100826
		class Sounds
		{
			class Engine 
			{
				frequency = "( randomizer*0.05 + 0.95 )";
				volume = "engineOn * camPos";
				sound[] = {"z\ae3\addons\power\sounds\GeneratorRunningSound.ogg", 2, 1, 100};
			};
		};

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_PortableGeneratorDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "call AE3_power_fnc_turnOnGeneratorAction";
			turnOffAction = "call AE3_power_fnc_turnOffGeneratorAction";

			class AE3_Generator
			{
				fuelConsumption = 1.5; // 48 litres per hour consumption
				fuelCapacity = 5; // 400 litres max. tank volume
				fuelLevel = 1; // 100 % full tank; Doesn't work here because this is set via vanilla fuel

				power = 5/3600; // provides max. 5 kW
			};
		};

		class AE3_Equipment
		{
			displayName = "$STR_AE3_Power_Config_PortableGeneratorDisplayName";

			class AE3_ace3Interactions
			{
				class AE3_aceDragging
				{
					// Dragging
					ae3_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
				class AE3_aceCargo
				{
					ae3_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
					ae3_cargo_size = 4;  // Cargo space the object takes
				};
			};
		};
	};

	/* ================================================================================ */

	// RUGGED BATTERY PACK OLIVE
	class Land_BatteryPack_01_open_olive_F;
	class Land_BatteryPack_01_open_olive_F_AE3 : Land_BatteryPack_01_open_olive_F
	{
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Battery";

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
			AE3_POWER_STARTON_ATTRIBUTE
		};

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_BatteryDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "call AE3_power_fnc_turnOnBatteryAction";
			turnOffAction = "call AE3_power_fnc_turnOffBatteryAction";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Battery
			{
				capacity = 0.6; // 600 Watts/hour max. capacity
				recharging = 0.3/3600; // 300 Watts power consumption while recharging
				level = 0.6; // 600 Watts/hour capacity at the beginning
				internal = 0;
			};
		};
    
 		class AE3_Equipment
		{
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
	};

	/* ================================================================================ */

	// RUGGED BATTERY PACK BLACK
	class Land_BatteryPack_01_open_black_F;
	class Land_BatteryPack_01_open_black_F_AE3 : Land_BatteryPack_01_open_black_F
	{
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Battery";

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
			AE3_POWER_STARTON_ATTRIBUTE
		};
    
		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_BatteryDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "call AE3_power_fnc_turnOnBatteryAction";
			turnOffAction = "call AE3_power_fnc_turnOffBatteryAction";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Battery
			{
				capacity = 0.6; // 600 Watts/hour max. capacity
				recharging = 0.3/3600; // 300 Watts power consumption while recharging
				level = 0.6; // 600 Watts/hour capacity at the beginning
				internal = 0;
			};
		};
    
 		class AE3_Equipment
		{
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
	};

	/* ================================================================================ */

	// RUGGED BATTERY PACK SAND
	class Land_BatteryPack_01_open_sand_F;
	class Land_BatteryPack_01_open_sand_F_AE3 : Land_BatteryPack_01_open_sand_F
	{
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Battery";

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
			AE3_POWER_STARTON_ATTRIBUTE
		};
    
		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_BatteryDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "call AE3_power_fnc_turnOnBatteryAction";
			turnOffAction = "call AE3_power_fnc_turnOffBatteryAction";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Battery
			{
				capacity = 0.6; // 600 Watts/hour max. capacity
				recharging = 0.3/3600; // 300 Watts power consumption while recharging
				level = 0.6; // 600 Watts/hour capacity at the beginning
				internal = 0;
			};
		};

		class AE3_Equipment
		{
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
	};

	/* ================================================================================ */

	// RUGGED SOLAR PANEL OLIVE
	class Land_SolarPanel_04_olive_F;
	class Land_SolarPanel_04_olive_F_AE3 : Land_SolarPanel_04_olive_F
	{
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_SolarPanel";

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

				defaultValue = "0";

				//--- Optional properties
				unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for variable names or player control)
				validate = "number"; // Validate the value before saving. If the value is not of given type e.g. "number", the default value will be set. Can be "none", "expression", "condition", "number" or "variable"
				condition = "1"; // Condition for attribute to appear (see the table below)
				typeName = "NUMBER"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
			};
			AE3_POWER_STARTON_ATTRIBUTE
		};

		// Cargo
		ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
		ace_cargo_size = 2;  // Cargo space the object takes

		class AE3_Equipment
		{
			displayName = "$STR_AE3_Power_Config_SolarPanelDisplayName";

			init = "call AE3_interaction_fnc_initSolarPanel;";

			class AE3_ace3Interactions
			{
				class AE3_aceDragging
				{
					// Dragging
					ae3_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
				class AE3_aceCargo
				{
					ae3_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
					ae3_cargo_size = 2;  // Cargo space the object takes
				};
			};

			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "$STR_AE3_Power_Config_SolarPanel1";
					selection = "panel_1";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Power_Config_PitchSolarPanel1";
						animation = "Panel_1_Pitch";
						minValue = -45;
						maxValue = 45;
						scrollMultiplier = 5;
					};
				};

				class AE3_Animation_Point_1
				{
					description = "$STR_AE3_Power_Config_SolarPanel2";
					selection = "panel_2";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Power_Config_PitchSolarPanel2";
						animation = "Panel_2_Pitch";
						minValue = -45;
						maxValue = 45;
						scrollMultiplier = 5;
					};
				};
				
				class AE3_Animation_Point_2
				{
					description = "$STR_AE3_Power_Config_SolarPanelsDisplayName";
					selection = "panels_base";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Power_Config_YawSolarPanels";
						animation = "Panels_Yaw";
						minValue = -180;
						maxValue = 180;
						scrollMultiplier = 10;
					};
				};
			};
		};

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_SolarPanelDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "call AE3_power_fnc_turnOnSolarAction";
			turnOffAction = "call AE3_power_fnc_turnOffSolarAction";

			class AE3_SolarGenerator
			{
				powerMax = 0.1/3600; // In this case per panel
				orientationFnc = "call AE3_power_fnc_multSolarPanelOrientation";
				height = 1.2;
			};
		};

		class AE3_InternalDevice
		{
			displayName = "$STR_AE3_Power_Config_BatteryDisplayName";
			defaultPowerLevel = 1;

			turnOnAction = "_this + [true] call AE3_power_fnc_turnOnBatteryAction";
			turnOffAction = "";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Battery
			{
				capacity = 0.4;
				recharging = 0.05/3600;
				level = 0;
				internal = 1;
			};
		};
	};

	/* ================================================================================ */

	// RUGGED SOLAR PANEL BLACK
	class Land_SolarPanel_04_black_F;
	class Land_SolarPanel_04_black_F_AE3 : Land_SolarPanel_04_black_F
	{
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_SolarPanel";

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

				defaultValue = "0";

				//--- Optional properties
				unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for variable names or player control)
				validate = "number"; // Validate the value before saving. If the value is not of given type e.g. "number", the default value will be set. Can be "none", "expression", "condition", "number" or "variable"
				condition = "1"; // Condition for attribute to appear (see the table below)
				typeName = "NUMBER"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
			};
			AE3_POWER_STARTON_ATTRIBUTE
		};
    
		// Cargo
		ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
		ace_cargo_size = 2;  // Cargo space the object takes

		class AE3_Equipment
		{
			displayName = "$STR_AE3_Power_Config_SolarPanelDisplayName";

			init = "call AE3_interaction_fnc_initSolarPanel;";

			class AE3_ace3Interactions
			{
				class AE3_aceDragging
				{
					// Dragging
					ae3_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
				class AE3_aceCargo
				{
					ae3_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
					ae3_cargo_size = 2;  // Cargo space the object takes
				};
			};

			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "$STR_AE3_Power_Config_SolarPanel1";
					selection = "panel_1";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Power_Config_PitchSolarPanel1";
						animation = "Panel_1_Pitch";
						minValue = -45;
						maxValue = 45;
						scrollMultiplier = 5;
					};
				};

				class AE3_Animation_Point_1
				{
					description = "$STR_AE3_Power_Config_SolarPanel2";
					selection = "panel_2";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Power_Config_PitchSolarPanel2";
						animation = "Panel_2_Pitch";
						minValue = -45;
						maxValue = 45;
						scrollMultiplier = 5;
					};
				};
				
				class AE3_Animation_Point_2
				{
					description = "$STR_AE3_Power_Config_SolarPanelsDisplayName";
					selection = "panels_base";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Power_Config_YawSolarPanels";
						animation = "Panels_Yaw";
						minValue = -180;
						maxValue = 180;
						scrollMultiplier = 10;
					};
				};
			};
		};

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_SolarPanelDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "call AE3_power_fnc_turnOnSolarAction";
			turnOffAction = "call AE3_power_fnc_turnOffSolarAction";

			class AE3_SolarGenerator
			{
				powerMax = 0.1/3600; // In this case per panel
				orientationFnc = "call AE3_power_fnc_multSolarPanelOrientation";
				height = 1.2;
			};
		};

		class AE3_InternalDevice
		{
			displayName = "$STR_AE3_Power_Config_BatteryDisplayName";
			defaultPowerLevel = 1;

			turnOnAction = "_this + [true] call AE3_power_fnc_turnOnBatteryAction";
			turnOffAction = "";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Battery
			{
				capacity = 0.4;
				recharging = 0.05/3600;
				level = 0;
				internal = 1;
			};
		};
	};

	/* ================================================================================ */

	// RUGGED SOLAR PANEL SAND
	class Land_SolarPanel_04_sand_F;
	class Land_SolarPanel_04_sand_F_AE3 : Land_SolarPanel_04_sand_F
	{
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_SolarPanel";

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

				defaultValue = "0";

				//--- Optional properties
				unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for variable names or player control)
				validate = "number"; // Validate the value before saving. If the value is not of given type e.g. "number", the default value will be set. Can be "none", "expression", "condition", "number" or "variable"
				condition = "1"; // Condition for attribute to appear (see the table below)
				typeName = "NUMBER"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
			};
			AE3_POWER_STARTON_ATTRIBUTE
		};
    
		class AE3_Equipment
		{
			displayName = "$STR_AE3_Power_Config_SolarPanelDisplayName";

			init = "call AE3_interaction_fnc_initSolarPanel;";

			class AE3_ace3Interactions
			{
				class AE3_aceDragging
				{
					// Dragging
					ae3_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
				class AE3_aceCargo
				{
					ae3_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
					ae3_cargo_size = 2;  // Cargo space the object takes
				};
			};

			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "$STR_AE3_Power_Config_SolarPanel1";
					selection = "panel_1";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Power_Config_PitchSolarPanel1";
						animation = "Panel_1_Pitch";
						minValue = -45;
						maxValue = 45;
						scrollMultiplier = 5;
					};
				};

				class AE3_Animation_Point_1
				{
					description = "$STR_AE3_Power_Config_SolarPanel2";
					selection = "panel_2";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Power_Config_PitchSolarPanel2";
						animation = "Panel_2_Pitch";
						minValue = -45;
						maxValue = 45;
						scrollMultiplier = 5;
					};
				};
				
				class AE3_Animation_Point_2
				{
					description = "$STR_AE3_Power_Config_SolarPanelsDisplayName";
					selection = "panels_base";

					class AE3_Animation_Main
					{
						description = "$STR_AE3_Power_Config_YawSolarPanels";
						animation = "Panels_Yaw";
						minValue = -180;
						maxValue = 180;
						scrollMultiplier = 10;
					};
				};
			};
		};

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_SolarPanelDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "call AE3_power_fnc_turnOnSolarAction";
			turnOffAction = "call AE3_power_fnc_turnOffSolarAction";

			class AE3_SolarGenerator
			{
				powerMax = 0.1/3600; // In this case per panel
				orientationFnc = "call AE3_power_fnc_multSolarPanelOrientation";
				height = 1.2;
			};
		};

		class AE3_InternalDevice
		{
			displayName = "$STR_AE3_Power_Config_BatteryDisplayName";
			defaultPowerLevel = 1;

			turnOnAction = "_this + [true] call AE3_power_fnc_turnOnBatteryAction";
			turnOffAction = "";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Battery
			{
				capacity = 0.4;
				recharging = 0.05/3600;
				level = 0;
				internal = 1;
			};
		};
	};

	/* ================================================================================ */

	// FLEXIBLE SOLAR PANEL OLIVE
	class Land_PortableSolarPanel_01_olive_F;
	class Land_PortableSolarPanel_01_olive_F_AE3 : Land_PortableSolarPanel_01_olive_F
	{
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_SolarPanel";

		curatorInfoTypeEmpty = "AE3_UserInterface_Zeus_Asset_Details";

		// Eden Editor Attributes
		class Attributes
		{
			AE3_POWER_STARTON_ATTRIBUTE
		};

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_SolarPanelDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "call AE3_power_fnc_turnOnSolarAction";
			turnOffAction = "call AE3_power_fnc_turnOffSolarAction";

			class AE3_SolarGenerator
			{
				powerMax = 0.15/3600;
				orientationFnc = "[(vectorUp (_this select 0))]";
				height = 0.1;
			};
		};
    
 		class AE3_Equipment
		{
			class AE3_ace3Interactions
			{
				class AE3_aceDragging
				{
					// Dragging
					ae3_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
				class AE3_aceCargo
				{
					ae3_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
					ae3_cargo_size = 1;  // Cargo space the object takes
				};
			};
		};
	};

	/* ================================================================================ */

	// FLEXIBLE SOLAR PANEL SAND
	class Land_PortableSolarPanel_01_sand_F;
	class Land_PortableSolarPanel_01_sand_F_AE3 : Land_PortableSolarPanel_01_sand_F
	{
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_SolarPanel";

		curatorInfoTypeEmpty = "AE3_UserInterface_Zeus_Asset_Details";

		// Eden Editor Attributes
		class Attributes
		{
			AE3_POWER_STARTON_ATTRIBUTE
		};

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_SolarPanelDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "call AE3_power_fnc_turnOnSolarAction";
			turnOffAction = "call AE3_power_fnc_turnOffSolarAction";

			class AE3_SolarGenerator
			{
				powerMax = 0.15/3600;
				orientationFnc = "[(vectorUp (_this select 0))]";
				height = 0.1;
			};
		};

		class AE3_Equipment
		{
			class AE3_ace3Interactions
			{
				class AE3_aceDragging
				{
					// Dragging
					ae3_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
				class AE3_aceCargo
				{
					ae3_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
					ae3_cargo_size = 1;  // Cargo space the object takes
				};
			};
		};
	};

	/* ================================================================================ */
};
