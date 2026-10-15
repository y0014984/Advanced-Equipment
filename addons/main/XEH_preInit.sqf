// File: XEH_preInit.sqf
#include "script_component.hpp"
#include "XEH_PREP.hpp"

// Detect the optional Zeus Enhanced dialog framework once at load. When present, AE3's Zeus modules
// route their input through ZEN's Dynamic Dialog instead of the built-in curator dialogs. Read
// elsewhere as EGVAR(main,hasZenDialog); ZEN is never a required addon, so this stays runtime-only.
GVAR(hasZenDialog) = isClass (configFile >> "CfgPatches" >> "zen_dialog");

["All", "deleted", {_this call AE3_main_fnc_terminateDevice}] call CBA_fnc_addClassEventHandler;

// Zeus device operations: curator clients request ops via server event; the server ensures the
// target device is initialized, executes the op and reports back to the requesting curator only.
if (isServer) then
{
	["ae3_main_zeusDeviceOp", { _this call AE3_main_fnc_zeus_deviceOpServer }] call CBA_fnc_addEventHandler;
};

if (hasInterface) then
{
	["ae3_main_zeusOpFeedback", { _this call AE3_main_fnc_zeus_deviceOpFeedback }] call CBA_fnc_addEventHandler;
};

[
	"AE3_DebugMode", // Settings internal name
	"CHECKBOX", // Settings type
	["STR_AE3_Main_CbaSettings_DebugModeName", "STR_AE3_Main_CbaSettings_DebugModeTooltip"], // Settings Name + Tooltip
	"STR_AE3_Main_CbaSettings_MainCategoryName", // Settings category
	false, // Default Value
    0, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can't be overwritten (optional, default: 0)
    AE3_main_fnc_manageDebugMode, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

[
	"AE3_NetworkDebug", // Settings internal name
	"CHECKBOX", // Settings type
	["STR_AE3_Main_CbaSettings_NetworkDebugName", "STR_AE3_Main_CbaSettings_NetworkDebugTooltip"], // Settings Name + Tooltip
	"STR_AE3_Main_CbaSettings_MainCategoryName", // Settings category
	false, // Default Value
    0, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can't be overwritten (optional, default: 0)
    AE3_main_fnc_manageNetworkDebug, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

[
	"AE3_DeploymentType", // Settings internal name
	"LIST", // Settings type
	["STR_AE3_Main_CbaSettings_DeploymentTypeName", "STR_AE3_Main_CbaSettings_DeploymentTypeTooltip"], // Settings Name + Tooltip
	"STR_AE3_Main_CbaSettings_MainCategoryName", // Settings category
	[
		[0, 1], // Values
		[
			["STR_AE3_Main_CbaSettings_DeploymentTypeStable", "STR_AE3_Main_CbaSettings_DeploymentTypeStable"],
			["STR_AE3_Main_CbaSettings_DeploymentTypeExperimental", "STR_AE3_Main_CbaSettings_DeploymentTypeExperimental"]
		], // Names
		0 // Default: Stable (index 0)
	],
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can't be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    true // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;
