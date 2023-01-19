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

if(!isServer) then
{
	[_computer, "AE3_USB_Interfaces"] call AE3_main_fnc_getRemoteVar;
};
private _interfaces = _computer getVariable ["AE3_USB_Interfaces", createHashMap];

if (!(_interface in _interfaces)) throw (localize "STR_AE3_Flashdrive_Exception_InterfaceNotExisting");

private _flashdrive = (_interfaces get _interface) select 0;

if (isNull _flashdrive) throw (localize "STR_AE3_Flashdrive_Exception_InterfaceEmpty");

private _parent = [
	[],
	_filesystem,
	format ["/mnt/%1", _interface],
	"root"
] call AE3_filesystem_fnc_getParentDir;

private _parent = (_parent select 1) select 0;

if (!(_interface in _parent)) exitWith {};

private _fdFilesystem = (_parent get _interface);
_flashdrive setVariable ["AE3_filesystem", _fdFilesystem, 2];


[
	[],
	_filesystem,
	format ["/mnt/%1", _interface],
	"root"
] call AE3_filesystem_fnc_delObj;

_computer setVariable ["AE3_filesystem", _filesystem, [_computer] call AE3_armaos_fnc_computer_getLocality];
(_interfaces get _interface) set [1, false];
if(!isServer) then 
{
	_computer setVariable ["AE3_USB_Interfaces", _interfaces, 2];
};

