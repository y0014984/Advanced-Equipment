// File: fnc_setMainsPowered.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Sets whether a consumer device runs on mains power (no provider needed, never drains a
 * generator or battery) or requires an external power cable. Overrides the class default
 * (AE3_Device >> mainsPowered). A running device switched to external power without a powered
 * provider is turned off. Routed to the server when called on a client.
 *
 * Arguments:
 * 0: _device <OBJECT> - Consumer device (e.g. a headless server)
 * 1: _mains <BOOL> - true = mains powered, false = requires external power
 *
 * Return Value:
 * None
 *
 * Example:
 * [_server, false] call AE3_power_fnc_setMainsPowered; // must be cabled to a generator
 *
 * Public: Yes
 */

params [["_device", objNull, [objNull]], ["_mains", true, [true]]];

if (!isServer) exitWith
{
	["ae3_power_setMainsPowered", [_device, _mains]] call CBA_fnc_serverEvent;
};

if (isNull _device) exitWith {};

_device setVariable ["AE3_power_mains", _mains, true];

if (_mains) exitWith {};

private _provider = _device getVariable ["AE3_power_powerCableDevice", objNull];
private _hasPower = !isNull _provider && {(_provider getVariable ["AE3_power_powerState", 0]) == 1};

if (!_hasPower && {(_device getVariable ["AE3_power_powerState", 0]) != 0}) then
{
	[_device] call AE3_power_fnc_turnOffDevice;
};
