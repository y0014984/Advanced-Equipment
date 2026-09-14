// File: fnc_app_music.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Desktop "Music" app: lists audio files registered via the media registry
 * (markers on the laptop filesystem) and plays them locally at the laptop's position.
 *
 * Arguments:
 * 0: _winId <NUMBER>
 * 1: _ctrlGroup <CONTROL>
 * 2: _computer <OBJECT>
 * 3: _args <ANY>
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

(ctrlPosition _ctrlGroup) params ["", "", "_w", "_h"];

private _listCtrl = _display ctrlCreate ["RscListBox", -1, _ctrlGroup];
_listCtrl ctrlSetPosition [0.01, 0.045, _w - 0.02, _h - 0.10];
_listCtrl ctrlCommit 0;

private _hintCtrl = _display ctrlCreate ["RscText", -1, _ctrlGroup];
_hintCtrl ctrlSetPosition [0.01, _h - 0.05, _w - 0.02, 0.035];
_hintCtrl ctrlSetText (localize "STR_AE3_Desktop_Music_Hint");
_hintCtrl ctrlSetTextColor (_theme getOrDefault ["accent", [1,1,1,1]]);
_hintCtrl ctrlCommit 0;

/* ---------------------------------------- */
/* find all audio media markers in the laptop filesystem (recursive walk) */

private _tracks = []; // [path, sourcePath]
private _filesystem = _computer getVariable ["AE3_filesystem", []];

if (_filesystem isNotEqualTo []) then
{
	private _walk = {
		params ["_dirContent", "_pathPrefix", "_tracks", "_walk"];

		{
			private _obj = _dirContent get _x;
			private _content = _obj select 0;

			if (_content isEqualType createHashMap) then
			{
				[_content, _pathPrefix + "/" + _x, _tracks, _walk] call _walk;
			}
			else
			{
				([_content] call AE3_desktop_fnc_parseMediaMarker) params ["_isMedia", "_type", "", "", "_sourcePath"];
				if (_isMedia && _type isEqualTo "audio") then
				{
					_tracks pushBack [_pathPrefix + "/" + _x, _sourcePath];
				};
			};
		} forEach (keys _dirContent);
	};

	[_filesystem select 0, "", _tracks, _walk] call _walk;
};

{
	_x params ["_path"];
	private _index = _listCtrl lbAdd _path;
	_listCtrl lbSetData [_index, _x select 1];
} forEach _tracks;

if (_tracks isEqualTo []) then
{
	private _index = _listCtrl lbAdd (localize "STR_AE3_Desktop_Music_NoTracks");
	_listCtrl lbSetData [_index, ""];
};

_listCtrl setVariable ["AE3_computer", _computer];
_listCtrl ctrlAddEventHandler ["LBDblClick", {
	params ["_listCtrl", "_index"];

	private _sourcePath = _listCtrl lbData _index;
	if (_sourcePath isEqualTo "") exitWith {};

	private _computer = _listCtrl getVariable "AE3_computer";
	[_computer, _sourcePath, "auto", _listCtrl lbText _index] call AE3_desktop_fnc_audioPlayer;
}];

createHashMap
