// File: fnc_getTransferSpeed.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Returns the simulated network transfer speed (KB/s) that applies to a user working on a
 * computer: the user's override on that computer, else the computer's override, else the override of
 * the router it is connected to (walking up parent routers), else the mission-wide
 * AE3_TransferSpeedNetwork setting. With _explicitOnly the mission setting is not used and -1 is
 * returned when nothing is configured (used to let a remote end limit a transfer only when a mission
 * maker restricted it).
 *
 * Arguments:
 * 0: _computer <OBJECT> - Laptop or server (a router is accepted too)
 * 1: _user <STRING> (Optional, default: "") - Account working on the computer
 * 2: _explicitOnly <BOOL> (Optional, default: false) - Ignore the mission-wide default
 *
 * Return Value:
 * Speed in KB/s (0 = transfers are instant), or -1 <NUMBER>
 *
 * Example:
 * private _kbps = [_laptop, "operator"] call AE3_network_fnc_getTransferSpeed;
 *
 * Public: Yes
 */

params [["_computer", objNull, [objNull]], ["_user", "", [""]], ["_explicitOnly", false, [false]]];

private _default = [missionNamespace getVariable ["AE3_TransferSpeedNetwork", 512], -1] select _explicitOnly;

if (isNull _computer) exitWith { _default };

_user = toLower (trim _user);
private _userSpeed = -1;
if (_user isNotEqualTo "") then
{
	private _speeds = _computer getVariable ["AE3_network_userTransferSpeeds", []];
	private _index = _speeds findIf { (_x select 0) isEqualTo _user };
	if (_index != -1) then { _userSpeed = (_speeds select _index) select 1; };
};
if (_userSpeed > 0) exitWith { _userSpeed };

private _deviceSpeed = _computer getVariable ["AE3_network_transferSpeed", -1];
if (_deviceSpeed > 0) exitWith { _deviceSpeed };

// The wifi network: the router the device is connected to, then its parent routers.
private _router = _computer getVariable ["AE3_network_parent", objNull];
private _visited = [];
while { !isNull _router && {!(_router in _visited)} } do
{
	private _routerSpeed = _router getVariable ["AE3_network_transferSpeed", -1];
	if (_routerSpeed > 0) exitWith { _deviceSpeed = _routerSpeed; };
	_visited pushBack _router;
	_router = _router getVariable ["AE3_network_parent", objNull];
};

if (_deviceSpeed > 0) exitWith { _deviceSpeed };

_default
