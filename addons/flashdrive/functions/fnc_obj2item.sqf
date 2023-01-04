/**
 * Converts an object to an item in the player inventory.
 * Preserves the variables set for the objects namespace.
 *
 */

params ["_object", "_player"];

private _itemClass = getText ((configOf _object) >> "ae3_item");

if (isNil "_itemClass") exitWith {};

private _buffer = missionNamespace getVariable ["AE3_ITEM" , createHashMap];

if (count _buffer > 511) exitWith {};

/* get free id */
private _id = 1;
private _item = _itemClass + "_ID_";

while {(_item + str _id) in _buffer} do
{
	_id = _id + 1;
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