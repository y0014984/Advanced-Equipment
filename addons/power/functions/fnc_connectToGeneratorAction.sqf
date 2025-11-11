/*
 * Author: Root
 * Description: Internal action that establishes power connection from device to provider. Handles internal batteries, updates connected devices list, and manages ACE3 interactions for both consumer and provider. Called by ACE3 interaction menu.
 *
 * Arguments:
 * 0: _target <OBJECT> - Consumer device to connect
 * 1: _generator <OBJECT> - Power provider (generator, battery, solar panel)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, _generator] call AE3_power_fnc_connectToGeneratorAction;
 *
 * Public: No
 */

params ["_target", "_generator"];


if(!isNil {_generator getVariable "AE3_power_internal"}) then
{
	_generator = _generator getVariable "AE3_power_internal";
};

_target setVariable ["AE3_power_powerCableDevice", _generator, true];

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


_tmpTar = _target;
// if target has internal power parent, change interaction for that parent instead of target itself
private _powerParent = _tmpTar getVariable "AE3_power_parent";
if (!(isNil "_powerParent")) then { _tmpTar = _powerParent };
[_tmpTar, "powerConnected", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];

_tmpGen = _generator;
// if generator has internal power parent, change interaction for that parent instead of generator itself
private _powerParent = _tmpGen getVariable "AE3_power_parent";
if (!(isNil "_powerParent")) then { _tmpGen = _powerParent };
[_tmpGen, "powerConnected", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
