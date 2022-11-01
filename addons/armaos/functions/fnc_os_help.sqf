params['_computer'];

private _availableCommands = _computer getVariable ['AE3_Links', createHashMap];
private _result = [];

{
	_result pushBack format ["%1: %2", _x, _y select 1];
} forEach _availableCommands;

_result sort true;

[_computer, _result] call AE3_armaos_fnc_shell_stdout;