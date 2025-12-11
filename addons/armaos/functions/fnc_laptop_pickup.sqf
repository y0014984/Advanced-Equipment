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

if (AE3_DebugMode) then {
	// DEBUG: Log pickup initiation
	diag_log format ["[AE3 DEBUG] [%1] ========== laptop_pickup CALLED on %2 by %3 ==========", time, _target, _player];
	diag_log format ["[AE3 DEBUG] [%1] Call stack: %2", time, diag_stacktrace];
};

// If running in unscheduled environment, re-spawn in scheduled environment
if (!canSuspend) exitWith {
	if (AE3_DebugMode) then {
		diag_log format ["[AE3 DEBUG] [%1] laptop_pickup: Re-spawning in scheduled environment", time];
	};
	[_target, _player] spawn AE3_armaos_fnc_laptop_pickup;
};

if (AE3_DebugMode) then {
	// DEBUG: Log current state before pickup
	private _powerState = _target getVariable ["AE3_power_powerState", -1];
	private _laptopFlag = _target getVariable ["AE3_interaction_laptopActionsAdded", "UNDEFINED"];
	private _equipmentFlag = _target getVariable ["AE3_interaction_equipmentActionsAdded", "UNDEFINED"];
	private _powerFlag = _target getVariable ["AE3_power_actionsAdded", "UNDEFINED"];
	private _hasEquipmentFlag = _target getVariable ["AE3_interaction_hasEquipmentAction", "UNDEFINED"];
	diag_log format ["[AE3 DEBUG] [%1] laptop_pickup: Current state - power=%2 | flags: laptop=%3 equipment=%4 power=%5 hasEquipment=%6", time, _powerState, _laptopFlag, _equipmentFlag, _powerFlag, _hasEquipmentFlag];
};

// Check if laptop is currently being used
private _mutex = _target getVariable ["AE3_computer_mutex", objNull];
if (!isNull _mutex) then {
	if (AE3_DebugMode) then {
		diag_log format ["[AE3 DEBUG] [%1] laptop_pickup: Laptop is in use by %2, closing terminal", time, _mutex];
	};
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

// CRITICAL: Ensure terminal sync data is available before saving to item
// The terminal_sync variable contains the raw buffer (STRING data) that can be safely saved
// When the terminal dialog closes, it saves sync data, but we need to retrieve it from remote
[_target, "AE3_terminal_sync"] call AE3_main_fnc_getRemoteVar;

if (AE3_DebugMode) then {
	private _syncData = _target getVariable ["AE3_terminal_sync", nil];
	if (!isNil "_syncData") then {
		private _bufferSize = count (_syncData select 0);
		diag_log format ["[AE3 DEBUG] [%1] laptop_pickup: Terminal sync data found - buffer has %2 lines", time, _bufferSize];
	} else {
		diag_log format ["[AE3 DEBUG] [%1] laptop_pickup: No terminal sync data found (terminal may never have been used)", time];
	};
};

// Convert object to item - laptop state is preserved (except power state which is excluded)
// The fnc_laptop_obj2item function saves all variables except power state and runtime flags
if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] laptop_pickup: Calling laptop_obj2item to convert to inventory item", time];
};
[_target, _player] call AE3_armaos_fnc_laptop_obj2item;
if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] ========== laptop_pickup COMPLETE ==========", time];
};
