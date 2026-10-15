// File: fnc_closeTable.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Ends a table for everyone at it, telling each seated player why before it goes. Used
 * by the hosting device, by the Zeus Games module and by the abandonment sweep. Runs on the server;
 * a client call is routed there.
 *
 * Arguments:
 * 0: _tableId <STRING> - Table id
 * 1: _reasonKey <STRING> (Optional) - Stringtable key explaining the closure
 *
 * Return Value:
 * None
 *
 * Example:
 * ["chess-3", "$STR_AE3_Games_Status_Closed"] call AE3_games_fnc_closeTable;
 *
 * Public: Yes
 */

params [["_tableId", "", [""]], ["_reasonKey", "$STR_AE3_Games_Status_Closed", [""]]];

if (!isServer) exitWith {["ae3_games_close", [_tableId, _reasonKey]] call CBA_fnc_serverEvent};

private _tables = missionNamespace getVariable [QGVAR(tables), createHashMap];
private _table = _tables get _tableId;

if (isNil "_table") exitWith {};

{
    private _device = objectFromNetId (_x select 0);

    if (!isNull _device) then
    {
        [_device, 0] call FUNC(applyGamePowerLoad);
        [_device, _reasonKey] call FUNC(pushNotice);
    };
} forEach (_table getOrDefault ["seats", []]);

_tables deleteAt _tableId;
missionNamespace setVariable [QGVAR(tables), _tables];

[] call FUNC(manageSweep);
