/**
 * Updates the power draw of the given device.
 *
 * Arguments:
 * 0: Device <OBJECT>
 *
 * Returns:
 * If successfull <BOOL>
 *
 */

params['_entity', '_power'];

private _generator = _entity getVariable 'AE3_powerCableDevice';

if(isNil "_generator") exitWith {true};

_entity setVariable ['AE3_powerDraw', _power, true];

private _result = [_generator] call AE3_power_fnc_updatePower;

_result;