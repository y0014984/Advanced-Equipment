/**
 * Updates/sets the text for the terminal text field, stored in the visible buffer setting in terminal settings of a given computer.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: UI Text Field <CONTROL>
 *
 * Results:
 * None
 */

 params ["_computer", "_outputControl"];

[_computer] call AE3_armaos_fnc_terminal_updateBufferVisible;

private _terminal = _computer getVariable "AE3_terminal";

private _terminalBuffer = _terminal get "AE3_terminalBuffer";
private _terminalBufferVisible = _terminal get "AE3_terminalBufferVisible";
private _size = _terminal get "AE3_terminalSize";

private _output = [];
{
	private _buffer = composeText [_x, lineBreak];
	_buffer setAttributes ["size", str _size, "font", "EtelkaMonospacePro"];
	_output pushBack _buffer;
} forEach _terminalBufferVisible;

_outputControl ctrlSetStructuredText (composeText _output);
ctrlSetFocus _outputControl;

_computer setVariable ["AE3_terminal", _terminal];

/* ------------- UI on Texture ------------ */

if (AE3_UiOnTexture) then
{
	private _playersInRange = [3, _computer] call AE3_main_fnc_getPlayersInRange;

	// Send raw text array instead of composed text to avoid serialization warnings
	[_computer, _terminalBufferVisible, _size] remoteExec ["AE3_armaos_fnc_terminal_uiOnTex_updateOutput", _playersInRange];
};

/* ---------------------------------------- */
