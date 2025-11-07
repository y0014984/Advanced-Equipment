/**
 * Handles the New File dialog for the filesystem browser.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Exit Code <NUMBER>
 * 2: Mode <STRING> - "onLoad" or "onUnload"
 *
 * Results:
 * None
 */

params ["_display", "_exitCode", "_mode"];

if (_mode isEqualTo "onLoad") then
{
	// Initialize dialog
};

if (_mode isEqualTo "onUnload") exitWith
{
	if (_exitCode != 1) exitWith {}; // User cancelled

	private _browserDisplay = findDisplay 16993;
	if (isNull _browserDisplay) exitWith {};

	private _entity = _browserDisplay getVariable ["AE3_entity", objNull];
	if (isNull _entity) exitWith {};

	private _pointer = _browserDisplay getVariable ["AE3_pointer", []];
	private _filesystem = _entity getVariable ["AE3_filesystem", createHashMap];

	// Check if trying to modify system folder
	private _pathString = "/" + (_pointer joinString "/");
	if (_pathString in ["/bin", "/sbin", "/etc"]) exitWith
	{
		hint localize "STR_AE3_Main_Zeus_CannotModifySystemFolder";
	};

	// Get values from dialog
	private _filename = _display getVariable ["filename", "newfile.txt"];
	private _content = ctrlText (_display displayCtrl 1402);
	private _isCode = cbChecked (_display displayCtrl 1301);
	private _owner = _display getVariable ["owner", "root"];

	// Get permissions from checkboxes
	private _ownerRead = cbChecked (_display displayCtrl 1302);
	private _ownerWrite = cbChecked (_display displayCtrl 1303);
	private _ownerExecute = cbChecked (_display displayCtrl 1304);

	private _everyoneRead = cbChecked (_display displayCtrl 1305);
	private _everyoneWrite = cbChecked (_display displayCtrl 1306);
	private _everyoneExecute = cbChecked (_display displayCtrl 1307);

	private _permissions = [
		[_ownerExecute, _ownerRead, _ownerWrite],
		[_everyoneExecute, _everyoneRead, _everyoneWrite]
	];

	// Process content if it's code
	if (_isCode) then
	{
		_content = compile _content;
	};

	// Create file
	try
	{
		[_pointer, _filesystem, _filename, _content, "root", _owner, _permissions] call AE3_filesystem_fnc_createFile;
		_entity setVariable ["AE3_filesystem", _filesystem, true];

		[_browserDisplay] call AE3_main_fnc_zeus_filesystemBrowser_refresh;

		hint format [localize "STR_AE3_Main_Zeus_FileCreated", _filename];
	}
	catch
	{
		hint format [localize "STR_AE3_Main_Zeus_FileCreationFailed", _exception];
	};
};
