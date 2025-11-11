/*
 * Author: Root
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

if (_pwrDraw > _pwrCap) then
{
	[_entity, [true]] spawn (_entity getVariable 'AE3_power_fnc_turnOffWrapper');

	_entity setVariable ['AE3_power_powerReq', 0, [clientOwner, 2]];
}else
{
	_entity setVariable ['AE3_power_powerReq', _pwrDraw, [clientOwner, 2]];
};

(_pwrDraw > _pwrCap);
