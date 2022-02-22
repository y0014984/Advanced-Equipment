/**
 * Processes the given command for a given computer. Calls the according functions and updates the terminal output.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Command <STRING>
 *
 * Results:
 * None
 */

params ["_computer", "_commandString"];

private _commandElements = _commandString splitString " ";
private _command = _commandElements select 0;
private _options = _commandElements select [1, (count _commandElements) - 1];
private _terminal = _computer getVariable "AE3_terminal";

_result = [];

if(!(_command isEqualTo "")) then 
{
	_availableCommands = _computer getVariable ['AE3_Links', createHashMap];
	_pointer = _computer getVariable ['AE3_filepointer', []];
	if(_command in _availableCommands) then
	{
		_command = (_availableCommands get _command) select 0;
		_pointer = [];
	};

	_result = [_computer, _command, _options] call AE3_armaos_fnc_shell_executeFile;

	if (_command == "shutdown") exitWith {};

	[_computer, _commandString] call AE3_armaos_fnc_terminal_addToHistory;
	_terminal set ["AE3_terminalCommandHistoryIndex", -1];
};

_terminal set ["AE3_terminalScrollPosition", 0];

_result = _result + [""];

[_computer, _result] call AE3_armaos_fnc_terminal_addLines;

private _terminalApplication = _terminal get "AE3_terminalApplication";

if (_terminalApplication == "SHELL") then 
{
	[_computer] call AE3_armaos_fnc_terminal_updatePromptPointer;
};

[_computer] call AE3_armaos_fnc_terminal_setPrompt;