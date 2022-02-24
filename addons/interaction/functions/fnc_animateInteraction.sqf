/**
 * Creates event handler for the interaction animation.
 *
 * Argmuments:
 * 0: Equipment <OBJECT>
 * 1: Default Interaction Description <STRING>
 * 2: Default Animatable Aspect <STRING>
 * 3: ALT Interaction Description <STRING> (Optional)
 * 4: ALT Animatable Aspect <STRING> (Optional)
 * 5: CTRL Interaction Description <STRING> (Optional)
 * 6: CTRL Animatable Aspect <STRING> (Optional)
 *
 * Returns:
 * None
 *
 */

params ["_equipment", "_defaultInteractionDescription", "_defaultAction", ["_altInteractionDescription", nil], ["_altAction", nil], ["_ctrlInteractionDescription", nil], ["_ctrlAction", nil]];

private _modifier = [];

if (!isNil "_altInteractionDescription") then { _modifier pushBack ["alt", _altInteractionDescription] };
if (!isNil "_ctrlInteractionDescription") then { _modifier pushBack ["control", _ctrlInteractionDescription] };

["", "Exit interaction", _defaultInteractionDescription, _modifier] call ace_interaction_fnc_showMouseHint;

hint format ["1: %1\n2: %2\n3: %3\n4: %4\n5: %5\n6: %6\n7: %7\n", _equipment, _defaultInteractionDescription, _defaultAction, _altInteractionDescription, _altAction, _ctrlInteractionDescription, _ctrlAction];

private _display = findDisplay 46;

uiNamespace setVariable ["AE3_activeEquipment", _equipment];
uiNamespace setVariable ["AE3_defaultAction", _defaultAction];
uiNamespace setVariable ["AE3_altAction", _altAction];
uiNamespace setVariable ["AE3_ctrlAction", _ctrlAction];

/* ---------------------------------------- */

private _mouseZChangedEhType = "MouseZChanged";

private _mouseZChangedEhId = _display displayAddEventHandler
[
	_mouseZChangedEhType, 
	{
		params ["_displayOrControl", "_scroll"];

		hint format ["SCROLL VALUE: %1", _scroll];

		private _equipment = uiNamespace getVariable "AE3_activeEquipment";
		private _defaultAction = uiNamespace getVariable "AE3_defaultAction";
		private _altAction = uiNamespace getVariable "AE3_altAction";
		private _ctrlAction = uiNamespace getVariable "AE3_ctrlAction";


		private _ctrlKeyDown = uiNamespace getVariable ["AE3_ctrlKeyDown", false];
		private _altKeyDown = uiNamespace getVariable ["AE3_altKeyDown", false];

		if (_ctrlKeyDown || _altKeyDown) then
		{
			private _min = -90;
			private _max = 90;
			private _multiplier = 10;
			private _action = _ctrlAction;
			if (_altKeyDown) then { _action = _altAction };
			[_equipment, _action, _min, _max, _scroll, _multiplier] call AE3_interaction_fnc_animateAction;
		}
		else 
		{
			private _min = 0;
			private _max = 1;
			private _multiplier = 0.1;
			[_equipment, _defaultAction, _min, _max, _scroll, _multiplier] call AE3_interaction_fnc_animateAction;
		};
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

		hint format ["KEY DOWN: %1\nSHIFT: %2\nCRTL: %3\nALT: %4", _key, _shift, _ctrl, _alt];

		if (_ctrl == true) then { uiNamespace setVariable ["AE3_ctrlKeyDown", true]; };
		if (_alt == true) then { uiNamespace setVariable ["AE3_altKeyDown", true]; };
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

		hint format ["KEY UP: %1\nSHIFT: %2\nCRTL: %3\nALT: %4", _key, _shift, _ctrl, _alt];

		if (_alt == false) then { uiNamespace setVariable ["AE3_ctrlKeyDown", false]; };
		if (_ctrl == false) then { uiNamespace setVariable ["AE3_altKeyDown", false]; };
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
			uiNamespace setVariable ["AE3_defaultAction", nil];
			uiNamespace setVariable ["AE3_altAction", nil];
			uiNamespace setVariable ["AE3_ctrlAction", nil];
			uiNamespace setVariable ["AE3_ctrlKeyDown", nil];
			uiNamespace setVariable ["AE3_altKeyDown", nil];
		};
	}
];

uiNamespace setVariable [_mouseButtonDownEhType, _mouseButtonDownEhId];

/* ---------------------------------------- */