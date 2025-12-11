/*
 * Author: Root
 * Description: Calculates current solar panel power output based on sun position, panel orientation, and visibility. Uses solar zenith and azimuth angles, panel normal vectors, and line-of-sight checks to determine effective power. Output is scaled by panel orientation efficiency, sun intensity, and occlusion.
 *
 * Arguments:
 * 0: _solar <OBJECT> - Solar panel object
 *
 * Return Value:
 * [Power state (always true), Effective power output in kWh] <ARRAY>
 *
 * Example:
 * private _solarStatus = [_solarPanel] call AE3_power_fnc_solarCalculation;
 *
 * Public: Yes
 */

params['_solar'];

call AE3_power_fnc_getSolarPosition params ['_solZen', '_solAz'];
private _solVec = [cos _solZen * cos _solAz, cos _solZen * sin _solAz, sin _solZen];
private _solVecWorld = [cos _solZen * sin _solAz, cos _solZen * cos _solAz, sin _solZen]; // The coord system is inverted and rotated to the grid system

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
private _panelPos = getPosASL _solar vectorAdd [0, 0, (_solar getVariable ['AE3_power_height', 0])]; // elevate panel position because of wiered ground stuff
private _solPos = _panelPos vectorAdd (_solVecWorld vectorMultiply 100);
private _solVis = [objNull, "VIEW"] checkVisibility [_panelPos, _solPos];

private _effPower = sunOrMoon * _mult * _solVis * (_solar getVariable 'AE3_power_powerMax');

[true, _effPower];
