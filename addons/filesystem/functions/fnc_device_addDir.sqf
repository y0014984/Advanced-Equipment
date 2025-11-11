/*
 * Author: Root
 * Description: Adds a directory to a device's filesystem (laptop or flash drive). Must run on server. Logs error if directory already exists, throws exception for other errors.
 *
 * Arguments:
 * 0: _device <OBJECT> - Device object (computer or flash drive)
 * 1: _path <STRING> - Path to new directory
 * 2: _owner <STRING> - Owner of the directory
 * 3: _permissions <ARRAY> - Permissions [[owner x,r,w],[everyone x,r,w]]
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
        diag_log format ["AE3 exception: %1", _exception];
        ["AE3 exception: %1", _exception] call BIS_fnc_error;
    }
    else
    {
        throw _exception;
    };
};

_device setVariable ["AE3_filesystem", _filesystem];
