#include "script_component.hpp"
#include "XEH_PREP.hpp"

[
	"AE3_KeyboardLayout",
	"LIST",
	["STR_AE3_Main_CbaSettings_KeyboardLayoutName", "STR_AE3_Main_CbaSettings_KeyboardLayoutTooltip"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[
		["US", "FR", "DE"],
		[["US", "United States"], ["FR", "France"], ["DE", "Deutschland"]], 
		0
	],
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

[
	"AE3_TerminalScrollSpeed",
	"LIST",
	["STR_AE3_Main_CbaSettings_TerminalScrollSpeedName", "STR_AE3_Main_CbaSettings_TerminalScrollSpeedTooltip"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[
		[1, 2, 3],
		[
			["STR_AE3_Main_CbaSettings_1line", "STR_AE3_Main_CbaSettings_1line"], 
			["STR_AE3_Main_CbaSettings_2lines", "STR_AE3_Main_CbaSettings_2lines"], 
			["STR_AE3_Main_CbaSettings_3lines", "STR_AE3_Main_CbaSettings_3lines"]
		], 
		0
	],
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;