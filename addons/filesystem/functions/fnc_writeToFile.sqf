/**
 * Writes or appends string to a file.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem [<HASHMAP>, <STRING>]
 * 2: Filepath <STRING>
 * 3: User <STRING>
 * 4: Content <STRING>
 * 5: Append Mode <BOOL> (Optional)
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
 * private _content = "file content";
 * private _appendMode = true;
 * [_pointer, _filesystem, _filePath, _user, _content, _appendMode] call AE3_filesystem_fnc_writeToFile;
*/

params["_pntr", "_filesystem", "_target", "_user", "_content", ["_appendMode", false]];

private _dir = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_getParentDir; // [_pointer, fsObj parent, name parent]

private _current = _dir select 1; // parent filesystemObject
private _filename = _dir select 2; // name parent
private _currentContent = _current select 0;

if(!(_filename in _currentContent)) throw (format [localize "STR_AE3_Filesystem_Exception_NotFound", _filename]);

private _fileObject = _currentContent get _filename;

// write permission needed to write to file; write = 2
[_fileObject, _user, 2] call AE3_filesystem_fnc_hasPermission;

if (_appendMode) then
{
    private _oldContent = _fileObject select 0;
    _content = _oldContent + _content;
};

_fileObject set [0, _content];
