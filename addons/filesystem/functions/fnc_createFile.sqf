/**
 * Creates a file.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem [<HASHMAP>, <STRING>]
 * 2: Filepath <STRING>
 * 3: Filecontent <ANY>
 * 4: User <STRING>
 * 5: Owner <STRING> (Optional)
 *
 * Results:
 * None
 */

params['_pntr', '_filesystem', '_target', '_content', '_user', '_owner'];


private _dir = [_pntr, _filesystem, _target, true] call AE3_filesystem_fnc_getParentDir;

private _current = _dir select 1;
private _new = _dir select 2;

[_current, _user] call AE3_filesystem_fnc_hasPermission;
_current = _current select 0;

if(_new in _current) then {
	throw _new + " already exists!";
};

if(isNil '_owner') then
{
	_owner = _user;
};

_current set [_new, [_content, _owner]];

_filesystem;