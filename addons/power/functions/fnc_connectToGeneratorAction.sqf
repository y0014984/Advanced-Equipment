params ["_target", "_generator"];

//hint format ["Target: %1\nGenerator: %2", _target, _generator];

_target setVariable ["AE3_powerCableDevice", _generator, true];

[_target, false, [0, 1, 1], 0] call ace_dragging_fnc_setCarryable;

[_target, -1] call ace_cargo_fnc_setSize;

private _connectedDevices = _generator getVariable "AE3_connectedDevices";

if (isNil "_connectedDevices") then 
{
	_connectedDevices = [_target];
}
else 
{
	_connectedDevices pushBack _target;
};

_generator setVariable ["AE3_connectedDevices", _connectedDevices, true];