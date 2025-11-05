/**
 * Puts computer in standby mode.
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

[_computer] spawn (_computer getVariable "AE3_power_fnc_standbyWrapper");

/* ------------- UI on Texture ------------ */

_computer setVariable ["AE3_UiOnTexActive", false, true]; // reset var for all clients

/* ---------------------------------------- */
