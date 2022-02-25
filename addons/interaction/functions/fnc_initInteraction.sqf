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

params["_equipment", ["_name", "Equipment"], ["_animatableLampsCount", 0], ["_closeState", 0], ["_initFnc", {}], ["_openFnc", {}], ["_closeFnc", {}]];

/* ---------------------------------------- */

private _openWrapper =
{
	params['_target', ['_args', []]];

	_openFnc =  _target getVariable "AE3_interaction_fnc_open";
	_result = [_target] + _args call _openFnc;
	if(isNil '_result') then {_result = false};

	if(_result) then
	{
		_target setVariable ['AE3_interaction_closeState', 1, true];
	};
};

/* ---------------------------------------- */

private _closeWrapper =
{
	params['_target', ['_args', []]];

	_closeFnc =  _target getVariable "AE3_interaction_fnc_close";
	_result = [_target] + _args call _closeFnc;
	if(isNil '_result') then {_result = false};

	if(_result) then
	{
		_target setVariable ['AE3_interaction_closeState', 0, true];
	};
};

/* ---------------------------------------- */

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

		[_equipment, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;
	};

	/* ---------------------------------------- */

	private _parentAction = ["AE3_EquipmentAction", _name, "", {}, {true}] call ace_interact_menu_fnc_createAction;
	[_equipment, 0, ["ACE_MainActions"], _parentAction] call ace_interact_menu_fnc_addActionToObject;

	// Add open/close action
	if (!((_openFnc isEqualTo {}) || (_closeFnc isEqualTo {}))) then
	{
		_open = ["AE3_openAction", "Open", "", 
					{
						params ['_target', '_player', '_params']; 

						//_target setVariable ['AE3_power_mutex', true, true];

						[_target] spawn {
							params['_target'];
							[_target] call (_target getVariable "AE3_interaction_fnc_openWrapper");

							//_target setVariable ['AE3_power_mutex', false, true];
						};
						
					}, 
					{(alive _target) and (_target getVariable 'AE3_interaction_closeState' != 1) /* and !(_target getVariable ['AE3_power_mutex', false]) */ },
					{}] call ace_interact_menu_fnc_createAction;

		_close = ["AE3_closeAction", "Close", "", 
					{
						params ['_target', '_player', '_params']; 
						
						//_target setVariable ['AE3_power_mutex', true, true];

						[_target] spawn {
							params['_target'];
							[_target] call (_target getVariable "AE3_interaction_fnc_closeWrapper");

							//_target setVariable ['AE3_power_mutex', false, true];
						};
					}, 
					{(alive _target) and (_target getVariable 'AE3_interaction_closeState' != 0) /* and !(_target getVariable ['AE3_power_mutex', false])*/ },
					{}] call ace_interact_menu_fnc_createAction;

		[_equipment, 0, ["ACE_MainActions", "AE3_EquipmentAction"], _open] call ace_interact_menu_fnc_addActionToObject;
		[_equipment, 0, ["ACE_MainActions", "AE3_EquipmentAction"], _close] call ace_interact_menu_fnc_addActionToObject;
	};
};

/* ---------------------------------------- */

if(isServer) then
{
	_equipment setVariable ["AE3_interaction_closeState", _closeState, true];
	_equipment setVariable ["AE3_interaction_fnc_open", _openFnc, true];
	_equipment setVariable ["AE3_interaction_fnc_openWrapper", _openWrapper, true];
	_equipment setVariable ["AE3_interaction_fnc_close", _closeFnc, true];
	_equipment setVariable ["AE3_interaction_fnc_closeWrapper", _closeWrapper, true];
};

[_equipment] call _initFnc;