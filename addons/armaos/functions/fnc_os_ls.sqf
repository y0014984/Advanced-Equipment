/**
 * Lists/outputs the containing files of a given folder/directory on a given computer.
 * Also returns information about the success of the command.
 *
 * Arguments:
 * 0: Computer <OBJECT>
 * 1: Folder/Directory <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

private _long = false;
private _path = [];

{
	if((_x select [0,1]) == "-") then
	{
		{
			if(_x == 'l' || _x == 'L') then
			{
				_long = true;
			};
		}forEach (_x splitString "");
	}else
	{
		_path pushBack _x;
	};
}forEach _options;

if (count _path == 0) then
{
	_path = [""];
};

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

private _output = [];

try
{
	{
		_dir = [_pointer, _filesystem, _x, _username, _long] call AE3_filesystem_fnc_lsdir;
		_output append _dir;
		_output pushBack "";
	}forEach _path;
}catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};

[_computer, _output] call AE3_armaos_fnc_shell_stdout;