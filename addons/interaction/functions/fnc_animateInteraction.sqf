/**
 * Creates event handler for the interaction animation.
 *
 * Argmuments:
 * 0: Equipment <OBJECT>
 * 1: Main Animation <ARRAY>
 * 2: Shift Animation <ARRAY>
 * 3: Ctrl Animation <ARRAY>
 * 4: Ctrl Animation <ARRAY>
 *
 * Returns:
 * None
 *
 */

params ["_equipment", "_animationMain", "_animationModifiedShift", "_animationModifiedCtrl", "_animationModifiedAlt"];

private _modifier = [];

if (!(_animationModifiedShift isEqualTo [])) then { _modifier pushBack ["shift", _animationModifiedShift select 0] };
if (!(_animationModifiedCtrl isEqualTo [])) then { _modifier pushBack ["control", _animationModifiedCtrl select 0] };
if (!(_animationModifiedAlt isEqualTo [])) then { _modifier pushBack ["alt", _animationModifiedAlt select 0] };

["", localize "STR_AE3_Interaction_General_Exit", _animationMain select 0, _modifier] call ace_interaction_fnc_showMouseHint;

private _display = findDisplay 46;

uiNamespace setVariable ["AE3_activeEquipment", _equipment];
uiNamespace setVariable ["AE3_animationMain", _animationMain];
uiNamespace setVariable ["AE3_animationModifiedShift", _animationModifiedShift];
uiNamespace setVariable ["AE3_animationModifiedCtrl", _animationModifiedCtrl];
uiNamespace setVariable ["AE3_animationModifiedAlt", _animationModifiedAlt];

/* ---------------------------------------- */

private _mouseZChangedEhType = "MouseZChanged";

private _mouseZChangedEhId = _display displayAddEventHandler
[
	_mouseZChangedEhType, 
	{
		params ["_displayOrControl", "_scroll"];

		private _equipment = uiNamespace getVariable "AE3_activeEquipment";
		private _animationMain = uiNamespace getVariable "AE3_animationMain";
		private _animationModifiedShift = uiNamespace getVariable "AE3_animationModifiedShift";
		private _animationModifiedCtrl = uiNamespace getVariable "AE3_animationModifiedCtrl";
		private _animationModifiedAlt = uiNamespace getVariable "AE3_animationModifiedAlt";

		private _shiftKeyDown = uiNamespace getVariable ["AE3_shiftKeyDown", false];
		private _ctrlKeyDown = uiNamespace getVariable ["AE3_ctrlKeyDown", false];
		private _altKeyDown = uiNamespace getVariable ["AE3_altKeyDown", false];

		if ( (_shiftKeyDown == false) && (_ctrlKeyDown == false) && (_altKeyDown == false) ) then
		{
			[
				_equipment,
				_animationMain select 1,
				_animationMain select 2,
				_animationMain select 3,
				_scroll,
				_animationMain select 4
			] call AE3_interaction_fnc_animateAction;			
		};

		if ( (_shiftKeyDown == true) && (_ctrlKeyDown == false) && (_altKeyDown == false) && (!(_animationModifiedShift isEqualTo [])) ) then
		{
			[
				_equipment,
				_animationModifiedShift select 1,
				_animationModifiedShift select 2,
				_animationModifiedShift select 3,
				_scroll,
				_animationModifiedShift select 4
			] call AE3_interaction_fnc_animateAction;			
		};

		if ( (_shiftKeyDown == false) && (_ctrlKeyDown == true) && (_altKeyDown == false) && (!(_animationModifiedCtrl isEqualTo [])) ) then
		{
			[
				_equipment,
				_animationModifiedCtrl select 1,
				_animationModifiedCtrl select 2,
				_animationModifiedCtrl select 3,
				_scroll,
				_animationModifiedCtrl select 4
			] call AE3_interaction_fnc_animateAction;			
		};

		if ( (_shiftKeyDown == false) && (_ctrlKeyDown == false) && (_altKeyDown == true) && (!(_animationModifiedAlt isEqualTo [])) ) then
		{
			
			[
				_equipment,
				_animationModifiedAlt select 1,
				_animationModifiedAlt select 2,
				_animationModifiedAlt select 3,
				_scroll,
				_animationModifiedAlt select 4
			] call AE3_interaction_fnc_animateAction;			
		};

		true
	}
];

uiNamespace setVariable [_mouseZChangedEhType, _mouseZChangedEhId];

/* ---------------------------------------- */

private _keyDownEhType = "KeyDown";

private _keyDownEhId = _display displayAddEventHandler
[
	_keyDownEhType, 
	{
		params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];

		uiNamespace setVariable ["AE3_shiftKeyDown", _shift];
		uiNamespace setVariable ["AE3_ctrlKeyDown", _ctrl];
		uiNamespace setVariable ["AE3_altKeyDown", _alt];

		true
	}
];

uiNamespace setVariable [_keyDownEhType, _keyDownEhId];

/* ---------------------------------------- */

private _keyUpEhType = "KeyUp";

private _keyUpEhId = _display displayAddEventHandler
[
	_keyUpEhType, 
	{
		params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];

		uiNamespace setVariable ["AE3_shiftKeyDown", _shift];
		uiNamespace setVariable ["AE3_ctrlKeyDown", _ctrl];
		uiNamespace setVariable ["AE3_altKeyDown", _alt];

		true
	}
];

uiNamespace setVariable [_keyUpEhType, _keyUpEhId];

/* ---------------------------------------- */

private _mouseButtonDownEhType = "MouseButtonDown";

private _mouseButtonDownEhId = _display displayAddEventHandler
[
	_mouseButtonDownEhType, 
	{
		params ["_displayOrControl", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

		private _rightMouseButton = 1;

		if (_button == _rightMouseButton) then
		{
			[] call ace_interaction_fnc_hideMouseHint;

			private _mouseZChangedEhType = "MouseZChanged";
			private _mouseButtonDownEhType = "MouseButtonDown";
			private _keyDownEhType = "KeyDown";
			private _keyUpEhType = "KeyUp";

			private _mouseZChangedEhId = uiNamespace getVariable _mouseZChangedEhType;
			private _mouseButtonDownEhId = uiNamespace getVariable _mouseButtonDownEhType;
			private _keyDownEhId = uiNamespace getVariable _keyDownEhType;
			private _keyUpEhId = uiNamespace getVariable _keyUpEhType;

			private _display = findDisplay 46;

			_display displayRemoveEventHandler [_mouseZChangedEhType, _mouseZChangedEhId];
			_display displayRemoveEventHandler [_mouseButtonDownEhType, _mouseButtonDownEhId];
			_display displayRemoveEventHandler [_keyDownEhType, _keyDownEhId];
			_display displayRemoveEventHandler [_keyUpEhType, _keyUpEhId];

			uiNamespace setVariable ["AE3_activeEquipment", nil];
			uiNamespace setVariable ["AE3_animationMain", nil];
			uiNamespace setVariable ["AE3_animationModifiedShift", nil];
			uiNamespace setVariable ["AE3_animationModifiedCtrl", nil];
			uiNamespace setVariable ["AE3_animationModifiedAlt", nil];
			uiNamespace setVariable ["AE3_shiftKeyDown", nil];
			uiNamespace setVariable ["AE3_ctrlKeyDown", nil];
			uiNamespace setVariable ["AE3_altKeyDown", nil];
		};

		true
	}
];

uiNamespace setVariable [_mouseButtonDownEhType, _mouseButtonDownEhId];

/* ---------------------------------------- */