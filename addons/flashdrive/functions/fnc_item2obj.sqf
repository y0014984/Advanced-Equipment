/**
 * Converts an item to an object.
 * Preserves the variables set for the items namespace.
 *
 */
params['_item', ['_pos', [0, 0, 0]]];

private _buffer = missionNamespace getVariable ["AE3_ITEM" , createHashMap];

if (!(_item in _buffer)) exitWith {};

private _itemnamespace = _buffer get _item;
private _type = _buffer get "AE3_OBJECT_TYPE";

private _object = createVehicle [_type, _pos, [], "CAN_COLLIDE"];

{
	_object setVariable [_x, _y];
} forEach _itemnamespace;

_buffer deleteAt _item;
_object;