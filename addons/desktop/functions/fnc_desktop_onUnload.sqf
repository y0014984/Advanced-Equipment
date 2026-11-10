// File: fnc_desktop_onUnload.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Unload handler of the desktop display: runs app onClose callbacks, pushes the
 * filesystem back to the server, releases the mutex and restores the laptop screen texture.
 *
 * Arguments:
 * 0: _display <DISPLAY> - The desktop display
 * 1: _exitCode <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * Wired via the AE3_Desktop_Display config (onUnload).
 *
 * Public: No
 */

params ["_display", "_exitCode"];

private _session = uiNamespace getVariable ["AE3_desktop_session", createHashMap];
private _computer = _session getOrDefault ["computer", objNull];

// Persist the session: open windows, their positions and app state (open paths, urls,
// unsaved notes, ...) so the next user finds the laptop exactly as it was left
private _desktopState = [];
{
	private _callbacks = _y getOrDefault ["callbacks", createHashMap];
	private _group = _y getOrDefault ["group", controlNull];

	private _stateData = _callbacks call (_callbacks getOrDefault ["getState", { nil }]);
	if (isNil "_stateData") then { _stateData = []; };

	private _pos = if (isNull _group) then { [] } else { (ctrlPosition _group) select [0, 2] };

	_desktopState pushBack [_y getOrDefault ["app", ""], _pos, _stateData];
} forEach (_session getOrDefault ["windows", createHashMap]);

if (!isNull _computer) then
{
	_computer setVariable ["AE3_desktopState", _desktopState, true];
};

// Run app close callbacks and remove any per-frame handlers the apps registered
{
	private _callbacks = _y getOrDefault ["callbacks", createHashMap];
	private _onClose = _callbacks getOrDefault ["onClose", {}];
	[_x, _computer] call _onClose;

	private _pfh = _callbacks getOrDefault ["pfh", -1];
	if (_pfh >= 0) then { [_pfh] call CBA_fnc_removePerFrameHandler; };
} forEach (_session getOrDefault ["windows", createHashMap]);

uiNamespace setVariable ["AE3_desktop_session", nil];

if (isNull _computer) exitWith {};

// Push filesystem changes back to the server
private _filesystem = _computer getVariable ["AE3_filesystem", nil];
if (!isNil "_filesystem" && {[_computer] call AE3_filesystem_fnc_device_isSynced}) then
{
	_computer setVariable ["AE3_filesystem", _filesystem, 2];
};
_computer setVariable ["AE3_filepointer", _computer getVariable ["AE3_filepointer", []], 2];

// Restore the running screen texture (GUI idle image) and release the laptop
_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_PowerOn.paa"];
_computer setVariable ["AE3_computer_mutex", objNull, true];
_computer setVariable ["AE3_filesystem_syncedBy", objNull, true];

[_computer, "inUse", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
