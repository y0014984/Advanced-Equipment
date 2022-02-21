/**
 * Executes a file.
 * 
 * Arguments:
 * 0: Computer <OBJECT>
 * 1: File pointer [<STRING>]
 * 2: Path to file <STRING>
 * 3: Options <LIST>
 *
 * Returns:
 * Result of the file.
 */

params['_computer', '_path', '_options'];

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

private _result = [format ["Command '%1' not found.", _path]];

try
{
	_content = [_pointer, _filesystem, _path, _username, 0] call AE3_filesystem_fnc_getFile;

	if(_content isEqualType {}) then
	{
		_result = [_computer, _options] call _content;

		if(isNil "_result") exitWith {_result = [""]};

		if(_result isEqualType []) exitWith {};

		if(!(_result isEqualType "")) exitWith {_result = [str _result]};

		_result = [_result];
	};
}catch {};

_result;