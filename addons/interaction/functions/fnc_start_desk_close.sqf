/**
 * Starts process of closing a desk
 *
 * Arguments:
 * 0: Desk <OBJECT>
 *
 * Return Value:
 * None
*/

params ['_desk'];

[
	15, // time in seconds
	_desk, // arguments for Finish + fail
	{ // on finish
		[_this] call AE3_interaction_fnc_desk_close;
	},
	{}, // on fail
	"Closing desk" // progress bar text, can be localized
	{true}, // condition code checked each frame to continue
	["isNotSwimming"] // conditions for checking interaction
] call ace_common_fnc_progressBar;