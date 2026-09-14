// File: fnc_module_addCalendarEvent.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Eden module function to add a calendar/intel event to all synced computers. Only runs
 * on the server when placed in the Eden editor (the Zeus path uses AE3_main_fnc_zeus_module_addCalendarEvent
 * which routes through the ae3_main_zeusDeviceOp server handler). Module is deleted after processing.
 *
 * Arguments:
 * 0: _module <OBJECT> - The Eden module object
 * 1: _syncedUnits <ARRAY> - Array of synced computer objects
 * 2: _activated <BOOL> - Module activation state
 *
 * Return Value:
 * Success <BOOL>
 *
 * Example:
 * [_module, [_computer1], true] call AE3_armaos_fnc_module_addCalendarEvent;
 *
 * Public: No
 */

params ["_module", "_syncedUnits", "_activated"];

// ignore this function if module is placed by curator/zeus (handled via the zeus device-op path)
if (_module getVariable ["BIS_fnc_moduleInit_isCuratorPlaced", false]) exitWith { false };

if (!isServer) exitWith {};

if (_activated) then
{
    [_module, _syncedUnits] spawn
    {
        params ["_module", "_syncedUnits"];

        waitUntil { !isNil "BIS_fnc_init" };

        private _date     = _module getVariable ["AE3_ModuleCalendar_Date", ""];
        private _title    = _module getVariable ["AE3_ModuleCalendar_Title", ""];
        private _location = _module getVariable ["AE3_ModuleCalendar_Location", ""];
        private _body     = _module getVariable ["AE3_ModuleCalendar_Body", ""];

        if (_date isEqualTo "" || _title isEqualTo "") exitWith { deleteVehicle _module; false };

        {
            private _computer = _x;
            waitUntil {
                sleep 0.1;
                _computer getVariable ["AE3_filesystemReady", false]
            };
            [_computer, _date, _title, _location, _body] call AE3_armaos_fnc_computer_addCalendarEvent;
        } forEach _syncedUnits;

        deleteVehicle _module;
    };
};

true
