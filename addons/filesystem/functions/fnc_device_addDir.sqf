params ["_computer", "_path", "_owner", "_permissions"];

private _filesystem = _computer getVariable "AE3_filesystem";

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

_computer setVariable ["AE3_filesystem", _filesystem];