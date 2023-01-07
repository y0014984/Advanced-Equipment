class CfgVehicles 
{
	/* ================================================================================ */
	// Flash Drive
	class Land_USB_Dongle_01_F;
	class FlashDrive_AE3: Land_USB_Dongle_01_F
	{
		scope=2;
		ae3_item = Item_FlashDisk_AE3;

		class EventHandlers
		{
			init = "_this call AE3_filesystem_fnc_initFilesystem";
		};

		class ACE_Actions {
			class GVAR(pickup) {
				displayName = CSTRING(Pickup);
				icon = "\a3\ui_f\data\igui\cfg\actions\take_ca.paa";
				distance = 2;
				condition = "true";
				statement = "_this remoteExec ['AE3_flashdrive_fnc_obj2item', 2];";
			};
        };
	};

	/* ================================================================================ */

};