/*
 * Author: Root
 * Description: Handles laptop pickup into inventory. Closes active terminal dialogs and clears mutex.
 *
 * Arguments:
 * 0: _target <OBJECT> - The laptop object
 * 1: _player <OBJECT> - The player picking up the laptop
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, player] call AE3_armaos_fnc_laptop_pickup;
 *
 * Public: No
 */

params ["_target", "_player"];

// If running in unscheduled environment, re-spawn in scheduled environment
if (!canSuspend) exitWith {
	[_target, _player] spawn AE3_armaos_fnc_laptop_pickup;
};

// Check if laptop is currently being used
private _mutex = _target getVariable ["AE3_computer_mutex", objNull];
if (!isNull _mutex) then {
	// If someone is using the laptop, close their terminal dialog
	// This ensures clean state saving via the dialog unload event handler
	private _terminalDialog = _mutex getVariable ["AE3_terminalDialog", displayNull];
	if (!isNull _terminalDialog) then {
		closeDialog 0;
		sleep 0.1;
	};

	// Clear the mutex
	_target setVariable ["AE3_computer_mutex", objNull, true];
};

// Force power off if laptop is on (saves state properly)
private _powerState = _target getVariable ["AE3_power_powerState", 0];
if (_powerState == 1) then {
	// Run in scheduled environment to allow waitUntil in power system
	[_target] spawn AE3_armaos_fnc_computer_turnOff;
	// Wait for power off to complete
	waitUntil {sleep 0.1; (_target getVariable ["AE3_power_powerState", 0]) == 0};
};

// Convert object to item
[_target, _player] call AE3_armaos_fnc_laptop_obj2item;
