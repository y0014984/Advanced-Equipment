#include "script_component.hpp"
#include "XEH_PREP.hpp"

/* ================================================================================ */

[
	"AE3_Power_ChangeThreshold",
	"SLIDER",
	["Power State Change Threshold", "Minimum percentage change required to sync power state over network. Higher values reduce network usage but may delay power updates. 0 = Always sync (highest accuracy, high network usage). Recommended: 1%"],
	"STR_AE3_Power_CbaSettings_PowerCategoryName",
	[0, 10, 1, 1], // min, max, default, decimal places
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can't be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_Power_EnableStateSync",
	"CHECKBOX",
	["Enable Power State Network Sync", "Enable synchronization of power states across the network. Disabling can improve performance but may cause power state inconsistencies on client machines. Recommended: Enabled."],
	"STR_AE3_Power_CbaSettings_PowerCategoryName",
	true,
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can't be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_Power_UpdateInterval",
	"SLIDER",
	["Power Calculation Update Interval", "How often (in seconds) to recalculate power states for batteries, solar panels, and generators. Higher values reduce CPU and network usage. Recommended: 1.0 seconds."],
	"STR_AE3_Power_CbaSettings_PowerCategoryName",
	[0.5, 5.0, 1.0, 1], // min, max, default, decimal places
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can't be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

["All", "InitPost", {_this call AE3_power_fnc_compileDevice}] call CBA_fnc_addClassEventHandler;
