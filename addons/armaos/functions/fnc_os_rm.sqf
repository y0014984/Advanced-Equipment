/**
 * Removes/deletes a given file on a given computer. Returns informations about the success of the command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: File <[STRING]>
 *
 * Results:
 * 1: Informations <[STRING]>
 */

params ["_computer", "_options"];

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

if (count _options > 1) exitWith {["   Command: rm - too many options"];};

if (count _options < 1) exitWith {["   Command: rm - too few options"];};


private _obj = _options select 0;
private _result = [];
_result = ["   Command: rm " + _obj];

try
{
	[_pointer, _filesystem, _obj] call AE3_filesystem_fnc_delObj;
	_result;
}catch
{
	["   Command: rm " + _exception];
};