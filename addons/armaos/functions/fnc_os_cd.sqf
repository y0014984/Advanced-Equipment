/**
 * Changes/sets the current working directory of a given terminal on a given computer.
 * Also returns informations about the success of the command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Folder/Directory <[STRING]>
 *
 * Results:
 * 1: Informations <[STRING]>
 */

params ["_computer", "_options"];

_options = _options joinString " ";

try
{
	private _result = [_computer getVariable ['AE3_filepointer', []], 
				_computer getVariable ['AE3_filesystem', createHashMap], 
				_options] call AE3_filesystem_fnc_chdir;

	_computer setVariable ['AE3_filepointer', _result select 0];
	[];

}catch
{
	[_exception];
};