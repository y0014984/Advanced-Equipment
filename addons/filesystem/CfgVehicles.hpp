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
			class ModuleDescription;	// Module description
		};
		// Description base classes, for more information see below
		class ModuleDescription
		{
			class AnyBrain;
		};
	};
	class AE3_Filesystem: Module_F
	{
		// Standard object definitions
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "AE3 Filesystem"; // Name displayed in the menu
		//icon = "\myTag_addonName\data\iconNuke_ca.paa"; // Map icon. Delete this entry to use the default icon
		category = "ObjectModifiers";

		// Name of function triggered once conditions are met
		function = "AE3_armaos_fnc_moduleFilesystem";
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
			class AE3_ModuleFilesystem_FilesystemObject1: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemObject1";
				displayName = "Filesystem Object 1";
				tooltip = "Path and Name of Filesystem Object, for example /users/y0014984/Desktop/passwords.txt";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """/users/y0014984/Desktop/passwords1.txt""";
			};
			class AE3_ModuleFilesystem_FilesystemContent1: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemContent1";
				displayName = "Filesystem Content 1";
				tooltip = "Content of Filesystem Object, like text note oder path to image";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """Hidden Note 1""";
			};
			class AE3_ModuleFilesystem_FilesystemObject2: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemObject2";
				displayName = "Filesystem Object 2";
				tooltip = "Path and Name of Filesystem Object, for example /users/y0014984/Desktop/passwords.txt";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """/users/y0014984/Desktop/passwords2.txt""";
			};
			class AE3_ModuleFilesystem_FilesystemContent2: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemContent2";
				displayName = "Filesystem Content 2";
				tooltip = "Content of Filesystem Object, like text note oder path to image";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """Hidden Note 2""";
			};
			class AE3_ModuleFilesystem_FilesystemObject3: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemObject3";
				displayName = "Filesystem Object 3";
				tooltip = "Path and Name of Filesystem Object, for example /users/y0014984/Desktop/passwords.txt";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """/users/y0014984/Desktop/passwords3.txt""";
			};
			class AE3_ModuleFilesystem_FilesystemContent3: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemContent3";
				displayName = "Filesystem Content 3";
				tooltip = "Content of Filesystem Object, like text note oder path to image";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """Hidden Note 3""";
			};
			class AE3_ModuleFilesystem_FilesystemObject4: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemObject4";
				displayName = "Filesystem Object 4";
				tooltip = "Path and Name of Filesystem Object, for example /users/y0014984/Desktop/passwords.txt";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """/users/y0014984/Desktop/passwords4.txt""";
			};
			class AE3_ModuleFilesystem_FilesystemContent4: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemContent4";
				displayName = "Filesystem Content 4";
				tooltip = "Content of Filesystem Object, like text note oder path to image";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """Hidden Note 4""";
			};
			class AE3_ModuleFilesystem_FilesystemObject5: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemObject5";
				displayName = "Filesystem Object 5";
				tooltip = "Path and Name of Filesystem Object, for example /users/y0014984/Desktop/passwords.txt";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """/users/y0014984/Desktop/passwords5.txt""";
			};
			class AE3_ModuleFilesystem_FilesystemContent5: Edit
			{
				property = "AE3_ModuleFilesystem_FilesystemContent5";
				displayName = "Filesystem Content 5";
				tooltip = "Content of Filesystem Object, like text note oder path to image";
				typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				// Default text filled in the input box
				// Because it is an expression, to return a String one must have a string within a string
				defaultValue = """Hidden Note 5""";
			};
			class ModuleDescription: ModuleDescription{}; // Module description should be shown last
		};

		// Module description. Must inherit from base class, otherwise pre-defined entities won't be available
		class ModuleDescription: ModuleDescription
		{
			description = "This Module defines Filesystem Objects for a synced Laptop. You can sync multiple Modules with one Laptop."; // Short description, will be formatted as structured text
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