#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Effective wireless range in metres between a router and a device: the configured range
 * (AE3_network_wirelessRange) times the router multiplier (AE3_network_rangeMultiplier), the mission multiplier
 * (CBA setting AE3_network_wirelessRangeMultiplier) and every registered range modifier. Any machine.
 *
 * Arguments:
 * 0: _router <OBJECT> - The router
 * 1: _device <OBJECT> - (Optional, default: objNull) The device the range is wanted for
 *
 * Return Value:
 * Range in metres, >= 0 <NUMBER>
 *
 * Example:
 * private _range = [_router, _laptop] call AE3_network_fnc_getWirelessRange;
 *
 * Public: Yes
 */

params [["_router", objNull, [objNull]], ["_device", objNull, [objNull]]];

if (isNull _router) exitWith { 0 };

private _range = (_router getVariable ["AE3_network_wirelessRange", 100])
    * (_router getVariable ["AE3_network_rangeMultiplier", 1])
    * (missionNamespace getVariable [QGVAR(wirelessRangeMultiplier), 1]);

{
    private _factor = [_router, _device] call _y;
    if (isNil "_factor" || {!(_factor isEqualType 0)}) then {
        if (isNil QGVAR(badRangeModifiers)) then { GVAR(badRangeModifiers) = createHashMap; };
        if !(_x in GVAR(badRangeModifiers)) then {
            GVAR(badRangeModifiers) set [_x, true];
            WARNING_1("Range modifier %1 did not return a number, ignored",_x);
        };
        continue;
    };
    _range = _range * (_factor max 0);
} forEach (missionNamespace getVariable [QGVAR(rangeModifiers), createHashMap]);

_range max 0
