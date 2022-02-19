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

private _availableCommands = [] call AE3_armaos_fnc_shell_getAvailableCommands;

_result = [];

switch (_command) do
{
	case "help": { _result = [format ["   Available commands: %1", _availableCommands joinString ", "]]; };
	case "man": { _result = [_computer, _options] call AE3_armaos_fnc_os_man; };
	case "ls": { _result = [_computer, _options] call AE3_armaos_fnc_os_ls; };
	case "cd": { _result = [_computer, _options] call AE3_armaos_fnc_os_cd; };
	case "print": { _result = [_computer, _options] call AE3_armaos_fnc_os_print; };
	case "date": { _result = [_computer, _options] call AE3_armaos_fnc_os_date; };
	case "ipconfig": { _result = [_computer, _options] call AE3_armaos_fnc_os_ipconfig; };
	case "shutdown": { _result = [_computer, _options] call AE3_armaos_fnc_os_shutdown; };
	case "standby": { _result = [_computer, _options] call AE3_armaos_fnc_os_standby; };
	case "history": { _result = [_computer, _options] call AE3_armaos_fnc_os_history; };
	case "logout": { _result = [_computer, _options] call AE3_armaos_fnc_os_logout; };
	case "ping": { _result = [_computer, _options] call AE3_armaos_fnc_os_ping; };
	case "clear": { _result = [_computer, _options] call AE3_armaos_fnc_os_clear; };
	case "rm": { _result = [_computer, _options] call AE3_armaos_fnc_os_rm; };
	case "mv": { _result = [_computer, _options] call AE3_armaos_fnc_os_mv; };
	case "chat": { _result = [_computer, _options] call AE3_armaos_fnc_os_chat; };
	default { _result = [_computer, _command, _options] call AE3_armaos_fnc_shell_executeFile; };
};

if (_command == "shutdown") exitWith {};

private _terminal = _computer getVariable "AE3_terminal";

[_computer, _commandString] call AE3_armaos_fnc_terminal_addToHistory;
_terminal set ["AE3_terminalCommandHistoryIndex", -1];

_terminal set ["AE3_terminalScrollPosition", 0];

_result = _result + [""];

[_computer, _result] call AE3_armaos_fnc_terminal_addLines;

private _terminalApplication = _terminal get "AE3_terminalApplication";

if (_terminalApplication == "SHELL") then 
{
	[_computer] call AE3_armaos_fnc_terminal_updatePromptPointer;
};

[_computer] call AE3_armaos_fnc_terminal_setPrompt;