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

private _pwrCap = _entity getVariable ['AE3_powerCapacity', 0];
private _pwrDraw = 0;
private _connected = _entity getVariable ['AE3_connectedDevices', []];
{
	_pwrDraw = _pwrDraw + (_x getVariable ['AE3_powerDraw', 0]);
} forEach _connected;

if (_pwrDraw > _pwrCap) then
{
	[_entity, [true]] spawn (_entity getVariable 'AE3_power_fnc_turnOffWrapper');

	_entity setVariable ['AE3_powerReq', 0];
}else
{
	_entity setVariable ['AE3_powerReq', _pwrDraw];
};

(_pwrDraw > _pwrCap);