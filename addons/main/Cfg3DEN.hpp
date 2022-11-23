class Cfg3DEN
{
	// Configuration of all objects
	class Object
	{
		// Categories collapsible in "Edit Attributes" window
		class AttributeCategories
		{
			// Category class, can be anything
			class AE3_AttributeCategory
			{
				displayName = "$STR_AE3_Main_EdenAttributes_AE3Attributes"; // Category name visible in Edit Attributes window
				collapsed = 1; // When 1, the category is collapsed by default
				class Attributes
				{
					// Attribute class, can be anything
					class AE3_ComputerPowerLevelPercent
					{
						//--- Mandatory properties
						displayName = "$STR_AE3_Main_EdenAttributes_PowerLevelDisplayName"; // Name assigned to UI control class Title
						tooltip = "$STR_AE3_Main_EdenAttributes_PowerLevelTooltip"; // Tooltip assigned to UI control class Title
						property = "AE3_ComputerPowerLevelPercent"; // Unique config property name saved in SQM
						control = "Edit"; // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

						// Expression called when applying the attribute in Eden and at the scenario start
						// The expression is called twice - first for data validation, and second for actual saving
						// Entity is passed as _this, value is passed as _value
						// %s is replaced by attribute config name. It can be used only once in the expression
						// In MP scenario, the expression is called only on server.
						//expression = "_this setVariable ['%s', _value, true];";
						expression = "_this setVariable ['%s', _value, true];";

						// Expression called when custom property is undefined yet (i.e., when setting the attribute for the first time)
						// Entity (unit, group, marker, comment etc.) is passed as _this
						// Returned value is the default value
						// Used when no value is returned, or when it is of other type than NUMBER, STRING or ARRAY
						// Custom attributes of logic entities (e.g., modules) are saved always, even when they have default value
						//defaultValue = "[configfile >> 'CfgVehicles' >> 'Land_Laptop_03_sand_F_AE3', 'ae3_power_defaultPowerLevel', -1] call BIS_fnc_returnConfigEntry;";
						defaultValue = "[configfile >> 'CfgVehicles' >> typeOf _this, 'ae3_power_defaultPowerLevel', -1] call BIS_fnc_returnConfigEntry;";

						//--- Optional properties
						unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for variable names or player control)
						validate = "number"; // Validate the value before saving. If the value is not of given type e.g. "number", the default value will be set. Can be "none", "expression", "condition", "number" or "variable"
						condition = "1"; // Condition for attribute to appear (see the table below)
						typeName = "NUMBER"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
					};
					// Attribute class, can be anything
					class AE3_GeneratorFuelLevelPercent
					{
						//--- Mandatory properties
						displayName = "$STR_AE3_Main_EdenAttributes_FuelLevelDisplayName"; // Name assigned to UI control class Title
						tooltip = "$STR_AE3_Main_EdenAttributes_FuelLevelTooltip"; // Tooltip assigned to UI control class Title
						property = "AE3_GeneratorFuelLevelPercent"; // Unique config property name saved in SQM
						control = "Edit"; // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

						// Expression called when applying the attribute in Eden and at the scenario start
						// The expression is called twice - first for data validation, and second for actual saving
						// Entity is passed as _this, value is passed as _value
						// %s is replaced by attribute config name. It can be used only once in the expression
						// In MP scenario, the expression is called only on server.
						//expression = "_this setVariable ['%s', _value, true];";
						expression = "_this setVariable ['%s', _value, true];";

						// Expression called when custom property is undefined yet (i.e., when setting the attribute for the first time)
						// Entity (unit, group, marker, comment etc.) is passed as _this
						// Returned value is the default value
						// Used when no value is returned, or when it is of other type than NUMBER, STRING or ARRAY
						// Custom attributes of logic entities (e.g., modules) are saved always, even when they have default value
						//defaultValue = "[configfile >> 'CfgVehicles' >> 'Land_PortableGenerator_01_sand_F_AE3', 'ae3_power_defaultFuelLevel', -1] call BIS_fnc_returnConfigEntry;";
						defaultValue = "[configfile >> 'CfgVehicles' >> typeOf _this, 'ae3_power_defaultFuelLevel', -1] call BIS_fnc_returnConfigEntry;";

						//--- Optional properties
						unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for variable names or player control)
						validate = "number"; // Validate the value before saving. If the value is not of given type e.g. "number", the default value will be set. Can be "none", "expression", "condition", "number" or "variable"
						condition = "1"; // Condition for attribute to appear (see the table below)
						typeName = "NUMBER"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
					};
				};
			};
		};
	};
};