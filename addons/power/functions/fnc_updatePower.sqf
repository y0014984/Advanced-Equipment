/*
 * Author: Root, Wasserstoff
 * Description: Checks if the power capacity of a generator or battery is sufficient to supply all connected devices. Sums power draw from all connected devices and compares to power capacity. If insufficient, turns off the provider and resets power requirements.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Power provider to check
 *
 * Return Value:
 * True if power capacity exceeded (insufficient power), false otherwise <BOOL>
 *
 * Example:
 * private _insufficient = [_generator] call AE3_power_fnc_updatePower;
 * if ([_battery] call AE3_power_fnc_updatePower) then {hint "Battery overloaded!"};
 *
 * Public: Yes
 */

params['_entity'];

[_entity, "AE3_power_powerCapacity"] call AE3_main_fnc_getRemoteVar;

private _pwrCap = _entity getVariable ['AE3_power_powerCapacity', 0];
private _pwrDraw = 0;
private _connected = _entity getVariable ['AE3_power_connectedDevices', []];
{
	[_x, "AE3_power_powerDraw"] call AE3_main_fnc_getRemoteVar;
	_pwrDraw = _pwrDraw + (_x getVariable ['AE3_power_powerDraw', 0]);
} forEach _connected;

// Determine new power requirement value
private _newPowerReq = if (_pwrDraw > _pwrCap) then {
	[_entity, [true]] spawn (_entity getVariable 'AE3_power_fnc_turnOffWrapper');
	0
} else {
	_pwrDraw
};

// Only sync if power requirement changed (respects CBA settings)
private _enableSync = missionNamespace getVariable ["AE3_Power_EnableStateSync", true];
if (_enableSync) then
{
    private _oldPowerReq = _entity getVariable ["AE3_power_powerReq", -1];

    // Only sync if value changed
    if (_oldPowerReq != _newPowerReq) then
    {
        _entity setVariable ['AE3_power_powerReq', _newPowerReq, [clientOwner, 2]];
    } else {
        _entity setVariable ['AE3_power_powerReq', _newPowerReq];
    };
} else {
    _entity setVariable ['AE3_power_powerReq', _newPowerReq];
};

(_pwrDraw > _pwrCap);
