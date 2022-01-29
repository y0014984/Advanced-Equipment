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
	_pwrDraw = _pwrCap + _x getVariable ['AE3_powerDraw'];
} forEach _connected;

_entity setVariable ['AE3_powerDraw', _pwrDraw];

if (_pwrDraw > _pwrCap) then
{
	{
		[_x] call AE3_fnc_power_turnOffDevice;
	}forEach _connected;
};

_pwrDraw > _pwrCap;