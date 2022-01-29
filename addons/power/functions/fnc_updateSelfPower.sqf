/**
 * Updates the power draw of the given device.
 *
 * Arguments:
 * 0: Device <OBJECT>
 *
 * Returns:
 * None
 *
 */

params['_entity', '_power'];


_entity setVariable ['AE3_powerDraw', _power, true];

private _generator = _entity getVariable 'AE3_powerCableDevice';
private _null = [_generator] call AE3_power_fnc_updatePower;