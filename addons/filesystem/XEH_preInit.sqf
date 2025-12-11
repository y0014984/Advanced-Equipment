#include "script_component.hpp"
#include "XEH_PREP.hpp"

/* ================================================================================ */

[
	"AE3_Filesystem_SyncMode",
	"LIST",
	["Filesystem Network Sync Mode", "Controls how filesystem changes are synchronized across the network. 'Server Only' = changes sent to server only (lowest network usage, recommended). 'Global' = changes broadcast to all clients (high network usage, for debugging/experimenting)."],
	"STR_AE3_Filesystem_CbaSettings_FilesystemCategoryName",
	[
		[0, 1],
		[
			["Server Only", "Server Only - Minimal network usage"],
			["Global", "Global - Broadcast to all clients (high network usage)"]
		],
		0
	],
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can't be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */
