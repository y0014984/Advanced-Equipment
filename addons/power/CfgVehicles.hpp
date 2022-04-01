class CfgVehicles 
{
	/* ================================================================================ */

	// Generator
	class B_Quadbike_01_F;
	//class Land_PortableGenerator_01_sand_F;
	class Land_PortableGenerator_01_sand_F_AE3: B_Quadbike_01_F
	{
		// Cargo
		ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
		ace_cargo_size = 4;  // Cargo space the object takes

		// Refuel
		ace_refuel_canReceive = 1; // For vehicles which can't be refueled
		ace_refuel_fuelCapacity = 5; // Fuel tank volume
		ace_refuel_flowRate = 1; // Speed?

		class AE3_Device
		{
			displayName = "Portable Generator";
			defaultPowerLevel = 0;

			turnOnAction = "_this call AE3_power_fnc_turnOnGeneratorAction";
			turnOffAction = "_this call AE3_power_fnc_turnOffGeneratorAction";

			class AE3_Generator
			{
				fuelConsumption = 1.5; // 1.5 litres per hour consumption
				fuelCapacity = 5; // 5 litres max. tank volume
				fuelLevel = 1; // 100 % full tank

				power = 5/3600; // provides max. 5.000 Watts
			};
		};

		class AE3_Equipment
		{
			displayName = "Portable Generator";

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
		displayName = "Portable Generator";
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

		soundEngine[] = {"z\ae3\addons\power\sounds\GeneratorRunningSound.ogg", 5, 1};
		soundStartEngine[] = {"z\ae3\addons\power\sounds\GeneratorStartSound.ogg", 5, 1};
		soundStopEngine[] = {"z\ae3\addons\power\sounds\GeneratorStopSound.ogg", 5, 1};

		class TextureSources
		{
			class Black
			{
				author = "Bohemia Interactive";
				displayName = "Black";
				factions[] = {};
				textures[] = {"a3\Props_F_Enoch\Military\Camps\data\PortableGenerator_01_black_CO.paa"};
			};
			class Olive
			{
				author = "Bohemia Interactive";
				displayName = "Olive";
				factions[] = {};
				textures[] = {"a3\props_f_exp\military\camps\data\portablegenerator_01_co.paa"};
			};
			class Sand
			{
				displayName = "Sand";
				author = "Bohemia Interactive";
				factions[] = {};
				textures[] = {"a3\Props_F_Enoch\Military\Camps\data\PortableGenerator_01_sand_CO.paa"};
			};
		};
	};

	/* ================================================================================ */

	// Batteries
	class Land_BatteryPack_01_open_sand_F;

	class Land_BatteryPack_01_open_sand_F_AE3 : Land_BatteryPack_01_open_sand_F
	{
		class TextureSources
		{
			class Black
			{
				author = "Bohemia Interactive";
				displayName = "Black";
				factions[] = {};
				textures[] = {"a3\Props_F_Enoch\Military\Equipment\data\BatteryPack_01_Black_CO.paa"};
			};
			class Olive
			{
				author = "Bohemia Interactive";
				displayName = "Olive";
				factions[] = {};
				textures[] = {"a3\Props_F_Enoch\Military\Equipment\data\BatteryPack_01_Olive_CO.paa"};
			};
			class Sand
			{
				displayName = "Sand";
				author = "Bohemia Interactive";
				factions[] = {};
				textures[] = {"a3\Props_F_Enoch\Military\Equipment\data\BatteryPack_01_Sand_CO.paa"};
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

		class AE3_Device
		{
			displayName = "Battery";
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

	// Solar Panel
	class Land_SolarPanel_04_sand_F;

	class Land_SolarPanel_04_sand_F_AE3 : Land_SolarPanel_04_sand_F
	{
		// Dragging
		ace_dragging_canDrag = 1;  // Can be dragged (0-no, 1-yes)
		ace_dragging_dragPosition[] = {0, 1, 0};  // Offset of the model from the body while dragging (same as attachTo)
		ace_dragging_dragDirection = 0;  // Model direction while dragging (same as setDir after attachTo)

		// Cargo
		ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
		ace_cargo_size = 2;  // Cargo space the object takes

		class AE3_Equipment
		{
			displayName = "Solar Panel";

			init = "_this call AE3_interaction_fnc_initSolarPanel;";

			class AE3_Animations
			{
				class AE3_Animation_Point_0
				{
					description = "solar panel 1";
					selection = "panel_1";

					class AE3_Animation_Main
					{
						description = "pitch solar panel 1";
						animation = "Panel_1_Pitch";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};

				class AE3_Animation_Point_1
				{
					description = "solar panel 2";
					selection = "panel_2";

					class AE3_Animation_Main
					{
						description = "pitch solar panel 2";
						animation = "Panel_2_Pitch";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};
				
				class AE3_Animation_Point_2
				{
					description = "solar panels";
					selection = "panels_base";

					class AE3_Animation_Main
					{
						description = "yaw solar panels";
						animation = "Panels_Yaw";
						minValue = -90;
						maxValue = 90;
						scrollMultiplier = 10;
					};
				};
			};
		};
	};

	/* ================================================================================ */
};