class CfgVehicles 
{
	/* ================================================================================ */
	// Flash Drive
	class Land_USB_Dongle_01_F;
	class Land_USB_Dongle_01_F_AE3: Land_USB_Dongle_01_F
	{
		scope = 2;
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.
		scopeArsenal = 2; // Virtual Arsenal visability; 2 will show it in the menu, 0 will hide it.

		editorCategory = "AE3_Assets";

		ae3_item = "Item_FlashDisk_AE3";

		class ACE_Actions {
			class Pickup {
				displayName = "$STR_AE3_Flashdrive_Interaction_Take";
				icon = "\a3\ui_f\data\igui\cfg\actions\take_ca.paa";
				distance = 2;
				condition = "true";
				statement = "_this remoteExec ['AE3_flashdrive_fnc_take', 2];";
			};
        };
	};

	/* ================================================================================ */

};
