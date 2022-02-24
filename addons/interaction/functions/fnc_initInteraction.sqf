/**
 * Animates interactive equipment by user-defined input.
 *
 * Arguments:
 * 0: Equipment <OBJECT>
 * 1: Animatable Lamps Count <NUMBER> (Optional)
 *
 * Returns:
 * none
 */

params["_equipment", ["_animatableLampsCount", 0]];

if(!isDedicated) then
{
	for "_i" from 1 to _animatableLampsCount step 1 do
	{
		private _selectionName = format ["light_%1_pitch", _i];
		private _interactionName = format ["animate lamp %1", _i];
		private _extendInteractionDescription = format ["extend lamp %1", _i];
		private _pitchInteractionDescription = format ["pitch lamp %1", _i];
		private _yawInteractionDescription = format ["yaw lamp %1", _i];
		private _animateItemExtend = format ["Light_%1_extend_source", _i];
		private _animateItemPitch = format ["Light_%1_pitch_source", _i];
		private _animateItemYaw = format ["Light_%1_yaw_source", _i];

		private _action = 
		[
			_interactionName,
			_interactionName,
			"",
			{
				params ["_target", "_player", "_params"];

				private _extendInteractionDescription = _params select 0;
				private _animateItemExtend = _params select 1;
				private _pitchInteractionDescription = _params select 2;
				private _animateItemPitch = _params select 3;
				private _yawInteractionDescription = _params select 4;
				private _animateItemYaw = _params select 5;

				_handle = [_target, _extendInteractionDescription, _animateItemExtend, _pitchInteractionDescription, _animateItemPitch, _yawInteractionDescription, _animateItemYaw] spawn AE3_interaction_fnc_animateInteraction;
			},
			{
				alive _target;
			},
			{},
			[_extendInteractionDescription, _animateItemExtend, _pitchInteractionDescription, _animateItemPitch, _yawInteractionDescription, _animateItemYaw],
			_selectionName
		] call ace_interact_menu_fnc_createAction;

		[
			_equipment,
			0, 
			[],
			_action
		] call ace_interact_menu_fnc_addActionToObject;
	};
};