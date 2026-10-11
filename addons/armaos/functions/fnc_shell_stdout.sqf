// File: fnc_shell_stdout.sqf
/*
 * Author: Root, Wasserstoff
 * Description: Writes output to the terminal display. Accepts string or array of strings/formatted text. This is the standard output function for all commands.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _input <STRING or ARRAY> - The text to output
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, "Hello World"] call AE3_armaos_fnc_shell_stdout;
 *
 * Public: Yes
 */
params['_computer', '_input'];

// Output redirection ("cmd > file"): while a capture buffer is set on the executing computer, output
// is collected as plain text lines instead of being printed (shell_process writes it to the file).
private _capture = _computer getVariable "AE3_stdoutCapture";
if (!isNil "_capture") exitWith
{
	if !(_input isEqualType []) then { _input = [_input]; };
	{
		private _line = _x;
		if (_line isEqualType []) then
		{
			// Formatted line: [[text, color], ...] or [text, ...]
			_line = (_line apply { if (_x isEqualType []) then { _x param [0, ""] } else { _x } }) apply { [str _x, _x] select (_x isEqualType "") };
			_line = _line joinString "";
		};
		if !(_line isEqualType "") then { _line = str _line; };
		_capture pushBack (_line regexReplace ["<[^>]*>", ""]);
	} forEach _input;
};

// Optional output redirect (e.g. SSH sessions route remote command output into the local
// terminal). Additive and backward compatible: unset means normal local output.
private _redirect = _computer getVariable ["AE3_stdoutRedirect", objNull];
if (!isNull _redirect) then
{
	_computer = _redirect;
};

if (!(_input isEqualType [])) then
{
	_input = [_input];
};

private _terminal = _computer getVariable "AE3_terminal";

// No-op when the terminal is not initialized (e.g. a GUI/desktop-only or headless server laptop that
// never opened a CLI shell). Without this, backend code that emits status text - such as Root
// Cyberwarfare's power-cost output during a GUI door action - drives the render pipeline against a
// non-array buffer and throws "count <Number>" in terminal_updateBufferVisible.
if (isNil "_terminal" || {!(_terminal isEqualType createHashMap)}) exitWith {};
if !((_terminal getOrDefault ["AE3_terminalBuffer", 0]) isEqualType []) exitWith {};

[_computer, _input] call AE3_armaos_fnc_terminal_addLines;
[_computer, _terminal get "AE3_terminalOutput"] call AE3_armaos_fnc_terminal_updateOutput;
