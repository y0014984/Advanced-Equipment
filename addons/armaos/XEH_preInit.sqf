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
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

[
	"AE3_TerminalScrollSpeed",
	"LIST",
	["Terminal Scroll Speed", "Determines the speed in lines for the mouse wheel scroll feature for the terminal."],
	"AE3 armaOS",
	[
		[1, 2, 3],
		[["1 line", "1 line"], ["2 lines", "2 lines"], ["3 lines", "3 lines"]], 
		0
	],
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;