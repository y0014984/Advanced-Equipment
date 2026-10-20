// File: fnc_module_transferSpeed.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: "Network Speed" module (Eden and Zeus). Sets the simulated network transfer speed for the
 * synchronized routers (whole wifi network), computers, or one user account on the synchronized
 * computers. Placed by a curator onto a router or computer it opens a dialog for the values (ZEN).
 * A speed of 0 removes the override, so the device falls back to the next level / mission default.
 *
 * Arguments:
 * 0: _module <OBJECT> - Module logic
 * 1: _units <ARRAY> - Synchronized units (unused)
 * 2: _activated <BOOL> - Module activated
 *
 * Return Value:
 * true <BOOL>
 *
 * Example:
 * [_module, [], true] call AE3_network_fnc_module_transferSpeed;
 *
 * Public: No
 */

params ["_module", "_units", "_activated"];

if (!_activated) exitWith { true };

private _isTarget = { (_this getVariable ["AE3_cap_isRouter", false]) || {_this getVariable ["AE3_cap_hasTerminal", false]} || {isClass (configOf _this >> "AE3_Device")} };

// Zeus: runs once on the curator's machine on the object the module was dropped onto, then asks through ZEN.
if (_module getVariable ["BIS_fnc_moduleInit_isCuratorPlaced", false]) exitWith
{
	if (!local _module || {_module getVariable [QGVAR(zeusHandled), false]}) exitWith { true };

	_module setVariable [QGVAR(zeusHandled), true];

	(missionNamespace getVariable ["BIS_fnc_curatorObjectPlaced_mouseOver", [""]]) params ["_mouseOverType", ["_target", objNull]];

	if (_mouseOverType isNotEqualTo "OBJECT" || {!(_target call _isTarget)} || {!(EGVAR(main,hasZenDialog))}) exitWith
	{
		[localize "STR_AE3_Network_Config_TransferSpeedDisplayName", localize "STR_AE3_Network_TransferSpeed_NoTarget", 5] call BIS_fnc_curatorHint;
		[_module] remoteExecCall ["deleteVehicle", 2];
		true
	};

	[netId _module, [netId _target]] call FUNC(zen_module_transferSpeed);
	true
};

if (!isServer) exitWith { true };

private _objs = (synchronizedObjects _module) select { !(_x isKindOf "Logic") && {_x call _isTarget} };

private _speed = _module getVariable ["AE3_Module_TransferSpeed_Speed", 0];
private _usersText = _module getVariable ["AE3_Module_TransferSpeed_Users", ""];
private _users = (_usersText splitString ", ") select { _x isNotEqualTo "" };
if (_users isEqualTo []) then { _users = [""]; };

if (_objs isEqualTo []) then
{
	diag_log format ["AE3: Network Speed module skipped - no router or computer synchronized (speed %1)", _speed];
};

{
	private _device = _x;
	{
		[_device, _speed, _x] call AE3_network_fnc_setTransferSpeed;
	} forEach _users;
} forEach _objs;

deleteVehicle _module;

true
