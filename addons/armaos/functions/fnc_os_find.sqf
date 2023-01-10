/**
 * Searches for a specific file in the current folder. Outputs results to stadout.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 * 2: Command Name <STRING>
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
			["path", "FILE or FOLDER", true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _searchString = _ae3OptsThings joinString " ";

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _current = [_pointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;

private _terminal = _computer getVariable "AE3_terminal";
private _user = _terminal get "AE3_terminalLoginUser";

private _result = [_pointer, _current, _user, _searchString] call AE3_filesystem_fnc_findFilesystemObject;

private _totalResults = _result select 0;
private _missingPermissions = _result select 1;

if (_missingPermissions > 0) then
{
	_totalResults append [format [localize "STR_AE3_ArmaOS_Exception_CantScanFolderMissionPermissions", _missingPermissions]];
};

[_computer, _totalResults] call AE3_armaos_fnc_shell_stdout;