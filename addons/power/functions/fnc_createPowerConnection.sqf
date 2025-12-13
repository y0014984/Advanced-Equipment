/*
 * Author: Root, y0014984
 * Description: Creates a power connection from a consumer device to a power provider (generator or battery). Waits for both devices to complete initialization before establishing the connection. Handles internal batteries automatically.
 *
 * Arguments:
 * 0: _from <OBJECT> - Consumer device (laptop, battery, etc.)
 * 1: _to <OBJECT> - Power provider (generator, solar panel, battery)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, _generator] call AE3_power_fnc_createPowerConnection;
 * [_battery, _solarPanel] call AE3_power_fnc_createPowerConnection;
 *
 * Public: Yes
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
