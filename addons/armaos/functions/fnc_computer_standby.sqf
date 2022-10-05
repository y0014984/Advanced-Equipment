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

[_computer] spawn {
	params ["_computer"];

	sleep 3;
	_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Standby.paa"];

	[_computer] call AE3_armaos_fnc_computer_playSoundStandby;
};
closeDialog 2;
true;