// File: fnc_computer_allowsRootLogin.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Resolves whether a given computer accepts a direct login as the root user. A computer
 * can carry its own policy in the AE3_allowRootLogin variable ("allow" / "deny", or a boolean);
 * anything else - including no variable at all - falls back to the mission-wide AE3_AllowRootLogin
 * setting. Used by the terminal login, the ssh command and the desktop login so all three paths
 * apply the same rule.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to check
 *
 * Return Value:
 * true if root may log in directly on this computer <BOOL>
 *
 * Example:
 * private _allowed = [_laptop] call AE3_armaos_fnc_computer_allowsRootLogin;
 *
 * Public: Yes
 */

params [["_computer", objNull, [objNull]]];

private _override = _computer getVariable ["AE3_allowRootLogin", ""];

if (_override isEqualType true) exitWith { _override };

if (_override isEqualType "") then { _override = toLower _override; };

if (_override isEqualTo "allow") exitWith { true };
if (_override isEqualTo "deny") exitWith { false };

missionNamespace getVariable ["AE3_AllowRootLogin", false]
