class CfgVehicles 
{
	/* ================================================================================ */

	//Generator Dummy
	class Land_PortableGenerator_01_F;
	class Land_PortableGenerator_01_black_F;
	class Land_PortableGenerator_01_sand_F;

	class Land_PortableGenerator_01_F_AE3_Dummy: Land_PortableGenerator_01_F
	{
		// Event Handlers
		class EventHandlers
		{
			init = "params ['_entity']; [_entity, 'Land_PortableGenerator_01_sand_F_AE3'] call AE3_main_fnc_replace;";
		};
	};

	class Land_PortableGenerator_01_black_F_AE3_Dummy: Land_PortableGenerator_01_black_F
	{
		// Event Handlers
		class EventHandlers
		{
			init = "params ['_entity']; [_entity, 'Land_PortableGenerator_01_sand_F_AE3', 'Black'] call AE3_main_fnc_replace;";
		};
	};

	class Land_PortableGenerator_01_sand_F_AE3_Dummy: Land_PortableGenerator_01_sand_F
	{
		// Event Handlers
		class EventHandlers
		{
			init = "params ['_entity']; [_entity, 'Land_PortableGenerator_01_sand_F_AE3', 'Sand'] call AE3_main_fnc_replace;";
		};
	};

	// Generator
	class B_Radar_System_01_F;

	class Land_PortableGenerator_01_sand_F_AE3: B_Radar_System_01_F
	{
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
		};

		// scope = 1; //Hide class in 3DEN asset browser

		// Cargo
		ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
		ace_cargo_size = 4;  // Cargo space the object takes

		// Refuel
		ace_refuel_canReceive = 1; // For vehicles which can't be refueled
		ace_refuel_fuelCapacity = 5; // Fuel tank volume
		ace_refuel_flowRate = 1; // Speed?

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_GeneratorDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_power_fnc_turnOnGeneratorAction";
			turnOffAction = "_this call AE3_power_fnc_turnOffGeneratorAction";

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
			displayName = "$STR_AE3_Power_Config_GeneratorDisplayName";

			class AE3_aceWorkaround
			{
				class AE3_aceDragging
				{
					// Dragging
					ae3_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
			};
		};

		/* -------------------- */

		// Override
		faction = "Default";
		editorCategory = "EdCat_Things";
		editorSubcategory = "EdSubcat_Electronics";
		editorPreview = "\A3\EditorPreviews_F_Enoch\Data\CfgVehicles\Land_PortableGenerator_01_sand_F.jpg";
		model = "\A3\Props_F_Exp\Military\Camps\PortableGenerator_01_F.p3d";
		hiddenSelections[] = {"Camo_1", "Camo_2", "Camo_3"};
		hiddenSelectionsTextures[] = {"a3\Props_F_Enoch\Military\Camps\data\PortableGenerator_01_sand_CO.paa", "a3\props_f_exp\military\camps\data\portablegenerator_01_co.paa", "a3\Props_F_Enoch\Military\Camps\data\PortableGenerator_01_black_CO.paa"};
		icon = "iconObject_1x1"; // Object gets invisible, except the shadow
		picture = "pictureThing";
		displayName = "$STR_AE3_Power_Config_GeneratorDisplayName";
		hasDriver = 0;
		getInAction = "";
		maximumLoad = 0;

		cargoCompartments[] = {};
		cargoAction[] = {};
		driverAction = "";
		typicalCargo[] = {};
		weapons[] = {};

		fuelCapacity = "5";
		fuelConsumptionRate = 0.0;
		
		textureList[] = {"Sand",1};

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

