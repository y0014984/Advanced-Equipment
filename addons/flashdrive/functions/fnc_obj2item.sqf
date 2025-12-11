/*
 * Author: Root, Wasserstoff
 * Description: Converts a world object to an inventory item, preserving all object variables in the item's namespace and deleting the object from the world
 *
 * Arguments:
 * 0: _object <OBJECT> - Object to convert to an item
 * 1: _player <OBJECT> - Player to receive the item in inventory
 *
 * Return Value:
 * None
 *
 * Example:
 * [flashDriveObject, player] call AE3_flashdrive_fnc_obj2item;
 *
 * Public: Yes
 */

params ["_object", "_player"];

private _itemClass = getText ((configOf _object) >> "ae3_item");

if (isNil "_itemClass") exitWith {};

private _buffer = missionNamespace getVariable ["AE3_ITEM" , createHashMap];

if (count _buffer > 511) exitWith {};

private _id = _object getVariable ["AE3_ITEM_ID", -1];
private _item = _itemClass + "_ID_";
if (_id == -1) then
{
	_id = 1;
	/* get free id */
	while {(_item + str _id) in _buffer} do
	{
		_id = _id + 1;
	};
	_object setVariable ["AE3_ITEM_ID", _id];
};

_item = _item + (str _id);

/* Copy variables */
_itemNamespace = createHashMap;
{
	_itemNamespace set [_x, _object getVariable _x];
} forEach allVariables _object;

_itemNamespace set ["AE3_OBJECT_TYPE", typeOf _object];

_buffer set [_item, _itemNamespace];
missionNamespace setVariable ["AE3_ITEM", _buffer];

[_player, _item, true] remoteExecCall ["CBA_fnc_addItem", _player];

deleteVehicle _object;
