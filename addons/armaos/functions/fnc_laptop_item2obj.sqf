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

// Create the laptop object
private _object = createVehicle [_type, _pos, [], 0, "CAN_COLLIDE"];

// Restore all variables from item namespace
{
	if (!(_x in ["AE3_OBJECT_TYPE", "AE3_ORIGINAL_POS", "AE3_ORIGINAL_DIR"])) then {
		private _value = _y;
		if (!isNil "_value") then {
			_object setVariable [_x, _value, true]; // Broadcast variable to all clients
		};
	};
} forEach _itemNamespace;

// Restore orientation if available
private _originalDir = _itemNamespace getOrDefault ["AE3_ORIGINAL_DIR", getDir _player];
_object setDir _originalDir;

// Remove item from player inventory
[_player, _item] remoteExecCall ["CBA_fnc_removeItem", _player];

// Show feedback - extract ID from item class name (e.g., "Item_Laptop_AE3_ID_5" -> "5")
private _idStr = _item select [20]; // Skip "Item_Laptop_AE3_ID_"
hint format ["Deployed Laptop %1", _idStr];

// Return the created object
_object
