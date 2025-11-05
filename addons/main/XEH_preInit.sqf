#include "script_component.hpp"
#include "XEH_PREP.hpp"

["All", "deleted", {_this call AE3_main_fnc_terminateDevice}] call CBA_fnc_addClassEventHandler;

[
	"AE3_DebugMode", // Settings internal name
	"CHECKBOX", // Settings type
	["STR_AE3_Main_CbaSettings_DebugModeName", "STR_AE3_Main_CbaSettings_DebugModeTooltip"], // Settings Name + Tooltip
	"STR_AE3_Main_CbaSettings_MainCategoryName", // Settings category
	false, // Default Value
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    AE3_main_fnc_manageDebugMode, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;
