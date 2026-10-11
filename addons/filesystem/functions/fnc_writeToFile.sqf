// File: fnc_writeToFile.sqf
/*
 * Author: Root, y0014984
 * Description: Writes content to an existing file in a filesystem array, either replacing existing content or appending to it. Requires write permission on the file. Throws if the file does not exist. Mutates the passed filesystem only - the caller must publish it; to write to a device from a mission script use AE3_filesystem_fnc_device_writeFile. A virtual file size is kept. Note the argument order: _user comes before _content (createFile/ensureFile take _content first).
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

// write permission (index 1) needed to write to file
[_fileObject, _user, 1] call AE3_filesystem_fnc_hasPermission;

if (_appendMode) then
{
    private _oldContent = _fileObject select 0;
    _content = _oldContent + _content;
};

_fileObject set [0, _content];
