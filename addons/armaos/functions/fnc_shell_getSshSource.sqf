// File: fnc_shell_getSshSource.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Returns the computer an SSH session into the given device was opened from, or objNull
 * when the device is not the target of an SSH session. Only meaningful on the machine running the
 * session (the operator's client), where the session state lives.
 *
 * Arguments:
 * 0: _computer <OBJECT> - Device that may be an SSH target
 *
 * Return Value:
 * Source computer, or objNull <OBJECT>
 *
 * Example:
 * private _source = [_computer] call AE3_armaos_fnc_shell_getSshSource;
 *
 * Public: Yes
 */

params [["_computer", objNull, [objNull]]];

if (isNull _computer) exitWith { objNull };

_computer getVariable ["AE3_stdoutRedirect", objNull]
