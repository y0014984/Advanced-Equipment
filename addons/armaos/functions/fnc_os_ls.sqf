params ["_computer", "_options"];

_options = _options joinString " ";

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

try
{
	private _dir = [_pointer, _filesystem, _options] call AE3_filesystem_fnc_lsdir;
	["   Command: ls " + (_pointer joinString "/")] + _dir;
}catch
{
	["   Command: ls " + _exception];
}