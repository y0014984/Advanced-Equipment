// File: fnc_desktop_open.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Opens the AE3 desktop (GUI interface) for a laptop. Claims the computer mutex,
 * pulls the filesystem from the server, shows a static lock screen on the laptop texture for
 * other players (zero ongoing sync traffic) and builds the desktop UI with app icons.
 * Must run in a scheduled environment (uses getRemoteVar).
 *
 * Arguments:
 * 0: _computer <OBJECT> - The laptop
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop] spawn AE3_desktop_fnc_desktop_open;
 *
 * Public: Yes
 */

params ["_computer"];

if (!hasInterface) exitWith {};

// Pull server-side state (scheduled environment required)
[_computer] call AE3_filesystem_fnc_device_pull;
[_computer, "AE3_filepointer"] call AE3_main_fnc_getRemoteVar;
[_computer, "AE3_Userlist"] call AE3_main_fnc_getRemoteVar;

// Static "in use" screen for everyone while the desktop is open (spectators see no live GUI)
_computer setObjectTextureGlobal [1, "#(argb,8,8,3)color(0.05,0.08,0.12,1,co)"];

[_computer, "inUse", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];

private _ok = createDialog "AE3_Desktop_Display";
if (!_ok) exitWith
{
	_computer setVariable ["AE3_computer_mutex", objNull, true];
	_computer setVariable ["AE3_filesystem_syncedBy", objNull, true];
	hint localize "STR_AE3_ArmaOS_Exception_DialogFailed";
};

private _display = findDisplay 17000;
_display setVariable ["AE3_computer", _computer];

private _theme = [_computer] call AE3_desktop_fnc_wm_getTheme;

// Session state (operator client only - no network traffic)
private _session = createHashMapFromArray [
	["computer", _computer],
	["display", _display],
	["windows", createHashMap],
	["nextWinId", 0],
	["theme", _theme],
	["drag", []]
];
uiNamespace setVariable ["AE3_desktop_session", _session];

/* ---------------------------------------- */
/* Theme */

(_display displayCtrl 17001) ctrlSetBackgroundColor (_theme get "wallpaper");
(_display displayCtrl 17002) ctrlSetBackgroundColor (_theme get "panel");
(_display displayCtrl 17003) ctrlSetTextColor (_theme get "text");
(_display displayCtrl 17004) ctrlSetTextColor (_theme get "text");

(_display displayCtrl 17003) ctrlSetText ([dayTime, "HH:MM"] call BIS_fnc_timeToString);
(_display displayCtrl 17004) ctrlSetText format ["%1  |  %2",
	([_computer] call AE3_armaos_fnc_computer_getHostname),
	[_computer getVariable ["AE3_network_address", [127, 0, 0, 1]]] call AE3_network_fnc_ip2str
];

(_display displayCtrl 17003) ctrlSetFont (_theme getOrDefault ["font", "RobotoCondensed"]);
(_display displayCtrl 17004) ctrlSetFont (_theme getOrDefault ["font", "RobotoCondensed"]);

/* ---------------------------------------- */
/* Wallpaper texture (per-laptop selection; falls back to the theme color) */

private _wallpaperTex = _computer getVariable ["AE3_desktopWallpaper", ""];
if (_wallpaperTex isNotEqualTo "") then
{
	private _wp = _display ctrlCreate ["RscPicture", -1];
	_wp ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW, safeZoneH];
	_wp ctrlSetText _wallpaperTex;
	_wp ctrlCommit 0;
};

/* ---------------------------------------- */
/* Desktop icons */

private _apps = [] call AE3_desktop_fnc_app_list;
private _iconIndex = 0;

{
	_x params ["_className", "_displayName", "", "", "", "_showOnDesktop"];

	if (_showOnDesktop) then
	{
		private _icon = _display ctrlCreate ["RscButton", -1];
		_icon ctrlSetPosition [
			safeZoneX + 0.015 + 0.13 * floor (_iconIndex / 8),
			safeZoneY + 0.03 + 0.065 * (_iconIndex mod 8),
			0.12,
			0.05
		];
		_icon ctrlSetText _displayName;
		_icon ctrlSetBackgroundColor (_theme get "titlebar");
		_icon ctrlSetTextColor (_theme get "text");
		_icon ctrlCommit 0;

		_icon setVariable ["AE3_appClass", _className];
		_icon ctrlAddEventHandler ["ButtonClick", {
			params ["_button"];
			[_button getVariable "AE3_appClass"] call AE3_desktop_fnc_wm_createWindow;
		}];

		_iconIndex = _iconIndex + 1;
	};
} forEach _apps;

/* ---------------------------------------- */
/* Window dragging (display-level mouse handlers; the titlebar only starts the drag) */

_display displayAddEventHandler ["MouseMoving", {
	params ["", "_xPos", "_yPos"];

	private _session = uiNamespace getVariable ["AE3_desktop_session", createHashMap];
	private _drag = _session getOrDefault ["drag", []];
	if (_drag isEqualTo []) exitWith {};

	_drag params ["_group", "_dx", "_dy"];
	private _pos = ctrlPosition _group;
	private _w = _pos select 2;
	private _h = _pos select 3;

	private _newX = _xPos - _dx;
	private _newY = _yPos - _dy;

	// Clamp so the titlebar always stays reachable on-screen: keep a slice of the window
	// inside the safezone horizontally and never let the titlebar leave the top/bottom edges.
	private _minVisible = 0.08;
	_newX = (_newX max (safeZoneX - _w + _minVisible)) min (safeZoneX + safeZoneW - _minVisible);
	_newY = (_newY max safeZoneY) min (safeZoneY + safeZoneH - 0.04);

	_group ctrlSetPosition [_newX, _newY, _w, _h];
	_group ctrlCommit 0;
}];

_display displayAddEventHandler ["MouseButtonUp", {
	private _session = uiNamespace getVariable ["AE3_desktop_session", createHashMap];
	_session set ["drag", []];
}];

/* ---------------------------------------- */
/* Restore the previous session: re-open the windows the last user left open */

{
	_x params [["_appClass", ""], ["_pos", []], ["_stateData", []]];
	if (_appClass isNotEqualTo "") then
	{
		[_appClass, _stateData, _pos] call AE3_desktop_fnc_wm_createWindow;
	};
} forEach (_computer getVariable ["AE3_desktopState", []]);
