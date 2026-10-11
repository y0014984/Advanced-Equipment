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

if (!isServer) exitWith { true };
if (!_activated) exitWith { true };

private _isTarget = { (_this getVariable ["AE3_cap_isRouter", false]) || {_this getVariable ["AE3_cap_hasTerminal", false]} || {isClass (configOf _this >> "AE3_Device")} };
private _objs = (synchronizedObjects _module) select { !(_x isKindOf "Logic") && {_x call _isTarget} };

// Eden modules carry their attribute values; a curator-placed module has none and asks through ZEN.
private _fromEditor = !isNil { _module getVariable "AE3_Module_TransferSpeed_Speed" };

if (!_fromEditor) exitWith
{
	if (_objs isEqualTo []) then
	{
		private _near = (nearestObjects [_module, [], 3]) select { !(_x isKindOf "Logic") && {_x call _isTarget} };
		if (_near isNotEqualTo []) then { _objs = [_near select 0]; };
	};

	if (_objs isEqualTo [] || {!(EGVAR(main,hasZenDialog))}) then
	{
		[localize "STR_AE3_Network_Config_TransferSpeedDisplayName", localize "STR_AE3_Network_TransferSpeed_NoTarget", 5] remoteExec ["BIS_fnc_curatorHint", owner _module];
		deleteVehicle _module;
	}
	else
	{
		[netId _module, _objs apply { netId _x }] remoteExec [QFUNC(zen_module_transferSpeed), owner _module];
	};
	true
};

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
