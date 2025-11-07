/**
 * Saves the currently edited file.
 *
 * Arguments:
 * None
 *
 * Results:
 * None
 */

private _display = findDisplay 16993;
if (isNull _display) exitWith {};

private _entity = _display getVariable ["AE3_entity", objNull];
if (isNull _entity) exitWith {};

private _currentFile = _display getVariable ["AE3_currentFile", ""];
if (_currentFile isEqualTo "") exitWith
{
	hint localize "STR_AE3_Main_Zeus_NoFileSelected";
};

private _pointer = _display getVariable ["AE3_pointer", []];
private _filesystem = _entity getVariable ["AE3_filesystem", createHashMap];

// Check if trying to modify system files
private _fullPath = _pointer + [_currentFile];
private _pathString = "/" + (_fullPath joinString "/");

private _systemPaths = ["/bin/", "/sbin/", "/etc/"];
private _isSystem = false;
{
	if (_pathString find _x == 0) exitWith { _isSystem = true; };
} forEach _systemPaths;

if (_isSystem) exitWith
{
	hint localize "STR_AE3_Main_Zeus_CannotModifySystemFile";
};

// Get new content from editor
private _contentCtrl = _display displayCtrl 1401;
private _newContent = ctrlText _contentCtrl;

// Get file object and update content
try
{
	[_pointer, _filesystem, _currentFile, _newContent] call AE3_filesystem_fnc_writeToFile;
	_entity setVariable ["AE3_filesystem", _filesystem, true];

	hint format [localize "STR_AE3_Main_Zeus_FileSaved", _currentFile];
}
catch
{
	hint format [localize "STR_AE3_Main_Zeus_FileSaveFailed", _exception];
};
