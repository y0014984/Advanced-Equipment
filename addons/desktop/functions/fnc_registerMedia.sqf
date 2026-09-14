// File: fnc_registerMedia.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Registers a media file (image/video/audio shipped in a mod or the mission) so
 * it can be opened on laptops via the Files app or 'cat'. Creates a marker file in the target
 * laptops' filesystems ("AE3_MEDIA|<type>|<scope>|<web>|<source path>"). Server-side; routed
 * from clients. JIP-safe: the registry and filesystems live on the server.
 *
 * Targets:
 * - ARRAY of laptop objects: only those laptops
 * - "all": every initialized AE3 computer
 * - "future": every computer that initializes from now on (plus all current ones)
 *
 * Arguments:
 * 0: _sourcePath <STRING> - Real path of the media file (e.g. "\myMod\video\intel.ogv")
 * 1: _type <STRING> - "image", "video" or "audio"
 * 2: _fsDest <STRING> - Virtual filesystem destination (e.g. "/home/user/intel.ogv")
 * 3: _targets <ARRAY|STRING> (Optional, default: "all") - See above
 * 4: _scope <STRING> (Optional, default: "auto") - Path origin hint: "mod", "mission" or "auto"
 * 5: _web <BOOL> (Optional, default: false) - Images open in the native viewer by default; set true
 *    to (experimentally) try the in-OS web viewer first, falling back to native if it cannot render
 *
 * Return Value:
 * None
 *
 * Example:
 * ["\a3\missions_f\video\a_in.ogv", "video", "/home/user/intel.ogv", "all"] call AE3_desktop_fnc_registerMedia;
 *
 * Public: Yes
 */

params ["_sourcePath", "_type", "_fsDest", ["_targets", "all"], ["_scope", "auto"], ["_web", false]];

// Canonicalise the source path: Arma textures/videos use backslash separators. Normalising once here
// keeps the native viewer, the web viewer and any persisted window state in agreement.
_sourcePath = (trim _sourcePath) splitString "/" joinString "\";

_type = toLower _type;

// Correct the media type from the file extension when it clearly disagrees with the caller's choice.
// The module's type combo defaults to "image"; a curator who adds an audio/video file without changing
// it would otherwise store an audio clip as an image, which the native image viewer then hands to the
// engine texture loader - an unsupported format there fails hard. Deriving the type from a recognised
// extension keeps such files pointed at the correct player. Unknown extensions keep the caller's type.
private _parts = _sourcePath splitString ".";
private _ext = toLower (_parts param [(count _parts) - 1, ""]);
private _extType = switch (true) do
{
	case (_ext in ["ogg", "mp3", "wav", "flac", "wss", "og8"]): { "audio" };
	case (_ext in ["ogv", "mp4", "webm", "avi", "wmv", "mov"]): { "video" };
	case (_ext in ["paa", "jpg", "jpeg", "png", "gif", "bmp", "tga"]): { "image" };
	default { "" };
};
if (_extType isNotEqualTo "" && _extType isNotEqualTo _type) then { _type = _extType; };

// Normalise the origin hint and the experimental web-viewer flag so the marker is always well formed.
_scope = toLower _scope;
if !(_scope in ["mod", "mission"]) then { _scope = "auto"; };
_web = _web isEqualTo true;

if (!isServer) exitWith
{
	["ae3_desktop_registerMedia", [_sourcePath, _type, _fsDest, _targets, _scope, _web]] call CBA_fnc_serverEvent;
};

private _marker = format ["AE3_MEDIA|%1|%2|%3|%4", toLower _type, _scope, ["0", "1"] select _web, _sourcePath];

// Registered images double as selectable desktop wallpapers (Settings app)
if ((toLower _type) isEqualTo "image") then
{
	private _wallpapers = missionNamespace getVariable ["AE3_Desktop_WallpaperList", []];
	_wallpapers pushBackUnique _sourcePath;
	missionNamespace setVariable ["AE3_Desktop_WallpaperList", _wallpapers, true];
};

private _computers = [];

switch (true) do
{
	case (_targets isEqualType []):
	{
		_computers = _targets;
	};
	case (_targets isEqualTo "all"):
	{
		_computers = +(missionNamespace getVariable ["ae3_desktop_computers", []]);
	};
	case (_targets isEqualTo "future"):
	{
		_computers = +(missionNamespace getVariable ["ae3_desktop_computers", []]);
		ae3_desktop_pendingMedia pushBack [_sourcePath, _type, _fsDest, _scope, _web];
	};
	default
	{
		private _targetObject = objectFromNetId _targets;
		if (!isNull _targetObject) then { _computers = [_targetObject]; };
	};
};

{
	if (!isNull _x && {_x getVariable ["AE3_cap_hasFilesystem", false]}) then
	{
		// Overwrite any existing (case-insensitive) file at the destination so re-placing media replaces it.
		[_x, _fsDest, _marker, false, "root", [[true, true, false], [true, false, false]], false, "caesar", "1", true] call AE3_filesystem_fnc_device_addFile;
	};
} forEach _computers;

INFO_3("Registered media %1 -> %2 on %3 computer(s)",_sourcePath,_fsDest,count _computers);
if (AE3_DebugMode) then { diag_log format ["[AE3 DEBUG] [%1] registerMedia: type=%2 scope=%3 web=%4 marker=%5", time, toLower _type, _scope, _web, _marker]; };
