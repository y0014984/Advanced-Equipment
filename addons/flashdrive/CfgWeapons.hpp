class CfgWeapons {
	class CBA_MiscItem;
	class CBA_MiscItem_ItemInfo;

	class Item_FlashDisk_AE3 : CBA_MiscItem
	{
		author[] = {"Wasserstoff"};
        scope = 1;
        displayName = "Flash drive";
        descriptionShort = "Flash drive";
		useActionTitle = "AE3: Pick up flash drive";

        model = "\a3\Missions_F_Oldman\Props\DummyItemSmall_F.p3d";
        picture = "\A3\EditorPreviews_F_oldman\Data\CfgVehicles\Land_USB_Dongle_01_F.jpg";

		ae3_vehicle = FlashDrive_AE3;

		class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
			scope = 0;
        };
	};

	ITEM_ID_LIST(Item_FlashDisk_AE3)
};