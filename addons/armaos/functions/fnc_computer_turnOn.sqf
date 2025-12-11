/*
 * Author: Root, Wasserstoff, y0014984
 * Description: Executes the turn on operation for a given computer object. Computer texture changes to show booting animation and plays startup sound.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to turn on
 *
 * Return Value:
 * Success <BOOL>
 *
 * Example:
 * [_computer] call AE3_armaos_fnc_computer_turnOn;
 *
 * Public: Yes
 */

params ["_computer"];

private _powerState = _computer getVariable 'AE3_power_powerState';

private _turnOnTime = 0;
private _elapsedTime = 0;

if (_powerState == 0) then
{
	// Cold boot - use CBA setting
	_turnOnTime = AE3_StartupTime;
}
else
{
	// Warm boot from standby - always 3 seconds
	_turnOnTime = 3;
};

if (AE3_DebugMode) then { _turnOnTime = 3; };

for "_i" from 0 to 3 do
{
	_computer setObjectTextureGlobal [1, format ["\z\ae3\addons\armaos\textures\Laptop_4_to_3_Booting_%1.paa", _i]];

	sleep (_turnOnTime / 4.0);
	_elapsedTime = _elapsedTime + (_turnOnTime / 4.0);

};

_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_On.paa"];

[_computer] call AE3_armaos_fnc_computer_playSoundStart;


true;
