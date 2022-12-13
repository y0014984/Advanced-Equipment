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

	
	if (count _connectedDevices == 0) then
	{
		_tmpGen = _generator;
		// if generator has internal power parent, change interaction for that parent instead of generator itself
		private _powerParent = _tmpGen getVariable "AE3_power_parent";
		if (!(isNil "_powerParent")) then { _tmpGen = _powerParent };
			
		// if generator is not connected to another generator (in case of battery pack)
		private _parentGenerator = _tmpGen getVariable "AE3_power_powerCableDevice";
		if (isNil "_parentGenerator") then { [_tmpGen, "powerConnected", false] call AE3_interaction_fnc_manageAce3Interactions; };
	};

	_generator setVariable ["AE3_power_connectedDevices", _connectedDevices, true];
};

_target setVariable ["AE3_power_powerCableDevice", nil, true];

_tmpTar = _target;
// if target has internal power parent, change interaction for that parent instead of target itself
private _powerParent = _tmpTar getVariable "AE3_power_parent";
if (!(isNil "_powerParent")) then { _tmpTar = _powerParent };
[_tmpTar, "powerConnected", false] call AE3_interaction_fnc_manageAce3Interactions;

if(!isNil {_target getVariable 'AE3_power_powerConsumption'}) then
{
	[_target] call (_target getVariable 'AE3_power_fnc_turnOffWrapper')
};

[_generator] call AE3_power_fnc_updatePower;
