/**
 * Inits ACE3 Interactions likes dragging, carrying and cargo.
 * Workaround is needed for some classes, that can't use ACE3 config entries.
 *
 * Arguments:
 * 0: Equipment <OBJECT>
 * 1: Dragging Settings <ARRAY>
 * 2: Carrying Settings <ARRAY>
 * 3: Cargo Settings <ARRAY>
 *
 * Returns:
 * none
 */

params["_equipment", "_aceDragging", "_aceCarrying", "_aceCargo"];

if(!isDedicated) then
{
	private _settingsAce3 = createHashMap;

	if (!(_aceDragging isEqualTo [])) then
	{
		private _ae3_dragging_canDrag = _aceDragging select 0;
		private _ae3_dragging_dragPosition = _aceDragging select 1;
		private _ae3_dragging_dragDirection = _aceDragging select 2;

		if (_ae3_dragging_canDrag == 1) then { _ae3_dragging_canDrag = true; } else { _ae3_dragging_canDrag = false; };

		[_equipment, _ae3_dragging_canDrag, _ae3_dragging_dragPosition, _ae3_dragging_dragDirection] call ace_dragging_fnc_setDraggable;

		_settingsAce3 set ["ae3_dragging_canDrag", _ae3_dragging_canDrag];
		_settingsAce3 set ["ae3_dragging_dragIsActive", true];
		_settingsAce3 set ["ae3_dragging_dragPosition", _ae3_dragging_dragPosition];
		_settingsAce3 set ["ae3_dragging_dragDirection", _ae3_dragging_dragDirection];
	};

	if (!(_aceCarrying isEqualTo [])) then
	{
		private _ae3_dragging_canCarry = _aceCarrying select 0;
		private _ae3_dragging_carryPosition = _aceCarrying select 1;
		private _ae3_dragging_carryDirection = _aceCarrying select 2;

		if (_ae3_dragging_canCarry == 1) then { _ae3_dragging_canCarry = true; } else { _ae3_dragging_canCarry = false; };

		[_equipment, _ae3_dragging_canCarry, _ae3_dragging_carryPosition, _ae3_dragging_carryDirection] call ace_dragging_fnc_setCarryable;

		_settingsAce3 set ["ae3_dragging_canCarry", _ae3_dragging_canCarry];
		_settingsAce3 set ["ae3_dragging_carryIsActive", true];
		_settingsAce3 set ["ae3_dragging_carryPosition", _ae3_dragging_carryPosition];
		_settingsAce3 set ["ae3_dragging_carryDirection", _ae3_dragging_carryDirection];
	};

	if (!(_aceCargo isEqualTo [])) then
	{
		private _ae3_cargo_canLoad = _aceCargo select 0;
		private _ae3_cargo_size = _aceCargo select 1;

		if (_ae3_cargo_canLoad == 1) then { _ae3_cargo_canLoad = true; } else { _ae3_cargo_canLoad = false; };
	
		[_equipment, _ae3_cargo_size] call ace_cargo_fnc_setSize;

		_settingsAce3 set ["ae3_cargo_canLoad", _ae3_cargo_canLoad];
		_settingsAce3 set ["ae3_cargo_isActive", true];
		_settingsAce3 set ["ae3_cargo_size", _ae3_cargo_size];
	};

	_equipment setVariable ["AE3_SettingsACE3", _settingsAce3, true];
};