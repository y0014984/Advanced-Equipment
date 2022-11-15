/**
 * Prints/outputs the content of a given file on a given computer.
 * Returns information about the success of the command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: File <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

if (count _options == 0) exitWith { [_computer, "'cat' has too few options"] call AE3_armaos_fnc_shell_stdout; };

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

private _result = [];

{
	private _path = _x;

	try
	{
		_content = [_pointer, _filesystem, _path, _username, 1] call AE3_filesystem_fnc_getFile;

		if(!(_content isEqualType "")) exitWith 
		{
			_result pushBack ("Unable to read: " + _path);
			_result;
		};

		_content = _content splitString endl;
		_result append _content;
	}
	catch
	{
		[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
	};

} forEach _options;

[_computer, _result] call AE3_armaos_fnc_shell_stdout;



