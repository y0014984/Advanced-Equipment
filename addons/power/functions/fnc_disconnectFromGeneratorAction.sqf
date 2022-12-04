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

	// if power source has no connected devices and it's battery is not connected to another power source (stand alone battery)
	if (count _connectedDevices == 0) then
	{
		private _parent = _generator getVariable "AE3_power_parent";
		if (!isNil "_parent") then {_target = _parent};
		[_generator, "powerConnected", false] call AE3_interaction_fnc_manageAce3Interactions;
	};

	_generator setVariable ["AE3_power_connectedDevices", _connectedDevices, true];
};

_target setVariable ["AE3_power_powerCableDevice", nil, true];

if(!isNil {_target getVariable 'AE3_power_powerConsumption'}) then
{
	[_target] call (_target getVariable 'AE3_power_fnc_turnOffWrapper')
};

[_generator] call AE3_power_fnc_updatePower;

[_target, "powerConnected", false] call AE3_interaction_fnc_manageAce3Interactions;
