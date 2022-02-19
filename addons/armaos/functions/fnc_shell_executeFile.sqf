/**
 * Executes a file.
 * 
 * Arguments:
 * 0: Computer <OBJECT>
 * 1: Path to file <STRING>
 * 2: Options <LIST>
 *
 * Returns:
 * Result of the file.
 */

params['_computer', '_path', '_options'];

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";
private _result = format ["   Command '%1' not found.", _path];

try
{
	_content = [_pointer, _filesystem, _path] call AE3_filesystem_fnc_getFile;

	if(_content isEqualType {}) then
	{
		_result = [_computer, _options] call _content;

		if(isNil "_result") then 
		{
			_result = ""
		}else
		{
			if(!(_result isEqualType "")) then 
			{
				_result = str _result
			};
		};
	}
}catch {};

[_result];