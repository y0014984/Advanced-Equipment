/*
 * Author: Root
 * Description: Converts a laptop inventory item back to a world object, restoring all state.
 *
 * Arguments:
 * 0: _player <OBJECT> - The player deploying the laptop
 * 1: _item <STRING> - The item class name (e.g., "Item_Laptop_AE3_ID_1")
 * 2: _pos <ARRAY> (Optional) - Position to deploy at, defaults to player position
 *
 * Return Value:
 * <OBJECT> - The created laptop object, objNull if failed
 *
 * Example:
 * [player, "Item_Laptop_AE3_ID_1"] call AE3_armaos_fnc_laptop_item2obj;
 * [player, "Item_Laptop_AE3_ID_1", [0, 0, 0]] call AE3_armaos_fnc_laptop_item2obj;
 *
 * Public: No
 */

params ["_player", "_item", ["_pos", [], [[]]]];

// Sync item data from server if needed
[missionNamespace, "AE3_LAPTOP_ITEM"] call AE3_main_fnc_getRemoteVar;
private _buffer = missionNamespace getVariable ["AE3_LAPTOP_ITEM", createHashMap];

if (!(_item in _buffer)) exitWith {
	hint "Laptop data not found. Item may be corrupted.";
	objNull
};

private _itemNamespace = _buffer get _item;
private _type = _itemNamespace get "AE3_OBJECT_TYPE";

if (isNil "_type" || {_type == ""}) exitWith {
	hint "Laptop type data missing. Cannot deploy.";
	objNull
};

// Determine deployment position
if (_pos isEqualTo []) then {
	// Deploy in front of player
	_pos = _player modelToWorld [0, 1.5, 0];
	_pos set [2, 0]; // Place on ground
};

if (AE3_DebugMode) then {
	// DEBUG: Log pre-creation state with timestamp
	diag_log format ["[AE3 DEBUG] [%1] ========== laptop_item2obj: ABOUT TO CREATE VEHICLE ==========", time];
	diag_log format ["[AE3 DEBUG] [%1] Call stack: %2", time, diag_stacktrace];
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Type: %2 | Pos: %3", time, _type, _pos];
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Calling createVehicle NOW...", time];
};

// Create the laptop object
private _object = createVehicle [_type, _pos, [], 0, "CAN_COLLIDE"];

// Small delay to allow init events to fire
sleep 0.05;

// Count ACE actions immediately after creation (for debug logging later)
private _actionsPostCreate = 0;
private _existingActionsPostCreate = _object getVariable ["ace_interact_menu_Act_SelfActions", []];
if (_existingActionsPostCreate isEqualType []) then {
	_actionsPostCreate = count _existingActionsPostCreate;
};

if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: createVehicle returned, object = %2", time, _object];
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: After 50ms delay post-creation", time];

	// DEBUG: Check flag state immediately after creation, before any restoration
	private _flagCheck1 = _object getVariable ["AE3_interaction_laptopActionsAdded", "UNDEFINED"];
	private _flagCheck2 = _object getVariable ["AE3_interaction_equipmentActionsAdded", "UNDEFINED"];
	private _flagCheck3 = _object getVariable ["AE3_power_actionsAdded", "UNDEFINED"];
	private _flagCheck4 = _object getVariable ["AE3_interaction_hasEquipmentAction", "UNDEFINED"];
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: POST-CREATE flag check: laptop=%2 | equipment=%3 | power=%4 | hasEquipment=%5", time, _flagCheck1, _flagCheck2, _flagCheck3, _flagCheck4];

	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: ACE actions immediately after createVehicle: %2", time, _actionsPostCreate];
};

// CRITICAL: Set restoration flag FIRST before restoring any variables
// This flag tells init code not to overwrite the restored power state
_object setVariable ["AE3_laptop_restored", true, true];

if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Set restoration flag to TRUE", time];

	// DEBUG: Log restoration process
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Restoring laptop from item %2 to object %3", time, _item, _object];
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Will restore %2 variables from saved data", time, count _itemNamespace];

	// DEBUG: Check if critical flags are in the saved data (they should NOT be!)
	private _criticalFlags = ["AE3_interaction_laptopActionsAdded", "AE3_interaction_equipmentActionsAdded", "AE3_power_actionsAdded", "AE3_interaction_hasEquipmentAction"];
	{
		private _flagName = _x;
		if (_flagName in _itemNamespace) then {
			diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: !!!!! WARNING! Flag %2 found in saved data, will be restored !!!!!", time, _flagName];
		} else {
			diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Flag %2 NOT in saved data (correct)", time, _flagName];
		};
	} forEach _criticalFlags;
};

