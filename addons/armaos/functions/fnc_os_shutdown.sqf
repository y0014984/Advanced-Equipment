/*
 * Author: Root, y0014984, Wasserstoff
 * Description: Powers down the computer immediately, closes the terminal dialog and turns off the computer. Similar to Unix shutdown command.
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
 * [_computer, [], "shutdown"] call AE3_armaos_fnc_os_shutdown;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = [];
private _commandSyntax =
[
	[
			["command", _commandName, true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _unused_ae3OptsThings = [];
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

_computer setVariable ["AE3_computer_mutex", objNull, true];
closeDialog 1;

[_computer, [false]] call (_computer getVariable "AE3_power_fnc_turnOffWrapper");

/* ------------- UI on Texture ------------ */

_computer setVariable ["AE3_UiOnTexActive", false, true]; // reset var for all clients

/* ---------------------------------------- */