		class TextureSources
		{
			class Black
			{
				author = "Bohemia Interactive";
				displayName = "$STR_AE3_Power_Config_TextureBlack";
				factions[] = {};
				textures[] = {"a3\Props_F_Enoch\Military\Camps\data\PortableGenerator_01_black_CO.paa"};
			};
			class Olive
			{
				author = "Bohemia Interactive";
				displayName = "$STR_AE3_Power_Config_TextureOlive";
				factions[] = {};
				textures[] = {"a3\props_f_exp\military\camps\data\portablegenerator_01_co.paa"};
			};
			class Sand
			{
				displayName = "$STR_AE3_Power_Config_TextureSand";
				author = "Bohemia Interactive";
				factions[] = {};
				textures[] = {"a3\Props_F_Enoch\Military\Camps\data\PortableGenerator_01_sand_CO.paa"};
			};
		};
	};

	/* ================================================================================ */

	// RUGGED BATTERY PACK OLIVE
	class Land_BatteryPack_01_open_olive_F;
	class Land_BatteryPack_01_open_olive_F_AE3 : Land_BatteryPack_01_open_olive_F
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
		};

		// Carrying
		ace_dragging_canCarry = 1;  // Can be carried (0-no, 1-yes)
		ace_dragging_carryPosition[] = {0, 1, 1};  // Offset of the model from the body while dragging (same as attachTo)
		ace_dragging_carryDirection = 0;  // Model direction while dragging (same as setDir after attachTo)

		// Cargo
		ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
		ace_cargo_size = 1;  // Cargo space the object takes

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_BatteryDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_power_fnc_turnOnBatteryAction";
			turnOffAction = "_this call AE3_power_fnc_turnOffBatteryAction";

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
	};

	/* ================================================================================ */

	// RUGGED BATTERY PACK BLACK
	class Land_BatteryPack_01_open_black_F;
	class Land_BatteryPack_01_open_black_F_AE3 : Land_BatteryPack_01_open_black_F
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
		};
    
		// Carrying
		ace_dragging_canCarry = 1;  // Can be carried (0-no, 1-yes)
		ace_dragging_carryPosition[] = {0, 1, 1};  // Offset of the model from the body while dragging (same as attachTo)
		ace_dragging_carryDirection = 0;  // Model direction while dragging (same as setDir after attachTo)

		// Cargo
		ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
		ace_cargo_size = 1;  // Cargo space the object takes

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_BatteryDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_power_fnc_turnOnBatteryAction";
			turnOffAction = "_this call AE3_power_fnc_turnOffBatteryAction";

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
	};

	/* ================================================================================ */

	// RUGGED BATTERY PACK SAND
	class Land_BatteryPack_01_open_sand_F;
	class Land_BatteryPack_01_open_sand_F_AE3 : Land_BatteryPack_01_open_sand_F
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
		};
    
		// Carrying
		ace_dragging_canCarry = 1;  // Can be carried (0-no, 1-yes)
		ace_dragging_carryPosition[] = {0, 1, 1};  // Offset of the model from the body while dragging (same as attachTo)
		ace_dragging_carryDirection = 0;  // Model direction while dragging (same as setDir after attachTo)

		// Cargo
		ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
		ace_cargo_size = 1;  // Cargo space the object takes

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_BatteryDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_power_fnc_turnOnBatteryAction";
			turnOffAction = "_this call AE3_power_fnc_turnOffBatteryAction";

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
	};

	/* ================================================================================ */

	// RUGGED SOLAR PANEL OLIVE
	class Land_SolarPanel_04_olive_F;
	class Land_SolarPanel_04_olive_F_AE3 : Land_SolarPanel_04_olive_F
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

				defaultValue = "0";

				//--- Optional properties
				unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for variable names or player control)
				validate = "number"; // Validate the value before saving. If the value is not of given type e.g. "number", the default value will be set. Can be "none", "expression", "condition", "number" or "variable"
				condition = "1"; // Condition for attribute to appear (see the table below)
				typeName = "NUMBER"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
			};
		};

		// Cargo
		ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
		ace_cargo_size = 2;  // Cargo space the object takes

		class AE3_Equipment
		{
			displayName = "$STR_AE3_Power_Config_SolarPanelDisplayName";

			init = "_this call AE3_interaction_fnc_initSolarPanel;";

			class AE3_aceWorkaround
			{
				class AE3_aceDragging
				{
					// Dragging
					ae3_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
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

			turnOnAction = "_this call AE3_power_fnc_turnOnSolarAction";
			turnOffAction = "_this call AE3_power_fnc_turnOffSolarAction";

			class AE3_SolarGenerator
			{
				powerMax = 0.1/3600; // In this case per panel
				orientationFnc = "_this call AE3_power_fnc_multSolarPanelOrientation";
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
		};
    
		// Cargo
		ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
		ace_cargo_size = 2;  // Cargo space the object takes

		class AE3_Equipment
		{
			displayName = "$STR_AE3_Power_Config_SolarPanelDisplayName";

			init = "_this call AE3_interaction_fnc_initSolarPanel;";

			class AE3_aceWorkaround
			{
				class AE3_aceDragging
				{
					// Dragging
					ae3_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
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

			turnOnAction = "_this call AE3_power_fnc_turnOnSolarAction";
			turnOffAction = "_this call AE3_power_fnc_turnOffSolarAction";

			class AE3_SolarGenerator
			{
				powerMax = 0.1/3600; // In this case per panel
				orientationFnc = "_this call AE3_power_fnc_multSolarPanelOrientation";
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
		};
    
		// Cargo
		ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
		ace_cargo_size = 2;  // Cargo space the object takes

		class AE3_Equipment
		{
			displayName = "$STR_AE3_Power_Config_SolarPanelDisplayName";

			init = "_this call AE3_interaction_fnc_initSolarPanel;";

			class AE3_aceWorkaround
			{
				class AE3_aceDragging
				{
					// Dragging
					ae3_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
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

			turnOnAction = "_this call AE3_power_fnc_turnOnSolarAction";
			turnOffAction = "_this call AE3_power_fnc_turnOffSolarAction";

			class AE3_SolarGenerator
			{
				powerMax = 0.1/3600; // In this case per panel
				orientationFnc = "_this call AE3_power_fnc_multSolarPanelOrientation";
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
		// Dragging
        ace_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
        ace_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
        ace_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)

		// Cargo
        ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
        ace_cargo_size = 1;  // Cargo space the object takes

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_SolarPanelDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_power_fnc_turnOnSolarAction";
			turnOffAction = "_this call AE3_power_fnc_turnOffSolarAction";

			class AE3_SolarGenerator
			{
				powerMax = 0.15/3600;
				orientationFnc = "[(vectorUp (_this select 0))]";
				height = 0.1;
			};
		};
	};

	/* ================================================================================ */

	// FLEXIBLE SOLAR PANEL SAND
	class Land_PortableSolarPanel_01_sand_F;
	class Land_PortableSolarPanel_01_sand_F_AE3 : Land_PortableSolarPanel_01_sand_F
	{
		// Dragging
        ace_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
        ace_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
        ace_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)

		// Cargo
        ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
        ace_cargo_size = 1;  // Cargo space the object takes

		class AE3_Device
		{
			displayName = "$STR_AE3_Power_Config_SolarPanelDisplayName";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_power_fnc_turnOnSolarAction";
			turnOffAction = "_this call AE3_power_fnc_turnOffSolarAction";

			class AE3_SolarGenerator
			{
				powerMax = 0.15/3600;
				orientationFnc = "[(vectorUp (_this select 0))]";
				height = 0.1;
			};
		};
	};

	/* ================================================================================ */
};