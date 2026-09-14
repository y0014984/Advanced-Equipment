// File: fnc_setStaticIpZeus.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Applies a static IP on behalf of a curator and reports the real outcome back to that
 * curator's machine. Address validation and duplicate detection happen on the server, so the curator
 * has no way to know locally whether the address was accepted; without this the attribute dialog
 * reports success even when the address was malformed or already taken.
 *
 * Arguments:
 * 0: _device <OBJECT> - The device to address
 * 1: _ipStr <STRING> - Static address as "a.b.c.d", empty to fall back to DHCP
 * 2: _curatorOwner <NUMBER> - Machine network id of the curator's client
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, "192.168.0.20", clientOwner] remoteExecCall ["AE3_network_fnc_setStaticIpZeus", 2];
 *
 * Public: No
 */

params [["_device", objNull, [objNull]], ["_ipStr", "", [""]], ["_curatorOwner", 0, [0]]];

if (!isServer) exitWith {};

private _res = [_device, _ipStr] call AE3_network_fnc_setStaticIp;

if (_curatorOwner <= 0) exitWith {};

private _error = _res getOrDefault ["error", ""];
private _message = switch (_error) do
{
	case "": { format [localize "STR_AE3_Network_Zeus_IpApplied", _res getOrDefault ["ip", _ipStr]] };
	case "bad_ip": { localize "STR_AE3_Network_Zeus_IpInvalid" };
	case "ip_in_use": { format [localize "STR_AE3_Network_Zeus_IpInUse", _ipStr] };
	default { localize "STR_AE3_Network_Zeus_IpFailed" };
};

["ae3_network_zeusIpResult", [_message], _curatorOwner] call CBA_fnc_ownerEvent;
