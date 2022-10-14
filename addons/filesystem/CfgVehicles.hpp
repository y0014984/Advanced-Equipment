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
	
	class AE3_AddFile: Module_F
	{
		// Standard object definitions
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "AE3 Add File"; // Name displayed in the menu
		//icon = "\myTag_addonName\data\iconNuke_ca.paa"; // Map icon. Delete this entry to use the default icon
		category = "AE3_armaosModules";

		// Name of function triggered once conditions are met
		function = "AE3_filesystem_fnc_moduleAddFile";
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

		icon = "\z\ae3\addons\filesystem\ui\AE3_Module_Icons_addFile.paa";

		// Menu displayed when the module is placed or double-clicked on by Zeus
		curatorInfoType = "RscDisplayAttributeModuleFilesystem";

		// Module attributes, uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific
		class Attributes: AttributesBase
		{
			// Arguments shared by specific module type (have to be mentioned in order to be present)
			class AE3_ModuleFilesystem_Path: Edit
			{
				property = "AE3_ModuleFilesystem_Path";
				displayName = "Path";
				tooltip = "Path and Name of Filesystem Object, for example /home/y0014984/Desktop/passwords.txt";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """/home/y0014984/Desktop/passwords1.txt""";
			};
			class AE3_ModuleFilesystem_FileContent: Edit
			{
				property = "AE3_ModuleFilesystem_FileContent";
				displayName = "File content";
				tooltip = "Content of Filesystem Object, like text note oder path to image";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """Lorem ipsum""";
			};
			class AE3_ModuleFilesystem_IsFunction: Checkbox
			{
				property = "AE3_ModuleFilesystem_IsFunction";
				displayName = "Is code?";
				tooltip = "If the file content is a function or code which can be executed from terminal";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = false;
			};
			class AE3_ModuleFilesystem_FileOwner: Edit
			{
				property = "AE3_ModuleFilesystem_FileOwner";
				displayName = "File owner";
				tooltip = "Owner of the file";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """root""";
			};

			/* ---- PERMISSIONS ---- */

			class AE3_ModuleFilesystem_OwnerExecute: Checkbox
			{
				property = "AE3_ModuleFilesystem_OwnerExecute";
				displayName = "Can be executed by the owner";
				tooltip = "Can be executed by the owner";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = true;
			};
			class AE3_ModuleFilesystem_OwnerRead: Checkbox
			{
				property = "AE3_ModuleFilesystem_OwnerRead";
				displayName = "Can be read by the owner";
				tooltip = "Can be read by the owner";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = true;
			};
			class AE3_ModuleFilesystem_OwnerWrite: Checkbox
			{
				property = "AE3_ModuleFilesystem_OwnerWrite";
				displayName = "Can be modified by the owner";
				tooltip = "Can be modified by the owner";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = true;
			};


			class AE3_ModuleFilesystem_EveryoneExecute: Checkbox
			{
				property = "AE3_ModuleFilesystem_EveryoneExecute";
				displayName = "Can be executed by everyone";
				tooltip = "Can be executed by everyone";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = false;
			};
			class AE3_ModuleFilesystem_EveryoneRead: Checkbox
			{
				property = "AE3_ModuleFilesystem_EveryoneRead";
				displayName = "Can be read by everyone";
				tooltip = "Can be read by everyone";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = false;
			};
			class AE3_ModuleFilesystem_EveryoneWrite: Checkbox
			{
				property = "AE3_ModuleFilesystem_EveryoneWrite";
				displayName = "Can be modified by everyone";
				tooltip = "Can be modified by everyone";
				typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = false;
			};

			
			class ModuleDescription: ModuleDescription{}; // Module description should be shown last
		};

		// Module description. Must inherit from base class, otherwise pre-defined entities won't be available
		class ModuleDescription: ModuleDescription
		{
			description = "Adds a file to a object which supports filesystems."; // Short description, will be formatted as structured text
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