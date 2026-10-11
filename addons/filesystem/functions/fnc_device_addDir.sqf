// File: fnc_device_addDir.sqf
#include "..\script_component.hpp"
/*
 * Author: Root, y0014984
 * Description: Adds a directory to a device's filesystem (laptop or flash drive). Must run on server. Logs error if directory already exists, throws exception for other errors.
 *
 * Arguments:
 * 0: _device <OBJECT> - Device object (computer or flash drive)
 * 1: _path <STRING> - Path to new directory
 * 2: _owner <STRING> - Owner of the directory
 * 3: _permissions <ARRAY> - Permissions [[owner r,w,x],[everyone r,w,x]]
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, "/tmp/logs", "root", [[true,true,true],[false,false,false]]] call AE3_filesystem_fnc_device_addDir;
 * [_flashdrive, "/backup", "admin", [[true,true,true],[true,true,false]]] call AE3_filesystem_fnc_device_addDir;
 *
 * Public: Yes
 */

params ["_device", "_path", "_owner", "_permissions"];

if (!isServer) exitWith {};

private _filesystem = _device getVariable "AE3_filesystem";

// throws exception if directory already exists
try 
{
    [
        [],
        _filesystem,
        _path,
        "root",
        _owner,
        _permissions
    ] call AE3_filesystem_fnc_createDir;
} 
catch
{
    private _normalizedException = _exception regexReplace ["'(.+)'", "'%1'"];
    if (_normalizedException isEqualTo (localize "STR_AE3_Filesystem_Exception_AlreadyExists")) then
    {
        INFO_1("Directory already exists, skipping: %1",_exception);
    }
    else
    {
        throw _exception;
    };
};

private _syncMode = missionNamespace getVariable ["AE3_Filesystem_SyncMode", 0];
_device setVariable ["AE3_filesystem", _filesystem, [2, true] select (_syncMode == 1)];
