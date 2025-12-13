/*
 * Author: Root, Wasserstoff
 * Description: Mounts a flash drive attached to a USB interface, creating a mount point at /mnt/<interface> and making the drive's filesystem accessible to the specified user
 *
 * Arguments:
 * 0: _computer <OBJECT> - Computer object with USB interfaces
 * 1: _interface <STRING> - Name of the USB interface to mount
 * 2: _username <STRING> - ArmaOS username to grant access permissions
 *
 * Return Value:
 * None
 *
 * Example:
 * [laptop, "usb0", "user"] call AE3_flashdrive_fnc_mount;
 *
 * Public: Yes
 */

params['_computer', '_interface', '_username'];

private _filesystem = _computer getVariable "AE3_filesystem";

private _interfaces = _computer getVariable ["AE3_USB_Interfaces", createHashMap];

if (!(_interface in _interfaces)) throw (localize "STR_AE3_Flashdrive_Exception_InterfaceNotExisting");

private _occupiedList = _computer getVariable "AE3_USB_Interfaces_occupied";
private _mountedList = _computer getVariable "AE3_USB_Interfaces_mounted";
private _index = (_interfaces get _interface) select 0;
private _flashdrive = _occupiedList select _index;

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

_mountedList set [_index, true];
_computer setVariable ["AE3_USB_Interfaces_mounted", _mountedList, 2];
