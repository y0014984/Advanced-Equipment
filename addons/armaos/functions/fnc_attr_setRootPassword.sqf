// File: fnc_attr_setRootPassword.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Eden object-attribute helper. Applies the root password entered in the editor once the
 * laptop has finished initialising, so the attribute wins over the account the device init seeds
 * regardless of init ordering. Server-only; a no-op for an empty password.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The laptop object
 * 1: _password <STRING> - The root password from the attribute
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, "hunter2"] call AE3_armaos_fnc_attr_setRootPassword;
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]], ["_password", "", [""]]];

if (!isServer) exitWith {};
if (isNull _computer || _password isEqualTo "") exitWith {};

// keep the attribute value on the object right away; the user list entry follows once init is done
_computer setVariable ["AE3_rootPassword", _password, true];

[
	{ params ["_computer"]; !isNull _computer && {_computer getVariable ["AE3_cap_hasTerminal", false]} },
	{ params ["_computer", "_password"]; [_computer, _password] call AE3_armaos_fnc_computer_setRootPassword; },
	[_computer, _password]
] call CBA_fnc_waitUntilAndExecute;