// Restore all variables from item namespace
private _restoredCount = 0;
if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: ===== STARTING variable restoration loop =====", time];
};

{
	if (!(_x in ["AE3_OBJECT_TYPE", "AE3_ORIGINAL_POS", "AE3_ORIGINAL_DIR"])) then {
		private _value = _y;
		if (!isNil "_value") then {
			if (AE3_DebugMode) then {
				// DEBUG: Log ALL variables that look like action flags
				if (_x find "Action" >= 0 || _x find "action" >= 0) then {
					diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Restoring action-related var: %2 = %3", time, _x, _value];
				};
				// DEBUG: Log critical flags being restored
				if (_x in ["AE3_interaction_laptopActionsAdded", "AE3_interaction_equipmentActionsAdded", "AE3_power_actionsAdded", "AE3_interaction_hasEquipmentAction"]) then {
					diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: !!!!! ERROR! Restoring runtime flag %2 = %3 (THIS SHOULD NOT HAPPEN) !!!!!", time, _x, _value];
				};
			};
			_object setVariable [_x, _value, true]; // Broadcast to all clients
			_restoredCount = _restoredCount + 1;
		};
	};
} forEach _itemNamespace;

if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: ===== FINISHED variable restoration loop =====", time];

	// DEBUG: Check flag state after restoration
	private _flagCheckAfter1 = _object getVariable ["AE3_interaction_laptopActionsAdded", "UNDEFINED"];
	private _flagCheckAfter2 = _object getVariable ["AE3_interaction_equipmentActionsAdded", "UNDEFINED"];
	private _flagCheckAfter3 = _object getVariable ["AE3_power_actionsAdded", "UNDEFINED"];
	private _flagCheckAfter4 = _object getVariable ["AE3_interaction_hasEquipmentAction", "UNDEFINED"];
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: POST-RESTORE flag check: laptop=%2 | equipment=%3 | power=%4 | hasEquipment=%5", time, _flagCheckAfter1, _flagCheckAfter2, _flagCheckAfter3, _flagCheckAfter4];

	// DEBUG: Count ACE actions after restoration
	private _actionsPostRestore = 0;
	private _existingActionsPostRestore = _object getVariable ["ace_interact_menu_Act_SelfActions", []];
	if (_existingActionsPostRestore isEqualType []) then {
		_actionsPostRestore = count _existingActionsPostRestore;
	};
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: ACE actions after restoration: %2 (delta from post-create: %3)", time, _actionsPostRestore, _actionsPostRestore - _actionsPostCreate];

	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Restored %2 variables to object", time, _restoredCount];
};

// Restore orientation if available
private _originalDir = _itemNamespace getOrDefault ["AE3_ORIGINAL_DIR", getDir _player];
_object setDir _originalDir;

// Remove item from player inventory
[_player, _item] remoteExecCall ["CBA_fnc_removeItem", _player];

// Show feedback - extract ID from item class name (e.g., "Item_Laptop_AE3_ID_5" -> "5")
private _idStr = _item select [20]; // Skip "Item_Laptop_AE3_ID_"
hint format ["Deployed Laptop %1", _idStr];

if (AE3_DebugMode) then {
	// DEBUG: Final state check after everything
	diag_log format ["[AE3 DEBUG] [%1] ========== laptop_item2obj: DEPLOYMENT COMPLETE ==========", time];
	private _finalFlags = format ["laptop=%1 | equipment=%2 | power=%3 | hasEquipment=%4",
		_object getVariable ["AE3_interaction_laptopActionsAdded", "UNDEFINED"],
		_object getVariable ["AE3_interaction_equipmentActionsAdded", "UNDEFINED"],
		_object getVariable ["AE3_power_actionsAdded", "UNDEFINED"],
		_object getVariable ["AE3_interaction_hasEquipmentAction", "UNDEFINED"]
	];
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Final flag states: %2", time, _finalFlags];

	private _actionsFinal = 0;
	private _existingActionsFinal = _object getVariable ["ace_interact_menu_Act_SelfActions", []];
	if (_existingActionsFinal isEqualType []) then {
		_actionsFinal = count _existingActionsFinal;
	};
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Final ACE action count: %2", time, _actionsFinal];
};

// Return the created object
_object
