// File: fnc_shell_executeFile.sqf
/*
 * Author: Root, y0014984, Wasserstoff
 * Description: Executes a file from the filesystem. If the file contains executable code, spawns it as a process and waits for completion.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _path <STRING> - Path to the file to execute
 * 2: _options <ARRAY> - Command options and arguments
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, "/bin/ls", ["-l"]] call AE3_armaos_fnc_shell_executeFile;
 *
 * Public: Yes
 */

params["_computer", "_path", "_options"];

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _terminal = _computer getVariable "AE3_terminal";
// Superusers act as root over the filesystem here, exactly as they do in the desktop file manager.
private _username = [_computer] call AE3_armaos_fnc_shell_getFsUser;

try
{
	private _content = [_pointer, _filesystem, _path, _username, 2] call AE3_filesystem_fnc_getFile;

	if(_content isEqualType {}) then
	{
		private _commandName = _path splitString "/" select -1;
		private _handler = [_computer, _options, _commandName] spawn _content;
		_terminal set ["AE3_terminalProcess", _handler];
		_computer setVariable ["AE3_terminal", _terminal];

		// Wait until programm is finished
		waitUntil {
			isNull _handler;
		};
	}
	else
	{
		[_computer, [format [localize "STR_AE3_ArmaOS_Exception_CommandNotFound", _path]]] call AE3_armaos_fnc_shell_stdout;
		[_computer] call AE3_armaos_fnc_shell_playErrorSound;
	};

}catch{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};


