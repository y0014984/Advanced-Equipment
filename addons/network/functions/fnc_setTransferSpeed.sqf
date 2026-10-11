// File: fnc_setTransferSpeed.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Overrides the simulated network transfer speed (KB/s) for a wifi network (router), a
 * whole computer, or one user account on a computer. Without overrides every transfer uses the
 * mission-wide AE3_TransferSpeedNetwork setting. Resolution order for a transfer: user on the
 * computer > computer > its router (and parent routers) > mission setting. Routed to the server when
 * called on a client.
 *
 * Arguments:
 * 0: _device <OBJECT> - Router, laptop or server
 * 1: _speed <NUMBER> - Speed in KB/s; 0 or less removes the override
 * 2: _user <STRING> (Optional, default: "") - Account name on a computer; "" = the whole device
 *
 * Return Value:
 * None
 *
 * Example:
 * [_router, 128] call AE3_network_fnc_setTransferSpeed;            // slow wifi
 * [_laptop, 4096, "operator"] call AE3_network_fnc_setTransferSpeed; // fast user
 * [_laptop, 0, "operator"] call AE3_network_fnc_setTransferSpeed;    // back to default
 *
 * Public: Yes
 */

params [["_device", objNull, [objNull]], ["_speed", 0, [0]], ["_user", "", [""]]];

if (!isServer) exitWith
{
	["ae3_network_setTransferSpeed", [_device, _speed, _user]] call CBA_fnc_serverEvent;
};

if (isNull _device) exitWith {};

_user = toLower (trim _user);

if (_user isEqualTo "") exitWith
{
	if (_speed > 0) then
	{
		_device setVariable ["AE3_network_transferSpeed", _speed, true];
	}
	else
	{
		_device setVariable ["AE3_network_transferSpeed", nil, true];
	};
};

// Per-user overrides travel as [[user, speed], ...] pairs so they replicate as a plain array.
private _speeds = +(_device getVariable ["AE3_network_userTransferSpeeds", []]);
private _index = _speeds findIf { (_x select 0) isEqualTo _user };
if (_index != -1) then { _speeds deleteAt _index; };
if (_speed > 0) then { _speeds pushBack [_user, _speed]; };

_device setVariable ["AE3_network_userTransferSpeeds", _speeds, true];
