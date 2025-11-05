/**
 * Executes a file.
 * 
 * Arguments:
 * 0: Computer <OBJECT>
 * 1: File pointer [<STRING>]
 * 2: Path to file <STRING>
 * 3: Options <LIST>
 *
 * Returns:
 * None
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


