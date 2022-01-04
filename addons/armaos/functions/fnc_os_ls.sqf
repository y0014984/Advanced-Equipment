params ["_options", "_consoleInput"];

_options = _options joinString " ";

systemChat str _options;

private _pointer = _consoleInput getVariable "AE3_filepointer";
private _filesystem = _consoleInput getVariable "AE3_filesystem";

private _dir = [_pointer, _filesystem, _options] call AE3_filesystem_fnc_lsdir;

systemChat str _dir;

if(_dir isEqualType []) exitWith 
{
	["   Command: ls " + (_pointer joinString "/") + endl + (_dir joinString endl)];
};

["   Command: ls " + _dir];