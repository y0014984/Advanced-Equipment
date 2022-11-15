#include "script_component.hpp"
#include "XEH_PREP.hpp"

[
	"AE3_DebugMode", // Settings internal name
	"CHECKBOX", // Settings type
	["Debug Mode", "By enabling the AE3 Debug Mode you will get additional information about the internal structure of AE3."], // Settings Name + Tooltip
	"AE3 main", // Settings category
	false, // Default Value
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    AE3_main_fnc_manageDebugMode, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;