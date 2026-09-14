// File: fnc_shell_process.sqf
/*
 * Author: Root, Wasserstoff, y0014984
 * Description: Processes a command string entered by the user. Parses the command, resolves any command links, adds to history, and executes the appropriate command function.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _commandString <STRING> (Optional, default: "") - The command string to process
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, "ls -l /home"] call AE3_armaos_fnc_shell_process;
 *
 * Public: Yes
 */

params ["_computer", ["_commandString", ""]];

private _terminal = _computer getVariable "AE3_terminal";
// Quote-aware tokenizer: paths/arguments may contain spaces when quoted
private _commandElements = [_commandString] call AE3_armaos_fnc_shell_tokenize;

if (_commandElements isNotEqualTo []) then
{
	private _command = _commandElements select 0;
	private _options = _commandElements select [1, (count _commandElements) - 1];

	if(_command isNotEqualTo "") then
	{
		// SSH session: commands are executed against the remote computer
		private _sshTarget = _terminal getOrDefault ["AE3_sshTarget", objNull];
		private _sshActive = !isNull _sshTarget;
		private _execComputer = [_computer, _sshTarget] select _sshActive;
		private _rawCommand = _command;

		[_computer, _commandString] call AE3_armaos_fnc_terminal_addToHistory;
		_terminal set ["AE3_terminalCommandHistoryIndex", -1];

		// 'exit' ends the SSH session instead of logging out
		if (_sshActive && _rawCommand isEqualTo "exit") exitWith
		{
			[_computer, ""] call AE3_armaos_fnc_terminal_setInputMode;
			[_computer] call AE3_armaos_fnc_shell_sshEnd;
		};

		// The far end of a session can go away between one command and the next - shut down, destroyed,
		// packed up, or unplugged from its network - and a command sent after that would be run against a
		// machine that is no longer there to run it. The session is re-tested here and closed when it no
		// longer holds, before anything is executed against it.
		if (_sshActive && {!([_computer] call AE3_armaos_fnc_shell_sshAlive)}) exitWith
		{
			[_computer, "SHELL"] call AE3_armaos_fnc_terminal_setInputMode;
			[_computer] call AE3_armaos_fnc_terminal_updatePromptPointer;
			[_computer] call AE3_armaos_fnc_terminal_setPrompt;
			[_computer, _terminal get "AE3_terminalOutput"] call AE3_armaos_fnc_terminal_updateOutput;
		};

		// Interactive/graphical commands are blocked over SSH (sshCompatible = 0)
		if (_sshActive && {!([_rawCommand] call AE3_armaos_fnc_shell_isSshCompatible)}) exitWith
		{
			[_computer, format [localize "STR_AE3_ArmaOS_Ssh_CommandBlocked", _rawCommand]] call AE3_armaos_fnc_shell_stdout;
			[_computer] call AE3_armaos_fnc_shell_playErrorSound;
		};

		private _availableCommands = _execComputer getVariable ['AE3_Links', createHashMap];
		if(_command in _availableCommands) then
		{
			_command = (_availableCommands get _command) select 0;
		};

		[_computer, ""] call AE3_armaos_fnc_terminal_setInputMode;
		[_execComputer, _command, _options] call AE3_armaos_fnc_shell_executeFile;

		if (_rawCommand isEqualTo "shutdown") exitWith
		{
			// remote shutdown over ssh drops the session; local shutdown ends the terminal
			if (_sshActive) then { [_computer] call AE3_armaos_fnc_shell_sshEnd; };
		};

		// Blank line between command output and the next prompt (visual separation)
		[_computer, [[""]]] call AE3_armaos_fnc_terminal_addLines;
	};
};

_terminal set ["AE3_terminalScrollPosition", 0];

private _terminalApplication = _terminal get "AE3_terminalApplication";

if (_terminalApplication != "LOGIN") then
{
	[_computer, "SHELL"] call AE3_armaos_fnc_terminal_setInputMode;

	private _sshTarget = _terminal getOrDefault ["AE3_sshTarget", objNull];
	if (isNull _sshTarget) then
	{
		[_computer] call AE3_armaos_fnc_terminal_updatePromptPointer;
	}
	else
	{
		// Build the prompt from the remote computer and mirror it into the local terminal
		[_sshTarget] call AE3_armaos_fnc_terminal_updatePromptPointer;
		private _targetTerminal = _sshTarget getVariable ["AE3_terminal", createHashMap];
		_terminal set ["AE3_terminalPrompt", _targetTerminal getOrDefault ["AE3_terminalPrompt", "ssh>"]];
	};
};

[_computer] call AE3_armaos_fnc_terminal_setPrompt;

[_computer, _terminal get "AE3_terminalOutput"] call AE3_armaos_fnc_terminal_updateOutput;
