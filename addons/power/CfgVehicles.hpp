class CfgVehicles 
{
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
						statement = "params ['_target', '_player', '_params']; _handle = [_target] spawn AE3_power_fnc_checkFuelLevelAction;";
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
						statement = "params ['_target', '_player', '_params']; _handle = [_target] spawn AE3_power_fnc_turnOnGeneratorAction;";
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
						statement = "params ['_target', '_player', '_params']; _handle = [_target, false] spawn AE3_power_fnc_turnOffGeneratorAction;";
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

};