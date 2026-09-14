// File: fnc_desktop_openWeb.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: R1 spike (WS-B) - opens the fullscreen CEF web-browser desktop and loads the
 * HTML/JS UI. This is the foundation of the os-master-style GUI port; it is intentionally
 * standalone so the existing native desktop (AE3_desktop_fnc_desktop_open) keeps working until
 * the web port reaches parity. Loads ui\web\index.html into a type-106 browser control and
 * routes JS->SQF messages through AE3_desktop_fnc_jsRouter. Client-only.
 *
 * Arguments:
 * 0: _computer <OBJECT> (Optional, default: objNull) - The laptop this session is bound to
 *
 * Return Value:
 * The created display <DISPLAY>
 *
 * Example:
 * [_laptop] call AE3_desktop_fnc_desktop_openWeb;
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]]];

if (!hasInterface) exitWith { displayNull };

// Convenience for debug-console testing: bind the AE3 device under the cursor if none given.
if (isNull _computer) then {
    private _cur = cursorObject;
    if (!isNull _cur && {isClass (configOf _cur >> "AE3_Device")}) then { _computer = _cur; };
};

private _display = (findDisplay 46) createDisplay "AE3_Desktop_BrowserDisplay";
if (isNull _display) exitWith { displayNull };

_display setVariable [QGVAR(computer), _computer];

// Apply the player's desktop size preference. The display class is fullscreen by default; the
// smaller options render it as a centred window (handy when using a laptop inside a vehicle).
// The setting reads back as nil until CBA has registered it, so the preference is normalised to a
// number first and only then compared - a desktop opened that early simply uses the fullscreen default.
private _sizeIdx = ["AE3_Desktop_Size"] call CBA_settings_fnc_get;
if (isNil "_sizeIdx") then { _sizeIdx = 0; };
if !(_sizeIdx isEqualType 0) then { _sizeIdx = 0; };
if (_sizeIdx > 0) then
{
	private _frac = [1, 0.85, 0.65, 0.45] select _sizeIdx;
	private _w = safeZoneW * _frac;
	private _h = safeZoneH * _frac;
	private _px = safeZoneX + (safeZoneW - _w) / 2;
	private _py = safeZoneY + (safeZoneH - _h) / 2;
	{
		private _ctrl = _display displayCtrl _x;
		_ctrl ctrlSetPosition [_px, _py, _w, _h];
		_ctrl ctrlCommit 0;
	} forEach [17011, 1337];
};

// Pull the authoritative per-laptop state onto the laptop object (object-as-namespace), exactly
// as the native desktop does (AE3_desktop_fnc_desktop_open). The filesystem and userlist are
// server-only (initFilesystem / computer_addUser run with isServer), so the web login (authUser)
// and the Files/Notepad/Settings apps need the synced copy - pulling only in MP previously left
// module-added users unauthenticated and the filesystem "unavailable" on clients.
//
// This runs in a BACKGROUND spawn so the login screen paints immediately instead of waiting on
// several sequential server round-trips.
// Nothing downstream needs it to block: the login handler (jsRouter) re-pulls and waits
// authoritatively for the userlist before replying, and the Files app retries while the filesystem
// is still syncing. getRemoteVar is a no-op in SP (the server-local copy is already present).
// AE3_power_*/AE3_network_* are added so the Settings/System panel (fnc_sysInfo) shows real values
// on clients instead of defaults.
if (!isNull _computer) then {
    [_computer] spawn {
        params ["_computer"];
        // Safety net for a freshly placed laptop whose server-side init has not completed yet.
        [_computer] remoteExecCall ["AE3_armaos_fnc_device_ensureInit", 2];
        {
            [_computer, _x] call AE3_main_fnc_getRemoteVar;
        } forEach [
            "AE3_filesystem", "AE3_filepointer", "AE3_Userlist",
            "AE3_power_powerState", "AE3_power_internal",
            "AE3_network_parent", "AE3_network_address"
        ];
    };
};

// Claim the laptop and show the static "in use" screen for other players (mirrors native open). The
// laptop is remembered on the client as well: the claim is held by the player object, and a respawn hands
// this client a new one, so the release path needs a reference that outlives the unit that made it.
if (!isNull _computer) then {
    missionNamespace setVariable ["AE3_computer_session", _computer];
    _computer setVariable ["AE3_computer_mutex", player, true];
    _computer setObjectTextureGlobal [1, "#(argb,8,8,3)color(0.05,0.08,0.12,1,co)"];
    [_computer, "inUse", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
};

private _ctrl = _display displayCtrl 1337;
[_ctrl, ["LoadFile", "\z\ae3\addons\desktop\ui\web\index.html"]] call FUNC(browserAction);

// "JSDialog" (Arma 2.18+) is newer than HEMTT's event list; pass it as a variable so the
// unknown-event lint does not fire on a literal it cannot validate.
private _jsDialogEvent = "JSDialog";
_ctrl ctrlAddEventHandler [_jsDialogEvent, { _this call FUNC(jsRouter) }];

// Keep a handle so SQF->JS pushes (ExecJS) can find the live browser control.
uiNamespace setVariable [QGVAR(browserCtrl), _ctrl];

// ESC closes the spike display (fullscreen browser captures most other input).
_display displayAddEventHandler ["KeyDown", {
    params ["_dsp", "_key"];
    if (_key == 1) exitWith { _dsp closeDisplay 0; true }; // DIK_ESCAPE
    false
}];

_display
