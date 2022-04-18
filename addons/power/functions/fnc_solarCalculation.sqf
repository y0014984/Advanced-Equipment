/**
 * Calculates the current solar panel output.
 *
 * Arguments:
 * 0: Solarpanel <OBJECT>
 *
 * Returns:
 * 0: Powerstate <BOOL>
 * 1: Poweroutput <FLOAT>
 */

params['_solar'];

call AE3_power_fnc_getSolarPosition params ['_solZen', '_solAz'];
private _solVec = [cos _solZen * cos _solAz, cos _solZen * sin _solAz, sin _solZen];

private _normalList = [_solar] call (_solar getVariable "AE3_power_orientationFnc");
private _mult = 0;

{
	_buffer = _x vectorCos _solVec;
	if (_buffer > 0) then 
	{
		_mult = _mult + _buffer;
	};
}forEach _normalList;

// If sun is visible
private _solPos = getPosASL _solar vectorAdd (_solVec vectorMultiply 10);
private _panelPos = getPosASL _solar vectorAdd [0, 0, (_solar getVariable ['AE3_power_height', 0])]; // elevate panel position because of wiered ground stuff
private _solVis = [objNull, "VIEW"] checkVisibility [_panelPos, _solPos];

private _effPower = sunOrMoon * _mult * _solVis * (_solar getVariable 'AE3_power_powerMax');

[true, _effPower];