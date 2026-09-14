// File: fnc_str2ip.sqf
/**
 * Author: Root
 * Converts an "a.b.c.d" string into a 4-element integer IP list. Returns [] when the string is not
 * four numeric octets, so callers can validate before routing. The octets are floored to integers
 * so the result compares equal (isEqualTo) to addresses handed out by AE3_network_fnc_dhcp_get.
 *
 * Arguments:
 * 0: IP String <STRING>
 *
 * Returns:
 * 0: IP List <[INT]> (empty array on parse failure)
 */

params [["_str", "", [""]]];

private _parts = _str splitString ".";
if (count _parts != 4) exitWith { [] };

private _ip = _parts apply { floor parseNumber _x };
if (_ip findIf { _x < 0 || _x > 255 } != -1) exitWith { [] };

_ip;
