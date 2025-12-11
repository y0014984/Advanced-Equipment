/*
 * Author: Root, Wasserstoff
 * Description: Converts an inventory item to a world object, preserving all variables from the item's namespace and removing the item from player inventory
 *
 * Arguments:
 * 0: _player <OBJECT> - Player who has the item in inventory
 * 1: _item <STRING> - Class name of the item to convert (e.g., "Item_FlashDisk_AE3_ID_1")
 * 2: _pos <ARRAY> - (Optional, default: [0,0,0]) Position to create the object at
 *
 * Return Value:
 * Created object or objNull if item not found <OBJECT>
 *
 * Example:
 * [player, "Item_FlashDisk_AE3_ID_1", [0,0,0]] call AE3_flashdrive_fnc_item2obj;
 *
 * Public: Yes
 */
params['_player', '_item', ['_pos', [0, 0, 0]]];


[missionNamespace, "AE3_ITEM"] call AE3_main_fnc_getRemoteVar;
private _buffer = missionNamespace getVariable ["AE3_ITEM" , createHashMap];

if (!(_item in _buffer)) exitWith {};

private _itemnamespace = _buffer get _item;
private _type = _itemnamespace get "AE3_OBJECT_TYPE";

private _object = createVehicle [_type, _pos, [], 0, "CAN_COLLIDE"];

{
	if (!(isNil "_y")) then
	{
		_object setVariable [_x, _y];
	};
} forEach _itemnamespace;

[_player, _item] remoteExecCall ["CBA_fnc_removeItem", _player];

_object;
