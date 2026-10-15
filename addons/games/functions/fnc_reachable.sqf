// File: fnc_reachable.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Decides whether two devices can sit at the same table. With the same-network
 * requirement on, the network component answers it: AE3_network_fnc_resolve walks the actual
 * topology and already accounts for power state, routers, wireless range and the cross-subnet
 * policy, so a laptop that was carried out of range or unplugged stops being reachable on its own.
 * With the requirement off, both devices only have to be powered on.
 *
 * Arguments:
 * 0: _from <OBJECT> - Device asking
 * 1: _to <OBJECT> - Device being reached
 *
 * Return Value:
 * True when the two devices may share a table <BOOL>
 *
 * Example:
 * if ([_computer, _hostDevice] call AE3_games_fnc_reachable) then {...};
 *
 * Public: No
 */

params [["_from", objNull, [objNull]], ["_to", objNull, [objNull]]];

if (isNull _from || {isNull _to}) exitWith {false};
if (!alive _from || {!alive _to}) exitWith {false};

if ((_from getVariable ["AE3_power_powerState", 0]) != 1) exitWith {false};
if ((_to getVariable ["AE3_power_powerState", 0]) != 1) exitWith {false};

if (_from isEqualTo _to) exitWith {true};

if !([_from, "RequireSameNetwork"] call FUNC(getSetting)) exitWith {true};

private _address = _to getVariable ["AE3_network_address", [127, 0, 0, 1]];

if (_address isEqualTo [127, 0, 0, 1]) exitWith {false};

private _resolved = ([_from, _address] call AE3_network_fnc_resolve) param [0, objNull];

!isNull _resolved
