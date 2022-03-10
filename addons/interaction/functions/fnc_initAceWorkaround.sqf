/**
 * Inits ACE3 Interactions likes dragging and carrying.
 * Workaround is needed for some classes, that can't use ACE3 config entries.
 *
 * Arguments:
 * 0: Equipment <OBJECT>
 * 1: Dragging Settings <ARRAY>
 * 2: Carrying Settings <ARRAY>
 *
 * Returns:
 * none
 */

params["_equipment", "_aceDragging", "_aceCarrying"];

if(!isDedicated) then
{
	if (!(_aceDragging isEqualTo [])) then
	{
		private _ae3_dragging_canDrag = _aceDragging select 0;
		private _ae3_dragging_dragPosition = _aceDragging select 1;
		private _ae3_dragging_dragDirection = _aceDragging select 2;

		if (_ae3_dragging_canDrag == 1) then { _ae3_dragging_canDrag = true; } else { _ae3_dragging_canDrag = false; };

		[_equipment, _ae3_dragging_canDrag, _ae3_dragging_dragPosition, _ae3_dragging_dragDirection] call ace_dragging_fnc_setDraggable;
	};

	if (!(_aceCarrying isEqualTo [])) then
	{
		private _ae3_dragging_canCarry = _aceCarrying select 0;
		private _ae3_dragging_carryPosition = _aceCarrying select 1;
		private _ae3_dragging_carryDirection = _aceCarrying select 2;

		if (_ae3_dragging_canCarry == 1) then { _ae3_dragging_canCarry = true; } else { _ae3_dragging_canCarry = false; };

		[_equipment, _ae3_dragging_canCarry, _ae3_dragging_carryPosition, _ae3_dragging_carryDirection] call ace_dragging_fnc_setCarryable;
	};
};