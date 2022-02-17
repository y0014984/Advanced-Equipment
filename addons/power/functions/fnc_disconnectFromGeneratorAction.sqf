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