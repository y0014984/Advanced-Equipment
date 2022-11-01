/**
 * Appends string to a file.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem [<HASHMAP>, <STRING>]
 * 2: Filepath <STRING>
 * 3: Appendable content <STRING>
 * 4: User <STRING>
 *
 * Results:
 * None
 *
 * Example:
 * --------
 * private _pointer = cursorObject getVariable "AE3_Filepointer";
 * private _filesystem = cursorObject getVariable "AE3_Filesystem";
 * private _filePath = "/tmp/new/example.txt";
 * private _user = "root"; 
 * private _appendableContent = "\n" + "new line";
 * [_pointer, _filesystem, _filePath, _user, _appendableContent] call AE3_filesystem_fnc_appendToFile;
*/

params["_pntr", "_filesystem", "_target", "_user", "_appendableContent"];

private _dir = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_getParentDir;
private _current = _dir select 1;
_current = _current select 0;

private _file = _dir select 2;

if(!(_file in _current)) throw (format ["'%1' not found!", _file]);

private _permissionWrite = 2; // write permission needed to append to file
[_current get _file, _user, _permissionWrite] call AE3_filesystem_fnc_hasPermission;

private _oldContent = (_current get _file) select 0;
private _owner = (_current get _file) select 1;
private _permissions = (_current get _file) select 2;

private _newContent = _oldContent + _appendableContent;

_current set [_file, [_newContent, _owner, _permissions]];