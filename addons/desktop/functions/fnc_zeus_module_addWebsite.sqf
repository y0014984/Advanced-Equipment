// File: fnc_zeus_module_addWebsite.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Handles the built-in Zeus 'Add Website' module dialog (onLoad/onUnload). Runs on the
 * placing curator's machine. Registers a custom domain -> mission site-root mapping so the Browser
 * can visit the domain and load that folder's index.html. When Zeus Enhanced is loaded the input is
 * gathered through a ZEN Dynamic Dialog instead of this built-in one. The module is deleted after
 * processing.
 *
 * Arguments:
 * 0: _display <DISPLAY> - The Zeus module display
 * 1: _exitCode <NUMBER> - Exit code (1 = OK, 2 = Cancel)
 * 2: _event <STRING> - Event type ("onLoad" or "onUnload")
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display, 1, "onUnload"] call AE3_desktop_fnc_zeus_module_addWebsite;
 *
 * Public: No
 */

params ["_display", "_exitCode", "_event"];

private _module = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _module) exitWith {};

/* ---------------------------------------- */

if (_event isEqualTo "onLoad") exitWith
{
    // Hand off to ZEN's Dynamic Dialog when Zeus Enhanced is present; the module lifecycle then
    // belongs to the ZEN builder, so the built-in onUnload below is skipped via the zenHandled flag.
    if (EGVAR(main,hasZenDialog)) exitWith
    {
        _module setVariable [QGVAR(zenHandled), true];
        _display closeDisplay 2;
        [FUNC(zen_module_addWebsite), [netId _module]] call CBA_fnc_execNextFrame;
    };
};

/* ---------------------------------------- */

if (_event isEqualTo "onUnload") exitWith
{
    if (_module getVariable [QGVAR(zenHandled), false]) exitWith {}; // ZEN owns the lifecycle

    if (_exitCode == 2) exitWith { [_module] remoteExec ["deleteVehicle", 2]; };

    private _domain = ctrlText (_display displayCtrl 1401);
    private _siteRoot = ctrlText (_display displayCtrl 1402);
    if (_domain isNotEqualTo "" && _siteRoot isNotEqualTo "") then
    {
        [_domain, _siteRoot] call AE3_desktop_fnc_registerSite; // routes to the server
    };

    [_module] remoteExec ["deleteVehicle", 2];
};

/* ---------------------------------------- */
