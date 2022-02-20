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

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

if (count _options > 1) exitWith {["Too many options"];};

if (count _options < 1) exitWith {["Too few options"];};


private _obj = _options select 0;
private _result = [];
_result = [_obj];

try
{
	[_pointer, _filesystem, _obj, _username] call AE3_filesystem_fnc_delObj;
	[];
}catch
{
	[_exception];
};