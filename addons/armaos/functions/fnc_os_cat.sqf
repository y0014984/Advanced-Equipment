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

private _commandName = "cat";
private _commandOpts = 
	[
		["_numbered", "n", "number", "bool", false, false, "prints numbered output lines"]
	];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["path", "PATH", true, true]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

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
			_result pushBack (format [localize "STR_AE3_ArmaOS_Exception_UnableToRead", _path]);
			_result;
		};

		_content = _content splitString endl;

		if (_numbered) then
		{
			{
				_content set [_forEachIndex, format ["%1: %2", _forEachIndex, _x]];
			} forEach _content;
		};

		_result append _content;
	}
	catch
	{
		[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
	};

} forEach _ae3OptsThings;

[_computer, _result] call AE3_armaos_fnc_shell_stdout;



