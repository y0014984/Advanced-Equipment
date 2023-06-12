class CfgVehicles 
{
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

	// MODULE ADD CONNECTION (ZEUS ONLY MODULE)
	class AE3_AddConnection: Module_F
	{
		// Standard object definitions
		scope = 1; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.
		displayName = "$STR_AE3_Main_Config_ModuleAddConnectionDisplayName"; // Name displayed in the menu
		icon = "\z\ae3\addons\main\ui\AE3_Module_Icon_addConnection.paa"; // Map icon. Delete this entry to use the default icon
		category = "AE3_mainModules";

		// Name of function triggered once conditions are met
		function = "";
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
		curatorInfoType = "AE3_UserInterface_Zeus_Module_AddConnection";

		// Module description. Must inherit from base class, otherwise pre-defined entities won't be available
		class ModuleDescription: ModuleDescription
		{
			description = "$STR_AE3_Main_Config_ModuleAddConnectionDescription"; // Short description, will be formatted as structured text
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