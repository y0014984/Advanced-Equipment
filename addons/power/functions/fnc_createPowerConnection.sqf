/**
 * PUBLIC
 *
 * This function creates a power connection from the _from object to the _to object.
 *
 * Arguments:
 * 1: From <OBJECT>
 * 2: To <OBJECT>
 *
 * Results:
 * None
 *
 * Examples:
 * [_laptop, _generator] call AE3_power_fnc_createPowerConnection;
 * [_battery, _generator] call AE3_power_fnc_createPowerConnection;
 *
 */

params ["_from", "_to"];

[_from, _to] spawn
{
    params ["_from", "_to"];

    // wait until both devices have relevant variables set; this indicates that the init process is done
    waitUntil { !(isNil { _from getVariable "AE3_power_hasInternal"; }) && !(isNil { _to getVariable "AE3_power_connectedDevices"; }) };

    private _hasInternal = _from getVariable "AE3_power_hasInternal";

    private _device = objNull;

    if (_hasInternal) then { _device = _from getVariable "AE3_power_internal"; } else { _device = _from; };

    [_device, _to] call AE3_power_fnc_connectToGeneratorAction;
};