/*
 * Author: Root, Wasserstoff, y0014984
 * Description: Executes the standby operation for a given computer object. Syncs terminal state, changes texture to standby screen, and plays standby sound.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to put into standby mode
 *
 * Return Value:
 * Success <BOOL>
 *
 * Example:
 * [_computer] call AE3_armaos_fnc_computer_standby;
 *
 * Public: Yes
 */

params ["_computer"];

[_computer] spawn 
{
	params ["_computer"];

	[_computer, "AE3_terminal"] call AE3_main_fnc_getRemoteVar;

	private _terminal = _computer getVariable "AE3_terminal";

	// if the laptop was turned on and immediately after that the standby mode war triggered, the
	// _terminal var doesn't seem to be set, so there's no need to sync that undefined var to server
	if (!isNil "_terminal") then
	{
		[_computer, [], "exit"] call AE3_armaos_fnc_os_exit;

		// Terminal state is persisted via AE3_terminal_sync (serializable types only)
		// NEVER broadcast AE3_terminal as it contains TEXT which causes serialization warnings
	};

	_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Standby.paa"];
	[_computer] call AE3_armaos_fnc_computer_playSoundStandby;

};

true;
