/*
 * Author: Root
 * Description: Handles laptop pickup using the stable method. Hides the laptop, disables simulation,
 * and adds a vanilla dummy laptop item to the player's inventory with tracking.
 *
 * Arguments:
 * 0: _target <OBJECT> - The laptop object
 * 1: _player <OBJECT> - The player picking up the laptop
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, player] call AE3_armaos_fnc_laptop_pickup_stable;
 *
 * Public: No
 */

params ["_target", "_player"];

if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] ========== laptop_pickup_stable CALLED on %2 by %3 ==========", time, _target, _player];
};

// If running in unscheduled environment, re-spawn in scheduled environment
if (!canSuspend) exitWith {
	if (AE3_DebugMode) then {
		diag_log format ["[AE3 DEBUG] [%1] laptop_pickup_stable: Re-spawning in scheduled environment", time];
	};
	[_target, _player] spawn AE3_armaos_fnc_laptop_pickup_stable;
};

// Check if laptop is currently being used
private _mutex = _target getVariable ["AE3_computer_mutex", objNull];
if (!isNull _mutex) then {
	if (AE3_DebugMode) then {
		diag_log format ["[AE3 DEBUG] [%1] laptop_pickup_stable: Laptop is in use by %2, closing terminal", time, _mutex];
	};
	// If someone is using the laptop, close their terminal dialog
	private _terminalDialog = _mutex getVariable ["AE3_terminalDialog", displayNull];
	if (!isNull _terminalDialog) then {
		closeDialog 0;
		sleep 0.1;
	};

	// Clear the mutex
	_target setVariable ["AE3_computer_mutex", objNull, true];
};

// Get or create the global laptop tracking hashmap
// Maps item class names (Item_Laptop_AE3_ID_X) to laptop objects
private _laptopTracker = missionNamespace getVariable ["AE3_LAPTOP_STABLE_TRACKER", createHashMap];

// Get the item class for this laptop type
private _itemClass = getText ((configOf _target) >> "ae3_item");

if (_itemClass == "") exitWith {
	hint "This laptop cannot be picked up into inventory.";
	false
};

// Find available ID
private _id = 1;
private _item = _itemClass + "_ID_";

while {(_item + str _id) in _laptopTracker} do {
	_id = _id + 1;
	if (_id > 512) exitWith {
		hint "Cannot carry more than 512 unique laptops at once.";
		false
	};
};

_item = _item + (str _id);

// Check if player has inventory space
if !([_player, _item] call CBA_fnc_canAddItem) exitWith {
	hint "No storage space in inventory";
	if (AE3_DebugMode) then {
		diag_log format ["[AE3 DEBUG] [%1] laptop_pickup_stable: Player %2 has no inventory space for %3", time, _player, _item];
	};
	false
};

if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] laptop_pickup_stable: Assigned item %2 to laptop %3", time, _item, _target];
};

// Store the laptop object in the tracker
_laptopTracker set [_item, _target];
missionNamespace setVariable ["AE3_LAPTOP_STABLE_TRACKER", _laptopTracker, true];

// Calculate unique position for this laptop in a spiral pattern around [2, 2, 2]
// This prevents all laptops from stacking at the same position
// Distribution: 100 laptops ≈ 20m radius, 1000 laptops ≈ 63m radius, 10000 laptops ≈ 200m radius
private _hiddenLaptopCount = missionNamespace getVariable ["AE3_LAPTOP_STABLE_HIDDEN_COUNT", 0];
_hiddenLaptopCount = _hiddenLaptopCount + 1;
missionNamespace setVariable ["AE3_LAPTOP_STABLE_HIDDEN_COUNT", _hiddenLaptopCount, true];

// Use Fibonacci spiral (golden angle) for even distribution
// Golden angle ≈ 137.5 degrees ensures laptops don't line up in rows
private _goldenAngle = 137.508;
private _angle = _hiddenLaptopCount * _goldenAngle;
private _radius = sqrt _hiddenLaptopCount * 2; // 2 meters spacing factor

private _x = 2 + (_radius * cos _angle);
private _y = 2 + (_radius * sin _angle);
private _z = 100; // Keep all at same altitude

private _hidePos = [_x, _y, _z];

// Hide the laptop and disable simulation
_target hideObjectGlobal true;
_target setPosATL _hidePos;
_target enableSimulationGlobal false;

if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] laptop_pickup_stable: Laptop #%2 hidden at position %3 (radius: %4m)", time, _hiddenLaptopCount, _hidePos, _radius];
};

// Add dummy laptop item to player inventory
[_player, _item, true] remoteExecCall ["CBA_fnc_addItem", _player];

// Prompt player to name the laptop (on client side)
[_target, _id, _player] remoteExec ["AE3_armaos_fnc_laptop_promptNameAndStore", _player];

// Show feedback to player
hint format ["Packed RootBook %1 into inventory", _id];

if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] ========== laptop_pickup_stable COMPLETE ==========", time];
};
