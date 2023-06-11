class CfgVehicles 
{
	/* ---------------------------------------- */

	// MODULE FILESYSTEM
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
	
	/* ---------------------------------------- */

	class AE3_AddFile: Module_F
	{
		// Standard object definitions

		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.
		displayName = "$STR_AE3_Filesystem_Config_AddFileDisplayName"; // Name displayed in the menu
		icon = "\z\ae3\addons\filesystem\ui\AE3_Module_Icons_addFile.paa"; // Map icon. Delete this entry to use the default icon
		category = "AE3_armaosModules";
		// Name of function triggered once conditions are met
		function = "AE3_filesystem_fnc_module_addFile";
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
		curatorInfoType = "AE3_UserInterface_Zeus_Module_AddFile";

		// Module attributes, uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific
		class Attributes: AttributesBase
		{
			// Arguments shared by specific module type (have to be mentioned in order to be present)
			class AE3_Module_AddFile_Path: Edit
			{
				property = "AE3_Module_AddFile_Path";
				displayName = "$STR_AE3_Filesystem_Config_PathFileDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_PathFileTooltip";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """/tmp/new/example.txt""";
			};
			class AE3_Module_AddFile_Content
			{
				control = "EditCodeMulti5";
				property = "AE3_Module_AddFile_Content";
				displayName = "$STR_AE3_Filesystem_Config_FileContentDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_FileContentTooltip";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """Lorem ipsum dolor sit amet""";
				validate = "none";
				expression = "_this setVariable [""AE3_Module_AddFile_Content"", _value]";
			};
			class AE3_Module_AddFile_IsCode: Checkbox
			{
				property = "AE3_Module_AddFile_IsCode";
				displayName = "$STR_AE3_Filesystem_Config_IsCodeDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_IsCodeTooltip";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = false;
			};
			class AE3_Module_AddFile_Owner: Edit
			{
				property = "AE3_Module_AddFile_Owner";
				displayName = "$STR_AE3_Filesystem_Config_FileOwnerDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_FileOwnerTooltip";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """root""";
			};

			/* ---- PERMISSIONS ---- */

			class AE3_Module_AddFile_OwnerExecute: Checkbox
			{
				property = "AE3_Module_AddFile_OwnerExecute";
				displayName = "$STR_AE3_Filesystem_Config_ExeByOwnerDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_ExeByOwnerTooltip";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = false;
			};
			class AE3_Module_AddFile_OwnerRead: Checkbox
			{
				property = "AE3_Module_AddFile_OwnerRead";
				displayName = "$STR_AE3_Filesystem_Config_ReadByOwnerDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_ReadByOwnerTooltip";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = true;
			};
			class AE3_Module_AddFile_OwnerWrite: Checkbox
			{
				property = "AE3_Module_AddFile_OwnerWrite";
				displayName = "$STR_AE3_Filesystem_Config_WriteByOwnerDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_WriteByOwnerTooltip";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = true;
			};


			class AE3_Module_AddFile_EveryoneExecute: Checkbox
			{
				property = "AE3_Module_AddFile_EveryoneExecute";
				displayName = "$STR_AE3_Filesystem_Config_ExeByOtherDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_ExeByOtherTooltip";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = false;
			};
			class AE3_Module_AddFile_EveryoneRead: Checkbox
			{
				property = "AE3_Module_AddFile_EveryoneRead";
				displayName = "$STR_AE3_Filesystem_Config_ReadByOtherDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_ReadByOtherTooltip";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = true;
			};
			class AE3_Module_AddFile_EveryoneWrite: Checkbox
			{
				property = "AE3_Module_AddFile_EveryoneWrite";
				displayName = "$STR_AE3_Filesystem_Config_WriteByOtherDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_WriteByOtherTooltip";
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
			description = "$STR_AE3_Filesystem_Config_ModuleAddFileDescription"; // Short description, will be formatted as structured text
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

	class AE3_AddDir: Module_F
	{
		// Standard object definitions
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.
		displayName = "$STR_AE3_Filesystem_Config_AddDirDisplayName"; // Name displayed in the menu
		icon = "\z\ae3\addons\filesystem\ui\AE3_Module_Icons_addDir.paa"; // Map icon. Delete this entry to use the default icon
		category = "AE3_armaosModules";

		// Name of function triggered once conditions are met
		function = "AE3_filesystem_fnc_module_addDir";
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
			class AE3_Module_AddDir_Path: Edit
			{
				property = "AE3_Module_AddDir_Path";
				displayName = "$STR_AE3_Filesystem_Config_PathDirDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_PathDirTooltip";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """/tmp/new""";
			};
			class AE3_Module_AddDir_Owner: Edit
			{
				property = "AE3_Module_AddDir_Owner";
				displayName = "$STR_AE3_Filesystem_Config_DirOwnerDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_DirOwnerTooltip";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """root""";
			};

			/* ---- PERMISSIONS ---- */

			class AE3_Module_AddDir_OwnerExecute: Checkbox
			{
				property = "AE3_Module_AddDir_OwnerExecute";
				displayName = "$STR_AE3_Filesystem_Config_ExeByOwnerDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_ExeByOwnerTooltip";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = true;
			};
			class AE3_Module_AddDir_OwnerRead: Checkbox
			{
				property = "AE3_Module_AddDir_OwnerRead";
				displayName = "$STR_AE3_Filesystem_Config_ReadByOwnerDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_ReadByOwnerTooltip";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = true;
			};
			class AE3_Module_AddDir_OwnerWrite: Checkbox
			{
				property = "AE3_Module_AddDir_OwnerWrite";
				displayName = "$STR_AE3_Filesystem_Config_WriteByOwnerDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_WriteByOwnerTooltip";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = true;
			};


			class AE3_Module_AddDir_EveryoneExecute: Checkbox
			{
				property = "AE3_Module_AddDir_EveryoneExecute";
				displayName = "$STR_AE3_Filesystem_Config_ExeByOtherDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_ExeByOtherTooltip";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = true;
			};
			class AE3_Module_AddDir_EveryoneRead: Checkbox
			{
				property = "AE3_Module_AddDir_EveryoneRead";
				displayName = "$STR_AE3_Filesystem_Config_ReadByOtherDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_ReadByOtherTooltip";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = true;
			};
			class AE3_Module_AddDir_EveryoneWrite: Checkbox
			{
				property = "AE3_Module_AddDir_EveryoneWrite";
				displayName = "$STR_AE3_Filesystem_Config_WriteByOtherDisplayName";
				tooltip = "$STR_AE3_Filesystem_Config_WriteByOtherTooltip";
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
			description = "$STR_AE3_Filesystem_Config_ModuleAddDirDescription"; // Short description, will be formatted as structured text
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

};