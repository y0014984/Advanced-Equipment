/**
 * Checks if the power capacity of the given entity is enough to supply
 * the connected entities.
 *
 * Arguments:
 * 0: Entity to check <OBJECT>
 *
 * Returns:
 * Check result <BOOL>
 */

params['_entity'];

private _pwrCap = _entity getVariable ['AE3_power_powerCapacity', 0];
private _pwrDraw = 0;
private _connected = _entity getVariable ['AE3_power_connectedDevices', []];
{
	_pwrDraw = _pwrDraw + (_x getVariable ['AE3_power_powerDraw', 0]);
} forEach _connected;

if (_pwrDraw > _pwrCap) then
{
	[_entity, [true]] spawn (_entity getVariable 'AE3_power_fnc_turnOffWrapper');

	_entity setVariable ['AE3_power_powerReq', 0, true];
}else
{
	_entity setVariable ['AE3_power_powerReq', _pwrDraw, true];
};

(_pwrDraw > _pwrCap);