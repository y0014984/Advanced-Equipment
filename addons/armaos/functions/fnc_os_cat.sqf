/*
 * Author: Root, y0014984
 * Description: Displays the contents of one or more files to the terminal output. Supports -n flag for line numbering. Similar to Unix cat command.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _options <ARRAY> - Command options and arguments
 * 2: _commandName <STRING> - The name of the command
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, ["-n", "/etc/passwd"], "cat"] call AE3_armaos_fnc_os_cat;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = 
	[
		["_numbered", "n", "number", "bool", false, false, localize "STR_AE3_ArmaOS_CommandHelp_Cat_numbered"]
	];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["options", "OPTIONS", false, false],
			["path", "FILEPATH", true, true]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _ae3OptsThings = [];
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



