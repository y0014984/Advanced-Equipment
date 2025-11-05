/**
 * Unmounts a filesystem which is connect via a given interface.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 * 3: Command Name <STRING>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

params ["_computer", "_options", "_commandName"];

private _commandOpts = [];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["path", "INTERFACE", true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _ae3OptsThings = [];
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};
_ae3OptsThings params ["_interfaceName"];

try
{
	[_computer, _interfaceName] call AE3_flashdrive_fnc_unmount;
}catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};
