#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Removes a connect condition registered with AE3_network_fnc_addConnectCondition on the calling
 * machine.
 *
 * Arguments:
 * 0: _id <STRING> - Id used at registration
 *
 * Return Value:
 * Removed <BOOL>
 *
 * Example:
 * ["myMod_jamming"] call AE3_network_fnc_removeConnectCondition;
 *
 * Public: Yes
 */

params [["_id", "", [""]]];

if (isNil QGVAR(connectConditions)) exitWith { false };
if !(_id in GVAR(connectConditions)) exitWith { false };

GVAR(connectConditions) deleteAt _id;

true
