// File: fnc_router_openConfig.sqf
/*
 * Author: Root
 * Description: Opens the router configuration dialog from the router's ACE interaction menu,
 * prefilled with the router's current network name, wireless range and password. Client-only.
 *
 * Arguments:
 * 0: _router <OBJECT> - The router being configured
 *
 * Return Value:
 * None
 *
 * Example:
 * [_router] call AE3_network_fnc_router_openConfig;
 *
 * Public: No
 */

params ["_router"];

if (!hasInterface || isNull _router) exitWith {};

if (!createDialog "AE3_RouterConfigDialog") exitWith {};
private _dlg = findDisplay 17030;
if (isNull _dlg) exitWith {};

uiNamespace setVariable ["AE3_router_configTarget", _router];
(_dlg displayCtrl 17031) ctrlSetText (([_router] call AE3_main_fnc_getDeviceName));
(_dlg displayCtrl 17032) ctrlSetText (str (_router getVariable ["AE3_network_wirelessRange", 100]));
(_dlg displayCtrl 17033) ctrlSetText (_router getVariable ["AE3_network_password", ""]);
(_dlg displayCtrl 17034) ctrlSetText ([_router getVariable ["AE3_network_address", [192, 168, 0, 1]]] call AE3_network_fnc_ip2str);
(_dlg displayCtrl 17035) cbSetChecked (_router getVariable ["AE3_network_allowExternalSsh", false]);
(_dlg displayCtrl 17036) ctrlSetText (_router getVariable ["AE3_network_externalAllow", ""]);
