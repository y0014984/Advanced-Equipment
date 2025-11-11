#include "script_component.hpp"
#include "XEH_PREP.hpp"

/* ================================================================================ */

[
	"AE3_KeyboardLayout",
	"LIST",
	["STR_AE3_Main_CbaSettings_KeyboardLayoutName", "STR_AE3_Main_CbaSettings_KeyboardLayoutTooltip"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[
		["AR", "DE", "FR", "HE", "HU", "IT", "RU", "TR", "US"],
		[["AR", "Arabic"], ["DE", "Deutschland"], ["FR", "France"], ["HE", "Hebrew"], ["HU", "Magyarország"], ["IT", "Italia"], ["RU", "Русский"], ["TR", "Türkiye"], ["US", "United States"]],
		8
	],
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalDesign",
	"LIST",
	["STR_AE3_Main_CbaSettings_TerminalDesignName", "STR_AE3_Main_CbaSettings_TerminalDesignTooltip"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[
		[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19],
		[
			["STR_AE3_Main_CbaSettings_TerminalDesignNameArmaOS", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipArmaOS"], 
			["STR_AE3_Main_CbaSettings_TerminalDesignNameC64", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipC64"], 
			["STR_AE3_Main_CbaSettings_TerminalDesignNameAppleII", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipAppleII"], 
			["STR_AE3_Main_CbaSettings_TerminalDesignNameAmber", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipAmber"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameMidnightBlue", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipMidnightBlue"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameLightMode", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipLightMode"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameRetroRed", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipRetroRed"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameTealTerm", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipTealTerm"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameNeonViolet", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipNeonViolet"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameDarkGray", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipDarkGray"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameIceBlue", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipIceBlue"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameSepiaVintage", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipSepiaVintage"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameHighContrastDark", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipHighContrastDark"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameHighContrastLight", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipHighContrastLight"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameYellowOnBlack", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipYellowOnBlack"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameCyanOnBlack", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipCyanOnBlack"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameOrangeOnBlack", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipOrangeOnBlack"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameCreamMode", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipCreamMode"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameTerminalGreen", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipTerminalGreen"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameSoftBlue", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipSoftBlue"]
		],
		9
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
	"AE3_TerminalDefaultSize",
	"SLIDER",
	["Terminal Default Size", "The default font size for terminal displays (0.5 = 50%, 1.0 = 100%). You can also use Ctrl + Plus/Minus to adjust size in-game."],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[0.5, 1.0, 0.75, 2],
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
    1, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_UiPlayerRange",
	"SLIDER",
	["UI-on-Texture Range", "Max Range (in meter) for players to be for the UI to update for them when viewing the laptop(s)"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[1, 500, 5, 0],
    1, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {
        params ["_value"];
		missionNamespace setVariable ["AE3_UiPlayerRange", _value, true];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_armaos_uiOnTexUpdateInterval",
	"SLIDER",
	["UI-on-Texture Update Interval", "How often (in seconds) to update UI-on-Texture displays for nearby players. Lower values = smoother updates but more network traffic. Higher values = better performance but less smooth updates. Recommended: 0.3 seconds."],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[0.1, 2.0, 0.3, 1], // min, max, default, decimal places
    1, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalDialogTitle",
	"EDITBOX",
	["Terminal Dialog Title", "The title shown in the terminal dialog window header"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	"SHITE™ COMPUTING",
    1, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalBiosVersion",
	"EDITBOX",
	["Terminal BIOS Version", "The BIOS version line shown in the terminal header"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	"SHITE™ BIOS v1.0.0",
    1, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalCopyright",
	"EDITBOX",
	["Terminal Copyright", "The copyright line shown in the terminal header"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	"© 2025 System Hardware Integration & Technology Enterprises",
    1, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalBootMessage",
	"EDITBOX",
	["Terminal Boot Message", "The initialization message shown in the terminal header"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	"Initializing kernel... please wait...",
    1, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalTipMessage",
	"EDITBOX",
	["Terminal Tip Message", "The tip message shown in the terminal header"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	"> Tip: SHITE™ laptops perform better when plugged in.",
    1, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalShowAsciiArt",
	"CHECKBOX",
	["Show ASCII Art", "Display ASCII art in the terminal header"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	true,
    1, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalTagline",
	"EDITBOX",
	["Terminal Tagline", "The tagline shown in the terminal header after ASCII art"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	"Powered by SHITE™ Technologies – Excellence, from the ground up.",
    1, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */
