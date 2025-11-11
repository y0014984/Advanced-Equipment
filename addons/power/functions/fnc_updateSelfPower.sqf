/*
 * Author: Root
 * Description: Updates power draw for a consumer device and checks if connected generator can supply sufficient power. Returns failure status if device has no generator connection, generator is off, or insufficient power available.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Consumer device
 * 1: _power <NUMBER> - New power draw in kWh
 *
 * Return Value:
 * True if update failed (no power/insufficient power), false if successful <BOOL>
 *
 * Example:
 * if ([_laptop, 0.065] call AE3_power_fnc_updateSelfPower) then {hint "Cannot turn on - no power"};
 *
 * Public: No
 */

params['_entity', '_power'];

private _generator = _entity getVariable 'AE3_power_powerCableDevice';

if(isNil "_generator") exitWith {true};

if((_generator getVariable 'AE3_power_powerState') != 1) exitWith {true};

_entity setVariable ['AE3_power_powerDraw', _power, [clientOwner, 2]];

private _result = [_generator] call AE3_power_fnc_updatePower;

_result;
