/**
 * Mounts a filesystem which is connect via a given interface.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: File <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

if (count _options > 1) exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasTooManyOptions", "mount"] ] call AE3_armaos_fnc_shell_stdout; };
if (count _options < 1) exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasTooFewOptions", "mount"] ] call AE3_armaos_fnc_shell_stdout; };

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";
private _interfaces = _computer getVariable ["AE3_USB_Interfaces", createHashMap];

private _obj = _options select 0;

if (!(_obj in _interfaces)) exitWith { [ _computer, "Interface does not exits!"] call AE3_armaos_fnc_shell_stdout; };

private _flashdrive = (_interfaces get _obj) select 0;

if (isNull _flashdrive) exitWith { [ _computer, "Interface is empty!"] call AE3_armaos_fnc_shell_stdout; };

private _fdFilesystem = _flashdrive getVariable "AE3_filesystem";

try
{
	[
		_pointer,
		_filesystem,
		format ["/mnt/%1", _obj],
		"root",
		_username
	] call AE3_filesystem_fnc_createDir;

	[
		_pointer,
		_filesystem,
		_fdFilesystem,
		format ["/mnt/%1", _obj],
		_username
	] call AE3_filesystem_fnc_mount;

	[
		_pointer,
		_filesystem,
		format ["/mnt/%1", _obj],
		"root",
		_username,
		true
	] call AE3_filesystem_fnc_chown;

	_computer setVariable ["AE3_filesystem", _filesystem, 2];

	(_interfaces get _obj) set [1, true];
}catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};