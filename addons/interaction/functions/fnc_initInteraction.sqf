/**
 * Animates interactive equipment by user-defined input.
 *
 * Arguments:
 * 0: Equipment <OBJECT>
 * 1: Name <STRING> (Optional)
 * 2: Close State <Number> (Optional)
 * 3: Init <FUNCTION> (Optional)
 * 4: Open Function <FUNCTION> (Optional)
 * 5: Close Function <FUNCTION> (Optional)
 * 6: Animation Points <ARRAY> (Optional)
 *
 * Returns:
 * none
 */

params["_equipment", ["_name", "Equipment"], ["_closeState", 0], ["_initFnc", {}], ["_openFnc", {}], ["_openCondition", {true}], ["_closeFnc", {}], ["_closeCondition", {true}], ["_animationPoints", []]];

/* ---------------------------------------- */

private _openWrapper =
{
	params["_target", ["_args", []]];

	_openFnc =  _target getVariable "AE3_interaction_fnc_open";
	_result = [_target] + _args call _openFnc;
	if(isNil "_result") then {_result = false};

	if(_result) then
	{
		_target setVariable ["AE3_interaction_closeState", 0, true];
	};
};

/* ---------------------------------------- */

private _closeWrapper =
{
	params["_target", ["_args", []]];

	_closeFnc =  _target getVariable "AE3_interaction_fnc_close";
	_result = [_target] + _args call _closeFnc;
	if(isNil "_result") then {_result = false};

	if(_result) then
	{
		_target setVariable ["AE3_interaction_closeState", 1, true];
	};
};

/* ---------------------------------------- */

if (!isDedicated) then
{
	{
		private _animationPointDescription = _x select 0;
		private _animationPointSelection = _x select 1;
		private _animationMain = _x select 2;
		private _animationModifiedShift = _x select 3;
		private _animationModifiedCtrl = _x select 4;
		private _animationModifiedAlt = _x select 5;

		private _action = 
		[
			_animationPointDescription,
			_animationPointDescription,
			"",
			{
				params ["_target", "_player", "_params"];

				private _animationMain = _params select 0;
				private _animationModifiedShift = _params select 1;
				private _animationModifiedCtrl = _params select 2;
				private _animationModifiedAlt = _params select 3;

				_handle = [_target, _animationMain, _animationModifiedShift, _animationModifiedCtrl, _animationModifiedAlt] spawn AE3_interaction_fnc_animateInteraction;
			},
			{
				alive _target;
			},
			{},
			[_animationMain, _animationModifiedShift, _animationModifiedCtrl, _animationModifiedAlt],
			_animationPointSelection
		] call ace_interact_menu_fnc_createAction;

		[_equipment, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;

	} forEach _animationPoints;

	/* ---------------------------------------- */

	private _parentActionPath = [_equipment, _name] call AE3_main_fnc_interaction_addParentAction;

	// Add open/close action
	if (!((_openFnc isEqualTo {}) || (_closeFnc isEqualTo {}))) then
	{
		_open = ["AE3_openAction", localize "STR_AE3_Interaction_General_Open", "", 
					{
						params ["_target", "_player", "_params"]; 

						[_target] spawn {
							params["_target"];
							[_target] call (_target getVariable "AE3_interaction_fnc_openWrapper");

							if (_target getVariable "AE3_power_powerState" == 2) then
							{
								[_target] call (_target getVariable "AE3_power_fnc_turnOnWrapper");
							};
						};
						
					}, 
					{(_target call (_target getVariable ["AE3_interaction_fnc_openActionCondition", {true}])) and (alive _target) and (_target getVariable "AE3_interaction_closeState" == 1)},
					{}] call ace_interact_menu_fnc_createAction;

		_close = ["AE3_closeAction", localize "STR_AE3_Interaction_General_Close", "", 
					{
						params ["_target", "_player", "_params"]; 
						
						[_target] spawn {
							params ["_target"];
							[_target] call (_target getVariable "AE3_interaction_fnc_closeWrapper");

							if (_target getVariable "AE3_power_powerState" == 1) then
							{
								[_target] call (_target getVariable "AE3_power_fnc_standbyWrapper");
							};
						};
					}, 
					{(_target call (_target getVariable ["AE3_interaction_fnc_closeActionCondition", {true}])) and (alive _target) and (_target getVariable "AE3_interaction_closeState" == 0) },
					{}] call ace_interact_menu_fnc_createAction;

		[_equipment, 0, _parentActionPath, _open] call ace_interact_menu_fnc_addActionToObject;
		[_equipment, 0, _parentActionPath, _close] call ace_interact_menu_fnc_addActionToObject;
	};
};

/* ---------------------------------------- */

if(isServer) then
{
	_equipment setVariable ["AE3_interaction_closeState", _closeState, true];
};

_equipment setVariable ["AE3_interaction_fnc_open", _openFnc];
_equipment setVariable ["AE3_interaction_fnc_openActionCondition", _openCondition];
_equipment setVariable ["AE3_interaction_fnc_openWrapper", _openWrapper];
_equipment setVariable ["AE3_interaction_fnc_close", _closeFnc];
_equipment setVariable ["AE3_interaction_fnc_closeActionCondition", _closeCondition];
_equipment setVariable ["AE3_interaction_fnc_closeWrapper", _closeWrapper];

[_equipment] call _initFnc;