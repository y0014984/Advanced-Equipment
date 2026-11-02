#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Hostname of a computer: its custom name (ace_cargo_customName), else "armaOS". Any machine.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer
 *
 * Return Value:
 * Hostname <STRING>
 *
 * Example:
 * private _host = [_laptop] call AE3_armaos_fnc_computer_getHostname;
 *
 * Public: Yes
 */

params [["_computer", objNull, [objNull]]];

[_computer, "armaOS"] call AE3_main_fnc_getDeviceName
