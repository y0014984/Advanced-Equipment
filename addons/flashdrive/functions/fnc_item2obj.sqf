/**
 * Converts an item to an object.
 * Preserves the variables set for the items namespace.
 *
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

_buffer deleteAt _item;
missionNamespace setVariable ["AE3_ITEM", _buffer, 2];

_object;