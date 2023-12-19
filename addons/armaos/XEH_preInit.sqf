#include "script_component.hpp"
#include "XEH_PREP.hpp"

/* ================================================================================ */

[
	"AE3_TerminalDesign",
	"LIST",
	["STR_AE3_Main_CbaSettings_TerminalDesignName", "STR_AE3_Main_CbaSettings_TerminalDesignTooltip"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[
		[0, 1, 2, 3],
		[["STR_AE3_Main_CbaSettings_TerminalDesignNameArmaOS", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipArmaOS"], 
		["STR_AE3_Main_CbaSettings_TerminalDesignNameC64", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipC64"], 
		["STR_AE3_Main_CbaSettings_TerminalDesignNameAppleII", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipAppleII"], 
		["STR_AE3_Main_CbaSettings_TerminalDesignNameAmber", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipAmber"]], 
		0
	],
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

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

/* ================================================================================ */

[
	"AE3_UiOnTexture",
	"CHECKBOX",
	["STR_AE3_Main_CbaSettings_UiOnTextureName", "STR_AE3_Main_CbaSettings_UiOnTextureTooltip"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	false,
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_MaxTerminalBufferLines",
	"EDITBOX",
	["STR_AE3_Main_CbaSettings_MaxTerminalBufferLinesName", "STR_AE3_Main_CbaSettings_MaxTerminalBufferLinesTooltip"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	"100",
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
        params ["_value"];

		// use an editbox to manage a number

		// string to number
		_value = parseNumber _value;

		// float to int
		_value = round _value;

		// ignore negative values; -1 means "no limit"
		if (_value < -1) then { _value = 100; };

		// if 0 then reset to default
		if (_value == 0) then { _value = 100; };

		// write/sync changed value back to CBA settings
		if (!isMultiplayer || (isServer && hasInterface)) then
		{
			// In singeplayer or as host in a multiplayer session
			["AE3_MaxTerminalBufferLines", str _value, 0, "server", true] call CBA_settings_fnc_set;
		}
		else
		{
			// As client in a multiplayer session
			["AE3_MaxTerminalBufferLines", str _value, 0, "client", true] call CBA_settings_fnc_set;
		};

    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */