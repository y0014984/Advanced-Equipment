class CfgVehicles 
{
    class Land_PortableLight_02_folded_base_F;
    class Land_PortableLight_02_folded_sand_F: Land_PortableLight_02_folded_base_F
	{
        class ACE_Actions 
		{
			class ACE_MainActions 
			{
				condition = "true";
				displayName = "Interaktionen";
				distance = 2;
				class danceParty 
				{
					displayName = "Entpacken";
					condition = "alive _target";
					statement = "_handle = [_entity, 'Land_MultiScreenComputer_01_sand_F', 'tragbare Lampe', 1, 3] execVM '\z\ae3\addons\main\scripts\OpenCloseAction.sqf';";
					priority = -1;
					showDisabled = 0;
				};
			};
		};
	};
	class Land_DeskChair_01_sand_F;
	class Land_DeskChair_01_sand_F2: Land_DeskChair_01_sand_F
	{
        acex_sitting_canSit = 1;  // Enable sitting
		acex_sitting_interactPosition[] = {0, 0, 0.3}; 
        acex_sitting_sitDirection = 180;  // Direction relative to object
        acex_sitting_sitPosition[] = {0, -0.18, -0.45};  // Position relative to object (may behave weird with certain objects)
	};
};
