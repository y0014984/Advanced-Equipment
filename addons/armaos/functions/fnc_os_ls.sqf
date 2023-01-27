/**
 * Lists/outputs the containing files of a given folder/directory on a given computer.
 * Also returns information about the success of the command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Folder/Directory <[STRING]>
 * 3: Command Name <STRING>
 *
 * Results:
 * None
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = 
	[
		["_long", "l", "long", "bool", false, false, "prints folder content in long form"]
	];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["options", "OPTIONS", false, false],
			["path", "DIRECTORIES", false, true]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _path = _ae3OptsThings;

if (count _path == 0) then
{
	_path = [""];
};

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

private _output = [];

try
{
	{
		_dir = [_pointer, _filesystem, _x, _username, _long] call AE3_filesystem_fnc_lsdir;
		_output append _dir;
	}forEach _path;
}catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};

[_computer, _output] call AE3_armaos_fnc_shell_stdout;