/**
 * Checks wether the filesystem object exists in the given filesystem or not
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem [<HASHMAP>, <STRING>]
 * 2: Path to filesystem object <STRING>
 * 3: User <STRING>
 * Results:
 * 0: exists <BOOL>
 */

params["_pntr", "_filesystem", "_target", "_user"];

try
{
    private _dir = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_getParentDir;
    private _current = _dir select 1;
    _current = _current select 0;

    private _fsObj = _dir select 2;

    if(_fsObj in _current) then { true; } else { false; };
} catch
{
    false;
};

