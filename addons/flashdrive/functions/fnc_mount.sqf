/**
 * Mounts a flashdrive attached to a given (usb) interface for a given (armaOS) user.
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

if(!isServer) then
{
	[_computer, "AE3_USB_Interfaces"] call AE3_main_fnc_getRemoteVar;
};
private _interfaces = _computer getVariable ["AE3_USB_Interfaces", createHashMap];

if (!(_interface in _interfaces)) throw (localize "STR_AE3_Flashdrive_Exception_InterfaceNotExisting");

private _flashdrive = (_interfaces get _interface) select 0;

if (isNull _flashdrive) throw (localize "STR_AE3_Flashdrive_Exception_InterfaceEmpty");

if(!isServer) then
{
	[_flashdrive, "AE3_filesystem"] call AE3_main_fnc_getRemoteVar;
};
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

_computer setVariable ["AE3_filesystem", _filesystem, [_computer] call AE3_armaos_fnc_computer_getLocality];

(_interfaces get _interface) set [1, true];
if(!isServer) then 
{
	_computer setVariable ["AE3_USB_Interfaces", _interfaces, 2];
};
