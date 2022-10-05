/**
 * Adds the "turn on" ACE interaction for a given computer object. Computer texture changes accordingly.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 *
 * Results:
 * None
 */

params ["_computer"];

private _powerState = _computer getVariable 'AE3_power_powerState';

private _turnOnTime = 0;
private _elapsedTime = 0;

if (_powerState == 0) then
{
	_turnOnTime = 3; 
}
else
{
	_turnOnTime = 3;
};


for "_i" from 0 to 3 do
{
	_computer setObjectTextureGlobal [1, format ["\z\ae3\addons\armaos\textures\Laptop_4_to_3_Booting_%1.paa", _i]];

	sleep (_turnOnTime / 4.0);
	_elapsedTime = _elapsedTime + (_turnOnTime / 4.0);

};

_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_On.paa"];

[_computer] call AE3_armaos_fnc_computer_playSoundStart;


true;