/**
 * Sets the file content to the given content.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem <HASHMAP>
 * 2: Path to target file <STRING>
 * 3: User <STRING>
 * 4: New content <String>
 *
 * Results:
 * None
 */

params["_pointer", "_filesystem", "_target", "_user", "_content"];

private _dir = [_pointer, _filesystem, _target, _user] call AE3_filesystem_fnc_getParentDir;
private _current = _dir select 1;
_current = _current select 0;
private _filename = _dir select 2;

private _fsObject = _current get _filename;

_fsObject set [0, _content];
