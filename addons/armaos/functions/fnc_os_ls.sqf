/**
 * Lists/outputs the containing files of a given folder/directory on a given computer.
 * Also returns informations about the success of the command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Folder/Directory <[STRING]>
 *
 * Results:
 * 1: Informations/Files <[STRING]>
 */

params ["_computer", "_options"];

_options = _options joinString " ";

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

try
{
	private _dir = [_pointer, _filesystem, _options] call AE3_filesystem_fnc_lsdir;
	_dir;
}catch
{
	[_exception];
}