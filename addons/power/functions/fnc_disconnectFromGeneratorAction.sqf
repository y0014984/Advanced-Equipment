/**
 * Disconnects a device from a power source.
 *
 * Arguments:
 * 0: Device <OBJECT>
 * 
 * Returns:
 * None
 */

params ["_target"];

_generator = _target getVariable "AE3_power_powerCableDevice";

if (!isNil "_generator") then
{
	_connectedDevices = _generator getVariable "AE3_power_connectedDevices";

	_index = _connectedDevices findIf {_x isEqualTo _target};

	_connectedDevices deleteAt _index;

	_generator setVariable ["AE3_power_connectedDevices", _connectedDevices, true];
};

_target setVariable ["AE3_power_powerCableDevice", nil, true];

[_target, true, [0, 1, 1], 0] call ace_dragging_fnc_setCarryable;

[_target, 1] call ace_cargo_fnc_setSize;

if(!isNil {_target getVariable 'AE3_power_powerConsumption'}) then
{
	[_target] call (_target getVariable 'AE3_power_fnc_turnOffWrapper')
};

[_generator] call AE3_power_fnc_updatePower;

// Enable ACE3 Carry, Drag and Cargo when disconnected from a Generator
private _settingsAce3 = _target getVariable "AE3_SettingsACE3";
if (!isNil "_settingsAce3") then
{
	if (_settingsAce3 get "ae3_dragging_canDrag") then
	{
		private _canDrag = _settingsAce3 get "ae3_dragging_canDrag";
		private _dragPosition = _settingsAce3 get "ae3_dragging_dragPosition";
		private _dragDirection = _settingsAce3 get "ae3_dragging_dragDirection";
		[_target, _canDrag, _dragPosition, _dragDirection] remoteExecCall ['ace_dragging_fnc_setDraggable', 0, true];
		_settingsAce3 set ["ae3_dragging_dragIsActive", true];
	};
	if (_settingsAce3 get "ae3_dragging_canCarry") then
	{
		private _canCarry = _settingsAce3 get "ae3_dragging_canCarry";
		private _carryPosition = _settingsAce3 get "ae3_dragging_carryPosition";
		private _carryDirection = _settingsAce3 get "ae3_dragging_carryDirection";
		[_target, _canCarry, _carryPosition, _carryDirection] remoteExecCall ['ace_dragging_fnc_setCarryable', 0, true];
		_settingsAce3 set ["ae3_dragging_carryIsActive", true];
	};
};
