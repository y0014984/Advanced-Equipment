params ["_options", "_consoleInput"];

_options = _options joinString " ";

private _result = [_consoleInput getVariable ['AE3_filepointer', []], 
				_consoleInput getVariable ['AE3_filesystem', createHashMap], 
				_options] call AE3_filesystem_fnc_chdir;


if(_result isEqualType []) exitWith {
	_consoleInput setVariable ['AE3_filepointer', _result select 0];
	["   Command: cd " + _options];}
;

["   Command: cd " + _result];