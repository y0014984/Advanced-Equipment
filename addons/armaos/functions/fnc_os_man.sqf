/**
 * Prints/outputs informatioms about a given shell command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Command <[STRING]>
 *
 * Results:
 * 1: Informations <[STRING]>
 */

params ["_computer", "_options"];

private _availableCommands = _computer getVariable ['AE3_Links', createHashMap];

private _result = [];

if (count _options > 1) exitWith {["Too many options"];};
if (count _options < 1) exitWith {["Too few options"];};

private _command = _options select 0;

if(_command in _availableCommands) then
{
	_result = (_availableCommands get _command) select 2;
}else
{
	_result = format ["   Command '%1' not found.", _command];
};

_result;