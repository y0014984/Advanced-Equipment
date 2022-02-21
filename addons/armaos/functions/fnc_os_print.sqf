/**
 * Prints/outputs the content of a given file on a given computer.
 * Returns informations about the success of the command and the content of the file.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: File <[STRING]>
 *
 * Results:
 * 1: Informations/Content <[STRING]>
 */

params ["_computer", "_options"];

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

if(count _options == 0) exitWith {["Too few options"];};

private _result = [];
private _path = _options select 0;

try
{
	_content = [_pointer, _filesystem, _path, _username, 1] call AE3_filesystem_fnc_getFile;

	if(!(_content isEqualType "")) exitWith 
	{
		_result pushBack ("Unable to read: " + _path);
		_result;
	};

	_result pushBack _content;
	_result;

}catch
{
	[_exception];
}



