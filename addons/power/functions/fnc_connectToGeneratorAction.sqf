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


private _parent = _target getVariable "AE3_power_parent";
if (!isNil "_parent") then {_target = _parent};

[_target, "powerConnected", true] call AE3_interaction_fnc_manageAce3Interactions;