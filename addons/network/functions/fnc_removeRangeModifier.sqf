#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Removes a wireless range modifier registered with AE3_network_fnc_addRangeModifier on the calling
 * machine.
 *
 * Arguments:
 * 0: _id <STRING> - Id used at registration
 *
 * Return Value:
 * Removed <BOOL>
 *
 * Example:
 * ["myMod_interference"] call AE3_network_fnc_removeRangeModifier;
 *
 * Public: Yes
 */

params [["_id", "", [""]]];

if (isNil QGVAR(rangeModifiers)) exitWith { false };
if !(_id in GVAR(rangeModifiers)) exitWith { false };

GVAR(rangeModifiers) deleteAt _id;

true
