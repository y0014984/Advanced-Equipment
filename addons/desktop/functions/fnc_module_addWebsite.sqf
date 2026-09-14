// File: fnc_module_addWebsite.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Eden/trigger module handler for AE3_AddWebsite. Registers a custom domain -> mission
 * site-root mapping (AE3_desktop_fnc_registerSite) so the Browser can visit the domain and load that
 * folder's index.html by reading the module's Domain/SiteRoot attributes. Curator placement is handled
 * by the module's curatorInfoType dialog (AE3_desktop_fnc_zeus_module_addWebsite) instead.
 *
 * Arguments:
 * 0: _module <OBJECT>
 * 1: _units <ARRAY>
 * 2: _activated <BOOL>
 *
 * Return Value:
 * true <BOOL>
 *
 * Public: No
 */

params ["_module", "_units", "_activated"];

if (!isServer) exitWith {};
if (!_activated) exitWith { true };

// Curator placement is owned entirely by the module's curatorInfoType dialog (built-in prompt, or a
// ZEN hand-off when Zeus Enhanced is loaded); only the Eden/trigger path is handled here.
if (_module getVariable ["BIS_fnc_moduleInit_isCuratorPlaced", false]) exitWith { false };

// Eden / trigger: read the configured attributes.
private _domain = _module getVariable ["AE3_ModuleWebsite_Domain", ""];
private _siteRoot = _module getVariable ["AE3_ModuleWebsite_SiteRoot", ""];
if (_domain isNotEqualTo "" && _siteRoot isNotEqualTo "") then
{
    [_domain, _siteRoot] call AE3_desktop_fnc_registerSite;
};

deleteVehicle _module;
true
