#include "script_item_macro.hpp"

class CfgWeapons {
	class CBA_MiscItem;
	class CBA_MiscItem_ItemInfo;

	// Base laptop item class
	class Item_Laptop_AE3 : CBA_MiscItem
	{
		author[] = {"Wasserstoff", "Root"};
		scope = 1;
		displayName = "$STR_AE3_ArmaOS_Laptop_Item_DisplayName";
		descriptionShort = "$STR_AE3_ArmaOS_Laptop_Item_DescrShort";
		useActionTitle = "$STR_AE3_ArmaOS_Laptop_Deploy";

		model = ""; // Model not needed for inventory item
		picture = "\a3\ui_f\data\gui\Rsc\RscDisplayArsenal\itemoptic_ca.paa"; // Generic item icon

		// Maps to the ground object class - will be determined dynamically based on original laptop type
		ae3_vehicle = "Land_Laptop_03_black_F_AE3";  // Default vehicle class

		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 70;  // Mass in inventory (1 unit = ACE cargo unit)
			scope = 0;
		};
	};

	// Generate 512 unique laptop item variants for state tracking
	ITEM_ID_LIST(Item_Laptop_AE3,Laptop)
};
