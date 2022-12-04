/**
 * Adds the "turn off" ACE interaction for a given computer object. Computer texture changes accordingly if silent mode is false.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Silent Switch <BOOL> (Optional)
 *
 * Results:
 * None
 */

params ["_computer", ["_silent", false]];

[_computer] spawn
{
	params["_computer"];

	private _powerState = _computer getVariable "AE3_power_powerState";

	private _turnOffTime = 0;
	private _elapsedTime = 0;
	private _color = "#(argb,8,8,3)color(0,0,0,0.0,co)";

	if (_powerState == 1) then
	{
		_turnOffTime = 15;
	}
	else
	{
		_turnOffTime = 10;
	};

	if (AE3_DebugMode) then { _turnOffTime = 3; };

	for "_i" from 3 to 0 step -1 do
	{
		_computer setObjectTextureGlobal [1, format ["\z\ae3\addons\armaos\textures\Laptop_4_to_3_Shutting_Down_%1.paa", _i]];

		sleep (_turnOffTime / 4.0);
		_elapsedTime = _elapsedTime + (_turnOffTime / 4.0);

	};

	_computer setObjectTextureGlobal [1, _color];

	private _handle = [_computer] spawn AE3_armaos_fnc_computer_playSoundStop;

	_computer setVariable ["AE3_terminal", nil, [clientOwner, 2]];
};

true;