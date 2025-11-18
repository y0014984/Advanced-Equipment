/*
 * Author: Root
 * Description: Initializes interactive equipment with ACE3 actions for opening/closing and animation points.
 * Creates wrapper functions for open/close actions that integrate with the power system. Ensures the Equipment
 * parent action exists via ensureEquipmentParent.
 *
 * Arguments:
 * 0: _equipment <OBJECT> - The equipment object to initialize
 * 1: _name <STRING> (Optional, default: "Equipment") - Display name for the equipment
 * 2: _closeState <NUMBER> (Optional, default: 0) - Initial close state (0=open, 1=closed)
 * 3: _initFnc <CODE> (Optional, default: {}) - Initialization function to run
 * 4: _openFnc <CODE> (Optional, default: {}) - Function to execute when opening
 * 5: _openCondition <CODE> (Optional, default: {true}) - Condition to enable open action
 * 6: _closeFnc <CODE> (Optional, default: {}) - Function to execute when closing
 * 7: _closeCondition <CODE> (Optional, default: {true}) - Condition to enable close action
 * 8: _animationPoints <ARRAY> (Optional, default: []) - Animation point configurations
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, "Laptop", 1, {}, {[_this] call AE3_interaction_fnc_laptop_open}, {true}, {[_this] call AE3_interaction_fnc_laptop_close}, {true}, []] call AE3_interaction_fnc_initInteraction;
 *
 * Public: Yes
 */

params["_equipment", ["_name", "Equipment"], ["_closeState", 0], ["_initFnc", {}], ["_openFnc", {}], ["_openCondition", {true}], ["_closeFnc", {}], ["_closeCondition", {true}], ["_animationPoints", []]];

/* ---------------------------------------- */

private _openWrapper =
{
	params['_target', ['_args', []]];

	_openFnc =  _target getVariable "AE3_interaction_fnc_open";
	_result = [_target] + _args call _openFnc;
	if(isNil '_result') then {_result = false};

	if(_result) then
	{
		_target setVariable ['AE3_interaction_closeState', 0, true];
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
		_target setVariable ['AE3_interaction_closeState', 1, true];
	};
};

/* ---------------------------------------- */

if (!isDedicated) then
{
	// Check if equipment interactions have already been added
	// This prevents duplicate actions when equipment is deployed from inventory
	private _equipmentActionsAdded = _equipment getVariable ["AE3_interaction_equipmentActionsAdded", false];

	// DEBUG: Log equipment action attempts with timestamp
	diag_log format ["[AE3 DEBUG] [%1] ===== initInteraction called on %2 (type: %3) | actionsAdded: %4 =====", time, _equipment, typeOf _equipment, _equipmentActionsAdded];
	diag_log format ["[AE3 DEBUG] [%1] Call stack: %2", time, diag_stacktrace];

	if (!_equipmentActionsAdded) then {
		// Mark that we're adding the equipment actions IMMEDIATELY to prevent race conditions
		diag_log format ["[AE3 DEBUG] [%1] initInteraction: SETTING equipmentActionsAdded flag to TRUE for %2", time, _equipment];
		_equipment setVariable ["AE3_interaction_equipmentActionsAdded", true];
		diag_log format ["[AE3 DEBUG] [%1] Adding equipment actions (Open/Close) for %2", time, _equipment];

		// Count existing ACE actions before we add ours
		private _actionsBeforeCount = 0;
		private _existingActions = _equipment getVariable ["ace_interact_menu_Act_SelfActions", []];
		if (_existingActions isEqualType []) then {
			_actionsBeforeCount = count _existingActions;
		};
		diag_log format ["[AE3 DEBUG] [%1] ACE actions before adding equipment actions: %2", time, _actionsBeforeCount];

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

		// Use global helper to ensure parent action exists
		[_equipment, _name] call AE3_interaction_fnc_ensureEquipmentParent;

		// Add open/close action directly under Equipment action
		if (!((_openFnc isEqualTo {}) || (_closeFnc isEqualTo {}))) then
		{
			_open = ["AE3_openAction", localize "STR_AE3_Interaction_General_Open", "",
						{
							params ["_target", "_player", "_params"];

							[_target] spawn {
								params["_target"];
								[_target] call (_target getVariable "AE3_interaction_fnc_openWrapper");

								if (_target getVariable 'AE3_power_powerState' == 2) then
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

								if (_target getVariable 'AE3_power_powerState' == 1) then
								{
									[_target] call (_target getVariable "AE3_power_fnc_standbyWrapper");
								};
							};
						},
						{(_target call (_target getVariable ["AE3_interaction_fnc_closeActionCondition", {true}])) and (alive _target) and (_target getVariable "AE3_interaction_closeState" == 0) },
						{}] call ace_interact_menu_fnc_createAction;

			[_equipment, 0, ["ACE_MainActions", "AE3_EquipmentAction"], _open] call ace_interact_menu_fnc_addActionToObject;
			[_equipment, 0, ["ACE_MainActions", "AE3_EquipmentAction"], _close] call ace_interact_menu_fnc_addActionToObject;
			diag_log format ["[AE3 DEBUG] [%1] Added Open/Close actions for %2", time, _equipment];
		};

		// Count ACE actions after we added ours
		private _actionsAfterCount = 0;
		private _existingActionsAfter = _equipment getVariable ["ace_interact_menu_Act_SelfActions", []];
		if (_existingActionsAfter isEqualType []) then {
			_actionsAfterCount = count _existingActionsAfter;
		};
		diag_log format ["[AE3 DEBUG] [%1] ACE actions after adding equipment actions: %2 (added %3 actions)", time, _actionsAfterCount, _actionsAfterCount - _actionsBeforeCount];
	} else {
		diag_log format ["[AE3 DEBUG] [%1] Equipment actions already added for %2, skipping", time, _equipment];

		// Even though we're skipping, count the existing actions to see if there are duplicates
		private _actionsCount = 0;
		private _existingActions = _equipment getVariable ["ace_interact_menu_Act_SelfActions", []];
		if (_existingActions isEqualType []) then {
			_actionsCount = count _existingActions;
		};
		diag_log format ["[AE3 DEBUG] [%1] Current ACE actions on object: %2", time, _actionsCount];
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
