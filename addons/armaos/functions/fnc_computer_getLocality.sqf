/*
 * Author: Root, Wasserstoff
 * Description: Returns the client ID of the current computer user. If the computer is unused, returns 2 (server ownership).
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to query
 *
 * Return Value:
 * Owner client ID <NUMBER>
 *
 * Example:
 * private _owner = [_computer] call AE3_armaos_fnc_computer_getLocality;
 *
 * Public: No
 */

params['_computer'];

private _owner = _computer getVariable ["AE3_computer_mutex", objNull];

if (isNull _owner) exitWith {2};

owner _owner;
