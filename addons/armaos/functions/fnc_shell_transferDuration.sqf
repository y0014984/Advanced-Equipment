// File: fnc_shell_transferDuration.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Returns how long a simulated transfer of the given size takes over a medium, using
 * the AE3_TransferSpeed* CBA settings (KB/s) and capped by AE3_TransferMaxDuration. Transfers under
 * half a second, or over a medium whose speed is 0, are instant. Network transfers given a computer
 * use the speed configured for that user/computer/wifi network (AE3_network_fnc_getTransferSpeed);
 * a remote end limits the speed only where a mission maker set an override for it.
 *
 * Arguments:
 * 0: _bytes <NUMBER> - Transfer size in bytes
 * 1: _medium <STRING> (Optional, default: "local") - "local", "usb" or "network"
 * 2: _computer <OBJECT> (Optional, default: objNull) - Computer the user works on (network only)
 * 3: _user <STRING> (Optional, default: "") - Account on _computer (network only)
 * 4: _peer <OBJECT> (Optional, default: objNull) - Remote end of the transfer (network only)
 * 5: _peerUser <STRING> (Optional, default: "") - Account on _peer (network only)
 *
 * Return Value:
 * [duration in seconds, speed in KB/s] <ARRAY>
 *
 * Example:
 * ([50 * 1048576, "network"] call AE3_armaos_fnc_shell_transferDuration) params ["_seconds", "_speed"];
 *
 * Public: Yes
 */

params [
	["_bytes", 0, [0]],
	["_medium", "local", [""]],
	["_computer", objNull, [objNull]],
	["_user", "", [""]],
	["_peer", objNull, [objNull]],
	["_peerUser", "", [""]]
];

private _speed = switch (toLower _medium) do
{
	case "usb":     { missionNamespace getVariable ["AE3_TransferSpeedUsb", 2048] };
	case "network": { missionNamespace getVariable ["AE3_TransferSpeedNetwork", 512] };
	default         { missionNamespace getVariable ["AE3_TransferSpeedLocal", 20480] };
};

if (toLower _medium isEqualTo "network" && {!isNull _computer}) then
{
	_speed = [_computer, _user] call AE3_network_fnc_getTransferSpeed;
	if (!isNull _peer) then
	{
		private _peerSpeed = [_peer, _peerUser, true] call AE3_network_fnc_getTransferSpeed;
		if (_peerSpeed > 0) then { _speed = _speed min _peerSpeed; };
	};
};

if (_speed <= 0) exitWith { [0, _speed] };

private _duration = (_bytes / 1024) / _speed;

private _cap = missionNamespace getVariable ["AE3_TransferMaxDuration", 0];
if (_cap > 0) then { _duration = _duration min _cap; };

if (_duration < 0.5) exitWith { [0, _speed] };

[_duration, _speed]
