#include "script_component.hpp"
#include "XEH_PREP.hpp"

[
	"AE3_KeyboardLayout",
	"LIST",
	["Keyboard Layout", "Keyboard Layout for armaOS. You can also change this in armaOS terminal."],
	"AE3 armaOS",
	[
		["US", "DE"],
		[["US", "United States"], ["DE", "Deutschland"]], 
		0
	],
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    true // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;