// File: fnc_manageSweep.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Starts the table housekeeping loop when the first table opens and removes it when the
 * last one closes, so a mission where nobody is playing runs no games code at all. Server only.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call AE3_games_fnc_manageSweep;
 *
 * Public: No
 */

if (!isServer) exitWith {};

private _tables = missionNamespace getVariable [QGVAR(tables), createHashMap];
private _handle = missionNamespace getVariable [QGVAR(sweepHandle), -1];

if (count _tables > 0) exitWith
{
    if (_handle >= 0) exitWith {};

    _handle = [{[] call AE3_games_fnc_tableSweep}, 10] call CBA_fnc_addPerFrameHandler;

    missionNamespace setVariable [QGVAR(sweepHandle), _handle];
};

if (_handle < 0) exitWith {};

[_handle] call CBA_fnc_removePerFrameHandler;

missionNamespace setVariable [QGVAR(sweepHandle), -1];
