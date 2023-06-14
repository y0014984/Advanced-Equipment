/**
 * PUBLIC
 *
 * Adds a directory to a given Device. Device could be a comupter or a flash drive.
 *
 * Arguments:
 * 1: Device <OBJECT>
 * 2: Path <STRING>
 * 3: Owner <STRING>
 * 4: Permissions <[ARRAY]>
 *
 * Results:
 * Logs if dir already exists; On other errors it throws an exception
 *
 * Example:
 * [_device, "/tmp/new", "root", [[true, true, true], [true, true, true]]] call AE3_filesystem_fnc_device_addDir;
 *
 *
 * Permissions:
 * [[owner execute, owner read, owner write], [everyone execute, everyone read, everyone write]]
 */

params ["_device", "_path", "_owner", "_permissions"];

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
    }
    else
    {
        throw _exception;
    };
};

_device setVariable ["AE3_filesystem", _filesystem];