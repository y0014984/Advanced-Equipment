/**
 * Connect device to power provider (Generator, Battery).
 *
 * Arguments:
 * 0: Device <OBJECT>
 * 0: Provider <OBJECT>
 * 
 * Returns:
 * None
 */

params ["_target", "_generator"];


if(!isNil {_generator getVariable "AE3_power_internal"}) then
{
	_generator = _generator getVariable "AE3_power_internal";
};

_target setVariable ["AE3_power_powerCableDevice", _generator, true];

[_target, -1] call ace_cargo_fnc_setSize;

private _connectedDevices = _generator getVariable "AE3_power_connectedDevices";

if (isNil "_connectedDevices") then 
{
	_connectedDevices = [_target];
}
else 
{
	_connectedDevices pushBack _target;
};

_generator setVariable ["AE3_power_connectedDevices", _connectedDevices, true];

// Disable ACE3 Carry, Drag and Cargo when connected to a Generator
private _settingsAce3 = _target getVariable "AE3_SettingsACE3";
if (!isNil "_settingsAce3") then
{
	if (_settingsAce3 get "ae3_dragging_canDrag") then
	{
		[_target, false] remoteExecCall ["ace_dragging_fnc_setDraggable", 0, true];
		_settingsAce3 set ["ae3_dragging_dragIsActive", false];
	};
	if (_settingsAce3 get "ae3_dragging_canCarry") then
	{
		[_target, false] remoteExecCall ["ace_dragging_fnc_setCarryable", 0, true];
		_settingsAce3 set ["ae3_dragging_carryIsActive", false];
	};

	_target setVariable ["AE3_SettingsACE3", _settingsAce3, true];
};