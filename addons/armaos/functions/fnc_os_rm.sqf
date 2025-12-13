/*
 * Author: Root, y0014984, Wasserstoff
 * Description: Removes/deletes a file or directory at the specified path. Similar to Unix rm command.
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
 * [_computer, ["/home/user/file.txt"], "rm"] call AE3_armaos_fnc_os_rm;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = [];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["path", "FILEPATH", true, false]
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

private _obj = _ae3OptsThings select 0;
private _result = [];
_result = [_obj];

try
{
	[_pointer, _filesystem, _obj, _username] call AE3_filesystem_fnc_delObj;
	// Respect filesystem sync mode CBA setting
	private _syncMode = missionNamespace getVariable ["AE3_Filesystem_SyncMode", 0];
	private _syncFlag = [2, true] select (_syncMode == 1);
	_computer setVariable ["AE3_filesystem", _filesystem, _syncFlag];
}catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};
