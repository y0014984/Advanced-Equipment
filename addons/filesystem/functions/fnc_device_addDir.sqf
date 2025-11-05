/**
 * PUBLIC
 *
 * Adds a directory to a given Device. Device could be a comupter or a flash drive.
 * Logs and displays an error message if dir already exists; On other errors it throws an exception.
 * Needs to run on server.
 *
 * Arguments:
 * 1: Device <OBJECT>
 * 2: Path <STRING>
 * 3: Owner <STRING>
 * 4: Permissions <[ARRAY]>
 *
 * Results:
 * none
 *
 * Example:
 * [_device, "/tmp/new", "root", [[true, true, true], [true, true, true]]] call AE3_filesystem_fnc_device_addDir;
 *
 *
 * Permissions:
 * [[owner execute, owner read, owner write], [everyone execute, everyone read, everyone write]]
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
