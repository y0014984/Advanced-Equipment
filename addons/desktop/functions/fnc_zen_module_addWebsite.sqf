// File: fnc_zen_module_addWebsite.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Zeus Enhanced curator prompt for the Add Website module. Runs on the placing curator's
 * machine (reached via remoteExec from the server module function). Asks for a domain and a mission
 * site-root folder through a ZEN Dynamic Dialog, then registers the mapping via
 * AE3_desktop_fnc_registerSite (which routes to the server) and drops the module.
 *
 * Arguments:
 * 0: _moduleNetId <STRING> - netId of the module logic
 *
 * Return Value:
 * None
 *
 * Example:
 * [_moduleNetId] call AE3_desktop_fnc_zen_module_addWebsite;
 *
 * Public: No
 */

params ["_moduleNetId"];

private _onConfirm = {
    params ["_values", "_args"];
    _values params ["_domain", "_siteRoot"];
    _args params ["_moduleNetId"];

    if (_domain isNotEqualTo "" && _siteRoot isNotEqualTo "") then
    {
        [_domain, _siteRoot] call AE3_desktop_fnc_registerSite; // routes to the server
    };

    (objectFromNetId _moduleNetId) remoteExec ["deleteVehicle", 2];
};

private _onCancel = {
    params ["_values", "_args"];
    (objectFromNetId (_args select 0)) remoteExec ["deleteVehicle", 2];
};

[
    "AE3: Add Website",
    [
        ["EDIT", "Domain (e.g. thisisme.com)", [""]],
        ["EDIT", "Site root folder (e.g. sites/mysite)", [""]]
    ],
    _onConfirm,
    _onCancel,
    [_moduleNetId]
] call EFUNC(main,zen_createDialog);
