/* ================================================================================ */

class CfgEditorCategories
{
	class AE3_Assets // Category class, you point to it in editorCategory property
	{
		displayName = "$STR_AE3_Main_AdvancedEquipmentObjectsCategoryDisplayName"; // Name visible in the list
	};
};

/* ================================================================================ */

// Second-level groupings shown under the AE3_Assets category in both Eden and Zeus. Objects select a
// group through their editorSubcategory property.
class CfgEditorSubcategories
{
	class AE3_Sub_Furniture   { displayName = "$STR_AE3_Main_SubcategoryFurniture"; };
	class AE3_Sub_Storage     { displayName = "$STR_AE3_Main_SubcategoryStorage"; };
	class AE3_Sub_Lights      { displayName = "$STR_AE3_Main_SubcategoryLights"; };
	class AE3_Sub_Routers     { displayName = "$STR_AE3_Main_SubcategoryRouters"; };
	class AE3_Sub_Power       { displayName = "$STR_AE3_Main_SubcategoryPower"; };
	class AE3_Sub_Battery     { displayName = "$STR_AE3_Main_SubcategoryBattery"; };
	class AE3_Sub_Laptop      { displayName = "$STR_AE3_Main_SubcategoryLaptop"; };
	class AE3_Sub_Servers     { displayName = "$STR_AE3_Main_SubcategoryServers"; };
	class AE3_Sub_SolarPanel  { displayName = "$STR_AE3_Main_SubcategorySolarPanel"; };
};

/* ================================================================================ */
