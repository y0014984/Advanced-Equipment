/*
 * Author: Root
 * Description: Removes the power connection from a consumer device to its power provider. Updates ACE3 interactions, removes the device from the provider's connected devices list, turns off the consumer if it was running, and updates the provider's power state.
 *
 * Arguments:
 * 0: _powerConsumer <OBJECT> - Consumer device to disconnect
 *
 * Return Value:
 * Success status <BOOL>
 *
 * Example:
 * [_laptop] call AE3_power_fnc_removePowerConnection;
 * [_battery] call AE3_power_fnc_removePowerConnection;
 *
 * Public: Yes
 */

params ["_powerConsumer"];

private _powerProvider = _powerConsumer getVariable ["AE3_power_powerCableDevice", objNull];

if (!(isNull _powerProvider)) then
{
    // remove power consumer from power providers list of connected devices
	private _connectedDevices = _powerProvider getVariable ["AE3_power_connectedDevices", []];
    _connectedDevices = _connectedDevices - [_powerConsumer];
    _powerProvider setVariable ["AE3_power_connectedDevices", _connectedDevices, true];

	if (count _connectedDevices == 0) then
	{
        // if power provider has internal power parent, change interaction for that parent instead
        _tmpPowerProvider = _powerProvider;
        private _powerParent = _tmpPowerProvider getVariable ["AE3_power_parent", objNull];
        if (!(isNull _powerParent)) then { _tmpPowerProvider = _powerParent; };
            
        // if power provider is not connected to another power provider (in case of battery pack)
        private _parentPowerProvider = _tmpPowerProvider getVariable ["AE3_power_powerCableDevice", objNull];
        if (isNull _parentPowerProvider) then { [_tmpPowerProvider, "powerConnected", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2]; };
    };

    _powerProvider setVariable ["AE3_power_connectedDevices", _connectedDevices, true];

    [_powerProvider] call AE3_power_fnc_updatePower;
};

// remove power connection from power consumer
_powerConsumer setVariable ["AE3_power_powerCableDevice", nil, true];

// if power consumer has internal power parent, change interaction for that parent instead
private _tmpPowerConsumer = _powerConsumer;
private _powerParent = _tmpPowerConsumer getVariable ["AE3_power_parent", objNull];
if (!(isNull _powerParent)) then { _tmpPowerConsumer = _powerParent; };
[_tmpPowerConsumer, "powerConnected", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];

// turn off power consumer if it was turned on
if(!(isNil {_powerConsumer getVariable ["AE3_power_powerConsumption", nil]})) then
{
    [_powerConsumer] call (_powerConsumer getVariable "AE3_power_fnc_turnOffWrapper");
};

true;
