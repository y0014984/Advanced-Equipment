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
};
