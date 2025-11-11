/*
 * Author: Root
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
private _username = _terminal get "AE3_terminalLoginUser";

private _result = [format [localize "STR_AE3_ArmaOS_Exception_CommandNotFound", _path]];
try 
{
	private _content = [_pointer, _filesystem, _path, _username, 0] call AE3_filesystem_fnc_getFile;

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
	};

}catch{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};


