// File: fnc_app_notepad.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Desktop "Notepad" app: open, edit and save text files on the laptop filesystem.
 * Saves write to the local filesystem copy and are pushed to the server immediately.
 *
 * Arguments:
 * 0: _winId <NUMBER>
 * 1: _ctrlGroup <CONTROL>
 * 2: _computer <OBJECT>
 * 3: _args <ANY> - optional [_path] to open a file directly
 *
 * Return Value:
 * App callbacks <HASHMAP>
 *
 * Public: No
 */

params ["_winId", "_ctrlGroup", "_computer", "_args"];

private _session = uiNamespace getVariable ["AE3_desktop_session", createHashMap];
private _display = _session getOrDefault ["display", displayNull];
private _theme = _session getOrDefault ["theme", createHashMap];
private _currentUser = _session getOrDefault ["user", "root"];

(ctrlPosition _ctrlGroup) params ["", "", "_w", "_h"];

/* path box */
private _pathCtrl = _display ctrlCreate ["RscEdit", -1, _ctrlGroup];
_pathCtrl ctrlSetPosition [0.01, 0.045, _w - 0.20, 0.035];
_pathCtrl ctrlSetText (_args param [0, "/home/user/note.txt"]);
_pathCtrl ctrlCommit 0;

/* load + save buttons */
private _loadBtn = _display ctrlCreate ["RscButton", -1, _ctrlGroup];
_loadBtn ctrlSetPosition [_w - 0.185, 0.045, 0.085, 0.035];
_loadBtn ctrlSetText (localize "STR_AE3_Desktop_Notepad_Load");
_loadBtn ctrlSetBackgroundColor (_theme getOrDefault ["titlebar", [0,0,0,1]]);
_loadBtn ctrlSetTextColor (_theme getOrDefault ["text", [1,1,1,1]]);
_loadBtn ctrlCommit 0;

private _saveBtn = _display ctrlCreate ["RscButton", -1, _ctrlGroup];
_saveBtn ctrlSetPosition [_w - 0.095, 0.045, 0.085, 0.035];
_saveBtn ctrlSetText (localize "STR_AE3_Desktop_Notepad_Save");
_saveBtn ctrlSetBackgroundColor (_theme getOrDefault ["accent", [0.2,0.5,0.8,1]]);
_saveBtn ctrlSetTextColor (_theme getOrDefault ["text", [1,1,1,1]]);
_saveBtn ctrlCommit 0;

/* multiline editor */
private _editCtrl = _display ctrlCreate ["RscEditMulti", -1, _ctrlGroup];
if (isNull _editCtrl) then { _editCtrl = _display ctrlCreate ["RscEdit", -1, _ctrlGroup]; };
_editCtrl ctrlSetPosition [0.01, 0.09, _w - 0.02, _h - 0.135];
_editCtrl ctrlCommit 0;

/* status line */
private _statusCtrl = _display ctrlCreate ["RscText", -1, _ctrlGroup];
_statusCtrl ctrlSetPosition [0.01, _h - 0.04, _w - 0.02, 0.03];
_statusCtrl ctrlSetTextColor (_theme getOrDefault ["accent", [1,1,1,1]]);
_statusCtrl ctrlCommit 0;

/* ---------------------------------------- */

private _ctx = [_computer, _pathCtrl, _editCtrl, _statusCtrl, _currentUser];
_loadBtn setVariable ["AE3_ctx", _ctx];
_saveBtn setVariable ["AE3_ctx", _ctx];

_loadBtn ctrlAddEventHandler ["ButtonClick", {
	params ["_button"];
	((_button getVariable "AE3_ctx")) params ["_computer", "_pathCtrl", "_editCtrl", "_statusCtrl"];

	private _filesystem = _computer getVariable ["AE3_filesystem", []];
	private _path = ctrlText _pathCtrl;

	try
	{
		private _content = [[], _filesystem, _path, "root", 0] call AE3_filesystem_fnc_getFile;
		if (_content isEqualType "") then
		{
			_editCtrl ctrlSetText _content;
			_statusCtrl ctrlSetText format [localize "STR_AE3_Desktop_Notepad_Loaded", _path];
		}
		else
		{
			_statusCtrl ctrlSetText (localize "STR_AE3_Desktop_Files_Executable");
		};
	}
	catch
	{
		_statusCtrl ctrlSetText str _exception;
	};
}];

_saveBtn ctrlAddEventHandler ["ButtonClick", {
	params ["_button"];
	((_button getVariable "AE3_ctx")) params ["_computer", "_pathCtrl", "_editCtrl", "_statusCtrl", ["_owner", "root"]];

	private _filesystem = _computer getVariable ["AE3_filesystem", []];
	private _path = ctrlText _pathCtrl;

	try
	{
		// create when missing, then overwrite content; file is owned by the logged-in user
		[[], _filesystem, _path, "", _owner, _owner, [[true, true, false], [true, false, false]]] call AE3_filesystem_fnc_ensureFile;
		[[], _filesystem, _path, _owner, ctrlText _editCtrl, false] call AE3_filesystem_fnc_writeToFile;

		// push to the server right away so the change survives even a hard desktop close
		if ([_computer] call AE3_filesystem_fnc_device_isSynced) then { _computer setVariable ["AE3_filesystem", _filesystem, 2]; };

		_statusCtrl ctrlSetText format [localize "STR_AE3_Desktop_Notepad_Saved", _path];
	}
	catch
	{
		_statusCtrl ctrlSetText str _exception;
	};
}];

// Auto-load when a path was passed in (e.g. opened from the Files app)
if ((_args param [0, ""]) isNotEqualTo "") then
{
	private _filesystem = _computer getVariable ["AE3_filesystem", []];
	try
	{
		private _content = [[], _filesystem, _args param [0, ""], "root", 0] call AE3_filesystem_fnc_getFile;
		if (_content isEqualType "") then
		{
			_editCtrl ctrlSetText _content;
		};
	}
	catch
	{
		_statusCtrl ctrlSetText str _exception;
	};
};

// Restored session: unsaved editor text from the previous user takes precedence
private _restoredText = _args param [1, ""];
if (_restoredText isNotEqualTo "") then
{
	_editCtrl ctrlSetText _restoredText;
	_statusCtrl ctrlSetText (localize "STR_AE3_Desktop_Notepad_Restored");
};

createHashMapFromArray [
	["pathCtrl", _pathCtrl],
	["editCtrl", _editCtrl],
	["getState", {
		private _pathCtrl = _this getOrDefault ["pathCtrl", controlNull];
		private _editCtrl = _this getOrDefault ["editCtrl", controlNull];
		if (isNull _pathCtrl || isNull _editCtrl) exitWith { [] };
		[ctrlText _pathCtrl, ctrlText _editCtrl]
	}]
]
