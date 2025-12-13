/*
 * Author: Root, y0014984
 * Description: Initializes ACE3 interactions (dragging, carrying, cargo) for equipment objects. Creates a
 * settings hashmap and calls manageAce3Interactions to apply initial state. Runs only on server.
 *
 * Arguments:
 * 0: _equipment <OBJECT> - The equipment object to initialize
 * 1: _aceDragging <ARRAY> - Dragging settings [canDrag, dragPosition, dragDirection]
 * 2: _aceCarrying <ARRAY> - Carrying settings [canCarry, carryPosition, carryDirection]
 * 3: _aceCargo <ARRAY> - Cargo settings [canLoad, size]
 * 4: _interactionConditions <ARRAY> - Interaction conditions [unwrapped]
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, [1, [0, 1, 0], 0], [1, [0, 1, 0], 0], [1, 2], [0]] call AE3_interaction_fnc_initAce3Interactions;
 *
 * Public: Yes
 */

params["_equipment", "_aceDragging", "_aceCarrying", "_aceCargo", "_interactionConditions"];

// this function only runs once on mission start on server or on client if it's no multiplayer
if(isServer) then
{
	private _settingsAce3 = createHashMap;

	if (_aceDragging isNotEqualTo []) then
	{
		private _ae3_dragging_canDrag = _aceDragging select 0;
		private _ae3_dragging_dragPosition = _aceDragging select 1;
		private _ae3_dragging_dragDirection = _aceDragging select 2;

		if (_ae3_dragging_canDrag == 1) then { _ae3_dragging_canDrag = true; } else { _ae3_dragging_canDrag = false; };

		_settingsAce3 set ["ae3_dragging_canDrag", _ae3_dragging_canDrag];
		_settingsAce3 set ["ae3_dragging_dragPosition", _ae3_dragging_dragPosition];
		_settingsAce3 set ["ae3_dragging_dragDirection", _ae3_dragging_dragDirection];
	};

	if (_aceCarrying isNotEqualTo []) then
	{
		private _ae3_dragging_canCarry = _aceCarrying select 0;
		private _ae3_dragging_carryPosition = _aceCarrying select 1;
		private _ae3_dragging_carryDirection = _aceCarrying select 2;

		if (_ae3_dragging_canCarry == 1) then { _ae3_dragging_canCarry = true; } else { _ae3_dragging_canCarry = false; };

		_settingsAce3 set ["ae3_dragging_canCarry", _ae3_dragging_canCarry];
		_settingsAce3 set ["ae3_dragging_carryPosition", _ae3_dragging_carryPosition];
		_settingsAce3 set ["ae3_dragging_carryDirection", _ae3_dragging_carryDirection];
	};

	if (_aceCargo isNotEqualTo []) then
	{
		private _ae3_cargo_canLoad = _aceCargo select 0;
		private _ae3_cargo_size = _aceCargo select 1;

		if (_ae3_cargo_canLoad == 1) then { _ae3_cargo_canLoad = true; } else { _ae3_cargo_canLoad = false; };

		_settingsAce3 set ["ae3_cargo_canLoad", _ae3_cargo_canLoad];
		_settingsAce3 set ["ae3_cargo_size", _ae3_cargo_size];
	};

	if (_interactionConditions isNotEqualTo []) then
	{
		private _ae3_unwrapped = _interactionConditions select 0;

		if (_ae3_unwrapped == 1) then { _ae3_unwrapped = true; } else { _ae3_unwrapped = false; };

		_settingsAce3 set ["unwrapped", _ae3_unwrapped];
	};

	_equipment setVariable ["AE3_SettingsACE3", _settingsAce3];

	[_equipment, "init", true] call AE3_interaction_fnc_manageAce3Interactions;
};
