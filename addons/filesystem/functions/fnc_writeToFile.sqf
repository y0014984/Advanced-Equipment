/*
 * Author: Root
 * Description: Writes content to a file, either replacing existing content or appending to it. Requires write permission on the file.
 *
 * Arguments:
 * 0: _pntr <ARRAY> - Current directory pointer
 * 1: _filesystem <ARRAY> - Filesystem object
 * 2: _target <STRING> - Path to file
 * 3: _user <STRING> - User performing the write operation
 * 4: _content <STRING> - Content to write
 * 5: _appendMode <BOOL> (Optional, default: false) - If true, append to existing content instead of replacing
 *
 * Return Value:
 * None
 *
 * Example:
 * [[], _filesystem, "/tmp/log.txt", "root", "New log entry\n"] call AE3_filesystem_fnc_writeToFile;
 * [_pointer, _filesystem, "/var/data.txt", "user", "More data\n", true] call AE3_filesystem_fnc_writeToFile;
 *
 * Public: Yes
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
