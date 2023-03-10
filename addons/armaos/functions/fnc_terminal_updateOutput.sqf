/**
 * Updates/sets the text for the terminal text field, stored in the visable buffer setting in terminal settings of a given computer.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: UI Text Field <CONTROL>
 *
 * Results:
 * None
 */

 params ["_computer", "_outputControl"];

[_computer] call AE3_armaos_fnc_terminal_updateBufferVisable;

private _terminal = _computer getVariable "AE3_terminal";

private _terminalBuffer = _terminal get "AE3_terminalBuffer";
private _terminalBufferVisable = _terminal get "AE3_terminalBufferVisable";
private _size = _terminal get "AE3_terminalSize";

private _output = [];
{
	_buffer = composeText [_x, lineBreak];
	_buffer setAttributes ["size", str _size, "font", "EtelkaMonospacePro"];
	_output pushBack _buffer;
} forEach _terminalBufferVisable;

_outputControl ctrlSetStructuredText (composeText _output);
ctrlSetFocus _outputControl;

_computer setVariable ["AE3_terminal", _terminal];

/* ------------- UI on Texture ------------ */

private _playersInRange = [3, _computer] call AE3_main_fnc_getPlayersInRange;

{
	[_computer, _output] remoteExec ["AE3_armaos_fnc_terminal_uiOnTex_updateOutput", _x];
} forEach _playersInRange;

/* ---------------------------------------- */