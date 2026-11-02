#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Registers a condition used by AE3_network_fnc_canConnect, for joining a router and for staying
 * connected to it. The code gets [_device, _router] and returns [allowed, reason] or a BOOL. A refusal without
 * reason reports "Connection refused"; nil counts as allowed. Registering an existing id replaces it. Local to
 * the calling machine: register on every machine, the server result is authoritative.
 *
 * Arguments:
 * 0: _id <STRING> - Unique id
 * 1: _code <CODE> - Condition
 *
 * Return Value:
 * Registered <BOOL>
 *
 * Example:
 * ["myMod_jamming", {
 *     params ["_device", "_router"];
 *     [!(_router getVariable ["myMod_blocked", false]), "Blocked"]
 * }] call AE3_network_fnc_addConnectCondition;
 *
 * Public: Yes
 */

params [["_id", "", [""]], ["_code", {}, [{}]]];

if (_id isEqualTo "") exitWith { false };

if (isNil QGVAR(connectConditions)) then { GVAR(connectConditions) = createHashMap; };
GVAR(connectConditions) set [_id, _code];

true
