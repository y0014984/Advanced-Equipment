/**
 * Adds the "standby" ACE interaction for a given computer object. Computer texture changes accordingly.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 *
 * Results:
 * None
 */

params ["_computer"];

[_computer] spawn 
{
	params ["_computer"];

	[_computer, "AE3_terminal"] call AE3_main_fnc_getRemoteVar;

	private _terminal = _computer getVariable "AE3_terminal";

	// if the laptop was turned on and immediately after that the standby mode war triggered, the 
	// _terminal var dosn't seem to be set, so there's no need to sync that undefined var to server
	if (!isNil "_terminal") then 
	{
		[_computer, [], "exit"] call AE3_armaos_fnc_os_exit;

		private _terminal = _computer getVariable "AE3_terminal";

		_computer setVariable ["AE3_terminal", _terminal, 2]; 
	};

	_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Standby.paa"];
	[_computer] call AE3_armaos_fnc_computer_playSoundStandby;

};

true;