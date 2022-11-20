/**
 * Lists/outputs the containing files of a given folder/directory on a given computer.
 * Also returns information about the success of the command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Folder/Directory <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

private _commandName = "ls";

if (count _options >= 3) exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasTooManyOptions", _commandName] ] call AE3_armaos_fnc_shell_stdout; };

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
	}forEach _path;
}catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};

[_computer, _output] call AE3_armaos_fnc_shell_stdout;