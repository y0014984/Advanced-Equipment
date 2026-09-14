// File: fnc_attr_addSudoers.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Eden object-attribute helper. Adds the comma-separated accounts entered in the editor to
 * the laptop's /etc/sudoers once it has finished initialising, so the attribute can be set in the
 * editor and applied at mission start regardless of init ordering. Server-only; a no-op for an empty
 * list.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The laptop object
 * 1: _sudoers <STRING> - Comma-separated user names from the attribute
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, "cracked, analyst"] call AE3_armaos_fnc_attr_addSudoers;
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]], ["_sudoers", "", [""]]];

if (!isServer) exitWith {};
if (isNull _computer) exitWith {};

private _names = (_sudoers splitString ",") apply { trim _x };
_names = _names select { _x isNotEqualTo "" };

if (_names isEqualTo []) exitWith {};

[
	{ params ["_computer"]; !isNull _computer && {_computer getVariable ["AE3_cap_hasTerminal", false]} },
	{
		params ["_computer", "_names"];
		{
			[_computer, _x] call AE3_armaos_fnc_computer_addSudoer;
		} forEach _names;
	},
	[_computer, _names]
] call CBA_fnc_waitUntilAndExecute;
