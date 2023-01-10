/**
 * Unmounts a flashdrive attached to a given interface.
 * 
 * Arguments:
 * 0: Computer <OBJECT>
 * 1: Interfacename <String>
 *
 * Results:
 * None
 */

params['_computer', '_interface'];

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
	"root"
] call AE3_filesystem_fnc_delObj;

_computer setVariable ["AE3_filesystem", _filesystem, 2];
(_interfaces get _interface) set [1, false];
