/*
 * Author: Root, Wasserstoff
 * Description: Mounts a filesystem connected via a USB interface (flash drive). Similar to Unix mount command.
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
 * [_computer, ["usb0"], "mount"] call AE3_armaos_fnc_os_mount;
 *
 * Public: Yes
 */

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

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

try
{
	[_computer, _interfaceName, _username] call AE3_flashdrive_fnc_mount;
}catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};
