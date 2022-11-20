/**
 * Prints/outputs informatioms about a given shell command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Command <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

if (count _options > 1) exitWith { [_computer, "'man' has too many options"] call AE3_armaos_fnc_shell_stdout; };
if (count _options < 1) exitWith { [_computer, "'man' has too few options"] call AE3_armaos_fnc_shell_stdout; };

private _availableCommands = _computer getVariable ['AE3_Links', createHashMap];

private _result = [];

if (count _options > 1) exitWith {[_computer, localize "STR_AE3_ArmaOS_Exception_TooManyOptions"] call AE3_armaos_fnc_shell_stdout;};
if (count _options < 1) exitWith {[_computer, localize "STR_AE3_ArmaOS_Exception_TooFewOptions"] call AE3_armaos_fnc_shell_stdout;};

private _command = _options select 0;

if(_command in _availableCommands) then
{
	_result = (_availableCommands get _command) select 2;
}else
{
	_result = format [localize "STR_AE3_ArmaOS_Exception_CommandNotFound", _command];
};

[_computer, _result] call AE3_armaos_fnc_shell_stdout;