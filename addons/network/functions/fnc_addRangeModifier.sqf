#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Registers a wireless range modifier used by AE3_network_fnc_getWirelessRange. The code gets
 * [_router, _device] and returns a factor: 1 = unchanged, 0 = no range, > 1 = longer range. Negative factors
 * count as 0; non-number results are ignored. Registering an existing id replaces it. Local to the calling
 * machine: register on every machine, the server result is authoritative.
 *
 * Arguments:
 * 0: _id <STRING> - Unique id
 * 1: _code <CODE> - Modifier
 *
 * Return Value:
 * Registered <BOOL>
 *
 * Example:
 * ["myMod_interference", { params ["_router", "_device"]; 0.5 }] call AE3_network_fnc_addRangeModifier;
 *
 * Public: Yes
 */

params [["_id", "", [""]], ["_code", {}, [{}]]];

if (_id isEqualTo "") exitWith { false };

if (isNil QGVAR(rangeModifiers)) then { GVAR(rangeModifiers) = createHashMap; };
GVAR(rangeModifiers) set [_id, _code];

true
