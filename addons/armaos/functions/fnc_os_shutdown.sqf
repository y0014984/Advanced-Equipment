/**
 * Powers down the computer immediately.
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

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

_computer setVariable ["AE3_computer_mutex", objNull, true];
closeDialog 1;

private _handle = [_computer, [false]] call (_computer getVariable "AE3_power_fnc_turnOffWrapper");

/* ------------- UI on Texture ------------ */

_computer setVariable ["AE3_UiOnTexActive", false, true]; // reset var for all clients

/* ---------------------------------------- */