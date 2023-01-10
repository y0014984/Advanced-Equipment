/**
 * Changes/sets the current working directory of a given terminal on a given computer.
 * Also returns information about the success of the command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Folder/Directory <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = [];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["path", "DIRECTORY", true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _ae3OptsThings = _ae3OptsThings joinString " ";

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

try
{
	private _result = [_computer getVariable ["AE3_filepointer", []], 
				_computer getVariable ["AE3_filesystem", createHashMap], 
				_ae3OptsThings,
				_username] call AE3_filesystem_fnc_chdir;

	[(_result select 1), _username, 0] call AE3_filesystem_fnc_hasPermission;
	_computer setVariable ["AE3_filepointer", _result select 0];

}catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};