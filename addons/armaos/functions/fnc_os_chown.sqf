/**
 * Changes the owner of file
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 * 3: Command Name <STRING>
 *
 * Results:
 * None
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = [
	["_recursive", "r", "recursive", "bool", false, false, localize "STR_AE3_ArmaOS_CommandHelp_Chown_recursive"]
];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["options", "OPTIONS", false, false],
			["path", "PATH", true, false],
			["path", "OWNER", true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};
_ae3OptsThings params ["_path", '_owner'];

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

try
{
	[_pointer, _filesystem, _path, _username, _owner, _recursive] call AE3_filesystem_fnc_chown;
}catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};