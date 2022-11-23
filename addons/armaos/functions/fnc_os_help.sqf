/**
 * Prints/outputs the available armaOS terminal commands to stdout.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

private _commandName = "help";

if (count _options >= 1) exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasNoOptions", _commandName] ] call AE3_armaos_fnc_shell_stdout; };

private _availableCommands = _computer getVariable ['AE3_Links', createHashMap];
private _result = [];

{
	_result pushBack format ["%1: %2", _x, _y select 1];
} forEach _availableCommands;

_result sort true;

[_computer, _result] call AE3_armaos_fnc_shell_stdout;