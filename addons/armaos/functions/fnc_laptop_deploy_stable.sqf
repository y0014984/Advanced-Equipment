/*
 * Author: Root
 * Description: Handles deploying a laptop using the stable method. Unhides the laptop object,
 * moves it in front of the player, enables simulation, and removes the dummy item.
 *
 * Arguments:
 * 0: _player <OBJECT> - The player deploying the laptop
 * 1: _item <STRING> (Optional) - Specific laptop item to deploy. If not provided, deploys the first one found.
 *
 * Return Value:
 * <BOOL> - True if deployment successful, false otherwise
 *
 * Example:
 * [player] call AE3_armaos_fnc_laptop_deploy_stable;
 * [player, "Item_Laptop_AE3_ID_5"] call AE3_armaos_fnc_laptop_deploy_stable;
 *
 * Public: No
 */

params ["_player", ["_item", ""]];

if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] ========== laptop_deploy_stable CALLED by %2 ==========", time, _player];
};

// Get the laptop tracking hashmap
private _laptopTracker = missionNamespace getVariable ["AE3_LAPTOP_STABLE_TRACKER", createHashMap];

// Find laptop items in player's inventory
private _laptopItems = [];

{
	if (_x find "Item_Laptop_AE3_ID_" == 0) then {
		// Check if this item is tracked (stable mode item)
		if (_x in _laptopTracker) then {
			_laptopItems pushBack _x;
		};
	};
} forEach (items _player);

if (_laptopItems isEqualTo []) exitWith {
	hint "No laptop in inventory.";
	false
};

// Select which laptop to deploy
private _itemToDeploy = "";

if (_item != "" && _item in _laptopItems) then {
	// Deploy specific laptop if requested
	_itemToDeploy = _item;
} else {
	// Deploy first laptop found
	_itemToDeploy = _laptopItems select 0;
};

// Get the laptop object
private _laptop = _laptopTracker get _itemToDeploy;

if (isNil "_laptop" || {isNull _laptop}) exitWith {
	hint "Laptop object not found. This laptop may have been destroyed.";
	// Clean up the tracker
	_laptopTracker deleteAt _itemToDeploy;
	missionNamespace setVariable ["AE3_LAPTOP_STABLE_TRACKER", _laptopTracker, true];
	// Remove the item
	[_player, _itemToDeploy] call CBA_fnc_removeItem;
	false
};

if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] laptop_deploy_stable: Deploying laptop %2 from item %3", time, _laptop, _itemToDeploy];
};

// Calculate deployment position 1.5m in front of player at ground level
private _playerPos = getPosATL _player;
private _playerDir = getDir _player;

// Calculate position 1.5m in front of player
private _deployPos = [
	(_playerPos select 0) + (1.5 * sin _playerDir),
	(_playerPos select 1) + (1.5 * cos _playerDir),
	0.05  // Small offset above ground to prevent clipping
];

if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] laptop_deploy_stable: Deploying at position %2", time, _deployPos];
};

// Unhide and move the laptop
_laptop hideObjectGlobal false;
_laptop setPosATL _deployPos;
_laptop enableSimulationGlobal true;

// Remove the item from tracker
_laptopTracker deleteAt _itemToDeploy;
missionNamespace setVariable ["AE3_LAPTOP_STABLE_TRACKER", _laptopTracker, true];

// Remove the dummy item from player's inventory
[_player, _itemToDeploy] call CBA_fnc_removeItem;

// No deployment hint needed

if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] ========== laptop_deploy_stable COMPLETE ==========", time];
};

true
