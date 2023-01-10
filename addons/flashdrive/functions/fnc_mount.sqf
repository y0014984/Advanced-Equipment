/**
 * Mounts a flashdrive attached to a given interface for a given (armaOS) user.
 * 
 * Arguments:
 * 0: Computer <OBJECT>
 * 1: Interfacename <String>
 * 2: Username <String>
 *
 * Results:
 * None
 */

params['_computer', '_interface', '_username'];

private _filesystem = _computer getVariable "AE3_filesystem";
private _interfaces = _computer getVariable ["AE3_USB_Interfaces", createHashMap];

if (!(_interface in _interfaces)) throw "Interface does not exits!";

private _flashdrive = (_interfaces get _interface) select 0;

if (isNull _flashdrive) throw "Interface is empty!";

private _fdFilesystem = _flashdrive getVariable "AE3_filesystem";

[
	[],
	_filesystem,
	format ["/mnt/%1", _interface],
	"root",
	_username
] call AE3_filesystem_fnc_createDir;

[
	[],
	_filesystem,
	_fdFilesystem,
	format ["/mnt/%1", _interface],
	_username
] call AE3_filesystem_fnc_mount;

[
	[],
	_filesystem,
	format ["/mnt/%1", _interface],
	"root",
	_username,
	true
] call AE3_filesystem_fnc_chown;

_computer setVariable ["AE3_filesystem", _filesystem, 2];

(_interfaces get _interface) set [1, true];